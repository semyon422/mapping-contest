local digest = require("openssl.digest")

local filehash = {}

function filehash.sum_bin(s)
	return digest.new("md5"):final(s)
end

function filehash.sum(s)
	return filehash.decode(filehash.sum_bin(s))
end

function filehash.encode(hex)
	assert(#hex == 32, "invalid length")
    return (hex:gsub("..", function(cc) return string.char(tonumber(cc, 16) or 0) end))
end

function filehash.decode(data)
	assert(#data == 16, "invalid length")
	return (data:gsub(".", function(c) return ("%02x"):format(c:byte()) end))
end

return filehash
