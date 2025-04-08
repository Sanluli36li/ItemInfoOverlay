local ADDON_NAME, ItemInfoOverlay = ...

local Module = ItemInfoOverlay:NewModule("equipmentSummary")
local Utils = ItemInfoOverlay:GetModule("utils")
local L = ItemInfoOverlay.Locale
local SharedMedia = LibStub("LibSharedMedia-3.0")

local CONFIG_PLAYER_ENABLE = "player.enable"
local CONFIG_INSPECT_ENABLE = "inspect.enable"
local CONFIG_SLOT_NAME = "slotName.enable"
local CONFIG_STAT_ICON = "statIcon.enable"
local CONFIG_STAT_ICON_STYLE = "statIcon.style"
local CONFIG_FONT_SIZE = "fontSize"
local CONFIG_TITLE_FONT_SIZE = "title.fontSize"

local STAT_ICONS = {
    ["Armory"] = {
        "Interface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_Armory\\crit.png",
        "Interface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_Armory\\haste.png",
        "Interface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_Armory\\mastery.png",
        "Interface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_Armory\\versatility.png"
    },
    ["GearStatSummary"] = {
        "Interface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_GearStatSummary\\crit.tga",
        "Interface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_GearStatSummary\\haste.tga",
        "Interface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_GearStatSummary\\mastery.tga",
        "Interface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_GearStatSummary\\vers.tga"
    },
}

local EQUIPMENT_SLOTS = {
    {slotId = 1, name = HEADSLOT},
    {slotId = 2, name = NECKSLOT},
    {slotId = 3, name = SHOULDERSLOT},
    {slotId = 15, name = BACKSLOT},
    {slotId = 5, name = CHESTSLOT},
    {slotId = 9, name = WRISTSLOT},
    {slotId = 10, name = HANDSSLOT},
    {slotId = 6, name = WAISTSLOT},
    {slotId = 7, name = LEGSSLOT},
    {slotId = 8, name = FEETSLOT},
    {slotId = 11, name = FINGER0SLOT},
    {slotId = 12, name = FINGER1SLOT},
    {slotId = 13, name = TRINKET0SLOT},
    {slotId = 14, name = TRINKET1SLOT},
    {slotId = 16, name = MAINHANDSLOT},
    {slotId = 17, name = SECONDARYHANDSLOT}
}

--------------------
-- Mixin
--------------------
SanluliEquipmentSummaryEntryMixin = {}

function SanluliEquipmentSummaryEntryMixin:OnLoad()
    self:UpdateAppearance()
end

