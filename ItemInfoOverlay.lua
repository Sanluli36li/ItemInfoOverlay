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
local CONFIG_EXTRA_INFO = "extraInfo.enable"
local CONFIG_EXTRA_INFO_ANCHOR_TO_ICON = "extraInfo.customAnchor"
local CONFIG_EXTRA_INFO_POINT = "extraInfo.point"
local CONFIG_EXTRA_INFO_FONT = "extraInfo.font"
local CONFIG_EXTRA_INFO_FONT_SIZE = "extraInfo.fontSize"
local CONFIG_EXTRA_INFO_BONDING_TYPE = "extraInfo.bondingType"
local CONFIG_EXTRA_INFO_PVP_ITEM_LEVEL = "extraInfo.pvpItemLevel"

local pool = CreateFramePool("Frame", UIParent, "IIOItemInfoOverlayTemplate")

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
IIOItemInfoOverlayMixin = {}

function IIOItemInfoOverlayMixin:UpdateAppearance()
    self.ItemLevel:SetFont(Module:GetConfig(CONFIG_ITEM_LEVEL_FONT), Module:GetConfig(CONFIG_ITEM_LEVEL_FONT_SIZE), "OUTLINE")
    self.ItemLevel:ClearAllPoints()
    self.ItemLevel:SetPoint(POINTS[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)])

    self.BondingType:SetFont(Module:GetConfig(CONFIG_EXTRA_INFO_FONT), Module:GetConfig(CONFIG_EXTRA_INFO_FONT_SIZE), "OUTLINE")
    if Module:GetConfig(CONFIG_EXTRA_INFO_ANCHOR_TO_ICON) then
        self.BondingType:ClearAllPoints()
        self.BondingType:SetPoint(POINTS[Module:GetConfig(CONFIG_EXTRA_INFO_POINT)])
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

    -- 由于数量庞大, 并且很多按钮在显示时会更新一次, 所以仅刷新显示中的图标, 防止修改设置时的卡顿
    if self.alwaysRefresh or self:IsVisible() then
        self:Refresh()
    end
end

