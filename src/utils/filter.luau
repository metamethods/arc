local function filter<T>(input: { [number]: T }, filterFn: (T, number) -> boolean): { T }
	local filtered = {}

	for i, v in input do
		if filterFn(v, i) then
			table.insert(filtered, v)
		end
	end

	return filtered
end

return filter
