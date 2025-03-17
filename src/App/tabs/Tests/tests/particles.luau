local types = require(script.Parent.Parent.Parent.Parent.Parent.types)
local emission = require(script.Parent.Parent.Parent.Parent.Parent.utils.emission)
local round = require(script.Parent.Parent.Parent.Parent.Parent.utils.round)

local MAX_PARTICLE_EMISSION = 8_000

local testDefinition: types.TestDefinition = {
	title = "Particles",
	description = `Checks if the total emission of selected instance(s) is <b>under {MAX_PARTICLE_EMISSION}/s</b>`,
	fn = function(selection)
		local totalParticleEmission = 0

		for _, selectedInstance in selection do
			for _, instance in selectedInstance:GetDescendants() do
				if not instance:IsA("ParticleEmitter") or not instance.Enabled then
					continue
				end
				totalParticleEmission += emission(instance)
			end
		end

		if totalParticleEmission <= MAX_PARTICLE_EMISSION then
			return {
				success = true,
				message = `Current emitting <b>{round(totalParticleEmission, 2)}/s</b>`,
			}
		else
			return {
				success = false,
				message = `Current emitting <b>{round(totalParticleEmission, 2)}/s</b> which is greater than <b>{MAX_PARTICLE_EMISSION}</b>`,
			}
		end
	end,
}

return testDefinition