function SanluliEquipmentSummaryEntryMixin:UpdateAppearance()
    local font, size, style = GameTooltipText:GetFont()
    self.SlotName:SetFont(font, Module:GetConfig(CONFIG_FONT_SIZE), style)
    self.ItemLevel:SetFont(font, Module:GetConfig(CONFIG_FONT_SIZE), style)
    self.ItemLink:SetFont(font, Module:GetConfig(CONFIG_FONT_SIZE), style)

    self.Crit:SetSize(Module:GetConfig(CONFIG_FONT_SIZE), Module:GetConfig(CONFIG_FONT_SIZE))
    self.Crit:SetTexture(STAT_ICONS[Module:GetConfig(CONFIG_STAT_ICON_STYLE)][1])

    self.Haste:SetSize(Module:GetConfig(CONFIG_FONT_SIZE), Module:GetConfig(CONFIG_FONT_SIZE))
    self.Haste:SetTexture(STAT_ICONS[Module:GetConfig(CONFIG_STAT_ICON_STYLE)][2])

    self.Mastery:SetSize(Module:GetConfig(CONFIG_FONT_SIZE), Module:GetConfig(CONFIG_FONT_SIZE))
    self.Mastery:SetTexture(STAT_ICONS[Module:GetConfig(CONFIG_STAT_ICON_STYLE)][3])

    self.Versatility:SetSize(Module:GetConfig(CONFIG_FONT_SIZE), Module:GetConfig(CONFIG_FONT_SIZE))
    self.Versatility:SetTexture(STAT_ICONS[Module:GetConfig(CONFIG_STAT_ICON_STYLE)][4])

    self:SetHeight(Module:GetConfig(CONFIG_FONT_SIZE) + 2)

    if Module:GetConfig(CONFIG_SLOT_NAME) then
        self.Crit:ClearAllPoints()
        self.Crit:SetPoint("TOPLEFT", self.SlotName, "TOPRIGHT", 2, 0)

        self.SlotName:Show()
    else
        self.Crit:ClearAllPoints()
        self.Crit:SetPoint("TOPLEFT", self)
        self.SlotName:Hide()
    end

    if Module:GetConfig(CONFIG_STAT_ICON) then
        self.ItemLevel:ClearAllPoints()
        self.ItemLevel:SetPoint("TOPLEFT", self.Versatility, "TOPRIGHT", 4, 0)
    else
        self.ItemLevel:ClearAllPoints()
        self.ItemLevel:SetPoint(
            "TOPLEFT",
            (Module:GetConfig(CONFIG_SLOT_NAME) and self.SlotName) or self,
            (Module:GetConfig(CONFIG_SLOT_NAME) and "TOPRIGHT") or "TOPLEFT",
            (Module:GetConfig(CONFIG_SLOT_NAME) and 2) or 0,
            0
        )
        self:ToggleStats()
    end

    local temp = self.ItemLevel:GetText()

    -- 重新计算宽度
    self.ItemLevel:SetText("1000")
    local itemLevelWidth = self.ItemLevel:GetUnboundedStringWidth()
    self.ItemLevel:SetWidth(itemLevelWidth)
    self.ItemLevel:SetText(temp)

    self.ItemLink:SetWidth((Module:GetConfig(CONFIG_FONT_SIZE) * 14) - itemLevelWidth)
end

function SanluliEquipmentSummaryEntryMixin:SetItemFromUnitInventory(unit, slot, itemLink, itemLevel, stats)
    self.unit = unit
    self.slot = slot
    itemLink = itemLink or GetInventoryItemLink(unit, slot)
    if itemLink then
        itemLevel = itemLevel or Utils:GetItemLevelFromTooltipInfo(C_TooltipInfo.GetInventoryItem(unit, slot))

        stats = stats or C_Item.GetItemStats(itemLink)
        if Module:GetConfig(CONFIG_STAT_ICON) and stats then
            self:ToggleStats(
                stats.ITEM_MOD_CRIT_RATING_SHORT and stats.ITEM_MOD_CRIT_RATING_SHORT > 0,
                stats.ITEM_MOD_HASTE_RATING_SHORT and stats.ITEM_MOD_HASTE_RATING_SHORT > 0,
                stats.ITEM_MOD_MASTERY_RATING_SHORT and stats.ITEM_MOD_MASTERY_RATING_SHORT > 0,
                stats.ITEM_MOD_VERSATILITY and stats.ITEM_MOD_VERSATILITY > 0
            )
        else
            self:ToggleStats()
        end

        self.ItemLevel:SetText(itemLevel)
        self.ItemLink:SetText(itemLink:gsub("[%[%]]", ""))
    else
        self:ToggleStats()
        self.ItemLevel:SetText("-")
        self.ItemLink:SetText("-")
    end
end

function SanluliEquipmentSummaryEntryMixin:Clear()
    self:ToggleStats()
    self.ItemLevel:SetText("|cff7f7f7f-|r")
    self.ItemLink:SetText("|cff7f7f7f"..(self.slotName or "-").."|r")
end


function SanluliEquipmentSummaryEntryMixin:ToggleStats(crit, haste, mastery, versatility)
    if crit then
        self.Crit:Show()
    else
        self.Crit:Hide()
    end

    if haste then
        self.Haste:Show()
    else
        self.Haste:Hide()
    end

    if mastery then
        self.Mastery:Show()
    else
        self.Mastery:Hide()
    end

    if versatility then
        self.Versatility:Show()
    else
        self.Versatility:Hide()
    end
end

function SanluliEquipmentSummaryEntryMixin:OnEnter()
    if self.unit and self.slot then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetInventoryItem(self.unit, self.slot)

        GameTooltip:Show()
    end
end

