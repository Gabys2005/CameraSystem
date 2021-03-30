local Settings = require(workspace.CameraSystem.Settings)
local macros = Settings.Macros
local replicated = game.ReplicatedStorage.CameraSystem

for i,v in pairs(macros) do
	local template = script.Template:Clone()
	template.Text = v.Name
	template.Parent = script.Parent.ScrollingFrame
	if v.LeftClick then
		template.MouseButton1Click:Connect(function()
			replicated.Events.RunMacro:FireServer(v.Name,"LeftClick")
		end)
	end
	if v.RightClick then
		template.MouseButton2Click:Connect(function()
			replicated.Events.RunMacro:FireServer(v.Name,"RightClick")
		end)
	end
end

script.Parent.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,math.ceil(#macros/2)*35)