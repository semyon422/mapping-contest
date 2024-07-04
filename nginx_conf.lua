local pkg_config = require("pkg_config")
local config = require("config")
local etlua_util = require("http.etlua_util")

local path = "nginx.conf.template"
local f = assert(io.open(path, "r"))
local conf = f:read("*a")
f:close()

local fn = etlua_util.compile(conf, path)
print(fn(config))
