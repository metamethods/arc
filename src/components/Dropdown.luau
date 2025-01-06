local Button = require(script.Parent.Button)
local Fusion = require(script.Parent.Parent.packages.Fusion)

type DropdownProps<T> = {
	title: string,
	items: { [T]: string },
	selected: Fusion.Value<T>,
}

local function Dropdown<T>(scope: Fusion.Scope<typeof(Fusion) & { plugin: Plugin }>, props: DropdownProps<T>)
	local scope = scope:deriveScope({
		Button = Button,
	})
	local pluginMenu = scope.plugin:CreatePluginMenu(tostring(math.random()), props.title)

	for itemId, itemName in props.items do
		local action = pluginMenu:AddNewAction(itemId, itemName)
		action.Name = itemId -- workaround to get the real item id lol
	end

	return scope:Button {
		text = scope:Computed(function(use)
			return props.items[use(props.selected)] or "Unknown"
		end),
		clicked = function()
			local selectedAction = pluginMenu:ShowAsync()

			if selectedAction then
				props.selected:set(selectedAction.Name)
			end
		end,
		outline = true,
	}
end

return Dropdown
