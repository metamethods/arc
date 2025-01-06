type ToolbarButtonProps = {
	id: string,
	tooltip: string,
	icon: string,
	text: string?,
	clicked: () -> ()?,
}

local function ToolbarButton(toolbar: PluginToolbar): (props: ToolbarButtonProps) -> PluginToolbarButton
	return function(props)
		local button = toolbar:CreateButton(props.id, props.tooltip, props.icon, props.text)

		if props.clicked then
			button.Click:Connect(function()
				button:SetActive(true)
				button:SetActive(false)
				props.clicked()
			end)
		end

		return button
	end
end

return ToolbarButton
