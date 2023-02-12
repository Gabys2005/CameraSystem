local Api = {}

function Api:_SetApis(replicated)
	Api.Themes = require(replicated.Apis.Themes)
end

return Api
