local class = require("class")
local lapis_util = require("lapis.util")
local schema = require("lapis.db.schema")
local lapis_db = require("lapis.db")
local Model = require("lapis.db.model").Model
local types = schema.types
local singularize = lapis_util.singularize

local Appstruct = class()

local function includes(t, v)
	for _, _v in ipairs(t) do
		if _v == v then
			return true
		end
	end
end

local function exclude(t, v)
	local _t = {}
	for _, _v in ipairs(t) do
		if _v ~= v then
			table.insert(_t, _v)
		end
	end
	return _t
end

local function singularize_except_last(t)
	local _t = {}
	for i, _v in ipairs(t) do
		if i ~= #t then
			_v = singularize(_v)
		end
		table.insert(_t, _v)
	end
	return _t
end

function Appstruct:get_key_name(res, parent)
	local p = self.custom_keys[parent] and self.custom_keys[parent][res]
	if p then
		return p
	end
	if includes(self.enums, res) then
		return singularize(res)
	end
	return singularize(res) .. "_id"
end

function Appstruct:get_above(name)
	local out = {}
	for _, res in ipairs(self.primary) do
		local _name, list = next(res)
		if includes(list, name) then
			table.insert(out, _name)
		end
	end

	local enums = self.enums_above[name]
	if not enums then
		return out
	end

	for _, res in ipairs(enums) do
		table.insert(out, res)
	end

	return out
end

function Appstruct:get_path(res, singular)
	if not singular then
		return "/" .. res
	end
	if includes(self.enums, res) then
		return "/" .. res .. "/:" .. self:get_key_name(res)
	end
	return "/" .. res .. "/:" .. self:get_key_name(res) .. "[%d]"
end

function Appstruct:get_resources()
	local resources = {}
	for _, res in ipairs(self.primary) do
		local name, list = next(res)
		table.insert(resources, {name = name})
		table.insert(resources, {name = name, singular = true})
		for _, _name in ipairs(list) do
			table.insert(resources, {
				parent = name,
				name = _name,
			})
		end
		for i, sec in ipairs(self.secondary) do
			if includes(sec, name) then
				local _name = table.concat(singularize_except_last(exclude(sec, name)), "_")
				table.insert(resources, {
					parent = name,
					name = _name,
					secondary = sec,
				})
				if #sec == 2 then
					table.insert(resources, {
						parent = name,
						name = _name,
						secondary = sec,
						singular = true,
					})
				end
			end
		end
	end
	for _, res in ipairs(resources) do
		res.loaders = {}
		local name = res.name
		local path = self:get_path(res.name, res.singular)
		if res.parent then
			name = singularize(res.parent) .. "." .. name
			path = self:get_path(res.parent, true) .. path
			table.insert(res.loaders, singularize(res.parent))
		end
		if res.singular then
			name = singularize(name)
			if not includes(self.enums, res.name) then
				table.insert(res.loaders, singularize(res.name))
			end
		end
		res.route_name = name
		res.path = path
		if res.secondary then
			res.controller = table.concat(singularize_except_last(res.secondary), "_")
		else
			res.controller = res.name
		end
		if res.singular then
			res.controller = singularize(res.controller)
			if res.secondary then
				table.insert(res.loaders, res.controller)
			end
		end
	end
	return resources
end

function Appstruct:get_tables()
	local tables = {}

	for _, res in ipairs(self.primary) do
		local name = next(res)
		local t = {name = name}
		table.insert(tables, t)
		for _, v in ipairs(self:get_above(name)) do
			table.insert(t, {
				name = v,
				key = self:get_key_name(v, name),
				enum = includes(self.enums, v),
			})
		end
	end

	for _, res in ipairs(self.secondary) do
		local _t = singularize_except_last(res)
		local t = {
			name = table.concat(_t, "_"),
			secondary = res,
			resource = table.concat(_t, "."),
		}
		table.insert(tables, t)
		for i, v in ipairs(res) do
			table.insert(t, {
				name = v,
				key = self:get_key_name(v),
				enum = includes(self.enums, v),
			})
		end
	end

	return tables
end

function Appstruct:drop_tables()
	lapis_db.query("PRAGMA foreign_keys = OFF;")
	for _, t in ipairs(self:get_tables()) do
		schema.drop_table(t.name)
	end
	lapis_db.query("PRAGMA foreign_keys = ON;")
end

