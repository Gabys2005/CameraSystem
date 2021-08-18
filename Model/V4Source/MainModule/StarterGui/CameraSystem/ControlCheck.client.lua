local replicated = game.ReplicatedStorage
local Settings = require(workspace.CameraSystem.Settings)
local menu = script.Parent.Controls.Menu

if table.find(Settings.GuiOwners, game.Players.LocalPlayer.Name) then
	-- can control
	local topbarPlusReference = replicated:FindFirstChild("TopbarPlusReference")
	local iconModule = replicated:WaitForChild("CameraSystem").Icon
	if topbarPlusReference then
		iconModule = topbarPlusReference.Value
	end

	local Icon = require(iconModule)
	local themes = require(replicated:WaitForChild("CameraSystem").Icon.Themes)
	local icon = Icon.new()
	:setImage(5056694020,"deselected")
	:setImage(5056714850,"selected")
	:setImageYScale(1)
	:bindToggleItem(menu)
	:setTheme(themes.NoBackground)
	icon.selected:Connect(function()
		local buttonPosition = icon.targetPosition
		menu.Position = UDim2.new(0,buttonPosition.X.Scale + 16,0,40)
		if menu.Position.X.Offset < menu.Size.X.Offset/2 then
			menu.Position = UDim2.new(0,menu.Size.X.Offset/2 + 5,0,40)
		end
	end)
else
	-- cant control
	script.Parent.Controls:Destroy()
	script:Destroy()
end