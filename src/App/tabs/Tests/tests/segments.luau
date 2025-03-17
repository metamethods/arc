local Selection = game:GetService("Selection")

local types = require(script.Parent.Parent.Parent.Parent.Parent.types)

local MAX_BEAM_SEGMENTS = 12_000

local test: types.TestDefinition = {
	title = "Beam Segments",
	description = `Checks if the total beam segments of selected instance(s) is <b>under {MAX_BEAM_SEGMENTS}</b>`,
	fn = function(selection)
		local totalBeamSegments = 0
		local hintStack: { types.StackEntry } = {}

		for _, selectedInstance in selection do
			for _, instance in selectedInstance:GetDescendants() do
				if not instance:IsA("Beam") then
					continue
				end
				totalBeamSegments += instance.Segments

				if (instance.CurveSize0 ~= 0 or instance.CurveSize1 ~= 0) and instance.Segments > 20 then
					table.insert(hintStack, {
						text = `<b>{instance:GetFullName()}</b> has <b>{instance.Segments} segments</b>. Recommended to <b>keep them under 20 for curved beams</b>`,
						fn = function()
							Selection:Set({ instance })
						end,
					})
				elseif instance.Segments > 3 then
					table.insert(hintStack, {
						text = `<b>{instance:GetFullName()}</b> has <b>{instance.Segments} segments</b>. Recommended to <b>keep them under 3 for straight beams</b>`,
						fn = function()
							Selection:Set({ instance })
						end,
					})
				end
			end
		end

		if totalBeamSegments > MAX_BEAM_SEGMENTS then
			return {
				success = false,
				message = `Contains <b>{totalBeamSegments} total beam segments</b> which is <b>greater than {MAX_BEAM_SEGMENTS} segments</b>`,
				stack = hintStack,
			}
		else
			return {
				success = true,
				message = `Contains <b>{totalBeamSegments} total beam segments</b>`,
			}
		end
	end,
}

return test
