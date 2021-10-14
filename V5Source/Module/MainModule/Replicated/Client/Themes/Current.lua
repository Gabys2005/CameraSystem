local Settings = require(workspace:FindFirstChild("CameraSystem").Settings)
local theme = Settings.Theme or "Dark"
local themeScript = require(script.Parent[theme])
return themeScript