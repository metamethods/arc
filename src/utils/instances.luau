local function instances(instance: Instance): { Instance }
	local instances = instance:GetDescendants()
	table.insert(instances, instance)
	return instances
end

return instances
