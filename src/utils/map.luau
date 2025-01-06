local function map<TI, KI, TO>(input: { [KI]: TI }, transform: (TI, KI) -> TO): { [KI]: TO }
	local mappedTable = {}

	for k, v in input do
		mappedTable[k] = transform(v, k)
	end

	return mappedTable
end

return map