function IIOItemInfoOverlayMixin:SetItemData(itemLink, tooltipInfo, itemLevel, pvpItemLevel)
    local itemLevelText
    local itemTypeText
    local itemBondingText

    local type, metaData, id, name = Utils.GetLinkTypeAndID(itemLink)

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
                itemLevelText = Utils.GetColoredItemLevelText(itemLevel, itemLink)
            end
            -- 装备部位
            if classID == Enum.ItemClass.Armor then
                -- 护甲
                if subclassID == Enum.ItemArmorSubclass.Shield then
                    -- 护甲->盾牌: 盾牌
                    itemTypeText = itemSubType
                else
                    -- 其他: 护甲类型和装备栏位
                    if Utils.IsPerferedArmorType(classID, subclassID, itemEquipLoc) then
                        itemTypeText = _G[itemEquipLoc]
                    else
                        itemTypeText = "|cffff0000".._G[itemEquipLoc].."|r"
                    end
                end
            else
                itemTypeText = itemSubType
            end
        elseif classID == Enum.ItemClass.Reagent and subclassID == Enum.ItemReagentSubclass.ContextToken then
            -- 珍玩 套装兑换物(以及暗影国度的武器兑换物)
            itemLevelText = Utils.GetColoredItemLevelText(itemLevel, itemLink)
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
                itemLevelText = Utils.GetColoredItemLevelText(itemLevel, itemLink)
            elseif subclassID == Enum.ItemMiscellaneousSubclass.CompanionPet then
                -- 战斗宠物
                itemTypeText = PET
            elseif subclassID == Enum.ItemMiscellaneousSubclass.Mount then
                -- 坐骑
                itemTypeText = itemSubType
            end
        elseif C_Item.IsItemKeystoneByID(id) then
            -- 史诗钥石 (偶尔有物品形式的：比如队友拾取的)
            local itemID, mapID, level, affix1, affix2, affix3, affix4 = strsplit(":", metaData)
            local r, g, b = 1, 1, 1

            if ItemInfoOverlay:GetConfig("color.itemLevel")  == 1 then
                r, g, b = Utils.GetRGBAFromHexColor(ItemInfoOverlay:GetConfig("color.itemLevel.custom"))
            elseif ItemInfoOverlay:GetConfig("color.itemLevel")  == 2 then
                r, g, b = C_ChallengeMode.GetKeystoneLevelRarityColor(level):GetRGB()
            end

            itemLevelText = format("|cff%02x%02x%02x+%d|r", r * 255, g * 255, b * 255, level)
        end

        if bonding == Enum.TooltipDataItemBinding.Account or bonding == Enum.TooltipDataItemBinding.BindToBnetAccount then
            itemBondingText = "|cff00ccff"..L["itemInfoOverlay.bonding.btw"].."|r"
        elseif bonding == Enum.TooltipDataItemBinding.BindOnEquip and classID ~= Enum.ItemClass.Recipe then
            itemBondingText = "|cffffffff"..L["itemInfoOverlay.bonding.boe"] .."|r"
        elseif bonding == Enum.TooltipDataItemBinding.AccountUntilEquipped or bonding == Enum.TooltipDataItemBinding.BindToAccountUntilEquipped then
            itemBondingText = "|cff00ccff"..L["itemInfoOverlay.bonding.wue"] .."|r"
        end

        if itemTypeText then
            if spellKnown then
                -- 已经学会
                itemTypeText = "|cff00ff00"..itemTypeText.."|r"
            elseif IsCosmeticItem(itemLink) then
                -- 装饰品
                itemTypeText = "|cffff80ff"..itemTypeText.."|r"
            end
        end

    elseif type == "keystone" then
        -- 史诗钥石
        local itemID, mapID, level, affix1, affix2, affix3, affix4 = strsplit(":", metaData)
        local r, g, b = 1, 1, 1

        if ItemInfoOverlay:GetConfig("color.itemLevel")  == 1 then
            r, g, b = Utils.GetRGBAFromHexColor(ItemInfoOverlay:GetConfig("color.itemLevel.custom"))
        elseif ItemInfoOverlay:GetConfig("color.itemLevel")  == 2 then
            r, g, b = C_ChallengeMode.GetKeystoneLevelRarityColor(level):GetRGB()
        end

        itemLevelText = format("|cff%02x%02x%02x+%d|r", r * 255, g * 255, b * 255, level)
    elseif type == "battlepet" then
        itemTypeText = PET

        local speciesID, level, breedQuality, maxHealth, power, speed, battlePetID = strsplit(":", metaData)
        local r, g, b = 1, 1, 1

        if ItemInfoOverlay:GetConfig("color.itemLevel")  == 1 then
            r, g, b = Utils.GetRGBAFromHexColor(ItemInfoOverlay:GetConfig("color.itemLevel.custom"))
        elseif ItemInfoOverlay:GetConfig("color.itemLevel")  == 2 then
            r, g, b = C_Item.GetItemQualityColor(breedQuality)
        end

        if speciesID then
            -- 需要 BattlePetBreedID 插件
            if BPBID_Internal and speciesID and breedQuality then
                local breedNum = BPBID_Internal.CalculateBreedID(
                    tonumber(speciesID),
                    tonumber(breedQuality) + 1,
                    tonumber(level),
                    tonumber(maxHealth),
                    tonumber(power),
                    tonumber(speed),
                    false,
                    false
                )
                local breed = BPBID_Internal.RetrieveBreedName(breedNum)
                if breed and breed ~= "NEW" then
                    itemTypeText = breed
                end
            end
        end
        itemLevelText = format("|cff%02x%02x%02x%d|r", r * 255, g * 255, b * 255, level)
    end

    if Module:GetConfig(CONFIG_ITEM_LEVEL) and itemLevelText then
        self.ItemLevel:SetText(itemLevelText)
        self.ItemLevel:Show()
    else
        self.ItemLevel:SetText()
        self.ItemLevel:Hide()
    end

    if Module:GetConfig(CONFIG_ITEM_TYPE) and itemTypeText then
        if L["itemInfoOverlay.itemType.alias"] and L["itemInfoOverlay.itemType.alias"][itemTypeText] then
            itemTypeText = L["itemInfoOverlay.itemType.alias"][itemTypeText]
        end

        if IsCosmeticItem(itemLink) then
            itemTypeText = "|cffff80ff"..itemTypeText.."|r"
        end

        self.ItemType:SetTextToFit(itemTypeText)
        self.ItemType:Show()

        if self.ItemType:GetUnboundedStringWidth() >= 50 then
            self.ItemType:SetWidth(50)
        end
    else
        self.ItemType:Hide()
    end

    if Module:GetConfig(CONFIG_EXTRA_INFO)then
        if Module:GetConfig(CONFIG_EXTRA_INFO_BONDING_TYPE) and itemBondingText then
            self.BondingType:SetText(itemBondingText)
            self.BondingType:Show()
        elseif Module:GetConfig(CONFIG_EXTRA_INFO_PVP_ITEM_LEVEL) and pvpItemLevel then
            self.BondingType:SetText(Utils.GetColoredItemLevelText("("..pvpItemLevel..")", itemLink, true))
            self.BondingType:Show()
        else
            self.BondingType:Hide()
        end
    else
        self.BondingType:Hide()
    end

    self:Show()
