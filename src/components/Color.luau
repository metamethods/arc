local Fragment = require(script.Parent.Fragment)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local Rounded = require(script.Parent.Rounded)
local TextBox = require(script.Parent.TextBox)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

type ColorProps = {
	color: Color3,
	size: UsedAs<UDim2>?,
}

local function Color(scope: Fusion.Scope<typeof(Fusion)>, props: ColorProps)
	local scope = scope:deriveScope({
		Fragment = Fragment,
		Rounded = Rounded,
		TextBox = TextBox,
	})

	return scope:New "Frame" {
		BackgroundColor3 = props.color,
		Size = props.size or UDim2.new(1, 0, 0, 40),

		[Children] = {
			scope:Fragment {
				size = UDim2.fromScale(1, 1),
				automaticSize = Enum.AutomaticSize.None,
				horizontalAlignment = Enum.HorizontalAlignment.Center,
				verticalAlignment = Enum.VerticalAlignment.Center,
				[Children] = scope:TextBox {
					text = `#{props.color:ToHex()}`,
					fontWeight = Enum.FontWeight.Bold,
				},
			},

			scope:Rounded(),
		},
	}
end

return Color
