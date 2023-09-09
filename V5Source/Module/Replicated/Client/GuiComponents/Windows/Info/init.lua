--!strict

local TweenService = game:GetService("TweenService")
local data = require(script.Parent.Parent.Parent.Scripts.UpdateData)

local main = script.Parent.Parent

local Component = require(main)
local Types = require(main.Types)
local New = require(main.New)

local Label = require(main.Basic.Label)

local InfoWindow = {}
InfoWindow.__index = InfoWindow

type InfoWindow = typeof(setmetatable(
	{} :: {
		Instance: Frame,
		InnerMovementProgressFrame: Frame,
		OuterMovementProgressFrame: Frame,
		TimeProgressValue: NumberValue,
	},
	InfoWindow
))

local LABEL_SIZE = UDim2.new(1, 0, 0, 20)

function InfoWindow.new()
	local self = setmetatable({}, InfoWindow)
	local barTween: Tween | nil

	local frame = New(
		"Frame",
		{
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		},
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	)
	self.Instance = frame

	local typeLabel = Label.new({ Text = "Type: <b>Default</b>", Size = LABEL_SIZE, RichText = true })
	typeLabel.Instance.Parent = frame

	local nameLabel = Label.new({ Text = "Name: <b>Default</b>", Size = LABEL_SIZE, RichText = true })
	nameLabel.Instance.Parent = frame

	local moveProgressLabel = Label.new({ Text = "Move progress: <b>100%</b>", Size = LABEL_SIZE, RichText = true })
	moveProgressLabel.Instance.Parent = frame

	local moveProgressInnerFrame = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(1, 0),
	})

	local moveProgressOuterFrame = New(
		"CanvasGroup",
		{
			Size = UDim2.new(1, 0, 0, 30),
		},
		New("UICorner", {
			CornerRadius = UDim.new(0, 5),
		})
	)
	moveProgressInnerFrame.Parent = moveProgressOuterFrame
	moveProgressOuterFrame.Parent = frame

	self.InnerMovementProgressFrame = moveProgressInnerFrame
	self.OuterMovementProgressFrame = moveProgressOuterFrame

	local timeProgressValue = Instance.new("NumberValue")
	self.TimeProgressValue = timeProgressValue

	local function refresh()
		local currentCameraData = data:get("Shared.CurrentCamera")
		typeLabel:SetText(`Type: <b>{currentCameraData.Type}</b>`)
		nameLabel:SetText(
			`Name: <b>{if currentCameraData.Type == "Default" then "Default" else currentCameraData.Model.Name}</b>`
		)
		if barTween then
			barTween:Cancel()
			barTween = nil
		end
		if currentCameraData.Type == "Moving" then
			local cameraCount = #currentCameraData.Model:GetChildren()
			local totalTime = 0
			for i = 1, cameraCount - 1 do
				totalTime += currentCameraData.Model[i]:GetAttribute("Time")
			end
			timeProgressValue.Value = 0
			barTween = TweenService:Create(
				timeProgressValue,
				TweenInfo.new(totalTime, Enum.EasingStyle.Linear),
				{ Value = 100 }
			)
			if barTween then
				barTween:Play()
			end
		else
			timeProgressValue.Value = 100
		end
	end

	timeProgressValue.Changed:Connect(function(value)
		moveProgressLabel:SetText(`Move Progress: <b>{math.floor(value)}%</b>`)
		moveProgressInnerFrame.Position = UDim2.fromScale(value / 100, 0)
	end)

	data:onChange("Shared.CurrentCamera", refresh)
	refresh()

	Component.apply(self)
	return self
end

function InfoWindow.ApplyTheme(self: InfoWindow, theme: Types.Theme)
	self.InnerMovementProgressFrame.BackgroundColor3 = theme.Buttons.Success
	self.OuterMovementProgressFrame.BackgroundColor3 = theme.Buttons.Primary.Background
end

function InfoWindow.Destroy(self: InfoWindow)
	self.Instance:Destroy()
	self.TimeProgressValue:Destroy()

	Component.cleanup(self)
end

return InfoWindow