end

function IIOItemInfoOverlayMixin:SetItemFromLocation(itemLocation)
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

        local itemLevel, _, pvpItemLevel = Utils.GetItemLevelFromTooltipInfo(tooltipInfo)
        --[[
        if not itemLevel then
            itemLevel = C_Item.GetCurrentItemLevel(itemLocation)
        end
        ]]

        self:SetItemData(itemLink, tooltipInfo, itemLevel, pvpItemLevel)

        return itemLevel, itemLink, tooltipInfo
    else
        self:Hide()
    end
end

function IIOItemInfoOverlayMixin:SetItemFromLink(itemLink)
    if itemLink then
        self.itemLocation = nil
        self.itemLink = itemLink

        local tooltipInfo = C_TooltipInfo.GetHyperlink(itemLink)

        local itemLevel, _, pvpItemLevel = Utils.GetItemLevelFromTooltipInfo(tooltipInfo)
        --[[
        if not itemLevel then
            itemLevel = GetDetailedItemLevelInfo(itemLink)
        end
        ]]
        self:SetItemData(itemLink, tooltipInfo, itemLevel, pvpItemLevel)

        return itemLevel, itemLink, tooltipInfo
    else
        self:Hide()
    end
end

function IIOItemInfoOverlayMixin:Clear()
    self.itemLocation = nil
    self.itemLink = nil
    self:Hide()
end

function IIOItemInfoOverlayMixin:Refresh()
    if self.itemLocation then
        self:SetItemFromLocation(self.itemLocation)
    elseif self.itemLink then
        self:SetItemFromLink(self.itemLink)
    else
        self:Hide()
    end
end

IIOItemInfoOverlaySettingPriviewMixin = {}

function IIOItemInfoOverlaySettingPriviewMixin:OnLoad()
    self.itemButton1:SetItemButtonTexture(6035288)
    self.itemButton1:SetItemButtonQuality(Enum.ItemQuality.Epic)
    local overlay1 = Module:CreateItemInfoOverlay(self.itemButton1)
    overlay1.alwaysRefresh = true
    local testItem1 = Item:CreateFromItemID(220202)
    testItem1:ContinueOnItemLoad(function()
        overlay1:SetItemFromLink("|cnIQ4:|Hitem:220202::::::::80:102::6:6:6652:10356:10299:1540:10255:11215:1:28:2462::::|h[间谍大师裹网]|h|r")
    end)

    self.itemButton2:SetItemButtonTexture(4672195)
    self.itemButton2:SetItemButtonQuality(Enum.ItemQuality.Rare)
    self.itemButton2:SetItemButtonCount(100)
    local overlay2 = Module:CreateItemInfoOverlay(self.itemButton2)
    overlay2.alwaysRefresh = true
    local testItem2 = Item:CreateFromItemID(222776)
    testItem2:ContinueOnItemLoad(function()
        overlay2:SetItemFromLink("|cnIQ3:|Hitem:222776::::::::80:102:::::::::|h[丰盛的贝雷达尔之慷]|h|r")
    end)

    self.itemButton3:SetItemButtonTexture(1322720)
    self.itemButton3:SetItemButtonQuality(Enum.ItemQuality.Epic)
    local overlay3 = Module:CreateItemInfoOverlay(self.itemButton3)
    overlay3.alwaysRefresh = true
    local testItem3 = Item:CreateFromItemID(229783)
    testItem3:ContinueOnItemLoad(function()
        overlay3:SetItemFromLink("|cnIQ4:|Hitem:229783::::::::80:102::14:5:11977:12030:1524:10255:1:28:2462:::::|h[至臻角斗士的勋章]|h|r")
    end)
end

--------------------
-- 
--------------------

function Module:CreateItemInfoOverlay(frame)
    frame.ItemInfoOverlay = pool:Acquire()
    frame.ItemInfoOverlay:SetParent(frame)
    -- frame.ItemInfoOverlay = CreateFrame("Frame", nil, frame, "IIOItemInfoOverlayTemplate")

    local overlay = frame.ItemInfoOverlay
    overlay.frame = frame

    if frame.IconOverlay then
        overlay:SetAllPoints(frame.IconOverlay)
    else
        overlay:SetAllPoints(frame)
    end

    overlay:UpdateAppearance()

    return overlay
