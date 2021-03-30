local api = require(script.Parent.Parent.API)

while wait() do
	api:TintColor(Color3.fromRGB(255,0,0),0.5)
	wait(0.5)
	api:TintColor(Color3.fromRGB(255, 128, 0),0.5)
	wait(0.5)
	api:TintColor(Color3.fromRGB(255, 255, 0),0.5)
	wait(0.5)
	api:TintColor(Color3.fromRGB(0, 255, 0),0.5)
	wait(0.5)
	api:TintColor(Color3.fromRGB(0, 255, 255),0.5)
	wait(0.5)
	api:TintColor(Color3.fromRGB(0, 0, 255),0.5)
	wait(0.5)
	api:TintColor(Color3.fromRGB(255, 0, 255),0.5)
	wait(0.5)
end