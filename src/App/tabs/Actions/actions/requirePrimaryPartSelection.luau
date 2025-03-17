local types = require(script.Parent.Parent.Parent.Parent.Parent.types)
local primaryPart = require(script.Parent.Parent.Parent.Parent.Parent.utils.primaryPart)
local requireSelection = require(script.Parent.requireSelection)

local checkFn: types.ActionCheckFn = function(selection)
	local ok, message = requireSelection(selection)

	if not ok then
		return ok, message
	end

	for _, selectedInstance in selection do
		if not primaryPart(selectedInstance) then
			return false,
				`{selectedInstance:GetFullName()} isnt a valid selection! Got instance class <b>{selectedInstance.ClassName}</b> which isnt a <b>Part/BasePart</b> or a <b>Model</b>`
		end
	end

	return true
end

return checkFn
