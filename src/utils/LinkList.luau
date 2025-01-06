local LinkList = {}
LinkList.__index = LinkList

function LinkList.new<T>(): LinkList<T>
	return setmetatable({
		links = {},
		cache = {},
	}, LinkList) :: LinkList<T>
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

function LinkList.linkedTo<T>(self: LinkList<T>, start: T, target: T, visited: { [T]: boolean }?): boolean
	local visited = visited or {}

	if self.cache[start] then
		return self.cache[start]
	end
	if visited[start] then
		return false
	end
	visited[start] = true

	for _, link in self:findConnections(start) do
		if link.link0 == target or link.link1 == target then
			self.cache[start] = true
			return true
		end

		if
			(link.link0 ~= start and self:linkedTo(link.link0, target, visited))
			or (link.link1 ~= start and self:linkedTo(link.link1, target, visited))
		then
			self.cache[start] = true
			return true
		end
	end

	self.cache[start] = false
	return false
end

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
