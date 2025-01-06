local Fusion = require(script.Parent.Parent.packages.Fusion)

type ListProps = {
	padding: UDim?,
	direction: Enum.FillDirection?,
	horizontalAlignment: Enum.HorizontalAlignment?,
	horizontalFlex: Enum.UIFlexAlignment?,
	verticalAlignment: Enum.VerticalAlignment?,
	verticalFlex: Enum.UIFlexAlignment?,
	sortOrder: Enum.SortOrder?,
	wraps: boolean?,
}

local function List(scope: Fusion.Scope<typeof(Fusion)>, props: ListProps)
	return scope:New "UIListLayout" {
		Padding = props.padding or UDim.new(0, 8),
		FillDirection = props.direction or Enum.FillDirection.Vertical,
		SortOrder = props.sortOrder or Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = props.horizontalAlignment or Enum.HorizontalAlignment.Left,
		HorizontalFlex = props.horizontalFlex,
		VerticalAlignment = props.verticalAlignment or Enum.VerticalAlignment.Top,
		VerticalFlex = props.verticalFlex,
		Wraps = props.wraps or false,
	}
end

return List
