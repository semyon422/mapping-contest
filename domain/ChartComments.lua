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

function ChartComments:canDeleteComment(user, chart_comment)
	return chart_comment.user_id == user.id
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

function ChartComments:deleteComment(user, chart_comment_id)
	local chart_comment = self.chartCommentsRepo:findById(chart_comment_id)
	if not chart_comment then
		return
	end
	if not self:canDeleteComment(user, chart_comment) then
		return
	end
	self.chartCommentsRepo:deleteById(chart_comment_id)
end

return ChartComments
