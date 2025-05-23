local SelectionService = game:GetService("Selection")

local Button = require(script.Parent.Parent.Parent.components.Button)
local Color = require(script.Parent.Parent.Parent.components.Color)
local Divider = require(script.Parent.Parent.Parent.components.Divider)
local ExpandableSection = require(script.Parent.Parent.Parent.components.ExpandableSection)
local Fragment = require(script.Parent.Parent.Parent.components.Fragment)
local Icon = require(script.Parent.Parent.Parent.components.Icon)
local InstancesList = require(script.Parent.Parent.Parent.components.InstancesList)
local KeyValue = require(script.Parent.Parent.Parent.components.KeyValue)
local Page = require(script.Parent.Parent.Parent.components.Page)
local Section = require(script.Parent.Parent.Parent.components.Section)
local SelectedInstances = require(script.Parent.Parent.Parent.components.SelectedInstances)
local Text = require(script.Parent.Parent.Parent.components.Text)
local TextBox = require(script.Parent.Parent.Parent.components.TextBox)
local ImageText = require(script.Parent.Parent.Parent.components.ImageText)
local Fusion = require(script.Parent.Parent.Parent.packages.Fusion)
local types = require(script.Parent.Parent.Parent.types)
local ForKeyValues = require(script.Parent.Parent.Parent.utils.ForKeyValues)
local emission = require(script.Parent.Parent.Parent.utils.emission)
local emissionBySecond = require(script.Parent.Parent.Parent.utils.emissionBySecond)
local getProperty = require(script.Parent.Parent.Parent.utils.getProperty)
local instances = require(script.Parent.Parent.Parent.utils.instances)
local round = require(script.Parent.Parent.Parent.utils.round)
local Theme = require(script.Parent.Parent.Theme)

local Children = Fusion.Children
local peek = Fusion.peek

type ComputedSelection = {
	totalInstances: number,
	totalParticleEmission: number,
	totalParticlePerSecondEmission: number,
	totalBeamSegments: number,
	instances: { [string]: number },
	colors: { [string]: Color3 },
	textures: { [string]: string },
	particleEmitters: { ParticleEmitter },
}

local function computeSelection(selection: { Instance }): ComputedSelection
	local totalInstances = 0
	local totalParticleEmission = 0
	local totalParticlePerSecondEmission = 0
	local totalBeamSegments = 0
	local particleEmitters = {}
	local instancesTable = {}
	local colors = {}
	local textures = {}

	for _, instance in selection do
		totalInstances += 1 + #instance:GetDescendants()

		for _, instance in instances(instance) do
			instancesTable[instance.ClassName] = (instancesTable[instance.ClassName] or 0) + 1

			if instance:IsA("Beam") then
				totalBeamSegments += instance.Segments
				textures[instance.Texture] = instance.Texture
			elseif instance:IsA("ParticleEmitter") then
				totalParticleEmission += emission(instance)
				totalParticlePerSecondEmission += emissionBySecond(instance)
				textures[instance.Texture] = instance.Texture
				table.insert(particleEmitters, instance)
			end

			local color: (Color3 | BrickColor | ColorSequence)? = getProperty(instance, "Color3", "Color")

			if color then
				if typeof(color) == "Color3" then
					colors[color:ToHSV()] = color
				elseif typeof(color) == "BrickColor" then
					colors[color.Color:ToHSV()] = color.Color
				elseif typeof(color) == "ColorSequence" then
					for _, keypoint in color.Keypoints do
						colors[keypoint.Value:ToHSV()] = keypoint.Value
					end
				end
			end
		end
	end

	table.sort(particleEmitters, function(a, b)
		return a.ZOffset > b.ZOffset
	end)

	return {
		totalInstances = totalInstances,
		totalParticleEmission = totalParticleEmission,
		totalParticlePerSecondEmission = totalParticlePerSecondEmission,
		totalBeamSegments = totalBeamSegments,
		instances = instancesTable,
		colors = colors,
		textures = textures,
		particleEmitters = particleEmitters,
	}
end

