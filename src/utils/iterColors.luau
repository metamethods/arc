local getProperty = require(script.Parent.getProperty)
local isClass = require(script.Parent.isClass)
local vertexColor = require(script.Parent.vertexColor)

local function iterColors(instances: { Instance }, transform: (color: Color3, instance: Instance) -> Color3)
	for _, instance in instances do
		if instance:IsA("DataModelMesh") then -- Includes SpecialMesh and BlockMesh (Character Mesh doesn't have a vertex color property)
			instance.VertexColor =
				vertexColor.colorToVertex(transform(vertexColor.vertexToColor(instance.VertexColor), instance))
		elseif instance:IsA("Color3Value") then
			instance.Value = transform(instance.Value, instance)
		elseif isClass(instance, "Beam", "Trail", "ParticleEmitter") then
			local transformedKeypoints = {}
			for i, keypoint in (instance :: Beam | Trail | ParticleEmitter).Color.Keypoints do
				transformedKeypoints[i] = ColorSequenceKeypoint.new(keypoint.Time, transform(keypoint.Value, instance))
			end
			instance.Color = ColorSequence.new(transformedKeypoints)
		elseif instance:IsA("Highlight") then
			instance.FillColor = transform(instance.FillColor, instance)
			instance.OutlineColor = transform(instance.OutlineColor, instance)
		else -- If the instance has a color property it'll automatically be transformed by the transform function
			local color: Color3? = (getProperty(instance, "Color") and typeof(instance.Color) == "Color3")
					and instance.Color
				or getProperty(instance, "Color3")
			if not color then
				continue
			end

			local transformedColor = transform(color, instance)

			if getProperty(instance, "Color") and typeof(instance.Color) == "Color3" then
				instance.Color = transformedColor
			else
				instance.Color3 = transformedColor
			end
		end
	end
end

return iterColors
