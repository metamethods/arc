local types = require(script.Parent.Parent.Parent.Parent.types)

local tests: { [types.SuiteType]: types.TestDefinition } = {
	general = {
		require(script.descendants),
		require(script.particles),
		require(script.constrainted),
		require(script.segments),
	},
	rex = {
		require(script.descendants),
		require(script.rex.baseParts),
		require(script.particles),
		require(script.constrainted),
		require(script.rex.collisionQuery),
		require(script.segments),
	},
	sols_rng = {
		require(script.descendants),
		require(script.particles),
		require(script.constrainted),
		require(script.segments),
	},
}

return tests
