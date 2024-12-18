local relations = require("rdb.relations")
local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.GetUsers: web.Usecase
---@operator call: usecases.GetUsers
local GetUsers = Usecase + {}

function GetUsers:handle(params)
	params.users = self.domain.users:getUsers()
	relations.preload(params.users, "user_roles")
	return "ok"
end

return GetUsers