function SanluliEquipmentSummaryEntryMixin:OnLeave()
    GameTooltip:Hide()
end

SanluliEquipmentSummaryFrameMixin = {}

function SanluliEquipmentSummaryFrameMixin:OnLoad()
    BackdropTemplateMixin.OnBackdropLoaded(self)
    self:SetBackdrop({
        bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileEdge = true,
        tileSize = 0,
        edgeSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })

    self.slots = {}
    self.slotNum = 0

    self.equipmentSets = {}

    local lastRegion = self.SubTitle
    for i, slot in ipairs(EQUIPMENT_SLOTS) do
        local slotId = slot.slotId

        if not self.slots[slotId] then
            self.slots[slotId] = CreateFrame("Frame", nil, self, "SanluliEquipmentSummaryEntryTemplate")
        end

        self.slots[slotId]:SetPoint("TOPLEFT", lastRegion, "BOTTOMLEFT")
        self.slots[slotId]:SetPoint("TOPRIGHT", lastRegion, "BOTTOMRIGHT")
        self.slots[slotId]:Show()

        self.slots[slotId].slotName = slot.name
        self.slots[slotId].SlotName:SetText(slot.name)

        self.slotNum = self.slotNum + 1
        lastRegion = self.slots[slotId]
    end
end

function SanluliEquipmentSummaryFrameMixin:OnShow()
    self:Refresh()
end

function SanluliEquipmentSummaryFrameMixin:UpdateAppearance()
    for i, entry in pairs(self.slots) do
        entry:UpdateAppearance()
    end

    local font, size, style = GameTooltipText:GetFont()
    self.SubTitle:SetFont(font, Module:GetConfig(CONFIG_FONT_SIZE), style)
    self.Text:SetFont(font, Module:GetConfig(CONFIG_FONT_SIZE), style)

    font, size, style = GameTooltipHeaderText:GetFont()
    self.Title:SetFont(font, Module:GetConfig(CONFIG_TITLE_FONT_SIZE), style)

    self:Refresh()
end

function SanluliEquipmentSummaryFrameMixin:SetUnit(unit)
    self.unit = unit
    self:Refresh()
end

