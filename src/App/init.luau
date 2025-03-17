local Button = require(script.Parent.components.Button)
local Dropdown = require(script.Parent.components.Dropdown)
local Flex = require(script.Parent.components.Flex)
local Fragment = require(script.Parent.components.Fragment)
local List = require(script.Parent.components.List)
local Padding = require(script.Parent.components.Padding)
local Rounded = require(script.Parent.components.Rounded)
local ScrollableFragment = require(script.Parent.components.ScrollableFragment)
local Text = require(script.Parent.components.Text)
local Fusion = require(script.Parent.packages.Fusion)
local suites = require(script.Parent.suites)
local types = require(script.Parent.types)
local map = require(script.Parent.utils.map)
local Theme = require(script.Theme)
local tabs = require(script.tabs)

local Children = Fusion.Children

local function App(scope: types.AppScope)
	local scope = scope:deriveScope({
		ScrollableFragment = ScrollableFragment,
		Button = Button,
		Dropdown = Dropdown,
		Fragment = Fragment,
		Text = Text,
		List = List,
		Padding = Padding,
		Rounded = Rounded,
		Flex = Flex,
		Theme = Theme,
	})

	local selectedTab = scope:Value(tabs[1].component)

	return scope:New "Frame" {
		BackgroundColor3 = scope:Theme("background"),
		Size = UDim2.fromScale(1, 1),

		[Children] = {
			scope:List {
				padding = UDim.new(0, 8),
				verticalFlex = Enum.UIFlexAlignment.Fill,
			},
			scope:Padding(UDim.new(0, 8)),

			scope:ScrollableFragment {
				size = UDim2.fromScale(1, 0),
				direction = Enum.FillDirection.Horizontal,

				root = scope:Flex(),

				[Children] = {
					scope:ForValues(tabs, function(_, scope: typeof(scope), route)
						return scope:Button {
							text = route.name,
							primary = scope:Computed(function(use)
								return use(selectedTab) == route.component
							end),
							clicked = function()
								selectedTab:set(route.component)
							end,
						}
					end),
				},
			},

			scope:New "Frame" {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ClipsDescendants = true,

				[Children] = scope:Computed(function(use, scope)
					return use(selectedTab)(scope)
				end),
			},

			scope:New "Frame" {
				BackgroundColor3 = scope:Theme("middle"),
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,

				[Children] = {
					scope:List {},

					scope:Text {
						text = scope:Computed(function(use)
							local selected = use(scope.selected)

							if not selected then
								return "No selected instance found"
							end

							local instances = map(selected, function(instance)
								return instance:GetFullName()
							end)
							return `Selected instance <b>{instances[1]}</b> {if #instances > 1
								then `<i>+{#instances - 1} more</i>`
								else ""}`
						end),
					},

					scope:Button {
						text = scope:Computed(function(use)
							return `<b>{if use(scope.selectionLocked) then "Unlock" else "Lock"}</b> selection`
						end),
						clicked = function()
							scope.selectionLocked:set(not Fusion.peek(scope.selectionLocked))
						end,
						outline = true,
					},

					scope:Text {
						text = "<i>Click the button below to change the current suite</i>",
						textColor = scope:Theme("subtext"),
					},

					scope:Dropdown {
						title = "Select Suite",
						items = suites,
						selected = scope.selectedSuite,
					},

					scope:Padding(UDim.new(0, 8), UDim.new(0, 10)),
					scope:Rounded(),
					scope:Flex(),
				},
			},
		},
	}
end

return App
