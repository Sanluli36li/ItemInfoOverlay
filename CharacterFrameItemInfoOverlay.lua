local ADDON_NAME, ItemInfoOverlay = ...

local Module = ItemInfoOverlay:NewModule("characterFrame")
local Utils = ItemInfoOverlay:GetModule("utils")
local L = ItemInfoOverlay.Locale

local CONFIG_ITEM_LEVEL = "itemLevel.enable"
local CONFIG_ITEM_LEVEL_FONT = "itemLevel.font"
local CONFIG_ITEM_LEVEL_FONT_SIZE = "itemLevel.fontSize"
local CONFIG_ITEM_LEVEL_POINT = "itemLevel.point"
local CONFIG_ITEM_LEVEL_ANCHOR_TO_ICON = "itemLevel.anchorToIcon"
local CONFIG_PVP_ITEM_LEVEL = "pvpItemLevel.enable"
local CONFIG_PVP_ITEM_LEVEL_FONT = "pvpItemLevel.font"
local CONFIG_PVP_ITEM_LEVEL_FONT_SIZE = "pvpItemLevel.fontSize"
local CONFIG_PVP_ITEM_LEVEL_POINT = "pvpItemLevel.point"
local CONFIG_PVP_ITEM_LEVEL_ANCHOR_TO_ICON = "pvpItemLevel.customAnchor"
local CONFIG_SOCKET = "socket.enable"
local CONFIG_SOCKET_ICON_SIZE = "socket.iconSize"
local CONFIG_SOCKET_DISPLAY_MAX_SOCKETS = "socket.displayMaxSockets"
local CONFIG_ENCHANT = "enchant.enable"
local CONFIG_ENCHANT_DISPLAY_MISSING = "enchant.displayMissing"
local CONFIG_ENCHANT_FONT = "enchant.font"
local CONFIG_ENCHANT_FONT_SIZE = "enchant.fontSize"
local CONFIG_DURABILITY = "durability.enable"
local CONFIG_DURABILITY_POINT = "durability.point"
local CONFIG_DURABILITY_FONT = "durability.font"
local CONFIG_DURABILITY_FONT_SIZE = "durability.fontSize"

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

local POINTS = {
    "TOPLEFT",
    "TOP",
    "TOPRIGHT",
    "LEFT",
    "CENTER",
    "RIGHT",
    "BOTTOMLEFT",
    "BOTTOM",
    "BOTTOMRIGHT"
}

local POINTS_PVP_ITEM_LEVEL_ANCHOR_TO_ITEMLEVEL = {
    {"TOPLEFT", "BOTTOMLEFT", -1},
    {"TOP", "BOTTOM", -1},
    {"TOPRIGHT", "BOTTOMRIGHT", -1},
    {"TOPLEFT", "BOTTOMLEFT", -1},
    {"TOP", "BOTTOM", -1},
    {"TOPRIGHT", "BOTTOMRIGHT", -1},
    {"BOTTOMLEFT", "TOPLEFT", 1},
    {"BOTTOM", "TOP", -1},
    {"BOTTOMRIGHT", "TOPRIGHT", -1},
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
    INVTYPE_RANGED = true,      -- 远程武器
    INVTYPE_2HWEAPON = true,    -- 双手武器
    INVTYPE_WEAPONMAINHAND = true,  -- 主手武器
    INVTYPE_RANGEDRIGHT = true, -- 远程武器
}

local EQUIP_LOC_MAX_SOCKETS_TWW = {
    INVTYPE_HEAD = {1, 232386, 230425},
    INVTYPE_WAIST = {1, 232386, 230425},
    INVTYPE_WRIST = {1, 232386, 230425},
    INVTYPE_NECK = {2, 213777, 230425},
    INVTYPE_FINGER = {2, 213777, 230425}
}

local function CanEnchant(itemLevel, itemEquipLoc)
    if itemLevel > 535 then
        -- TWW
        return EQUIP_LOC_CAN_ENCHANT_TWW[itemEquipLoc]
    else
        return false
    end
end

