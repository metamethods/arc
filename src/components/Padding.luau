local Fusion = require(script.Parent.Parent.packages.Fusion)

type UsedAs<T> = Fusion.UsedAs<T>

local function Padding(
	scope: Fusion.Scope<typeof(Fusion)>,
	paddingTop: UsedAs<UDim>,
	paddingLeft: UsedAs<UDim>?,
	paddingBottom: UsedAs<UDim>?,
	paddingRight: UsedAs<UDim>?
)
	return scope:New "UIPadding" {
		PaddingTop = paddingTop,
		PaddingLeft = paddingLeft or paddingTop,
		PaddingBottom = paddingBottom or paddingTop,
		PaddingRight = paddingRight or paddingLeft or paddingTop,
	}
end

return Padding
