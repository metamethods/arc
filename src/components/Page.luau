local Fusion = require(script.Parent.Parent.packages.Fusion)
local ScrollableFragment = require(script.Parent.ScrollableFragment)

local Children = Fusion.Children

type PageProps = {
	[typeof(Children)]: Fusion.Child,
}

local function Page(scope: Fusion.Scope<typeof(Fusion)>, props: PageProps)
	local scope = scope:deriveScope({
		ScrollableFragment = ScrollableFragment,
	})

	return scope:ScrollableFragment {
		size = UDim2.fromScale(1, 1),
		padding = UDim.new(0, 8),

		[Children] = props[Children],
	}
end

return Page
