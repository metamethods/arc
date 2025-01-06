local function getProperty(instance: Instance, name: string): any?
	local ok, value = pcall(function()
		return instance[name]
	end)

	if ok then
		return value
	end

	return
end

return getProperty
