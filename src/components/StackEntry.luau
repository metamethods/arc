local Button = require(script.Parent.Button)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local types = require(script.Parent.Parent.types)

type StackEntryProps = {
	stackEntry: types.StackEntry,
}

local function StackEntry(scope: Fusion.Scope<typeof(Fusion)>, props: StackEntryProps)
	local scope = scope:deriveScope({
		Button = Button,
	})

	return scope:Button {
		size = UDim2.fromScale(1, 0),
		text = props.stackEntry.text,
		clicked = function()
			if props.stackEntry.fn then
				props.stackEntry.fn()
			end
		end,
		outline = true,
	}
end

return StackEntry
