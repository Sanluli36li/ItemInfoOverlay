local ADDON_NAME, ItemInfoOverlay = ...

local Module = ItemInfoOverlay:NewModule("characterFrame")
local L = ItemInfoOverlay.Locale

local CONFIG_ITEM_LEVEL = "itemLevel.enable"
local CONFIG_ITEM_LEVEL_FONT = "itemLevel.font"
local CONFIG_ITEM_LEVEL_FONT_SIZE = "itemLevel.fontSize"
local CONFIG_ITEM_LEVEL_POINT = "itemLevel.point"
local CONFIG_ITEM_LEVEL_POINT_ON_ICON = 1
local CONFIG_ITEM_LEVEL_POINT_ON_SIDE = 2
local CONFIG_SOCKET = "socket.enable"
local CONFIG_SOCKET_ICON_SIZE = "socket.iconSize"
local CONFIG_ENCHANT = "enchant.enable"
local CONFIG_ENCHANT_DISPLAY_MISSING = "enchant.displayMissing"
local CONFIG_ENCHANT_FONT = "enchant.font"
local CONFIG_ENCHANT_FONT_SIZE = "enchant.fontSize"

local CHARACTER_PREFIX = "Character"
local INSPECT_PREFIX = "Inspect"
local SLOT_SUFFIX = "Slot"

local ENCHANT_PATTERN = ENCHANTED_TOOLTIP_LINE:gsub("%%s", "(.*)")
local ENCHANT_QUALITY_PATTERN = "(.*)|A:(.*):20:20|a"

local EQUIPMENT_SLOTS = {
    [1] = {id = 1, side = "LEFT", name = "Head"},
    [2] = {id = 2, side = "LEFT", name = "Neck"},
    [3] = {id = 3, side = "LEFT", name = "Shoulder"},
    [4] = {id = 4, side = "LEFT", name = "Shirt"},
    [5] = {id = 5, side = "LEFT", name = "Chest"},
    [6] = {id = 6, side = "RIGHT", name = "Waist"},
    [7] = {id = 7, side = "RIGHT", name = "Legs"},
    [8] = {id = 8, side = "RIGHT", name = "Feet"},
    [9] = {id = 9, side = "LEFT", name = "Wrist"},
    [10] = {id = 10, side = "RIGHT", name = "Hands"},
    [11] = {id = 11, side = "RIGHT", name = "Finger0"},
    [12] = {id = 12, side = "RIGHT", name = "Finger1"},
    [13] = {id = 13, side = "RIGHT", name = "Trinket0"},
    [14] = {id = 14, side = "RIGHT", name = "Trinket1"},
    [15] = {id = 15, side = "LEFT", name = "Back"},
    [16] = {id = 16, side = "RIGHT", name = "MainHand", offsetY = -8},
    [17] = {id = 17, side = "LEFT", name = "SecondaryHand", offsetY = -8},
    --    [18] = {id = 18, side = "LEFT", name = "Ranged", canEnchant = false},
    [19] = {id = 19, side = "LEFT", name = "Tabard"}
}
local itemInfoOverlayPoor = {}

local EQUIP_LOC_CAN_ENCHANT_TWW = {
    INVTYPE_CHEST = true,       -- 胸部
    INVTYPE_ROBE = true,        -- 胸部 (搞不懂为啥胸甲会有两种装备位置)
    INVTYPE_LEGS = true,        -- 腿部
    INVTYPE_FEET = true,        -- 脚部
    INVTYPE_WRIST = true,       -- 腕部
    INVTYPE_FINGER = true,      -- 手指
    INVTYPE_CLOAK = true,       -- 背部
    INVTYPE_WEAPON = true,      -- 武器
    INVTYPE_2HWEAPON = true,    -- 双手武器
}

local function canEnchant(itemLevel, itemEquipLoc)
    if itemLevel > 535 then
        -- TWW
        return EQUIP_LOC_CAN_ENCHANT_TWW[itemEquipLoc]
    else
        return false
    end
