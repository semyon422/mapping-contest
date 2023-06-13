local loadkit = require("loadkit")
local EtluaWidget = require("lapis.etlua").EtluaWidget

local pattern = "<!%-%- #([%w%._]*) %-%->"

local function parse_blocks(data)
	local buffers = {}
	local blocks = {}

	local pos = 1
	while true do
		local start, _end, name = data:find(pattern, pos)

		if not start then
			assert(#blocks == 0, "not enough closing tags")
			break
		end

		local chunk = data:sub(pos, start - 1)

		for _, block in ipairs(blocks) do
			buffers[block] = buffers[block] or {}
			table.insert(buffers[block], chunk)
		end

		if name ~= "" then
			table.insert(blocks, name)
		else
			assert(table.remove(blocks), "too many closing tags")
		end

		pos = _end + 1
	end

	for block, buffer in pairs(buffers) do
		buffers[block] = table.concat(buffer)
	end

	return buffers
end

local function get_widget(data, fname)
	local widget, err = EtluaWidget:load(data)
	if err then
		error("[" .. tostring(fname) .. "] " .. tostring(err))
	end
	return widget
end

local render_pattern = ([[<%
if params.use_block == "<block>" then
	render("<mod>", context)
	return _b
end
%>]]):gsub("\t", ""):gsub("\n", " ")

package.loaded["lapis.features.etlua"] = loadkit.register("etlua", function(file, mod, fname)
	local data = file:read("*a")

	local block_renders = {}

	local blocks = parse_blocks(data)
	for block, s in pairs(blocks) do
		local _mod = mod .. "#" .. block
		package.loaded[_mod] = get_widget(s, fname .. "#" .. block)
		local render = render_pattern:gsub("<block>", block):gsub("<mod>", _mod)
		table.insert(block_renders, render)
	end

	return get_widget(table.concat(block_renders) .. data, fname)
end)
