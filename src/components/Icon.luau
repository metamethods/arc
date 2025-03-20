local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)

type UsedAs<T> = Fusion.UsedAs<T>

export type IconProps = {
	imageId: number,
	size: UDim2?,
	color: UsedAs<Color3>?,
}

local function Icon(scope: Fusion.Scope<typeof(Fusion)>, props: IconProps)
	local scope = scope:deriveScope({
		Theme = Theme,
	})

	return scope:New "ImageLabel" {
		Size = props.size or UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1,

		Image = `rbxassetid://{props.imageId}`,
		ImageColor3 = props.color or scope:Theme("text"),
	}
end

return Icon
