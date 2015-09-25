local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
	Asset( "ANIM", "anim/onyxazuretail.zip" ),
	Asset( "ANIM", "anim/ghost_onyxazuretail_build.zip" ),
}

local prefabs = {
	
}

-- Custom starting items
local start_inv = {
	
}

-- Changing fuel values
local function onFuelEaten(inst, val)
	local newval = math.max(0, math.min(7, inst.spitcharges:value() + val))
	if newval < 2 then
		inst:RemoveTag("canspitfire")
	else
		inst:AddTag("canspitfire")
	end
	inst.spitcharges:set_local(newval)
	inst.spitcharges:set(newval)
end


-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when loading or reviving from ghost (optional)
	inst.components.locomotor.walkspeed = 4
	inst.components.locomotor.runspeed = 6
end


-- When loading or spawning the character
local function onload(inst, data)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)

    if not inst:HasTag("playerghost") then
        onbecamehuman(inst)
    end

	-- Loading fuel charges
	onFuelEaten(inst, data and data.spitcharges or 0)
end

local function onsave(inst, data)
	-- Save the fuel charges
	data.spitcharges = inst.spitcharges:value()
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "onyxazuretail.tex" )
	
	--inst:AddTag("azurebuilder")

	-- Fire breath variables
	inst:AddTag("spitdragon")
	inst.spitcharges = net_tinybyte(inst.GUID, "p.f.spit", "spitchargedelta")
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "wendy"
	
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- Stats	
	inst.components.health:SetMaxHealth(150)
	inst.components.hunger:SetMax(170)
	inst.components.sanity:SetMax(180)
	
	--Sanity
	inst.components.sanity.night_drain_mult = TUNING.WENDY_SANITY_MULT
    inst.components.sanity.neg_aura_mult = TUNING.WENDY_SANITY_MULT
	
	-- Damage multiplier (optional)
  
	inst.components.combat.damagemultiplier = TUNING.WENDY_DAMAGE_MULT
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	inst.OnSave = onsave

	-- Accept event from eating fuel
	onFuelEaten(inst, 0)
	inst:ListenForEvent("fueleaten", onFuelEaten)
end

return MakePlayerCharacter("onyxazuretail", prefabs, assets, common_postinit, master_postinit, start_inv)