local function Selection(scope: types.AppScope)
	local scope = scope:deriveScope({
		Page = Page,
		InstancesList = InstancesList,
		ExpandableSection = ExpandableSection,
		SelectedInstances = SelectedInstances,
		Section = Section,
		ImageText = ImageText,
		Icon = Icon,
		Color = Color,
		Button = Button,
		Divider = Divider,
		Fragment = Fragment,
		KeyValue = KeyValue,
		TextBox = TextBox,
		Text = Text,
		Theme = Theme,
		ForKeyValues = ForKeyValues,
	})

	local computedSelection: Fusion.Value<ComputedSelection?> = scope:Value()

	return scope:Page {
		[Children] = {
			scope:SelectedInstances {
				selected = scope.rawSelected,
			},

			scope:Button {
				text = "Compute",
				primary = true,
				size = UDim2.fromScale(1, 0),
				textXAlignment = Enum.TextXAlignment.Center,
				disabled = scope:Computed(function(use)
					return #use(scope.rawSelected) == 0
				end),
				clicked = function()
					computedSelection:set(computeSelection(peek(scope.rawSelected)))
				end,
			},

			scope:Divider(),

			scope:Computed(function(use, scope: typeof(scope))
				local computedSelection = use(computedSelection)

				if not computedSelection then
					return scope:Text {
						text = "<i>Nothing to show yet</i>",
						textColor = scope:Theme("subtext"),
					}
				end

				return scope:Fragment {
					[Children] = {
						scope:Section {
							header = scope:Text {
								text = "Instances",
								fontWeight = Enum.FontWeight.Bold,
							},
							[Children] = scope:Fragment {
								[Children] = {
									scope:KeyValue {
										key = "Total Instances",
										value = computedSelection.totalInstances,
									},

									scope:KeyValue {
										key = "Total Attachments",
										value = computedSelection.instances["Attachment"] or 0,
									},
								},
							},
						},

						scope:Section {
							header = scope:Fragment {
								padding = UDim.new(0, 0),
								[Children] = {
									scope:Text {
										text = "Concurrent Particles",
										fontWeight = Enum.FontWeight.Bold,
									},
									scope:Text {
										text = "Concurrent amount of particles shown at a time in the average lifetime defined for a particle emitter (min + max) / 2",
										textColor = scope:Theme("subtext"),
									},
								},
							},
							[Children] = scope:Fragment {
								[Children] = {
									scope:KeyValue {
										key = "Total",
										value = round(computedSelection.totalParticleEmission, 2),
									},
									scope:KeyValue {
										key = "Per Emitter",
										value = `{round(
											computedSelection.totalParticleEmission
												/ (computedSelection.instances["ParticleEmitter"] or 0),
											2
										)}/emitter`,
									},
								},
							},
						},

						scope:Section {
							header = scope:Text {
								text = "Particles per Second",
								fontWeight = Enum.FontWeight.Bold,
							},
							[Children] = scope:Fragment {
								[Children] = {
									scope:KeyValue {
										key = "Total/s",
										value = `{round(computedSelection.totalParticlePerSecondEmission, 2)}/s`,
									},
									scope:KeyValue {
										key = "Total Per Emitter/s",
										value = `{round(
											computedSelection.totalParticlePerSecondEmission
												/ (computedSelection.instances["ParticleEmitter"] or 0),
											2
										)}/s/emitter`,
									},
								},
							},
						},

						scope:Section {
							header = scope:Text {
								text = "Beam Segments",
								fontWeight = Enum.FontWeight.Bold,
							},
							[Children] = scope:Fragment {
								[Children] = {
									scope:KeyValue {
										key = "Total",
										value = computedSelection.totalBeamSegments,
									},
									scope:KeyValue {
										key = "Per Beam",
										value = `{round(
											computedSelection.totalBeamSegments
												/ (computedSelection.instances["Beam"] or 0),
											2
										)}/beam`,
									},
								},
							},
						},

						scope:ExpandableSection {
							open = scope:Value(false),
							title = "Instances",
							[Children] = scope:Fragment {
								sortOrder = Enum.SortOrder.LayoutOrder,

								[Children] = scope:ForKeyValues(
									computedSelection.instances,
									function(_, scope: typeof(scope), className, count)
										return scope:Fragment {
											padding = UDim.new(0, 4),
											direction = Enum.FillDirection.Horizontal,
											verticalAlignment = Enum.VerticalAlignment.Center,
											layoutOrder = -count, -- high -> low

											[Children] = {
												scope:Icon {
													imageId = 104624195613642,
												},

												scope:KeyValue {
													key = className,
													value = count,
													valueBackground = scope:Theme("overlay"),
												},
											},
										}
									end
								),
							},
						},

						scope:ExpandableSection {
							open = scope:Value(false),
							title = "Colors",
							[Children] = scope:ForValues(
								computedSelection.colors,
								function(_, scope: typeof(scope), color)
									return scope:Color {
										color = color,
									}
								end
							),
						},

						scope:ExpandableSection {
							open = scope:Value(false),
							title = "Textures",
							[Children] = scope:Fragment {
								direction = Enum.FillDirection.Horizontal,
								wraps = true,
								padding = UDim.new(0, 8),

								[Children] = scope:ForValues(
									computedSelection.textures,
									function(_, scope: typeof(scope), texture)
										return scope:ImageText {
											image = texture,
											text = texture,
											textAlignment = Enum.TextXAlignment.Right,
											backgroundColor = scope:Theme("background"),
										}
									end
								),
							},
						},

						scope:ExpandableSection {
							open = scope:Value(false),
							title = "Z-Offsets",
							[Children] = scope:Fragment {
								direction = Enum.FillDirection.Horizontal,
								wraps = true,
								padding = UDim.new(0, 8),

								[Children] = scope:ForValues(
									computedSelection.particleEmitters,
									function(_, scope: typeof(scope), emitter)
										return scope:ImageText {
											image = emitter.Texture,
											text = `ZOffset: {emitter.ZOffset}`,
											backgroundColor = scope:Theme("background"),
											[Children] = scope:Button {
												backgroundColor = scope:Theme("background"),
												text = "Goto",
												clicked = function()
													SelectionService:Set({ emitter })
												end,
											},
										}
									end
								),
							},
						},
					},
				}
			end),
		},
	}
end

return Selection
