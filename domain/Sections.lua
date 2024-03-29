local class = require("class")

---@class domain.Sections
---@operator call: domain.Sections
local Sections = class()

---@param contestsRepo domain.IContestsRepo
---@param sectionsRepo domain.ISectionsRepo
function Sections:new(contestsRepo, sectionsRepo)
	self.contestsRepo = contestsRepo
	self.sectionsRepo = sectionsRepo
end

function Sections:get_max_heart_votes(charts_count)
	return math.ceil(charts_count / 6)
end

function Sections:canCreateSection(user, contest)
	return user.id == contest.host_id
end

--[[
create_section.validate = {
	name = {"*", "string", {"#", 1, 128}},
	time_base = "number",
	time_per_knote = "number",
}
]]

function Sections:createSection(user, contest_id, _section)
	local contest = self.contestsRepo:getById(contest_id)
	if not self:canCreateSection(user, contest) then
		return nil, "deny"
	end
	self.sectionsRepo:create(_section)
end

-- UpdateSection.validate = {
-- 	name = {"*", "string", {"#", 1, 128}},
-- 	time_base = "number",
-- 	time_per_knote = "number",
-- }

function Sections:updateSection(user, contest_id, _section)
	local contest = self.contestsRepo:getById(contest_id)
	if not self:canCreateSection(user, contest) then
		return nil, "deny"
	end
	-- self.sectionsRepo:update(_section)
	-- params.section:update({
	-- 	name = params.name,
	-- 	time_base = tonumber(params.time_base) or 0,
	-- 	time_per_knote = tonumber(params.time_per_knote) or 0,
	-- })
end

function Sections:deleteSections(section_id)

end

return Sections
