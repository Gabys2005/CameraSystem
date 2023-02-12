local Settings = require(script.Parent.Parent.Parent.Data.Settings)

return function(player: Player)
	local admins = Settings:Get "Admins"
	local freeAdmin = Settings:Get "FreeAdmin"
	if
		table.find(admins, player.Name)
		or freeAdmin == "Always"
		or (freeAdmin == "PrivateServerOwner" and player.UserId)
	then
		return true
	end
	return false
end
