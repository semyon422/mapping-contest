local ITracksRepo = require("domain.repos.ITracksRepo")

---@class app.TracksRepo: domain.ITracksRepo
---@operator call: app.TracksRepo
local TracksRepo = ITracksRepo + {}

---@param appDatabase app.AppDatabase
function TracksRepo:new(appDatabase)
	self.models = appDatabase.models
end

---@param conds table
---@return table?
function TracksRepo:get(conds)
	return self.models.tracks:find(conds)
end

---@param track_id number
---@return table?
function TracksRepo:getById(track_id)
	return self.models.tracks:find({id = assert(track_id)})
end

---@param track_id number
function TracksRepo:deleteById(track_id)
	return self.models.tracks:delete({id = assert(track_id)})
end

---@return table?
function TracksRepo:getAll()
	return self.models.tracks:select()
end

---@param track table
function TracksRepo:update(track)
	return self.models.tracks:update(track, {id = assert(track.id)})
end

---@param track table
function TracksRepo:create(track)
	return self.models.tracks:create(track)
end

return TracksRepo
