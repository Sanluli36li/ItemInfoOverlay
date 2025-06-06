local ADDON_NAME, ItemInfoOverlay = ...

local Module = ItemInfoOverlay:NewModule("chatLink")
local L = ItemInfoOverlay.Locale

local CONFIG_CHAT_HYPERLINK_ENHANCE = "hyperlinkEnhance.enable"
local CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ICON = "hyperlinkEnhance.displayIcon"
local CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ITEM_LEVEL = "hyperlinkEnhance.displayItemLevel"
local CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ITEM_TYPE = "hyperlinkEnhance.displayItemType"
local CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_SOCKETS = "hyperlinkEnhance.displaySockets"
local CONFIG_CHAT_HYPERLINK_ENHANCE_APPLY_TO_GUILD_NEWS = "hyperlinkEnhance.applyToGuildNews"

local function HandleItemLink(itemLink)
    local color, metaData, itemName = itemLink:match("\124c([\\a-zA-Z0-9:]+)\124Hitem:([^\124]+)\124h(%b[])\124h\124r")
    local sourceItemName = strsub(itemName, 2, -2)
    local sourceItemNameWithoutIcon = sourceItemName:gsub("\124.*", "")
    local name, _, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, _, itemEquipLoc, itemTexture, _, classID, subclassID, bindType, expacID, setID, isCraftingReagent = C_Item.GetItemInfo(itemLink)
    local displayItemName = sourceItemNameWithoutIcon

    if not name then return end

    local bonding
    local canUse = true
    local sockets = ""

    local tooltipInfo = C_TooltipInfo.GetHyperlink(itemLink)
    if tooltipInfo and tooltipInfo.type == Enum.TooltipDataType.Item and tooltipInfo.lines then
        for i, line in ipairs(tooltipInfo.lines) do
            if line.type == Enum.TooltipDataLineType.ItemBinding then
                bonding = line.bonding
            elseif Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_SOCKETS) and line.type == Enum.TooltipDataLineType.GemSocket then
                -- 插槽信息
                if line.gemIcon then
                    sockets = sockets.."|T"..line.gemIcon..":12:12:0:0|t"
                elseif line.socketType then
                    sockets = sockets.."|T"..string.format("Interface\\ItemSocketingFrame\\UI-EmptySocket-%s", line.socketType)..":12:12:0:0|t"
                end
            elseif line.type == Enum.TooltipDataLineType.RestrictedRaceClass and line.leftColor and line.leftColor:GenerateHexColor() ~= "ffffffff" then
                -- 职业限制不可用
                canUse = false
            elseif strfind(line.leftText, ITEM_LEVEL:gsub("%%d", "%%d+")) then
                local i, j = strfind(line.leftText, "%d+")
                local ilvl = tonumber(strsub(line.leftText, i, j))
                if ilvl then
                    itemLevel = ilvl
                end
            end
        end
    end

    if sockets ~= "" then
        sockets = sockets.." "
    end

    -- 物品分类
    if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ITEM_TYPE) then
        local displayType
        if classID == Enum.ItemClass.Armor then
            -- 护甲
            if subclassID == Enum.ItemArmorSubclass.Generic or itemEquipLoc == "INVTYPE_CLOAK" then
                -- 护甲->杂项/背部(所有披风都是布甲类型, 需要特判): 装备栏位
                displayType = _G[itemEquipLoc]
            elseif subclassID == Enum.ItemArmorSubclass.Shield then
                -- 护甲->盾牌: 盾牌
                displayType = itemSubType
            else
                -- 其他: 护甲类型和装备栏位
                displayType = itemSubType.."||".._G[itemEquipLoc]
            end
        elseif classID == Enum.ItemClass.Tradegoods and subclassID == 11 then
            -- 制造材料
            displayType = PROFESSIONS_MODIFIED_CRAFTING_REAGENT_BASIC
        elseif (
            (classID == Enum.ItemClass.Consumable and subclassID == Enum.ItemConsumableSubclass.Other) or                                           -- 消耗品->其他
            (classID == Enum.ItemClass.Gem and subclassID ~= Enum.ItemGemSubclass.Artifactrelic) or                                                 -- 宝石 (不包括军团神器圣物)
            classID == Enum.ItemClass.ItemEnhancement or                                                                                            -- 物品强化
            (classID == Enum.ItemClass.Miscellaneous and subclassID == Enum.ItemMiscellaneousSubclass.Junk and itemQuality > Enum.ItemQuality.Poor) -- 非破烂品质垃圾
        ) then
            displayType = itemType
        else
            displayType = itemSubType or itemType
        end

        if displayType and (
            classID == Enum.ItemClass.Weapon or
            classID == Enum.ItemClass.Armor or
            classID == Enum.ItemClass.Profession or
            (classID == Enum.ItemClass.Miscellaneous and Enum.ItemMiscellaneousSubclass.Junk and itemQuality >= Enum.ItemQuality.Epic)  -- 杂项->垃圾 (史诗品质以上) (套装兑换物)
        ) then
            if bonding == 7 then
                -- 装备后绑定
                displayType = "|cffffffffBoE|r||"..displayType
            elseif bonding == 10 then
                -- 装备前战团绑定
                -- displayType = "|cff00ccffWuE|r||"..displayType
            end
        end

        if displayType then
            displayItemName = "("..displayType..")"..displayItemName
        end
    end

    -- 重新格式化钥石物品
    --[[
        注: 
        钥石有两种格式 分别为"|Hitem:XXXX|h[史诗钥石]|h"的物品形式以及"|Hkeystone:XXXX|h[钥石：XXXX(10)]"的钥石形式
        但将背包中的钥石链接至聊天框会自动转化为钥石格式而非物品格式
        物品格式的钥石链接仅在获得钥石时或与林多尔米对话更换或降低钥石时使用
        此处代码将统一两种链接的显示效果 (钥石格式的链接显然要直观不少)
    ]]
    if classID == Enum.ItemClass.Reagent and subclassID == Enum.ItemReagentSubclass.Keystone then
        local data = strsplittable(":", metaData)
            if data[16] and data[18] then
            local mapName = C_ChallengeMode.GetMapUIInfo(tonumber(data[16]))
            if mapName then
                displayItemName = CHALLENGE_MODE_KEYSTONE_HYPERLINK:format(mapName, tonumber(data[18]))
            end
        end
    end

    -- 物品染色
    if IsCosmeticItem(itemLink) then
        -- 装饰品
        color = "ffff80ff"
    elseif
        bonding == Enum.TooltipDataItemBinding.Account or                   -- 战团绑定
        bonding == Enum.TooltipDataItemBinding.BnetAccount or               -- 战网通行证绑定 (疑似弃用)
        bonding == Enum.TooltipDataItemBinding.BindToBnetAccount or         -- 绑定至战团 (为什么会有这么多种?)
        bonding == Enum.TooltipDataItemBinding.AccountUntilEquipped or      -- 装备前战团绑定
        bonding == Enum.TooltipDataItemBinding.BindToAccountUntilEquipped   -- 装备前战团绑定 (为什么会有这么多种?)
    then
        -- 战团绑定/装备前战团绑定的物品
        color = "ff00ccff"
    elseif not canUse then
        -- 不能使用的物品 (例如其他职业的套装)
        color = "ffff2020"
    end

    -- 物品等级 (仅武器、护甲、专业装备展示物品等级; 并排除装饰品)
    if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ITEM_LEVEL) and (
        classID == Enum.ItemClass.Weapon or                                                                                                         -- 武器
        classID == Enum.ItemClass.Armor or                                                                                                          -- 护甲
        classID == Enum.ItemClass.Profession or                                                                                                     -- 专业装备
        (classID == Enum.ItemClass.Gem and subclassID == Enum.ItemGemSubclass.Artifactrelic) or                                                     -- 神器圣物
        (classID == Enum.ItemClass.Miscellaneous and subclassID == Enum.ItemMiscellaneousSubclass.Junk and itemQuality >= Enum.ItemQuality.Epic)    -- 杂项->垃圾 (史诗品质以上) (套装兑换物)
    ) and not IsCosmeticItem(itemLink) then
        displayItemName = itemLevel..":"..displayItemName
    end

    local newItemLink = "|c"..color.."|H".."item:"..metaData.."|h".."["..sourceItemName:gsub(sourceItemNameWithoutIcon:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1"), displayItemName).."]".."|h".."|r"

    -- 物品图标
    if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ICON) and itemTexture then
        newItemLink = "|T"..itemTexture..":12:12:1:0|t"..newItemLink
    end

    -- 插槽图标
    if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_SOCKETS) then
        newItemLink = newItemLink..sockets
    end

    return newItemLink