end

function Module:ReleaseItemInfoOverlay(frame)
    if frame.ItemInfoOverlay and pool:IsActive(frame.ItemInfoOverlay) then
        frame.ItemInfoOverlay.frame = nil
        frame.ItemInfoOverlay.type = nil

        pool:Release(frame.ItemInfoOverlay)
        frame.ItemInfoOverlay = nil
    end
end

function Module:DisableItemInfoOverlayByType(type)
    for overlay in pool:EnumerateActive() do
        if overlay.type == type then
            local frame = overlay.frame
            self.ReleaseItemInfoOverlay(overlay.frame)

            frame.ItemInfoOverlay = false
        end
    end
end

function Module:UpdateAllAppearance()
    for overlay in pool:EnumerateActive() do
        overlay:UpdateAppearance()
    end
end

--------------------
-- 暴雪函数安全钩子
--------------------

-- 通用钩子
hooksecurefunc("SetItemButtonQuality", function(button, quality, itemIDOrLink, suppressOverlays, isBound)
    if not Module:GetConfig("frames.other") then
        if button and button.ItemInfoOverlay then
            ItemInfoOverlay:GetModule("itemInfoOverlay"):ReleaseItemInfoOverlay(button)
        end
        return
    elseif button.ItemInfoOverlay == false or (button.ItemInfoOverlay and button.ItemInfoOverlay.type) then
        return
    end

    if button and button.SetItemButtonQuality then
        -- 跳过带有ItemButtonMixin等带有此函数的类型 防止重复操作
        return
    elseif itemIDOrLink then
        if tonumber(itemIDOrLink) then
        else
            -- 能直接获取到物品链接
            Utils.GetItemInfoOverlay(button):SetItemFromLink(itemIDOrLink)
            return
        end
    end
    Module:ReleaseItemInfoOverlay(button)
end)

hooksecurefunc(ItemButtonMixin, "SetItemButtonQuality", function(button, quality, itemIDOrLink, suppressOverlays, isBound)
    if not Module:GetConfig("frames.other") then
        if button.ItemInfoOverlay then
            ItemInfoOverlay:GetModule("itemInfoOverlay"):ReleaseItemInfoOverlay(button)
        end
        return
    elseif button.ItemInfoOverlay == false or (button.ItemInfoOverlay and button.ItemInfoOverlay.type) then
        return
    end

    if button.GetItemLocation and button:GetItemLocation() and button:GetItemLocation():IsValid() then
        -- GetItemLocation (背包/战团银行)
        Utils.GetItemInfoOverlay(button):SetItemFromLocation(button:GetItemLocation())
        return
    elseif button.GetItemLocationCallback and button:GetItemLocationCallback() and button:GetItemLocationCallback():IsValid() then
        -- GetItemLocationCallback (专业装备栏)
        Utils.GetItemInfoOverlay(button):SetItemFromLocation(button:GetItemLocationCallback())
        return
    elseif itemIDOrLink then
        if tonumber(itemIDOrLink) then
        else
            -- 能直接获取到物品链接
            Utils.GetItemInfoOverlay(button):SetItemFromLink(itemIDOrLink)
            return
        end
    end
    Module:ReleaseItemInfoOverlay(button)
end)

-- 背包
do
    local function ContainerFrameUpdateItems(frame)
        for _, button in frame:EnumerateValidItems() do
            if not Module:GetConfig("frames.blizzard.container") then
                Utils.GetItemInfoOverlay(button, false)
            else
                Utils.GetItemInfoOverlay(button, "Container"):SetItemFromLocation(button:GetItemLocation())
            end
        end
    end

    -- 联合的大包
    hooksecurefunc(ContainerFrameCombinedBags, "UpdateItems", ContainerFrameUpdateItems)

    -- 分开的小包
    for _, frame in ipairs(ContainerFrameContainer.ContainerFrames) do
        hooksecurefunc(frame, "UpdateItems", ContainerFrameUpdateItems)
    end
end

