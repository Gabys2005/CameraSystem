local util = require(script.Parent.Parent.Parent.Scripts.Utils)
local data = require(script.Parent.Parent.Parent.Scripts.UpdateData)
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

export type DotSliderParams = {
	Name: string,
	Min: number,
	Max: number,
	Round: number,
	Default: number,
	Setting: string,
	EventToFire: RemoteEvent?,
	Suffix: string?,
}

local main = script.Parent.Parent

local Component = require(main)
local New = require(main.New)
local Types = require(main.Types)

local Button = require(main.Basic.Button)
local Label = require(main.Basic.Label)

local DotSlider = {}
DotSlider.__index = DotSlider

local FULL_SLIDER_TIME = 5

export type DotSlider = typeof(setmetatable(
	{} :: {
		Instance: Frame,
		Children: { any },
		Events: { RBXScriptSignal },
		SliderBackground: Frame,
		SliderFiller: Frame,
		SliderCircle: Frame,
	},
	DotSlider
))

function DotSlider.new(params: DotSliderParams)
	local self = setmetatable({}, DotSlider)
	self.Events = {}
	self.Children = {}

	local mainFrame = New("Frame", {
		BackgroundTransparency = 0,
		Size = UDim2.new(1, 0, 0, 60),
	}, {
		New("UICorner", { CornerRadius = UDim.new(0, 8) }),
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 15),
			PaddingTop = UDim.new(0, 5),
			PaddingLeft = UDim.new(0, 5),
			PaddingRight = UDim.new(0, 5),
		}),
	})

	params.Round = params.Round or 0
	params.Suffix = params.Suffix or ""

	local nameLabel =
		Label.new({ Text = params.Name, Size = UDim2.fromScale(0.4, 0.5), Position = UDim2.fromScale(0, 0.1) })
	nameLabel:SetParent(mainFrame)

	local valueLabel = Label.new({
		Text = "0",
		Position = UDim2.fromScale(0.5, 0.1),
		Size = UDim2.fromScale(0.4, 0.5),
		AnchorPoint = Vector2.new(0.5, 0),
		Bold = true,
	})
	valueLabel:SetParent(mainFrame)

	table.insert(self.Children, nameLabel)
	table.insert(self.Children, valueLabel)

	local sliderContainer = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0.85),
		Size = UDim2.fromScale(0.85, 0.15),
		BackgroundTransparency = 1,
		Parent = mainFrame,
	})

	local hitbox = New("Frame", {
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(1, 20, 1, 8),
		BackgroundTransparency = 1,
		Parent = sliderContainer,
	})

	local sliderBackground = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		Parent = sliderContainer,
	}, New("UICorner", { CornerRadius = UDim.new(0, 10) }))

	local sliderFiller = New("Frame", {
		Size = UDim2.new(0.5, 1),
		Parent = sliderBackground,
	}, New("UICorner", { CornerRadius = UDim.new(0, 10) }))

	local sliderCircle = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(1, 0.5),
		Size = UDim2.fromOffset(20, 20),
		Parent = sliderFiller,
	}, New("UICorner", { CornerRadius = UDim.new(1, 0) }))

	self.SliderBackground = sliderBackground
	self.SliderFiller = sliderFiller
	self.SliderCircle = sliderCircle

	local function reset(rightClick: boolean)
		if params.EventToFire then
			if rightClick then
				local currentValue = data:get(params.Setting)
				if typeof(currentValue) == "table" and currentValue.Value then
					currentValue = currentValue.Value
				end
				currentValue = util:Map(currentValue, params.Min, params.Max, 0, 1)
				local defaultValue = util:Map(params.Default, params.Min, params.Max, 0, 1)

				local distance = math.abs(currentValue - defaultValue)
				params.EventToFire:FireServer(params.Default, distance * FULL_SLIDER_TIME)
			else
				params.EventToFire:FireServer(params.Default)
			end
		else
			data:set(params.Setting, params.Default)
		end
	end

	local resetButton = Button.new({
		Text = "Reset",
		Position = UDim2.fromScale(0.9, 0.15),
		Size = UDim2.fromScale(0.3, 0.4),
		AnchorPoint = Vector2.new(1, 0),
		Parent = mainFrame,
		OnClick = function()
			reset(false)
		end,
		OnRightClick = function()
			reset(true)
		end,
	})
	table.insert(self.Children, resetButton)

	table.insert(
		self.Events,
		hitbox.InputBegan:Connect(function(Input: InputObject)
			if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			local dragging = true
			local stopDrag
			stopDrag = Input:GetPropertyChangedSignal("UserInputState"):Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					dragging = false
					stopDrag:Disconnect()
				end
			end)

			while dragging do
				local relativePositionX = uis:GetMouseLocation().X - sliderBackground.AbsolutePosition.X
				local scaleX = math.clamp(relativePositionX / sliderBackground.AbsoluteSize.X, 0, 1)
				local value = scaleX * (params.Max - params.Min) + params.Min
				if params.EventToFire then
					params.EventToFire:FireServer(value)
				else
					data:set(params.Setting, value)
				end
				task.wait()
			end

			Input:Destroy()
		end)
	)

	local function update(newValue)
		local actualValue = newValue or data:get(params.Setting)
		if typeof(actualValue) == "table" and actualValue.Value then
			actualValue = actualValue.Value
		end
		local val = util:Map(actualValue, params.Min, params.Max, 0, 1)
		ts:Create(sliderFiller, TweenInfo.new(0.05), { Size = UDim2.fromScale(val, 1) }):Play()
		valueLabel:SetText(util:Round(actualValue, params.Round) .. params.Suffix)
	end
	data:onChange(params.Setting, update)
	update()

	self.Instance = mainFrame

	Component.apply(self)
	return self
end

function DotSlider.SetParent(self: DotSlider, newParent: Instance)
	self.Instance.Parent = newParent
end

function DotSlider.ApplyTheme(self: DotSlider, theme: Types.Theme)
	self.Instance.BackgroundColor3 = theme.Background.Dark
	self.SliderBackground.BackgroundColor3 = theme.Buttons.Primary.Background
	self.SliderFiller.BackgroundColor3 = theme.Buttons.Primary.Selected
	self.SliderCircle.BackgroundColor3 = theme.Buttons.Primary.Selected
end

function DotSlider.Destroy(self: DotSlider)
	self.Instance:Destroy()
	for _, child in self.Children do
		child:Destroy()
	end
	for _, event in self.Events do
		event:Disconnect()
	end

	Component.cleanup(self)
end

return DotSlider
