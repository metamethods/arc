local setProperty = require(script.Parent.Parent.Parent.Parent.Parent.Parent.components.setProperty)
local types = require(script.Parent.Parent.Parent.Parent.Parent.Parent.types)
local instances = require(script.Parent.Parent.Parent.Parent.Parent.Parent.utils.instances)
local iterColors = require(script.Parent.Parent.Parent.Parent.Parent.Parent.utils.iterColors)
local primaryPart = require(script.Parent.Parent.Parent.Parent.Parent.Parent.utils.primaryPart)
local requireSelection = require(script.Parent.Parent.requireSelection)

local action: types.ActionDefinition = {
	title = "Ionize",
	description = "Ionizes your ore",
	checkFn = requireSelection,
	fn = function(selection)
		for _, selectedInstance in selection do
			iterColors(instances(selectedInstance), function(color, instance)
				local newColor = Color3.new(1 - color.B, 1 - color.R, 1 - color.G)

				if newColor == Color3.new(0, 0, 0) then
					setProperty(instance, "LightEmission", 0)
				end

				return newColor
			end)

			primaryPart(selectedInstance, true):SetAttribute("Ionized", true)
		end
	end,
}

return action
