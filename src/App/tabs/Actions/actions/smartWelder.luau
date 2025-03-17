local types = require(script.Parent.Parent.Parent.Parent.Parent.types)
local LinkList = require(script.Parent.Parent.Parent.Parent.Parent.utils.LinkList)
local getConnectors = require(script.Parent.Parent.Parent.Parent.Parent.utils.getConnectors)
local primaryPart = require(script.Parent.Parent.Parent.Parent.Parent.utils.primaryPart)
local requirePrimaryPartSelection = require(script.Parent.requirePrimaryPartSelection)

local action: types.ActionDefinition = {
	title = "Smart Welder",
	description = "Adds weld constraints to unanchored and unconstrainted parts to the selected instance",
	checkFn = requirePrimaryPartSelection,
	fn = function(selected)
		for _, selectedInstance in selected do
			local primary = primaryPart(selectedInstance)
			local linkList = LinkList.fromConnectors(getConnectors(selectedInstance))

			assert(primary, `Missing primary part`)

			for _, instance in selectedInstance:GetDescendants() do
				if not instance:IsA("BasePart") or instance == primary or instance.Anchored then
					continue
				end
				if not linkList:linkedTo(instance, primary) then
					local weldConstraint = Instance.new("WeldConstraint")
					weldConstraint.Part0 = instance
					weldConstraint.Part1 = primary
					weldConstraint.Parent = instance
				end
			end
		end
	end,
}

return action
