--// Services
local replicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local replicated = replicatedStorage:WaitForChild("CameraSystem")
local initClient = require(replicated.Client.InitControls)
initClient(script.Parent)
