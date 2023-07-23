return function(className: string, properties: { [string]: any }?, children: any?)
	local ins = Instance.new(className)
	if properties then
		for propertyName, propertyValue in properties do
			ins[propertyName] = propertyValue
		end
	end
	if children then
		if typeof(children) == "table" then
			for _, child in children do
				child.Parent = ins
			end
		else
			children.Parent = ins
		end
	end
	return ins
end
