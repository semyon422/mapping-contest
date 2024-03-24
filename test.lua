require("pkg_config")

local socket = require("socket")

local luacov_runner = require("luacov.runner")
luacov_runner.init()

local testing = require("testing")

testing.blacklist = {
	".git",
	"aqua",
	"tree",
}

testing.get_time = socket.gettime

testing.test()
