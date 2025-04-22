--[[
    This is an extension of LibBlzSettings that provides some common controls that Blizzard does not use in the settings interface (and naturally does not implement).
]]

local LibBlzSettings = LibStub("LibBlzSettings-1.0")

local CONTROL_TYPE = LibBlzSettings.CONTROL_TYPE

----------------------------------------
--- Editbox
--- Author: KeiraMetz88
----------------------------------------

LibBlzSettingsEditboxMixin = CreateFromMixins(CallbackRegistryMixin, DefaultTooltipMixin)

LibBlzSettingsEditboxMixin:GenerateCallbackEvents(
    {
        "OnValueChanged",
    }
)

function LibBlzSettingsEditboxMixin:OnLoad()
    CallbackRegistryMixin.OnLoad(self)
    DefaultTooltipMixin.OnLoad(self)
    self.tooltipXOffset = 0
end

function LibBlzSettingsEditboxMixin:Init(value, initTooltip)
    self:SetValue(value)
    self:SetTooltipFunc(initTooltip)

    self:SetScript("OnTextChanged", function(editbox, userInput)
        if userInput then   -- 限制: 用户输入才触发
            self:TriggerEvent(LibBlzSettingsEditboxMixin.Event.OnValueChanged, editbox:GetText())
        end
    end)
end

function LibBlzSettingsEditboxMixin:Release()
    self:SetScript("OnTextChanged", nil)
end

function LibBlzSettingsEditboxMixin:SetValue(value)
    self:SetText(value)
end

----------------------------------------
--- Editbox Control
--- Author: KeiraMetz88
----------------------------------------
CONTROL_TYPE.EDITBOX = 4

LibBlzSettingsEditboxControlMixin = CreateFromMixins(SettingsControlMixin)

function LibBlzSettingsEditboxControlMixin:OnLoad()
    SettingsControlMixin.OnLoad(self)

    self.Editbox = CreateFrame("EditBox", nil, self, "LibBlzSettingsEditboxTemplate")
    self.Editbox:SetPoint("LEFT", self, "CENTER", -72, 0)
end

function LibBlzSettingsEditboxControlMixin:Init(initializer)
    SettingsControlMixin.Init(self, initializer)

    local setting = self:GetSetting()
    local initTooltip = GenerateClosure(Settings.InitTooltip, initializer:GetName(), initializer:GetTooltip())

    self.Editbox:Init(setting:GetValue(), initTooltip)

    self.cbrHandles:RegisterCallback(self.Editbox, LibBlzSettingsEditboxMixin.Event.OnValueChanged, self.OnEditboxValueChanged, self)

    self:EvaluateState()
end

function LibBlzSettingsEditboxControlMixin:OnSettingValueChanged(setting, value)
    SettingsControlMixin.OnSettingValueChanged(self, setting, value)

    self.Editbox:SetText(value)
end

function LibBlzSettingsEditboxControlMixin:OnEditboxValueChanged(value)
    self:GetSetting():SetValue(value)
end

function LibBlzSettingsEditboxControlMixin:EvaluateState()
    SettingsListElementMixin.EvaluateState(self)
    local enabled = SettingsControlMixin.IsEnabled(self)
    self.Editbox:SetEnabled(enabled)
    self:DisplayEnabled(enabled)
end

function LibBlzSettingsEditboxControlMixin:Release()
    self.Editbox:Release()
    SettingsControlMixin.Release(self)
end

LibBlzSettings.RegisterControl(CONTROL_TYPE.EDITBOX, function (addOnName, category, layout, dataTbl, database)
    local setting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.String)

    local data = {
        name = dataTbl.name,
        tooltip = dataTbl.tooltip,
        setting = setting,
        options = {},
    }

    local initializer = Settings.CreateSettingInitializer("LibBlzSettingsEditboxControlTemplate", data)

    if dataTbl.canSearch or dataTbl.canSearch == nil then
        initializer:AddSearchTags(dataTbl.name)
    end

    layout:AddInitializer(initializer)

    return setting, initializer
end, {}, {})

----------------------------------------
--- Checkbox and Editbox Control
--- Author: KeiraMetz88, Sanluli36li
----------------------------------------
CONTROL_TYPE.CHECKBOX_AND_EDITBOX = 24

LibBlzSettingsCheckboxEditboxControlMixin = CreateFromMixins(SettingsListElementMixin)

