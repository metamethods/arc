local Theme = require(script.Parent.App.Theme)
local Fusion = require(script.Parent.packages.Fusion)

export type Settings = {}

export type AppScope = Fusion.Scope<typeof(Fusion) & {
	selected: Fusion.Value<{ BasePart | Model }?>,
	rawSelected: Fusion.Value<{ Instance }>,
	selectionLocked: Fusion.Value<boolean>,
	selectedSuite: Fusion.Value<SuiteType>,
	settings: Fusion.Value<Settings>,
	plugin: Plugin,
}>

export type Tab = {
	name: string,
	component: (scope: AppScope) -> Fusion.Child,
}

export type SuiteType = "general" | "rex" | "sols_rng"

export type StackEntry = {
	text: string,
	fn: () -> (),
}

export type TestResult = {
	success: boolean,
	message: string,
	overlayColor: Theme.ThemeColor?,
	stack: { StackEntry },
}

export type TestFn = (selection: { BasePart | Model }, selectedSuite: SuiteType) -> TestResult

export type TestDefinition = {
	title: string,
	description: string,
	fn: TestFn,
}

export type ActionFn = (selection: { Instance }) -> ()
export type ActionCheckFn = (selection: { Instance }) -> (boolean, string?)

export type ActionDefinition = {
	title: string,
	description: string,
	checkFn: ActionCheckFn?,
	fn: ActionFn,
}

return nil
