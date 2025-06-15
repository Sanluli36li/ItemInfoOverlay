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
local CONFIG_ITEM_SETS = "itemSets.enable"
local CONFIG_ITEM_SETS_UNIQUE = "itemSets.unique"
local CONFIG_ITEM_STATS = "itemStats.enable"

local ITEM_LEVEL_AND_SPEC_FORMAT = "|cffffd200"..ITEM_LEVEL:gsub("%%d", "%%.1f").."|r %s%s%s|r\n "
local ITEM_LEVEL_AND_SPEC_WITH_PVP_FORMAT = "|cffffd200"..ITEM_LEVEL:gsub("%%d", "%%.1f").."|r %s%s%s|r\n|cffffd200"..ITEM_UPGRADE_PVP_ITEM_LEVEL_STAT_FORMAT:gsub("%%d", "%%.1f").."|r\n "

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
IIOEquipmentSummaryEntryMixin = {}

function IIOEquipmentSummaryEntryMixin:OnLoad()
    self:UpdateAppearance()
end

function IIOEquipmentSummaryEntryMixin:UpdateAppearance()
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

function IIOEquipmentSummaryEntryMixin:SetItemFromUnitInventory(unit, slot, itemLink, itemLevel, stats)
    self.unit = unit
    self.slot = slot
    itemLink = itemLink or GetInventoryItemLink(unit, slot)
    if itemLink then
        itemLevel = itemLevel or Utils.GetItemLevelFromTooltipInfo(C_TooltipInfo.GetInventoryItem(unit, slot))

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

function IIOEquipmentSummaryEntryMixin:Clear()
    self:ToggleStats()
    self.ItemLevel:SetText("|cff7f7f7f-|r")
    self.ItemLink:SetText("|cff7f7f7f"..(self.slotName or "-").."|r")
end


function IIOEquipmentSummaryEntryMixin:ToggleStats(crit, haste, mastery, versatility)
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

function IIOEquipmentSummaryEntryMixin:OnEnter()
    if self.unit and self.slot then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetInventoryItem(self.unit, self.slot)

        GameTooltip:Show()
    end
end

function IIOEquipmentSummaryEntryMixin:OnLeave()
    GameTooltip:Hide()
end

IIOEquipmentSummaryFrameMixin = {}

function IIOEquipmentSummaryFrameMixin:OnLoad()
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

    if ElvUI then
        self:SetTemplate("Transparent")
    end

    self.slots = {}
    self.slotNum = 0

    self.equipmentSets = {}

    local lastRegion = self.SubTitle
    for i, slot in ipairs(EQUIPMENT_SLOTS) do
        local slotId = slot.slotId

        if not self.slots[slotId] then
            self.slots[slotId] = CreateFrame("Frame", nil, self, "IIOEquipmentSummaryEntryTemplate")
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

function IIOEquipmentSummaryFrameMixin:OnShow()
    self:Refresh()
end

function IIOEquipmentSummaryFrameMixin:UpdateAppearance()
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

function IIOEquipmentSummaryFrameMixin:SetUnit(unit)
    self.unit = unit
    self:Refresh()
end

