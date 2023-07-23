return function(module: ModuleScript?, defaultValue: any, warningMessage: string)
	if not module then
		warn(warningMessage)
		return defaultValue
	end

	local success, contentOrErrorMessage = pcall(require, module)

	if success then
		return contentOrErrorMessage
	else
		warn(warningMessage)
		return defaultValue
	end
end
