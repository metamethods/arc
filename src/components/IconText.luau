local Fragment = require(script.Parent.Fragment)
local Icon = require(script.Parent.Icon)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local Text = require(script.Parent.Text)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

type IconTextProps = {
	text: UsedAs<string>,
	color: UsedAs<Color3>?,
	icon: Icon.IconProps,
	[typeof(Children)]: Fusion.Child?,
}

local function IconText(scope: Fusion.Scope<typeof(Fusion)>, props: IconTextProps)
	local scope = scope:deriveScope({
		Fragment = Fragment,
		Text = Text,
		Icon = Icon,
	})

	return scope:Fragment {
		direction = Enum.FillDirection.Horizontal,
		padding = UDim.new(0, 4),

		[Children] = {
			scope:Icon(props.icon),

			scope:Text {
				text = props.text,
				size = UDim2.new(1, -(props.icon.size or UDim2.fromOffset(16, 16)).X.Offset - 4, 0, 0),
				textColor = props.color,
			},

			props[Children],
		},
	}
end

return IconText
