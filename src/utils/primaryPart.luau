local function primaryPart(instance: BasePart | Model): BasePart?
	if instance:IsA("Model") then
		return instance.PrimaryPart
			or instance:FindFirstChildOfClass("Part")
			or instance:FindFirstChildOfClass("UnionOperation")
			or instance:FindFirstChildOfClass("MeshPart")
	end

	if instance:IsA("BasePart") then
		return instance
	end

	return
end

return primaryPart
