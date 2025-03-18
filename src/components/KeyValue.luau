local Fragment = require(script.Parent.Fragment)
local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local Text = require(script.Parent.Text)
local TextBox = require(script.Parent.TextBox)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

type KeyValueProps = {
	key: UsedAs<string>,
	value: UsedAs<string>,
	valueBackground: UsedAs<Color3>?,
	layoutOrder: UsedAs<number>?,
}

local function KeyValue(scope: Fusion.Scope<typeof(Fusion)>, props: KeyValueProps)
	local scope = scope:deriveScope({
		Fragment = Fragment,
		TextBox = TextBox,
		Text = Text,
		Theme = Theme,
	})

	return scope:Fragment {
		direction = Enum.FillDirection.Horizontal,
		verticalAlignment = Enum.VerticalAlignment.Center,
		layoutOrder = props.layoutOrder,
		automaticSize = Enum.AutomaticSize.XY,
		size = UDim2.fromScale(0, 0),

		[Children] = {
			scope:Text {
				text = props.key,
			},

			scope:TextBox {
				text = props.value,
				textColor = scope:Theme "accent_sub",
				backgroundColor = props.valueBackground,
				fontWeight = Enum.FontWeight.Bold,
				editable = false,
			},
		},
	}
end

return KeyValue
