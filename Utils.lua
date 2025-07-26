local ADDON_NAME, ItemInfoOverlay = ...

local Utils = ItemInfoOverlay:NewModule("utils")

--------------------
--- 框体
--------------------
function Utils.GetItemInfoOverlay(frame)
    if not frame.ItemInfoOverlay then
        return ItemInfoOverlay:GetModule("itemInfoOverlay"):CreateItemInfoOverlay(frame)
    else
        return frame.ItemInfoOverlay
    end
end

--------------------
--- 链接解析
--------------------
function Utils.GetLinkTypeAndID(link)
    -- 返回: 链接分类, 元数据, ID, 显示内容
    return strmatch(link, "\124c[\\a-zA-Z0-9:]+\124H([A-Za-z]+):(([0-9]+):[^\124]+)\124h(%b[])\124h\124r")
end

local ITEM_LINK_FORMAT = {
    "itemID",
    "enchantID",
    "gemID1",
    "gemID2",
    "gemID3",
    "gemID4",
    "suffixID",
    "uniqueID",
    "linkLevel",
    "specializationID",
    "modifierMask",
    "itemContext",
    { "bonusIDs", 1 },
    { "modifiers", 2, true },
    { "relic1BonuIDs", 1 },
    { "relic2BonuIDs", 1 },
    { "relic3BonuIDs", 1 },
    { "crafterGUID", "string" },
    "extraEnchantID"
}

function Utils.GetItemLinkDataTable(link)
    local linkType, meta, id, name = Utils.GetLinkTypeAndID(link)
    if linkType == "item" then
        local splited = { strsplit(":", meta) }
        local table = {}

        local i = 1
        for _, data in ipairs(ITEM_LINK_FORMAT) do
            if type(data) == "string" then
                table[data] = tonumber(splited[i])
            elseif type(data) == "table" then
                if type(data[2]) == "number" then
                    local num = tonumber(splited[i])
                    if num and num > 0 then
                        table[data[1]] = {}
                        for j = 1, num do
                            local key = (data[3] and tonumber(splited[i + 1])) or j

                            if data[2] == 1 then
                                table[data[1]][key] = tonumber(splited[i + 1])
                            else
                                table[data[1]][key] = {}
                                for k = 1, data[2] do
                                    table[data[1]][key][k] = tonumber(splited[i + k])
                                end
                            end
                            i = i + data[2]
                        end
                    end
                elseif data[2] == "string" then
                    table[data[1]] = splited[i]
                end
            end
            i = i + 1
        end
        return table
    end
end

--------------------
--- 鼠标提示信息解析
--------------------
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

local ITEM_STATS = {
    "ITEM_MOD_STRENGTH_SHORT",          -- 力量
    "ITEM_MOD_AGILITY_SHORT",           -- 敏捷
    "ITEM_MOD_INTELLECT_SHORT",         -- 智力
    "ITEM_MOD_STAMINA_SHORT",           -- 耐力
    "ITEM_MOD_CRIT_RATING_SHORT",       -- 爆击
    "ITEM_MOD_HASTE_RATING_SHORT",      -- 急速
    "ITEM_MOD_MASTERY_RATING_SHORT",    -- 精通
    "ITEM_MOD_VERSATILITY",             -- 全能
    "ITEM_MOD_CR_SPEED_SHORT",          -- 加速
    "ITEM_MOD_CR_LIFESTEAL_SHORT",      -- 吸血
    "ITEM_MOD_CR_AVOIDANCE_SHORT",      -- 闪避
}

function Utils.GetItemStatsFromTooltipInfo(tooltipInfo)
    if tooltipInfo and tooltipInfo.lines then
        local primaryStat
        local stats = {}

        for _, line in ipairs(tooltipInfo.lines) do
            local lineText = line.leftText:gsub("[, ]", "")
            for i, stat in ipairs(ITEM_STATS) do
                local value = tonumber(lineText:match("%+([0-9]+)".._G[stat]:gsub(" ", "")))
                local color = line.leftColor:GenerateHexColorNoAlpha()

                if value and color ~= "808080" then
                    if not primaryStat and line.type == Enum.TooltipDataLineType.None and (stat == "ITEM_MOD_STRENGTH_SHORT" or stat == "ITEM_MOD_AGILITY_SHORT" or stat == "ITEM_MOD_INTELLECT_SHORT") then
                        primaryStat = stat
                    end

                    stats[stat] = (stats[stat] or 0) + value
                end
            end
        end
        return stats, primaryStat
    end
