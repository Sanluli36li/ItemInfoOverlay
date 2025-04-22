if not(GetLocale() == "zhCN") then
    return
end

local ADDON_NAME, ItemInfoOverlay = ...

local L = ItemInfoOverlay.Locale

L["addon.name"] = ADDON_NAME
L["addon.sanluliUtils.tooltip"] = "\n\n|cffff0000此功能来自\"SanluliUtils\", 若你已载入该插件, 此功能不会生效|r"
L["characterFrame.durability.title"] = "显示耐久度"
L["characterFrame.durability.tooltip"] = "在角色面板显示装备的耐久度百分比"
L["characterFrame.durability.font"] = "耐久度字体"
L["characterFrame.durability.fontSize"] = "耐久度文字大小"
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
L["characterFrame.itemLevel.title"] = "显示物品等级"
L["characterFrame.itemLevel.tooltip"] = "在角色面板显示装备的物品等级"
L["characterFrame.pvpItemLevel.font"] = "PvP物品等级字体"
L["characterFrame.pvpItemLevel.fontSize"] = "PvP物品等级文字大小"
L["characterFrame.pvpItemLevel.title"] = "显示PvP物品等级"
L["characterFrame.pvpItemLevel.tooltip"] = "在角色面板显示装备的PvP物品等级"
L["characterFrame.selector"] = "选择编辑元素"
L["characterFrame.selector.itemLevel"] = "物品等级"
L["characterFrame.selector.enchantAndSockets"] = "附魔和插槽"
L["characterFrame.selector.other"] = "其他"
L["characterFrame.socket.displayMaxSockets"] = "显示可添加的插槽"
L["characterFrame.socket.displayMaxSockets.message"] = "这个物品可以添加插槽"
L["characterFrame.socket.iconSize"] = "插槽图标尺寸"
L["characterFrame.socket.title"] = "显示插槽"
L["characterFrame.socket.tooltip"] = "在角色面板显示装备的物品插槽和宝石"
L["characterFrame.title"] = "角色面板与观察面板"
L["chatLink.hyperlinkEnhance.applyToGuildNews.title"] = "应用于公会新闻"
L["chatLink.hyperlinkEnhance.applyToGuildNews.tooltip"] = "公会新闻的物品链接也会被替换"
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
L["equipmentSummary.equipmentStats"] = "装备属性"
L["equipmentSummary.fontSize"] = "内容文字大小"
L["equipmentSummary.inspect.title"] = "观察时显示装备总览"
L["equipmentSummary.inspect.tooltip"] = "显示观察目标的装备总览框体, 用以显示装备列表、套装、属性等"
L["equipmentSummary.mainStat"] = "主属性"
L["equipmentSummary.player.title"] = "显示角色装备总览"
L["equipmentSummary.player.tooltip"] = "在角色面板右侧添加一个装备总览框体, 用以显示装备列表、套装、属性等"
L["equipmentSummary.slotName.title"] = "显示部位名称"
L["equipmentSummary.slotName.tooltip"] = "在装备总览中显示装备部位"
L["equipmentSummary.statIcon.style.armory.title"] = "魔兽世界英雄榜"
L["equipmentSummary.statIcon.style.gearStatSummary.title"] = "GearStatSummary"
L["equipmentSummary.statIcon.title"] = "显示属性图标"
L["equipmentSummary.statIcon.tooltip"] = "在装备总览中显示装备次要属性的图标"
L["equipmentSummary.title"] = "装备总览"
L["equipmentSummary.title.fontSize"] = "标题文字大小"
L["itemInfoOverlay.bonding.boe"] = "装绑"
L["itemInfoOverlay.bonding.btw"] = "战团"
L["itemInfoOverlay.bondingType.font"] = "绑定类型字体"
L["itemInfoOverlay.bondingType.fontSize"] = "绑定类型文字大小"
L["itemInfoOverlay.bondingType.title"] = "显示装备绑定类型"
L["itemInfoOverlay.bondingType.tooltip"] = "在绑定类型为|cff00ccff装备前战团绑定|r和|cffffffff装备后绑定|r的物品图标上显示绑定类型"
L["itemInfoOverlay.bonding.wue"] = "战团"
L["itemInfoOverlay.customAnchor"] = "自定义锚点"
L["itemInfoOverlay.itemLevel.color.title"] = "物品等级颜色"
L["itemInfoOverlay.itemLevel.color.tooltip"] = "指定显示物品等级的字体颜色"
L["itemInfoOverlay.itemLevel.color.customColor"] = "使用自定义颜色"
L["itemInfoOverlay.itemLevel.color.custom.title"] = "自定义颜色"
L["itemInfoOverlay.itemLevel.color.itemQuality"] = "基于物品品质"
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
L["tooltip.itemLevel.title"] = "鼠标提示装等"
L["tooltip.itemLevel.tooltip"] = "在鼠标提示中添加单位的物品等级显示\n\n当获取一名玩家装等后, 60秒内不会尝试更新其装等(除非你手动观察他)\n\n此功能依赖于观察, 因此当观察界面打开时(被占用), 鼠标提示只会显示已缓存的数据, 并不会获取新的数据"
