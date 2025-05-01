if not(GetLocale() == "ruRU") then
    return
end
local ADDON_NAME, ItemInfoOverlay = ...
local L = ItemInfoOverlay.Locale
L["addon.name"] = ADDON_NAME
L["addon.sanluliUtils.tooltip"] = "\n\n|cffff0000Эта функция перенесена из \"SanluliUtils\". Если у вас загружен этот аддон, данная функция не будет работать.|r"
L["characterFrame.compareStats.mainStat"] = "Основная характеристика"
L["characterFrame.compareStats.title"] = "Характеристики"
L["characterFrame.compareStats.tooltip.title"] = "Характеристики экипировки: %s"
L["characterFrame.compareStats.tooltip.info"] = "Характеристики только от экипировки\nНе включают чары, камни и баффы\nТолько для справки"
L["characterFrame.durability.title"] = "Отображать прочность"
L["characterFrame.durability.tooltip"] = "Отображать прочность на иконках предметов в окне персонажа"
L["characterFrame.durability.font"] = "Шрифт прочности"
L["characterFrame.durability.fontSize"] = "Размер шрифта прочности"
L["characterFrame.enchant.displayMissing"] = "Отображать отсутствующие чары"
L["characterFrame.enchant.displayMissing.noenchant"] = "Нет чар"
L["characterFrame.enchant.font"] = "Шрифт чар"
L["characterFrame.enchant.fontSize"] = "Размер шрифта чар"
L["characterFrame.enchant.title"] = "Отображать чары предметов"
L["characterFrame.enchant.tooltip"] = "Отображать чары на иконках предметов в окне персонажа и осмотра"
L["characterFrame.itemLevel.anchorToIcon"] = "Привязать к иконке"
L["characterFrame.itemLevel.font"] = "Шрифт уровня предмета"
L["characterFrame.itemLevel.fontSize"] = "Размер шрифта уровня предмета"
L["characterFrame.itemLevel.point"] = "Место отображения уровня предмета"
L["characterFrame.itemLevel.point.icon"] = "На иконке"
L["characterFrame.itemLevel.point.side"] = "Сбоку"
L["characterFrame.itemLevel.title"] = "Отображать уровень предмета"
L["characterFrame.itemLevel.tooltip"] = "Отображать уровень предмета на иконках в окне персонажа и осмотра"
L["characterFrame.socket.iconSize"] = "Размер иконки гнезда"
L["characterFrame.socket.title"] = "Отображать гнезда"
L["characterFrame.socket.tooltip"] = "Отображать камни и гнезда на иконках предметов в окне персонажа и осмотра"
L["characterFrame.title"] = "Окно персонажа и осмотра"
L["chatLink.hyperlinkEnhance.applyToGuildNews.title"] = "Применять к новостям гильдии"
L["chatLink.hyperlinkEnhance.applyToGuildNews.tooltip"] = "Ссылки на предметы в новостях гильдии будут заменены"
L["chatLink.hyperlinkEnhance.displayIcon.title"] = "Отображать иконку"
L["chatLink.hyperlinkEnhance.displayIcon.tooltip"] = "Отображать иконку перед ссылками на предметы, заклинания и транспорт"
L["chatLink.hyperlinkEnhance.displayItemLevel.title"] = "Отображать уровень предмета"
L["chatLink.hyperlinkEnhance.displayItemLevel.tooltip"] = "Отображать уровень предмета перед ссылкой на предмет"
L["chatLink.hyperlinkEnhance.displayItemType.title"] = "Отображать тип предмета"
L["chatLink.hyperlinkEnhance.displayItemType.tooltip"] = "Отображать тип предмета перед ссылкой на предмет"
L["chatLink.hyperlinkEnhance.displaySockets.title"] = "Отображать гнезда"
L["chatLink.hyperlinkEnhance.displaySockets.tooltip"] = "Отображать гнезда после ссылки на предмет"
L["chatLink.hyperlinkEnhance.title"] = "Улучшение ссылок в чате"
L["chatLink.hyperlinkEnhance.tooltip"] = "Добавляет дополнительную информацию в ссылки чата"
L["equipmentSummary.equipmentStats"] = "Характеристики экипировки"
L["equipmentSummary.inspect.title"] = "Отображение обзора сводки"
L["equipmentSummary.inspect.tooltip"] = "Отображает окно сводки экипировки проверенной цели, который используется для отображения списков экипировки, сетов, атрибутов и т. д."
L["equipmentSummary.mainStat"] = "Основная характеристика"
L["equipmentSummary.player.title"] = "Отображение сводки игрока"
L["equipmentSummary.player.tooltip"] = "Отображает окно сводки экипировки справа от рамки персонажа, которая используется для отображения списков экипировки, сетов, атрибутов и т. д."
L["equipmentSummary.title"] = "Обзор экипировки"
L["itemInfoOverlay.bonding.boe"] = "BoE"
L["itemInfoOverlay.bonding.btw"] = "ПкО"
L["itemInfoOverlay.bonding.wue"] = "ПкО"
L["itemInfoOverlay.extraInfo.bondingType"] = "Отображать тип привязки экипировки"
L["itemInfoOverlay.extraInfo.bondingType.tooltip"] = "Отображает тип привязки на иконках предметов с типами |cff00ccffПривязывается к отряду до экипировки (ПкО)|r и |cffffffffПерсональный при получении(BoE)|r"
L["itemInfoOverlay.extraInfo.font"] = "Шрифт типа привязки"
L["itemInfoOverlay.extraInfo.fontSize"] = "Размер шрифта типа привязки"
L["itemInfoOverlay.extraInfo.pvpItemLevel"] = "Show PvP Item Levels"
L["itemInfoOverlay.extraInfo.title"] = "Show Extra Item Info"
L["itemInfoOverlay.extraInfo.tooltip"] = "Display extra item info on item icon"
L["itemInfoOverlay.itemLevel.font"] = "Шрифт уровня предмета"
L["itemInfoOverlay.itemLevel.fontSize"] = "Размер шрифта уровня предмета"
L["itemInfoOverlay.itemLevel.title"] = "Размер шрифта уровня предмета"
L["itemInfoOverlay.itemLevel.tooltip"] = "Отображать уровень предмета на иконках экипировки\n\nТакже отображает уровень ключа подземелья (M+)"
L["itemInfoOverlay.itemType.font"] = "Шрифт типа предмета"
L["itemInfoOverlay.itemType.fontSize"] = "Размер шрифта типа предмета"
L["itemInfoOverlay.itemType.replacer"] = function (text)
    local table = {
        ["One-Handed Axes"] = "1H-Топор",
        ["Two-Handed Axes"] = "2H-Топор",
        ["One-Handed Maces"] = "1H-Дробящее",
        ["Two-Handed Maces"] = "2H-Дробящее",
        ["One-Handed Swords"] = "1H-Меч",
        ["Two-Handed Swords"] = "2H-Меч",
        ["Fist Weapons"] = "Кистевое",
        ["Held In Off-hand"] = "Левая рука",
    }
    if table[text] then
        return table[text]
    else
        return text
    end
end
L["itemInfoOverlay.itemType.title"] = "Размер шрифта"
L["itemInfoOverlay.itemType.tooltip"] = "Отображать расположение предмета экипировки и профессию рецепта на иконке предмета"
L["itemInfoOverlay.title"] = "Наложение на кнопку предмета"
L["other.title"] = "Другое"
