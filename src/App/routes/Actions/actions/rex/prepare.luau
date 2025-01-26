local types = require(script.Parent.Parent.Parent.Parent.Parent.Parent.types)
local requireSelection = require(script.Parent.Parent.requireSelection)

local action: types.ActionDefinition = {
	title = "Prepare",
	description = "Prepares your ore for submission <i>(Removes any ion/spec attributes and set all sound objects to playing = false)</i>",
	checkFn = requireSelection,
	fn = function(selection)
		for _, selectedInstance in selection do
			selectedInstance:SetAttribute("Ionized", nil)
			selectedInstance:SetAttribute("Spectral", nil)

			for _, instance in selectedInstance:GetDescendants() do
				if instance:IsA("Sound") then
					instance.Playing = false
				end
			end
		end
	end,
}

return action
