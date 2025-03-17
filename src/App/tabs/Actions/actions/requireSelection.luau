local types = require(script.Parent.Parent.Parent.Parent.Parent.types)

local checkFn: types.ActionCheckFn = function(selection)
	if #selection == 0 then
		return false, "Select something first!"
	end

	return true
end

return checkFn
