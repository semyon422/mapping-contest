local osu_util = require("osu_util")
local File = require("domain.File")
local Usecase = require("http.Usecase")

---@class usecases.SubmitTrack: http.Usecase
---@operator call: usecases.SubmitTrack
local SubmitTrack = Usecase + {}

function SubmitTrack:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:isContestEditable(params.session_user, params.contest)
end

function SubmitTrack:handle(params)
	self.domain.contestTracks:create(params)
	return "ok", params
end

return SubmitTrack
