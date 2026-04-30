local ADDON_NAME, ItemInfoOverlay = ...

local Module = ItemInfoOverlay:NewModule("weeklyRewards")
local Utils = ItemInfoOverlay:GetModule("utils")
local L = ItemInfoOverlay.Locale

local loaded = false

local function CreateObstruction(frame)
    if not frame.obstruction then
        frame.obstruction = CreateFrame("Frame", nil, frame)
        frame.obstruction:SetAllPoints(frame)
        frame.obstruction:SetFrameStrata("HIGH")

        frame.obstruction.texture = frame.obstruction:CreateTexture()
        frame.obstruction.texture:SetAllPoints(frame.obstruction)
        frame.obstruction.texture:SetColorTexture(0, 0, 0)

        frame.obstruction.text = frame.obstruction:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        frame.obstruction.text:SetPoint("BOTTOM", frame.obstruction, "BOTTOM", 0, 10)
        frame.obstruction.text:SetText("")

        frame.obstruction:SetScript("OnMouseUp", function (self)
            self:Hide()
            if self.isMyth then
                PlaySound(SOUNDKIT.UI_LEGENDARY_LOOT_TOAST)
            end
        end)
    end

    if frame.info and frame.hasRewards and frame.info.type ~= 5 then
        frame.obstruction:Show()

        local dbid = nil
        for i, rewardInfo in ipairs(frame.info.rewards) do
            if rewardInfo.type == Enum.CachedRewardType.Item and not C_Item.IsItemKeystoneByID(rewardInfo.id) then
                dbid = rewardInfo.itemDBID
            end
        end

        if dbid then
            local hyperlink = C_WeeklyRewards.GetItemHyperlink(dbid)
            if hyperlink then
                local itemUpgradeInfo = C_Item.GetItemUpgradeInfo(hyperlink)

                if itemUpgradeInfo and itemUpgradeInfo.trackString then
                    frame.obstruction.text:SetText(Utils.GetColoredItemLevelText(itemUpgradeInfo.trackString, hyperlink))

                    if itemUpgradeInfo.trackStringID == 978 then
                        frame.obstruction.isMyth = true
                    end
                else
                    local itemLevel = C_Item.GetDetailedItemLevelInfo(hyperlink)
                    local progressText = string.format(ITEM_LEVEL, itemLevel)
                    
                    frame.obstruction.text:SetText(Utils.GetColoredItemLevelText(progressText, hyperlink))
                end
            end
        end
    else
        frame.obstruction:Hide()
    end
end

function Module:ADDON_LOADED(addon)
    if addon == "Blizzard_WeeklyRewards" then
        for _, frame in pairs(WeeklyRewardsFrame.Activities) do
            hooksecurefunc(frame, "Refresh", CreateObstruction)
        end
    end
end
Module:RegisterEvent("ADDON_LOADED")
