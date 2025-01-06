local Button = require(script.Parent.Parent.Parent.components.Button)
local Divider = require(script.Parent.Parent.Parent.components.Divider)
local Padding = require(script.Parent.Parent.Parent.components.Padding)
local Page = require(script.Parent.Parent.Parent.components.Page)
local ScrollableFragment = require(script.Parent.Parent.Parent.components.ScrollableFragment)
local Test = require(script.Parent.Parent.Parent.components.Test)
local Fusion = require(script.Parent.Parent.Parent.packages.Fusion)
local types = require(script.Parent.Parent.Parent.types)
local tests = require(script.tests)

local Children = Fusion.Children

local function Tests(scope: types.AppScope)
	local scope = scope:deriveScope({
		Page = Page,
		ScrollableFragment = ScrollableFragment,
		Button = Button,
		Test = Test,
		Divider = Divider,
		Padding = Padding,
	})

	local disabled = scope:Computed(function(use)
		return use(scope.selected) == nil
	end)

	local runTestsEvent: BindableEvent = scope:New "BindableEvent" {}
	local clearTestsEvent: BindableEvent = scope:New "BindableEvent" {}

	scope:Observer(scope.selected):onChange(function()
		clearTestsEvent:Fire()
	end)

	return scope:Page {
		[Children] = {
			scope:ScrollableFragment {
				size = UDim2.new(1, 0, 0, 32),
				direction = Enum.FillDirection.Horizontal,

				[Children] = {
					scope:Button {
						text = "Run Tests",
						primary = true,
						disabled = disabled,
						clicked = function()
							runTestsEvent:Fire()
						end,
					},

					scope:Button {
						text = "Clear Tests",
						clicked = function()
							clearTestsEvent:Fire()
						end,
					},
				},
			},

			scope:Divider(),

			scope:Computed(function(use, scope: typeof(scope))
				return scope:ForValues(
					tests[use(scope.selectedSuite)] or {},
					function(_, scope: typeof(scope), testDefinition)
						local result: Fusion.Value<types.TestResult?> = scope:Value()

						local function runTest()
							result:set(testDefinition.fn(Fusion.peek(scope.selected)))
						end

						local function clearTest()
							result:set()
						end

						-- add this to scope which it can be cleanuped later
						table.insert(scope, runTestsEvent.Event:Connect(runTest))
						table.insert(scope, clearTestsEvent.Event:Connect(clearTest))

						return scope:Test {
							test = testDefinition,
							result = result,
							disabled = disabled,
							runTest = runTest,
							clearTest = clearTest,
						}
					end
				)
			end),
		},
	}
end

return Tests
