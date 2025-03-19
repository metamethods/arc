local function emission(particleEmitter: ParticleEmitter): number
	return math.clamp(particleEmitter.Rate, 0, 500)
		* ((particleEmitter.Lifetime.Min + particleEmitter.Lifetime.Max) / 2)
end

return emission