local EQUIP_LOC_MAX_SOCKETS = {
    [LE_EXPANSION_DRAGONFLIGHT] = {
        INVTYPE_NECK = { 3, 192994 }
    },
    [LE_EXPANSION_WAR_WITHIN] = {
        INVTYPE_HEAD = { 1, 232386, 230425 },
        INVTYPE_WAIST = { 1, 232386, 230425 },
        INVTYPE_WRIST = { 1, 232386, 230425 },
        INVTYPE_NECK = { 2, 213777, 230425 },
        INVTYPE_FINGER = { 2, 213777, 230425 }
    }
}

local function MaxSockets(itemLevel, itemLink, isPvpItem)
    local itemMinLevel, _, _, _, itemEquipLoc, _, _, _, _, _, expansionID = select(5, C_Item.GetItemInfo(itemLink))

    if itemLevel > 535 or expansionID == LE_EXPANSION_WAR_WITHIN then
        local maxSocketInfo = EQUIP_LOC_MAX_SOCKETS_TWW[itemEquipLoc]
        if maxSocketInfo then
            return maxSocketInfo[1], (isPvpItem and maxSocketInfo[3]) or maxSocketInfo[2]
        else
            return 0
        end
    elseif expansionID == LE_EXPANSION_DRAGONFLIGHT then
        if itemEquipLoc == "INVTYPE_NECK" then
            return 3, 192994
        end
    end
    return 0
end

--------------------
-- Mixin
--------------------
IIOCharacterFrameItemInfoOverlayMixin = {}

function IIOCharacterFrameItemInfoOverlayMixin:SetSide(isLeft)
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

function IIOCharacterFrameItemInfoOverlayMixin:UpdateAppearance()
    -- 物品等级字体
    self.ItemLevel:SetFont(Module:GetConfig(CONFIG_ITEM_LEVEL_FONT), Module:GetConfig(CONFIG_ITEM_LEVEL_FONT_SIZE), "OUTLINE")
    if Module:GetConfig(CONFIG_ITEM_LEVEL) and not Module:GetConfig(CONFIG_ITEM_LEVEL_ANCHOR_TO_ICON) then
        -- 默认位置
        self.ItemLevel:ClearAllPoints()
        self.ItemLevel:SetPoint(
            (self.side == "LEFT" and "LEFT") or "RIGHT",
            self,
            (self.side == "LEFT" and "RIGHT") or "LEFT",
            (self.side == "LEFT" and 8) or -8,
            0
        )
    else
        -- 显示在图标上
        self.ItemLevel:ClearAllPoints()
        self.ItemLevel:SetPoint(POINTS[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)])
    end

    -- PvP物品等级
    self.PvPItemLevel:SetFont(Module:GetConfig(CONFIG_PVP_ITEM_LEVEL_FONT), Module:GetConfig(CONFIG_PVP_ITEM_LEVEL_FONT_SIZE), "OUTLINE")
    if Module:GetConfig(CONFIG_PVP_ITEM_LEVEL_ANCHOR_TO_ICON) then
        -- 自定义锚点
        self.PvPItemLevel:ClearAllPoints()
        self.PvPItemLevel:SetPoint(POINTS[Module:GetConfig(CONFIG_PVP_ITEM_LEVEL_POINT)])
    elseif Module:GetConfig(CONFIG_ITEM_LEVEL) and Module:GetConfig(CONFIG_ITEM_LEVEL_ANCHOR_TO_ICON) then
        -- 有物品等级且显示在图标上
        self.PvPItemLevel:ClearAllPoints()
        self.PvPItemLevel:SetPoint(
            POINTS_PVP_ITEM_LEVEL_ANCHOR_TO_ITEMLEVEL[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)][1],
            self.ItemLevel,
            POINTS_PVP_ITEM_LEVEL_ANCHOR_TO_ITEMLEVEL[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)][2],
            0,
            POINTS_PVP_ITEM_LEVEL_ANCHOR_TO_ITEMLEVEL[Module:GetConfig(CONFIG_ITEM_LEVEL_POINT)][3]
        )
    else
        -- 默认锚点
        self.PvPItemLevel:ClearAllPoints()
        self.PvPItemLevel:SetPoint("TOP")
    end

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
    if Module:GetConfig(CONFIG_ITEM_LEVEL) and not Module:GetConfig(CONFIG_ITEM_LEVEL_ANCHOR_TO_ICON) then
        -- 显示物品等级且不在图标上 (插槽移动给装等让位置)
        self.GemSocket1:ClearAllPoints()
        self.GemSocket1:SetPoint(
            (self.side == "LEFT" and "LEFT") or "RIGHT",
            self,
            (self.side == "LEFT" and "RIGHT") or "LEFT",
            (self.side == "LEFT" and Module:GetConfig(CONFIG_ITEM_LEVEL_FONT_SIZE) * 3 + 2) or (- Module:GetConfig(CONFIG_ITEM_LEVEL_FONT_SIZE) * 3 - 2),
            0
        )
    else
        -- 默认位置
        self.GemSocket1:ClearAllPoints()
        self.GemSocket1:SetPoint(
            (self.side == "LEFT" and "LEFT") or "RIGHT",
            self,
            (self.side == "LEFT" and "RIGHT") or "LEFT",
            (self.side == "LEFT" and 9) or -9,
        0)
    end

    -- 耐久度
    self.Durability:SetFont(Module:GetConfig(CONFIG_DURABILITY_FONT), Module:GetConfig(CONFIG_DURABILITY_FONT_SIZE), "OUTLINE")
    self.Durability:ClearAllPoints()
    self.Durability:SetPoint(POINTS[Module:GetConfig(CONFIG_DURABILITY_POINT)])
    self.Durability:SetShown(Module:GetConfig(CONFIG_DURABILITY))

    self:Refresh()