end

--------------------
-- Mixin
--------------------
SanluliCharacterFrameItemInfoOverlayMixin = {}

function SanluliCharacterFrameItemInfoOverlayMixin:SetSide(isLeft)
    self.side = (isLeft and "LEFT") or "RIGHT"

    -- 附魔
    self.Enchant:ClearAllPoints()
    self.Enchant:SetPoint(
        (isLeft and "LEFT") or "RIGHT",
        self,
        (isLeft and "RIGHT") or "LEFT",
        (isLeft and 8) or -8,
        0
    )
    -- 附魔品质
    self.EnchantQuality:ClearAllPoints()
    self.EnchantQuality:SetPoint(
        (isLeft and "LEFT") or "RIGHT",
        self.Enchant,
        (isLeft and "RIGHT") or "LEFT",
        (isLeft and 4) or -4,
        0
    )

    -- 宝石插槽2
    self.GemSocket2:ClearAllPoints()
    self.GemSocket2:SetPoint(
        (isLeft and "LEFT") or "RIGHT",
        self.GemSocket1,
        (isLeft and "RIGHT") or "LEFT",
        0,
        0
    )
    -- 宝石插槽3
    self.GemSocket3:ClearAllPoints()
    self.GemSocket3:SetPoint(
        (isLeft and "LEFT") or "RIGHT",
        self.GemSocket2,
        (isLeft and "RIGHT") or "LEFT",
        0,
        0
    )
end

function SanluliCharacterFrameItemInfoOverlayMixin:UpdateAppearance()
    -- 物品等级位置
    if Module:GetConfig(CONFIG_ITEM_LEVEL_POINT) == CONFIG_ITEM_LEVEL_POINT_ON_SIDE then
        self.ItemLevel:ClearAllPoints()
        self.ItemLevel:SetPoint(
            (self.side == "LEFT" and "LEFT") or "RIGHT",
            self,
            (self.side == "LEFT" and "RIGHT") or "LEFT",
            (self.side == "LEFT" and 8) or -8,
            0
        )

        self.GemSocket1:ClearAllPoints()
        self.GemSocket1:SetPoint(
            (self.side == "LEFT" and "LEFT") or "RIGHT",
            self,
            (self.side == "LEFT" and "RIGHT") or "LEFT",
            (self.side == "LEFT" and Module:GetConfig(CONFIG_ITEM_LEVEL_FONT_SIZE) * 3 + 2) or (- Module:GetConfig(CONFIG_ITEM_LEVEL_FONT_SIZE) * 3 - 2),
            0
        )
    else
        self.ItemLevel:ClearAllPoints()
        self.ItemLevel:SetPoint("TOP", self, "TOP", 0, -2)

        self.GemSocket1:ClearAllPoints()
        self.GemSocket1:SetPoint(
            (self.side == "LEFT" and "LEFT") or "RIGHT",
            self,
            (self.side == "LEFT" and "RIGHT") or "LEFT",
            (self.side == "LEFT" and 9) or -9,
        0)
    end
    -- 物品等级字体
    self.ItemLevel:SetFont(Module:GetConfig(CONFIG_ITEM_LEVEL_FONT), Module:GetConfig(CONFIG_ITEM_LEVEL_FONT_SIZE), "OUTLINE")
    -- 附魔
    self.Enchant:SetFont(Module:GetConfig(CONFIG_ENCHANT_FONT), Module:GetConfig(CONFIG_ENCHANT_FONT_SIZE), "OUTLINE")
    self.EnchantQuality:SetFont(Module:GetConfig(CONFIG_ENCHANT_FONT), Module:GetConfig(CONFIG_ENCHANT_FONT_SIZE), "OUTLINE")
    self.EnchantQuality:ClearAllPoints()
    self.EnchantQuality:SetPoint(self.side, self.Enchant, (self.side == "LEFT" and "RIGHT" or "LEFT"), (self.side == "LEFT" and -4 or 4), 0)
    -- 宝石
    self.GemSocket1:SetSize(Module:GetConfig(CONFIG_SOCKET_ICON_SIZE), Module:GetConfig(CONFIG_SOCKET_ICON_SIZE))
    self.GemSocket1.Quality:SetFont(Module:GetConfig(CONFIG_ENCHANT_FONT), Module:GetConfig(CONFIG_SOCKET_ICON_SIZE) - 2, "OUTLINE")
    self.GemSocket2:SetSize(Module:GetConfig(CONFIG_SOCKET_ICON_SIZE), Module:GetConfig(CONFIG_SOCKET_ICON_SIZE))
    self.GemSocket2.Quality:SetFont(Module:GetConfig(CONFIG_ENCHANT_FONT), Module:GetConfig(CONFIG_SOCKET_ICON_SIZE) - 2, "OUTLINE")
    self.GemSocket3:SetSize(Module:GetConfig(CONFIG_SOCKET_ICON_SIZE), Module:GetConfig(CONFIG_SOCKET_ICON_SIZE))
    self.GemSocket3.Quality:SetFont(Module:GetConfig(CONFIG_ENCHANT_FONT), Module:GetConfig(CONFIG_SOCKET_ICON_SIZE) - 2, "OUTLINE")

    self:UpdateLines()
