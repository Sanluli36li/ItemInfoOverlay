local ADDON_NAME, ItemInfoOverlay = ...

local Module = ItemInfoOverlay:NewModule("equipmentSummary")
local Utils = ItemInfoOverlay:GetModule("utils")
local L = ItemInfoOverlay.Locale

local CONFIG_PLAYER_ENABLE = "player.enable"
local CONFIG_INSPECT_ENABLE = "inspect.enable"
local CONFIG_SLOT_NAME = "slotName.enable"
local CONFIG_STAT_ICON = "statIcon.enable"
local CONFIG_STAT_ICON_STYLE = "statIcon.style"
local CONFIG_STAT_ICON_TEXT_OFFSET_X = "statIcon.text.offsetX"
local CONFIG_STAT_ICON_TEXT_OFFSET_Y = "statIcon.text.offsetY"
local CONFIG_STYLE = "style"
local CONFIG_FONT = "font"
local CONFIG_FONT_SIZE = "fontSize"
local CONFIG_TITLE_FONT = "title.font"
local CONFIG_TITLE_FONT_SIZE = "title.fontSize"
local CONFIG_ITEM_SETS = "itemSets.enable"
local CONFIG_ITEM_SETS_UNIQUE = "itemSets.unique"
local CONFIG_ITEM_STATS = "itemStats.enable"
local CONFIG_ITEM_LEVEL_COLOR = "itemLevel.color"
local CONFIG_ITEM_LEVEL_STYLE = "itemLevel.style"
local CONFIG_ITEM_UPGRADE_TRACK = "itemUpgradeTrack.enable"
local CONFIG_ITEM_UPGRADE_TRACK_STYLE = "itemUpgradeTrack.style"
local CONFIG_BACKDROP_ALPHA = "backdrop.alpha"
local CONFIG_ENCHANT_AND_SOCKETS = "enchantAndSockets.enable"

local ITEM_LEVEL_AND_SPEC_FORMAT = "|cffffd200"..ITEM_LEVEL:gsub("%%d", "%%.1f").."|r %s%s%s|r\n "
local ITEM_LEVEL_AND_SPEC_WITH_PVP_FORMAT = "|cffffd200"..ITEM_LEVEL:gsub("%%d", "%%.1f").."|r %s%s%s|r\n|cffffd200"..ITEM_UPGRADE_PVP_ITEM_LEVEL_STAT_FORMAT:gsub("%%d", "%%.1f").."|r\n "
local ITEM_SET_BONUS_PATTERN = ITEM_SET_BONUS:gsub("%%s", "(.+)")
local ITEM_SET_BONUS_GRAY_PATTERN = ITEM_SET_BONUS_GRAY:gsub("%(%%d%)", "%%(%%d+%%)"):gsub("%%s", "(.+)")

local STAT_ICONS_STYLE = {
    ["Armory"] = {
        { type = "texture", r = 224/255, g =  28/255, b =  28/255, texture = "Interface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_Armory\\crit.png", border = true },
        { type = "texture", r =  14/255, g = 213/255, b = 155/255, texture = "Interface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_Armory\\haste.png", border = true },
        { type = "texture", r = 146/255, g =  86/255, b = 255/255, texture = "Interface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_Armory\\mastery.png", border = true },
        { type = "texture", r = 191/255, g = 191/255, b = 191/255, texture = "Interface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_Armory\\versatility.png", border = true }
    },
    ["GearStatSummary"] = {
        { type = "text", r = 255/255, g = 104/255, b =  63/255, text = "爆", style = "", border = true },
        { type = "text", r = 252/255, g = 255/255, b =  23/255, text = "急", style = "", border = true },
        { type = "text", r = 198/255, g =  23/255, b = 255/255, text = "精", style = "", border = true },
        { type = "text", r =  23/255, g =  83/255, b = 191/255, text = "全", style = "", border = true }
    },
    ["GearStatSummaryNoBorder"] = {
        { type = "text", r = 255/255, g = 104/255, b =  63/255, text = "爆", style = "OUTLINE", border = false },
        { type = "text", r = 252/255, g = 255/255, b =  23/255, text = "急", style = "OUTLINE", border = false },
        { type = "text", r = 198/255, g =  23/255, b = 255/255, text = "精", style = "OUTLINE", border = false },
        { type = "text", r =  23/255, g =  83/255, b = 191/255, text = "全", style = "OUTLINE", border = false }
    },
    ["GearStatSummaryEn"] = {
        { type = "text", r = 255/255, g = 104/255, b =  63/255, text = "C", style = "", border = true },
        { type = "text", r = 252/255, g = 255/255, b =  23/255, text = "H", style = "", border = true },
        { type = "text", r = 198/255, g =  23/255, b = 255/255, text = "M", style = "", border = true },
        { type = "text", r =  23/255, g =  83/255, b = 191/255, text = "V", style = "", border = true }
    },
    ["GearStatSummaryEnNoBorder"] = {
        { type = "text", r = 255/255, g = 104/255, b =  63/255, text = "C", style = "OUTLINE", border = false },
        { type = "text", r = 252/255, g = 255/255, b =  23/255, text = "H", style = "OUTLINE", border = false },
        { type = "text", r = 198/255, g =  23/255, b = 255/255, text = "M", style = "OUTLINE", border = false },
        { type = "text", r =  23/255, g =  83/255, b = 191/255, text = "V", style = "OUTLINE", border = false }
    },
}

