local function emissionBySecond(particleEmitter: ParticleEmitter): number
	return math.clamp(particleEmitter.Rate, 0, 500) * particleEmitter.TimeScale
end

return emissionBySecond
