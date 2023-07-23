--// Services
local replicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local replicated = replicatedStorage:WaitForChild("CameraSystem")
local initClient = require(replicated.Client.Main)
initClient(script.Parent)
