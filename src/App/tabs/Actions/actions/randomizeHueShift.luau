local types = require(script.Parent.Parent.Parent.Parent.Parent.types)
local instances = require(script.Parent.Parent.Parent.Parent.Parent.utils.instances)
local iterColors = require(script.Parent.Parent.Parent.Parent.Parent.utils.iterColors)
local requireSelection = require(script.Parent.requireSelection)

local action: types.ActionDefinition = {
	title = "Randomize Hue Shift",
	description = "Shifts all of the hue for the colors in the ore",
	checkFn = requireSelection,
	fn = function(selection)
		for _, selectedInstance in selection do
			local shift = math.random()

			iterColors(instances(selectedInstance), function(color)
				local h, s, v = color:ToHSV()
				return Color3.fromHSV((h + shift) % 1, s, v)
			end)
		end
	end,
}

return action