function SanluliEquipmentSummaryFrameMixin:Refresh()
    if not self:IsShown() then return end
    if self.unit then
        local name = UnitNameUnmodified(self.unit)
        local className, classFilename = UnitClass(self.unit)
        local classColor = C_ClassColor.GetClassColor(classFilename)

        if classColor then
            self:SetBackdropBorderColor(classColor:GetRGBA())
            self.Title:SetTextColor(classColor:GetRGB())
        end

        self.Title:SetText(name)
        self:RefreshItemLevelAndSpec()

        local totalMainStat = 0
        local totalStats = {}
        local numItemSets = 0
        local itemSets = {}

        for i, entry in pairs(self.slots) do
            local link = GetInventoryItemLink(self.unit, i)
            if link then
                local stats = C_Item.GetItemStats(link)
                if stats then
                    for stat, value in pairs(stats) do
                        totalStats[stat] = (totalStats[stat] or 0) + value
                    end
                    totalMainStat = totalMainStat + (stats.ITEM_MOD_STRENGTH_SHORT or stats.ITEM_MOD_AGILITY_SHORT or stats.ITEM_MOD_INTELLECT_SHORT or 0)
                end

                local itemSet = select(16, C_Item.GetItemInfo(link))

                if itemSet then
                    if itemSets[itemSet] then
                        itemSets[itemSet] = itemSets[itemSet] + 1
                    else
                        itemSets[itemSet] = 1
                        numItemSets = numItemSets + 1
                    end
                end

                local iLvl = Utils:GetItemLevelFromTooltipInfo(C_TooltipInfo.GetInventoryItem(self.unit, i)) or GetDetailedItemLevelInfo(link)
                entry:SetItemFromUnitInventory(self.unit, i, link, iLvl, stats)
            else
                entry:Clear()
            end
        end

        local text = ""

        if numItemSets > 0 then
            text = text..format("|cffffd200%s:|r\n", LOOT_JOURNAL_ITEM_SETS)
            for setID, num in pairs(itemSets) do
                local setName = C_Item.GetItemSetInfo(setID)
                local maxNum = #C_LootJournal.GetItemSetItems(setID)
                if setName then
                    text = text..format("    %s (%s)\n", setName, (maxNum and num.."/"..maxNum) or num)
                end
            end
            text = text.."\n"
        end
        
        text = text..format("|cffffd200%s:|r\n", L["equipmentSummary.equipmentStats"])
        text = text..format("    %s: %d\n", L["equipmentSummary.mainStat"], totalMainStat)         -- 主属性
        text = text..format("    %s: %d\n", ITEM_MOD_STAMINA_SHORT, totalStats.ITEM_MOD_STAMINA_SHORT or 0)   -- 耐力
        text = text..format("    %s: |cff00ff00%d|r\n", ITEM_MOD_CRIT_RATING_SHORT, totalStats.ITEM_MOD_CRIT_RATING_SHORT or 0)       -- 爆击
        text = text..format("    %s: |cff00ff00%d|r\n", ITEM_MOD_HASTE_RATING_SHORT, totalStats.ITEM_MOD_HASTE_RATING_SHORT or 0)     -- 急速
        text = text..format("    %s: |cff00ff00%d|r\n", ITEM_MOD_MASTERY_RATING_SHORT, totalStats.ITEM_MOD_MASTERY_RATING_SHORT or 0) -- 精通
        text = text..format("    %s: |cff00ff00%d|r\n", ITEM_MOD_VERSATILITY, totalStats.ITEM_MOD_VERSATILITY or 0)                   -- 全能
        if totalStats.ITEM_MOD_CR_SPEED_SHORT and totalStats.ITEM_MOD_CR_SPEED_SHORT > 0 then
            text = text..format("    %s: |cff007fff%d|r\n", ITEM_MOD_CR_SPEED_SHORT, totalStats.ITEM_MOD_CR_SPEED_SHORT or 0)         -- 加速
        end
        if totalStats.ITEM_MOD_CR_LIFESTEAL_SHORT and totalStats.ITEM_MOD_CR_LIFESTEAL_SHORT > 0 then
            text = text..format("    %s: |cff007fff%d|r\n", ITEM_MOD_CR_LIFESTEAL_SHORT, totalStats.ITEM_MOD_CR_LIFESTEAL_SHORT or 0) -- 吸血
        end
        if totalStats.ITEM_MOD_CR_AVOIDANCE_SHORT and totalStats.ITEM_MOD_CR_AVOIDANCE_SHORT > 0 then
            text = text..format("    %s: |cff007fff%d|r\n", ITEM_MOD_CR_AVOIDANCE_SHORT, totalStats.ITEM_MOD_CR_AVOIDANCE_SHORT or 0) -- 闪避
        end

        self.Text:SetText(text)

        -- local width = math.max(self.Text:GetStringWidth() + self.Title:GetStringWidth())
        local height = 12
            + self.Title:GetStringHeight()
            + 10
            + self.SubTitle:GetStringHeight()
            + (self.slotNum * (Module:GetConfig(CONFIG_FONT_SIZE) + 2))
            + 10
            + self.Text:GetStringHeight()
            + 12
        local width = 12
            + (Module:GetConfig(CONFIG_SLOT_NAME) and 42 or 0)
            + (Module:GetConfig(CONFIG_STAT_ICON) and (Module:GetConfig(CONFIG_FONT_SIZE) * 4 + 8) or 0)
            + (Module:GetConfig(CONFIG_FONT_SIZE) * 14)
            + 12
        self:SetSize(width, height)
    else

    end
end

function SanluliEquipmentSummaryFrameMixin:RefreshItemLevelAndSpec()
    local className, classFilename = UnitClass(self.unit)
    local classColor = C_ClassColor.GetClassColor(classFilename)
    local hexColorMarkup = "|cfffffff"
    
    if classColor then
        hexColorMarkup = classColor:GenerateHexColorMarkup()
    end

    local specName, itemLevel, specIcon
    if self.unit == "player" then
        _, itemLevel = GetAverageItemLevel()
        _, specName, _, specIcon  = GetSpecializationInfo(GetSpecialization())
    else
        itemLevel = C_PaperDollInfo.GetInspectItemLevel(self.unit)
        _, specName, _, specIcon  = GetSpecializationInfoForSpecID(GetInspectSpecialization("target"))
    end

    if specIcon then
        self.SpecIcon:SetTexture(specIcon)
        self.SpecIcon:Show()
    else
        self.SpecIcon:Hide()
    end

    self.SubTitle:SetFormattedText("|cffffd200"..ITEM_LEVEL.."|r %s%s%s|r ".."|n ", itemLevel, hexColorMarkup, specName or "", className)
