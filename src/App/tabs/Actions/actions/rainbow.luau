local types = require(script.Parent.Parent.Parent.Parent.Parent.types)
local instances = require(script.Parent.Parent.Parent.Parent.Parent.utils.instances)
local iterColors = require(script.Parent.Parent.Parent.Parent.Parent.utils.iterColors)
local requireSelection = require(script.Parent.requireSelection)

local action: types.ActionDefinition = {
	title = "Rainbow",
	description = "Make all of instances/descendants rainbow",
	checkFn = requireSelection,
	fn = function(selection)
		for _, selectedInstance in selection do
			local hue = 0

			iterColors(instances(selectedInstance), function(color)
				local _, saturation, value = color:ToHSV()
				hue += 8
				return Color3.fromHSV((hue - 1) % 361 / 360, saturation, value)
			end)
		end
	end,
}

return action
