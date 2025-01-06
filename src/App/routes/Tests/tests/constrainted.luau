local Selection = game:GetService("Selection")

local types = require(script.Parent.Parent.Parent.Parent.Parent.types)
local LinkList = require(script.Parent.Parent.Parent.Parent.Parent.utils.LinkList)
local map = require(script.Parent.Parent.Parent.Parent.Parent.utils.map)
local primaryPart = require(script.Parent.Parent.Parent.Parent.Parent.utils.primaryPart)

local test: types.TestDefinition = {
	title = "Constrainted",
	description = "Checks if all instances are <b>currently constrainted to the first/primary part selected</b> <i>(If more instances are selected, it'll check if they are contrainted to the first/primary part selected)</i>",
	fn = function(selected)
		local linkList: LinkList.LinkList<BasePart> = LinkList.new()

		local primaryPart = primaryPart(selected[1])
		local baseParts = {}
		local unconstraintedParts = {}

		for _, selectedInstance in selected do
			for _, instance in selectedInstance:GetDescendants() do
				if
					(instance:IsA("WeldConstraint") or instance:IsA("Motor6D") or instance:IsA("Weld"))
					and instance.Active
					and instance.Enabled
				then
					linkList:add(instance.Part0, instance.Part1)
				end

				if instance:IsA("Constraint") and instance.Enabled then
					linkList:add(
						instance.Attachment0:FindFirstAncestorWhichIsA("BasePart"),
						instance.Attachment1:FindFirstAncestorWhichIsA("BasePart")
					)
				end

				if instance:IsA("BasePart") then
					table.insert(baseParts, instance)
				end
			end
		end

		for _, basePart in baseParts do
			if basePart == primaryPart then
				continue
			end -- ignore
			if not linkList:linkedTo(basePart, primaryPart) then
				table.insert(unconstraintedParts, basePart)
			end
		end

		if #unconstraintedParts > 0 then
			return {
				success = false,
				message = `Selected instance(s) had <b>{#unconstraintedParts} unconstrained part{if #unconstraintedParts
						> 1
					then "s"
					else ""}</b> to the primary part <b>{primaryPart:GetFullName()}</b>`,
				stack = map(unconstraintedParts, function(unconstraintedPart)
					return {
						text = `<b>{unconstraintedPart:GetFullName()}</b> isnt constrained to <b>{primaryPart:GetFullName()}</b>`,
						fn = function()
							Selection:Set({ unconstraintedPart })
						end,
					}
				end),
			}
		else
			return {
				success = true,
				message = `Everything is <b>constrained</b> to the primary part <b>{primaryPart:GetFullName()}</b>`,
			}
		end
	end,
}

return test
