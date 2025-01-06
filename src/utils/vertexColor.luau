local vertexColor = {}

function vertexColor.colorToVertex(color: Color3): Vector3
	return Vector3.new(color.R, color.G, color.B)
end

function vertexColor.vertexToColor(vertex: Vector3): Color3
	return Color3.new(vertex.X, vertex.Y, vertex.Z)
end

return vertexColor
