local Fusion = require(script.Parent.Parent.packages.Fusion)

type UsedAs<T> = Fusion.UsedAs<T>

local function Rounded(scope: Fusion.Scope<typeof(Fusion)>, radius: UDim?)
	return scope:New "UICorner" {
		CornerRadius = radius or UDim.new(0, 8),
	}
end

return Rounded
