local Button = require(script.Parent.Button)
local Container = require(script.Parent.Container)
local Divider = require(script.Parent.Divider)
local Fragment = require(script.Parent.Fragment)
local Padding = require(script.Parent.Padding)
local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local types = require(script.Parent.Parent.types)
local Rounded = require(script.Parent.Rounded)
local ScrollableFragment = require(script.Parent.ScrollableFragment)
local StackEntry = require(script.Parent.StackEntry)
local Text = require(script.Parent.Text)

local Children = Fusion.Children

type TestProps = {
	test: types.TestDefinition,
	result: Fusion.Value<types.TestResult?>,
	disabled: Fusion.Value<boolean>,
	runTest: () -> (),
	clearTest: () -> (),
}

local function Test(scope: Fusion.Scope<typeof(Fusion)>, props: TestProps)
	local scope = scope:deriveScope({
		StackEntry = StackEntry,
		Container = Container,
		Fragment = Fragment,
		ScrollableFragment = ScrollableFragment,
		Button = Button,
		Text = Text,
		Divider = Divider,
		Padding = Padding,
		Rounded = Rounded,
		Theme = Theme,
	})

	local resultColor = scope:Computed(function(use, scope: typeof(scope))
		local result = use(props.result)
		return if result
			then if result.success then use(scope:Theme(result.overlayColor or "green")) else use(scope:Theme("red"))
			else use(scope:Theme("accent"))
	end)

	local stackOpen = scope:Value(false)

	return scope:Fragment {
		direction = Enum.FillDirection.Vertical,

		[Children] = {
			scope:Container {
				[Children] = {
					scope:Fragment {
						padding = UDim.new(0, 8),

						[Children] = {
							scope:Fragment {
								padding = UDim.new(0, 0),

								[Children] = {
									scope:Text {
										text = props.test.title,
										textSize = 20,
										fontWeight = Enum.FontWeight.Bold,
									},

									scope:Text {
										text = props.test.description,
									},
								},
							},

							scope:Divider(),

							scope:Text {
								text = scope:Computed(function(use)
									local result = use(props.result)
									return if result then result.message else "<i>No Message</i>"
								end),
							},

							scope:Divider(),

							scope:Text {
								text = scope:Computed(function(use)
									local result = use(props.result)
									return `Test Result ... <font color="#{use(resultColor):ToHex()}">{if result
										then if result.success then "OK" else "FAIL"
										else "None"}</font>`
								end),
							},
						},
					},
				},
			},

			scope:ScrollableFragment {
				size = UDim2.new(1, 0, 0, 32),
				direction = Enum.FillDirection.Horizontal,

				[Children] = {
					scope:Button {
						text = "Run Test",
						primary = true,
						disabled = props.disabled,
						clicked = props.runTest,
					},

					scope:Button {
						text = "Clear Test",
						clicked = props.clearTest,
					},

					scope:Button {
						text = "View Stack",
						disabled = scope:Computed(function(use)
							local result = use(props.result)
							return not result or use(props.result).stack == nil
						end),
						clicked = function()
							stackOpen:set(not Fusion.peek(stackOpen))
						end,
					},
				},
			},

			scope:Container {
				visible = scope:Computed(function(use)
					local result = use(props.result)
					if not result or #(result.stack or {}) == 0 then
						return false
					end
					return use(stackOpen)
				end),

				[Children] = scope:Fragment {
					[Children] = {
						scope:Text {
							text = "Click a stack entry below to view the stack <i>(Very recommended to lock your selection before clicking)</i>",
							textColor = scope:Theme("subtext"),
						},

						scope:Computed(function(use, scope: typeof(scope))
							local result = use(props.result)

							if not result then
								return
							end

							return scope:ForValues(result.stack or {}, function(_, scope: typeof(scope), stackEntry)
								return scope:StackEntry {
									stackEntry = stackEntry,
								}
							end)
						end),
					},
				},
			},
		},
	}
end

return Test