local STYLE = {
    ["Blizzard"] = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileEdge = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    },
    ["NoBorder"] = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    },
    ["Transparent"] = {
        bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileEdge = true,
        tileSize = 16,
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    }
}

local WIDTH_BY_LOCALE = {
    enUS = {20, 16, 8.9, 6.5, 2.9},
    zhCN = {14.5, 12.5, 5.4, 3.5, 2.9},
    zhTW = {14.5, 12.5, 5.4, 3.5, 2.9},
}

local WIDTH_RATE = WIDTH_BY_LOCALE[GetLocale()] or WIDTH_BY_LOCALE.enUS

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

local preview = false

--------------------
-- Mixin
--------------------
IIOEquipmentSummaryEntryMixin = {}

function IIOEquipmentSummaryEntryMixin:OnLoad()
    self.SlotNameBackdrop:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile     = true,
        tileSize = 8,
        edgeSize = 1,
        insets   = {left = 1, right = 1, top = 1, bottom = 1}
    })
    self.SlotNameBackdrop:SetBackdropBorderColor(0, 0.9, 0.9, 0.2)
    self.SlotNameBackdrop:SetBackdropColor(0, 0.9, 0.9, 0.2)
end

function IIOEquipmentSummaryEntryMixin:UpdateAppearance()
    local _, _, style = GameTooltipText:GetFont()

    self.SlotName:SetFont(Module:GetConfig(CONFIG_FONT), Module:GetConfig(CONFIG_FONT_SIZE), style)
    self.ItemLevel:SetFont(Module:GetConfig(CONFIG_FONT), Module:GetConfig(CONFIG_FONT_SIZE), style)
    self.ItemLink:SetFont(Module:GetConfig(CONFIG_FONT), Module:GetConfig(CONFIG_FONT_SIZE), style)
    self.ItemUpgrade:SetFont(Module:GetConfig(CONFIG_FONT), Module:GetConfig(CONFIG_FONT_SIZE), style)

    local iconStyle = STAT_ICONS_STYLE[Module:GetConfig(CONFIG_STAT_ICON_STYLE)]

    self.CritIcon:SetSize(Module:GetConfig(CONFIG_FONT_SIZE), Module:GetConfig(CONFIG_FONT_SIZE))
    self.CritIcon.Backdrop:SetVertexColor(iconStyle[1].r, iconStyle[1].g, iconStyle[1].b, 1)
    if iconStyle[1].border then
        self.CritIcon.Backdrop:Show()
    else
        self.CritIcon.Backdrop:Hide()
    end
    if iconStyle[1].type == "texture" then
        self.CritIcon.Icon:SetTexture(iconStyle[1].texture)
        self.CritIcon.Icon:Show()
        self.CritIcon.Text:Hide()
    elseif iconStyle[1].type == "text" then
        self.CritIcon.Icon:Hide()
        self.CritIcon.Text:SetPoint("CENTER", self.CritIcon, "CENTER", Module:GetConfig(CONFIG_STAT_ICON_TEXT_OFFSET_X), Module:GetConfig(CONFIG_STAT_ICON_TEXT_OFFSET_Y))
        self.CritIcon.Text:SetFont(Module:GetConfig(CONFIG_FONT), Module:GetConfig(CONFIG_FONT_SIZE) - 1, iconStyle[1].style)
        self.CritIcon.Text:SetText(iconStyle[1].text)
        self.CritIcon.Text:SetTextColor(iconStyle[1].r, iconStyle[1].g, iconStyle[1].b)
        self.CritIcon.Text:Show()
    end

    self.HasteIcon:SetSize(Module:GetConfig(CONFIG_FONT_SIZE), Module:GetConfig(CONFIG_FONT_SIZE))
    self.HasteIcon.Backdrop:SetVertexColor(iconStyle[2].r, iconStyle[2].g, iconStyle[2].b, 1)
    if iconStyle[2].border then
        self.HasteIcon.Backdrop:Show()
    else
        self.HasteIcon.Backdrop:Hide()
    end
    if iconStyle[2].type == "texture" then
        self.HasteIcon.Icon:SetTexture(iconStyle[2].texture)
        self.HasteIcon.Icon:Show()
        self.HasteIcon.Text:Hide()
    elseif iconStyle[2].type == "text" then
        self.HasteIcon.Icon:Hide()
        self.HasteIcon.Text:SetPoint("CENTER", self.HasteIcon, "CENTER", Module:GetConfig(CONFIG_STAT_ICON_TEXT_OFFSET_X), Module:GetConfig(CONFIG_STAT_ICON_TEXT_OFFSET_Y))
        self.HasteIcon.Text:SetFont(Module:GetConfig(CONFIG_FONT), Module:GetConfig(CONFIG_FONT_SIZE) - 1, iconStyle[2].style)
        self.HasteIcon.Text:SetText(iconStyle[2].text)
        self.HasteIcon.Text:SetTextColor(iconStyle[2].r, iconStyle[2].g, iconStyle[2].b)
        self.HasteIcon.Text:Show()
    end

    self.MasteryIcon:SetSize(Module:GetConfig(CONFIG_FONT_SIZE), Module:GetConfig(CONFIG_FONT_SIZE))
    self.MasteryIcon.Backdrop:SetVertexColor(iconStyle[3].r, iconStyle[3].g, iconStyle[3].b, 1)
    if iconStyle[3].border then
        self.MasteryIcon.Backdrop:Show()
    else
        self.MasteryIcon.Backdrop:Hide()
    end
    if iconStyle[3].type == "texture" then
        self.MasteryIcon.Icon:SetTexture(iconStyle[3].texture)
        self.MasteryIcon.Icon:Show()
        self.MasteryIcon.Text:Hide()
    elseif iconStyle[3].type == "text" then
        self.MasteryIcon.Icon:Hide()
        self.MasteryIcon.Text:SetPoint("CENTER", self.MasteryIcon, "CENTER", Module:GetConfig(CONFIG_STAT_ICON_TEXT_OFFSET_X), Module:GetConfig(CONFIG_STAT_ICON_TEXT_OFFSET_Y))
        self.MasteryIcon.Text:SetFont(Module:GetConfig(CONFIG_FONT), Module:GetConfig(CONFIG_FONT_SIZE) - 1, iconStyle[3].style)
        self.MasteryIcon.Text:SetText(iconStyle[3].text)
        self.MasteryIcon.Text:SetTextColor(iconStyle[3].r, iconStyle[3].g, iconStyle[3].b)
        self.MasteryIcon.Text:Show()
    end

    self.VersatilityIcon:SetSize(Module:GetConfig(CONFIG_FONT_SIZE), Module:GetConfig(CONFIG_FONT_SIZE))
    self.VersatilityIcon.Backdrop:SetVertexColor(iconStyle[4].r, iconStyle[4].g, iconStyle[4].b, 1)
    if iconStyle[4].border then
        self.VersatilityIcon.Backdrop:Show()
    else
        self.VersatilityIcon.Backdrop:Hide()
    end
    if iconStyle[4].type == "texture" then
        self.VersatilityIcon.Icon:SetTexture(iconStyle[4].texture)
        self.VersatilityIcon.Icon:Show()
        self.VersatilityIcon.Text:Hide()
    elseif iconStyle[4].type == "text" then
        self.VersatilityIcon.Icon:Hide()
        self.VersatilityIcon.Text:SetPoint("CENTER", self.VersatilityIcon, "CENTER", Module:GetConfig(CONFIG_STAT_ICON_TEXT_OFFSET_X), Module:GetConfig(CONFIG_STAT_ICON_TEXT_OFFSET_Y))
        self.VersatilityIcon.Text:SetFont(Module:GetConfig(CONFIG_FONT), Module:GetConfig(CONFIG_FONT_SIZE) - 1, iconStyle[4].style)
        self.VersatilityIcon.Text:SetText(iconStyle[4].text)
        self.VersatilityIcon.Text:SetTextColor(iconStyle[4].r, iconStyle[4].g, iconStyle[4].b)
        self.VersatilityIcon.Text:Show()
    end

    self:SetHeight(Module:GetConfig(CONFIG_FONT_SIZE))

    if Module:GetConfig(CONFIG_SLOT_NAME) then

        self.CritIcon:ClearAllPoints()
        self.CritIcon:SetPoint("TOPLEFT", self.SlotName, "TOPRIGHT", 2, 0)

        self.SlotName:SetWidth(Module:GetConfig(CONFIG_FONT_SIZE) * 3)

        self.SlotNameBackdrop:Show()

        self.SlotName:Show()
    else
        self.CritIcon:ClearAllPoints()
        self.CritIcon:SetPoint("TOPLEFT", self)
        self.SlotName:Hide()
        self.SlotNameBackdrop:Hide()
    end

    if Module:GetConfig(CONFIG_STAT_ICON) then
        self.ItemLevel:ClearAllPoints()
        self.ItemLevel:SetPoint("TOPLEFT", self.VersatilityIcon, "TOPRIGHT", 4, 0)
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

    self.ItemLink:SetWidth((Module:GetConfig(CONFIG_FONT_SIZE) * (Module:GetConfig(CONFIG_ITEM_UPGRADE_TRACK) and WIDTH_RATE[2] or WIDTH_RATE[1])) - itemLevelWidth)
    self.ItemUpgrade:SetWidth(Module:GetConfig(CONFIG_ITEM_UPGRADE_TRACK) and (WIDTH_RATE[Module:GetConfig(CONFIG_ITEM_UPGRADE_TRACK_STYLE) + 2] * Module:GetConfig(CONFIG_FONT_SIZE)) or 0)
