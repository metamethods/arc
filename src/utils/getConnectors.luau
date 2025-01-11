local instances = require(script.Parent.instances)

local function getConnectors(baseInstance: Instance): { Constraint | WeldConstraint | Weld }
	local connectors = {}

	for _, connector in instances(baseInstance) do
		if
			connector:IsA("WeldConstraint")
			or connector:IsA("Motor6D")
			or connector:IsA("Weld")
			or connector:IsA("Constraint")
		then
			table.insert(connectors, connector)
		end
	end

	return connectors
end

return getConnectors
