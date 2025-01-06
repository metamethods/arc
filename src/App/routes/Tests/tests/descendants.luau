local types = require(script.Parent.Parent.Parent.Parent.Parent.types)

local MAX_DESCENDANTS = 1_000

local testDefinition: types.TestDefinition = {
	title = "Descendants",
	description = `Checks if the total descendants of selected instance(s) is <b>under {MAX_DESCENDANTS}</b> <i>(Includes the selected instance)</i>`,
	fn = function(selection)
		local totalDescendants = 0

		for _, selectedInstance in selection do
			totalDescendants += #selectedInstance:GetDescendants() + 1
			-- for sols auras
			totalDescendants -= if selectedInstance:FindFirstChild("AnimSaves")
				then #selectedInstance.AnimSaves:GetDescendants() + 1
				else 0
		end

		if totalDescendants <= MAX_DESCENDANTS then
			return {
				success = true,
				message = `Currently have <b>{totalDescendants} descendants</b>`,
			}
		else
			return {
				success = false,
				message = `Currently have <b>{totalDescendants} descendants</b> which is greater than <b>{MAX_DESCENDANTS}</b>`,
			}
		end
	end,
}

return testDefinition
