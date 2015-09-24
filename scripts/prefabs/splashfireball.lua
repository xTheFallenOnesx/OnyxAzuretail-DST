local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddPhysics()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddNetwork()

	inst.Light:Enable(true)
	inst.Light:SetRadius(2.5)
	inst.Light:SetColour(0, 183/255, 1)
	inst.Light:SetFalloff(0.5)
	inst.Light:SetIntensity(0.75)

	inst.AnimState:SetBank("projectile")
	inst.AnimState:SetBuild("staff_projectile")
	inst.AnimState:PlayAnimation("fire_spin_loop", true)
	inst.AnimState:SetMultColour(0, 183/255, 1, 1)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("weapon")
	inst:AddComponent("locomotor")

	inst:AddComponent("groundpounder")
	inst.components.groundpounder.numRings = 2
	inst.components.groundpounder.burner = true
	inst.components.groundpounder.groundpoundfx = "bluefiresplash_fx"
	inst.components.groundpounder.groundpounddamagemult = 2
	inst.components.groundpounder.groundpoundringfx = "bluefiresplash_fx"

	inst:AddComponent("complexprojectile")

	return inst
end

return Prefab("common/splashfireball", fn)
