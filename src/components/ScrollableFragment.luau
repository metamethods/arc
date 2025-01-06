local Fragment = require(script.Parent.Fragment)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local ScrollingFrame = require(script.Parent.ScrollingFrame)

local Children = Fusion.Children

type ScrollableListProps = {
	size: UDim2?,
	padding: UDim?,
	automaticSize: Enum.AutomaticSize?,
	direction: Enum.FillDirection?,

	root: Fusion.Child?,
	[typeof(Children)]: Fusion.Child,
}

local function ScrollableList(scope: Fusion.Scope<typeof(Fusion)>, props: ScrollableListProps)
	local scope = scope:deriveScope({
		ScrollingFrame = ScrollingFrame,
		Fragment = Fragment,
	})

	return scope:ScrollingFrame {
		size = props.size,
		automaticSize = props.automaticSize
			or if props.direction == Enum.FillDirection.Horizontal then Enum.AutomaticSize.Y else Enum.AutomaticSize.X,
		automaticCanvasSize = if props.direction == Enum.FillDirection.Horizontal
			then Enum.AutomaticSize.X
			else Enum.AutomaticSize.Y,

		[Children] = {
			scope:Fragment {
				direction = props.direction or Enum.FillDirection.Vertical,
				padding = props.padding,

				[Children] = props[Children],
			},

			props.root,
		},
	}
end

return ScrollableList
