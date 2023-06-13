local enum = require("lapis.db.model").enum

local Votes = enum({
	yes = 0,
	no = 1,
	heart = 2,
})

Votes.list = {
	"yes",
	"no",
	"heart",
}

return Votes
