local SystemFolder = {}

SystemFolder._folder = nil

function SystemFolder:Set(gui: Folder)
	SystemFolder._folder = gui
end

function SystemFolder:Get()
	return SystemFolder._folder
end

return SystemFolder
