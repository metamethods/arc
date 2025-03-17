local types = require(script.Parent.Parent.Parent.Parent.Parent.types)
local instances = require(script.Parent.Parent.Parent.Parent.Parent.utils.instances)
local iterColors = require(script.Parent.Parent.Parent.Parent.Parent.utils.iterColors)
local requireSelection = require(script.Parent.requireSelection)

local action: types.ActionDefinition = {
	title = "Randomize Colors",
	description = "Randomizes all of the colors for every single instance/descendant selected",
	checkFn = requireSelection,
	fn = function(selection)
		local rng = Random.new()

		for _, selectedInstance in selection do
			iterColors(instances(selectedInstance), function()
				return Color3.new(rng:NextNumber(), rng:NextNumber(), rng:NextNumber())
			end)
		end
	end,
}

return action
