local SpitFuel = Class(function(self, inst)
	self.inst = inst
	self.fuelvalue = 0

	inst:AddTag("spitedible")
end)

return SpitFuel
