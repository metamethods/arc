local Fragment = require(script.Parent.Fragment)
local IconText = require(script.Parent.IconText)
local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local Text = require(script.Parent.Text)

local Children = Fusion.Children
type InstancesListProps = {
	instances: Fusion.Value<{ Instance }>,
}

local function InstancesList(scope: Fusion.Scope<typeof(Fusion)>, props: InstancesListProps)
	local scope = scope:deriveScope({
		Fragment = Fragment,
		IconText = IconText,
		Text = Text,
		Theme = Theme,
	})

	return scope:Computed(function(use, scope: typeof(scope))
		if #use(props.instances) == 0 then
			return scope:Text {
				text = "<i>No instances</i>",
				textColor = scope:Theme("subtext"),
			}
		end

		return scope:ForValues(props.instances, function(_, scope: typeof(scope), instance)
			return scope:Fragment {
				direction = Enum.FillDirection.Horizontal,
				padding = UDim.new(0, 4),

				[Children] = scope:IconText {
					text = instance:GetFullName(),
					icon = {
						imageId = 104624195613642,
					},
				},
			}
		end)
	end)
end

return InstancesList
