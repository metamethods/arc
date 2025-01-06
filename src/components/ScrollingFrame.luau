local Fusion = require(script.Parent.Parent.packages.Fusion)

local Children = Fusion.Children

type ScrollingFrameProps = {
	size: UDim2?,
	automaticSize: Enum.AutomaticSize?,
	automaticCanvasSize: Enum.AutomaticSize?,

	[typeof(Children)]: Fusion.Child,
}

local function ScrollingFrame(scope: Fusion.Scope<typeof(Fusion)>, props: ScrollingFrameProps)
	return scope:New "ScrollingFrame" {
		BackgroundTransparency = 1,
		Size = props.size,
		CanvasSize = UDim2.fromScale(0, 0),
		AutomaticSize = props.automaticSize or Enum.AutomaticSize.XY,
		AutomaticCanvasSize = props.automaticCanvasSize or Enum.AutomaticSize.Y,

		ScrollBarThickness = 0,

		[Children] = props[Children],
	}
end

return ScrollingFrame
