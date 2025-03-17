local types = require(script.Parent.Parent.Parent.Parent.Parent.Parent.types)

local MAX_BASEPARTS = 100

local testDefinition: types.TestDefinition = {
	title = "BaseParts",
	description = `Checks if the total BaseParts <i>(Part, MeshPart, Unions, etc...)</i> of selected instance(s) is <b>under {MAX_BASEPARTS}</b> <i>(Does not include the selected instance)</i>`,
	fn = function(selection)
		local totalBaseParts = 0

		for _, selectedInstance in selection do
			for _, instance in selectedInstance:GetDescendants() do
				if instance:IsA("BasePart") then
					totalBaseParts += 1
				end
			end
		end

		if totalBaseParts <= MAX_BASEPARTS then
			return {
				success = true,
				message = `Currently have <b>{totalBaseParts} BaseParts</b>`,
			}
		else
			return {
				success = false,
				message = `Currently have <b>{totalBaseParts} BaseParts</b> which is greater than <b>{MAX_BASEPARTS}</b>`,
			}
		end
	end,
}

return testDefinition
