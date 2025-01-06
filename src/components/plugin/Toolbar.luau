type ToolbarProps = {}

local function Toolbar(plugin: Plugin, name: string): PluginToolbar
	return plugin:CreateToolbar(name)
end

return Toolbar
