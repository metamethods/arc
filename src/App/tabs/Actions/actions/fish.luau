local types = require(script.Parent.Parent.Parent.Parent.Parent.types)

local action: types.ActionDefinition = {
	title = "Fish",
	description = "🐟🐟🐟",
	fn = function()
		print("🐟")
	end,
}

return action
