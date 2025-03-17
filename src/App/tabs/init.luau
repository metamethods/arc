local types = require(script.Parent.Parent.types)

return {
	{
		name = "Tests",
		component = require(script.Tests),
	},
	{
		name = "Actions",
		component = require(script.Actions),
	},
} :: { types.Tab }
