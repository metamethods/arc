local Selection = game:GetService("Selection")

local types = require(script.Parent.Parent.Parent.Parent.Parent.Parent.types)
local primaryPart = require(script.Parent.Parent.Parent.Parent.Parent.Parent.utils.primaryPart)

local test: types.TestDefinition = {
	title = "Collision Query",
	description = "Checks if all of the descendants of the selected instance(s) have the collision and query property disabled",
	fn = function(selection)
		local stack: { types.StackEntry } = {}

		local ore = primaryPart(selection[1])

		for _, selectedInstance in selection do
			for _, instance in selectedInstance:GetDescendants() do
				if not instance:IsA("BasePart") or instance == ore then
					continue
				end
				if instance.CanCollide or instance.CanQuery then
					table.insert(stack, {
						text = `<b>{instance:GetFullName()}</b> has either CanCollide and or CanQuery enabled`,
						fn = function()
							Selection:Set({ instance })
						end,
					})
				end
			end
		end

		if #stack > 0 then
			return {
				success = false,
				message = `{#stack} descendants either have the collision and or query property enabled`,
				stack = stack,
			}
		else
			return {
				success = true,
				message = "All descendants have the collision and query property disabled",
			}
		end
	end,
}

return test