end

function IIOCharacterFrameItemInfoOverlayMixin:UpdateLines()
    local line1, line2
    if (not Module:GetConfig(CONFIG_ITEM_LEVEL_ANCHOR_TO_ICON) and self.ItemLevel:IsShown()) or self.GemSocket1:IsShown() then
        line1 = true
    end

    if self.Enchant:IsShown() then
        line2 = true
    end

    local point, relativeTo, relativePoint, offsetX, offsetY

    if line1 and line2 then

        -- 物品等级
        if (not Module:GetConfig(CONFIG_ITEM_LEVEL_ANCHOR_TO_ICON) and self.ItemLevel:IsShown()) then
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
        if (not Module:GetConfig(CONFIG_ITEM_LEVEL_ANCHOR_TO_ICON) and self.ItemLevel:IsShown()) then
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

function IIOCharacterFrameItemInfoOverlayMixin:SetItemData(itemLevel, itemLink, tooltipInfo, pvpItemLevel)
    local itemName, _, itemQuality, _, itemMinLevel, itemType, itemSubType, 
    itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
    expacID, setID, isCraftingReagent = C_Item.GetItemInfo(itemLink)

    local itemEnchant, itemEnchantQuality
    local itemGemSocketCount = 0
    local itemGemSockets = {}
    local itemGemSocketsText = {}
    if tooltipInfo then
        for i, line in pairs(tooltipInfo.lines) do
            local text = line.leftText

            if line.type == Enum.TooltipDataLineType.ItemEnchantmentPermanent then
                -- 附魔
                local enchant = string.match(text, ENCHANT_PATTERN)
                if enchant then
                    if string.find(enchant, "|A:") then
                        itemEnchant, itemEnchantQuality = string.match(enchant, ENCHANT_QUALITY_PATTERN)
                    else
                        itemEnchant = enchant
                    end
                end
            elseif line.type == Enum.TooltipDataLineType.GemSocket then
                -- 宝石
                itemGemSocketCount = itemGemSocketCount + 1
                if line.socketType then
                    itemGemSockets[itemGemSocketCount] = string.format("Interface\\ItemSocketingFrame\\UI-EmptySocket-%s", line.socketType)
                    itemGemSocketsText[itemGemSocketCount] = line.leftText
                end
            end
        end
    end

    if Module:GetConfig(CONFIG_ITEM_LEVEL) and itemLevel and itemLevel > 1 then
        self.ItemLevel:SetText(Utils.GetColoredItemLevelText(itemLevel, itemLink))
        self.ItemLevel:Show()
    else
        self.ItemLevel:Hide()
    end

    if Module:GetConfig(CONFIG_PVP_ITEM_LEVEL) then
        if not Module:GetConfig(CONFIG_ITEM_LEVEL) then
            if pvpItemLevel then
                self.PvPItemLevel:SetText(Utils.GetColoredItemLevelText(pvpItemLevel, itemLink, true))
            else
                self.PvPItemLevel:SetText(Utils.GetColoredItemLevelText(itemLevel, itemLink))
            end
            self.PvPItemLevel:Show()
        elseif pvpItemLevel and pvpItemLevel > itemLevel then
            self.PvPItemLevel:SetText(Utils.GetColoredItemLevelText("("..pvpItemLevel..")", itemLink, true))
            self.PvPItemLevel:Show()
        else
            self.PvPItemLevel:Hide()
        end
    else
        self.PvPItemLevel:Hide()
    end

    if Module:GetConfig(CONFIG_ENCHANT) and itemEnchant then
        self.Enchant:SetTextToFit(string.gsub(itemEnchant, "[ \\+]", ""))
        self.Enchant:Show()

        if self.Enchant:GetUnboundedStringWidth() >= 80 then
            self.Enchant:SetWidth(80)
        end

        if itemEnchantQuality then
            self.EnchantQuality:SetText("|A:"..itemEnchantQuality..":20:20|a")
            self.EnchantQuality:Show()
        else
            self.EnchantQuality:Hide()
        end
    elseif Module:GetConfig(CONFIG_ENCHANT) and Module:GetConfig(CONFIG_ENCHANT_DISPLAY_MISSING) and CanEnchant(itemLevel, itemEquipLoc) then
        self.Enchant:SetTextToFit("|cffff0000"..L["characterFrame.enchant.displayMissing.noenchant"].."|r")
        self.Enchant:Show()

        if self.Enchant:GetUnboundedStringWidth() >= 80 then
            self.Enchant:SetWidth(80)
        end

        self.EnchantQuality:Hide()
    else
        self.EnchantQuality:Hide()
        self.Enchant:Hide()
    end

    if Module:GetConfig(CONFIG_SOCKET) then
        local maxSocketsNum, addSocketItemID = MaxSockets(itemLevel, itemLink, pvpItemLevel)

        for i = 1, 3 do
            if self["GemSocket"..i] then
                local socketIcon = self["GemSocket"..i]
                local gemID = C_Item.GetItemGemID(itemLink, i)

                if gemID then
                    -- 等待缓存宝石图标的处理方式来自 [Interface\\AddOns\\Blizzard_UIPanels_Game\\Mainline\\PaperDollFrame.lua]:2799
                    local gemItem = Item:CreateFromItemID(gemID)

                    -- 未载入: 贴个棱彩插槽上去
                    if not gemItem:IsItemDataCached() then
                        socketIcon:SetNormalTexture("Interface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic")
                        socketIcon:GetNormalTexture():SetVertexColor(1, 1, 1)
                        socketIcon:SetAlpha(1)
                    end
                    -- 等待到宝石物品载入
                    gemItem:ContinueOnItemLoad(function()
                        local _, gemLink, _, _, _, _, _, _, _, gemIcon = C_Item.GetItemInfo(gemID)
                        local professionQuality = C_TradeSkillUI.GetItemReagentQualityByItemInfo(gemID)

                        socketIcon:SetNormalTexture(gemIcon)
                        socketIcon:GetNormalTexture():SetVertexColor(1, 1, 1)
                        socketIcon:SetAlpha(1)

                        socketIcon:SetScript("OnEnter", function(self)
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                            GameTooltip:SetHyperlink(gemLink)
                            GameTooltip:Show()
                        end)

                        socketIcon:SetScript("OnLeave", function()
                            GameTooltip:Hide()
                        end)

                        if professionQuality then
                            socketIcon.Quality:SetText("|A:".."Professions-ChatIcon-Quality-Tier"..professionQuality..":12:12|a")
                            socketIcon.Quality:Show()
                        else
                            socketIcon.Quality:Hide()
                        end

                        socketIcon:Show()
                    end)
                else
                    -- 没有宝石
                    if i <= itemGemSocketCount then
                        if itemGemSockets[i] then
                            socketIcon:SetNormalTexture(itemGemSockets[i])
                            socketIcon:GetNormalTexture():SetVertexColor(1, 1, 1)
                            socketIcon:SetAlpha(1)

                            socketIcon:SetScript("OnEnter", function(self)
                                GameTooltip:SetOwner(socketIcon, "ANCHOR_RIGHT")
                                GameTooltip:SetText(itemGemSocketsText[i])
                                GameTooltip:Show()
                            end)

                            socketIcon:SetScript("OnLeave", function()
                                GameTooltip:Hide()
                            end)

                            socketIcon:Show()
                            socketIcon.Quality:Hide()
                        else
                            socketIcon:Hide()
                            socketIcon.Quality:Hide()
                        end
                    elseif Module:GetConfig(CONFIG_SOCKET_DISPLAY_MAX_SOCKETS) and i <= maxSocketsNum then
                        if addSocketItemID then
                            local addSocketItem = Item:CreateFromItemID(addSocketItemID)
                            socketIcon.addSocketItemLink = C_Item.GetItemInfo(addSocketItemID) or "[...]"
                            addSocketItem:ContinueOnItemLoad(function()
                                socketIcon.addSocketItemLink = select(2, C_Item.GetItemInfo(addSocketItemID))
                            end)
                        else
                            socketIcon.addSocketItemLink = nil
                        end

                        socketIcon:SetNormalTexture("Interface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic")
                        socketIcon:GetNormalTexture():SetVertexColor(1, 0.5, 0.5)
                        socketIcon:SetAlpha(0.5)

                        socketIcon:SetScript("OnEnter", function(self)
                            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
                            GameTooltip:SetText(L["characterFrame.socket.displayMaxSockets.message"])
                            if self.addSocketItemLink then
                                IIOTooltip:SetOwner(GameTooltip, "ANCHOR_NONE")
                                IIOTooltip:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 0, -2)
                                IIOTooltip:SetHyperlink(self.addSocketItemLink)
                                IIOTooltip:Show()
                                --GameTooltip.shoppingTooltips[1]:SetOwner(GameTooltip, "ANCHOR_NONE")
                                --GameTooltip.shoppingTooltips[1]:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 0, -2)
                                --GameTooltip.shoppingTooltips[1]:SetHyperlink(self.addSocketItemLink)
                                --GameTooltip.shoppingTooltips[1]:Show()
                            end
                            GameTooltip:Show()
                        end)

                        socketIcon:SetScript("OnLeave", function()
                            GameTooltip:Hide()
                            GameTooltip.shoppingTooltips[1]:Hide()
                            IIOTooltip:Hide()
                        end)

                        socketIcon:Show()
                        socketIcon.Quality:Hide()
                    else
                        socketIcon:Hide()
                        socketIcon.Quality:Hide()
                    end
                end
            end
        end
    else
        self.GemSocket1:Hide()
        self.GemSocket2:Hide()
        self.GemSocket3:Hide()
    end

    self:Show()
    self:UpdateLines()
