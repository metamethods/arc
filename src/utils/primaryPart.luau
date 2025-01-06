local function primaryPart(instance: BasePart | Model): BasePart
	if instance:IsA("Model") then
		return instance.PrimaryPart
			or instance:FindFirstChildOfClass("Part")
			or instance:FindFirstChildOfClass("UnionOperation")
			or instance:FindFirstChildOfClass("MeshPart")
	end

	return instance
end

return primaryPart
