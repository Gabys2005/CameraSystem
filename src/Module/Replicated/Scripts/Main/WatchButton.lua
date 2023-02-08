local WatchButton = {}
local replicated = script.Parent.Parent.Parent
local Icon = require(replicated.Dependencies.TopbarPlus)

local watchButton = Icon.new():setName("CameraSystemWatch"):setLabel("Watch"):setMid():autoDeselect(false):setXSize(100)

WatchButton.Button = watchButton

return WatchButton
