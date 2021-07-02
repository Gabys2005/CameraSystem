local uis = game:GetService("UserInputService")

for i,v in pairs(script.Parent:GetChildren()) do
	if v:IsA("TextButton") then
		v.MouseButton1Click:Connect(function()
			script.Parent.Parent[v.Name].Visible = not script.Parent.Parent[v.Name].Visible
		end)
		script.Parent.Parent[v.Name]:GetPropertyChangedSignal("Visible"):Connect(function()
			local color = Color3.fromRGB(0,0,0)
			local enabled = false
			if script.Parent.Parent[v.Name].Visible == true then
				color = Color3.fromRGB(35,167,28)
				enabled = true
			end
			if v.Name == "MobileView" then
				uis.ModalEnabled = enabled
			end
			script.Parent[v.Name].BackgroundColor3 = color
		end)
	end
end