local ADDON_NAME, ItemInfoOverlay = ...

local Module = ItemInfoOverlay:NewModule("settings")
local L = ItemInfoOverlay.Locale

local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local LibBlzSettings = LibStub("LibBlzSettings-1.0")

local CONTROL_TYPE = LibBlzSettings.CONTROL_TYPE
local SETTING_TYPE = LibBlzSettings.SETTING_TYPE

local POINTS = {
    "TOPLEFT",
    "TOP",
    "TOPRIGHT",
    "LEFT",
    "CENTER",
    "RIGHT",
    "BOTTOMLEFT",
    "BOTTOM",
    "BOTTOMRIGHT"
}

local category, layout
local characterFrameSelector

local settings = {
    name = L["addon.name"],
    database = "ItemInfoOverlayDB",
    settings = {
        {
            -- 预览
            controlType = CONTROL_TYPE.CUSTOM_FRAME,
            name = PREVIEW,
            template = "IIOItemInfoOverlaySettingPriviewTemplate"
        },
        {
            -- 物品等级
            controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["itemInfoOverlay.itemLevel.title"],
            tooltip = L["itemInfoOverlay.itemLevel.tooltip"],
            key = "itemInfoOverlay.itemLevel.enable",
            default = true,
            onValueChanged = function(value)
                ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
            end,
            dropdown = {
                -- 物品等级锚点
                settingType = SETTING_TYPE.ADDON_VARIABLE,
                key = "itemInfoOverlay.itemLevel.point",
                default = 2,
                options = POINTS,
                onValueChanged = function(value)
                    ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                end
            },
            subSettings = {
                {
                    -- 物品等级字体
                    controlType = CONTROL_TYPE.LIB_SHARED_MEDIA_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.itemLevel.font"],
                    key = "itemInfoOverlay.itemLevel.font",
                    mediaType = LibSharedMedia.MediaType.FONT,
                    default = LibSharedMedia:Fetch(LibSharedMedia.MediaType.FONT, LibSharedMedia:GetDefault(LibSharedMedia.MediaType.FONT)),
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                    end
                },
                {
                    -- 物品等级文字大小
                    controlType = CONTROL_TYPE.SLIDER,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.itemLevel.fontSize"],
                    key = "itemInfoOverlay.itemLevel.fontSize",
                    minValue = 5,
                    maxValue = 20,
                    step = 1,
                    default = 14,
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                    end
                }
            }
        },
        {
            -- 物品分类
            controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["itemInfoOverlay.itemType.title"],
            tooltip = L["itemInfoOverlay.itemType.tooltip"],
            key = "itemInfoOverlay.itemType.enable",
            default = true,
            onValueChanged = function(value)
                ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
            end,
            dropdown = {
                -- 物品分类锚点
                settingType = SETTING_TYPE.ADDON_VARIABLE,
                key = "itemInfoOverlay.itemType.point",
                default = 8,
                options = POINTS,
                onValueChanged = function(value)
                    ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                end
            },
            subSettings = {
                {
                    -- 物品分类字体
                    controlType = CONTROL_TYPE.LIB_SHARED_MEDIA_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.itemType.font"],
                    key = "itemInfoOverlay.itemType.font",
                    mediaType = LibSharedMedia.MediaType.FONT,
                    default = LibSharedMedia:Fetch(LibSharedMedia.MediaType.FONT, LibSharedMedia:GetDefault(LibSharedMedia.MediaType.FONT)),
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                    end
                },
                {
                    -- 物品分类文字大小
                    controlType = CONTROL_TYPE.SLIDER,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.itemType.fontSize"],
                    key = "itemInfoOverlay.itemType.fontSize",
                    minValue = 5,
                    maxValue = 20,
                    step = 1,
                    default = 12,
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                    end
                }
            }
        },
        {
            -- 绑定类型
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["itemInfoOverlay.bondingType.title"],
            tooltip = L["itemInfoOverlay.bondingType.tooltip"],
            key = "itemInfoOverlay.bondingType.enable",
            default = true,
            onValueChanged = function(value)
                ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
            end,
            subSettings = {
                {
                    -- 绑定类型独立锚点
                    controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.customAnchor"],
                    key = "itemInfoOverlay.bondingType.customAnchor",
                    default = false,
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                    end,
                    dropdown = {
                        -- 绑定类型锚点
                        settingType = SETTING_TYPE.ADDON_VARIABLE,
                        key = "itemInfoOverlay.bondingType.point",
                        default = 2,
                        options = POINTS,
                        onValueChanged = function(value)
                            ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                        end
                    },
                },
                {
                    -- 绑定类型字体
                    controlType = CONTROL_TYPE.LIB_SHARED_MEDIA_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.bondingType.font"],
                    key = "itemInfoOverlay.bondingType.font",
                    mediaType = LibSharedMedia.MediaType.FONT,
                    default = LibSharedMedia:Fetch(LibSharedMedia.MediaType.FONT, LibSharedMedia:GetDefault(LibSharedMedia.MediaType.FONT)),
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                    end
                },
                {
                    -- 绑定类型字体大小
                    controlType = CONTROL_TYPE.SLIDER,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.bondingType.fontSize"],
                    key = "itemInfoOverlay.bondingType.fontSize",
                    minValue = 5,
                    maxValue = 20,
                    step = 1,
                    default = 12,
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                    end
                }
            }
        },
        {
            controlType = CONTROL_TYPE.SECTION_HEADER,
            name = L["other.title"]
        },
        {
            -- 鼠标提示装等
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["tooltip.itemLevel.title"],
            tooltip = L["tooltip.itemLevel.tooltip"],
            key = "tooltip.itemLevel.enable",
            default = true,
        },
        {
            -- 聊天链接增强
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["chatLink.hyperlinkEnhance.title"],
            tooltip = L["chatLink.hyperlinkEnhance.tooltip"]..L["addon.sanluliUtils.tooltip"],
            key = "chatLink.hyperlinkEnhance.enable",
            default = true,
            isModifiable = function ()
                return not SanluliUtils
            end,
            subSettings = {
                {
                    -- 显示图标
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["chatLink.hyperlinkEnhance.displayIcon.title"],
                    tooltip = L["chatLink.hyperlinkEnhance.displayIcon.tooltip"],
                    key = "chatLink.hyperlinkEnhance.displayIcon",
                    default = true,
                    isVisible = function ()
                        return not C_AddOns.IsAddOnLoaded("SanluliUtils")
                    end
                },
                {
                    -- 显示物品等级
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["chatLink.hyperlinkEnhance.displayItemLevel.title"],
                    tooltip = L["chatLink.hyperlinkEnhance.displayItemLevel.tooltip"],
                    key = "chatLink.hyperlinkEnhance.displayItemLevel",
                    default = true,
                    isVisible = function ()
                        return not C_AddOns.IsAddOnLoaded("SanluliUtils")
                    end
                },
                {
                    -- 显示物品分类
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["chatLink.hyperlinkEnhance.displayItemType.title"],
                    tooltip = L["chatLink.hyperlinkEnhance.displayItemType.tooltip"],
                    key = "chatLink.hyperlinkEnhance.displayItemType",
                    default = true,
                    isVisible = function ()
                        return not C_AddOns.IsAddOnLoaded("SanluliUtils")
                    end
                },
                {
                    -- 显示插槽
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["chatLink.hyperlinkEnhance.displaySockets.title"],
                    tooltip = L["chatLink.hyperlinkEnhance.displaySockets.tooltip"],
                    key = "chatLink.hyperlinkEnhance.displaySockets",
                    default = false,
                    isVisible = function ()
                        return not C_AddOns.IsAddOnLoaded("SanluliUtils")
                    end
                },
                {
                    -- 应用于公会新闻
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["chatLink.hyperlinkEnhance.applyToGuildNews.title"],
                    tooltip = L["chatLink.hyperlinkEnhance.applyToGuildNews.tooltip"],
                    key = "chatLink.hyperlinkEnhance.applyToGuildNews",
                    default = true,
                    isVisible = function ()
                        return not C_AddOns.IsAddOnLoaded("SanluliUtils")
                    end
                },
            }
        },
    },
    subCategorys = {
        {
            name = L["characterFrame.title"],
            settings = {
                {
                    -- 预览
                    controlType = CONTROL_TYPE.CUSTOM_FRAME,
                    name = PREVIEW,
                    template = "IIOCharacterFrameItemInfoOverlaySettingPriviewTemplate"
                },
                {
                    controlType = CONTROL_TYPE.DROPDOWN,
                    settingType = SETTING_TYPE.PROXY,
                    name = "|cffffffff"..L["characterFrame.selector"].."|r",
                    key = "characterFrame.selector",
                    options = {
                        { value = "itemLevel", name = L["characterFrame.selector.itemLevel"] },
                        { value = "enchantAndSockets", name = L["characterFrame.selector.enchantAndSockets"] },
                        { value = "other", name = L["characterFrame.selector.other"] },
                    },
                    getValue = function ()
                        return characterFrameSelector or "itemLevel"
                    end,
                    setValue = function (value)
                        characterFrameSelector = value
                    end,
                    onValueChanged = function (value)
                        -- 刷新面板
                        SettingsPanel:DisplayLayout(SettingsPanel:GetCurrentLayout())
                    end,
                },
                {
                    -- 物品等级
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["characterFrame.itemLevel.title"],
                    tooltip = L["characterFrame.itemLevel.tooltip"],
                    key = "characterFrame.itemLevel.enable",
                    default = true,
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                    end,
                    isVisible = function ()
                        return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "itemLevel"
                    end,
                    subSettings = {
                        {
                            -- 物品等级锚点至物品图标
                            controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["characterFrame.itemLevel.anchorToIcon"],
                            key = "characterFrame.itemLevel.anchorToIcon",
                            default = false,
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                            dropdown = {
                                -- 物品等级锚点
                                settingType = SETTING_TYPE.ADDON_VARIABLE,
                                key = "characterFrame.itemLevel.point",
                                default = 2,
                                options = POINTS,
                                onValueChanged = function(value)
                                    ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                                end
                            },
                            isVisible = function ()
                                return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "itemLevel"
                            end,
                        },
                        {
                            -- 物品等级字体
                            controlType = CONTROL_TYPE.LIB_SHARED_MEDIA_DROPDOWN,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["characterFrame.itemLevel.font"],
                            key = "characterFrame.itemLevel.font",
                            mediaType = LibSharedMedia.MediaType.FONT,
                            default = LibSharedMedia:Fetch(LibSharedMedia.MediaType.FONT, LibSharedMedia:GetDefault(LibSharedMedia.MediaType.FONT)),
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                            isVisible = function ()
                                return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "itemLevel"
                            end,
                        },
                        {
                            -- 物品等级文字大小
                            controlType = CONTROL_TYPE.SLIDER,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["characterFrame.itemLevel.fontSize"],
                            key = "characterFrame.itemLevel.fontSize",
                            minValue = 5,
                            maxValue = 20,
                            step = 1,
                            default = 14,
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                            isVisible = function ()
                                return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "itemLevel"
                            end,
                        }
                    }
                },
                {
                    -- PvP物品等级
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["characterFrame.pvpItemLevel.title"],
                    tooltip = L["characterFrame.pvpItemLevel.tooltip"],
                    key = "characterFrame.pvpItemLevel.enable",
                    default = true,
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                    end,
                    isVisible = function ()
                        return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "itemLevel"
                    end,
                    subSettings = {
                        {
                            -- PvP物品等级锚点至物品图标
                            controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["itemInfoOverlay.customAnchor"],
                            key = "characterFrame.pvpItemLevel.customAnchor",
                            default = false,
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                            dropdown = {
                                -- PvP物品等级锚点
                                settingType = SETTING_TYPE.ADDON_VARIABLE,
                                key = "characterFrame.pvpItemLevel.point",
                                default = 2,
                                options = POINTS,
                                onValueChanged = function(value)
                                    ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                                end
                            },
                            isVisible = function ()
                                return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "itemLevel"
                            end,
                        },
                        {
                            -- PvP物品等级字体
                            controlType = CONTROL_TYPE.LIB_SHARED_MEDIA_DROPDOWN,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["characterFrame.pvpItemLevel.font"],
                            key = "characterFrame.pvpItemLevel.font",
                            mediaType = LibSharedMedia.MediaType.FONT,
                            default = LibSharedMedia:Fetch(LibSharedMedia.MediaType.FONT, LibSharedMedia:GetDefault(LibSharedMedia.MediaType.FONT)),
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                            isVisible = function ()
                                return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "itemLevel"
                            end,
                        },
                        {
                            -- PvP物品等级文字大小
                            controlType = CONTROL_TYPE.SLIDER,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["characterFrame.pvpItemLevel.fontSize"],
                            key = "characterFrame.pvpItemLevel.fontSize",
                            minValue = 5,
                            maxValue = 20,
                            step = 1,
                            default = 12,
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                            isVisible = function ()
                                return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "itemLevel"
                            end,
                        }
                    }
                },
                {
                    -- 附魔
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["characterFrame.enchant.title"],
                    tooltip = L["characterFrame.enchant.tooltip"],
                    key = "characterFrame.enchant.enable",
                    default = true,
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                    end,
                    isVisible = function ()
                        return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "enchantAndSockets"
                    end,
                    subSettings = {
                        {
                            -- 显示缺少的附魔
                            controlType = CONTROL_TYPE.CHECKBOX,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["characterFrame.enchant.displayMissing"],
                            key = "characterFrame.enchant.displayMissing",
                            default = true,
                            isVisible = function ()
                                return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "enchantAndSockets"
                            end,
                        },
                        {
                            -- 附魔字体
                            controlType = CONTROL_TYPE.LIB_SHARED_MEDIA_DROPDOWN,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["characterFrame.enchant.font"],
                            key = "characterFrame.enchant.font",
                            mediaType = LibSharedMedia.MediaType.FONT,
                            default = LibSharedMedia:Fetch(LibSharedMedia.MediaType.FONT, LibSharedMedia:GetDefault(LibSharedMedia.MediaType.FONT)),
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                            isVisible = function ()
                                return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "enchantAndSockets"
                            end,
                        },
                        {
                            -- 附魔文字大小
                            controlType = CONTROL_TYPE.SLIDER,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["characterFrame.enchant.fontSize"],
                            key = "characterFrame.enchant.fontSize",
                            minValue = 5,
                            maxValue = 20,
                            step = 1,
                            default = 12,
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                            isVisible = function ()
                                return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "enchantAndSockets"
                            end,
                        }
                    }
                },
                {
                    -- 插槽
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["characterFrame.socket.title"],
                    tooltip = L["characterFrame.socket.tooltip"],
                    key = "characterFrame.socket.enable",
                    default = true,
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                    end,
                    isVisible = function ()
                        return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "enchantAndSockets"
                    end,
                    subSettings = {
                        {
                            -- 显示可打孔
                            controlType = CONTROL_TYPE.CHECKBOX,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["characterFrame.socket.displayMaxSockets"],
                            key = "characterFrame.socket.displayMaxSockets",
                            default = false,
                            isVisible = function ()
                                return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "enchantAndSockets"
                            end,
                        },
                        {
                            -- 插槽图标尺寸
                            controlType = CONTROL_TYPE.SLIDER,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["characterFrame.socket.iconSize"],
                            key = "characterFrame.socket.iconSize",
                            minValue = 5,
                            maxValue = 20,
                            step = 1,
                            default = 14,
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                            isVisible = function ()
                                return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "enchantAndSockets"
                            end,
                        }
                    }
                },
                {
                    -- 耐久度
                    controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["characterFrame.durability.title"],
                    tooltip = L["characterFrame.durability.tooltip"],
                    key = "characterFrame.durability.enable",
                    default = true,
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                    end,
                    isVisible = function ()
                        return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "other"
                    end,
                    dropdown = {
                        -- 耐久度锚点
                        settingType = SETTING_TYPE.ADDON_VARIABLE,
                        key = "characterFrame.durability.point",
                        default = 8,
                        options = POINTS,
                        onValueChanged = function(value)
                            ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                        end
                    },
                    subSettings = {
                        {
                            -- 耐久度字体
                            controlType = CONTROL_TYPE.LIB_SHARED_MEDIA_DROPDOWN,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["characterFrame.durability.font"],
                            key = "characterFrame.durability.font",
                            mediaType = LibSharedMedia.MediaType.FONT,
                            default = LibSharedMedia:Fetch(LibSharedMedia.MediaType.FONT, LibSharedMedia:GetDefault(LibSharedMedia.MediaType.FONT)),
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                            isVisible = function ()
                                return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "other"
                            end,
                        },
                        {
                            -- 耐久度文字大小
                            controlType = CONTROL_TYPE.SLIDER,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["characterFrame.durability.fontSize"],
                            key = "characterFrame.durability.fontSize",
                            minValue = 5,
                            maxValue = 20,
                            step = 1,
                            default = 12,
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                            isVisible = function ()
                                return Settings.GetSetting("ItemInfoOverlay.characterFrame.selector"):GetValue() == "other"
                            end,
                        }
                    }
                },
            }
        },
        {
            name = L["equipmentSummary.title"],
            settings = {
                {
                    -- 显示玩家装备总览
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["equipmentSummary.player.title"],
                    tooltip = L["equipmentSummary.player.tooltip"],
                    key = "equipmentSummary.player.enable",
                    default = true
                },
                {
                    -- 观察时显示装备总览
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["equipmentSummary.inspect.title"],
                    tooltip = L["equipmentSummary.inspect.tooltip"],
                    key = "equipmentSummary.inspect.enable",
                    default = true
                },
                {
                    -- 显示部位名称
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["equipmentSummary.slotName.title"],
                    tooltip = L["equipmentSummary.slotName.tooltip"],
                    key = "equipmentSummary.slotName.enable",
                    default = false,
                    onValueChanged = function(value)
                        IIOEquipmentSummaryPlayerFrame:UpdateAppearance()
                        IIOEquipmentSummaryInspectFrame:UpdateAppearance()
                    end
                },
                {
                    -- 显示属性图标
                    controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["equipmentSummary.statIcon.title"],
                    tooltip = L["equipmentSummary.statIcon.tooltip"],
                    key = "equipmentSummary.statIcon.enable",
                    default = true,
                    onValueChanged = function(value)
                        IIOEquipmentSummaryPlayerFrame:UpdateAppearance()
                        IIOEquipmentSummaryInspectFrame:UpdateAppearance()
                    end,
                    dropdown = {
                        -- 属性图标风格
                        settingType = SETTING_TYPE.ADDON_VARIABLE,
                        key = "equipmentSummary.statIcon.style",
                        default = "Armory",
                        options = {
                            {
                                "Armory",
                                L["equipmentSummary.statIcon.style.armory.title"]..
                                " |TInterface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_Armory\\crit.png:12|t"..
                                "|TInterface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_Armory\\haste.png:12|t"..
                                "|TInterface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_Armory\\mastery.png:12|t"..
                                "|TInterface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_Armory\\versatility.png:12|t",
                                ""
                            },
                            {
                                "GearStatSummary",
                                L["equipmentSummary.statIcon.style.gearStatSummary.title"]..
                                " |TInterface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_GearStatSummary\\crit.tga:12|t"..
                                "|TInterface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_GearStatSummary\\haste.tga:12|t"..
                                "|TInterface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_GearStatSummary\\mastery.tga:12|t"..
                                "|TInterface\\AddOns\\ItemInfoOverlay\\Media\\icon\\stats_GearStatSummary\\vers.tga:12|t",
                                ""
                            },
                        },
                        onValueChanged = function(value)
                            IIOEquipmentSummaryPlayerFrame:UpdateAppearance()
                            IIOEquipmentSummaryInspectFrame:UpdateAppearance()
                        end
                    },
                },
                {
                    -- 标题文本尺寸
                    controlType = CONTROL_TYPE.SLIDER,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["equipmentSummary.title.fontSize"],
                    key = "equipmentSummary.title.fontSize",
                    minValue = 5,
                    maxValue = 20,
                    step = 1,
                    default = 16,
                    onValueChanged = function(value)
                        IIOEquipmentSummaryPlayerFrame:UpdateAppearance()
                        IIOEquipmentSummaryInspectFrame:UpdateAppearance()
                    end,
                },
                {
                    -- 内容文本尺寸
                    controlType = CONTROL_TYPE.SLIDER,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["equipmentSummary.fontSize"],
                    key = "equipmentSummary.fontSize",
                    minValue = 5,
                    maxValue = 20,
                    step = 1,
                    default = 13,
                    onValueChanged = function(value)
                        IIOEquipmentSummaryPlayerFrame:UpdateAppearance()
                        IIOEquipmentSummaryInspectFrame:UpdateAppearance()
                    end,
                }
            }
        },
        {
            name = "颜色",
            settings = {
                {
                    -- 物品等级颜色
                    controlType = CONTROL_TYPE.DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.itemLevel.color.title"],
                    tooltip = L["itemInfoOverlay.itemLevel.color.tooltip"],
                    key = "itemInfoOverlay.itemLevel.color",
                    default = 2,
                    options = {
                        L["itemInfoOverlay.itemLevel.color.customColor"],
                        L["itemInfoOverlay.itemLevel.color.itemQuality"]
                    },
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                        ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                        SettingsPanel:DisplayLayout(SettingsPanel:GetCurrentLayout())
                    end,
                    subSettings = {
                        {
                            -- 自定义颜色
                            controlType = CONTROL_TYPE.COLOR,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["itemInfoOverlay.itemLevel.color.custom.title"],
                            key = "itemInfoOverlay.itemLevel.color.custom",
                            default = "#ffffff",
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                            end
                        },
                    },
                },
                {
                    -- 使用物品升级等级颜色
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = "使用物品升级等级颜色",
                    tooltip = "对于可升级的物品，物品等级将显示为基于其升级等级(神话/英雄/勇士等...)的颜色",
                    key = "itemInfoOverlay.itemLevel.color.itemUpgrade",
                    default = true,
                    onValueChanged = function(value)
                        ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                        ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                    end,
                    newFeature = true,
                    subSettings = {
                        {
                            -- 神话
                            controlType = CONTROL_TYPE.COLOR,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = "神话",
                            key = "itemInfoOverlay.itemLevel.color.itemUpgrade.myth",
                            default = "#ff7d00",
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                        },
                        {
                            -- 英雄
                            controlType = CONTROL_TYPE.COLOR,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = "英雄",
                            key = "itemInfoOverlay.itemLevel.color.itemUpgrade.hero",
                            default = "#a335ee",
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                        },
                        {
                            -- 勇士
                            controlType = CONTROL_TYPE.COLOR,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = "勇士",
                            key = "itemInfoOverlay.itemLevel.color.itemUpgrade.champion",
                            default = "#0070dd",
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                        },
                        {
                            -- 老兵
                            controlType = CONTROL_TYPE.COLOR,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = "老兵",
                            key = "itemInfoOverlay.itemLevel.color.itemUpgrade.veteran",
                            default = "#1eff00",
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                        },
                        {
                            -- 冒险者和探索者
                            controlType = CONTROL_TYPE.COLOR,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = "探索者和冒险者",
                            key = "itemInfoOverlay.itemLevel.color.itemUpgrade.explorer",
                            default = "#ffffff",
                            onValueChanged = function(value)
                                ItemInfoOverlay.Modules.itemInfoOverlay:UpdateAllAppearance()
                                ItemInfoOverlay.Modules.characterFrame:UpdateAllAppearance()
                            end,
                        },
                    },
                },
            }
        }
    }
}

local function Register()
    category, layout = LibBlzSettings:RegisterVerticalSettingsTable(ADDON_NAME, settings, nil, true)
end


function Module:OnLoad()
    Register()
end
