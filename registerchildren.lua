
--[[
	combines GetChildren() and .ChildAdded() into one
	kind of turns an instance into a carrier of instances that need to be registered
	
	example:
	registerChildren(workspace, function(child)
		print(child.Name) -- "Baseplate"
	end)
]]

function registerChildren(parent, callback)
	
	local connections = {}
	local children = {}
	local function Register(child)
		if not table.find(children, child) then
			table.insert(children, child)
			table.insert(connections, child.AncestryChanged:Connect(function()
				if not child:IsDescendantOf(game) and table.find(children, child) then
					table.remove(children, table.find(children, child))
				end
			end))
			callback(child)
		end
	end
	
	for _, child in pairs(parent:GetChildren()) do
		coroutine.wrap(Register)(child)
	end
	table.insert(connections, parent.ChildAdded:Connect(Register))
	
	local self = {}
	function self:Disconnect()
		for _, connection in pairs(connections) do
			connection:Disconnect()
		end
		table.clear(connections)
		table.clear(children)
		table.clear(self)
	end
	return self
end
