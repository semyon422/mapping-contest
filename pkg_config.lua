package.loadlib("/usr/local/opt/sqlite/lib/libsqlite3.dylib","*")

local pkg = require("aqua.pkg")

pkg.add()
pkg.add("aqua")
pkg.add("tree/share/lua/5.1")
pkg.addc("tree/lib/lua/5.1")

pkg.add(os.getenv("LJ_ROOT") .. "/share/luajit-2.1.0-beta3")
pkg.add(os.getenv("OR_ROOT") .. "/lualib")
pkg.addc(os.getenv("OR_ROOT") .. "/lualib")

pkg.add("glue")
pkg.add("minizip")

pkg.export_lua()

package.loaded.json = require("cjson")
