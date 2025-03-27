local ADDON_NAME, SanluliCharacterSheet = ...

local Module = SanluliCharacterSheet:NewModule("settings")
local L = SanluliCharacterSheet.Locale

local libSharedMedia = LibStub("LibSharedMedia-3.0")
local libSettings = LibStub("LibBlzSettings-1.0")

local CONTROL_TYPE = libSettings.CONTROL_TYPE
local SETTING_TYPE = libSettings.SETTING_TYPE

local settings = {
    name = L["addon.name"],
    settings = {
        {
            controlType = CONTROL_TYPE.SECTION_HEADER,
            name = L["itemInfoOverlay.title"]
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["itemInfoOverlay.itemLevel.title"],
            tooltip = L["itemInfoOverlay.itemLevel.tooltip"],
            key = "itemInfoOverlay.itemLevel.enable",
            default = true,
            subSettings = {
                {
                    controlType = CONTROL_TYPE.LIB_SHARED_MEDIA_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.itemLevel.font"],
                    key = "itemInfoOverlay.itemLevel.font",
                    mediaType = libSharedMedia.MediaType.FONT,
                    default = libSharedMedia:Fetch(libSharedMedia.MediaType.FONT, libSharedMedia:GetDefault(libSharedMedia.MediaType.FONT)),
                    onValueChanged = function(value)
                        SanluliCharacterSheet.itemInfoOverlay:UpdateAllAppearance()
                    end
                },
                {
                    controlType = CONTROL_TYPE.SLIDER,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.itemLevel.fontSize"],
                    key = "itemInfoOverlay.itemLevel.fontSize",
                    minValue = 5,
                    maxValue = 20,
                    step = 1,
                    default = 12,
                    onValueChanged = function(value)
                        SanluliCharacterSheet.itemInfoOverlay:UpdateAllAppearance()
                    end
                }
            }
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["itemInfoOverlay.itemType.title"],
            tooltip = L["itemInfoOverlay.itemType.tooltip"],
            key = "itemInfoOverlay.itemType.enable",
            default = true,
            subSettings = {
                {
                    controlType = CONTROL_TYPE.LIB_SHARED_MEDIA_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.itemType.font"],
                    key = "itemInfoOverlay.itemType.font",
                    mediaType = libSharedMedia.MediaType.FONT,
                    default = libSharedMedia:Fetch(libSharedMedia.MediaType.FONT, libSharedMedia:GetDefault(libSharedMedia.MediaType.FONT)),
                    onValueChanged = function(value)
                        SanluliCharacterSheet.itemInfoOverlay:UpdateAllAppearance()
                    end
                },
                {
                    controlType = CONTROL_TYPE.SLIDER,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.itemType.fontSize"],
                    key = "itemInfoOverlay.itemType.fontSize",
                    minValue = 5,
                    maxValue = 20,
                    step = 1,
                    default = 10,
                    onValueChanged = function(value)
                        SanluliCharacterSheet.itemInfoOverlay:UpdateAllAppearance()
                    end
                }
            }
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["itemInfoOverlay.bondingType.title"],
            tooltip = L["itemInfoOverlay.bondingType.tooltip"],
            key = "itemInfoOverlay.bondingType.enable",
            default = true,
            subSettings = {
                {
                    controlType = CONTROL_TYPE.LIB_SHARED_MEDIA_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.bondingType.font"],
                    key = "itemInfoOverlay.bondingType.font",
                    mediaType = libSharedMedia.MediaType.FONT,
                    default = libSharedMedia:Fetch(libSharedMedia.MediaType.FONT, libSharedMedia:GetDefault(libSharedMedia.MediaType.FONT)),
                    onValueChanged = function(value)
                        SanluliCharacterSheet.itemInfoOverlay:UpdateAllAppearance()
                    end
                },
                {
                    controlType = CONTROL_TYPE.SLIDER,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["itemInfoOverlay.bondingType.fontSize"],
                    key = "itemInfoOverlay.bondingType.fontSize",
                    minValue = 5,
                    maxValue = 20,
                    step = 1,
                    default = 10,
                    onValueChanged = function(value)
                        SanluliCharacterSheet.itemInfoOverlay:UpdateAllAppearance()
                    end
                }
            }
        },
        {
            controlType = CONTROL_TYPE.SECTION_HEADER,
            name = L["characterFrame.title"]
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["characterFrame.itemLevel.title"],
            tooltip = L["characterFrame.itemLevel.tooltip"],
            key = "characterFrame.itemLevel.enable",
            default = true,
            dropdown = {
                settingType = SETTING_TYPE.ADDON_VARIABLE,
                name = L["characterFrame.itemLevel.point"],
                key = "characterFrame.itemLevel.point",
                default = 2,
                options = {
                    { L["characterFrame.itemLevel.point.icon"] },
                    { L["characterFrame.itemLevel.point.side"] }
                },
                onValueChanged = function(value)
                    SanluliCharacterSheet.characterFrame:UpdateAllAppearance()
                end
            },
            onValueChanged = function(value)
                SanluliCharacterSheet.characterFrame:UpdateAllAppearance()
            end,
            subSettings = {
                {
                    controlType = CONTROL_TYPE.LIB_SHARED_MEDIA_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["characterFrame.itemLevel.font"],
                    key = "characterFrame.itemLevel.font",
                    mediaType = libSharedMedia.MediaType.FONT,
                    default = libSharedMedia:Fetch(libSharedMedia.MediaType.FONT, libSharedMedia:GetDefault(libSharedMedia.MediaType.FONT)),
                    onValueChanged = function(value)
                        SanluliCharacterSheet.characterFrame:UpdateAllAppearance()
                    end
                },
                {
                    controlType = CONTROL_TYPE.SLIDER,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["characterFrame.itemLevel.fontSize"],
                    key = "characterFrame.itemLevel.fontSize",
                    minValue = 5,
                    maxValue = 20,
                    step = 1,
                    default = 12,
                    onValueChanged = function(value)
                        SanluliCharacterSheet.characterFrame:UpdateAllAppearance()
                    end
                }
            }
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["characterFrame.enchant.title"],
            tooltip = L["characterFrame.enchant.tooltip"],
            key = "characterFrame.enchant.enable",
            default = true,
            onValueChanged = function(value)
            end,
            subSettings = {
                {
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["characterFrame.enchant.displayMissing"],
                    key = "characterFrame.enchant.displayMissing",
                    default = true,
                },
                {
                    controlType = CONTROL_TYPE.LIB_SHARED_MEDIA_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["characterFrame.enchant.font"],
                    key = "characterFrame.enchant.font",
                    mediaType = libSharedMedia.MediaType.FONT,
                    default = libSharedMedia:Fetch(libSharedMedia.MediaType.FONT, libSharedMedia:GetDefault(libSharedMedia.MediaType.FONT)),
                    onValueChanged = function(value)
                        SanluliCharacterSheet.characterFrame:UpdateAllAppearance()
                    end
                },
                {
                    controlType = CONTROL_TYPE.SLIDER,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["characterFrame.enchant.fontSize"],
                    key = "characterFrame.enchant.fontSize",
                    minValue = 5,
                    maxValue = 20,
                    step = 1,
                    default = 10,
                    onValueChanged = function(value)
                        SanluliCharacterSheet.characterFrame:UpdateAllAppearance()
                    end
                }
            }
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["characterFrame.socket.title"],
            tooltip = L["characterFrame.socket.tooltip"],
            key = "characterFrame.socket.enable",
            default = true,
            onValueChanged = function(value)
            end,
            subSettings = {
                {
                    controlType = CONTROL_TYPE.SLIDER,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["characterFrame.socket.iconSize"],
                    key = "characterFrame.socket.iconSize",
                    minValue = 5,
                    maxValue = 20,
                    step = 1,
                    default = 14,
                    onValueChanged = function(value)
                        SanluliCharacterSheet.characterFrame:UpdateAllAppearance()
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
    }
}

local function Register()
    local category, layout = libSettings:RegisterVerticalSettingsTable(ADDON_NAME, settings, ItemInfoOverlayDB, true)
end


function Module:BeforeStartup()
    Register()
end