-- 银行
do
    --[[
    -- 银行界面 已于11.2.0移除
    -- 这段先留着，如果移植到怀旧服估计能用上
    hooksecurefunc("BankFrameItemButton_Update", function(button)
        -- 银行/材料银行
        if button.isBag  then
            -- 过滤银行背包栏
            return
        end
        local bag = button:GetParent():GetID()
        local slot = button:GetID()
        Utils.GetItemInfoOverlay(button):SetItemFromLocation(ItemLocation:CreateFromBagAndSlot(bag, slot))
    end)
    ]]

    local function BankPanelUpdateItems(frame)
        for button in frame:EnumerateValidItems() do
            if not Module:GetConfig("frames.blizzard.bank") then
                Utils.GetItemInfoOverlay(button, false)
            else
                Utils.GetItemInfoOverlay(button, "Bank"):SetItemFromLocation(button:GetItemLocation())
            end
        end
    end

    hooksecurefunc(BankPanel, "GenerateItemSlotsForSelectedTab", BankPanelUpdateItems)
    hooksecurefunc(BankPanel, "RefreshAllItemsForSelectedTab", BankPanelUpdateItems)
end

-- 装备选择器
hooksecurefunc("EquipmentFlyout_UpdateItems", function()
    local flyoutSettings = EquipmentFlyoutFrame.button:GetParent().flyoutSettings
    for _, button in ipairs(EquipmentFlyoutFrame.buttons) do
        if not Module:GetConfig("frames.blizzard.equipmentFlyout") then
            Utils.GetItemInfoOverlay(button, false)
        elseif button:IsShown() then
            local overlay = Utils.GetItemInfoOverlay(button, "EquipmentFlyout")

            if flyoutSettings.useItemLocation then
                overlay:SetItemFromLocation(button:GetItemLocation())
            else
                local data = EquipmentManager_GetLocationData(button.location)
                if data.isBags then
                    -- 背包中的物品
                    overlay:SetItemFromLocation(ItemLocation:CreateFromBagAndSlot(data.bag, data.slot))
                elseif data.isPlayer then
                    overlay:SetItemFromLocation(ItemLocation:CreateFromEquipmentSlot(data.slot))
                end
            end
        else
            Module:ReleaseItemInfoOverlay(button)
        end
    end
end)

-- 商人界面
hooksecurefunc("MerchantFrameItem_UpdateQuality", function(button, link, isBound)
    if not Module:GetConfig("frames.blizzard.merchant") then
        Utils.GetItemInfoOverlay(button.ItemButton, false)
    else
        Utils.GetItemInfoOverlay(button.ItemButton, "Merchant"):SetItemFromLink(link)
    end
end)

-- roll点框体
hooksecurefunc("GroupLootContainer_OpenNewFrame", function(rollID, rollTime)
    for i = 1, 4 do
        local frame = _G["GroupLootFrame"..i]
        if frame and frame.rollID then
            local overlay = Utils.GetItemInfoOverlay(frame.IconFrame, "GroupLootFrame")

            local itemLink = GetLootRollItemLink(frame.rollID)
            local tooltipInfo = C_TooltipInfo.GetLootRollItem(frame.rollID)

            if itemLink then
                local itemLevel = Utils.GetItemLevelFromTooltipInfo(tooltipInfo)
                overlay:SetItemData(itemLink, tooltipInfo, itemLevel)
            end
        end
    end
end)

function Module:AfterLogin()
    if NDui then
        -- NDui整合背包 https://ngabbs.com/read.php?tid=5483616
        local NDuiBagpack = NDui.cargBags:GetImplementation("NDui_Backpack")
        if NDuiBagpack then
            hooksecurefunc(NDuiBagpack:GetItemButtonClass(), "OnUpdateButton", function(button, item)
                if not Module:GetConfig("frames.addons.ndui") then
                    Utils.GetItemInfoOverlay(button, false)
                else
                    local bag = item.bagId
                    local slot = item.slotId
                    Utils.GetItemInfoOverlay(button, "NDui"):SetItemFromLocation(ItemLocation:CreateFromBagAndSlot(bag, slot))
                end
            end)
        end
    end

    if NDui_Bags then
        -- NDui整合背包 独立插件版 https://ngabbs.com/read.php?tid=34318074
        local NDuiBagpack = NDui_Bags.cargBags:GetImplementation("NDui_Backpack")
        if NDuiBagpack then
            hooksecurefunc(NDuiBagpack:GetItemButtonClass(), "OnUpdateButton", function(button, item)
                if not Module:GetConfig("frames.addons.ndui") then
                    Utils.GetItemInfoOverlay(button, false)
                else
                    local bag = item.bagId
                    local slot = item.slotId
                    Utils.GetItemInfoOverlay(button, "NDui"):SetItemFromLocation(ItemLocation:CreateFromBagAndSlot(bag, slot))
                end
            end)
        end
    end
end