function LibBlzSettingsCheckboxEditboxControlMixin:OnLoad()
    SettingsListElementMixin.OnLoad(self)

    self.Checkbox = CreateFrame("CheckButton", nil, self, "SettingsCheckboxTemplate")
    self.Checkbox:SetPoint("LEFT", self, "CENTER", -80, 0)

    self.Editbox = CreateFrame("EditBox", nil, self, "LibBlzSettingsEditboxTemplate")
    self.Editbox:SetPoint("LEFT", self.Checkbox, "RIGHT", 10, 0)
    -- self.Editbox:SetWidth(200)

    Mixin(self.Editbox, DefaultTooltipMixin)

    self.Tooltip:SetScript("OnMouseUp", function()
        if self.Checkbox:IsEnabled() then
            self.Checkbox:Click()
        end
    end)
end

function LibBlzSettingsCheckboxEditboxControlMixin:Init(initializer)
    SettingsListElementMixin.Init(self, initializer)

    local cbSetting = initializer.data.cbSetting
    local cbLabel = initializer.data.cbLabel
    local cbTooltip = initializer.data.cbTooltip
    local editboxSetting = initializer.data.editboxSetting
    local editboxLabel = initializer.data.editboxLabel
    local editboxTooltip = initializer.data.editboxTooltip

    local initCheckboxTooltip = GenerateClosure(Settings.InitTooltip, cbLabel, cbTooltip)
    self:SetTooltipFunc(initCheckboxTooltip)

    self.Checkbox:Init(cbSetting:GetValue(), initCheckboxTooltip)
    self.cbrHandles:RegisterCallback(self.Checkbox, SettingsCheckboxMixin.Event.OnValueChanged, self.OnCheckboxValueChanged, self)

    local initEditboxTooltip = GenerateClosure(Settings.InitTooltip, editboxLabel, editboxTooltip)
    self.Editbox:Init(editboxSetting:GetValue(), initEditboxTooltip)
    self.cbrHandles:RegisterCallback(self.Editbox, LibBlzSettingsEditboxMixin.Event.OnValueChanged, self.OnEditboxValueChanged, self)
    self.Editbox:SetEnabled(cbSetting:GetValue())

    -- Defaults...
    local function OnCheckboxSettingValueChanged(o, setting, value)
		self.Checkbox:SetValue(value)
		self:EvaluateState()
	end
	self.cbrHandles:SetOnValueChangedCallback(cbSetting:GetVariable(), OnCheckboxSettingValueChanged)

	local function OnEditboxSettingValueChanged(o, setting, value)
		self.Editbox:SetValue(value)
	end
	self.cbrHandles:SetOnValueChangedCallback(editboxSetting:GetVariable(), OnEditboxSettingValueChanged)

    self:EvaluateState()
end

function LibBlzSettingsCheckboxEditboxControlMixin:OnCheckboxValueChanged(value)
    local initializer = self:GetElementData()
    local cbSetting = initializer.data.cbSetting
    cbSetting:SetValue(value)
    if value then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end

    self.Editbox:SetEnabled(value)
end

function LibBlzSettingsCheckboxEditboxControlMixin:OnEditboxValueChanged(value)
    local initializer = self:GetElementData()
    local editboxSetting = initializer.data.editboxSetting
    editboxSetting:SetValue(value)
end

function LibBlzSettingsCheckboxEditboxControlMixin:EvaluateState()
	SettingsListElementMixin.EvaluateState(self)
	local enabled = SettingsControlMixin.IsEnabled(self)
	self.Checkbox:SetEnabled(enabled)
	self.Editbox:SetEnabled(enabled and self.Checkbox:GetChecked())
	self:DisplayEnabled(enabled)
end

function LibBlzSettingsCheckboxEditboxControlMixin:Release()
	self.Checkbox:Release()
	self.Editbox:Release()
	SettingsListElementMixin.Release(self)
end

LibBlzSettings.RegisterControl(
    CONTROL_TYPE.CHECKBOX_AND_EDITBOX,
    function (addOnName, category, layout, dataTbl, database)
        local checkboxSetting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Boolean)
        local editboxSetting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl.editbox, database, Settings.VarType.String)

        local data = {
            name = dataTbl.name,
            tooltip = dataTbl.tooltip,
            setting = checkboxSetting,
            cbSetting = checkboxSetting,
            cbLabel = dataTbl.name,
            cbTooltip = dataTbl.tooltip,
            editboxSetting = editboxSetting,
            editboxLabel = dataTbl.editbox.name or dataTbl.name,
            editboxTooltip = dataTbl.editbox.tooltip or dataTbl.tooltip
        }

        local initializer = Settings.CreateSettingInitializer("LibBlzSettingsCheckboxEditboxControlTemplate", data)

        if dataTbl.canSearch or dataTbl.canSearch == nil then
            initializer:AddSearchTags(dataTbl.name)
        end

        layout:AddInitializer(initializer)

        return setting, initializer
    end,
    { editbox = CONTROL_TYPE.EDITBOX },
    { inherits = CONTROL_TYPE.CHECKBOX }
)

