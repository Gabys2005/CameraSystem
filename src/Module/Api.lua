local Api = {}

local _folder = nil

function Api:_SetApis(replicated, folder)
	Api.Themes = require(replicated.Apis.Themes)
	Api.Cameras = require(replicated.Apis.Cameras)
	Api.Guis = require(replicated.Apis.Guis)
	_folder = folder
end

function Api:GetSystemFolder()
	return _folder
end

return Api
