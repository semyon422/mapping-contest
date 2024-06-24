require("pkg_config")

local socket = require("socket")

local luacov_runner = require("luacov.runner")
luacov_runner.init()

local testing = require("testing")

testing.blacklist = {
	".git",
	"aqua",
	"tree",
	"glue",
	"minizip",
}

testing.get_time = socket.gettime

testing.test()

local configuration = {
	reporter = "lcov",
	reportfile = "lcov.info",
	exclude = {
		"glue",
	},
	include = {},
}
debug.sethook(nil)
luacov_runner.save_stats()
luacov_runner.run_report(configuration)
