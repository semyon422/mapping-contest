local relations = require("rdb.relations")
local Usecase = require("http.Usecase")

---@class usecases.GetUsers: http.Usecase
---@operator call: usecases.GetUsers
local GetUsers = Usecase + {}

function GetUsers:handle(params)
	params.users = self.domain.users:getUsers()
	relations.preload(params.users, "user_roles")
	return "ok", params
end

return GetUsers
