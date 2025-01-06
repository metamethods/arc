local List = require(script.Parent.List)
local Fusion = require(script.Parent.Parent.packages.Fusion)

local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

type FragmentProps = {
	size: UsedAs<UDim2>?,
	automaticSize: UsedAs<Enum.AutomaticSize>?,
	padding: UDim?,
	direction: Enum.FillDirection?,
	horizontalAlignment: Enum.HorizontalAlignment?,
	verticalAlignment: Enum.VerticalAlignment?,
	sortOrder: Enum.SortOrder?,
	wraps: boolean?,
	layoutOrder: UsedAs<number>?,
	visible: UsedAs<boolean>?,
	[typeof(Children)]: Fusion.Child,
}

local function Fragment(scope: Fusion.Scope<typeof(Fusion)>, props: FragmentProps)
	local scope = scope:deriveScope({
		List = List,
	})

	return scope:New "Frame" {
		BackgroundTransparency = 1,
		Size = props.size or UDim2.fromScale(1, 0),
		AutomaticSize = props.automaticSize or Enum.AutomaticSize.Y,
		LayoutOrder = props.layoutOrder or 0,
		Visible = props.visible,

		[Children] = {
			scope:List {
				padding = props.padding,
				direction = props.direction,
				horizontalAlignment = props.horizontalAlignment,
				verticalAlignment = props.verticalAlignment,
				sortOrder = props.sortOrder,
				wraps = props.wraps,
			},

			props[Children],
		},
	}
end

return Fragment