end

function SanluliCharacterFrameItemInfoOverlayMixin:UpdateLines()
    local line1, line2
    if (Module:GetConfig(CONFIG_ITEM_LEVEL_POINT) == CONFIG_ITEM_LEVEL_POINT_ON_SIDE and self.ItemLevel:IsShown()) or self.GemSocket1:IsShown() then
        line1 = true
    end

    if self.Enchant:IsShown() then
        line2 = true
    end

    local point, relativeTo, relativePoint, offsetX, offsetY

    if line1 and line2 then

        -- 物品等级
        if Module:GetConfig(CONFIG_ITEM_LEVEL_POINT) == CONFIG_ITEM_LEVEL_POINT_ON_SIDE then
            point, relativeTo, relativePoint, offsetX, offsetY = self.ItemLevel:GetPointByName(self.side)
            self.ItemLevel:SetPoint(point, relativeTo, relativePoint, offsetX, (Module:GetConfig(CONFIG_ITEM_LEVEL_FONT_SIZE) / 2) + 1 + (self.offsetY or 0))
        end

        -- 宝石插槽
        point, relativeTo, relativePoint, offsetX, offsetY = self.GemSocket1:GetPointByName(self.side)
        self.GemSocket1:SetPoint(point, relativeTo, relativePoint, offsetX, (Module:GetConfig(CONFIG_SOCKET_ICON_SIZE) / 2) + (self.offsetY or 0))

        -- 附魔文字
        point, relativeTo, relativePoint, offsetX, offsetY = self.Enchant:GetPointByName(self.side)
        self.Enchant:SetPoint(point, relativeTo, relativePoint, offsetX, - (Module:GetConfig(CONFIG_ITEM_LEVEL_FONT_SIZE) / 2) - 1 + (self.offsetY or 0))
    else
        -- 物品等级
        if Module:GetConfig(CONFIG_ITEM_LEVEL_POINT) == CONFIG_ITEM_LEVEL_POINT_ON_SIDE then
            point, relativeTo, relativePoint, offsetX, offsetY = self.ItemLevel:GetPointByName(self.side)
            self.ItemLevel:SetPoint(point, relativeTo, relativePoint, offsetX, self.offsetY or 0)
        end

        -- 宝石插槽
        point, relativeTo, relativePoint, offsetX, offsetY = self.GemSocket1:GetPointByName(self.side)
        self.GemSocket1:SetPoint(point, relativeTo, relativePoint, offsetX, self.offsetY or 0)

        -- 附魔文字
        point, relativeTo, relativePoint, offsetX, offsetY = self.Enchant:GetPointByName(self.side)
        self.Enchant:SetPoint(point, relativeTo, relativePoint, offsetX, self.offsetY or 0)
    end
