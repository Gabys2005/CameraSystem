------------------------------------------------------------------------
-- Freecam
-- Cinematic free camera for spectating and video production.
------------------------------------------------------------------------

local pi = math.pi
local abs = math.abs
local clamp = math.clamp
local exp = math.exp
local rad = math.rad
local sign = math.sign
local sqrt = math.sqrt
local tan = math.tan

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local Camera = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local newCamera = Workspace.CurrentCamera
	if newCamera then
		Camera = newCamera
	end
end)

local data = require(script.Parent.Parent.Parent.Data)

------------------------------------------------------------------------

local TOGGLE_INPUT_PRIORITY = Enum.ContextActionPriority.Low.Value
local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value
local FREECAM_MACRO_KB = { Enum.KeyCode.LeftShift, Enum.KeyCode.P }

local NAV_GAIN = Vector3.new(1, 1, 1) * 64
local PAN_GAIN = Vector2.new(0.75, 1) * 8
local FOV_GAIN = 300

local PITCH_LIMIT = rad(90)

local VEL_STIFFNESS = 1.5
local PAN_STIFFNESS = 1.0
local FOV_STIFFNESS = 4.0

------------------------------------------------------------------------

local Spring = {}
do
	Spring.__index = Spring

	function Spring.new(freq, pos)
		local self = setmetatable({}, Spring)
		self.f = freq
		self.p = pos
		self.v = pos * 0
		return self
	end

	function Spring:Update(dt, goal)
		local f = self.f * 2 * pi
		local p0 = self.p
		local v0 = self.v

		local offset = goal - p0
		local decay = exp(-f * dt)

		local p1 = goal + (v0 * dt - offset * (f * dt + 1)) * decay
		local v1 = (f * dt * (offset * f - v0) + v0) * decay

		self.p = p1
		self.v = v1

		return p1
	end

	function Spring:Reset(pos)
		self.p = pos
		self.v = pos * 0
	end
end

------------------------------------------------------------------------

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()
local cameraFov = 0

local velSpring = Spring.new(VEL_STIFFNESS, Vector3.new())
local panSpring = Spring.new(PAN_STIFFNESS, Vector2.new())
local fovSpring = Spring.new(FOV_STIFFNESS, 0)

------------------------------------------------------------------------