end

function IIOCharacterFrameItemInfoOverlayMixin:SetItemFromLocation(itemLocation)
    self.itemLocation = itemLocation
    self.itemLink = nil

    if itemLocation and itemLocation:IsValid() then
        local itemLink = C_Item.GetItemLink(itemLocation)

        local tooltipInfo
        if itemLocation:IsBagAndSlot() then
            tooltipInfo = C_TooltipInfo.GetBagItem(itemLocation:GetBagAndSlot())
        elseif itemLocation:IsEquipmentSlot() then
            tooltipInfo = C_TooltipInfo.GetInventoryItem("player", itemLocation:GetEquipmentSlot())
        else
            tooltipInfo = C_TooltipInfo.GetHyperlink(itemLink)
        end

        local itemLevel, _, pvpItemLevel = Utils.GetItemLevelFromTooltipInfo(tooltipInfo)

        if not itemLevel then
            itemLevel = C_Item.GetCurrentItemLevel(itemLocation)
        end

        self:SetItemData(itemLevel, itemLink, tooltipInfo, pvpItemLevel)

        return itemLevel, itemLink, tooltipInfo
    else
        self:Hide()
    end
end

function IIOCharacterFrameItemInfoOverlayMixin:SetItemFromLink(itemLink)
    if itemLink then
        self.itemLocation = nil
        self.itemLink = itemLink

        local tooltipInfo = C_TooltipInfo.GetHyperlink(itemLink)

        local itemLevel, _, pvpItemLevel = Utils.GetItemLevelFromTooltipInfo(tooltipInfo)

        if not itemLevel then
            itemLevel = GetDetailedItemLevelInfo(itemLink)
        end

        self:SetItemData(itemLevel, itemLink, tooltipInfo, pvpItemLevel)

        return itemLevel, itemLink, tooltipInfo
    else
        self:Hide()
    end
