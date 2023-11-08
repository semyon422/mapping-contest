local enum = require("util.enum")

local Votes = {}

Votes.enum = enum({
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
