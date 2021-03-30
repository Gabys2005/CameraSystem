local replicated = game.ReplicatedStorage
local Settings = require(workspace.CameraSystem.Settings)
local topbarPlus = replicated:WaitForChild("HDAdmin"):WaitForChild("Topbar+")

local TopbarPlusTheme = {
	["toggleTweenInfo"] = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	["button"] = {
		selected = {
			ImageTransparency = 0.5,
			ImageColor3 = Color3.fromRGB(0,0,0),
		},
		deselected = {
			ImageTransparency = 0.5,
			ImageColor3 = Color3.fromRGB(0,0,0),
		}
	},
	["image"] = {
		selected = {
			ImageColor3 = Color3.fromRGB(255,255,255),
			Image = "rbxassetid://5056714850"
		},
		deselected = {
			ImageColor3 = Color3.fromRGB(255,255,255),
			Image = "rbxassetid://5056694020",
			Size = UDim2.new(0,30,0,30)
		}
	}
}

local menu = script.Parent.Controls.Menu

if table.find(Settings.GuiOwners, game.Players.LocalPlayer.Name) then
	-- can control
	local iconController = require(topbarPlus.IconController)
	local icon = iconController:createIcon("CameraSystem",5056694020,1)
	icon:setToggleMenu(menu)
	icon:setToggleFunction(function()
		local button = icon.objects.container
		menu.Position = UDim2.new(0,button.AbsolutePosition.X + button.Size.X.Offset/2,0,40)
		if menu.Position.X.Offset < menu.Size.X.Offset/2 then
			menu.Position = UDim2.new(0,menu.Size.X.Offset/2 + 5,0,40)
		end
	end)
	icon:setTheme(TopbarPlusTheme)
else
	-- cant control
	script.Parent.Controls:Destroy()
	script:Destroy()
end