local Usecase = require("http.Usecase")

---@class usecases.CreateComment: http.Usecase
---@operator call: usecases.CreateComment
local CreateComment = Usecase + {}

function CreateComment:handle(params)
	local chart_comment, err = self.domain.chartComments:createComment(
		params.session_user,
		tonumber(params.chart_id),
		params.text
	)
	assert(chart_comment)
	return "ok"
end

return CreateComment
