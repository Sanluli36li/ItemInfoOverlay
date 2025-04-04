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

local settings = {
    name = L["addon.name"],
    settings = {
        {
            -- 预览
            controlType = CONTROL_TYPE.CUSTOM_FRAME,
            name = PREVIEW,
            template = "SanluliItemInfoOverlaySettingPriviewTemplate"
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
                ItemInfoOverlay.itemInfoOverlay:UpdateAllAppearance()
            end,
            dropdown = {
                -- 物品等级锚点
                settingType = SETTING_TYPE.ADDON_VARIABLE,
                key = "itemInfoOverlay.itemLevel.point",
                default = 2,
                options = POINTS,
                onValueChanged = function(value)
                    ItemInfoOverlay.itemInfoOverlay:UpdateAllAppearance()
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
                        ItemInfoOverlay.itemInfoOverlay:UpdateAllAppearance()
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
                        ItemInfoOverlay.itemInfoOverlay:UpdateAllAppearance()
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
                ItemInfoOverlay.itemInfoOverlay:UpdateAllAppearance()
            end,
            dropdown = {
                -- 物品分类锚点
                settingType = SETTING_TYPE.ADDON_VARIABLE,
                key = "itemInfoOverlay.itemType.point",
                default = 8,
                options = POINTS,
                onValueChanged = function(value)
                    ItemInfoOverlay.itemInfoOverlay:UpdateAllAppearance()
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
                        ItemInfoOverlay.itemInfoOverlay:UpdateAllAppearance()
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
                        ItemInfoOverlay.itemInfoOverlay:UpdateAllAppearance()
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
                ItemInfoOverlay.itemInfoOverlay:UpdateAllAppearance()
            end,
            subSettings = {
                {
                    -- 绑定类型独立锚点
                    controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["characterFrame.itemLevel.anchorToIcon"],
                    key = "itemInfoOverlay.bondingType.anchorToIcon",
                    default = false,
                    onValueChanged = function(value)
                        ItemInfoOverlay.itemInfoOverlay:UpdateAllAppearance()
                    end,
                    dropdown = {
                        -- 绑定类型锚点
                        settingType = SETTING_TYPE.ADDON_VARIABLE,
                        key = "itemInfoOverlay.bondingType.point",
                        default = 2,
                        options = POINTS,
                        onValueChanged = function(value)
                            ItemInfoOverlay.itemInfoOverlay:UpdateAllAppearance()
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
                        ItemInfoOverlay.itemInfoOverlay:UpdateAllAppearance()
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
                        ItemInfoOverlay.itemInfoOverlay:UpdateAllAppearance()
                    end
                }
            }
        },
        {
            controlType = CONTROL_TYPE.SECTION_HEADER,
            name = L["other.title"]
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
                    tooltip = L["chatLink.hyperlinkEnhance.displayIcon.tooltip"]..L["addon.sanluliUtils.tooltip"],
                    key = "chatLink.hyperlinkEnhance.displayIcon",
                    default = true,
                    isModifiable = function ()
                        return not SanluliUtils
                    end
                },
                {
                    -- 显示物品等级
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["chatLink.hyperlinkEnhance.displayItemLevel.title"],
                    tooltip = L["chatLink.hyperlinkEnhance.displayItemLevel.tooltip"]..L["addon.sanluliUtils.tooltip"],
                    key = "chatLink.hyperlinkEnhance.displayItemLevel",
                    default = true,
                    isModifiable = function ()
                        return not SanluliUtils
                    end
                },
                {
                    -- 显示物品分类
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["chatLink.hyperlinkEnhance.displayItemType.title"],
                    tooltip = L["chatLink.hyperlinkEnhance.displayItemType.tooltip"]..L["addon.sanluliUtils.tooltip"],
                    key = "chatLink.hyperlinkEnhance.displayItemType",
                    default = true,
                    isModifiable = function ()
                        return not SanluliUtils
                    end
                },
                {
                    -- 显示插槽
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["chatLink.hyperlinkEnhance.displaySockets.title"],
                    tooltip = L["chatLink.hyperlinkEnhance.displaySockets.tooltip"]..L["addon.sanluliUtils.tooltip"],
                    key = "chatLink.hyperlinkEnhance.displaySockets",
                    default = false,
                    isModifiable = function ()
                        return not SanluliUtils
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
                    template = "SanluliCharacterFrameItemInfoOverlaySettingPriviewTemplate"
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
                        ItemInfoOverlay.characterFrame:UpdateAllAppearance()
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
                                ItemInfoOverlay.characterFrame:UpdateAllAppearance()
                            end,
                            dropdown = {
                                -- 物品等级锚点
                                settingType = SETTING_TYPE.ADDON_VARIABLE,
                                key = "characterFrame.itemLevel.point",
                                default = 2,
                                options = POINTS,
                                onValueChanged = function(value)
                                    ItemInfoOverlay.characterFrame:UpdateAllAppearance()
                                end
                            },
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
                                ItemInfoOverlay.characterFrame:UpdateAllAppearance()
                            end
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
                                ItemInfoOverlay.characterFrame:UpdateAllAppearance()
                            end
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
                        ItemInfoOverlay.characterFrame:UpdateAllAppearance()
                    end,
                    subSettings = {
                        {
                            -- 显示缺少的附魔
                            controlType = CONTROL_TYPE.CHECKBOX,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["characterFrame.enchant.displayMissing"],
                            key = "characterFrame.enchant.displayMissing",
                            default = true,
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
                                ItemInfoOverlay.characterFrame:UpdateAllAppearance()
                            end
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
                                ItemInfoOverlay.characterFrame:UpdateAllAppearance()
                            end
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
                        ItemInfoOverlay.characterFrame:UpdateAllAppearance()
                    end,
                    subSettings = {
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
                                ItemInfoOverlay.characterFrame:UpdateAllAppearance()
                            end
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
                        ItemInfoOverlay.characterFrame:UpdateAllAppearance()
                    end,
                    dropdown = {
                        -- 耐久度锚点
                        settingType = SETTING_TYPE.ADDON_VARIABLE,
                        key = "characterFrame.durability.point",
                        default = 8,
                        options = POINTS,
                        onValueChanged = function(value)
                            ItemInfoOverlay.characterFrame:UpdateAllAppearance()
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
                                ItemInfoOverlay.characterFrame:UpdateAllAppearance()
                            end
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
                                ItemInfoOverlay.characterFrame:UpdateAllAppearance()
                            end
                        }
                    }
                },
            }
        }
    }
}

local function Register()
    local category, layout = LibBlzSettings:RegisterVerticalSettingsTable(ADDON_NAME, settings, ItemInfoOverlayDB, true)
end


function Module:BeforeStartup()
    Register()
end
