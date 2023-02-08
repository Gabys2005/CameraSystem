local Settings = require(script.Parent.Parent.Parent.Data.Settings)

return function(username: string)
	local admins = Settings:Get("Admins")
	if table.find(admins, username) then
		return true
	end
	return false
end
