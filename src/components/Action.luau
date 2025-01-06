local Button = require(script.Parent.Button)
local Divider = require(script.Parent.Divider)
local Fragment = require(script.Parent.Fragment)
local Padding = require(script.Parent.Padding)
local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local types = require(script.Parent.Parent.types)
local Text = require(script.Parent.Text)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

type ActionProps = {
	action: types.ActionDefinition,
	disabled: UsedAs<{ ok: boolean, message: string? }>,
	activated: () -> (),
}

local function Action(scope: Fusion.Scope<typeof(Fusion)>, props: ActionProps)
	local scope = scope:deriveScope({
		Button = Button,
		Text = Text,
		Fragment = Fragment,
		Padding = Padding,
		Divider = Divider,
		Theme = Theme,
	})

	local buttonDisabled = scope:Computed(function(use)
		return not use(props.disabled).ok
	end)

	return scope:Button {
		size = UDim2.fromScale(1, 0),
		disabled = buttonDisabled,
		clicked = props.activated,

		[Children] = {
			scope:Fragment {
				padding = UDim.new(0, 8),

				[Children] = {
					scope:Fragment {
						padding = UDim.new(0, 0),

						[Children] = {
							scope:Text {
								text = props.action.title,
								textSize = 20,
								fontWeight = Enum.FontWeight.Bold,
							},

							scope:Text {
								text = props.action.description,
							},
						},
					},

					scope:Fragment {
						visible = buttonDisabled,

						[Children] = {
							scope:Divider(),

							scope:Text {
								text = scope:Computed(function(use)
									return use(props.disabled).message or ""
								end),
								textColor = scope:Theme("red"),
							},
						},
					},
				},
			},
		},
	}
end

return Action
