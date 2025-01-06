local function plural(count: number, suffix: string?): string
	return if count > 1 then suffix or "s" else ""
end

return plural
