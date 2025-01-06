local function nullifyEmpty<T>(input: { T }): { T }?
	return if #input == 0 then nil else input
end

return nullifyEmpty
