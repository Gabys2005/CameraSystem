return function(gui: ScreenGui)
	local replicated = script.Parent.Parent

	local IsAdmin = require(script.Parent.Utils.IsAdmin)
	local Settings = require(replicated.Data.Settings)
	local Gui = require(replicated.Data.Gui)
	local Api = require(replicated.Data.Api)
	local Themes = require(replicated.Data.Themes)

	local currentData = replicated.Functions.GetCurrentData:InvokeServer()
	print(currentData)
	Settings:SetAll(currentData.Settings)
	Gui:Set(gui)
	Api:Set(currentData.Api)
	require(currentData.Api):_SetApis(script.Parent.Parent, currentData.Folder)

	for themeName, themeData in currentData.Themes.All do
		Themes:Add(themeName, themeData)
	end
	Themes:SetCurrent(currentData.Themes.Current)

	require(script.Parent.Main.WatchButton)
	require(script.Parent.Parent.Scripts.Main.DefaultCameraTypes.Static)

	if IsAdmin(game.Players.LocalPlayer) then
		require(script.Parent.Control.TopbarMenu)
		require(script.Parent.Parent.UIWindows.Cameras)
		require(script.Parent.Parent.UIWindows.Settings)
	end
end
