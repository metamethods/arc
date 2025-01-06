local List = require(script.Parent.List)
local Padding = require(script.Parent.Padding)
local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local Rounded = require(script.Parent.Rounded)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

type ContainerProps = {
	padding: UDim?,
	backgroundColor: UsedAs<Color3>?,
	visible: UsedAs<boolean>?,

	[typeof(Children)]: Fusion.Child,
}

local function Container(scope: Fusion.Scope<typeof(Fusion)>, props: ContainerProps)
	local scope = scope:deriveScope({
		List = List,
		Padding = Padding,
		Rounded = Rounded,
		Theme = Theme,
	})

	return scope:New "Frame" {
		BackgroundColor3 = props.backgroundColor or scope:Theme("middle"),
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Visible = props.visible,

		[Children] = {
			props[Children],

			scope:Padding(UDim.new(0, 8)),
			scope:Rounded(),
		},
	}
end

return Container
