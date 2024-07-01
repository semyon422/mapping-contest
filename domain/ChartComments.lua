local class = require("class")
local Errors = require("domain.Errors")

---@class domain.ChartComments
---@operator call: domain.ChartComments
local ChartComments = class()

---@param chartCommentsRepo domain.IChartCommentsRepo
---@param roles domain.Roles
function ChartComments:new(chartCommentsRepo, roles)
	self.chartCommentsRepo = chartCommentsRepo
	self.roles = roles
end

function ChartComments:canCreateComment(user)
	return true
end

function ChartComments:createComment(user, chart_id, text)
	if not self:canCreateComment(user) then
		return
	end

	local chart_comment = self.chartCommentsRepo:create({
		chart_id = assert(chart_id),
		user_id = assert(user.id),
		text = text,
		created_at = os.time(),
	})

	return chart_comment
end

return ChartComments
