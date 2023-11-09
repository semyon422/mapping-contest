local resty_upload = require("resty.upload")
local resty_md5 = require("resty.md5")
local resty_string = require("resty.string")

local attachment_name = "file"
return function(content_type)
	if not content_type or not content_type:find("^multipart") then
		ngx.log(ngx.ERR, content_type)
		return
	end
	local form, err = resty_upload:new(4096)
	if not form then
		ngx.log(ngx.ERR, err)
		return
	end

	form:set_timeout(1000)

	local headers = {}
	local filename
	local file
	local tmpname = "temp/" .. os.tmpname():match("/([^/]+)$")
	local hash = resty_md5:new()
	local size = 0

	while true do
		local typ, res, err = form:read()
		if not typ then
			ngx.log(ngx.ERR, err)
			return
		end
		if typ == "header" then
			local k, v = unpack(res)
			headers[k] = v
			if k == "Content-Disposition" then
				local name = v:match(";%s*name=\"([^\"]+)\"")
				filename = v:match(";%s*filename=\"([^\"]+)\"")
				if name ~= attachment_name or not filename then
					return
				end

				file = io.open(tmpname, "wb")
				if not file then
					return
				end
			end
		elseif typ == "body" then
			file:write(res)
			hash:update(res)
			size = size + #res
		elseif typ == "part_end" then
			file:close()
			local _hash = hash:final()
			if not _hash then return end
			return {[attachment_name] = {
				tmpname = tmpname,
				filename = filename,
				hash = resty_string.to_hex(_hash),
				size = size,
			}}
		elseif typ == "eof" then
			break
		else
			-- do nothing
		end
	end
end
