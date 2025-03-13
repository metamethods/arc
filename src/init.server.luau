local Selection = game:GetService("Selection")

local App = require(script.App)
local Toolbar = require(script.components.plugin.Toolbar)
local ToolbarButton = require(script.components.plugin.ToolbarButton)
local Widget = require(script.components.plugin.Widget)
local constants = require(script.constants)
local Fusion = require(script.packages.Fusion)
local filter = require(script.utils.filter)
local nullifyEmpty = require(script.utils.nullifyEmpty)
local primaryPart = require(script.utils.primaryPart)

local scope = Fusion.scoped(Fusion)

local selected = scope:Value(nullifyEmpty(Selection:Get()))
local rawSelected = scope:Value(Selection:Get())
local selectionLocked = scope:Value(false)
local selectedSuite = scope:Value(plugin:GetSetting("suite") or "general")
local settings = scope:Value({}) -- TODO: Settings

local toolbar = Toolbar(plugin, constants.PLUGIN_NAME)

local appWidget = Widget(plugin) {
	id = constants.PLUGIN_ID,
	title = `{constants.PLUGIN_NAME} {constants.PLUGIN_VERSION}`,
	root = App(scope:deriveScope({
		selected = selected,
		rawSelected = rawSelected,
		selectionLocked = selectionLocked,
		selectedSuite = selectedSuite,
		settings = settings,
		plugin = plugin,
	})),
}

ToolbarButton(toolbar) {
	id = constants.PLUGIN_ID,
	icon = "rbxassetid://86954494133699",
	tooltip = `Click to toggle the {constants.PLUGIN_NAME} window`,
	clicked = function()
		appWidget.Enabled = not appWidget.Enabled
	end,
}

Selection.SelectionChanged:Connect(function()
	if Fusion.peek(selectionLocked) then
		return
	end
	rawSelected:set(Selection:Get())
	selected:set(nullifyEmpty(filter(Selection:Get(), function(instance)
		return (instance:IsA("BasePart") or instance:IsA("Model")) and primaryPart(instance)
	end)))
end)

-- TODO: rewrite saving values n stuff
scope:Observer(selectedSuite):onChange(function()
	plugin:SetSetting("suite", Fusion.peek(selectedSuite))
end)
