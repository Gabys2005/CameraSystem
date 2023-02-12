return function(gui: ScreenGui)
	local replicated = script.Parent.Parent
	local Settings = require(replicated.Data.Settings)
	local Gui = require(replicated.Data.Gui)
	local Themes = require(replicated.Data.Themes)

	local currentData = replicated.Functions.GetCurrentData:InvokeServer()
	print(currentData)
	Settings:SetAll(currentData.Settings)
	Gui:Set(gui)

	for themeName, themeData in currentData.Themes.All do
		Themes:Add(themeName, themeData)
	end
	Themes:SetCurrent(currentData.Themes.Current)

	local IsAdmin = require(script.Parent.Utils.IsAdmin)

	require(script.Parent.Main.WatchButton)

	if IsAdmin(game.Players.LocalPlayer) then
		require(script.Parent.Control.TopbarMenu)
		require(script.Parent.Parent.UIWindows.Cameras)
	end
end