end

--------------------
--- RGB转换
--------------------
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
        if itemQuality then
            r, g, b = C_Item.GetItemQualityColor(itemQuality)
        else
            r, g, b = Utils.GetRGBAFromHexColor(ItemInfoOverlay:GetConfig("color.itemLevel.custom"))
        end
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

    -- 低等级物品染色
    if type(itemLevel) == "number" and ItemInfoOverlay:GetConfig("color.itemLevel.lowLevel") then
        local itemQuality = C_Item.GetItemQualityByID(itemLink)
        if itemQuality < 5 and itemLevel < select(1, GetAverageItemLevel()) - ItemInfoOverlay:GetConfig("color.itemLevel.lowLevel.threshold") then
            -- 传说品质以下 / 物品等级 < 最高平均物品等级 - 设置的等级差
            r, g, b = Utils.GetRGBAFromHexColor(ItemInfoOverlay:GetConfig("color.itemLevel.lowLevel.color"))
        end 
    end

    return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, itemLevel)
end

--------------------
--- 属性递减计算
--------------------

local COMBAT_RATING_DECREASING = {  -- 递减曲线: 爆击, 急速, 精通, 全能
    { 200, 126, 0 },
    { 80, 66, 0.5 },
    { 60, 54, 0.6 },
    { 50, 47, 0.7 },
    { 40, 39, 0.8 },
    { 30, 30, 0.9 },
}

local COMBAT_RATING_DECREASING2 = { -- 递减曲线: 加速, 吸血, 闪避
    {100, 49, 0},
    {20, 17, 0.4},
    {15, 14, 0.6},
    {10, 10, 0.8},
}

local COMBAT_RATINGS = {
    ITEM_MOD_CRIT_RATING_SHORT = { CR_CRIT_SPELL, COMBAT_RATING_DECREASING },
    ITEM_MOD_HASTE_RATING_SHORT = { CR_HASTE_SPELL, COMBAT_RATING_DECREASING },
    ITEM_MOD_MASTERY_RATING_SHORT = { CR_MASTERY, COMBAT_RATING_DECREASING },
    ITEM_MOD_VERSATILITY = { CR_VERSATILITY_DAMAGE_DONE, COMBAT_RATING_DECREASING },
    ITEM_MOD_CR_SPEED_SHORT = { CR_SPEED, COMBAT_RATING_DECREASING2 },
    ITEM_MOD_CR_LIFESTEAL_SHORT = { CR_LIFESTEAL, COMBAT_RATING_DECREASING2 },
    ITEM_MOD_CR_AVOIDANCE_SHORT = { CR_AVOIDANCE, COMBAT_RATING_DECREASING2 }
}

local function UpdateCombatStatsRatings()
    local statsRatings = ItemInfoOverlay:GetConfig("statsRatings")

    if not statsRatings then
        statsRatings = {}
        ItemInfoOverlay:SetConfig("statsRatings", statsRatings)
    end

    statsRatings[UnitLevel("player")] = {}

    for i, stat in pairs(COMBAT_RATINGS) do
        -- 这好用多了
        statsRatings[UnitLevel("player")][i] = 1 /  GetCombatRatingBonusForCombatRatingValue(stat[1], 1)
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

function Utils.CalculateStatsRatings(stat, statNum, level)
    local statsRatings = ItemInfoOverlay:GetConfig("statsRatings")
    if not level then
        level = UnitLevel("player")
    end

    if statNum and statNum > 0 and statsRatings and statsRatings[level] and statsRatings[level][stat] then
        local bonus = statNum / statsRatings[level][stat]
        -- 递减计算
        local decreasing = COMBAT_RATINGS[stat] and COMBAT_RATINGS[stat][2]
        if decreasing then
            for i, data in ipairs(decreasing) do
                if bonus > data[1] then
                    return (bonus - data[1]) * data[3] + data[2], bonus
                end
            end
        end

        return bonus
    end
end

function Utils:AfterLogin()
    UpdateCombatStatsRatings()
end

function Utils:PLAYER_LEVEL_CHANGED()
    UpdateCombatStatsRatings()
end
Utils:RegisterEvent("PLAYER_LEVEL_CHANGED")
