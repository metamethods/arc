type WidgetProps = {
	id: string,
	title: string,
	root: Instance,
}

local function Widget(plugin: Plugin): (props: WidgetProps) -> DockWidgetPluginGui
	return function(props)
		local info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float)
		local widget: DockWidgetPluginGui = plugin:CreateDockWidgetPluginGui(props.id, info)

		widget.Name = props.title
		widget.Title = props.title
		props.root.Parent = widget

		return widget
	end
end

return Widget
