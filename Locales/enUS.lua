local ADDON_NAME, ItemInfoOverlay = ...

local L = ItemInfoOverlay.Locale

L["addon.name"] = ADDON_NAME
L["characterFrame.enchant.displayMissing"] = "Display Missing Enchant"
L["characterFrame.enchant.displayMissing.noenchant"] = "NoEnchant"
L["characterFrame.enchant.font"] = "Enchant Font"
L["characterFrame.enchant.fontSize"] = "Enchant Font Size"
L["characterFrame.enchant.title"] = "Display Item Enchant"
L["characterFrame.enchant.tooltip"] = "Display Item Enchant on Item Icon of Character Frame and Inspect Frame"
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
L["itemInfoOverlay.bonding.boe"] = "BoE"
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
