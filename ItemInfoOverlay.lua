local ADDON_NAME, ItemInfoOverlay = ...

local Module = ItemInfoOverlay:NewModule("itemInfoOverlay")
local L = ItemInfoOverlay.Locale
local SharedMedia = LibStub("LibSharedMedia-3.0")

local CONFIG_ITEM_LEVEL = "itemLevel.enable"
local CONFIG_ITEM_LEVEL_FONT = "itemLevel.font"
local CONFIG_ITEM_LEVEL_FONT_SIZE = "itemLevel.fontSize"
local CONFIG_ITEM_TYPE = "itemType.enable"
local CONFIG_ITEM_TYPE_FONT = "itemType.font"
local CONFIG_ITEM_TYPE_FONT_SIZE = "itemType.fontSize"
local CONFIG_BONDING_TYPE = "bondingType.enable"
local CONFIG_BONDING_TYPE_FONT = "bondingType.font"
local CONFIG_BONDING_TYPE_FONT_SIZE = "bondingType.fontSize"

local POINT_ITEM_LEVEL_ON_ICON = {"TOP", "TOP", 0, -2}
local POINT_ITEM_TYPE_ON_ICON = {"BOTTOM", "BOTTOM", 0, 2}
local POINT_SOCKET_ON_ICON = {"BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0}

local itemInfoOverlayPoor = {}


--------------------
-- Mixin
--------------------
SanluliItemInfoOverlayMixin = {}

function SanluliItemInfoOverlayMixin:UpdateAppearance()
    self.ItemLevel:SetFont(Module:GetConfig(CONFIG_ITEM_LEVEL_FONT), Module:GetConfig(CONFIG_ITEM_LEVEL_FONT_SIZE), "OUTLINE")
    self.BondingType:SetFont(Module:GetConfig(CONFIG_BONDING_TYPE_FONT), Module:GetConfig(CONFIG_BONDING_TYPE_FONT_SIZE), "OUTLINE")
    self.ItemType:SetFont(Module:GetConfig(CONFIG_ITEM_TYPE_FONT), Module:GetConfig(CONFIG_ITEM_TYPE_FONT_SIZE), "OUTLINE")
end

function SanluliItemInfoOverlayMixin:SetItem(itemLocation, itemLink)
    if itemLink or (itemLocation and itemLocation:IsValid()) then
        self:Show()
        local itemName, itemQuality, itemLevel, itemType, itemSubType,
            itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
            expacID, setID, isCraftingReagent
        local itemID
        local tooltipInfo

        if itemLocation and itemLocation:IsValid() then
            if not itemLink then
                itemLink = C_Item.GetItemLink(itemLocation)
            end

            itemLevel = C_Item.GetCurrentItemLevel(itemLocation)
            itemID = C_Item.GetItemID(itemLocation)
            
            if itemLocation:IsBagAndSlot() then
                tooltipInfo = C_TooltipInfo.GetBagItem(itemLocation:GetBagAndSlot())
            elseif itemLocation:IsEquipmentSlot() then
                tooltipInfo = C_TooltipInfo.GetInventoryItem("player", itemLocation:GetEquipmentSlot())
            end
        end

        if itemLink then
            if not itemLevel then
                itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
            end

            if not itemID then
                C_Item.GetItemIDForItemInfo(itemLink)
            end

            if not tooltipInfo then
                tooltipInfo = C_TooltipInfo.GetHyperlink(itemLink)
            end
        end

        local itemLevelText
        local itemTypeText
        local itemBondingText

        local bonding
        if tooltipInfo and tooltipInfo.type == Enum.TooltipDataType.Item and tooltipInfo.lines then
            for i, line in ipairs(tooltipInfo.lines) do
                if line.type == Enum.TooltipDataLineType.ItemBinding then
                    bonding = line.bonding
                end
            end
        end

        itemName, _, itemQuality, _, _, itemType, itemSubType,
        itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
        expacID, setID, isCraftingReagent = C_Item.GetItemInfo(itemLink)

        if classID == Enum.ItemClass.Weapon or classID == Enum.ItemClass.Armor or classID == Enum.ItemClass.Profession then
            if itemLevel > 1 then
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

            if bonding == 7 then
                itemBondingText = "|cffffffff"..L["itemInfoOverlay.bonding.boe"] .."|r"
            elseif bonding == 9 then
                itemBondingText = "|cff00ccff"..L["itemInfoOverlay.bonding.wue"] .."|r"
            end
        elseif classID == Enum.ItemClass.Miscellaneous and subclassID == Enum.ItemMiscellaneousSubclass.Junk and itemQuality >= Enum.ItemQuality.Epic then
            if itemLevel > 1 then
                -- 史诗品质垃圾 且只能堆叠一个 且物品等级大于1: 大概率是套装兑换物 显示装等
                local r, g, b = C_Item.GetItemQualityColor(itemQuality)

                itemLevelText = format("|cff%02x%02x%02x%d|r", r * 255, g * 255, b * 255, itemLevel)

                if bonding == 9 then
                    itemBondingText = "|cff00ccff"..L["itemInfoOverlay.bonding.wue"] .."|r"
                end
            end
        elseif classID == Enum.ItemClass.Reagent and subclassID == Enum.ItemReagentSubclass.ContextToken then
            -- 珍玩 套装兑换物(以及暗影国度的武器兑换物)
            local r, g, b = C_Item.GetItemQualityColor(itemQuality)

            itemLevelText = format("|cff%02x%02x%02x%d|r", r * 255, g * 255, b * 255, itemLevel)
        elseif classID == Enum.ItemClass.Recipe then
            itemTypeText = itemSubType
        elseif itemID and C_Item.IsItemKeystoneByID(itemID) then
            -- 史诗钥石
            local _, itemID, mapID, level, affix1, affix2, affix3, affix4 = strsplit(":", itemLink)
            local r, g, b = C_ChallengeMode.GetKeystoneLevelRarityColor(level):GetRGB()
            itemLevelText = format("|cff%02x%02x%02x+%d|r", r * 255, g * 255, b * 255, level)
        end

        if bonding == Enum.TooltipDataItemBinding.Account or bonding == Enum.TooltipDataItemBinding.BindToBnetAccount then
            itemBondingText = "|cff00ccff"..L["itemInfoOverlay.bonding.btw"].."|r"
        elseif bonding == Enum.TooltipDataItemBinding.BindOnEquip then
            itemBondingText = "|cffffffff"..L["itemInfoOverlay.bonding.boe"] .."|r"
        elseif bonding == Enum.TooltipDataItemBinding.AccountUntilEquipped or bonding == Enum.TooltipDataItemBinding.BindToAccountUntilEquipped then
            itemBondingText = "|cff00ccff"..L["itemInfoOverlay.bonding.wue"] .."|r"
        end

        if Module:GetConfig(CONFIG_ITEM_LEVEL) and itemLevelText then
            self.ItemLevel:SetText(itemLevelText)
            self.ItemLevel:Show()
        else
            self.ItemLevel:SetText()
            self.ItemLevel:Hide()
        end

        if itemStackCount == 1 and Module:GetConfig(CONFIG_ITEM_TYPE) and itemTypeText then
            self.ItemType:SetText(L["itemInfoOverlay.itemType.replacer"](itemTypeText))
            self.ItemType:Show()
        else
            self.ItemType:Hide()
        end

        if classID ~= Enum.ItemClass.Recipe and Module:GetConfig(CONFIG_BONDING_TYPE) and itemBondingText then
            self.BondingType:SetText(itemBondingText)
            self.BondingType:Show()
        else
            self.BondingType:Hide()
        end
    else
        self:Hide()
    end
end

--------------------
-- 
--------------------

local function CreateItemInfoOverlay(frame)
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

local function GetItemInfoOverlay(frame)
    if not frame.ItemInfoOverlay then
        return CreateItemInfoOverlay(frame)
    else
        return frame.ItemInfoOverlay
    end
end

function Module:UpdateAllAppearance()
    for i, overlay in ipairs(itemInfoOverlayPoor) do
        overlay:UpdateAppearance()
    end
end

--------------------
-- 暴雪函数安全钩子
--------------------
--[[
hooksecurefunc("SetItemButtonQuality", function(button, quality, itemIDOrLink, suppressOverlays, isBound)
    local name = button:GetName()

    if button.location then
        -- 装备栏快捷更换按钮
        local player, bank, bags, voidStorage, slot, bag, tab, voidSlot = EquipmentManager_UnpackLocation(button.location)
        if bags then
            -- 背包中的物品
            GetItemInfoOverlay(button):SetItem(ItemLocation:CreateFromBagAndSlot(bag, slot))
            return
        elseif player then
            -- 玩家物品栏
            GetItemInfoOverlay(button):SetItem(ItemLocation:CreateFromEquipmentSlot(slot))
            return
        end
    elseif button.GetItemLocation then
        -- 背包、材料背包、银行背包、战团银行
        GetItemInfoOverlay(button):SetItem(button:GetItemLocation())
        return
    elseif name then
        -- 基于按钮名字判断框体
        if strsub(name, 1, 24) == "VoidStorageStorageButton" then
            -- 虚空仓库物品按钮: 
            -- 已知问题: 通过物品链接获取物品信息时, 传家宝、军团再临传说物品的物品等级可能会有问题
            local tab = VoidStorageFrame.page
            local slot = button.slot
            GetItemInfoOverlay(button):SetItem(nil, GetVoidItemHyperlinkString((tab - 1)*80 + slot))
            return
        end
    end

    if itemIDOrLink then
        if tonumber(itemIDOrLink) then
        else
            -- 能直接获取到物品链接
            GetItemInfoOverlay(button):SetItem(nil, itemIDOrLink)
            return
        end
    end
    GetItemInfoOverlay(button):Hide()

end)
]]

hooksecurefunc(ItemButtonMixin, "SetItemButtonQuality", function (button, quality, itemIDOrLink, suppressOverlays, isBound)
    local name = button:GetName()

    if button.GetItemLocation and button:GetItemLocation() and button:GetItemLocation():IsValid() then
        -- 背包、材料背包、银行背包、战团银行
        GetItemInfoOverlay(button):SetItem(button:GetItemLocation())
        return
    elseif button.location then
        -- 装备栏快捷更换按钮
        local player, bank, bags, voidStorage, slot, bag, tab, voidSlot = EquipmentManager_UnpackLocation(button.location)
        if bags then
            -- 背包中的物品
            GetItemInfoOverlay(button):SetItem(ItemLocation:CreateFromBagAndSlot(bag, slot))
            return
        elseif player then
            -- 玩家物品栏
            GetItemInfoOverlay(button):SetItem(ItemLocation:CreateFromEquipmentSlot(slot))
            return
        end
    end

    if itemIDOrLink then
        if tonumber(itemIDOrLink) then
        else
            -- 能直接获取到物品链接
            GetItemInfoOverlay(button):SetItem(nil, itemIDOrLink)
            return
        end
    end
    GetItemInfoOverlay(button):Hide()
end)

hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
    -- 装备栏/专业装备栏
    local slot = button:GetID()
    GetItemInfoOverlay(button):SetItem(ItemLocation:CreateFromEquipmentSlot(slot))
end)

hooksecurefunc("BankFrameItemButton_Update", function(button)
    -- 银行/材料银行
    local bag = button:GetParent():GetID()
    local slot = button:GetID()
    GetItemInfoOverlay(button):SetItem(ItemLocation:CreateFromBagAndSlot(bag, slot))
end)