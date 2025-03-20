local Padding = require(script.Parent.Padding)
local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local Rounded = require(script.Parent.Rounded)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

type TextBoxProps = {
	backgroundColor: UsedAs<Color3>?,
	text: Fusion.Value<string>,
	textXAlignment: Enum.TextXAlignment?,
	placeholderText: UsedAs<string>?,
	textSize: UsedAs<number>,
	textColor: UsedAs<Color3>?,
	placeholderColor: UsedAs<Color3>?,
	size: UsedAs<UDim2>?,
	automaticSize: UsedAs<Enum.AutomaticSize>?,
	position: UsedAs<UDim2>?,
	anchorPoint: UsedAs<Vector2>?,
	fontWeight: Enum.FontWeight?,
	editable: UsedAs<boolean>?,
}

local function TextBox(scope: Fusion.Scope<typeof(Fusion)>, props: TextBoxProps)
	local scope = scope:innerScope({
		Theme = Theme,
		Padding = Padding,
		Rounded = Rounded,
	})

	return scope:New "TextBox" {
		BackgroundColor3 = props.backgroundColor or scope:Theme("middle"),
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		Size = props.size,
		AutomaticSize = props.automaticSize or Enum.AutomaticSize.XY,

		Text = props.text,
		PlaceholderText = props.placeholderText or "",
		TextSize = props.textSize or 16,
		TextColor3 = props.textColor or scope:Theme("text"),
		PlaceholderColor3 = props.placeholderColor or scope:Theme("subtext"),
		FontFace = Font.fromName("Montserrat", props.fontWeight or Enum.FontWeight.Medium),
		ClearTextOnFocus = false,
		TextEditable = props.editable,
		TextXAlignment = props.textXAlignment or Enum.TextXAlignment.Left,
		ClipsDescendants = true,

		[Children] = {
			scope:Padding(UDim.new(0, 4), UDim.new(0, 6)),
			scope:Rounded(UDim.new(0, 4)),
		},
	}
end

return TextBox