function Appstruct:create_tables()
	local fk_pattern = "FOREIGN KEY (%s) references %s(id) ON DELETE CASCADE"

	for _, tbl in ipairs(self:get_tables()) do
		local decl = {}
		table.insert(decl, {"id", types.integer({primary_key = true})})
		for _, rel in ipairs(tbl) do
			table.insert(decl, {rel.key, types.integer})
		end
		if self.decls[tbl.name] then
			for _, d in ipairs(self.decls[tbl.name]) do
				table.insert(decl, d)
			end
		end
		for _, rel in ipairs(tbl) do
			if not rel.enum then
				table.insert(decl, fk_pattern:format(rel.key, rel.name))
			end
		end
		local rel_keys = {}
		if tbl.secondary then
			for _, rel in ipairs(tbl) do
				table.insert(rel_keys, rel.key)
			end
		elseif self.primary_unique[tbl.name] then
			for _, res in ipairs(self.primary_unique[tbl.name]) do
				local key = self:get_key_name(res, tbl.name)
				table.insert(rel_keys, key)
			end
		end
		if #rel_keys > 0 then
			table.insert(decl, ("UNIQUE(%s)"):format(table.concat(rel_keys, ", ")))
		end
		schema.create_table(tbl.name, decl)
	end
end

function Appstruct:get_url_params(tbl)
	if not tbl.secondary then
		return function(_self, req, ...)
			return singularize(tbl.name), {[self:get_key_name(tbl.name)] = _self.id}, ...
		end
	end
	return function(_self, req, ...)
		local params = {}
		for _, res in ipairs(tbl.secondary) do
			local key = self:get_key_name(res)
			params[key] = _self[key]
		end
		return singularize(tbl.resource), params, ...
	end
end

function Appstruct:get_loader(tbl, model)
	if not tbl.secondary then
		return function(params, ctx)
			local name = singularize(tbl.name)
			ctx[name] = model:find(params[name .. "_id"])
			return ctx[name]
		end
	end
	return function(params, ctx)
		local keys = {}
		for _, res in ipairs(tbl.secondary) do
			local key = self:get_key_name(res)
			keys[key] = params[key]
		end
		local name = singularize(tbl.name)
		ctx[name] = model:find(keys)
		return ctx[name]
	end
end

function Appstruct:define_models()
	local tables = self:get_tables()
	for _, tbl in ipairs(tables) do
		local relations = {}
		for _, rel in ipairs(tbl) do
			if not rel.enum then
				table.insert(relations, {rel.key:gsub("_id", ""), belongs_to = rel.name, key = rel.key})
			end
		end
		for _, _tbl in ipairs(tables) do
			for _, rel in ipairs(_tbl) do
				if not rel.enum and rel.name == tbl.name then
					table.insert(relations, {_tbl.name, has_many = _tbl.name, key = rel.key})
				end
			end
		end
		local model = Model:extend(tbl.name, {
			relations = relations,
			url_params = self:get_url_params(tbl),
		})
		package.loaded["models." .. tbl.name] = model

		local _load = model.load
		if package.searchpath("model_ext." .. tbl.name, package.path) then
			local M = require("model_ext." .. tbl.name)
			local mt = {__index = M}
			setmetatable(M, model.__base)

			function model:load(row)
				_load(self, row)
				for k, v in pairs(row) do
					if k:sub(1, 3) == "is_" then
						row[k] = v ~= 0
					end
				end
				return setmetatable(row, mt)
			end
		else
			function model:load(row)
				for k, v in pairs(row) do
					if k:sub(1, 3) == "is_" then
						row[k] = v ~= 0
					end
				end
				return _load(self, row)
			end
		end
		package.loaded["loaders." .. singularize(tbl.name)] = self:get_loader(tbl, model)
	end
end

function Appstruct:get_string()
	local text = {}

	table.insert(text, "# endpoints")
	for _, res in ipairs(self:get_resources()) do
		if not res.controller then
			table.insert(text, ("- %s %s {%s}"):format(res.route_name, res.path, table.concat(res.loaders, ", ")))
		else
			table.insert(text, ("- %s [%s] %s {%s}"):format(res.route_name, res.controller, res.path, table.concat(res.loaders, ", ")))
		end
	end

	table.insert(text, "")
	table.insert(text, "# tables")
	for _, tbl in ipairs(self:get_tables()) do
		local t = {}
		for _, rel in ipairs(tbl) do
			if rel.enum then
				table.insert(t, ("(%s %s enum)"):format(rel.name, rel.key))
			else
				table.insert(t, ("(%s %s)"):format(rel.name, rel.key))
			end
		end
		table.insert(text, "- " .. tbl.name .. " " .. table.concat(t, " "))
	end

	return table.concat(text, "\n")
end

return Appstruct
