local relations = require("rdb.relations")
local Usecase = require("http.Usecase")

---@class usecases.GetUser: http.Usecase
---@operator call: usecases.GetUser
local GetUser = Usecase + {}

function GetUser:handle(params)
	params.user = self.domain.users:getUser(params.user_id)
	relations.preload({params.user}, "user_roles")
	return "ok"
end

return GetUser