----------------------------------------
--- Color Control
--- Author: Sanluli36li
----------------------------------------
CONTROL_TYPE.COLOR = 5

LibBlzSettingsColorControlMixin = CreateFromMixins(SettingsControlMixin)

local function GetHexColorFromRGBA(r, g, b, a)
    if a and a >= 1 then
        return string.format("#%02x%02x%02x", r * 255, g * 255, b * 255)
    else
        return string.format("#%02x%02x%02x%02x", r * 255, g * 255, b * 255, a * 255)
    end
end

local function GetRGBAFromHexColor(hex)
    if strsub(hex, 1, 1) ~= "#" then
        return 1, 1, 1, 1
    end

    local len = string.len(hex)
    local r, g, b, a = 1, 1, 1, 1
    if len == 7 then
        r = (tonumber(strsub(hex, 2, 3), 16) or 255) / 255
        g = (tonumber(strsub(hex, 4, 5), 16) or 255) / 255
        b = (tonumber(strsub(hex, 6, 7), 16) or 255) / 255
    elseif len == 9 then
        r = (tonumber(strsub(hex, 2, 3), 16) or 255) / 255
        g = (tonumber(strsub(hex, 4, 5), 16) or 255) / 255
        b = (tonumber(strsub(hex, 6, 7), 16) or 255) / 255
        a = (tonumber(strsub(hex, 8, 9), 16) or 255) / 255
    end

    return r, g, b, a
end

function LibBlzSettingsColorControlMixin:OnLoad()
	SettingsControlMixin.OnLoad(self)

	self.ColorSwatch = CreateFrame("Button", nil, self, "ColorSwatchTemplate")
	self.ColorSwatch:SetPoint("TOPLEFT", self.Text, "TOPLEFT", 192, 0)

    self.ColorSwatch:SetScript("OnClick", function(button, buttonName, down)
        self:OpenColorPicker()
	end)
end

function LibBlzSettingsColorControlMixin:OpenColorPicker()
    local info = UIDropDownMenu_CreateInfo()

	info.r, info.g, info.b, info.opacity = GetRGBAFromHexColor(self:GetSetting():GetValue())
    info.hasOpacity = self.hasOpacity
	info.extraInfo = nil
	info.swatchFunc = function ()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		local a = ColorPickerFrame:GetColorAlpha()

		self.ColorSwatch.Color:SetVertexColor(r,g,b, a)

		self:GetSetting():SetValue(GetHexColorFromRGBA(r, g, b, a))
	end

	info.cancelFunc = function ()
		local r, g, b, a = ColorPickerFrame:GetPreviousValues()

		self.ColorSwatch.Color:SetVertexColor(r,g,b, a)

		self:GetSetting():SetValue(GetHexColorFromRGBA(r, g, b, a))
	end

	ColorPickerFrame:SetupColorPickerAndShow(info)
end

function LibBlzSettingsColorControlMixin:Init(initializer)
    SettingsControlMixin.Init(self, initializer)

    local setting = self:GetSetting()

    local initTooltip = GenerateClosure(Settings.InitTooltip, initializer:GetName(), initializer:GetTooltip())

    local r, g, b, a = GetRGBAFromHexColor(setting:GetValue())

    self.hasOpacity = initializer.data.hasOpacity
    self.ColorSwatch.Color:SetVertexColor(r, g, b, a)

	self:EvaluateState()
end

function LibBlzSettingsColorControlMixin:OnSettingValueChanged(setting, value)
	SettingsControlMixin.OnSettingValueChanged(self, setting, value)

    self.ColorSwatch.Color:SetVertexColor(GetRGBAFromHexColor(setting:GetValue()))
end

function LibBlzSettingsColorControlMixin:EvaluateState()
	SettingsListElementMixin.EvaluateState(self)
    local enabled = SettingsControlMixin.IsEnabled(self)
	self.ColorSwatch:SetEnabled(enabled)
	self:DisplayEnabled(enabled)
end

function LibBlzSettingsColorControlMixin:Release()
	SettingsControlMixin.Release(self)
end

LibBlzSettings.RegisterControl(
    CONTROL_TYPE.COLOR,
    function (addOnName, category, layout, dataTbl, database)
        local setting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.String)

        local data = {
            name = dataTbl.name,
            tooltip = dataTbl.tooltip,
            setting = setting,
            hasOpacity = dataTbl.hasOpacity,
            options = {},
        }

        local initializer = Settings.CreateSettingInitializer("LibBlzSettingsColorControlTemplate", data)

        if dataTbl.canSearch or dataTbl.canSearch == nil then
            initializer:AddSearchTags(dataTbl.name)
        end

        layout:AddInitializer(initializer)

        return setting, initializer
    end,
    {},
    {}
)