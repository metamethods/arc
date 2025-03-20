local Fusion = require(script.Parent.Parent.packages.Fusion)

type UsedAs<T> = Fusion.UsedAs<T>

local function ForKeyValues<IK, IV, TO>(
	scope: Fusion.Scope<typeof(Fusion)>,
	input: UsedAs<{ [IK]: IV }>,
	processer: (use: Fusion.Use, scope: Fusion.Scope, key: IK, value: IV) -> TO
): Fusion.Computed<{ TO }>
	return scope:Computed(function(use, scope)
		local items = {}

		for key, value in use(input) do
			table.insert(items, processer(use, scope, key, value))
		end

		return items
	end)
end

return ForKeyValues
