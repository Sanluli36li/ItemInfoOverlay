if not(GetLocale() == "zhTW") then
    return
end

local ADDON_NAME, ItemInfoOverlay = ...

local L = ItemInfoOverlay.Locale

L["addon.name"] = ADDON_NAME
L["characterFrame.enchant.displayMissing"] = "顯示缺少的附魔"
L["characterFrame.enchant.displayMissing.noenchant"] = "無附魔"
L["characterFrame.enchant.font"] = "附魔字體"
L["characterFrame.enchant.fontSize"] = "附魔文字大小"
L["characterFrame.enchant.title"] = "顯示物品附魔"
L["characterFrame.enchant.tooltip"] = "在角色面板顯示物品附魔"
L["characterFrame.itemLevel.font"] = "物品等級字體"
L["characterFrame.itemLevel.fontSize"] = "物品等級文字大小"
L["characterFrame.itemLevel.point"] = "物品等級顯示位置"
L["characterFrame.itemLevel.point.icon"] = "圖標上"
L["characterFrame.itemLevel.point.side"] = "側邊"
L["characterFrame.itemLevel.title"] = "顯示物品等級"
L["characterFrame.itemLevel.tooltip"] = "在角色面板顯示裝備的物品等級"
L["characterFrame.socket.iconSize"] = "插槽圖標尺寸"
L["characterFrame.socket.title"] = "顯示插槽"
L["characterFrame.socket.tooltip"] = "在角色面板顯示裝備的插槽和寶石"
L["characterFrame.title"] = "角色面板與觀察面板"
L["chatLink.hyperlinkEnhance.displayIcon.title"] = "顯示圖標"
L["chatLink.hyperlinkEnhance.displayIcon.tooltip"] = "在物品、法術、坐騎超鏈接前加入它們的圖標"
L["chatLink.hyperlinkEnhance.displayItemLevel.title"] = "顯示物品等級"
L["chatLink.hyperlinkEnhance.displayItemLevel.tooltip"] = "在物品超鏈接前顯示其等級"
L["chatLink.hyperlinkEnhance.displayItemType.title"] = "顯示物品分類"
L["chatLink.hyperlinkEnhance.displayItemType.tooltip"] = "在物品超鏈接前顯示其分類"
L["chatLink.hyperlinkEnhance.title"] = "超鏈接增强"
L["chatLink.hyperlinkEnhance.tooltip"] = "在聊天信息的超鏈接添加更多信息"
L["chatLink.hyperlinkEnhance.displaySockets.title"] = "顯示插槽"
L["chatLink.hyperlinkEnhance.displaySockets.tooltip"] = "在物品超鏈接后顯示插槽信息"
L["itemInfoOverlay.bonding.boe"] = "裝綁"
L["itemInfoOverlay.bonding.btw"] = "戰團"
L["itemInfoOverlay.bondingType.font"] = "綁定分類字體"
L["itemInfoOverlay.bondingType.fontSize"] = "綁定分類文字大小"
L["itemInfoOverlay.bondingType.title"] = "顯示裝備綁定類型"
L["itemInfoOverlay.bondingType.tooltip"] = "在綁定類型為|cff00ccff裝備前戰團綁定|r和|cffffffff裝備后綁定|r的物品圖標上顯示綁定類型"
L["itemInfoOverlay.bonding.wue"] = "戰團"
L["itemInfoOverlay.itemLevel.font"] = "物品等級字體"
L["itemInfoOverlay.itemLevel.fontSize"] = "物品等級文字大小"
L["itemInfoOverlay.itemLevel.title"] = "顯示物品等級"
L["itemInfoOverlay.itemLevel.tooltip"] = "在物品圖標上顯示裝備、套裝兌換物的物品等級\n\n史詩鑰石的等級也會顯示"
L["itemInfoOverlay.itemType.font"] = "物品分類字體"
L["itemInfoOverlay.itemType.fontSize"] = "物品分類文字大小"
L["itemInfoOverlay.itemType.replacer"] = function (text)
    local table = {}
    if table[text] then
        return table[text]
    else
        return text
    end
end
L["itemInfoOverlay.itemType.title"] = "顯示物品分類"
L["itemInfoOverlay.itemType.tooltip"] = "在物品圖標上顯示裝備物品的部位、配方的裝備類型"
L["itemInfoOverlay.title"] = "物品圖標覆蓋"
L["other.title"] = "其他"
