local List = require(script.Parent.List)
local Padding = require(script.Parent.Padding)
local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local Rounded = require(script.Parent.Rounded)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

type FrameProps = {
	padding: UDim?,
	backgroundColor: UsedAs<Color3>?,
	backgroundTransparency: UsedAs<number>?,
	visible: UsedAs<boolean>?,
	[typeof(Children)]: Fusion.Child,
}

local function Frame(scope: Fusion.Scope<typeof(Fusion)>, props: FrameProps)
	local scope = scope:deriveScope({
		List = List,
		Padding = Padding,
		Rounded = Rounded,
		Theme = Theme,
	})

	return scope:New "Frame" {
		BackgroundColor3 = props.backgroundColor or scope:Theme("middle"),
		BackgroundTransparency = props.backgroundTransparency or 0,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Visible = props.visible,

		[Children] = {
			props[Children],
		},
	}
end

return Frame
