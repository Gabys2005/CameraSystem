local utils = require(script.Parent.Utils)
local theme = require(script.Parent.Parent.Themes.Current)
local draggableUi = require(script.Parent.DraggableUI)
local window = {}
local parent

export type NewWindowParams = {
	Title: string,
	Name: string,
	MinimumWidth: number,
	MinimumHeight: number,
	Position: UDim2,
	Enabled: boolean
}

function window:setParent(instance)
	parent = instance
end

script.Frame.BackgroundColor3 = theme.Base
script.Frame.CloseButtonOverlay1.BackgroundColor3 = theme.RedButton
script.Frame.CloseButtonOverlay2.BackgroundColor3 = theme.RedButton
script.Frame.Close.BackgroundColor3 = theme.RedButton
script.Frame.Minimise.BackgroundColor3 = theme.DarkerButton
script.Frame.TopbarFiller.BackgroundColor3 = theme.Base
script.Frame.Content.Content.BackgroundColor3 = theme.Base
script.Frame.TextLabel.TextColor3 = theme.BaseText
script.Frame.Content.Content.BorderColor3 = theme.BaseBorder

function window:new(params:NewWindowParams,options)
	local minWidth = params.MinimumWidth or 220
	local minHeight = params.MinimumHeight or 300
	local pos = params.Position or UDim2.fromOffset(200,50)
	local windowCopy = script.Frame:Clone()
	windowCopy.Name = params.Name
	windowCopy.Size = UDim2.fromOffset(minWidth,20)
	windowCopy.Content.Size = UDim2.new(1,0,0,minHeight)
	windowCopy.Position = pos
	windowCopy.Visible = params.Enabled or false
	windowCopy.TextLabel.Text = params.Title
	
	windowCopy.Close.MouseButton1Click:Connect(function()
		windowCopy:Destroy()
	end)
	
	local content = require(script.Parent.Parent.GuiComponents[params.Name])(params,options)
	content.Parent = windowCopy.Content.Content
	windowCopy.Parent = parent
	draggableUi(windowCopy)
	return windowCopy
end

return window