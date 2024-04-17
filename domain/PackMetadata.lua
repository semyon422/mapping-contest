local class = require("class")
local Osu = require("domain.Osu")

---@class domain.PackMetadata
---@operator call: domain.PackMetadata
local PackMetadata = class()

local pack_path = "domain/pack.osu"

---@param title string
---@param creator string
---@param charts table
function PackMetadata:new(title, creator, charts)
	self.title = title
	self.creator = creator
	self.charts = charts
end

function PackMetadata:getUsersList()
	local users_map = {}
	for _, chart in ipairs(self.charts) do
		users_map[chart.charter.name] = true
	end
	local users = {}
	for user in pairs(users_map) do
		table.insert(users, user)
	end
	table.sort(users)
	return users
end

---@return string
---@return string
function PackMetadata:getFile()
	local f = assert(io.open(pack_path, "r"))
	local pack_template = f:read("*a")
	f:close()

	local osu = Osu()
	osu:decode(pack_template)

	local md = osu.sections.Metadata
	md.Title = self.title
	md.TitleUnicode = self.title
	md.Creator = self.creator
	md.Tags = table.concat(self:getUsersList(), " ")

	local filename = ("%s - %s (%s) [%s].osu"):format(md.Artist, md.Title, md.Creator, md.Version)
	local data = osu:encode()

	return filename, data
end

return PackMetadata
