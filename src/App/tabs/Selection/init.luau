local Button = require(script.Parent.Parent.Parent.components.Button)
local Color = require(script.Parent.Parent.Parent.components.Color)
local Divider = require(script.Parent.Parent.Parent.components.Divider)
local ExpandableSection = require(script.Parent.Parent.Parent.components.ExpandableSection)
local Fragment = require(script.Parent.Parent.Parent.components.Fragment)
local InstancesList = require(script.Parent.Parent.Parent.components.InstancesList)
local KeyValue = require(script.Parent.Parent.Parent.components.KeyValue)
local Page = require(script.Parent.Parent.Parent.components.Page)
local Text = require(script.Parent.Parent.Parent.components.Text)
local Fusion = require(script.Parent.Parent.Parent.packages.Fusion)
local types = require(script.Parent.Parent.Parent.types)
local emission = require(script.Parent.Parent.Parent.utils.emission)
local getProperty = require(script.Parent.Parent.Parent.utils.getProperty)
local instances = require(script.Parent.Parent.Parent.utils.instances)
local plural = require(script.Parent.Parent.Parent.utils.plural)
local round = require(script.Parent.Parent.Parent.utils.round)
local Theme = require(script.Parent.Parent.Theme)

local MAX_COLORS = 400 -- prevent lag LOL

local Children = Fusion.Children

local peek = Fusion.peek

type SelectionInfo = {
	totalInstances: number,
	totalParticleEmission: number,
	totalBeamSegments: number,
	instances: { [string]: number },
	colors: { [string]: Color3 },
}

local function Selection(scope: types.AppScope)
	local scope = scope:deriveScope({
		Page = Page,
		InstancesList = InstancesList,
		ExpandableSection = ExpandableSection,
		Color = Color,
		Button = Button,
		Divider = Divider,
		Fragment = Fragment,
		KeyValue = KeyValue,
		Text = Text,
		Theme = Theme,
	})

	local selectionInfo: Fusion.Value<SelectionInfo?> = scope:Value()

	return scope:Page {
		[Children] = {
			scope:Fragment {
				padding = UDim.new(0, 4),

				[Children] = {
					scope:Text {
						text = scope:Computed(function(use)
							return `Selected instance{plural(#use(scope.rawSelected))}`
						end),
						fontWeight = Enum.FontWeight.Bold,
					},

					scope:Fragment {
						padding = UDim.new(0, 4),

						[Children] = scope:InstancesList {
							instances = scope.rawSelected,
						},
					},
				},
			},

			scope:Button {
				text = "Calculate",
				primary = true,
				size = UDim2.fromScale(1, 0),
				textXAlignment = Enum.TextXAlignment.Center,
				disabled = scope:Computed(function(use)
					return #use(scope.rawSelected) == 0
				end),
				clicked = function()
					local totalInstances = 0
					local totalParticleEmission = 0
					local totalBeamSegments = 0
					local instancesTable = {}
					local colors = {}

					for _, instance in peek(scope.rawSelected) do
						totalInstances += 1 + #instance:GetDescendants()

						for _, instance in instances(instance) do
							instancesTable[instance.ClassName] = (instancesTable[instance.ClassName] or 0) + 1

							if instance:IsA("Beam") then
								totalBeamSegments += instance.Segments
							elseif instance:IsA("ParticleEmitter") then
								totalParticleEmission += emission(instance)
							end

							local color: (Color3 | BrickColor | ColorSequence)? =
								getProperty(instance, "Color3", "Color")

							if color then
								if typeof(color) == "Color3" then
									colors[color:ToHSV()] = color
								elseif typeof(color) == "BrickColor" then
									colors[color.Color:ToHSV()] = color.Color
								else
									for _, keypoint in color.Keypoints do
										colors[keypoint.Value:ToHSV()] = keypoint.Value
									end
								end
							end
						end
					end

					selectionInfo:set({
						totalInstances = totalInstances,
						totalParticleEmission = totalParticleEmission,
						totalBeamSegments = totalBeamSegments,
						instances = instancesTable,
						colors = colors,
					})
				end,
			},

			scope:Divider(),

			scope:Computed(function(use, scope: typeof(scope))
				local selectionInfo = use(selectionInfo)

				if not selectionInfo then
					return scope:Text {
						text = "<i>Nothing to show yet</i>",
						textColor = scope:Theme("subtext"),
					}
				end

				return scope:Fragment {
					[Children] = {
						scope:KeyValue {
							key = "Total Instances",
							value = selectionInfo.totalInstances,
						},

						scope:KeyValue {
							key = "Total Attachments",
							value = selectionInfo.instances["Attachment"] or 0,
						},

						scope:Fragment {
							direction = Enum.FillDirection.Horizontal,
							wraps = true,
							[Children] = {
								scope:KeyValue {
									key = "Total Particles/s",
									value = `{round(selectionInfo.totalParticleEmission, 2)}/s`,
								},
								scope:KeyValue {
									key = "Average Particles/s",
									value = `{round(
										selectionInfo.totalParticleEmission
											/ (selectionInfo.instances["ParticleEmitter"] or 0),
										2
									)}/a`,
								},
							},
						},

						scope:Fragment {
							direction = Enum.FillDirection.Horizontal,
							wraps = true,
							[Children] = {
								scope:KeyValue {
									key = "Total Beam Segments",
									value = `{selectionInfo.totalBeamSegments}/s`,
								},
								scope:KeyValue {
									key = "Average Beam Segements",
									value = `{round(
										selectionInfo.totalBeamSegments / (selectionInfo.instances["Beam"] or 0),
										2
									)}/a`,
								},
							},
						},

						scope:ExpandableSection {
							open = scope:Value(false),
							title = "Instances",
							[Children] = scope:Fragment {
								sortOrder = Enum.SortOrder.LayoutOrder,

								[Children] = scope:Computed(function(use, scope: typeof(scope))
									local components = {}

									for className, count in use(selectionInfo.instances) do
										table.insert(
											components,
											scope:Fragment {
												padding = UDim.new(0, 4),
												direction = Enum.FillDirection.Horizontal,
												verticalAlignment = Enum.VerticalAlignment.Center,
												layoutOrder = -count, -- high -> low

												[Children] = {
													scope:New "ImageLabel" {
														Size = UDim2.fromOffset(16, 16),
														BackgroundTransparency = 1,

														Image = "rbxassetid://104624195613642",
														ImageColor3 = scope:Theme("text"),
													},

													scope:KeyValue {
														key = className,
														value = count,
														valueBackground = scope:Theme("overlay"),
													},
												},
											}
										)
									end

									return components
								end),
							},
						},

						scope:ExpandableSection {
							open = scope:Value(false),
							title = "Colors",
							[Children] = scope:Computed(function(use, scope: typeof(scope))
								local colors = use(selectionInfo.colors)
								local components = {}

								for _, color in colors do
									if #components == MAX_COLORS then
										table.insert(
											components,
											scope:Text {
												text = `...<i>(to prevent lag, we only show the first {MAX_COLORS} colors)</i>`,
												textColor = scope:Theme("subtext"),
											}
										)
										break
									end

									table.insert(
										components,
										scope:Color {
											color = color,
										}
									)
								end

								return scope:Fragment {
									[Children] = components,
								}
							end),
						},
					},
				}
			end),
		},
	}
end

return Selection