end

function IIOEquipmentSummaryEntryMixin:SetItemFromUnitInventory(unit, slot, itemLink, itemLevel)
    self.unit = unit
    self.slot = slot
    itemLink = itemLink or GetInventoryItemLink(unit, slot)
    if itemLink then

        itemLevel = itemLevel or Utils.GetItemLevelFromTooltipInfo(C_TooltipInfo.GetInventoryItem(unit, slot))

        if itemLevel and Module:GetConfig(CONFIG_ITEM_LEVEL_COLOR) then
            itemLevel = Utils.GetColoredItemLevelText(itemLevel, itemLink)
        end

        -- 从API获取属性, 而非鼠标提示, 避免绿字分布被附魔/宝石污染
        local stats = C_Item.GetItemStats(itemLink)
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

        if Module:GetConfig(CONFIG_ITEM_UPGRADE_TRACK) then
            local itemUpgradeInfo = C_Item.GetItemUpgradeInfo(itemLink)
            if itemUpgradeInfo and itemUpgradeInfo.trackString then
                local level = itemUpgradeInfo.currentLevel.."/"..itemUpgradeInfo.maxLevel

                if itemUpgradeInfo.maxLevel == 0 then
                    -- 过时, 已无法再升级的物品
                    level = "-/-"
                end

                if Module:GetConfig(CONFIG_ITEM_UPGRADE_TRACK_STYLE) == 1 then
                    self.ItemUpgrade:SetText(Utils.GetColoredItemLevelText("["..itemUpgradeInfo.trackString.." "..level.."]", itemLink))
                elseif Module:GetConfig(CONFIG_ITEM_UPGRADE_TRACK_STYLE) == 2 then
                    self.ItemUpgrade:SetText(Utils.GetColoredItemLevelText("["..itemUpgradeInfo.trackString.."]", itemLink))
                elseif Module:GetConfig(CONFIG_ITEM_UPGRADE_TRACK_STYLE) == 3 then
                    self.ItemUpgrade:SetText(Utils.GetColoredItemLevelText("["..level.."]", itemLink))
                end
            elseif string.find(itemLink, "|A:") then
                -- 分离制造物品的品质图标
                local level = string.match(itemLink, "|A:.+|a")
                itemLink = itemLink:gsub("|A:.+|a", "")
                self.ItemUpgrade:SetText(level)
            else
                self.ItemUpgrade:SetText()
            end
        else
            self.ItemUpgrade:SetText()
        end

        self.ItemLink:SetText(itemLink:gsub("[%[%]]", ""))
    else
        self:Clear()
    end
