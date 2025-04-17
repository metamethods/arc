local Fragment = require(script.Parent.Fragment)
local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local Rounded = require(script.Parent.Rounded)
local TextBox = require(script.Parent.TextBox)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

type ImageTextProps = {
	image: number | string,
	text: number | string,
	backgroundColor: UsedAs<Color3>?,
	size: UsedAs<UDim2>?,
	textAlignment: UsedAs<Enum.TextXAlignment>?,
	[typeof(Children)]: Fusion.Child?,
}

local function ImageText(scope: Fusion.Scope<typeof(Fusion)>, props: ImageTextProps)
	local scope = scope:deriveScope({
		Fragment = Fragment,
		TextBox = TextBox,
		Rounded = Rounded,
		Theme = Theme,
	})

	local image = if typeof(props.image) == "number" then `rbxassetid://{props.image}` else props.image

	return scope:Fragment {
		size = UDim2.fromScale(0, 0),
		horizontalFlex = Enum.UIFlexAlignment.Fill,
		automaticSize = Enum.AutomaticSize.XY,

		[Children] = {
			scope:New "ImageLabel" {
				BackgroundColor3 = props.backgroundColor or scope:Theme("middle"),
				Size = props.size or UDim2.fromOffset(100, 100),

				Image = image,

				[Children] = scope:Rounded(),
			},

			scope:TextBox {
				text = props.text,
				textXAlignment = props.textAlignment,
				backgroundColor = props.backgroundColor,
				size = UDim2.fromScale(0, 0),
				automaticSize = Enum.AutomaticSize.Y,
				editable = false,
			},

			props[Children],
		},
	}
end

return ImageText
