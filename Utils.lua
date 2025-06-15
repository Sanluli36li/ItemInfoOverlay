local ADDON_NAME, ItemInfoOverlay = ...

local Utils = ItemInfoOverlay:NewModule("utils")

function Utils.GetItemInfoOverlay(frame)
    if not frame.ItemInfoOverlay then
        return ItemInfoOverlay:GetModule("itemInfoOverlay"):CreateItemInfoOverlay(frame)
    else
        return frame.ItemInfoOverlay
    end
end

local PVP_ITEM_LEVEL_TOOLTIP_PATTERN = PVP_ITEM_LEVEL_TOOLTIP:gsub("%%d", "(%%d+)")

function Utils.GetItemLevelFromTooltipInfo(tooltipInfo)
    if tooltipInfo and tooltipInfo.lines then
        local itemLevel, currentItemLevel, pvpItemLevel
        for _, line in ipairs(tooltipInfo.lines) do
            if line.type == Enum.TooltipDataLineType.ItemLevel then
                itemLevel = line.actualItemLevel or line.itemLevel
                currentItemLevel = line.itemLevel
            elseif not pvpItemLevel and line.leftText:match(PVP_ITEM_LEVEL_TOOLTIP_PATTERN) then
                pvpItemLevel = line.leftText:match(PVP_ITEM_LEVEL_TOOLTIP_PATTERN)
            end
        end

        return tonumber(itemLevel), tonumber(currentItemLevel), tonumber(pvpItemLevel)
    end
end

local TRACK_STRING_ID_MYTH = 978
local TRACK_STRING_ID_HERO = 974
local TRACK_STRING_ID_CHAMPION = 973
local TRACK_STRING_ID_VETERAN = 972
local TRACK_STRING_ID_ADVENTURER = 971
local TRACK_STRING_ID_EXPLORER = 970

function Utils.GetColoredItemLevelText(itemLevel, itemLink, isPvP)
    local r, g, b = 1, 1, 1

    if ItemInfoOverlay:GetConfig("color.itemLevel") == 1 then
        -- 固定颜色
        r, g, b = Utils.GetRGBAFromHexColor(ItemInfoOverlay:GetConfig("color.itemLevel.custom"))
    elseif ItemInfoOverlay:GetConfig("color.itemLevel") == 2 then
        -- 基于物品品质染色
        local itemQuality = C_Item.GetItemQualityByID(itemLink)
        r, g, b = C_Item.GetItemQualityColor(itemQuality)
    end

    if C_Item.IsEquippableItem(itemLink) and ItemInfoOverlay:GetConfig("color.itemLevel.itemUpgrade") then
        local itemUpgradeInfo = C_Item.GetItemUpgradeInfo(itemLink)

        if itemUpgradeInfo and itemUpgradeInfo.trackStringID then
            -- 基于物品升级等级染色
            if itemUpgradeInfo.trackStringID == TRACK_STRING_ID_MYTH or (isPvP and itemUpgradeInfo.trackStringID == TRACK_STRING_ID_CHAMPION) then
                -- 神话(662-678) / PvP勇士(678)
                r, g, b = Utils.GetRGBAFromHexColor(ItemInfoOverlay:GetConfig("color.itemLevel.itemUpgrade.myth"))
            elseif itemUpgradeInfo.trackStringID == TRACK_STRING_ID_HERO or (isPvP and itemUpgradeInfo.trackStringID == TRACK_STRING_ID_VETERAN) then
                -- 英雄(649-665) / PvP老兵(675)
                r, g, b = Utils.GetRGBAFromHexColor(ItemInfoOverlay:GetConfig("color.itemLevel.itemUpgrade.hero"))
            elseif itemUpgradeInfo.trackStringID == TRACK_STRING_ID_CHAMPION or (isPvP and itemUpgradeInfo.trackStringID == TRACK_STRING_ID_EXPLORER) then
                -- 勇士(636-658) / PvP探索者(665)
                r, g, b = Utils.GetRGBAFromHexColor(ItemInfoOverlay:GetConfig("color.itemLevel.itemUpgrade.champion"))
            elseif itemUpgradeInfo.trackStringID == TRACK_STRING_ID_VETERAN then
                -- 老兵(623-645)
                r, g, b = Utils.GetRGBAFromHexColor(ItemInfoOverlay:GetConfig("color.itemLevel.itemUpgrade.veteran"))
            elseif itemUpgradeInfo.trackStringID == TRACK_STRING_ID_ADVENTURER or itemUpgradeInfo.trackStringID == TRACK_STRING_ID_EXPLORER then
                -- 探索者 / 冒险者
                r, g, b = Utils.GetRGBAFromHexColor(ItemInfoOverlay:GetConfig("color.itemLevel.itemUpgrade.explorer"))
            end
        end
    end

    return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, itemLevel)
