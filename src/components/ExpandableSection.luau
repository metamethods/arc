local Button = require(script.Parent.Button)
local Frame = require(script.Parent.Frame)
local Divider = require(script.Parent.Divider)
local Fragment = require(script.Parent.Fragment)
local Padding = require(script.Parent.Padding)
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
		Frame = Frame,
		Fragment = Fragment,
		Button = Button,
		Text = Text,
		Divider = Divider,
		Padding = Padding,
		Rounded = Rounded,
		Theme = Theme,
	})

	return scope:Frame {
		[Children] = {
			scope:Fragment {
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
							then scope:Frame {
								[Children] = {
									scope:Fragment {
										[Children] = props[Children],
									},

									scope:Padding(UDim.new(0, 8)),
									scope:Rounded(),
								},
							}
							else {}
					end),

					scope:Rounded(),
				},
			},

			scope:Rounded(),
		},
	}
end

return ExpandableSection