local Input = {}
do
	local thumbstickCurve
	do
		local K_CURVATURE = 2.0
		local K_DEADZONE = 0.15

		local function fCurve(x)
			return (exp(K_CURVATURE * x) - 1) / (exp(K_CURVATURE) - 1)
		end

		local function fDeadzone(x)
			return fCurve((x - K_DEADZONE) / (1 - K_DEADZONE))
		end

		function thumbstickCurve(x)
			return sign(x) * clamp(fDeadzone(abs(x)), 0, 1)
		end
	end

	local gamepad = {
		ButtonX = 0,
		ButtonY = 0,
		DPadDown = 0,
		DPadUp = 0,
		ButtonL2 = 0,
		ButtonR2 = 0,
		Thumbstick1 = Vector2.new(),
		Thumbstick2 = Vector2.new(),
	}

	local keyboard = {
		W = 0,
		A = 0,
		S = 0,
		D = 0,
		E = 0,
		Q = 0,
		U = 0,
		H = 0,
		J = 0,
		K = 0,
		I = 0,
		Y = 0,
		Up = 0,
		Down = 0,
		LeftShift = 0,
		RightShift = 0,
	}

	local mouse = {
		Delta = Vector2.new(),
		MouseWheel = 0,
	}

	local NAV_GAMEPAD_SPEED = Vector3.new(1, 1, 1)
	local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
	local PAN_MOUSE_SPEED = Vector2.new(1, 1) * (pi / 64)
	local PAN_GAMEPAD_SPEED = Vector2.new(1, 1) * (pi / 8)
	local FOV_WHEEL_SPEED = 1.0
	local FOV_GAMEPAD_SPEED = 0.25
	local NAV_ADJ_SPEED = 0.75
	local NAV_SHIFT_MUL = 0.25

	local navSpeed = 1

	function Input.Vel(dt)
		navSpeed = clamp(navSpeed + dt * (keyboard.Up - keyboard.Down) * NAV_ADJ_SPEED, 0.01, 4)

		local kGamepad = Vector3.new(
			thumbstickCurve(gamepad.Thumbstick1.X),
			thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
			thumbstickCurve(-gamepad.Thumbstick1.Y)
		) * NAV_GAMEPAD_SPEED

		local kKeyboard = Vector3.new(
			keyboard.D - keyboard.A + keyboard.K - keyboard.H,
			keyboard.E - keyboard.Q + keyboard.I - keyboard.Y,
			keyboard.S - keyboard.W + keyboard.J - keyboard.U
		) * NAV_KEYBOARD_SPEED

		local shift = data.Local.Settings.DroneSpeed

		return (kGamepad + kKeyboard) * (navSpeed * shift)
	end

	function Input.Pan(dt)
		local kGamepad = Vector2.new(thumbstickCurve(gamepad.Thumbstick2.Y), thumbstickCurve(-gamepad.Thumbstick2.X))
			* PAN_GAMEPAD_SPEED
		local kMouse = mouse.Delta * PAN_MOUSE_SPEED
		mouse.Delta = Vector2.new()
		return kGamepad + kMouse
	end

	function Input.Fov(dt)
		local kGamepad = (gamepad.ButtonX - gamepad.ButtonY) * FOV_GAMEPAD_SPEED
		local kMouse = mouse.MouseWheel * FOV_WHEEL_SPEED
		mouse.MouseWheel = 0
		return kGamepad + kMouse
	end

	do
		local function Keypress(action, state, input)
			keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		local function GpButton(action, state, input)
			gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		local function MousePan(action, state, input)
			local delta = input.Delta
			mouse.Delta = Vector2.new(-delta.y, -delta.x)
			return Enum.ContextActionResult.Sink
		end

		local function Thumb(action, state, input)
			gamepad[input.KeyCode.Name] = input.Position
			return Enum.ContextActionResult.Sink
		end

		local function Trigger(action, state, input)
			gamepad[input.KeyCode.Name] = input.Position.z
			return Enum.ContextActionResult.Sink
		end

		local function MouseWheel(action, state, input)
			mouse[input.UserInputType.Name] = -input.Position.z
			return Enum.ContextActionResult.Sink
		end

		local function Zero(t)
			for k, v in pairs(t) do
				t[k] = v * 0
			end
		end

		function Input.StartCapture()
			ContextActionService:BindActionAtPriority(
				"FreecamKeyboard",
				Keypress,
				false,
				INPUT_PRIORITY,
				Enum.KeyCode.W,
				Enum.KeyCode.U,
				Enum.KeyCode.A,
				Enum.KeyCode.H,
				Enum.KeyCode.S,
				Enum.KeyCode.J,
				Enum.KeyCode.D,
				Enum.KeyCode.K,
				Enum.KeyCode.E,
				Enum.KeyCode.I,
				Enum.KeyCode.Q,
				Enum.KeyCode.Y,
				Enum.KeyCode.Up,
				Enum.KeyCode.Down
			)
			ContextActionService:BindActionAtPriority(
				"FreecamMousePan",
				MousePan,
				false,
				INPUT_PRIORITY,
				Enum.UserInputType.MouseMovement
			)
			ContextActionService:BindActionAtPriority(
				"FreecamMouseWheel",
				MouseWheel,
				false,
				INPUT_PRIORITY,
				Enum.UserInputType.MouseWheel
			)
			ContextActionService:BindActionAtPriority(
				"FreecamGamepadButton",
				GpButton,
				false,
				INPUT_PRIORITY,
				Enum.KeyCode.ButtonX,
				Enum.KeyCode.ButtonY
			)
			ContextActionService:BindActionAtPriority(
				"FreecamGamepadTrigger",
				Trigger,
				false,
				INPUT_PRIORITY,
				Enum.KeyCode.ButtonR2,
				Enum.KeyCode.ButtonL2
			)
			ContextActionService:BindActionAtPriority(
				"FreecamGamepadThumbstick",
				Thumb,
				false,
				INPUT_PRIORITY,
				Enum.KeyCode.Thumbstick1,
				Enum.KeyCode.Thumbstick2
			)
		end

		function Input.StopCapture()
			navSpeed = 1
			Zero(gamepad)
			Zero(keyboard)
			Zero(mouse)
			ContextActionService:UnbindAction("FreecamKeyboard")
			ContextActionService:UnbindAction("FreecamMousePan")
			ContextActionService:UnbindAction("FreecamMouseWheel")
			ContextActionService:UnbindAction("FreecamGamepadButton")
			ContextActionService:UnbindAction("FreecamGamepadTrigger")
			ContextActionService:UnbindAction("FreecamGamepadThumbstick")
		end
	end
