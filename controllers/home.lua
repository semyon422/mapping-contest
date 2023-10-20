local Sections = require("enums.sections")

local home_c = {}

function home_c.GET(self)
	self.ctx.Sections = Sections
	return {render = true}
end

return home_c
