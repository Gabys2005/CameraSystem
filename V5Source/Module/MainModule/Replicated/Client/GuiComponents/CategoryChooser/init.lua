local theme = require(script.Parent.Parent.Themes.Current)
local util = require(script.Parent.Parent.Scripts.Utils)
local window = require(script.Parent.Parent.Scripts.NewWindow)
local ts = game:GetService("TweenService")

export type CategoryChooserTable = {
	Frame: GuiObject,
	Name: string,
	ComponentName: string
}
export type CategoryChooserOptions = {
	Frames: table<CategoryChooserTable>
}

script.MenuButton.BackgroundColor3 = theme.Base
script.MenuButton.TextColor3 = theme.BaseText
script.Frame.Categories.BackgroundColor3 = theme.Base
script.Frame.Categories.Selector.BackgroundColor3 = theme.Underline

return function(options:CategoryChooserOptions)
	local copy = script.Frame:Clone()
	local buttonWidth = 1/#options.Frames
	copy.Categories.Selector.Size = UDim2.new(buttonWidth,0,0,2)
	for i,v:CategoryChooserTable in pairs(options.Frames) do
		local button = script.MenuButton:Clone()
		button.Text = v.Name
		button.Size = UDim2.fromScale(buttonWidth,1)
		button.Position = UDim2.fromScale((i-1) * buttonWidth,0)
		button.Parent = copy.Categories
		
		button.MouseButton1Click:Connect(function()
			copy.Pages.UIPageLayout:JumpToIndex(i-1)
			ts:Create(copy.Categories.Selector,TweenInfo.new(0.2),{Position = UDim2.fromScale((i-1) * buttonWidth,1)}):Play()
		end)
		button.MouseButton2Click:Connect(function()
			window:new({
				Name = v.ComponentName,
				Title = v.Name,
				Position = UDim2.fromOffset(300,50),
				Enabled = true
			})
		end)
		
		local frame = util:NewInstance("Frame",{
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1,1),
			LayoutOrder = i,
			Parent = copy.Pages
		})
		v.Frame.Parent = frame
	end
	
	return copy
end