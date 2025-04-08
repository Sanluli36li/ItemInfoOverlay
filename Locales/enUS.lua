local ADDON_NAME, ItemInfoOverlay = ...

local L = ItemInfoOverlay.Locale

L["addon.name"] = ADDON_NAME
L["addon.sanluliUtils.tooltip"] = "\n\n|cffff0000This feature is transplanted from \"SanluliUtils\", if you have loaded the add-on, this feature will not take effect|r"
L["characterFrame.compareStats.mainStat"] = "Main Stat"
L["characterFrame.compareStats.title"] = "Stats"
L["characterFrame.compareStats.tooltip.title"] = "Equipment Stats: %s"
L["characterFrame.compareStats.tooltip.info"] = "Stats are only from equipment\nDoes not include enchants/gems/buffs\nFor reference only"
L["characterFrame.durability.title"] = "Display Durability"
L["characterFrame.durability.tooltip"] = "Display Durability on Item Icon of Character Frame"
L["characterFrame.durability.font"] = "Durability Font"
L["characterFrame.durability.fontSize"] = "Durability Font Size"
L["characterFrame.enchant.displayMissing"] = "Display Missing Enchant"
L["characterFrame.enchant.displayMissing.noenchant"] = "NoEnchant"
L["characterFrame.enchant.font"] = "Enchant Font"
L["characterFrame.enchant.fontSize"] = "Enchant Font Size"
L["characterFrame.enchant.title"] = "Display Item Enchant"
L["characterFrame.enchant.tooltip"] = "Display Item Enchant on Item Icon of Character Frame and Inspect Frame"
L["characterFrame.itemLevel.anchorToIcon"] = "Anchor to Icon"
L["characterFrame.itemLevel.font"] = "ItemLevel Font"
L["characterFrame.itemLevel.fontSize"] = "ItemLevel Font Size"
L["characterFrame.itemLevel.point"] = "Display Location of ItemLevel"
L["characterFrame.itemLevel.point.icon"] = "On Icon"
L["characterFrame.itemLevel.point.side"] = "Side"
L["characterFrame.itemLevel.title"] = "Display ItemLevel"
L["characterFrame.itemLevel.tooltip"] = "Display ItemLevel on Item Icon of Character Frame and Inspect Frame"
L["characterFrame.socket.iconSize"] = "GemSocket Icon Size"
L["characterFrame.socket.title"] = "Display GemSocket"
L["characterFrame.socket.tooltip"] = "Display Gem and Socket on Item Icon of Character Frame and Inspect Frame"
L["characterFrame.title"] = "Character and Inspect Frame"
L["chatLink.hyperlinkEnhance.applyToGuildNews.title"] = "Apply To GuildNews"
L["chatLink.hyperlinkEnhance.applyToGuildNews.tooltip"] = "ItemLink in GuildNews will be replace"
L["chatLink.hyperlinkEnhance.displayIcon.title"] = "Display Icon"
L["chatLink.hyperlinkEnhance.displayIcon.tooltip"] = "Display icon before hyperlink of items, spells and mounts"
L["chatLink.hyperlinkEnhance.displayItemLevel.title"] = "Display Item Level"
L["chatLink.hyperlinkEnhance.displayItemLevel.tooltip"] = "Display item level before hyperlink of items"
L["chatLink.hyperlinkEnhance.displayItemType.title"] = "Display Item Type"
L["chatLink.hyperlinkEnhance.displayItemType.tooltip"] = "Display item type before hyperlink of items"
L["chatLink.hyperlinkEnhance.displaySockets.title"] = "Display Gem Sockets"
L["chatLink.hyperlinkEnhance.displaySockets.tooltip"] = "Display gem sockets after hyperlink of items"
L["chatLink.hyperlinkEnhance.title"] = "Chat Hyperlink Enhance"
L["chatLink.hyperlinkEnhance.tooltip"] = "Add more infomation in chat hyperlink"
L["equipmentSummary.equipmentStats"] = "Equipment Stats"
L["equipmentSummary.fontSize"] = "Content Font Size"
L["equipmentSummary.inspect.title"] = "Display Inspect Summary"
L["equipmentSummary.inspect.tooltip"] = "Displays the Equipment Summary frame of the inspected target, which is used to display equipment lists, sets, attributes, etc."
L["equipmentSummary.mainStat"] = "Main Stat"
L["equipmentSummary.player.title"] = "Display Player Summary"
L["equipmentSummary.player.tooltip"] = "Displays the Equipment Summary frame on right side of Character Frame, which is used to display equipment lists, sets, attributes, etc."
L["equipmentSummary.slotName.title"] = "Display Slot Name"
L["equipmentSummary.slotName.tooltip"] = "Display slot name in equipment summary"
L["equipmentSummary.statIcon.style.armory.title"] = "WoWArmory"
L["equipmentSummary.statIcon.style.gearStatSummary.title"] = "GearStatSummary"
L["equipmentSummary.statIcon.title"] = "Display Stats Icon"
L["equipmentSummary.statIcon.tooltip"] = "Display icons for equipment stats in equipment summary"
L["equipmentSummary.title"] = "Equipment Summary"
L["equipmentSummary.title.fontSize"] = "Title Font Size"
L["itemInfoOverlay.bonding.boe"] = "BoE"
L["itemInfoOverlay.bonding.btw"] = "BtW"
L["itemInfoOverlay.bondingType.font"] = "Bonding Type Font"
L["itemInfoOverlay.bondingType.fontSize"] = "Bonding Type Font Size"
L["itemInfoOverlay.bondingType.title"] = "Display Bonding Type of Equipment"
L["itemInfoOverlay.bondingType.tooltip"] = "Displays the binding type on the item icons of items with binding type |cff00ccffBinds to Warband until equipped(WuE)|r and |cffffffff Bind on Equip(BoE)|r"
L["itemInfoOverlay.bonding.wue"] = "WuE"
L["itemInfoOverlay.itemLevel.font"] = "ItemLevel Font"
L["itemInfoOverlay.itemLevel.fontSize"] = "ItemLevel Font Size"
L["itemInfoOverlay.itemLevel.title"] = "ItemLevel Font Size"
L["itemInfoOverlay.itemLevel.tooltip"] = "Display ItemLevel on icon of equipment's item icon\n\nIt's also display level of M+ Keystone"
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
L["itemInfoOverlay.itemType.title"] = "Display Font Size"
L["itemInfoOverlay.itemType.tooltip"] = "Display the location of the equipment item and the profession of the recipe on the item icon"
L["itemInfoOverlay.title"] = "Item Button Overlay"
L["other.title"] = "Other"
