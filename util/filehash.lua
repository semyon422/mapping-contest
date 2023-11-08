
local filehash = {}

function filehash.sum_bin(s)
	return ngx.md5_bin(s)
end

function filehash.sum(s)
	return ngx.md5(s)
end

function filehash.encode(hex)
	if #hex == 16 then
		return hex
	end
    return (hex:gsub("..", function(cc) return string.char(tonumber(cc, 16) or 0) end))
end

function filehash.decode(data)
	if #data == 32 then
		return data
	end
	return (data:gsub(".", function(c) return ("%02x"):format(c:byte()) end))
end

return filehash
