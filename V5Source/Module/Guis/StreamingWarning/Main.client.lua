local replicated = game:GetService("ReplicatedStorage"):WaitForChild("CameraSystem")
local topbarPlus = require(replicated.Client.Dependencies.TopbarPlus)

local label =
	topbarPlus.new():setLabel("Cameras can't load! Untick StreamingEnabled in Workspace's properties."):lock():setMid()
label.deselectWhenOtherIconSelected = false