end

function IIOEquipmentSummaryEntryMixin:Clear()
    self:ToggleStats()
    self.ItemLevel:SetText("|cff7f7f7f-|r")
    self.ItemLink:SetText("|cff7f7f7f"..(self.slotName or "-").."|r")
    self.ItemUpgrade:SetText()
end


function IIOEquipmentSummaryEntryMixin:ToggleStats(crit, haste, mastery, versatility)
    if crit then
        self.CritIcon:Show()
    else
        self.CritIcon:Hide()
    end

    if haste then
        self.HasteIcon:Show()
    else
        self.HasteIcon:Hide()
    end

    if mastery then
        self.MasteryIcon:Show()
    else
        self.MasteryIcon:Hide()
    end

    if versatility then
        self.VersatilityIcon:Show()
    else
        self.VersatilityIcon:Hide()
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

    self.slots = {}
    self.slotNum = 0

    local lastRegion = self.SubTitle
    for i, slot in ipairs(EQUIPMENT_SLOTS) do
        local slotId = slot.slotId

        if not self.slots[slotId] then
            self.slots[slotId] = CreateFrame("Frame", nil, self, "IIOEquipmentSummaryEntryTemplate")
        end

        self.slots[slotId]:SetPoint("TOPLEFT", lastRegion, "BOTTOMLEFT", 0, -2)
        self.slots[slotId]:SetPoint("TOPRIGHT", lastRegion, "BOTTOMRIGHT", 0, -2)
        self.slots[slotId]:Show()

        self.slots[slotId].slotName = slot.name
        self.slots[slotId].SlotName:SetText(slot.name)

        self.slotNum = self.slotNum + 1
        lastRegion = self.slots[slotId]
    end

    self.InfoText:SetPoint("TOPLEFT", lastRegion, "BOTTOMLEFT", 0, -10)
    self.InfoText:SetPoint("TOPRIGHT", lastRegion, "BOTTOMRIGHT", 0, -10)

    self.ItemStatsTips:SetScript("OnEnter", function (button)
        GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["equipmentSummary.itemStats.tips.title"])
        GameTooltip:AddLine(L["equipmentSummary.itemStats.tips.line1"], 1, 1, 1)
        if self.level then
            GameTooltip:AddLine(" ")
            local critRating = Utils.GetCombatStatsRatings("ITEM_MOD_CRIT_RATING_SHORT", self.level)
            local hasteRating = Utils.GetCombatStatsRatings("ITEM_MOD_HASTE_RATING_SHORT", self.level)
            local masteryRating = Utils.GetCombatStatsRatings("ITEM_MOD_MASTERY_RATING_SHORT", self.level)
            local versRating = Utils.GetCombatStatsRatings("ITEM_MOD_VERSATILITY", self.level)

            local speedRating = Utils.GetCombatStatsRatings("ITEM_MOD_CR_SPEED_SHORT", self.level)
            local lifestealRating = Utils.GetCombatStatsRatings("ITEM_MOD_CR_LIFESTEAL_SHORT", self.level)
            local avoidRating = Utils.GetCombatStatsRatings("ITEM_MOD_CR_AVOIDANCE_SHORT", self.level)

            GameTooltip:AddLine(format(L["equipmentSummary.itemStats.tips.line2"], self.level))
            GameTooltip:AddDoubleLine(ITEM_MOD_CRIT_RATING_SHORT..": ", (critRating and format("%d", critRating + 0.5)) or L["equipmentSummary.itemStats.tips.unknown"], nil, nil, nil, 1, 1, 1)
            GameTooltip:AddDoubleLine(ITEM_MOD_HASTE_RATING_SHORT..": ", (hasteRating and format("%d", hasteRating + 0.5)) or L["equipmentSummary.itemStats.tips.unknown"], nil, nil, nil, 1, 1, 1)
            GameTooltip:AddDoubleLine(ITEM_MOD_MASTERY_RATING_SHORT..": ", (masteryRating and format("%d", masteryRating + 0.5)) or L["equipmentSummary.itemStats.tips.unknown"], nil, nil, nil, 1, 1, 1)
            GameTooltip:AddDoubleLine(ITEM_MOD_VERSATILITY..": ", (versRating and format("%d", versRating + 0.5)) or L["equipmentSummary.itemStats.tips.unknown"], nil, nil, nil, 1, 1, 1)
            GameTooltip:AddLine(" ")
            GameTooltip:AddDoubleLine(ITEM_MOD_CR_SPEED_SHORT..": ", (versRating and format("%d", speedRating + 0.5)) or L["equipmentSummary.itemStats.tips.unknown"], nil, nil, nil, 1, 1, 1)
            GameTooltip:AddDoubleLine(ITEM_MOD_CR_LIFESTEAL_SHORT..": ", (versRating and format("%d", lifestealRating + 0.5)) or L["equipmentSummary.itemStats.tips.unknown"], nil, nil, nil, 1, 1, 1)
            GameTooltip:AddDoubleLine(ITEM_MOD_CR_AVOIDANCE_SHORT..": ", (versRating and format("%d", avoidRating + 0.5)) or L["equipmentSummary.itemStats.tips.unknown"], nil, nil, nil, 1, 1, 1)
        end

        GameTooltip:Show()
    end)
    self.ItemStatsTips:SetScript("OnLeave", function (button)
        GameTooltip:Hide()
    end)

