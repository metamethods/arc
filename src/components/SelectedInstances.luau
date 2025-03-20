local Fragment = require(script.Parent.Fragment)
local InstancesList = require(script.Parent.InstancesList)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local plural = require(script.Parent.Parent.utils.plural)
local Text = require(script.Parent.Text)

local Children = Fusion.Children

type SelectedInstancesProps = {
	selected: Fusion.Value<{ Instance }>,
}

local function SelectedInstances(scope: Fusion.Scope<typeof(Fusion)>, props: SelectedInstancesProps)
	local scope = scope:deriveScope({
		Fragment = Fragment,
		InstancesList = InstancesList,
		Text = Text,
	})

	return scope:Fragment {
		padding = UDim.new(0, 4),

		[Children] = {
			scope:Text {
				text = scope:Computed(function(use)
					return `Selected instance{plural(#use(props.selected))}`
				end),
				fontWeight = Enum.FontWeight.Bold,
			},

			scope:Fragment {
				padding = UDim.new(0, 4),

				[Children] = scope:InstancesList {
					instances = props.selected,
				},
			},
		},
	}
end

return SelectedInstances
