local types = require(script.Parent.Parent.Parent.Parent.Parent.types)
local instances = require(script.Parent.Parent.Parent.Parent.Parent.utils.instances)
local iterColors = require(script.Parent.Parent.Parent.Parent.Parent.utils.iterColors)
local requireSelection = require(script.Parent.requireSelection)

local action: types.ActionDefinition = {
	title = "Grayscale",
	description = "Grayscale all colors",
	checkFn = requireSelection,
	fn = function(selection)
		for _, selectedInstance in selection do
			iterColors(instances(selectedInstance), function(color)
				local avg = (color.R + color.G + color.B) / 3
				return Color3.new(avg, avg, avg)
			end)
		end
	end,
}

return action
