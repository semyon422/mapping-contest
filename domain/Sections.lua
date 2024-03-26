local class = require("class")

---@class domain.Sections
---@operator call: domain.Sections
local Sections = class()

---@param sectionsRepo domain.ISectionsRepo
function Sections:new(sectionsRepo)
	self.sectionsRepo = sectionsRepo
end

function Sections:get_max_heart_votes(charts_count)
	return math.ceil(charts_count / 6)
end

function Sections:canCreateSection(user, contest)
	return user.id == contest.host_id
end

function Sections:createSection(user, contest, _section)
	if not self:canCreateSection(user, contest) then
		return nil, "deny"
	end

	self.sectionsRepo:create(_section)
end

return Sections
