local zip = require("zip")

local osu_util = {}

local function parse_osu(file)
	local osu = {}
	local HitObjects = 0

	local block
	for line in file:lines() do
		if line:find("^%[") then
			block = line:match("^%[(.+)%]")
		else
			if line:find("^%a+:.*$") then
				local key, value = line:match("^(%a+):%s?(.*)")
				osu[key] = value
			elseif block == "HitObjects" and line ~= "" then
				HitObjects = HitObjects + 1
			end
		end
	end

	osu.HitObjects = HitObjects
	return osu
end

function osu_util.parse_osz(path)
	local zf, err = zip.open(path)
	if not zf then
		return nil, err
	end

	local osu = {}

	for info in zf:files() do
		if info.filename:find("%.osu$") then
			local file = zf:open(info.filename)
			osu = parse_osu(file)
			file:close()
			break
		end
	end

	zf:close()

	return osu
end

return osu_util
