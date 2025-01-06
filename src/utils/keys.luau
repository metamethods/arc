local function keys<T>(input: { [T]: any }): { T }
	local keys = {}

	for k, _ in input do
		table.insert(keys, k)
	end

	return keys
end

return keys
