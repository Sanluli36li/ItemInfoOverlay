local ADDON_NAME, ItemInfoOverlay = ...

local Module = ItemInfoOverlay:NewModule("itemInfoOverlay")
local Utils = ItemInfoOverlay:GetModule("utils")
local L = ItemInfoOverlay.Locale
local SharedMedia = LibStub("LibSharedMedia-3.0")



local CONFIG_ITEM_LEVEL = "itemLevel.enable"
local CONFIG_ITEM_LEVEL_POINT = "itemLevel.point"
local CONFIG_ITEM_LEVEL_FONT = "itemLevel.font"
local CONFIG_ITEM_LEVEL_FONT_SIZE = "itemLevel.fontSize"
local CONFIG_ITEM_TYPE = "itemType.enable"
local CONFIG_ITEM_TYPE_POINT = "itemType.point"
local CONFIG_ITEM_TYPE_FONT = "itemType.font"
local CONFIG_ITEM_TYPE_FONT_SIZE = "itemType.fontSize"
local CONFIG_BONDING_TYPE = "bondingType.enable"
local CONFIG_BONDING_TYPE_ANCHOR_TO_ICON = "bondingType.anchorToIcon"
local CONFIG_BONDING_TYPE_POINT = "bondingType.point"
local CONFIG_BONDING_TYPE_FONT = "bondingType.font"
local CONFIG_BONDING_TYPE_FONT_SIZE = "bondingType.fontSize"

local POINT_ITEM_LEVEL_ON_ICON = {"TOP", "TOP", 0, -2}
local POINT_ITEM_TYPE_ON_ICON = {"BOTTOM", "BOTTOM", 0, 2}
local POINT_SOCKET_ON_ICON = {"BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0}

local itemInfoOverlayPoor = {}

local POINTS = {
    "TOPLEFT",
    "TOP",
    "TOPRIGHT",
    "LEFT",
    "CENTER",
    "RIGHT",
    "BOTTOMLEFT",
    "BOTTOM",
    "BOTTOMRIGHT"
}

local POINTS_JUSTIFY_H = {
    "LEFT",
    "CENTER",
    "RIGHT",
    "LEFT",
    "CENTER",
    "RIGHT",
    "LEFT",
    "CENTER",
    "RIGHT"
}

local POINTS_BONDING_TYPE_ANCHOR_TO_ITEMLEVEL = {
    {"TOPLEFT", "BOTTOMLEFT", -1},
    {"TOP", "BOTTOM", -1},
    {"TOPRIGHT", "BOTTOMRIGHT", -1},
    {"TOPLEFT", "BOTTOMLEFT", -1},
    {"TOP", "BOTTOM", -1},
    {"TOPRIGHT", "BOTTOMRIGHT", -1},
    {"BOTTOMLEFT", "TOPLEFT", 1},
    {"BOTTOM", "TOP", -1},
    {"BOTTOMRIGHT", "TOPRIGHT", -1},
}

--------------------
-- Mixin
--------------------
SanluliItemInfoOverlayMixin = {}

function SanluliItemInfoOverlayMixin:UpdateAppearance()
    self.ItemLevel:SetFont(Module:GetConfig(CONFIG_ITEM_LEVEL_FONT), Module:GetConfig(CONFIG_ITEM_LEVEL_FONT_SIZE), "OUTLINE")
    self.ItemLevel:ClearAllPoints()
    self.ItemLevel:SetPoint(POINTS[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)])

    self.BondingType:SetFont(Module:GetConfig(CONFIG_BONDING_TYPE_FONT), Module:GetConfig(CONFIG_BONDING_TYPE_FONT_SIZE), "OUTLINE")
    if Module:GetConfig(CONFIG_BONDING_TYPE_ANCHOR_TO_ICON) then
        self.BondingType:ClearAllPoints()
        self.BondingType:SetPoint(POINTS[Module:GetConfig(CONFIG_BONDING_TYPE_POINT)])
    else
        self.BondingType:ClearAllPoints()
        self.BondingType:SetPoint(
            POINTS_BONDING_TYPE_ANCHOR_TO_ITEMLEVEL[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)][1],
            self.ItemLevel,
            POINTS_BONDING_TYPE_ANCHOR_TO_ITEMLEVEL[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)][2],
            0,
            POINTS_BONDING_TYPE_ANCHOR_TO_ITEMLEVEL[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)][3]
        )
    end

    self.ItemType:SetFont(Module:GetConfig(CONFIG_ITEM_TYPE_FONT), Module:GetConfig(CONFIG_ITEM_TYPE_FONT_SIZE), "OUTLINE")
    self.ItemType:SetJustifyH(POINTS_JUSTIFY_H[Module:GetConfig(CONFIG_ITEM_TYPE_POINT)])
    self.ItemType:ClearAllPoints()
    self.ItemType:SetPoint(POINTS[Module:GetConfig(CONFIG_ITEM_TYPE_POINT)])

    if self:IsVisible() then
        self:Refresh()
    end
