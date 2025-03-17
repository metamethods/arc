local Outline = require(script.Parent.Outline)
local Padding = require(script.Parent.Padding)
local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local Rounded = require(script.Parent.Rounded)
local Text = require(script.Parent.Text)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

type UsedAs<T> = Fusion.UsedAs<T>

type ButtonProps = {
	size: UDim2?,
	text: UsedAs<string>?,
	textXAlignment: UsedAs<Enum.TextXAlignment>?,
	primary: UsedAs<boolean>?,
	disabled: UsedAs<boolean>?,
	cornerRadius: UDim?,
	outline: boolean?,
	clicked: () -> ()?,
	[typeof(Children)]: Fusion.Child,
}

local function Button(scope: Fusion.Scope<typeof(Fusion)>, props: ButtonProps)
	local scope = scope:deriveScope({
		Text = Text,
		Outline = Outline,
		Padding = Padding,
		Rounded = Rounded,
		Theme = Theme,
	})

	local hovering = scope:Value(false)
	local pressed = scope:Value(false)

	local overlayTransparency = scope:Computed(function(use)
		if use(props.disabled) then
			return 0.5
		end

		if use(pressed) then
			return 0.5
		end

		if use(hovering) then
			return 0.75
		end

		return 1
	end)

	return scope:New "TextButton" {
		BackgroundColor3 = scope:Computed(function(use, scope)
			return if use(props.primary) then use(scope:Theme("accent")) else use(scope:Theme("middle"))
		end),
		Size = props.size,
		AutomaticSize = Enum.AutomaticSize.XY,

		Text = props.text,
		RichText = true,
		TextWrapped = true,
		TextSize = 16,
		TextColor3 = scope:Computed(function(use, scope)
			return if use(props.primary) then use(scope:Theme("text_light")) else use(scope:Theme("text"))
		end),
		FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
		TextXAlignment = props.textXAlignment or Enum.TextXAlignment.Left,

		[OnEvent "MouseButton1Down"] = function()
			pressed:set(true)

			if not Fusion.peek(props.disabled) and props.clicked then
				props.clicked()
			end
		end,

		[OnEvent "MouseButton1Up"] = function()
			pressed:set(false)
		end,

		[OnEvent "MouseEnter"] = function()
			hovering:set(true)
		end,

		[OnEvent "MouseLeave"] = function()
			hovering:set(false)
			pressed:set(false)
		end,

		[Children] = {
			props[Children],

			scope:New "Frame" {
				BackgroundColor3 = scope:Theme("overlay"),
				BackgroundTransparency = scope:Spring(overlayTransparency, 50),
				Size = UDim2.new(1, 20, 1, 16),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),

				[Children] = scope:Rounded(props.cornerRadius),
			},

			scope:Padding(UDim.new(0, 8), UDim.new(0, 10)),
			scope:Rounded(props.cornerRadius),
			scope:Outline {
				color = scope:Computed(function(use, scope)
					return if use(props.primary) then use(scope:Theme("accent_sub")) else use(scope:Theme("overlay"))
				end),
				thickness = if props.outline then 1 else 0,
			},
		},
	}
end

return Button
