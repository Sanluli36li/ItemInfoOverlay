if not(GetLocale() == "zhCN") then
    return
end

local ADDON_NAME, ItemInfoOverlay = ...

local L = ItemInfoOverlay.Locale

L["addon.name"] = ADDON_NAME
L["addon.sanluliUtils.tooltip"] = "\n\n|cffff0000此功能来自\"SanluliUtils\", 若你已载入该插件, 此功能不会生效|r"
L["characterFrame.compareStats.mainStat"] = "主属性"
L["characterFrame.compareStats.title"] = "属性对比"
L["characterFrame.compareStats.tooltip.title"] = "装备属性: %s"
L["characterFrame.compareStats.tooltip.info"] = "属性仅来源于装备\n不包括附魔/宝石/Buff\n仅供参考"
L["characterFrame.durability.title"] = "显示耐久度"
L["characterFrame.durability.tooltip"] = "在角色面板显示装备的耐久度百分比"
L["characterFrame.itemLevel.font"] = "耐久度字体"
L["characterFrame.itemLevel.fontSize"] = "耐久度文字大小"
L["characterFrame.enchant.displayMissing"] = "显示缺少的附魔"
L["characterFrame.enchant.displayMissing.noenchant"] = "无附魔"
L["characterFrame.enchant.font"] = "附魔字体"
L["characterFrame.enchant.fontSize"] = "附魔文字大小"
L["characterFrame.enchant.title"] = "显示物品附魔"
L["characterFrame.enchant.tooltip"] = "在角色面板显示物品附魔"
L["characterFrame.itemLevel.anchorToIcon"] = "锚定到物品图标"
L["characterFrame.itemLevel.font"] = "物品等级字体"
L["characterFrame.itemLevel.fontSize"] = "物品等级文字大小"
L["characterFrame.itemLevel.point"] = "物品等级显示位置"
L["characterFrame.itemLevel.point.icon"] = "图标上"
L["characterFrame.itemLevel.point.side"] = "侧边"
L["characterFrame.itemLevel.title"] = "显示物品等级"
L["characterFrame.itemLevel.tooltip"] = "在角色面板显示装备的物品等级"
L["characterFrame.socket.iconSize"] = "插槽图标尺寸"
L["characterFrame.socket.title"] = "显示插槽"
L["characterFrame.socket.tooltip"] = "在角色面板显示装备的物品插槽和宝石"
L["characterFrame.title"] = "角色面板与观察面板"
L["chatLink.hyperlinkEnhance.displayIcon.title"] = "显示图标"
L["chatLink.hyperlinkEnhance.displayIcon.tooltip"] = "在物品、法术、坐骑链接前加入它们的图标"
L["chatLink.hyperlinkEnhance.displayItemLevel.title"] = "显示物品等级"
L["chatLink.hyperlinkEnhance.displayItemLevel.tooltip"] = "在物品链接前显示其物品等级"
L["chatLink.hyperlinkEnhance.displayItemType.title"] = "显示物品分类"
L["chatLink.hyperlinkEnhance.displayItemType.tooltip"] = "在物品链接前显示其分类"
L["chatLink.hyperlinkEnhance.displaySockets.title"] = "显示插槽"
L["chatLink.hyperlinkEnhance.displaySockets.tooltip"] = "在物品链接后显示插槽信息"
L["chatLink.hyperlinkEnhance.title"] = "聊天链接增强"
L["chatLink.hyperlinkEnhance.tooltip"] = "在聊天信息中的链接里添加更多信息"
L["itemInfoOverlay.bonding.boe"] = "装绑"
L["itemInfoOverlay.bonding.btw"] = "战团"
L["itemInfoOverlay.bondingType.font"] = "绑定类型字体"
L["itemInfoOverlay.bondingType.fontSize"] = "绑定类型文字大小"
L["itemInfoOverlay.bondingType.title"] = "显示装备绑定类型"
L["itemInfoOverlay.bondingType.tooltip"] = "在绑定类型为|cff00ccff装备前战团绑定|r和|cffffffff装备后绑定|r的物品图标上显示绑定类型"
L["itemInfoOverlay.bonding.wue"] = "战团"
L["itemInfoOverlay.itemLevel.font"] = "物品等级字体"
L["itemInfoOverlay.itemLevel.fontSize"] = "物品等级文字大小"
L["itemInfoOverlay.itemLevel.title"] = "显示物品等级"
L["itemInfoOverlay.itemLevel.tooltip"] = "在物品图标上显示装备类物品、套装兑换物的物品等级\n\n史诗钥石的层数也会显示在图标上"
L["itemInfoOverlay.itemType.font"] = "物品分类字体"
L["itemInfoOverlay.itemType.fontSize"] = "物品分类文字大小"
L["itemInfoOverlay.itemType.replacer"] = function (text)
    local table = {
        ["长柄武器"] = "长柄",
        ["副手物品"] = "副手",
    }
    if table[text] then
        return table[text]
    else
        return text
    end
end
L["itemInfoOverlay.itemType.title"] = "显示物品分类"
L["itemInfoOverlay.itemType.tooltip"] = "在物品图标上显示装备物品的部位、配方的专业类型"
L["itemInfoOverlay.title"] = "物品图标覆盖"
L["other.title"] = "其他"
