local ADDON_NAME, ItemInfoOverlay = ...

local L = ItemInfoOverlay.Locale

L["addon.name"] = ADDON_NAME
L["addon.sanluliUtils.tooltip"] = "\n\n|cffff0000This feature comes from \"SanluliUtils\". If you have this addon loaded, this feature will not work|r"
L["characterFrame.durability.title"] = "Show Durability"
L["characterFrame.durability.tooltip"] = "Display equipment durability percentage on character frame"
L["characterFrame.durability.font"] = "Durability Font"
L["characterFrame.durability.fontSize"] = "Durability Font Size"
L["characterFrame.enchant.displayMissing"] = "Show Missing Enchants"
L["characterFrame.enchant.displayMissing.noenchant"] = "NoEnchant"
L["characterFrame.enchant.font"] = "Enchant Font"
L["characterFrame.enchant.fontSize"] = "Enchant Font Size"
L["characterFrame.enchant.title"] = "Show Item Enchants"
L["characterFrame.enchant.tooltip"] = "Display item enchants on character frame"
L["characterFrame.itemLevel.anchorToIcon"] = "Anchor to Item Icon"
L["characterFrame.itemLevel.font"] = "Item Level Font"
L["characterFrame.itemLevel.fontSize"] = "Item Level Font Size"
L["characterFrame.itemLevel.point"] = "Item Level Position"
L["characterFrame.itemLevel.point.icon"] = "On Icon"
L["characterFrame.itemLevel.point.side"] = "Side"
L["characterFrame.itemLevel.title"] = "Show Item Levels"
L["characterFrame.itemLevel.tooltip"] = "Display item levels on character frame"
L["characterFrame.socket.displayMaxSockets"] = "Show Max Sockets"
L["characterFrame.socket.displayMaxSockets.message"] = "This item can have sockets added"
L["characterFrame.socket.iconSize"] = "Socket Icon Size"
L["characterFrame.socket.title"] = "Show Sockets"
L["characterFrame.socket.tooltip"] = "Display item sockets and gems on character frame"
L["characterFrame.title"] = "Character & Inspect Frame"
L["chatLink.hyperlinkEnhance.applyToGuildNews.title"] = "Apply to Guild News"
L["chatLink.hyperlinkEnhance.applyToGuildNews.tooltip"] = "Also replace item links in guild news"
L["chatLink.hyperlinkEnhance.displayIcon.title"] = "Display Icons"
L["chatLink.hyperlinkEnhance.displayIcon.tooltip"] = "Add icons before item, spell, and mount links"
L["chatLink.hyperlinkEnhance.displayItemLevel.title"] = "Show Item Levels"
L["chatLink.hyperlinkEnhance.displayItemLevel.tooltip"] = "Display item level before item links"
L["chatLink.hyperlinkEnhance.displayItemType.title"] = "Show Item Types"
L["chatLink.hyperlinkEnhance.displayItemType.tooltip"] = "Display item category before item links"
L["chatLink.hyperlinkEnhance.displaySockets.title"] = "Show Sockets"
L["chatLink.hyperlinkEnhance.displaySockets.tooltip"] = "Display socket information after item links"
L["chatLink.hyperlinkEnhance.title"] = "Chat Link Enhancements"
L["chatLink.hyperlinkEnhance.tooltip"] = "Add more information to chat links"
L["equipmentSummary.equipmentStats"] = "Equipment Stats"
L["equipmentSummary.fontSize"] = "Content Font Size"
L["equipmentSummary.inspect.title"] = "Show Summary When Inspecting"
L["equipmentSummary.inspect.tooltip"] = "Display equipment summary frame when inspecting others"
L["equipmentSummary.mainStat"] = "Main Stat"
L["equipmentSummary.player.title"] = "Show Character Summary"
L["equipmentSummary.player.tooltip"] = "Add equipment summary frame to character panel"
L["equipmentSummary.slotName.title"] = "Show Slot Names"
L["equipmentSummary.slotName.tooltip"] = "Display equipment slot names in summary"
L["equipmentSummary.statIcon.style.armory.title"] = "WoW Armory"
L["equipmentSummary.statIcon.style.gearStatSummary.title"] = "GearStatSummary"
L["equipmentSummary.statIcon.title"] = "Show Stat Icons"
L["equipmentSummary.statIcon.tooltip"] = "Display secondary stat icons in summary"
L["equipmentSummary.title"] = "Equipment Summary"
L["equipmentSummary.title.fontSize"] = "Title Font Size"
L["itemInfoOverlay.bonding.boe"] = "BoE"
L["itemInfoOverlay.bonding.btw"] = "BtW"
L["itemInfoOverlay.bondingType.font"] = "Bonding Type Font"
L["itemInfoOverlay.bondingType.fontSize"] = "Bonding Font Size"
L["itemInfoOverlay.bondingType.title"] = "Show Binding Type"
L["itemInfoOverlay.bondingType.tooltip"] = "Show binding type on items with |cff00ccffBinds to Warband until equipped|r or |cffffffffBind on Equip|r"
L["itemInfoOverlay.bonding.wue"] = "WuE"
L["itemInfoOverlay.itemLevel.font"] = "Item Level Font"
L["itemInfoOverlay.itemLevel.fontSize"] = "Item Level Font Size"
L["itemInfoOverlay.itemLevel.title"] = "Show Item Levels"
L["itemInfoOverlay.itemLevel.tooltip"] = "Display item level on equippable items and set tokens\n\nMythic+ Keystone levels will also be shown"
L["itemInfoOverlay.itemType.font"] = "Item Type Font"
L["itemInfoOverlay.itemType.fontSize"] = "Item Type Font Size"
L["itemInfoOverlay.itemType.replacer"] = function (text)
    local table = {
        ["One-Handed Axes"] = "1H-Axe",
        ["Two-Handed Axes"] = "2H-Axe",
        ["One-Handed Maces"] = "1H-Mace",
        ["Two-Handed Maces"] = "2H-Mace",
        ["One-Handed Swords"] = "1H-Sword",
        ["Two-Handed Swords"] = "2H-Sword",
        ["Fist Weapons"] = "Fist",
        ["Held In Off-hand"] = "Off-hand",
    }
    if table[text] then
        return table[text]
    else
        return text
    end
end
L["itemInfoOverlay.itemType.title"] = "Show Item Types"
L["itemInfoOverlay.itemType.tooltip"] = "Display equipment slot or profession type on items"
L["itemInfoOverlay.title"] = "Item Info Overlay"
L["other.title"] = "Other"