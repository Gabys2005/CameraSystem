local replicated = game.ReplicatedStorage.CameraSystem

replicated.Events.MacroAskForValues.OnClientInvoke = function(data)
	local name = data[1]
	table.remove(data,1)
	local totalSize = 70
	local template = script.Parent.Template:Clone()
	template.Name = "E"
	template.Visible = true
	template.Parent = script.Parent
	template.Content.TextLabel.Text = "<b>" .. name .. "</b> needs this information:"
	local toCollect = {}
	for i,v in pairs(data) do
		if v.Type == "number" then
			local temp = script.Number:Clone()
			temp.Namer.Text = v.Name
			temp.Parent = template.Content.InfoSpace
			totalSize += temp.Size.Y.Offset
			table.insert(toCollect,temp)
		elseif v.Type == "string" then
			local temp = script.String:Clone()
			temp.Namer.Text = v.Name
			temp.Parent = template.Content.InfoSpace
			totalSize += temp.Size.Y.Offset
			table.insert(toCollect,temp)
		elseif v.Type == "slider" then
			local temp = script.Slider:Clone()
			temp.Namer.Text = v.Name
			temp.Namer.OriginalText.Value = v.Name
			temp.Min.Text = v.Min
			temp.Max.Text = v.Max
			temp.Parent = template.Content.InfoSpace
			totalSize += temp.Size.Y.Offset
			table.insert(toCollect,temp)
		end
	end
	template.Content.Size = UDim2.new(0,250,0,totalSize)
	template.Position = UDim2.new(0.5,0,0.5,-(totalSize/2))
	local submitted = false
	local yield, con, con2 = Instance.new("BindableEvent")

	con = template.Content.Submit.Submit.MouseButton1Click:Connect(function()
		submitted = true
		yield:Fire()
	end)

	con2 = template.Content.Submit.Cancel.MouseButton1Click:Connect(function()
		yield:Fire()
	end)

	yield.Event:Wait()
	con:Disconnect()
	con2:Disconnect()
	
	local toSend = {}
	for i,v in pairs(toCollect) do
		if v.Name == "Number" then
			table.insert(toSend,tonumber(v.TextBox.Text) or 0)
		elseif v.Name == "String" then
			table.insert(toSend,v.TextBox.Text or "")
		elseif v.Name == "Slider" then
			table.insert(toSend,v.FinalValue.Value)
		end
	end
	template:Destroy()
	if submitted then
		return toSend
	else
		return nil
	end
end