local types = require(script.Parent.Parent.Parent.Parent.Parent.types)
local instances = require(script.Parent.Parent.Parent.Parent.Parent.utils.instances)
local iterColors = require(script.Parent.Parent.Parent.Parent.Parent.utils.iterColors)
local requireSelection = require(script.Parent.requireSelection)

local action: types.ActionDefinition = {
	title = "Randomize Color",
	description = "Picks a random color for all of your selected instances/descendants",
	checkFn = requireSelection,
	fn = function(selection)
		local rng = Random.new()
		local color = Color3.new(rng:NextNumber(), rng:NextNumber(), rng:NextNumber())

		for _, selectedInstance in selection do
			iterColors(instances(selectedInstance), function()
				return color
			end)
		end
	end,
}

return action