end

function Utils.GetLinkTypeAndID(link)
    return strmatch(link, "\124c[\\a-zA-Z0-9:]+\124H([A-Za-z]+):(([0-9]+):[^\124]+)\124h(%b[])\124h\124r")
end

function Utils.GetRGBAFromHexColor(hex)
    if strsub(hex, 1, 1) ~= "#" then
        return 1, 1, 1, 1
    end

    local len = string.len(hex)
    local r, g, b, a = 1, 1, 1, 1
    if len == 7 then
        r = (tonumber(strsub(hex, 2, 3), 16) or 255) / 255
        g = (tonumber(strsub(hex, 4, 5), 16) or 255) / 255
        b = (tonumber(strsub(hex, 6, 7), 16) or 255) / 255
    elseif len == 9 then
        r = (tonumber(strsub(hex, 2, 3), 16) or 255) / 255
        g = (tonumber(strsub(hex, 4, 5), 16) or 255) / 255
        b = (tonumber(strsub(hex, 6, 7), 16) or 255) / 255
        a = (tonumber(strsub(hex, 8, 9), 16) or 255) / 255
    end

    return r, g, b, a
end

local COMBAT_STATS = {
    ITEM_MOD_CRIT_RATING_SHORT = CR_CRIT_SPELL,
    ITEM_MOD_HASTE_RATING_SHORT = CR_HASTE_SPELL,
    ITEM_MOD_MASTERY_RATING_SHORT = CR_MASTERY,
    ITEM_MOD_VERSATILITY = CR_VERSATILITY_DAMAGE_DONE,
}

local function UpdateCombatStatsRatings()
    local statsRatings = ItemInfoOverlay:GetConfig("statsRatings")

    if not statsRatings then
        statsRatings = {}
        ItemInfoOverlay:SetConfig("statsRatings", statsRatings)
    end

    statsRatings[UnitLevel("player")] = {}

    for i, stat in pairs(COMBAT_STATS) do
        local bonus = GetCombatRatingBonus(stat)
        -- 计算递减前应有的数值
        if bonus > 0 then   -- 绿字率应当大于0, 否则无法计算
            if bonus >= 125 then
                -- 当绿字大于125%时，因完全溢出无收益的绿字已经无法计算，故只能取递减前的最大值 200%
                bonus = 200
            elseif bonus > 60 then
                bonus = ((bonus - 60) / 0.5) + 70
            elseif bonus > 54 then
                bonus = ((bonus - 54) / 0.6) + 60
            elseif bonus > 47 then
                bonus = ((bonus - 47) / 0.7) + 50
            elseif bonus > 39 then
                bonus = ((bonus - 39) / 0.8) + 40
            elseif bonus > 30 then
                bonus = ((bonus - 30) / 0.9) + 30
            end

            statsRatings[UnitLevel("player")][i] = GetCombatRating(stat) / bonus
        else
            -- 当完全没有此项绿字时，无法计算转化率，故忽略
        end
    end
end

function Utils.GetCombatStatsRatings(stat, level)
    local statsRatings = ItemInfoOverlay:GetConfig("statsRatings")
    if not level then
        level = UnitLevel("player")
    end

    if statsRatings and statsRatings[level] then
        return statsRatings[level][stat]
    end
end

function Utils:AfterLogin()
    UpdateCombatStatsRatings()
end

function Utils:PLAYER_LEVEL_CHANGED()
    UpdateCombatStatsRatings()
end
Utils:RegisterEvent("PLAYER_LEVEL_CHANGED")
