local function isClass(instance: Instance, ...: string): boolean
	for _, className in { ... } do
		if instance:IsA(className) then
			return true
		end
	end

	return false
end

return isClass
