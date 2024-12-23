local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.SubmitTrack: web.Usecase
---@operator call: usecases.SubmitTrack
local SubmitTrack = Usecase + {}

function SubmitTrack:handle(params)
	local file = params.file
	local track = self.domain.tracks:create(params.session_user, file, params.contest_id)
	if not track then
		assert(os.remove(file.path))
	end
	return "ok"
end

return SubmitTrack
