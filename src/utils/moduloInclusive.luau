local function moduloInclusive(n: number, mod: number): number
	local result = n % mod
	return if result == 0 then mod else result
end

return moduloInclusive