end

function SanluliItemInfoOverlayMixin:SetItemData(itemLevel, itemLink, tooltipInfo)
    local itemLevelText
    local itemTypeText
    local itemBondingText

    local type, id = Utils:GetLinkTypeAndID(itemLink)

    if type == "item" then
        local itemName, _, itemQuality, _, _, itemType, itemSubType,
        itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
        expacID, setID, isCraftingReagent = C_Item.GetItemInfo(itemLink)

        local bonding, spellKnown
        if tooltipInfo and tooltipInfo.type == Enum.TooltipDataType.Item and tooltipInfo.lines then
            for _, line in ipairs(tooltipInfo.lines) do
                if line.type == Enum.TooltipDataLineType.ItemBinding then
                    -- 物品绑定类型
                    bonding = line.bonding
                elseif line.type == Enum.TooltipDataLineType.RestrictedSpellKnown then
                    -- 已经学会
                    spellKnown = true
                end
            end
        end

        if classID == Enum.ItemClass.Weapon or classID == Enum.ItemClass.Armor or classID == Enum.ItemClass.Profession then
            if itemLevel and itemLevel > 1 then
                -- 物品等级为1的装备不显示, 如此可以过滤掉大部分的衬衣和战袍
                local r, g, b = C_Item.GetItemQualityColor(itemQuality)

                itemLevelText = format("|cff%02x%02x%02x%d|r", r * 255, g * 255, b * 255, itemLevel)
            end
            -- 装备部位
            if classID == Enum.ItemClass.Armor then
                -- 护甲
                if subclassID == Enum.ItemArmorSubclass.Shield then
                    -- 护甲->盾牌: 盾牌
                    itemTypeText = itemSubType
                else
                    -- 其他: 护甲类型和装备栏位
                    itemTypeText = _G[itemEquipLoc]
                end
            else
                itemTypeText = itemSubType
            end
        elseif classID == Enum.ItemClass.Reagent and subclassID == Enum.ItemReagentSubclass.ContextToken then
            -- 珍玩 套装兑换物(以及暗影国度的武器兑换物)
            local r, g, b = C_Item.GetItemQualityColor(itemQuality)

            itemLevelText = format("|cff%02x%02x%02x%d|r", r * 255, g * 255, b * 255, itemLevel)
        elseif classID == Enum.ItemClass.Recipe then
            -- 配方
            if itemStackCount == 1 then
                itemTypeText = itemSubType
            end
        elseif C_ToyBox.GetToyInfo(id) then
            -- 玩具
            if PlayerHasToy(id) then
                itemTypeText = "|cff00ff00"..TOY.."|r"
            else
                itemTypeText = TOY
            end
        elseif classID == Enum.ItemClass.Miscellaneous then
            if subclassID == Enum.ItemMiscellaneousSubclass.Junk and itemQuality >= Enum.ItemQuality.Epic and itemLevel and itemLevel > 1 and itemStackCount then
                -- 史诗品质垃圾 且只能堆叠一个 且物品等级大于1: 大概率是套装兑换物 显示装等
                local r, g, b = C_Item.GetItemQualityColor(itemQuality)

                itemLevelText = format("|cff%02x%02x%02x%d|r", r * 255, g * 255, b * 255, itemLevel)
            elseif subclassID == Enum.ItemMiscellaneousSubclass.CompanionPet then
                -- 战斗宠物
                itemTypeText = PET
            elseif subclassID == Enum.ItemMiscellaneousSubclass.Mount then
                -- 坐骑
                itemTypeText = itemSubType
            end
        elseif C_Item.IsItemKeystoneByID(id) then
            -- 史诗钥石 (偶尔有物品形式的：比如队友拾取的)
            local _, itemID, mapID, level, affix1, affix2, affix3, affix4 = strsplit(":", itemLink)
            local r, g, b = C_ChallengeMode.GetKeystoneLevelRarityColor(level):GetRGB()
            itemLevelText = format("|cff%02x%02x%02x+%d|r", r * 255, g * 255, b * 255, level)
        end

        if bonding == Enum.TooltipDataItemBinding.Account or bonding == Enum.TooltipDataItemBinding.BindToBnetAccount then
            itemBondingText = "|cff00ccff"..L["itemInfoOverlay.bonding.btw"].."|r"
        elseif bonding == Enum.TooltipDataItemBinding.BindOnEquip and classID ~= Enum.ItemClass.Recipe then
            itemBondingText = "|cffffffff"..L["itemInfoOverlay.bonding.boe"] .."|r"
        elseif bonding == Enum.TooltipDataItemBinding.AccountUntilEquipped or bonding == Enum.TooltipDataItemBinding.BindToAccountUntilEquipped then
            itemBondingText = "|cff00ccff"..L["itemInfoOverlay.bonding.wue"] .."|r"
        end

        if spellKnown and itemTypeText then
            itemTypeText = "|cff00ff00"..itemTypeText.."|r"
        end

    elseif type == "keystone" then
        -- 史诗钥石
        local _, itemID, mapID, level, affix1, affix2, affix3, affix4 = strsplit(":", itemLink)
        local r, g, b = C_ChallengeMode.GetKeystoneLevelRarityColor(level):GetRGB()
        itemLevelText = format("|cff%02x%02x%02x+%d|r", r * 255, g * 255, b * 255, level)
    elseif type == "battlepet" then
        itemTypeText = PET
    end

    

    if Module:GetConfig(CONFIG_ITEM_LEVEL) and itemLevelText then
        self.ItemLevel:SetText(itemLevelText)
        self.ItemLevel:Show()
    else
        self.ItemLevel:SetText()
        self.ItemLevel:Hide()
    end

    if Module:GetConfig(CONFIG_ITEM_TYPE) and itemTypeText then
        if IsCosmeticItem(itemLink) then
            itemTypeText = "|cffff80ff"..itemTypeText.."|r"
        end

        self.ItemType:SetTextToFit(L["itemInfoOverlay.itemType.replacer"](itemTypeText))
        self.ItemType:Show()

        if self.ItemType:GetUnboundedStringWidth() >= 50 then
            self.ItemType:SetWidth(50)
        end
    else
        self.ItemType:Hide()
    end

    if Module:GetConfig(CONFIG_BONDING_TYPE) and itemBondingText then
        self.BondingType:SetText(itemBondingText)
        self.BondingType:Show()
    else
        self.BondingType:Hide()
    end

    self:Show()