end

function IIOEquipmentSummaryFrameMixin:OnShow()
    self:Refresh()
end

function IIOEquipmentSummaryFrameMixin:UpdateAppearance()
    if Module:GetConfig(CONFIG_STYLE) == "Auto" then
        if ElvUI or NDui then
            self:SetBackdrop(STYLE["Transparent"])
        else
            self:SetBackdrop(STYLE["Blizzard"])
        end
    else
        self:SetBackdrop(STYLE[Module:GetConfig(CONFIG_STYLE)])
    end

    for i, entry in pairs(self.slots) do
        entry:UpdateAppearance()
    end

    local _, _, style = GameTooltipText:GetFont()
    self.SubTitle:SetFont(Module:GetConfig(CONFIG_FONT), Module:GetConfig(CONFIG_FONT_SIZE), style)

    self.InfoText:SetFont(Module:GetConfig(CONFIG_FONT), Module:GetConfig(CONFIG_FONT_SIZE), style)
    self.ItemStatsText1:SetFont(Module:GetConfig(CONFIG_FONT), Module:GetConfig(CONFIG_FONT_SIZE), style)
    self.ItemStatsText2:SetFont(Module:GetConfig(CONFIG_FONT), Module:GetConfig(CONFIG_FONT_SIZE), style)
    self.ItemStatsText3:SetFont(Module:GetConfig(CONFIG_FONT), Module:GetConfig(CONFIG_FONT_SIZE), style)

    _, _, style = GameTooltipHeaderText:GetFont()
    self.Title:SetFont(Module:GetConfig(CONFIG_TITLE_FONT), Module:GetConfig(CONFIG_TITLE_FONT_SIZE), style)

    self:SetBackdropColor(0, 0, 0, Module:GetConfig(CONFIG_BACKDROP_ALPHA) * 0.01)

    local width = 12
            + (Module:GetConfig(CONFIG_SLOT_NAME) and (Module:GetConfig(CONFIG_FONT_SIZE) * 3 + 2) or 0)
            + (Module:GetConfig(CONFIG_STAT_ICON) and (Module:GetConfig(CONFIG_FONT_SIZE) * 4 + 5) or 0)
            + (Module:GetConfig(CONFIG_FONT_SIZE) * (Module:GetConfig(CONFIG_ITEM_UPGRADE_TRACK) and WIDTH_RATE[2] or WIDTH_RATE[1]))
            + (Module:GetConfig(CONFIG_ITEM_UPGRADE_TRACK) and (Module:GetConfig(CONFIG_FONT_SIZE) * WIDTH_RATE[Module:GetConfig(CONFIG_ITEM_UPGRADE_TRACK_STYLE) + 2]) + 6 or 0)
            + 12

    self:SetWidth(width)

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
        self.level = level
        local className, classFilename = UnitClass(self.unit)
        local classColor = C_ClassColor.GetClassColor(classFilename)

        if classColor then
            self:SetBackdropBorderColor(classColor:GetRGBA())
            self.Title:SetTextColor(classColor:GetRGB())
        end

        self.Title:SetText(name)

        local primaryStat
        local totalStats = {}

        local numItemSets = 0
        local itemSets = {}
        local itemSetsBonus = {}
        local itemUnique = {}

        local totalItemLevel, totalPvpItemLevel = 0, 0
        local hasEnchantNum, maxEnchantNum = 0, 0
        local gemNum, socketNum = 0, 0

        for i, entry in pairs(self.slots) do
            local link = GetInventoryItemLink(self.unit, i)

            if link then
                local itemName, _, itemQuality, _, itemMinLevel, itemType, itemSubType,
                itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
                expacID, setID, isCraftingReagent = C_Item.GetItemInfo(link)

                local tooltipInfo = C_TooltipInfo.GetInventoryItem(self.unit, i)
                local itemLevel, currentItemLevel, pvpItemLevel = Utils.GetItemLevelFromTooltipInfo(tooltipInfo)

                if itemLevel then
                    totalItemLevel = totalItemLevel + itemLevel
                    totalPvpItemLevel = totalPvpItemLevel + (pvpItemLevel or itemLevel)
                end

                -- 从鼠标提示中获取物品属性, 以获得正确的主属性及附魔、宝石提供的属性
                -- C_Item.GetItemStats(link)
                local stats, pstat = Utils.GetItemStatsFromTooltipInfo(tooltipInfo)

                if stats then
                    for stat, value in pairs(stats) do
                        totalStats[stat] = (totalStats[stat] or 0) + value
                    end
                end
                -- 主要属性
                if not primaryStat and pstat then
                    primaryStat = pstat
                end

                -- 附魔和插槽数量检查
                local canEnchant = Utils.ItemCanEnchant(itemLevel, itemEquipLoc)
                local hasEnchant
                local numItemSetBonus, maxItemSetBonus = 0, 0
                if tooltipInfo then
                    for i, line in pairs(tooltipInfo.lines) do
                        if line.type == Enum.TooltipDataLineType.ItemEnchantmentPermanent then
                            hasEnchant = true
                        elseif line.type == Enum.TooltipDataLineType.GemSocket then
                            socketNum = socketNum + 1
                        elseif line.leftText:match(ITEM_SET_BONUS_PATTERN) then
                            if not line.leftText:match(ITEM_SET_BONUS_GRAY_PATTERN) then
                                numItemSetBonus = numItemSetBonus + 1
                            end
                            maxItemSetBonus = maxItemSetBonus + 1
                        end
                    end
                end

                if canEnchant then
                    maxEnchantNum = maxEnchantNum + 1
                    if hasEnchant then
                        hasEnchantNum = hasEnchantNum + 1
                    end
                end

                -- 宝石检查
                for j = 1, 3 do
                    local gemID = C_Item.GetItemGemID(link, j)

                    if gemID then
                        gemNum = gemNum + 1

                        -- 如果有未加载的宝石，则在加载后刷新
                        local gemItem = Item:CreateFromItemID(gemID)

                        if not gemItem:IsItemDataCached() then
                            gemItem:ContinueOnItemLoad(function()
                                self:Refresh()
                            end)
                        end
                    end
                end

                -- 套装物品
                if Module:GetConfig(CONFIG_ITEM_SETS) then
                    -- 套装物品
                    if setID then
                        if itemSets[setID] then
                            itemSets[setID] = itemSets[setID] + 1
                            itemSetsBonus[setID] = {numItemSetBonus, maxItemSetBonus}
                        else
                            itemSets[setID] = 1
                            itemSetsBonus[setID] = {numItemSetBonus, maxItemSetBonus}
                            numItemSets = numItemSets + 1
                        end
                    end
                    -- 装备唯一物品
                    local isUnique, limitCategoryName, limitCategoryCount, limitCategoryID = Utils.GetItemUniquenessByID(link)
                    if Module:GetConfig(CONFIG_ITEM_SETS_UNIQUE) and isUnique and limitCategoryID then
                        if limitCategoryCount > 1 then  -- 忽略仅能装备一件的装备唯一分类
                            if itemUnique[limitCategoryID] then
                                itemUnique[limitCategoryID][1] = itemUnique[limitCategoryID][1] + 1
                            else
                                itemUnique[limitCategoryID] = { 1, limitCategoryName, limitCategoryCount}
                                numItemSets = numItemSets + 1
                            end
                        end
                    end
                end

                if Module:GetConfig(CONFIG_ITEM_LEVEL_STYLE) == 2 then
                    -- 使用PvP物品等级
                    entry:SetItemFromUnitInventory(self.unit, i, link, pvpItemLevel)
                elseif Module:GetConfig(CONFIG_ITEM_LEVEL_STYLE) == 1 and currentItemLevel == pvpItemLevel then
                    -- 随PvP状态动态调整
                    entry:SetItemFromUnitInventory(self.unit, i, link, pvpItemLevel)
                else
                    entry:SetItemFromUnitInventory(self.unit, i, link, itemLevel)
                end

            else
                if i == 16 or i == 17 then
                    link = GetInventoryItemLink(self.unit, i== 17 and 16 or 17)
                    if link then
                        local loc = select(9, C_Item.GetItemInfo(link))
                        if loc == "INVTYPE_2HWEAPON" or loc == "INVTYPE_RANGED" or loc == "INVTYPE_RANGEDRIGHT" then
                            local itemLevel, _, pvpItemLevel = Utils.GetItemLevelFromTooltipInfo(C_TooltipInfo.GetInventoryItem(self.unit, i == 17 and 16 or 17))

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

        self:RefreshItemLevelAndSpec(totalItemLevel / 16, totalPvpItemLevel / 16, specName)

        local text = ""

        if Module:GetConfig(CONFIG_ENCHANT_AND_SOCKETS) then
            text = text..format("|cffffd200%s: |r|c%s%d|r / %d    |cffffd200%s: |r|c%s%d|r / %d\n",
            GetItemClassInfo(8), hasEnchantNum == maxEnchantNum and "ff00ff00" or "ffff0000", hasEnchantNum, maxEnchantNum,
            GetItemClassInfo(3), gemNum == socketNum and "ff00ff00" or "ffff0000", gemNum, socketNum)
            text = text.."\n"
        end

        if numItemSets > 0 then
            text = text..format("|cffffd200%s:|r\n", LOOT_JOURNAL_ITEM_SETS)

            for id, num in pairs(itemSets) do
                local setName = C_Item.GetItemSetInfo(id)
                local maxNum = #C_LootJournal.GetItemSetItems(id)
                local color = "ffffffff"
                if itemSetsBonus[id] then
                    if itemSetsBonus[id][1] == 0 then
                        color = "ffff0000"
                    elseif itemSetsBonus[id][1] == itemSetsBonus[id][2] then
                        color = "ff00ff00"
                    else
                        color = "ffffff00"
                    end
                end

                if setName then
                    text = text..format("    %s (|c%s%d|r/%d)\n", setName, color, num, maxNum)
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

            text = text.."\n"
        end

        self.InfoText:SetText(text)

        if Module:GetConfig(CONFIG_ITEM_STATS) then
            local critBonus, critBonus2 = Utils.CalculateStatsRatings("ITEM_MOD_CRIT_RATING_SHORT", totalStats.ITEM_MOD_CRIT_RATING_SHORT, level)
            local hasteBonus, hasteBonus2 = Utils.CalculateStatsRatings("ITEM_MOD_HASTE_RATING_SHORT", totalStats.ITEM_MOD_HASTE_RATING_SHORT, level)
            local masteryBonus, masteryBonus2 = Utils.CalculateStatsRatings("ITEM_MOD_MASTERY_RATING_SHORT", totalStats.ITEM_MOD_MASTERY_RATING_SHORT, level)
            local versBonus, versBonus2 = Utils.CalculateStatsRatings("ITEM_MOD_VERSATILITY", totalStats.ITEM_MOD_VERSATILITY, level)
            local masteryCoefficient = (self.unit == "player" and select(2, GetMasteryEffect()))

            local text1 = (
                format("|cffffd200%s:|r\n", L["equipmentSummary.equipmentStats"])..
                format("    %s: \n", _G[primaryStat] or L["equipmentSummary.mainStat"])..
                format("    %s: \n", ITEM_MOD_STAMINA_SHORT.."")..
                format("    %s: \n", ITEM_MOD_CRIT_RATING_SHORT.."")..
                format("    %s: \n", ITEM_MOD_HASTE_RATING_SHORT)..
                format("    %s: \n", ITEM_MOD_MASTERY_RATING_SHORT)..
                format("    %s: \n", ITEM_MOD_VERSATILITY)
            )
            local text2 = ( -- 属性数值
                "\n"..
                format("|cffffffff%d|r\n", totalStats[primaryStat] or 0)..
                format("|cffffffff%d|r\n", totalStats.ITEM_MOD_STAMINA_SHORT or 0)..
                format("|cff00ff00%d|r\n", totalStats.ITEM_MOD_CRIT_RATING_SHORT or 0)..
                format("|cff00ff00%d|r\n", totalStats.ITEM_MOD_HASTE_RATING_SHORT or 0)..
                format("|cff00ff00%d|r\n", totalStats.ITEM_MOD_MASTERY_RATING_SHORT or 0)..
                format("|cff00ff00%d|r\n", totalStats.ITEM_MOD_VERSATILITY or 0)
            )
            local text3 = ( -- 属性百分比
                "\n\n\n"..
                format(" |c%s%s|r\n", (critBonus2 and "ffffff00") or "ff00ff00", (critBonus and format("%.1f%%", critBonus)) or "")..
                format(" |c%s%s|r\n", (hasteBonus2 and "ffffff00") or "ff00ff00", (hasteBonus and format("%.1f%%", hasteBonus)) or "")..
                format(" |c%s%s|r%s\n", (masteryBonus2 and "ffffff00") or "ff00ff00", (masteryBonus and format("%.1f%%", masteryBonus)) or "", (masteryCoefficient and format(" (x%.2f)", masteryCoefficient) or ""))..
                format(" |c%s%s|r\n", (versBonus2 and "ffffff00") or "ff00ff00", (versBonus and format("%.1f%%|cff7f7f7f/|r%.1f%%", versBonus, versBonus / 2)) or "")
            )

            -- 次要属性 (加速 吸血 闪避)
            if totalStats.ITEM_MOD_CR_SPEED_SHORT and totalStats.ITEM_MOD_CR_SPEED_SHORT > 0 then
                local bonus, bonus2 = Utils.CalculateStatsRatings("ITEM_MOD_CR_SPEED_SHORT", totalStats.ITEM_MOD_CR_SPEED_SHORT, level)
                text1 = text1..format("    %s: \n", ITEM_MOD_CR_SPEED_SHORT)
                text2 = text2..format("|cff007fff%d|r\n", totalStats.ITEM_MOD_CR_SPEED_SHORT or 0)
                text3 = text3..format(" |c%s%s|r\n", (bonus2 and "ffffff00") or "ff007fff", (bonus and format("%.1f%%", bonus)) or "")
            end
            if totalStats.ITEM_MOD_CR_LIFESTEAL_SHORT and totalStats.ITEM_MOD_CR_LIFESTEAL_SHORT > 0 then
                local bonus, bonus2 = Utils.CalculateStatsRatings("ITEM_MOD_CR_LIFESTEAL_SHORT", totalStats.ITEM_MOD_CR_LIFESTEAL_SHORT, level)
                text1 = text1..format("    %s: \n", ITEM_MOD_CR_LIFESTEAL_SHORT)
                text2 = text2..format("|cff007fff%d|r\n", totalStats.ITEM_MOD_CR_LIFESTEAL_SHORT or 0)
                text3 = text3..format(" |c%s%s|r\n", (bonus2 and "ffffff00") or "ff007fff", (bonus and format("%.1f%%", bonus)) or "")
            end
            if totalStats.ITEM_MOD_CR_AVOIDANCE_SHORT and totalStats.ITEM_MOD_CR_AVOIDANCE_SHORT > 0 then
                local bonus, bonus2 = Utils.CalculateStatsRatings("ITEM_MOD_CR_AVOIDANCE_SHORT", totalStats.ITEM_MOD_CR_AVOIDANCE_SHORT, level)
                text1 = text1..format("    %s: \n", ITEM_MOD_CR_AVOIDANCE_SHORT)
                text2 = text2..format("|cff007fff%d|r\n", totalStats.ITEM_MOD_CR_AVOIDANCE_SHORT or 0)
                text3 = text3..format(" |c%s%s|r\n", (bonus2 and "ffffff00") or "ff007fff", (bonus and format("%.1f%%", bonus)) or "")
            end

            self.ItemStatsText1:SetText(text1)
            self.ItemStatsText2:SetText(text2)
            self.ItemStatsText3:SetText(text3)
            self.ItemStatsTips:Show()
        else
            self.ItemStatsText1:SetText()
            self.ItemStatsText2:SetText()
            self.ItemStatsText3:SetText()
            self.ItemStatsTips:Hide()
        end

        local height = 12
            + self.Title:GetStringHeight()
            + 10
            + self.SubTitle:GetStringHeight()
            + (self.slotNum * (Module:GetConfig(CONFIG_FONT_SIZE) + 2))
            + 10
            + self.InfoText:GetStringHeight()
            + self.ItemStatsText1:GetStringHeight()
            + 12

        self:SetHeight(height)
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

    if preview then
        IIOEquipmentSummaryPlayerFrame:Show()
        IIOEquipmentSummaryPlayerFrame:ClearAllPoints()
        IIOEquipmentSummaryPlayerFrame:SetParent(SettingsPanel)
        IIOEquipmentSummaryPlayerFrame:SetPoint("TOPLEFT", SettingsPanel, "TOPRIGHT", 2, 0)
    elseif Module:GetConfig(CONFIG_INSPECT_ENABLE) and InspectFrame and InspectFrame:IsVisible() then
        IIOEquipmentSummaryInspectFrame:Show()

        if Module:GetConfig(CONFIG_PLAYER_ENABLE) then
            IIOEquipmentSummaryPlayerFrame:Show()
            IIOEquipmentSummaryPlayerFrame:ClearAllPoints()
            IIOEquipmentSummaryPlayerFrame:SetParent(IIOEquipmentSummaryInspectFrame)
            IIOEquipmentSummaryPlayerFrame:SetPoint("TOPLEFT", IIOEquipmentSummaryInspectFrame, "TOPRIGHT", 2, 0)
        end

        if PaperDollFrame:IsVisible() then
            IIOEquipmentSummaryInspectFrame:ClearAllPoints()
            IIOEquipmentSummaryInspectFrame:SetParent(PaperDollFrame)
            IIOEquipmentSummaryInspectFrame:SetPoint("TOPLEFT", characterRelative, "TOPRIGHT", 2, 0)
        else
            IIOEquipmentSummaryInspectFrame:ClearAllPoints()
            IIOEquipmentSummaryInspectFrame:SetParent(InspectFrame)
            IIOEquipmentSummaryInspectFrame:SetPoint("TOPLEFT", InspectFrame, "TOPRIGHT", 2, 0)
        end
    elseif Module:GetConfig(CONFIG_PLAYER_ENABLE) and PaperDollFrame:IsVisible() then
        IIOEquipmentSummaryInspectFrame:Hide()
        IIOEquipmentSummaryPlayerFrame:Show()

        IIOEquipmentSummaryPlayerFrame:ClearAllPoints()
        IIOEquipmentSummaryPlayerFrame:SetParent(PaperDollFrame)
        IIOEquipmentSummaryPlayerFrame:SetPoint("TOPLEFT", characterRelative, "TOPRIGHT", 2, 0)
    else
        IIOEquipmentSummaryInspectFrame:Hide()
        IIOEquipmentSummaryPlayerFrame:Hide()
    end

end

IIOEquipmentSummarySettingPreviewMixin = {}

function IIOEquipmentSummarySettingPreviewMixin:OnLoad()
end

function IIOEquipmentSummarySettingPreviewMixin:OnShow()
    preview = true
    UpdateSummaryPoints()
end

function IIOEquipmentSummarySettingPreviewMixin:OnHide()
    preview = false
    UpdateSummaryPoints()
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
    IIOEquipmentSummaryPlayerFrame:Refresh()
end
Module:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_UPDATE")

-- 玩家专精改变: 更新装等和专精
function Module:ACTIVE_PLAYER_SPECIALIZATION_CHANGED()
    IIOEquipmentSummaryPlayerFrame:Refresh()
end
Module:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")
