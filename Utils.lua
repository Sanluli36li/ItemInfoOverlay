local ADDON_NAME, ItemInfoOverlay = ...

local Module = ItemInfoOverlay:NewModule("utils")

function Module:GetItemInfoOverlay(frame)
    if not frame.ItemInfoOverlay then
        return ItemInfoOverlay:GetModule("itemInfoOverlay"):CreateItemInfoOverlay(frame)
    else
        return frame.ItemInfoOverlay
    end
end

local ITEM_LEVEL_PATTERN = ITEM_LEVEL:gsub("%%d", "(%%d+)")
local ITEM_LEVEL_ALT_PATTERN = ITEM_LEVEL_ALT:gsub("[%(%)]", "%%%1"):gsub("%%d", "(%%d+)")
local PVP_ITEM_LEVEL_TOOLTIP_PATTERN = PVP_ITEM_LEVEL_TOOLTIP:gsub("%%d", "(%%d+)")

function Module:GetItemLevelFromTooltipInfo(tooltipInfo)
    if tooltipInfo and tooltipInfo.lines then
        local itemLevel, currentItemLevel, pvpItemLevel
        for _, line in ipairs(tooltipInfo.lines) do
            
            if line.leftText:match(ITEM_LEVEL_ALT_PATTERN) then
                currentItemLevel, itemLevel = line.leftText:match(ITEM_LEVEL_ALT_PATTERN)
            elseif line.leftText:match(ITEM_LEVEL_PATTERN) then
                itemLevel = line.leftText:match(ITEM_LEVEL_PATTERN)
            elseif not pvpItemLevel and line.leftText:match(PVP_ITEM_LEVEL_TOOLTIP_PATTERN) then
                pvpItemLevel = line.leftText:match(PVP_ITEM_LEVEL_TOOLTIP_PATTERN)
            end
        end

        if not currentItemLevel then
            currentItemLevel = itemLevel
        end

        -- print(tonumber(itemLevel), tonumber(currentItemLevel), tonumber(pvpItemLevel))
        return tonumber(itemLevel), tonumber(currentItemLevel), tonumber(pvpItemLevel)
    end
end

function Module:GetLinkTypeAndID(link)
    return strmatch(link, "\124c[\\a-fA-F0-9]+\124H([A-Za-z]+):([0-9]+):[^\124]+\124h%b[]\124h\124r")
end