end

function SanluliItemInfoOverlayMixin:SetItemFromLocation(itemLocation)
    self.itemLocation = itemLocation
    self.itemLink = nil

    if itemLocation and itemLocation:IsValid() then
        local itemLink = C_Item.GetItemLink(itemLocation)

        local tooltipInfo
        if itemLocation:IsBagAndSlot() then
            tooltipInfo = C_TooltipInfo.GetBagItem(itemLocation:GetBagAndSlot())
        elseif itemLocation:IsEquipmentSlot() then
            tooltipInfo = C_TooltipInfo.GetInventoryItem("player", itemLocation:GetEquipmentSlot())
        else
            tooltipInfo = C_TooltipInfo.GetHyperlink(itemLink)
        end

        local itemLevel = C_Item.GetCurrentItemLevel(itemLocation)

        self:SetItemData(itemLevel, itemLink, tooltipInfo)

        return itemLevel, itemLink, tooltipInfo
    else
        self:Hide()
    end
end

function SanluliItemInfoOverlayMixin:SetItemFromLink(itemLink)
    if itemLink then
        self.itemLocation = nil
        self.itemLink = itemLink

        local tooltipInfo = C_TooltipInfo.GetHyperlink(itemLink)

        local itemLevel = Utils:GetItemLevelFromTooltipInfo(tooltipInfo) or GetDetailedItemLevelInfo(itemLink)

        self:SetItemData(itemLevel, itemLink, tooltipInfo)

        return itemLevel, itemLink, tooltipInfo
    else
        self:Hide()
    end
end

function SanluliItemInfoOverlayMixin:Clear()
    self.itemLocation = nil
    self.itemLink = nil
    self:Hide()
end

function SanluliItemInfoOverlayMixin:Refresh()
    if self.itemLocation then
        self:SetItemFromLocation(self.itemLocation)
    elseif self.itemLink then
        self:SetItemFromLink(self.itemLink)
    else
        self:Hide()
    end
end

SanluliItemInfoOverlaySettingPriviewMixin = {}

function SanluliItemInfoOverlaySettingPriviewMixin:OnLoad()
    self.itemButton1:SetItemButtonTexture(6035288)
    self.itemButton1:SetItemButtonQuality(Enum.ItemQuality.Epic)
    local overlay1 = Module:CreateItemInfoOverlay(self.itemButton1)
    local testItem1 = Item:CreateFromItemID(220202)
    testItem1:ContinueOnItemLoad(function()
        overlay1:SetItemFromLink("|cffa335ee|Hitem:220202::::::::80:102::6:6:6652:10356:10299:1540:10255:11215:1:28:2462::::|h[间谍大师裹网]|h|r")
    end)

    self.itemButton2:SetItemButtonTexture(4672195)
    self.itemButton2:SetItemButtonQuality(Enum.ItemQuality.Rare)
    self.itemButton2:SetItemButtonCount(100)
    local overlay2 = Module:CreateItemInfoOverlay(self.itemButton2)
    local testItem2 = Item:CreateFromItemID(222776)
    testItem2:ContinueOnItemLoad(function()
        overlay2:SetItemFromLink("|cff0070dd|Hitem:222776::::::::80:102:::::::::|h[丰盛的贝雷达尔之慷]|h|r")
    end)
