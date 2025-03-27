if not(GetLocale() == "ruRU") then
    return
end

local ADDON_NAME, ItemInfoOverlay = ...

local L = ItemInfoOverlay.Locale

L["addon.name"] = ADDON_NAME
L["characterFrame.enchant.displayMissing"] = "Показывать отсутствующие зачарования"
L["characterFrame.enchant.displayMissing.noenchant"] = "Нет зачарования"
L["characterFrame.enchant.font"] = "Шрифт зачарований"
L["characterFrame.enchant.fontSize"] = "Размер шрифта зачарований"
L["characterFrame.enchant.title"] = "Отображение зачарований предметов"
L["characterFrame.enchant.tooltip"] = "Показывать зачарования предметов на иконках в окне персонажа и при осмотре"
L["characterFrame.itemLevel.font"] = "Шрифт уровня предметов"
L["characterFrame.itemLevel.fontSize"] = "Размер шрифта уровня предметов"
L["characterFrame.itemLevel.point"] = "Расположение уровня предметов"
L["characterFrame.itemLevel.point.icon"] = "На иконке"
L["characterFrame.itemLevel.point.side"] = "Сбоку"
L["characterFrame.itemLevel.title"] = "Отображение уровня предметов"
L["characterFrame.itemLevel.tooltip"] = "Показывать уровень предметов на иконках в окне персонажа и при осмотре"
L["characterFrame.socket.iconSize"] = "Размер иконки гнезда"
L["characterFrame.socket.title"] = "Отображение гнезд для камней"
L["characterFrame.socket.tooltip"] = "Показывать камни и гнезда на иконках предметов в окне персонажа и при осмотре"
L["itemInfoOverlay.bonding.boe"] = "BoE"
 -- (При получении) BoE — При получении Непривязывается
L["itemInfoOverlay.bondingType.font"] = "Шрифт типа привязки"
L["itemInfoOverlay.bondingType.fontSize"] = "Размер шрифта типа привязки"
L["itemInfoOverlay.bondingType.title"] = "Отображение типа привязки экипировки"
L["itemInfoOverlay.bondingType.tooltip"] = "Показывает тип привязки на иконках предметов с типами |cff00ccffПривязывается к отряду до экипировки(ПкО)|r и |cffffffffПерсональный при получении(BoE)|r"
L["itemInfoOverlay.bonding.wue"] = "ПкО" 
 -- (При экипировке) ПкО — При экипировке Отряду
L["itemInfoOverlay.itemLevel.font"] = "Шрифт уровня предмета"
L["itemInfoOverlay.itemLevel.fontSize"] = "Размер шрифта уровня предмета"
L["itemInfoOverlay.itemLevel.title"] = "Размер шрифта уровня предмета"
L["itemInfoOverlay.itemLevel.tooltip"] = "Показывать уровень предмета на иконках экипировки\n\nТакже отображает уровень ключа М+"
L["itemInfoOverlay.itemType.font"] = "Шрифт типа предмета"
L["itemInfoOverlay.itemType.fontSize"] = "Размер шрифта типа предмета"
L["itemInfoOverlay.itemType.title"] = "Размер шрифта"
L["itemInfoOverlay.itemType.tooltip"] = "Показывает расположение предмета экипировки и профессию рецепта на иконке предмета"
L["itemInfoOverlay.title"] = "Наложение информации о предмете"
