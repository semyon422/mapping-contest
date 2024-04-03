local class = require("class")
local crc32 = require("crc32")
local bit = require("bit")

---@class domain.ChartNameGenerator
---@operator call: domain.ChartNameGenerator
local ChartNameGenerator = class()

local bits = 11
local words_count = bit.lshift(1, bits)
local mask = words_count - 1
local words

function ChartNameGenerator:new()
	if words then
		return
	end
	local f = assert(io.open("domain/bip39english.txt", "r"))
	words = {}
	for line in f:lines() do
		table.insert(words, line)
	end
	f:close()
	assert(#words == words_count, #words)
end

function ChartNameGenerator:generate(data)
	local hash = crc32.hash(data)
	local index_1 = bit.band(hash, mask) + 1
	local index_2 = bit.band(bit.rshift(hash, bits), mask) + 1
	return ("%s %s"):format(words[index_1], words[index_2])
end

return ChartNameGenerator