end

--------------------
-- 
--------------------

function Module:CreateItemInfoOverlay(frame)
    frame.ItemInfoOverlay = CreateFrame("Frame", nil, frame, "SanluliItemInfoOverlayTemplate")

    local overlay = frame.ItemInfoOverlay

    tinsert(itemInfoOverlayPoor, overlay)

    if frame.IconOverlay then
        overlay:SetAllPoints(frame.IconOverlay)
    else
        overlay:SetAllPoints(frame)
    end

    overlay:UpdateAppearance()

    return overlay
end

function Module:UpdateAllAppearance()
    for i, overlay in ipairs(itemInfoOverlayPoor) do
        overlay:UpdateAppearance()
    end
end

--------------------
-- 暴雪函数安全钩子
--------------------

hooksecurefunc("SetItemButtonQuality", function(button, quality, itemIDOrLink, suppressOverlays, isBound)
    if button and button.SetItemButtonQuality then
        -- 跳过带有ItemButtonMixin等带有此函数的类型 防止重复操作
        return
    elseif itemIDOrLink then
        if tonumber(itemIDOrLink) then
        else
            -- 能直接获取到物品链接
            Utils:GetItemInfoOverlay(button):SetItemFromLink(itemIDOrLink)
            return
        end
    end
    Utils:GetItemInfoOverlay(button):Hide()
end)

hooksecurefunc(ItemButtonMixin, "SetItemButtonQuality", function (button, quality, itemIDOrLink, suppressOverlays, isBound)
    if button.GetItemLocation and button:GetItemLocation() and button:GetItemLocation():IsValid() then
        -- 背包、材料背包、银行背包、战团银行
        Utils:GetItemInfoOverlay(button):SetItemFromLocation(button:GetItemLocation())
        return
    elseif button.location then
        -- 装备栏快捷更换按钮
        local player, bank, bags, voidStorage, slot, bag, tab, voidSlot = EquipmentManager_UnpackLocation(button.location)
        if bags then
            -- 背包中的物品
            Utils:GetItemInfoOverlay(button):SetItemFromLocation(ItemLocation:CreateFromBagAndSlot(bag, slot))
            return
        elseif player then
            -- 玩家物品栏
            Utils:GetItemInfoOverlay(button):SetItemFromLocation(ItemLocation:CreateFromEquipmentSlot(slot))
            return
        end
    end

    if itemIDOrLink then
        if tonumber(itemIDOrLink) then
        else
            -- 能直接获取到物品链接
            Utils:GetItemInfoOverlay(button):SetItemFromLink(itemIDOrLink)
            return
        end
    end
    Utils:GetItemInfoOverlay(button):Hide()
end)

hooksecurefunc("MerchantFrameItem_UpdateQuality", function(button, link, isBound)
    -- 商人界面
    Utils:GetItemInfoOverlay(button.ItemButton):SetItemFromLink(link)
end)
--[[
hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
    -- 装备栏/专业装备栏
    local slot = button:GetID()
    Utils:GetItemInfoOverlay(button):SetItemFromLocation(ItemLocation:CreateFromEquipmentSlot(slot))
end)
]]
hooksecurefunc("BankFrameItemButton_Update", function(button)
    -- 银行/材料银行
    local bag = button:GetParent():GetID()
    local slot = button:GetID()
    Utils:GetItemInfoOverlay(button):SetItemFromLocation(ItemLocation:CreateFromBagAndSlot(bag, slot))
end)

function Module:AfterStartup()
    if NDui then
        -- NDui整合背包 https://ngabbs.com/read.php?tid=5483616
        hooksecurefunc(NDui.cargBags:GetImplementation("NDui_Backpack"):GetItemButtonClass(), "OnUpdateButton", function(button, item)
            local bag = item.bagId
            local slot = item.slotId
            Utils:GetItemInfoOverlay(button):SetItemFromLocation(ItemLocation:CreateFromBagAndSlot(bag, slot))
        end)
    end

    if NDui_Bags then
        -- NDui整合背包 独立插件版 https://ngabbs.com/read.php?tid=34318074
        hooksecurefunc(NDui_Bags.cargBags:GetImplementation("NDui_Backpack"):GetItemButtonClass(), "OnUpdateButton", function(button, item)
            local bag = item.bagId
            local slot = item.slotId
            Utils:GetItemInfoOverlay(button):SetItemFromLocation(ItemLocation:CreateFromBagAndSlot(bag, slot))
        end)
    end
end

