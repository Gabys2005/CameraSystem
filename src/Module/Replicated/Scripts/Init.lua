return function(gui: ScreenGui)
	local replicated = script.Parent.Parent
	local Settings = require(replicated.Data.Settings)
	local Gui = require(replicated.Data.Gui)

	local currentData = replicated.Functions.GetCurrentData:InvokeServer()
	print(currentData)
	Settings:SetAll(currentData.Settings)
	Gui:Set(gui)

	local IsAdmin = require(script.Parent.Utils.IsAdmin)

	require(script.Parent.Main.WatchButton)

	if IsAdmin(game.Players.LocalPlayer.Name) then
		require(script.Parent.Control.TopbarMenu)
		require(script.Parent.Control.Windows.Cameras)
	end
end
