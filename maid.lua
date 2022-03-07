
--[[
	
	allows you to store connections/events, and easily clean them all up.
	you can attach the maid to an instance, so that when the instance
	is destroyed it will follow in destroying itself.
	
	
	 -- new maid object
	local exampleMaid = Maid.new()
	
	 -- stores the given connection/event inside the exampleMaid
	exampleMaid:give(RunService.RenderStepped:Connect(function(deltaTime)
		print(deltaTime)
	end))
	
	 -- once baseplate is destroyed, exampleMaid:stop() will be called
	 -- returns the AncestryChanged connection for convenience
	exampleMaid:attach(workspace.Baseplate)
	
	 -- ends all connections given to the maid, and destroys itself
	exampleMaid:stop()
	
]]

local Maid = {}
function Maid.new()
	local self = {}
	self.Tasks = {}
	function self:give(task)
		table.insert(self.Tasks, task)
	end
	function self:stop()
		for _, task in pairs(self.Tasks) do
			task:Disconnect()
			task = nil
		end
		table.clear(self.Tasks)
		table.clear(self)
	end
	function self:attach(instance)
		if instance:IsDescendantOf(workspace) then
			return instance.AncestryChanged:Connect(function()
				if not instance:IsDescendantOf(workspace) then
					self:stop()
				end
			end)
		end
	end
	return self
end

return Maid
