---@class html.Html
---@field [string] html.Element
local html = {}

---@class html.Element
---@operator call: html.Element
---@field __tag string
local el_mt = {}

function el_mt:__call(t)
	return setmetatable(t, {
		__index = self,
		__tostring = el_mt.__tostring,
		__call = el_mt.__call,
	})
end

local function rec_tostr(el, open_tag)
	for k, v in pairs(el) do
		if type(k) == "string" and not k:find("^__") then
			table.insert(open_tag, ("%s=%q"):format(k:gsub("_", "-"), v))
		end
	end
	local mt = getmetatable(el)
	if mt and mt.__index and mt.__index.__tag then
		rec_tostr(mt.__index, open_tag)
	end
end

function el_mt:__tostring()
	local tag = self.__tag
	local open_tag = {tag}
	local inner = {}
	for i, v in ipairs(self) do
		inner[i] = tostring(v)
	end
	rec_tostr(self, open_tag)
	return ("<%s>%s</%s>"):format(table.concat(open_tag, " "), table.concat(inner), tag)
end

local function new_el(tag_name)
	return setmetatable({__tag = tag_name}, el_mt)
end

local html_mt = {__index = function(t, k)
	return new_el(k)
end}

setmetatable(html, html_mt)

assert(tostring(html.a{href = "/", "home"}) == '<a href="/">home</a>')
assert(tostring(html.a{href = "/"}{"home"}) == '<a href="/">home</a>')

return html