end

function IIOCharacterFrameItemInfoOverlayMixin:SetItemFromUnitInventory(unit, slotID)
    local itemLink = GetInventoryItemLink(unit, slotID)

    if itemLink then
        local tooltipInfo = C_TooltipInfo.GetInventoryItem(unit, slotID)

        local itemLevel, _, pvpItemLevel = Utils.GetItemLevelFromTooltipInfo(tooltipInfo)

        if not itemLevel then
            itemLevel = GetDetailedItemLevelInfo(itemLink)
        end

        self:SetItemData(itemLevel, itemLink, tooltipInfo, pvpItemLevel)

        return itemLevel, itemLink, tooltipInfo
    else
        self:Hide()
    end
end

function IIOCharacterFrameItemInfoOverlayMixin:UpdateDurability()
    if self.itemLocation and self.itemLocation:IsEquipmentSlot() then
        local current, maximum = GetInventoryItemDurability(self.itemLocation:GetEquipmentSlot())
        if current and maximum then
            local percent = current / maximum * 100
            if percent > 50 then
                self.Durability:SetText(format("|cff00ff00%d%%|r", current / maximum * 100))
            elseif percent > 20 then
                self.Durability:SetText(format("|cffffff00%d%%|r", current / maximum * 100))
            else
                self.Durability:SetText(format("|cffff0000%d%%|r", current / maximum * 100))
            end
        else
            self.Durability:SetText()
        end
    end
