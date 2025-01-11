local LinkList = {}
LinkList.__index = LinkList

function LinkList.new<T>(): LinkList<T>
	return setmetatable({
		links = {},
		cache = {},
	}, LinkList) :: LinkList<T>
end

function LinkList.fromConnectors(connectors: { Constraint | WeldConstraint | Weld }): LinkList<BasePart>
	local linkList = LinkList.new()

	for _, connector in connectors do
		if connector:IsA("WeldConstraint") or connector:IsA("Motor6D") or connector:IsA("Weld") then
			if not connector.Active or not connector.Enabled then
				continue
			end

			linkList:add(connector.Part0, connector.Part1)
		end

		if connector:IsA("Constraint") then
			if not connector.Enabled then
				continue
			end

			if not connector.Attachment0 or not connector.Attachment1 then
				continue
			end

			linkList:add(
				connector.Attachment0:FindFirstAncestorWhichIsA("BasePart"),
				connector.Attachment1:FindFirstAncestorWhichIsA("BasePart")
			)
		end
	end

	return linkList
end

function LinkList.add<T>(self: LinkList<T>, link0: T, link1: T)
	table.insert(self.links, {
		link0 = link0,
		link1 = link1,
	})
end

function LinkList.findConnections<T>(self: LinkList<T>, from: T): { Link<T> }
	local links = {}

	for _, link in self.links do
		if link.link0 == from or link.link1 == from then
			table.insert(links, link)
		end
	end

	return links
end

function LinkList.linkedTo<T>(
	self: LinkList<T>,
	start: T,
	target: T,
	check: CheckFn<T>?,
	visited: { [T]: boolean }?
): boolean
	local visited = visited or {}
	local check = check or function(item, target)
		return item == target
	end

	if self.cache[start] then
		return self.cache[start]
	end
	if visited[start] then
		return false
	end
	visited[start] = true

	for _, link in self:findConnections(start) do
		if check(link.link0, target) or check(link.link1, target) then
			self.cache[start] = true
			return true
		end

		if
			(link.link0 ~= start and self:linkedTo(link.link0, target, check, visited))
			or (link.link1 ~= start and self:linkedTo(link.link1, target, check, visited))
		then
			self.cache[start] = true
			return true
		end
	end

	self.cache[start] = false
	return false
end

type CheckFn<T> = (item: T, target: T) -> boolean?

type Link<T> = {
	link0: T,
	link1: T,
}

export type LinkList<T> = typeof(setmetatable(
	{} :: {
		links: { Link<T> },
		cache: { [T]: boolean },
	},
	LinkList
))

return LinkList
