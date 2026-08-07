local ADDON_NAME, ItemInfoOverlay = ...

local Module = ItemInfoOverlay:NewModule("itemInfoOverlay")
local Utils = ItemInfoOverlay:GetModule("utils")
local L = ItemInfoOverlay.Locale
local SharedMedia = LibStub("LibSharedMedia-3.0")

local CONFIG_ITEM_LEVEL = "itemLevel.enable"
local CONFIG_ITEM_LEVEL_POINT = "itemLevel.point"
local CONFIG_ITEM_LEVEL_FONT = "itemLevel.font"
local CONFIG_ITEM_LEVEL_FONT_SIZE = "itemLevel.fontSize"
local CONFIG_ITEM_LEVEL_OFFSET_X = "itemLevel.offsetX"
local CONFIG_ITEM_LEVEL_OFFSET_Y = "itemLevel.offsetY"
local CONFIG_ITEM_TYPE = "itemType.enable"
local CONFIG_ITEM_TYPE_POINT = "itemType.point"
local CONFIG_ITEM_TYPE_FONT = "itemType.font"
local CONFIG_ITEM_TYPE_FONT_SIZE = "itemType.fontSize"
local CONFIG_ITEM_TYPE_OFFSET_X = "itemType.offsetX"
local CONFIG_ITEM_TYPE_OFFSET_Y = "itemType.offsetY"
local CONFIG_EXTRA_INFO = "extraInfo.enable"
local CONFIG_EXTRA_INFO_ANCHOR_TO_ICON = "extraInfo.customAnchor"
local CONFIG_EXTRA_INFO_POINT = "extraInfo.point"
local CONFIG_EXTRA_INFO_FONT = "extraInfo.font"
local CONFIG_EXTRA_INFO_FONT_SIZE = "extraInfo.fontSize"
local CONFIG_EXTRA_INFO_BONDING_TYPE = "extraInfo.bondingType"
local CONFIG_EXTRA_INFO_PVP_ITEM_LEVEL = "extraInfo.pvpItemLevel"
local CONFIG_EXTRA_INFO_OFFSET_X = "extraInfo.offsetX"
local CONFIG_EXTRA_INFO_OFFSET_Y = "extraInfo.offsetY"

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
    self.ItemLevel:SetPoint(
        POINTS[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)],
        self,
        POINTS[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)],
        Module:GetConfig(CONFIG_ITEM_LEVEL_OFFSET_X),
        Module:GetConfig(CONFIG_ITEM_LEVEL_OFFSET_Y)
    )

    self.ItemType:SetFont(Module:GetConfig(CONFIG_ITEM_TYPE_FONT), Module:GetConfig(CONFIG_ITEM_TYPE_FONT_SIZE), "OUTLINE")
    self.ItemType:SetJustifyH(POINTS_JUSTIFY_H[Module:GetConfig(CONFIG_ITEM_TYPE_POINT)])
    self.ItemType:ClearAllPoints()
    self.ItemType:SetPoint(
        POINTS[Module:GetConfig(CONFIG_ITEM_TYPE_POINT)],
        self,
        POINTS[Module:GetConfig(CONFIG_ITEM_TYPE_POINT)],
        Module:GetConfig(CONFIG_ITEM_TYPE_OFFSET_X),
        Module:GetConfig(CONFIG_ITEM_TYPE_OFFSET_Y)
    )

    self.BondingType:SetFont(Module:GetConfig(CONFIG_EXTRA_INFO_FONT), Module:GetConfig(CONFIG_EXTRA_INFO_FONT_SIZE), "OUTLINE")
    if Module:GetConfig(CONFIG_EXTRA_INFO_ANCHOR_TO_ICON) then
        self.BondingType:ClearAllPoints()
        self.BondingType:SetPoint(
            POINTS[Module:GetConfig(CONFIG_EXTRA_INFO_POINT)],
            self,
            POINTS[Module:GetConfig(CONFIG_EXTRA_INFO_POINT)],
            Module:GetConfig(CONFIG_EXTRA_INFO_OFFSET_X),
            Module:GetConfig(CONFIG_EXTRA_INFO_OFFSET_Y)
        )
    else
        self.BondingType:ClearAllPoints()
        self.BondingType:SetPoint(
            POINTS_BONDING_TYPE_ANCHOR_TO_ITEMLEVEL[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)][1],
            self.ItemLevel,
            POINTS_BONDING_TYPE_ANCHOR_TO_ITEMLEVEL[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)][2],
            Module:GetConfig(CONFIG_EXTRA_INFO_OFFSET_X),
            POINTS_BONDING_TYPE_ANCHOR_TO_ITEMLEVEL[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)][3] + Module:GetConfig(CONFIG_EXTRA_INFO_OFFSET_Y)
        )
    end


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
                        -- 非偏好护甲类型: 显示红色
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

        Module:RefreshOnItemLoad(self, itemLink)

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

        Module:RefreshOnItemLoad(self, itemLink)

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
            if frame then
                self:ReleaseItemInfoOverlay(frame)
            end

            frame.ItemInfoOverlay = false
        end
    end
end

function Module:UpdateAllAppearance()
    for overlay in pool:EnumerateActive() do
        overlay:UpdateAppearance()
    end
end

-- 物品数据未缓存时(如刚打开背包), 先按现有数据显示, 并在数据加载完成后自动刷新一次
-- 部分按钮(如 Baganator)在物品加载完成后不会再调用 SetItemDetails, 需要自行补刷新
function Module:RefreshOnItemLoad(overlay, itemLink)
    local itemID = C_Item.GetItemIDForItemInfo(itemLink)
    if not itemID or C_Item.IsItemDataCachedByID(itemID) then
        return
    end

    local item = Item:CreateFromItemLink(itemLink)
    item:ContinueOnItemLoad(function()
        if pool:IsActive(overlay) and overlay.frame then
            overlay:Refresh()
        end
    end)
