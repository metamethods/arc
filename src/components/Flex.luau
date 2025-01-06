local Fusion = require(script.Parent.Parent.packages.Fusion)

local function Flex(scope: Fusion.Scope<typeof(Fusion)>)
	return scope:New "UIFlexItem" {}
end

return Flex