end

function SanluliCharacterFrameItemInfoOverlayMixin:SetItem(itemLocation, itemLink)
    if itemLink or (itemLocation and itemLocation:IsValid()) then
        self:Show()
        local itemName, itemQuality, itemLevel, itemID, itemMinLevel, itemType, itemSubType,
            itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
            expacID, setID, isCraftingReagent

        if itemLocation and itemLocation:IsValid() then
            if not itemLink then
                itemLink = C_Item.GetItemLink(itemLocation)
            end

            itemLevel = C_Item.GetCurrentItemLevel(itemLocation)
            itemID = C_Item.GetItemID(itemLocation)
        end

        if itemLink then
            if not itemLevel then
                itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
            end

            if not itemID then
                C_Item.GetItemIDForItemInfo(itemLink)
            end
        end

        itemName, _, itemQuality, _, itemMinLevel, itemType, itemSubType, 
        itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
        expacID, setID, isCraftingReagent = C_Item.GetItemInfo(itemLink)

        local itemLevelText

        if itemLevel > 1 then
            -- 物品等级为1的装备不显示, 如此可以过滤掉大部分的衬衣和战袍
            local r, g, b = C_Item.GetItemQualityColor(itemQuality)

            itemLevelText = format("|cff%02x%02x%02x%d|r", r * 255, g * 255, b * 255, itemLevel)
        end

        local itemEnchant, itemEnchantQuality
        local itemGemSocketCount = 0
        local itemGemSockets = {}
        local tooltipData = C_TooltipInfo.GetHyperlink(itemLink)
        if tooltipData then
            for i, line in pairs(tooltipData.lines) do
                local text = line.leftText

                -- 附魔
                if line.type == Enum.TooltipDataLineType.ItemEnchantmentPermanent then
                    local enchant = string.match(text, ENCHANT_PATTERN)
                    if enchant then
                        if string.find(enchant, "|A:") then
                            itemEnchant, itemEnchantQuality = string.match(enchant, ENCHANT_QUALITY_PATTERN)
                        else
                            itemEnchant = enchant
                        end
                    end
                end

                -- 宝石
                if line.type == Enum.TooltipDataLineType.GemSocket then
                    if line.socketType then
                        itemGemSocketCount = itemGemSocketCount + 1
                        itemGemSockets[itemGemSocketCount] = string.format("Interface\\ItemSocketingFrame\\UI-EmptySocket-%s", line.socketType)
                    end
                end
            end
        end

        if Module:GetConfig(CONFIG_ITEM_LEVEL) and itemLevelText then
            self.ItemLevel:SetText(itemLevelText)
            self.ItemLevel:Show()
        else
            self.ItemLevel:Hide()
        end

        if Module:GetConfig(CONFIG_ENCHANT) and itemEnchant then
            self.Enchant:SetText(string.gsub(itemEnchant, "[ \\+]", ""))
            self.Enchant:Show()

            if self.Enchant:GetUnboundedStringWidth() <= 80 then
                self.Enchant:SetWidth(self.Enchant:GetUnboundedStringWidth())
            else
                self.Enchant:SetWidth(80)
            end

            if itemEnchantQuality then
                self.EnchantQuality:SetText("|A:"..itemEnchantQuality..":20:20|a")
                self.EnchantQuality:Show()
            else
                self.EnchantQuality:Hide()
            end
        elseif Module:GetConfig(CONFIG_ENCHANT) and Module:GetConfig(CONFIG_ENCHANT_DISPLAY_MISSING) and canEnchant(itemLevel, itemEquipLoc) then
            self.Enchant:SetText("|cffff0000"..L["characterFrame.enchant.displayMissing.noenchant"].."|r")
            self.Enchant:Show()

            if self.Enchant:GetUnboundedStringWidth() <= 80 then
                self.Enchant:SetWidth(self.Enchant:GetUnboundedStringWidth())
            else
                self.Enchant:SetWidth(80)
            end

            self.EnchantQuality:Hide()
        else
            self.EnchantQuality:Hide()
            self.Enchant:Hide()
        end

        if Module:GetConfig(CONFIG_SOCKET) then
            for i = 1, 3 do
                if self["GemSocket"..i] then
                    local gemID = C_Item.GetItemGemID(itemLink, i)

                    if gemID then
                        -- 等待缓存宝石图标的处理方式来自 [Interface\\AddOns\\Blizzard_UIPanels_Game\\Mainline\\PaperDollFrame.lua]:2799

                        local gemItem = Item:CreateFromItemID(gemID)

                        -- 未载入: 先把插槽图标贴上去
                        if not gemItem:IsItemDataCached() then
                            self["GemSocket"..i]:SetNormalTexture("Interface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic")
                        end
                        -- 等待到宝石物品载入
                        gemItem:ContinueOnItemLoad(function()
                            local _, gemLink, _, _, _, _, _, _, _, gemIcon = C_Item.GetItemInfo(gemID)
                            local professionQuality = C_TradeSkillUI.GetItemReagentQualityByItemInfo(gemID)

                            self["GemSocket"..i]:SetNormalTexture(gemIcon)

                            self["GemSocket"..i]:SetScript("OnEnter", function(self)
                                GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
                                GameTooltip:SetHyperlink(gemLink)
                                GameTooltip:Show()
                            end)

                            self["GemSocket"..i]:SetScript("OnLeave", function()
                                GameTooltip:Hide()
                            end)

                            if professionQuality then
                                self["GemSocket"..i].Quality:SetText("|A:".."Professions-ChatIcon-Quality-Tier"..professionQuality..":12:12|a")
                                self["GemSocket"..i].Quality:Show()
                            else
                                self["GemSocket"..i].Quality:Hide()
                            end

                            self["GemSocket"..i]:Show()
                        end)
                    else
                        -- 没有宝石
                        if i <= itemGemSocketCount then
                            if itemGemSockets[i] then
                                self["GemSocket"..i]:SetNormalTexture(itemGemSockets[i])
                                self["GemSocket"..i]:SetScript("OnEnter", function () end)
                                self["GemSocket"..i]:Show()
                                self["GemSocket"..i].Quality:Hide()
                            else
                                self["GemSocket"..i]:Hide()
                                self["GemSocket"..i].Quality:Hide()
                            end
                        else
                            self["GemSocket"..i]:Hide()
                            self["GemSocket"..i].Quality:Hide()
                        end
                    end
                end
            end
        else
            self.GemSocket1:Hide()
            self.GemSocket2:Hide()
            self.GemSocket3:Hide()
        end

        self:UpdateLines()
    else
        self:Hide()
    end
