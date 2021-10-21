-- This is used in functions where the data is defined dynamically and we can't
-- use the normal path syntax, and also for connecting functions for when
-- the data changes
local updateData = {}
local data = require(script.Parent.Parent.Parent.Data)

local onchangeEvents = {}

function updateData:get(name: string)
	local path = string.split(name, ".")
	local val = data
	for i, v in pairs(path) do
		val = val[v]
	end
	return val
end

function updateData:getModule()
	return data
end

function updateData:set(name: string, val: any)
	local path = string.split(name, ".")
	local toEdit = data
	for i = 1, #path - 1 do
		toEdit = toEdit[path[i]]
	end
	toEdit[path[#path]] = val
	if onchangeEvents[name] then
		for i, v in pairs(onchangeEvents[name]) do
			task.spawn(function()
				v(val)
			end)
		end
	end
end

function updateData:onChange(name: string, func)
	if not onchangeEvents[name] then
		onchangeEvents[name] = {}
	end
	table.insert(onchangeEvents[name], func)
end

return updateData
