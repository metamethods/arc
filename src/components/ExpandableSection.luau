local Button = require(script.Parent.Button)
local Container = require(script.Parent.Container)
local Divider = require(script.Parent.Divider)
local Fragment = require(script.Parent.Fragment)
local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local Rounded = require(script.Parent.Rounded)
local Text = require(script.Parent.Text)

local Children = Fusion.Children

local peek = Fusion.peek

type UsedAs<T> = Fusion.UsedAs<T>

type ExpandableSectionProps = {
	open: Fusion.Value<boolean>,
	title: UsedAs<string>,
	[typeof(Children)]: Fusion.Child,
}

local function ExpandableSection(scope: Fusion.Scope<typeof(Fusion)>, props: ExpandableSectionProps)
	local scope = scope:deriveScope({
		Container = Container,
		Fragment = Fragment,
		Button = Button,
		Text = Text,
		Divider = Divider,
		Rounded = Rounded,
		Theme = Theme,
	})

	return scope:Container {
		padding = UDim.new(0, 0),

		[Children] = scope:Fragment {
			padding = UDim.new(0, 0),

			[Children] = {
				scope:Button {
					text = props.title,
					textSize = 20,
					fontWeight = Enum.FontWeight.Bold,
					size = UDim2.fromScale(1, 0),
					clicked = function()
						props.open:set(not peek(props.open))
					end,
				},

				scope:Computed(function(use)
					return if use(props.open)
						then scope:Container {
							[Children] = scope:Fragment {
								[Children] = props[Children],
							},
						}
						else {}
				end),

				scope:Rounded(),
			},
		},
	}
end

return ExpandableSection