end

function IIOCharacterFrameItemInfoOverlayMixin:Clear()
    self.itemLocation = nil
    self.itemLink = nil
    self:Hide()
end

function IIOCharacterFrameItemInfoOverlayMixin:Refresh()
    if self.itemLocation then
        self:SetItemFromLocation(self.itemLocation)
    elseif self.itemLink then
        self:SetItemFromLink(self.itemLink)
    else
        self:Hide()
    end
end

IIOCharacterFrameItemInfoOverlaySettingPriviewMixin = {}

function IIOCharacterFrameItemInfoOverlaySettingPriviewMixin:OnLoad()
    self.itemButton:SetItemButtonTexture(6035288)
    self.itemButton:SetItemButtonQuality(Enum.ItemQuality.Epic)
    local overlay = Module:CreateItemInfoOverlay(self.itemButton, 1)
    overlay.Durability:SetText("|cff00ff00100%|r")
    local testItem = Item:CreateFromItemID(220202)
    testItem:ContinueOnItemLoad(function()
        overlay:SetItemFromLink("|cffa335ee|Hitem:220202:7346:213746:213482:::::80:102::6:7:12030:6652:10356:10299:1540:10255:11215:1:28:2462:::|h[间谍大师裹网]|h|r")
    end)
end

--------------------
-- 
--------------------

function Module:CreateItemInfoOverlay(frame, slot)
    frame.ItemInfoOverlay = CreateFrame("Frame", nil, frame, "IIOCharacterFrameItemInfoOverlayTemplate")

    local overlay = frame.ItemInfoOverlay

    tinsert(itemInfoOverlayPoor, overlay)

    if slot then
        overlay.slot = slot
        overlay.side = EQUIPMENT_SLOTS[slot].side
        overlay.offsetY = EQUIPMENT_SLOTS[slot].offsetY
        overlay:SetAllPoints(frame)

        overlay:SetSide(EQUIPMENT_SLOTS[slot].side == "LEFT")
        overlay:UpdateAppearance()
    end

    return overlay