end

local function chatFilter(chatFrame, event, message, ...)
    if SanluliUtils then return end -- 如果SanluliUtils插件存在, 则不生效
    if not Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE) then return end
    local newMessage = message:gsub("\124c[\\a-zA-Z0-9:]+\124Hitem:[^\124]+\124h%b[]\124h\124r", HandleItemLink
    ):gsub("(\124c[\\a-zA-Z0-9:]+\124Hkeystone:([0-9]+):[^\124]+\124h(%b[])\124h\124r)", function(link, itemIDStr, keystoneName)
        -- 史诗钥石
        if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ICON) then
            local itemID = tonumber(itemIDStr)
            local name, _, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, _, itemEquipLoc, itemTexture = GetItemInfo(itemID)

            if itemTexture then
                return "|T"..itemTexture..":12:12:1:0|t"..link
            end
        end
    end):gsub("(\124c[\\a-zA-Z0-9:]+\124Hcurrency:([0-9]+):[^\124]+\124h(%b[])\124h\124r)", function(link, currencyIDLink, currencyName)
        -- 货币
        if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ICON) then
            local info = C_CurrencyInfo.GetCurrencyInfoFromLink(link)

            if info and info.iconFileID then
                return "|T"..info.iconFileID..":12:12:1:0|t"..link
            end
        end
    end):gsub("(\124c[\\a-zA-Z0-9:]+\124Hspell:[^\124]+\124h(%b[])\124h\124r)", function(link, spellName)
        -- 法术
        if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ICON) then
            local info = C_Spell.GetSpellInfo(link)

            if info and info.iconID then
                return "|T"..info.iconID..":12:12:1:0|t"..link
            end
        end
    end):gsub("(\124c[\\a-zA-Z0-9:]+\124Hmount:([0-9]+):[^\124]+\124h(%b[])\124h\124r)", function(link, spellIDStr, spellName)
        -- 坐骑
        if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ICON) then
            local spellID = tonumber(spellIDStr)
            local spellInfo = C_Spell.GetSpellInfo(spellID)

            if spellInfo and spellInfo.iconID then
                return "|T"..spellInfo.iconID..":12:12:1:0|t"..link
            end
        end
    end)

    return false, newMessage, ...
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", chatFilter)                     -- 说
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", chatFilter)                   -- 表情
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", chatFilter)                    -- 大喊
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", chatFilter)                   -- 公会聊天
-- ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", chatFilter)              -- 官员聊天 (官员聊天的内容为受保护的字符串 插件无法读取到其内容, 故无法替换)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", chatFilter)                 -- 悄悄话
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", chatFilter)          -- 悄悄话
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", chatFilter)              -- 战网昵称密语
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", chatFilter)       -- 战网昵称密语
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", chatFilter)                   -- 小队
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", chatFilter)            -- 小队队长
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", chatFilter)                    -- 团队
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", chatFilter)             -- 团队领袖
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", chatFilter)           -- 副本
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", chatFilter)    -- 副本向导
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", chatFilter)                 -- 频道
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", chatFilter)                    -- 物品拾取
ChatFrame_AddMessageEventFilter("CHAT_MSG_CURRENCY", chatFilter)                -- 货币
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ITEM_LOOTED", chatFilter)       -- 公会物品拾取

hooksecurefunc("GuildNewsButton_SetText", function(button, text_color, text, text1, text2, ...)
    if SanluliUtils then return end -- 如果SanluliUtils插件存在, 则不生效
    if not Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_APPLY_TO_GUILD_NEWS) then return end

    if true and (text2 and type(text2) == "string") then
        text2 = text2:gsub("\124c[\\a-zA-Z0-9:]+\124Hitem:[^\124]+\124h%b[]\124h\124r", HandleItemLink)
        button.text:SetFormattedText(text, text1, text2, ...)
    end
end)
