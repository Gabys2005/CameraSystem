return function(gui: ScreenGui)
	local replicated = script.Parent.Parent
	local Settings = require(replicated.Data.Settings)
	local Gui = require(replicated.Data.Gui)
	local SystemFolder = require(replicated.Data.SystemFolder)
	local Themes = require(replicated.Data.Themes)

	local currentData = replicated.Functions.GetCurrentData:InvokeServer()
	print(currentData)
	Settings:SetAll(currentData.Settings)
	Gui:Set(gui)
	SystemFolder:Set(currentData.Folder)

	for themeName, themeData in currentData.Themes.All do
		Themes:Add(themeName, themeData)
	end
	Themes:SetCurrent(currentData.Themes.Current)

	local IsAdmin = require(script.Parent.Utils.IsAdmin)

	require(script.Parent.Main.WatchButton)

	require(script.Parent.Parent.Scripts.DefaultCameraTypes.Static)

	if IsAdmin(game.Players.LocalPlayer) then
		require(script.Parent.Control.TopbarMenu)
		require(script.Parent.Parent.UIWindows.Cameras)
		require(script.Parent.Parent.UIWindows.Settings)
	end
end
