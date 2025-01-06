local Fusion = require(script.Parent.Parent.packages.Fusion)

local themeColors = {
	dark = {
		accent = Color3.fromHex("#7E61FF"),
		accent_sub = Color3.fromHex("#8F7CE2"),
		background = Color3.fromHex("#111117"),
		middle = Color3.fromHex("#1F2128"),
		overlay = Color3.fromHex("#353741"),
		text = Color3.fromHex("#CFD3FA"),
		text_light = Color3.fromHex("#E9EBFF"),
		subtext = Color3.fromHex("#9B9FC0"),
		subtext_alt = Color3.fromHex("#4D4D80"),
		red = Color3.fromHex("#FF6568"),
		green = Color3.fromHex("#65FF77"),
		blue = Color3.fromHex("#6591FF"),
	},
	light = {},
}

export type ThemeColor =
	"accent"
	| "accent_sub"
	| "background"
	| "middle"
	| "overlay"
	| "text"
	| "text_light"
	| "subtext"
	| "subtext_alt"
	| "red"
	| "green"
	| "blue"

local function Theme(scope: Fusion.Scope<typeof(Fusion)>, themeColor: ThemeColor): Fusion.Computed<Color3>
	return scope:Computed(function()
		-- TODO: Add lightmode support
		return themeColors.dark[themeColor]
	end)
end

return Theme