end

local function GetItemInfoOverlayFromSlotID(slotID, isInspect)
    if slotID and EQUIPMENT_SLOTS[slotID] then
        if isInspect then
            if InspectFrame then
                return Utils.GetItemInfoOverlay(_G[INSPECT_PREFIX..EQUIPMENT_SLOTS[slotID].name..SLOT_SUFFIX])
            end
        else
            return Utils.GetItemInfoOverlay(_G[CHARACTER_PREFIX..EQUIPMENT_SLOTS[slotID].name..SLOT_SUFFIX])
        end
    end
end

function Module:UpdateAllAppearance()
    for _, overlay in ipairs(itemInfoOverlayPoor) do
        overlay:UpdateAppearance()
    end
end

function Module:UpdateAllInspectSlot ()
    if InspectFrame and InspectFrame.unit then
        for slotID, _ in pairs(EQUIPMENT_SLOTS) do
            GetItemInfoOverlayFromSlotID(slotID, true):SetItemFromUnitInventory(InspectFrame.unit, slotID)
        end
    end
end

function Module:UpdateAllCharacterSlot()
    for slotID, _ in pairs(EQUIPMENT_SLOTS) do
        GetItemInfoOverlayFromSlotID(slotID):SetItemFromLocation(ItemLocation:CreateFromEquipmentSlot(slotID))
    end
end

function Module:UpdateAllCharacterSlotDurability()
    for slotID, _ in pairs(EQUIPMENT_SLOTS) do
        GetItemInfoOverlayFromSlotID(slotID):UpdateDurability()
    end
end

function Module:UpdateItemLocation(itemLocation)
    if itemLocation and itemLocation:IsValid() and itemLocation:IsEquipmentSlot() then
        local slotID = itemLocation:GetEquipmentSlot()
        local overlay = GetItemInfoOverlayFromSlotID(slotID)
        if overlay then
            overlay:SetItemFromLocation(itemLocation)
        end
    end
end

--------------------
-- 暴雪函数安全钩子
--------------------

hooksecurefunc(CharacterFrame, "Show", function(self)
    Module:UpdateAllCharacterSlot()
    Module:UpdateAllCharacterSlotDurability()
end)

--------------------
-- 事件处理
--------------------

function Module:Startup()
    if C_SeasonInfo.GetCurrentDisplaySeasonID() == 25 then
        EQUIP_LOC_CAN_ENCHANT_TWW["INVTYPE_HEAD"] = true
    end

    for slotID, _ in pairs(EQUIPMENT_SLOTS) do
        Module:CreateItemInfoOverlay(_G[CHARACTER_PREFIX..EQUIPMENT_SLOTS[slotID].name..SLOT_SUFFIX], slotID)
    end
end

function Module:ADDON_LOADED(AddOnName)
    if AddOnName == "Blizzard_InspectUI" then
        -- 观察界面载入
        for slotID, _ in pairs(EQUIPMENT_SLOTS) do
            local overlay = Module:CreateItemInfoOverlay(_G[INSPECT_PREFIX..EQUIPMENT_SLOTS[slotID].name..SLOT_SUFFIX], slotID)
            function overlay:GetUnit()
                return InspectFrame.unit
            end
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
end
Module:RegisterEvent("ADDON_LOADED")

-- 插槽更新: 更新所有栏位
function Module:SOCKET_INFO_UPDATE()
    self:UpdateAllCharacterSlot()
end
Module:RegisterEvent("SOCKET_INFO_UPDATE")

-- 耐久度更新
function Module:UPDATE_INVENTORY_DURABILITY()
    self:UpdateAllCharacterSlotDurability()
end
Module:RegisterEvent("UPDATE_INVENTORY_DURABILITY")

-- 装备变更: 更新所有栏位
function Module:PLAYER_EQUIPMENT_CHANGED()
    self:UpdateAllCharacterSlot()
end
Module:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

-- 玩家物品栏更新: 更新所有栏位
function Module:UNIT_INVENTORY_CHANGED(unit)
    if unit == "player" then
        self:UpdateAllCharacterSlot()
    end
end
Module:RegisterEvent("UNIT_INVENTORY_CHANGED")
