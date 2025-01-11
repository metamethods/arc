local types = require(script.Parent.Parent.Parent.Parent.types)

local actions: { [types.SuiteType]: types.ActionDefinition } = {
	general = {
		require(script.randomizeColor),
		require(script.randomizeColors),
		require(script.randomizeHueShift),
		require(script.rainbow),
		require(script.shiftTime),
		require(script.smartWelder),
	},
	rex = {
		require(script.rex.ionize),
		require(script.rex.spectralize),
		require(script.randomizeColor),
		require(script.randomizeColors),
		require(script.randomizeHueShift),
		require(script.rainbow),
		require(script.shiftTime),
		require(script.smartWelder),
		require(script.rex.prepare),
	},
	sols_rng = {
		require(script.randomizeColor),
		require(script.randomizeColors),
		require(script.randomizeHueShift),
		require(script.rainbow),
		require(script.shiftTime),
		require(script.smartWelder),
	},
}

return actions
