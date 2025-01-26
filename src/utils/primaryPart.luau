local function primaryPart(instance: BasePart | Model, required: boolean): BasePart?
	if instance:IsA("Model") then
		return instance.PrimaryPart
			or instance:FindFirstChildOfClass("Part")
			or instance:FindFirstChildOfClass("UnionOperation")
			or instance:FindFirstChildOfClass("MeshPart")
	end

	if instance:IsA("BasePart") then
		return instance
	end

	if required then
		assert(required, `Primary Part doesn't exist for {instance:GetFullName()}`)
	end

	return
end

return primaryPart :: ((instance: BasePart | Model) -> BasePart?) & ((instance: BasePart | Model, required: boolean) -> BasePart)
