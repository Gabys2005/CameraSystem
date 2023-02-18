local Api = {}

function Api:_SetApis(replicated)
	Api.Themes = require(replicated.Apis.Themes)
	Api.Cameras = require(replicated.Apis.Cameras)
	-- TODO: add guis api
end

return Api
