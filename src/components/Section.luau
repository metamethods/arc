local Fragment = require(script.Parent.Fragment)
local Frame = require(script.Parent.Frame)
local Padding = require(script.Parent.Padding)
local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)

local Children = Fusion.Children

type SectionProps = {
	header: Fusion.Child,
	[typeof(Children)]: Fusion.Child,
}

local function Section(scope: Fusion.Scope<typeof(Fusion)>, props: SectionProps)
	local scope = scope:deriveScope({
		Fragment = Fragment,
		Frame = Frame,
		Padding = Padding,
		Theme = Theme,
	})

	return scope:Fragment {
		[Children] = {
			props.header,

			scope:Frame {
				backgroundTransparency = 1,
				[Children] = {
					scope:Frame {
						backgroundTransparency = 1,
						[Children] = {
							scope:Frame {
								backgroundTransparency = 1,
								[Children] = props[Children],
							},
							scope:Padding(UDim.new(0, 0), UDim.new(0, 8), UDim.new(0, 0), UDim.new(0, 0)),
						},
					},
					scope:New "Frame" {
						BackgroundColor3 = scope:Theme("overlay"),
						Size = UDim2.new(0, 1, 1, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
					},
				},
			},
		},
	}
end

return Section