end

--------------------
-- 
--------------------

local function CreateItemInfoOverlay(frame, slot)
    frame.ItemInfoOverlay = CreateFrame("Frame", nil, frame, "SanluliCharacterFrameItemInfoOverlayTemplate")

    local overlay = frame.ItemInfoOverlay

    tinsert(itemInfoOverlayPoor, overlay)

    overlay.slot = slot
    overlay.side = EQUIPMENT_SLOTS[slot].side
    overlay.offsetY = EQUIPMENT_SLOTS[slot].offsetY
    overlay:SetAllPoints(frame)

    overlay:SetSide(EQUIPMENT_SLOTS[slot].side == "LEFT")
    overlay:UpdateAppearance()

    return overlay
end

local function GetItemInfoOverlay(frame)
    if not frame.ItemInfoOverlay then
        return nil
    else
        return frame.ItemInfoOverlay
    end
end

local function GetItemInfoOverlayFromSlotID(slotID, isInspect)
    if slotID and EQUIPMENT_SLOTS[slotID] then
        if isInspect then
            return GetItemInfoOverlay(_G[INSPECT_PREFIX..EQUIPMENT_SLOTS[slotID].name..SLOT_SUFFIX])
        else
            return GetItemInfoOverlay(_G[CHARACTER_PREFIX..EQUIPMENT_SLOTS[slotID].name..SLOT_SUFFIX])
        end
    end