end

local function UpdateSummaryPoints()
    if Module:GetConfig(CONFIG_INSPECT_ENABLE) and InspectFrame and InspectFrame:IsVisible() then
        EquipmentSummaryInspectFrame:Show()

        if Module:GetConfig(CONFIG_PLAYER_ENABLE) then
            EquipmentSummaryPlayerFrame:Show()
            EquipmentSummaryPlayerFrame:ClearAllPoints()
            EquipmentSummaryPlayerFrame:SetPoint("TOPLEFT", EquipmentSummaryInspectFrame, "TOPRIGHT")
        end

        if CharacterFrame:IsVisible() then
            EquipmentSummaryInspectFrame:ClearAllPoints()
            EquipmentSummaryInspectFrame:SetPoint("TOPLEFT", CharacterFrame, "TOPRIGHT")
        else
            EquipmentSummaryInspectFrame:ClearAllPoints()
            EquipmentSummaryInspectFrame:SetPoint("TOPLEFT", InspectFrame, "TOPRIGHT")
        end
    elseif Module:GetConfig(CONFIG_PLAYER_ENABLE) and CharacterFrame:IsVisible() then
        EquipmentSummaryInspectFrame:Hide()
        EquipmentSummaryPlayerFrame:Show()

        EquipmentSummaryPlayerFrame:ClearAllPoints()
        EquipmentSummaryPlayerFrame:SetPoint("TOPLEFT", CharacterFrame, "TOPRIGHT")
    else
        EquipmentSummaryInspectFrame:Hide()
        EquipmentSummaryPlayerFrame:Hide()
    end
end

hooksecurefunc(CharacterFrame, "Show", function(self)
    EquipmentSummaryPlayerFrame:Refresh()
    UpdateSummaryPoints()
end)

hooksecurefunc(CharacterFrame, "Hide", function(self)
    UpdateSummaryPoints()
end)

function Module:AfterStartup()
    EquipmentSummaryPlayerFrame:UpdateAppearance()
    EquipmentSummaryPlayerFrame:SetUnit("player")
end

function Module:ADDON_LOADED(AddOnName)
    if AddOnName == "Blizzard_InspectUI" then
        EquipmentSummaryInspectFrame:UpdateAppearance()

        hooksecurefunc("InspectPaperDollFrame_UpdateButtons", function ()
            EquipmentSummaryInspectFrame:SetUnit(InspectFrame.unit)
            UpdateSummaryPoints()
        end)

        hooksecurefunc(InspectFrame, "Hide", function ()
            UpdateSummaryPoints()
        end)
    end
end
Module:RegisterEvent("ADDON_LOADED")

-- 装备变更: 刷新总览
function Module:PLAYER_EQUIPMENT_CHANGED()
    EquipmentSummaryPlayerFrame:Refresh()
end
Module:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

-- 玩家物品栏更新: 刷新总览
function Module:UNIT_INVENTORY_CHANGED(unit)
    if unit == "player" then
        EquipmentSummaryPlayerFrame:Refresh()
    end
end
Module:RegisterEvent("UNIT_INVENTORY_CHANGED")

-- 平均装等更新: 更新装等和专精
function Module:PLAYER_AVG_ITEM_LEVEL_UPDATE()
    EquipmentSummaryPlayerFrame:RefreshItemLevelAndSpec()
end
Module:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_UPDATE")

-- 玩家专精改变: 更新装等和专精
function Module:ACTIVE_PLAYER_SPECIALIZATION_CHANGED()
    EquipmentSummaryPlayerFrame:RefreshItemLevelAndSpec()
end
Module:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")
