local Usecase = require("http.Usecase")

---@class usecases.DeleteComment: http.Usecase
---@operator call: usecases.DeleteComment
local DeleteComment = Usecase + {}

function DeleteComment:handle(params)
	self.domain.chartComments:deleteComment(
		params.session_user,
		tonumber(params.chart_comment_id)
	)
	return "ok"
end

return DeleteComment
