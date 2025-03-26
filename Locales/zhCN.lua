if not(GetLocale() == "zhCN") then
    return
end

local ADDON_NAME, ItemInfoOverlay = ...

local L = ItemInfoOverlay.Locale

L["addon.name"] = ADDON_NAME
L["characterFrame.enchant.displayMissing"] = "显示缺少的附魔"
L["characterFrame.enchant.displayMissing.noenchant"] = "无附魔"
L["characterFrame.enchant.font"] = "附魔字体"
L["characterFrame.enchant.fontSize"] = "附魔文字大小"
L["characterFrame.enchant.title"] = "显示物品附魔"
L["characterFrame.enchant.tooltip"] = "在角色面板显示物品附魔"
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
L["itemInfoOverlay.bonding.boe"] = "装绑"
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
L["itemInfoOverlay.itemType.title"] = "显示物品分类"
L["itemInfoOverlay.itemType.tooltip"] = "在物品图标上显示装备物品的部位、配方的专业类型"
L["itemInfoOverlay.title"] = "物品图标覆盖"
