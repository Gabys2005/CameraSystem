-- This module is here so we don't have to check the Theme setting every time we want to get the theme colors
local Settings = require(workspace:FindFirstChild("CameraSystem").Settings) -- TODO remove direct reference to workspace
local theme = Settings.Theme or "Dark"
local themeScript = require(script.Parent[theme])
return themeScript
