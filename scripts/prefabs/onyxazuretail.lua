
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),

        Asset( "ANIM", "anim/onyxazuretail.zip" ),
        Asset( "ANIM", "anim/ghost_onyxazuretail_build.zip" ),
}
local prefabs = {
	
}

-- Custom starting items
local start_inv = {
	
}


-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when loading or reviving from ghost (optional)
	inst.components.locomotor.walkspeed = 4
	inst.components.locomotor.runspeed = 6
end


-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)

    if not inst:HasTag("playerghost") then
        onbecamehuman(inst)
    end
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "onyxazuretail.tex" )
	
	--inst:AddTag("azurebuilder")
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
end

return MakePlayerCharacter("onyxazuretail", prefabs, assets, common_postinit, master_postinit, start_inv)

--Fireball?
local MakePlayerCharacter = require("prefabs/player_common")

local assets = {
	Asset("ANIM", "anim/wilson.zip"),
	Asset("ANIM", "anim/ghost_wilson_build.zip"),
}

local prefabs = {}

local function common_postinit(inst)
	inst:AddTag("ghostwithhat")
	inst:AddTag("spitdragon")

	inst.spitcharges = net_tinybyte(inst.GUID, "p.f.spit", "spitchargedelta")
end

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

local function OnLoad(inst, data)
	onFuelEaten(inst, data and data.spitcharges or 0)
end

local function OnSave(inst, data)
	data.spitcharges = inst.spitcharges:value()
end

local function master_postinit(inst)
	onFuelEaten(inst, 0)
	inst:ListenForEvent("fueleaten", onFuelEaten)

	inst.OnLoad = OnLoad
	inst.OnSave = OnSave
end

return MakePlayerCharacter("wilson", prefabs, assets, common_postinit, master_postinit)
