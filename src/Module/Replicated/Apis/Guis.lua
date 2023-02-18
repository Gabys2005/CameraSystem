local GuisApi = {
	Cameras = {},
	Utils = {},
}
local replicated = script.Parent.Parent
local GuisData = require(replicated.Data.Guis)
local Fusion = require(replicated.Dependencies.Fusion)
local Button = require(replicated.UIComponents.Button)

local New = Fusion.New
local Children = Fusion.Children
local ForValues = Fusion.ForValues

function GuisApi.Cameras:AddSection(name: string, content: any)
	GuisData:AddCameraSection(name, content)
end

function GuisApi.Utils.GenerateCameraGrid(camType: string)
	local names = replicated.Functions.GetNames:InvokeServer(camType)
	print(names)
	return New("Frame") {
		BackgroundTransparency = 1,
		[Children] = {
			New("UIGridLayout") {
				CellSize = UDim2.fromOffset(100, 30),
			},

			ForValues(names, function(name)
				return Button {
					Text = name.Name,
					OnClick = function()
						replicated.Functions.ChangeCamera:FireServer(name.ID)
					end,
				}
			end, Fusion.cleanup),
		},
	}
end

return GuisApi
