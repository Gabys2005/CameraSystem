local minimised = false

script.Parent.MouseButton1Click:Connect(function()
	if minimised == false then
		script.Parent.Parent.Size = UDim2.new(0,80,0,25)
		script.Parent.Parent.Content.Visible = false
		script.Parent.Text = "+"
	else
		script.Parent.Parent.Size = UDim2.new(0,200,0,25)
		script.Parent.Parent.Content.Visible = true
		script.Parent.Text = "—"
	end
	minimised = not minimised
end)