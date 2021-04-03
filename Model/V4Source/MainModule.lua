script.ReplicatedStorage.CameraSystem.Parent = game.ReplicatedStorage
for i,v in pairs(script.Lighting:GetChildren()) do
	v.Parent = game.Lighting
end
script.Workspace.API.Parent = workspace.CameraSystem
script.Workspace.Main.Parent = workspace.CameraSystem
script.StarterGui.CameraSystem.Parent = game.StarterGui

return "hi"