end

function Module:UpdateAllAppearance()
    for _, overlay in ipairs(itemInfoOverlayPoor) do
        overlay:UpdateAppearance()
    end
end

function Module:UpdateAllInspectSlot ()
    if InspectFrame.unit then
        for slotID, _ in pairs(EQUIPMENT_SLOTS) do
            local itemLink = GetInventoryItemLink(InspectFrame.unit, slotID)
            GetItemInfoOverlayFromSlotID(slotID, true):SetItem(nil, itemLink)
        end
    end
end

function Module:UpdateAllCharacterSlot()
    for slotID, _ in pairs(EQUIPMENT_SLOTS) do
        GetItemInfoOverlayFromSlotID(slotID):SetItem(ItemLocation:CreateFromEquipmentSlot(slotID))
    end
end

function Module:UpdateItemLocation(itemLocation)
    if itemLocation and itemLocation:IsValid() and itemLocation:IsEquipmentSlot() then
        local slotID = itemLocation:GetEquipmentSlot()
        local overlay = GetItemInfoOverlayFromSlotID(slotID)
        if overlay then
            overlay:SetItem(itemLocation)
        end
    end
end

--------------------
-- 暴雪函数安全钩子
--------------------

local function hookInspectUI()
    for slotID, _ in pairs(EQUIPMENT_SLOTS) do
        CreateItemInfoOverlay(_G[INSPECT_PREFIX..EQUIPMENT_SLOTS[slotID].name..SLOT_SUFFIX], slotID)
    end

    InspectModelFrame.ItemLevelOverlay = InspectModelFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText")

    InspectModelFrame.ItemLevelOverlay:SetFont(Module:GetConfig(CONFIG_ITEM_LEVEL_FONT), Module:GetConfig(CONFIG_ITEM_LEVEL_FONT_SIZE), "OUTLINE")
    InspectModelFrame.ItemLevelOverlay:SetShadowOffset(1, -1)

    InspectModelFrame.ItemLevelOverlay:SetPoint("BOTTOM", InspectModelFrame, "BOTTOM", 0, 20)

    hooksecurefunc("InspectPaperDollFrame_UpdateButtons", function ()
        InspectModelFrame.ItemLevelOverlay:SetText(STAT_AVERAGE_ITEM_LEVEL..": "..C_PaperDollInfo.GetInspectItemLevel(InspectFrame.unit))

        Module:UpdateAllInspectSlot()
    end)
end

--------------------
-- 事件处理
--------------------

function Module:Startup()
    for slotID, _ in pairs(EQUIPMENT_SLOTS) do
        CreateItemInfoOverlay(_G[CHARACTER_PREFIX..EQUIPMENT_SLOTS[slotID].name..SLOT_SUFFIX], slotID)
    end
end

function Module:ADDON_LOADED(AddOnName)
    if AddOnName == "Blizzard_InspectUI" then
        hookInspectUI()
    end
end
Module:RegisterEvent("ADDON_LOADED")

-- 插槽更新: 更新所有栏位
function Module:SOCKET_INFO_UPDATE()
    self:UpdateAllCharacterSlot()
end
Module:RegisterEvent("SOCKET_INFO_UPDATE")

-- 附魔完成: 0.5s后更新栏位
-- 未知原因, 附魔后马上获取物品信息无法取到新的附魔, 故延迟0.5s (正好角色界面的附魔更新动画也差不多播完了)
function Module:ENCHANT_SPELL_COMPLETED(successful, enchantedItem)
    if successful and enchantedItem and enchantedItem:IsValid() and enchantedItem:IsEquipmentSlot() then
        C_Timer.After(0.5, function()
            self:UpdateItemLocation(enchantedItem)
        end)
    end
end
Module:RegisterEvent("ENCHANT_SPELL_COMPLETED")
