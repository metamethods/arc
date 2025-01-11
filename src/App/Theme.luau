local Fusion = require(script.Parent.Parent.packages.Fusion)

local scoped = Fusion.scoped

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
	light = {
		accent = Color3.fromHex("#856DEE"),
		accent_sub = Color3.fromHex("#7058DB"),
		background = Color3.fromHex("#FFFFFF"),
		middle = Color3.fromHex("#E1E0F8"),
		overlay = Color3.fromHex("#9092AD"),
		text = Color3.fromHex("#3D3D4E"),
		text_light = Color3.fromHex("#242538"),
		subtext = Color3.fromHex("#63667E"),
		subtext_alt = Color3.fromHex("#51517A"),
		red = Color3.fromHex("#D84B4D"),
		green = Color3.fromHex("#44CE54"),
		blue = Color3.fromHex("#4F76D8"),
	},
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

local scope = scoped({ Value = Fusion.Value })

local studio = settings():GetService("Studio")
local studioTheme: Fusion.Value<"light" | "dark"> = scope:Value(studio.Theme.Name:lower())

table.insert(scope, {
	studio.ThemeChanged:Connect(function()
		studioTheme:set(studio.Theme.Name:lower())
	end),
})

local function Theme(scope: Fusion.Scope<typeof(Fusion)>, themeColor: ThemeColor): Fusion.Computed<Color3>
	return scope:Computed(function(use)
		return themeColors[use(studioTheme)][themeColor]
	end)
end

return Theme
