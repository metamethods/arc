local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)

type UsedAs<T> = Fusion.UsedAs<T>

type TextProps = {
	text: UsedAs<string>,
	textSize: UsedAs<number>,
	textColor: UsedAs<Color3>?,
	fontWeight: Enum.FontWeight?,
	size: UsedAs<UDim2>?,
	visible: UsedAs<boolean>?,
}

local function Text(scope: Fusion.Scope<typeof(Fusion)>, props: TextProps)
	local scope = scope:innerScope({
		Theme = Theme,
	})

	return scope:New "TextLabel" {
		BackgroundTransparency = 1,
		Size = props.size,
		AutomaticSize = if not props.size then Enum.AutomaticSize.XY else Enum.AutomaticSize.Y,
		Visible = props.visible,

		Text = props.text,
		TextWrapped = true,
		RichText = true,
		TextSize = props.textSize or 16,
		TextColor3 = props.textColor or scope:Theme("text"),
		FontFace = Font.fromName("Montserrat", props.fontWeight or Enum.FontWeight.Medium),
		TextXAlignment = Enum.TextXAlignment.Left,
	}
end

return Text
