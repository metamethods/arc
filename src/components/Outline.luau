local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)

type UsedAs<T> = Fusion.UsedAs<T>

type OutlineProps = {
	thickness: UsedAs<number>?,
	color: UsedAs<Color3>?,
	mode: Enum.ApplyStrokeMode?,
}

local function Outline(scope: Fusion.Scope<typeof(Fusion)>, props: OutlineProps)
	local scope = scope:deriveScope({
		Theme = Theme,
	})

	return scope:New "UIStroke" {
		ApplyStrokeMode = props.mode or Enum.ApplyStrokeMode.Border,
		Color = props.color or scope:Theme("overlay"),
		Thickness = props.thickness or 1,
	}
end

return Outline