function IIOEquipmentSummaryFrameMixin:Refresh()
    if not self:IsShown() then return end
    if self.unit then
        local name = UnitNameUnmodified(self.unit)
        local level = UnitLevel(self.unit)
        local className, classFilename = UnitClass(self.unit)
        local classColor = C_ClassColor.GetClassColor(classFilename)

        if classColor then
            self:SetBackdropBorderColor(classColor:GetRGBA())
            self.Title:SetTextColor(classColor:GetRGB())
        end

        self.Title:SetText(name)

        local totalMainStat = 0
        local totalStats = {}
        local numItemSets = 0
        local itemSets = {}
        local itemUnique = {}

        local totalItemLevel = 0
        local totalPvpItemLevel = 0

        for i, entry in pairs(self.slots) do
            local link = GetInventoryItemLink(self.unit, i)
            if link then
                local itemLevel, _, pvpItemLevel = Utils.GetItemLevelFromTooltipInfo(C_TooltipInfo.GetInventoryItem(self.unit, i))

                if itemLevel then
                    totalItemLevel = totalItemLevel + itemLevel
                    totalPvpItemLevel = totalPvpItemLevel + (pvpItemLevel or itemLevel)
                end

                local stats = C_Item.GetItemStats(link)
                if stats then
                    for stat, value in pairs(stats) do
                        totalStats[stat] = (totalStats[stat] or 0) + value
                    end
                    totalMainStat = totalMainStat + (stats.ITEM_MOD_STRENGTH_SHORT or stats.ITEM_MOD_AGILITY_SHORT or stats.ITEM_MOD_INTELLECT_SHORT or 0)
                end

                if Module:GetConfig(CONFIG_ITEM_SETS) then
                    local itemSet = select(16, C_Item.GetItemInfo(link))

                    if itemSet then
                        if itemSets[itemSet] then
                            itemSets[itemSet] = itemSets[itemSet] + 1
                        else
                            itemSets[itemSet] = 1
                            numItemSets = numItemSets + 1
                        end
                    end

                    local isUnique, limitCategoryName, limitCategoryCount, limitCategoryID = C_Item.GetItemUniquenessByID(link)
                    if Module:GetConfig(CONFIG_ITEM_SETS_UNIQUE) and isUnique and limitCategoryID then
                        if itemUnique[limitCategoryID] then
                            itemUnique[limitCategoryID][1] = itemUnique[limitCategoryID][1] + 1
                        else
                            itemUnique[limitCategoryID] = { 1, limitCategoryName, limitCategoryCount}
                            numItemSets = numItemSets + 1
                        end
                    end
                end

                entry:SetItemFromUnitInventory(self.unit, i, link, itemLevel, stats)
            else
                if i == 17 then
                    link = GetInventoryItemLink(self.unit, 16)
                    if link then
                        local loc = select(9, C_Item.GetItemInfo(link))
                        if loc == "INVTYPE_2HWEAPON" or loc == "INVTYPE_RANGED" or loc == "INVTYPE_RANGEDRIGHT" then
                            local itemLevel, _, pvpItemLevel = Utils.GetItemLevelFromTooltipInfo(C_TooltipInfo.GetInventoryItem(self.unit, 16))

                            if itemLevel then
                                totalItemLevel = totalItemLevel + itemLevel
                                totalPvpItemLevel = totalPvpItemLevel + (pvpItemLevel or itemLevel)
                            end
                        end
                        
                    end
                    
                end

                entry:Clear()
            end
        end

        self:RefreshItemLevelAndSpec(totalItemLevel / 16, totalPvpItemLevel / 16)

        local text = ""

        if numItemSets > 0 then
            text = text..format("|cffffd200%s:|r\n", LOOT_JOURNAL_ITEM_SETS)
            for id, num in pairs(itemSets) do
                local setName = C_Item.GetItemSetInfo(id)
                local maxNum = #C_LootJournal.GetItemSetItems(id)
                if setName then
                    text = text..format("    %s (%s)\n", setName, (maxNum and num.."/"..maxNum) or num)
                end
            end

            for id, data in pairs(itemUnique) do
                local num = data[1]
                local setName = data[2]
                local maxNum = data[3]
                if setName then
                    text = text..format("    %s (%s)\n", setName, (maxNum and num.."/"..maxNum) or num)
                end
            end
        end

        if Module:GetConfig(CONFIG_ITEM_STATS) then
            if numItemSets > 0 then
                text = text.."\n"
            end

            local critRating = Utils.GetCombatStatsRatings("ITEM_MOD_CRIT_RATING_SHORT", level)
            local hastRating = Utils.GetCombatStatsRatings("ITEM_MOD_HASTE_RATING_SHORT", level)
            local mastRating = Utils.GetCombatStatsRatings("ITEM_MOD_MASTERY_RATING_SHORT", level)
            local versRating = Utils.GetCombatStatsRatings("ITEM_MOD_VERSATILITY", level)

            text = text..format("|cffffd200%s:|r\n", L["equipmentSummary.equipmentStats"])
            text = text..format("    %s: %d\n", L["equipmentSummary.mainStat"], totalMainStat)         -- 主属性
            text = text..format("    %s: %d\n", ITEM_MOD_STAMINA_SHORT, totalStats.ITEM_MOD_STAMINA_SHORT or 0)   -- 耐力
            text = text..format("    %s: |cff00ff00%d%s|r\n", ITEM_MOD_CRIT_RATING_SHORT, totalStats.ITEM_MOD_CRIT_RATING_SHORT or 0, (critRating and totalStats.ITEM_MOD_CRIT_RATING_SHORT and format("|cff7f7f7f/|r%d%%", totalStats.ITEM_MOD_CRIT_RATING_SHORT / critRating)) or "")             -- 爆击
            text = text..format("    %s: |cff00ff00%d%s|r\n", ITEM_MOD_HASTE_RATING_SHORT, totalStats.ITEM_MOD_HASTE_RATING_SHORT or 0, (hastRating and totalStats.ITEM_MOD_HASTE_RATING_SHORT and format("|cff7f7f7f/|r%d%%", totalStats.ITEM_MOD_HASTE_RATING_SHORT / hastRating)) or "")         -- 急速
            text = text..format("    %s: |cff00ff00%d%s|r\n", ITEM_MOD_MASTERY_RATING_SHORT, totalStats.ITEM_MOD_MASTERY_RATING_SHORT or 0, (mastRating and totalStats.ITEM_MOD_MASTERY_RATING_SHORT and format("|cff7f7f7f/|r%d%%", totalStats.ITEM_MOD_MASTERY_RATING_SHORT / mastRating)) or "") -- 精通
            text = text..format("    %s: |cff00ff00%d%s|r\n", ITEM_MOD_VERSATILITY, totalStats.ITEM_MOD_VERSATILITY or 0, (versRating and totalStats.ITEM_MOD_VERSATILITY and format("|cff7f7f7f/|r%d%%", totalStats.ITEM_MOD_VERSATILITY / versRating)) or "")                                     -- 全能
            if totalStats.ITEM_MOD_CR_SPEED_SHORT and totalStats.ITEM_MOD_CR_SPEED_SHORT > 0 then
                text = text..format("    %s: |cff007fff%d|r\n", ITEM_MOD_CR_SPEED_SHORT, totalStats.ITEM_MOD_CR_SPEED_SHORT or 0)         -- 加速
            end
            if totalStats.ITEM_MOD_CR_LIFESTEAL_SHORT and totalStats.ITEM_MOD_CR_LIFESTEAL_SHORT > 0 then
                text = text..format("    %s: |cff007fff%d|r\n", ITEM_MOD_CR_LIFESTEAL_SHORT, totalStats.ITEM_MOD_CR_LIFESTEAL_SHORT or 0) -- 吸血
            end
            if totalStats.ITEM_MOD_CR_AVOIDANCE_SHORT and totalStats.ITEM_MOD_CR_AVOIDANCE_SHORT > 0 then
                text = text..format("    %s: |cff007fff%d|r\n", ITEM_MOD_CR_AVOIDANCE_SHORT, totalStats.ITEM_MOD_CR_AVOIDANCE_SHORT or 0) -- 闪避
            end
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

