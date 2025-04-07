if not(GetLocale() == "zhTW") then
    return
end

local ADDON_NAME, ItemInfoOverlay = ...

local L = ItemInfoOverlay.Locale

L["addon.name"] = ADDON_NAME
L["addon.sanluliUtils.tooltip"] = "\n\n|cffff0000此功能來自\"SanluliUtils\", 若你已載入此插件, 此功能不會生效|r"
L["characterFrame.compareStats.mainStat"] = "主屬性"
L["characterFrame.compareStats.title"] = "屬性對比"
L["characterFrame.compareStats.tooltip.title"] = "裝備屬性: %s"
L["characterFrame.compareStats.tooltip.info"] = "屬性僅來自裝備\n不包括附魔/寶石/Buff\n僅供參考"
L["characterFrame.durability.title"] = "顯示耐久度"
L["characterFrame.durability.tooltip"] = "在角色面板顯示裝備的耐久度"
L["characterFrame.durability.font"] = "耐久度字體"
L["characterFrame.durability.fontSize"] = "耐久度文字大小"
L["characterFrame.enchant.displayMissing"] = "顯示缺少的附魔"
L["characterFrame.enchant.displayMissing.noenchant"] = "無附魔"
L["characterFrame.enchant.font"] = "附魔字體"
L["characterFrame.enchant.fontSize"] = "附魔文字大小"
L["characterFrame.enchant.title"] = "顯示物品附魔"
L["characterFrame.enchant.tooltip"] = "在角色面板顯示物品附魔"
L["characterFrame.itemLevel.anchorToIcon"] = "錨定到物品圖標"
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
L["chatLink.hyperlinkEnhance.applyToGuildNews.title"] = "应用于公会新闻"
L["chatLink.hyperlinkEnhance.applyToGuildNews.tooltip"] = "公会新闻的物品链接也会被替换"
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
L["equipmentSummary.title"] = "装备总览"
L["equipmentSummary.inspect.title"] = "观察时显示装备总览"
L["equipmentSummary.inspect.tooltip"] = "显示观察目标的装备总览框体, 用以显示装备列表、套装、属性等"
L["equipmentSummary.player.title"] = "显示角色装备总览"
L["equipmentSummary.player.tooltip"] = "在角色面板右侧添加一个装备总览框体, 用以显示装备列表、套装、属性等"
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
