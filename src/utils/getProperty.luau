local function getProperty(instance: Instance, ...: string): any?
	for _, property in { ... } do
		local ok, value = pcall(function()
			return instance[property]
		end)
		if ok then
			return value
		end
	end

	return nil
end

return getProperty
