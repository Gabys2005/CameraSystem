local Api = {}

Api._api = nil

function Api:Set(api: ModuleScript)
	Api._api = api
end

function Api:Get()
	return require(Api._api)
end

return Api
