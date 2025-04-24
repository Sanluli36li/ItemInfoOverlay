local ADDON_NAME, ItemInfoOverlay = ...

local Module = ItemInfoOverlay:NewModule("tooltip")
local L = ItemInfoOverlay.Locale

local CONFIG_ITEM_LEVEL = "itemLevel.enable"

local playerItemLevelCache = { }

local itemLevelLine
local isBlzInspecting
local isIIOInspecting
local lastInspectTime
local lastInspectGuid
local added

local function SearchUnitFromGUID(guid)
    if UnitGUID("target") == guid then
        return "target"
    elseif UnitGUID("mouseover") == guid then
        return "mouseover"
    elseif IsInGroup() and not IsInRaid() then
        for i = 1, 4 do
            if UnitGUID("party"..i) == guid then
                return "party"..i
            end
        end
    elseif IsInRaid() then
        for i = 1, 40 do
            if UnitGUID("raid"..i) == guid then
                return "raid"..i
            end
        end
    end
end

hooksecurefunc(GameTooltip, "Show", function (self)
    if Module:GetConfig(CONFIG_ITEM_LEVEL) then
        if added then return end
        itemLevelLine = nil
        if self:IsTooltipType(Enum.TooltipDataType.Unit) then
            local name, unit, guid = TooltipUtil.GetDisplayedUnit(self)

            if UnitIsPlayer(unit) then
                if not UnitIsUnit("player", unit) then
                    if playerItemLevelCache[guid] then
                        self:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL..":", playerItemLevelCache[guid][2], nil, nil, nil, 1, 1, 1)
                        itemLevelLine = _G[self:GetName() .. "TextRight"..self:NumLines()]
                        added = true
                    else
                        self:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL..":", "...", nil, nil, nil, 1, 1, 1)
                        itemLevelLine = _G[self:GetName() .. "TextRight"..self:NumLines()]
                        added = true
                    end
                end
            end
        end
        GameTooltip_CalculatePadding(self)
    end
end)

hooksecurefunc(GameTooltip, "ClearLines", function (self)
    added = false
end)

hooksecurefunc("InspectUnit", function (unit)
    -- print("InspectUnit:", unit, UnitGUID(unit))
    isBlzInspecting = true
    isIIOInspecting = false
end)

hooksecurefunc("NotifyInspect", function(unit)
    -- print("NotifyInspect:", unit, UnitGUID(unit))
    lastInspectTime = GetTime()
    lastInspectGuid = UnitGUID(unit)
end)

hooksecurefunc("ClearInspectPlayer", function()
    -- print("ClearInspectPlayer")
    isBlzInspecting = false
end)

function Module:INSPECT_READY(guid)
    -- print("INSPECT_READY:", guid)
    lastInspectTime = nil
    lastInspectGuid = nil

    if Module:GetConfig(CONFIG_ITEM_LEVEL) then
        local unit = SearchUnitFromGUID(guid)

        if unit then
            -- print(C_PaperDollInfo.GetInspectItemLevel(unit))
            local itemLevel = C_PaperDollInfo.GetInspectItemLevel(unit)
            playerItemLevelCache[guid] = { GetTime(), itemLevel }

            if itemLevelLine and playerItemLevelCache[guid] then
                itemLevelLine:SetText(playerItemLevelCache[guid][2])
            end
        end

        if isIIOInspecting then
            isIIOInspecting = false
            ClearInspectPlayer()
        end
    end
end
Module:RegisterEvent("INSPECT_READY")

function Module:UPDATE_MOUSEOVER_UNIT()
    if Module:GetConfig(CONFIG_ITEM_LEVEL) then
        if not UnitIsUnit("player", "mouseover") and CanInspect("mouseover") then
            local guid = UnitGUID("mouseover")

            if playerItemLevelCache[guid] then
                -- 装等有效时间在1分钟内的 不再尝试更新
                if playerItemLevelCache[guid][1] + 60 > GetTime() then
                    return
                end
            end
            -- print(isBlzInspecting, isIIOInspecting, guid, lastInspectGuid, lastInspectTime)
            if (
                not isBlzInspecting and
                (
                    not lastInspectTime or
                    (lastInspectTime and isIIOInspecting) or
                    (lastInspectTime + 3 > GetTime())
                )
            ) then
                ClearInspectPlayer()
                NotifyInspect("mouseover")
                isIIOInspecting = true
            end
        end
    end
end
Module:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
