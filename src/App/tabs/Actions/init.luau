local ChangeHistoryService = game:GetService("ChangeHistoryService")

local Action = require(script.Parent.Parent.Parent.components.Action)
local Divider = require(script.Parent.Parent.Parent.components.Divider)
local Fragment = require(script.Parent.Parent.Parent.components.Fragment)
local Page = require(script.Parent.Parent.Parent.components.Page)
local SelectedInstances = require(script.Parent.Parent.Parent.components.SelectedInstances)
local Text = require(script.Parent.Parent.Parent.components.Text)
local Fusion = require(script.Parent.Parent.Parent.packages.Fusion)
local types = require(script.Parent.Parent.Parent.types)
local Theme = require(script.Parent.Parent.Theme)
local actions = require(script.actions)

local Children = Fusion.Children

local function Actions(scope: types.AppScope)
	local scope = scope:deriveScope({
		Page = Page,
		Action = Action,
		SelectedInstances = SelectedInstances,
		Fragment = Fragment,
		Text = Text,
		Divider = Divider,
		Theme = Theme,
	})

	return scope:Page {
		[Children] = {
			scope:SelectedInstances {
				selected = scope.rawSelected,
			},

			scope:Divider(),

			scope:Computed(function(use, scope: typeof(scope))
				return scope:ForValues(
					actions[use(scope.selectedSuite)] or {},
					function(_, scope: typeof(scope), actionDefinition: types.ActionDefinition)
						return scope:Action {
							action = actionDefinition,
							disabled = scope:Computed(function(use)
								local ok, message = (actionDefinition.checkFn or function()
									return true
								end :: types.ActionCheckFn)(use(scope.rawSelected))

								return {
									ok = ok,
									message = message,
								}
							end),
							activated = function()
								actionDefinition.fn(Fusion.peek(scope.rawSelected))
								ChangeHistoryService:SetWaypoint("Finished Action")
							end,
						}
					end
				)
			end),
		},
	}
end

return Actions
