if not(GetLocale() == "zhTW") then
    return
end

local ADDON_NAME, ItemInfoOverlay = ...

local L = ItemInfoOverlay.Locale

L["addon.name"] = ADDON_NAME
L["addon.sanluliUtils.tooltip"] = "\n\n|cffff0000此功能來自「SanluliUtils」，若你已載入該插件，此功能不會生效|r"
L["characterFrame.durability.title"] = "顯示耐久度"
L["characterFrame.durability.tooltip"] = "在角色面板顯示裝備的耐久度百分比"
L["characterFrame.durability.font"] = "耐久度字型"
L["characterFrame.durability.fontSize"] = "耐久度文字大小"
L["characterFrame.enchant.displayMissing"] = "顯示缺少的附魔"
L["characterFrame.enchant.displayMissing.noenchant"] = "無附魔"
L["characterFrame.enchant.font"] = "附魔字型"
L["characterFrame.enchant.fontSize"] = "附魔文字大小"
L["characterFrame.enchant.title"] = "顯示物品附魔"
L["characterFrame.enchant.tooltip"] = "在角色面板顯示物品附魔"
L["characterFrame.itemLevel.anchorToIcon"] = "錨定到物品圖示"
L["characterFrame.itemLevel.font"] = "物品等級字型"
L["characterFrame.itemLevel.fontSize"] = "物品等級文字大小"
L["characterFrame.itemLevel.point"] = "物品等級顯示位置"
L["characterFrame.itemLevel.point.icon"] = "圖示上"
L["characterFrame.itemLevel.point.side"] = "側邊"
L["characterFrame.itemLevel.title"] = "顯示物品等級"
L["characterFrame.itemLevel.tooltip"] = "在角色面板顯示裝備的物品等級"
L["characterFrame.socket.displayMaxSockets"] = "顯示可添加的插槽"
L["characterFrame.socket.displayMaxSockets.message"] = "這個物品可以添加插槽"
L["characterFrame.socket.iconSize"] = "插槽圖示尺寸"
L["characterFrame.socket.title"] = "顯示插槽"
L["characterFrame.socket.tooltip"] = "在角色面板顯示裝備的物品插槽和寶石"
L["characterFrame.title"] = "角色面板與觀察面板"
L["chatLink.hyperlinkEnhance.applyToGuildNews.title"] = "應用於公會新聞"
L["chatLink.hyperlinkEnhance.applyToGuildNews.tooltip"] = "公會新聞的物品連結也會被替換"
L["chatLink.hyperlinkEnhance.displayIcon.title"] = "顯示圖示"
L["chatLink.hyperlinkEnhance.displayIcon.tooltip"] = "在物品、法術、坐騎連結前加入它們的圖示"
L["chatLink.hyperlinkEnhance.displayItemLevel.title"] = "顯示物品等級"
L["chatLink.hyperlinkEnhance.displayItemLevel.tooltip"] = "在物品連結前顯示其物品等級"
L["chatLink.hyperlinkEnhance.displayItemType.title"] = "顯示物品分類"
L["chatLink.hyperlinkEnhance.displayItemType.tooltip"] = "在物品連結前顯示其分類"
L["chatLink.hyperlinkEnhance.displaySockets.title"] = "顯示插槽"
L["chatLink.hyperlinkEnhance.displaySockets.tooltip"] = "在物品連結後顯示插槽資訊"
L["chatLink.hyperlinkEnhance.title"] = "聊天連結增強"
L["chatLink.hyperlinkEnhance.tooltip"] = "在聊天訊息中的連結裡添加更多資訊"
L["equipmentSummary.equipmentStats"] = "裝備屬性"
L["equipmentSummary.fontSize"] = "內容文字大小"
L["equipmentSummary.inspect.title"] = "觀察時顯示裝備總覽"
L["equipmentSummary.inspect.tooltip"] = "顯示觀察目標的裝備總覽框體，用以顯示裝備列表、套裝、屬性等"
L["equipmentSummary.mainStat"] = "主屬性"
L["equipmentSummary.player.title"] = "顯示角色裝備總覽"
L["equipmentSummary.player.tooltip"] = "在角色面板右側添加一個裝備總覽框體，用以顯示裝備列表、套裝、屬性等"
L["equipmentSummary.slotName.title"] = "顯示部位名稱"
L["equipmentSummary.slotName.tooltip"] = "在裝備總覽中顯示裝備部位"
L["equipmentSummary.statIcon.style.armory.title"] = "《魔獸世界》英雄榜"
L["equipmentSummary.statIcon.style.gearStatSummary.title"] = "GearStatSummary"
L["equipmentSummary.statIcon.title"] = "顯示屬性圖示"
L["equipmentSummary.statIcon.tooltip"] = "在裝備總覽中顯示裝備次要屬性的圖示"
L["equipmentSummary.title"] = "裝備總覽"
L["equipmentSummary.title.fontSize"] = "標題文字大小"
L["itemInfoOverlay.bonding.boe"] = "裝綁"
L["itemInfoOverlay.bonding.btw"] = "戰團"
L["itemInfoOverlay.bondingType.font"] = "綁定類型字型"
L["itemInfoOverlay.bondingType.fontSize"] = "綁定類型文字大小"
L["itemInfoOverlay.bondingType.title"] = "顯示裝備綁定類型"
L["itemInfoOverlay.bondingType.tooltip"] = "在綁定類型為|cff00ccff裝備前戰團綁定|r和|cffffffff裝備後綁定|r的物品圖示上顯示綁定類型"
L["itemInfoOverlay.bonding.wue"] = "戰團"
L["itemInfoOverlay.itemLevel.font"] = "物品等級字型"
L["itemInfoOverlay.itemLevel.fontSize"] = "物品等級文字大小"
L["itemInfoOverlay.itemLevel.title"] = "顯示物品等級"
L["itemInfoOverlay.itemLevel.tooltip"] = "在物品圖示上顯示裝備類物品、套裝兌換物的物品等級\n\n傳奇鑰石的層數也會顯示在圖示上"
L["itemInfoOverlay.itemType.font"] = "物品分類字型"
L["itemInfoOverlay.itemType.fontSize"] = "物品分類文字大小"
L["itemInfoOverlay.itemType.replacer"] = function (text)
    local table = { }
    if table[text] then
        return table[text]
    else
        return text
    end
end
L["itemInfoOverlay.itemType.title"] = "顯示物品分類"
L["itemInfoOverlay.itemType.tooltip"] = "在物品圖示上顯示裝備物品的部位、配方的專業類型"
L["itemInfoOverlay.title"] = "物品圖示覆蓋"
L["other.title"] = "其他"