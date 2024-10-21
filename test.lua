require("pkg_config")

local socket = require("socket")

local luacov_runner = require("luacov.runner")
luacov_runner.init()

local Testing = require("testing.Testing")
local BaseTestingIO = require("testing.BaseTestingIO")

local tio = BaseTestingIO()
tio.blacklist = {
	".git",
	-- "aqua",
	"tree",
	"glue",
	"minizip",
}

function tio:getTime()
	return socket.gettime()
end

local testing = Testing(tio)

local file_pattern, method_pattern = arg[3], arg[4]
testing:test(file_pattern, method_pattern)

debug.sethook(nil)
luacov_runner.save_stats()
require("luacov.reporter.lcov").report()