end

--------------------
-- Baganator
--------------------

-- Baganator 的物品按钮通过方法调用 SetItemButtonQuality, 且其 mixin 被 table.freeze 冻结,
-- 无法钩住 mixin 方法, 因此改为逐按钮钩住 SetItemDetails
local BaganatorButtons

do
    local hooked = {}

    -- Baganator 按钮特征: 同时拥有 SetItemDetails 和 SetItemFiltered
    local function IsBaganatorItemButton(button)
        return button ~= nil and button.SetItemDetails ~= nil and button.SetItemFiltered ~= nil
    end

    local function UpdateOverlay(button, itemLink)
        if not Module:GetConfig("frames.other") then
            Utils.GetItemInfoOverlay(button, false)
            return
        end

        itemLink = itemLink or (button.BGR and button.BGR.itemLink)

        if itemLink then
            local overlay = Utils.GetItemInfoOverlay(button, "Baganator")

            local itemLocation
            if button.GetBagID and button.GetID and button.BGR and button.BGR.guid then
                -- 实时背包/银行按钮: 通过物品GUID确认位置有效后, 使用位置获取更准确的绑定信息
                -- (缓存的其他角色银行按钮没有guid, 不会走到这里)
                itemLocation = ItemLocation:CreateFromBagAndSlot(button:GetBagID(), button:GetID())
                if not (itemLocation:IsValid() and C_Item.DoesItemExist(itemLocation) and C_Item.GetItemGUID(itemLocation) == button.BGR.guid) then
                    itemLocation = nil
                end
            end

            if itemLocation then
                overlay:SetItemFromLocation(itemLocation)
            else
                overlay:SetItemFromLink(itemLink)
            end
        else
            -- 空槽位或物品链接尚未就绪
            Module:ReleaseItemInfoOverlay(button)
        end
    end

    local function HookButton(button)
        if hooked[button] or not button.SetItemDetails then
            return false
        end
        hooked[button] = true
        hooksecurefunc(button, "SetItemDetails", function(self, details)
            UpdateOverlay(self, details and details.itemLink)
        end)
        return true
    end

    BaganatorButtons = {}

    -- 由通用钩子调用: 识别并接管 Baganator 按钮
    -- 返回 true 表示已处理, 通用钩子应跳过后续逻辑
    function BaganatorButtons.Handle(button, itemIDOrLink)
        if not IsBaganatorItemButton(button) then
            return false
        end

        HookButton(button)

        -- 逐按钮钩子对进行中的 SetItemDetails 调用不会触发, 当前这次更新在这里直接处理
        if itemIDOrLink and not tonumber(itemIDOrLink) then
            UpdateOverlay(button, itemIDOrLink)
        else
            UpdateOverlay(button)
        end

        return true
    end

    -- 通过 Baganator 的公开接口在每个物品按钮创建时挂钩
    function BaganatorButtons.Register()
        if not (Baganator and Baganator.API and Baganator.API.Skins and Baganator.API.Skins.RegisterListener) then
            return false
        end

        Baganator.API.Skins.RegisterListener(function(details)
            if details.regionType == "ItemButton" then
                HookButton(details.region)
            end
        end)

        -- 监听器只对注册后创建的按钮生效, 补挂监听注册前已创建的按钮
        -- (例如带着打开的背包/reload时, Baganator 在登录后立即恢复背包视图)
        if Baganator.API.Skins.GetAllFrames then
            for _, details in ipairs(Baganator.API.Skins.GetAllFrames()) do
                if details.regionType == "ItemButton" then
                    -- 新挂钩的按钮立即按当前物品刷新一次 (钩子对已完成的调用不生效)
                    if HookButton(details.region) then
                        UpdateOverlay(details.region)
                    end
                end
            end
        end

        return true
    end

    -- 诊断命令: /iiobgn 输出 Baganator 按钮的挂钩与浮层状态
    SLASH_IIOBGN1 = "/iiobgn"
    SlashCmdList["IIOBGN"] = function()
        local hookedCount, visible = 0, {}
        for button in pairs(hooked) do
            hookedCount = hookedCount + 1
            if button:IsVisible() and #visible < 6 then
                table.insert(visible, button)
            end
        end
        print("|cffff8000[IIO-BGN]|r hooked buttons:", hookedCount, " visible samples:", #visible)
        for i, button in ipairs(visible) do
            local bgr = button.BGR
            local overlay = button.ItemInfoOverlay
            print(("|cffff8000[IIO-BGN]|r #%d link=%s guid=%s bag=%s slot=%s overlay=%s type=%s shown=%s"):format(
                i,
                (bgr and bgr.itemLink) and "Y" or "N",
                (bgr and bgr.guid) and "Y" or "N",
                tostring(button.GetBagID and button:GetBagID()),
                tostring(button:GetID()),
                tostring(overlay),
                (type(overlay) == "table" and tostring(overlay.type)) or "-",
                (type(overlay) == "table" and tostring(overlay:IsShown())) or "-"
            ))
        end
    end
end

--------------------
-- 暴雪函数安全钩子
--------------------

-- 通用钩子
hooksecurefunc("SetItemButtonQuality", function(button, quality, itemIDOrLink, suppressOverlays, isBound)
    if BaganatorButtons.Handle(button, itemIDOrLink) then
        return
    end

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
    if BaganatorButtons.Handle(button, itemIDOrLink) then
        return
    end

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
    if Baganator then
        -- Baganator 背包/银行
        BaganatorButtons.Register()
    end

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

