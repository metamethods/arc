local function setProperty(instance: Instance, property: string, value: any): boolean
	return (pcall(function()
		instance[property] = value
	end))
end

return setProperty
