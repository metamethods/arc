local Fragment = require(script.Parent.Fragment)
local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local Text = require(script.Parent.Text)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

type InstancesListProps = {
	instances: UsedAs<{ Instance }>,
}

local function InstancesList(scope: Fusion.Scope<typeof(Fusion)>, props: InstancesListProps)
	local scope = scope:deriveScope({
		Fragment = Fragment,
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

		return scope:ForValues(scope.rawSelected, function(_, scope: typeof(scope), instance)
			return scope:Fragment {
				direction = Enum.FillDirection.Horizontal,
				padding = UDim.new(0, 4),

				[Children] = {
					scope:New "ImageLabel" {
						Size = UDim2.fromOffset(16, 16),
						BackgroundTransparency = 1,

						Image = "rbxassetid://104624195613642",
						ImageColor3 = scope:Theme("text"),
					},

					scope:Text {
						text = instance:GetFullName(),
						size = UDim2.new(1, -20, 0, 0),
					},
				},
			}
		end)
	end)
end

return InstancesList
