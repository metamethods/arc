local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)

local function Divider(scope: Fusion.Scope<typeof(Fusion)>)
	local scope = scope:deriveScope({
		Theme = Theme,
	})

	return scope:New "Frame" {
		BackgroundColor3 = scope:Theme("overlay"),
		Size = UDim2.new(1, 0, 0, 1),
	}
end

return Divider