function IIOEquipmentSummaryFrameMixin:RefreshItemLevelAndSpec(itemLevel, pvpItemLevel)
    local className, classFilename = UnitClass(self.unit)
    local classColor = C_ClassColor.GetClassColor(classFilename)
    local hexColorMarkup = "|cfffffff"
    
    if classColor then
        hexColorMarkup = classColor:GenerateHexColorMarkup()
    end

    local specName, specIcon
    if self.unit == "player" then
        if not itemLevel then
            _, itemLevel = GetAverageItemLevel()
        end
        _, specName, _, specIcon  = GetSpecializationInfo(GetSpecialization())
    else
        if not itemLevel then
            itemLevel = C_PaperDollInfo.GetInspectItemLevel(self.unit)
        end
        _, specName, _, specIcon  = GetSpecializationInfoForSpecID(GetInspectSpecialization(self.unit))
    end

    if pvpItemLevel and pvpItemLevel > itemLevel then
        self.SubTitle:SetFormattedText(ITEM_LEVEL_AND_SPEC_WITH_PVP_FORMAT, itemLevel, hexColorMarkup, specName or "", className, pvpItemLevel)
    else
        self.SubTitle:SetFormattedText(ITEM_LEVEL_AND_SPEC_FORMAT, itemLevel, hexColorMarkup, specName or "", className)
    end

    if specIcon then
        self.SpecIcon:SetTexture(specIcon)
        self.SpecIcon:Show()
    else
        self.SpecIcon:Hide()
    end
