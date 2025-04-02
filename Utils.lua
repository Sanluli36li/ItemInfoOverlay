local ADDON_NAME, ItemInfoOverlay = ...

local Module = ItemInfoOverlay:NewModule("utils")

function Module:GetItemInfoOverlay(frame)
    if not frame.ItemInfoOverlay then
        return ItemInfoOverlay:GetModule("itemInfoOverlay"):CreateItemInfoOverlay(frame)
    else
        return frame.ItemInfoOverlay
    end
end

function Module:GetItemLevelFromTooltipInfo(tooltipInfo)
    if tooltipInfo and tooltipInfo.lines then
        for _, line in ipairs(tooltipInfo.lines) do
            if strfind(line.leftText, ITEM_LEVEL:gsub("%%d", "%%d+")) then
                local i, j = strfind(line.leftText, "%d+")
                local ilvl = tonumber(strsub(line.leftText, i, j))
                if ilvl then
                    return ilvl
                end
            end
        end
    end
end
