local localButtons = script.Parent.Local.Buttons

localButtons.BlackoutTransparent.MouseButton1Click:Connect(function()
	if script.Parent.Parent.Parent.Parent.BlackoutTransparency.Value == 0 then
		script.Parent.Parent.Parent.Parent.BlackoutTransparency.Value = 0.5
		localButtons.BlackoutTransparent.BackgroundColor3 = Color3.fromRGB(35, 167, 28)
	else
		script.Parent.Parent.Parent.Parent.BlackoutTransparency.Value = 0
		localButtons.BlackoutTransparent.BackgroundColor3 = Color3.fromRGB(0,0,0)
	end
end)

localButtons.Keybinds.MouseButton1Click:Connect(function()
	if script.Parent.Parent.Parent.KeybindsEnabled.Value == false then
		script.Parent.Parent.Parent.KeybindsEnabled.Value = true
		localButtons.Keybinds.BackgroundColor3 = Color3.fromRGB(35,167,28)
	else
		script.Parent.Parent.Parent.KeybindsEnabled.Value = false
		localButtons.Keybinds.BackgroundColor3 = Color3.fromRGB(0,0,0)
	end
end)