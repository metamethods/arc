local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local types = require(script.Parent.Parent.Parent.Parent.Parent.types)
local moduloInclusive = require(script.Parent.Parent.Parent.Parent.Parent.utils.moduloInclusive)

local action: types.ActionDefinition = {
	title = "Shift Time",
	description = "Shifts the lighting time by 6 hours in a smooth transition",
	fn = function()
		Lighting:SetAttribute(
			"ClockTime",
			moduloInclusive((Lighting:GetAttribute("ClockTime") or Lighting.ClockTime) + 6, 24)
		)
		TweenService:Create(Lighting, TweenInfo.new(5), {
			ClockTime = Lighting:GetAttribute("ClockTime"),
		}):Play()
	end,
}

return action