end

local function UpdateSummaryPoints()
    local characterRelative = CharacterFrame
    if CCS_TOAST then
        characterRelative = CharacterFrameBg
    end

    if Module:GetConfig(CONFIG_INSPECT_ENABLE) and InspectFrame and InspectFrame:IsVisible() then
        IIOEquipmentSummaryInspectFrame:Show()

        if Module:GetConfig(CONFIG_PLAYER_ENABLE) then
            IIOEquipmentSummaryPlayerFrame:Show()
            IIOEquipmentSummaryPlayerFrame:ClearAllPoints()
            IIOEquipmentSummaryPlayerFrame:SetParent(IIOEquipmentSummaryInspectFrame)
            IIOEquipmentSummaryPlayerFrame:SetPoint("TOPLEFT", IIOEquipmentSummaryInspectFrame, "TOPRIGHT")
        end

        if PaperDollFrame:IsVisible() then
            IIOEquipmentSummaryInspectFrame:ClearAllPoints()
            IIOEquipmentSummaryInspectFrame:SetParent(PaperDollFrame)
            IIOEquipmentSummaryInspectFrame:SetPoint("TOPLEFT", characterRelative, "TOPRIGHT")
        else
            IIOEquipmentSummaryInspectFrame:ClearAllPoints()
            IIOEquipmentSummaryInspectFrame:SetParent(InspectFrame)
            IIOEquipmentSummaryInspectFrame:SetPoint("TOPLEFT", InspectFrame, "TOPRIGHT")
        end
    elseif Module:GetConfig(CONFIG_PLAYER_ENABLE) and PaperDollFrame:IsVisible() then
        IIOEquipmentSummaryInspectFrame:Hide()
        IIOEquipmentSummaryPlayerFrame:Show()

        IIOEquipmentSummaryPlayerFrame:ClearAllPoints()
        IIOEquipmentSummaryPlayerFrame:SetParent(PaperDollFrame)
        IIOEquipmentSummaryPlayerFrame:SetPoint("TOPLEFT", characterRelative, "TOPRIGHT")
    else
        IIOEquipmentSummaryInspectFrame:Hide()
        IIOEquipmentSummaryPlayerFrame:Hide()
    end
end

PaperDollFrame:HookScript("OnShow", function(self)
    IIOEquipmentSummaryPlayerFrame:Refresh()
    UpdateSummaryPoints()
end)

PaperDollFrame:HookScript("OnHide", function(self)
    UpdateSummaryPoints()
end)

function Module:AfterLogin()
    IIOEquipmentSummaryPlayerFrame:UpdateAppearance()
    IIOEquipmentSummaryPlayerFrame:SetUnit("player")
end

function Module:ADDON_LOADED(AddOnName)
    if AddOnName == "Blizzard_InspectUI" then
        IIOEquipmentSummaryInspectFrame:UpdateAppearance()

        hooksecurefunc("InspectPaperDollFrame_UpdateButtons", function ()
            IIOEquipmentSummaryInspectFrame:SetUnit(InspectFrame.unit)
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
    IIOEquipmentSummaryPlayerFrame:Refresh()
end
Module:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

-- 玩家物品栏更新: 刷新总览
function Module:UNIT_INVENTORY_CHANGED(unit)
    if unit == "player" then
        IIOEquipmentSummaryPlayerFrame:Refresh()
    end
end
Module:RegisterEvent("UNIT_INVENTORY_CHANGED")

-- 平均装等更新: 更新装等和专精
function Module:PLAYER_AVG_ITEM_LEVEL_UPDATE()
    -- IIOEquipmentSummaryPlayerFrame:RefreshItemLevelAndSpec()
end
Module:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_UPDATE")

-- 玩家专精改变: 更新装等和专精
function Module:ACTIVE_PLAYER_SPECIALIZATION_CHANGED()
    IIOEquipmentSummaryPlayerFrame:Refresh()
end
Module:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")
