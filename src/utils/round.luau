local function round(input: number, decimals: number): number
	return math.round(input * 10 ^ decimals) / 10 ^ decimals
end

return round