end

local function GetFocusDistance(cameraFrame)
	local znear = 0.1
	local viewport = Camera.ViewportSize
	local projy = 2 * tan(cameraFov / 2)
	local projx = viewport.x / viewport.y * projy
	local fx = cameraFrame.rightVector
	local fy = cameraFrame.upVector
	local fz = cameraFrame.lookVector

	local minVect = Vector3.new()
	local minDist = 512

	for x = 0, 1, 0.5 do
		for y = 0, 1, 0.5 do
			local cx = (x - 0.5) * projx
			local cy = (y - 0.5) * projy
			local offset = fx * cx - fy * cy + fz
			local origin = cameraFrame.p + offset * znear
			local _, hit = Workspace:FindPartOnRay(Ray.new(origin, offset.unit * minDist))
			local dist = (hit - origin).magnitude
			if minDist > dist then
				minDist = dist
				minVect = offset.unit
			end
		end
	end

	return fz:Dot(minVect) * minDist
end

------------------------------------------------------------------------

local droneInstance
local lastCameraCFrame

local function StepFreecam(dt)
	local vel = velSpring:Update(dt, Input.Vel(dt))
	local pan = panSpring:Update(dt, Input.Pan(dt))
	local fov = fovSpring:Update(dt, Input.Fov(dt))

	local zoomFactor = sqrt(tan(rad(70 / 2)) / tan(rad(cameraFov / 2)))

	cameraFov = clamp(cameraFov + fov * FOV_GAIN * (dt / zoomFactor), 1, 120)
	cameraRot = cameraRot + pan * PAN_GAIN * (dt / zoomFactor)
	cameraRot = Vector2.new(clamp(cameraRot.x, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.y % (2 * pi))

	local cameraCFrame = CFrame.new(cameraPos)
		* CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)
		* CFrame.new(vel * NAV_GAIN * dt)
	cameraPos = cameraCFrame.p

	local nx, ny, nz = cameraCFrame:ToOrientation()
	local finalCFrame = cameraCFrame * CFrame.Angles(-nx, 0, 0)

	droneInstance.CamPos.BodyGyro.CFrame = cameraCFrame
	droneInstance.CamPos.BodyPosition.Position = cameraPos
	droneInstance.BodyPosition.Position = cameraPos
	droneInstance.BodyGyro.CFrame = finalCFrame
	Camera.CFrame = cameraCFrame
	lastCameraCFrame = cameraCFrame

	-- Camera.CFrame = cameraCFrame
	-- Camera.Focus = cameraCFrame * CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
	-- Camera.FieldOfView = cameraFov
end

------------------------------------------------------------------------

local function StartFreecam()
	local cameraCFrame = droneInstance.CamPos.CFrame
	cameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())
	cameraPos = cameraCFrame.p
	cameraFov = Camera.FieldOfView

	velSpring:Reset(Vector3.new())
	panSpring:Reset(Vector2.new())
	-- fovSpring:Reset(0)

	-- PlayerState.Push()
	RunService:BindToRenderStep("CameraSystemV5Drone", Enum.RenderPriority.Camera.Value, StepFreecam)
	Input.StartCapture()
end

local function StopFreecam()
	Input.StopCapture()
	RunService:UnbindFromRenderStep("CameraSystemV5Drone")
	-- PlayerState.Pop()
end

------------------------------------------------------------------------

local watchController = require(script.Parent.Parent.Controllers.Watch)
local other = require(script.Parent.Parent.Scripts.Other)
local wasWatching = false

local DroneController = {}

function DroneController:Stop()
	if droneInstance then
		script.Parent.Parent.Parent.Events.SendDroneLocation:InvokeServer(droneInstance, lastCameraCFrame)
	end
	StopFreecam()
	watchController:Unlock()
	data.Local.ControllingDrone = false
	if wasWatching then
		watchController:Watch()
	end
	other:updateDroneVisibility()
end

function DroneController:Start(drone)
	StopFreecam()
	data.Local.ControllingDrone = true
	wasWatching = watchController.IsWatching
	script.Parent.Parent.Parent.Events.RequestDrone:InvokeServer(drone)
	droneInstance = drone
	watchController:Unwatch()
	watchController:Lock()
	StartFreecam()
	other:updateDroneVisibility()
end

return DroneController
