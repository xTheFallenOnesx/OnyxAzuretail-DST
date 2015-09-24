PrefabFiles = {
	"onyxazuretail",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/onyxazuretail.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/onyxazuretail.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/onyxazuretail.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/onyxazuretail.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/onyxazuretail_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/onyxazuretail_silho.xml" ),

    Asset( "IMAGE", "bigportraits/onyxazuretail.tex" ),
    Asset( "ATLAS", "bigportraits/onyxazuretail.xml" ),
	
	Asset( "IMAGE", "images/map_icons/onyxazuretail.tex" ),
	Asset( "ATLAS", "images/map_icons/onyxazuretail.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_onyxazuretail.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_onyxazuretail.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_onyxazuretail.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_onyxazuretail.xml" ),

}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

local resolvefilepath = GLOBAL.resolvefilepath
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local TECH = GLOBAL.TECH


-- Recipes
--local azuretiara_recipe = AddRecipe("azuretiara",
--{
   --GLOBAL.Ingredient("goldnugget", 3), 
  --GLOBAL.Ingredient("charcoal", 1), 
    --GLOBAL.Ingredient("ash", 2)
--},
--RECIPETABS.DRESS, TECH.NONE,
--nil, nil, nil, nil, nil,
--"images/inventoryimages/azuretiara.xml", "azuretiara.tex")
--azuretiara_recipe.tagneeded = true
--azuretiara_recipe.builder_tag = "azurebuilder"


-- The character select screen lines
STRINGS.CHARACTER_TITLES.onyxazuretail = "The Azuretail"
STRINGS.CHARACTER_NAMES.onyxazuretail = "Onyx"
STRINGS.CHARACTER_DESCRIPTIONS.onyxazuretail = "*Can breathe blue fire\n*Radiates Heat\n*Is a great chef\n*Has great vision\n*Physically Weaker"
STRINGS.CHARACTER_QUOTES.onyxazuretail = "\"Ohhh, Shiny!\""

-- Custom speech strings
STRINGS.CHARACTERS.ONYXAZURETAIL = require "speech_onyxazuretail"

-- The character's name as appears in-game 
STRINGS.NAMES.ONYXAZURETAIL = "OnyxAzuretail"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ONYXAZURETAIL = 
{
	GENERIC = "It's Onyx!",
	ATTACKER = "That Onyx looks shifty...",
	MURDERER = "Murderer!",
	REVIVER = "Onyx, Friend of Ghosts.",
	GHOST = "Onyx could use a heart.",
}


AddMinimapAtlas("images/map_icons/onyxazuretail.xml")

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("onyxazuretail", "FEMALE")

-- ?
PrefabFiles = {
	"splashfireball",
}

-- Can breathe blue fire

local require = GLOBAL.require

local easing = require("easing")
local fx = require("fx")
local Text = require "widgets/text"

local ActionHandler = GLOBAL.ActionHandler
local BODYTEXTFONT = GLOBAL.BODYTEXTFONT
local COLLISION = GLOBAL.COLLISION
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES
local SpawnPrefab = GLOBAL.SpawnPrefab
local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local Vector3 = GLOBAL.Vector3


-- The fire, but blue
local spitfx = {
	name = "bluefiresplash_fx",
	bank = "dragonfly_ground_fx",
	build = "dragonfly_ground_fx",
	anim = "idle",
	bloom = true,
	tint = { x = 0, y = 183/255, z = 1, tintalpha = 1 },
}
table.insert(fx, spitfx)

-- Meaty part done by gregdwilson in his dragon mod, I just adjusted it
local SPITFIRE = AddAction("SPITFIRE", "Breathe Fire", function(act)
	local attacker = act.doer
	local target = act.target
	local targetPos = target and Vector3(target.Transform:GetWorldPosition()) or act.pos
	local x, y, z = attacker.Transform:GetWorldPosition()
	local dx = targetPos.x - x
	local dz = targetPos.z - z
	local rangesq = dx * dx + dz * dz
	local attackeroffset = Vector3(0, 3, 0)
	local numberofprojectiles = 20
	local maxrange = 20
	local speed = easing.linear(rangesq, 15, 8, maxrange * maxrange)
	local attackerPos = Vector3(attacker.Transform:GetWorldPosition()) + attackeroffset
	attacker.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
	
	for i = 1, numberofprojectiles, 1 do
		local projectile = SpawnPrefab("splashfireball")
		projectile.Transform:SetPosition(attacker.Transform:GetWorldPosition())
		projectile.Transform:SetScale(1.5, 1.5, 1.5)
		projectile.components.complexprojectile:SetHorizontalSpeed(speed)
		projectile.components.complexprojectile:SetGravity(-10)
		projectile.components.complexprojectile:SetTargetOffset({ x = 0, y = 0, z = 0 })
		projectile.components.complexprojectile.usehigharc = false
		projectile.components.complexprojectile.attacker = attacker

			projectile.components.complexprojectile:SetOnHit(function(projectile, attacker)
				local x, y, z = projectile.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, 3) -- or we could include a flag to the search?
				for i, target in ipairs(ents) do
					if target ~= attacker and target.entity:IsVisible() then
						if target then
							if target.components.burnable and not target.components.burnable:IsBurning() then
								if target.components.freezable and target.components.freezable:IsFrozen() then           
									target.components.freezable:Unfreeze()            
								else           
									if target.components.fueled and target:HasTag("campfire") and target:HasTag("structure") then
										-- Rather than worrying about adding fuel cmp here, just spawn some fuel and immediately feed it to the fire
										local fuel = SpawnPrefab("cutgrass")
										if fuel then
											target.components.fueled:TakeFuelItem(fuel)
										end
									else
										target.components.burnable:Ignite(true)
									end
								end  
							end

							if target.components.freezable then
								target.components.freezable:AddColdness(-1) --Does this break ice staff?
								if target.components.freezable:IsFrozen() then
									target.components.freezable:Unfreeze()            
								end
							end

							if target.components.sleeper and target.components.sleeper:IsAsleep() then
								target.components.sleeper:WakeUp()
							end

							if target.components.combat then
								target.components.combat:SuggestTarget(attacker)
							end
							target:PushEvent("attacked", {attacker = attacker, damage = 0})
						end
					end
				end

				projectile.components.groundpounder:GroundPound()
				projectile:Remove()
			end)

		projectile.components.complexprojectile:SetOnLaunch(function()
			projectile:AddTag("NOCLICK")
			projectile.persists = false

			projectile.AnimState:PlayAnimation("fire_spin_loop", true)

			projectile.Physics:SetMass(1)
			projectile.Physics:SetCapsule(0.01, 0.01)
			projectile.Physics:SetFriction(0)
			projectile.Physics:SetDamping(0)
			projectile.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
			projectile.Physics:ClearCollisionMask()
			projectile.Physics:CollidesWith(COLLISION.WORLD)
			projectile.Physics:CollidesWith(COLLISION.OBSTACLES)
			projectile.Physics:CollidesWith(COLLISION.ITEMS)
			projectile.Physics:CollidesWith(COLLISION.CHARACTERS)
			projectile.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
			projectile.Physics:CollidesWith(COLLISION.GIANTS)
			projectile.Physics:CollidesWith(COLLISION.GROUND)
		end)

		projectile.components.complexprojectile:Launch(targetPos, attacker)

		local pos = projectile.components.complexprojectile.inst:GetPosition()
		projectile.components.complexprojectile.owningweapon = owningweapon or projectile.components.complexprojectile

		projectile.Transform:SetPosition(pos:Get())

		targetPos.x = targetPos.x - 1 + 2 * math.random()
		targetPos.y = targetPos.y - 1 + 2 * math.random()
		targetPos.z = targetPos.z - 1 + 2 * math.random()

		projectile.components.complexprojectile:CalculateTrajectory(pos, targetPos, projectile.components.complexprojectile.horizontalSpeed)

		if projectile.components.complexprojectile.onlaunchfn ~= nil then
			projectile.components.complexprojectile.onlaunchfn(projectile.components.complexprojectile.inst)
		end
		projectile.components.complexprojectile.inst:StartUpdatingComponent(projectile.components.complexprojectile)
	end
	act.doer:PushEvent("fueleaten", -2)
	return true
end)

-- Action is with right click, distance is within 10
SPITFIRE.rmb = true
SPITFIRE.distance = 10
SPITFIRE.priority = -2


-- The stategraph state for spitting
local spitstate = State {
	name = "spitfire",
	tags = { "busy", "yawn", "pausepredict" },
	onenter = function(inst, data)
		inst.components.locomotor:Stop()
		if inst.components.playercontroller ~= nil then
			inst.components.playercontroller:RemotePausePrediction()
		end
		inst.AnimState:PlayAnimation("yawn")
	end,
	timeline = {
		TimeEvent(18 * FRAMES, function(inst) inst:PerformBufferedAction() end),
	},
	events = {
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:RemoveStateTag("yawn")
				inst.sg:GoToState("idle")
			end
		end),
	},
}
-- The handler that makes the buffered spit action go to our state
local spithandler = ActionHandler(SPITFIRE, "spitfire")

AddStategraphState("wilson", spitstate)
AddStategraphActionHandler("wilson", spithandler)


-- We add the spit action if there aren't any others available
AddComponentPostInit("playeractionpicker", function(self)
	if not self.inst:HasTag("spitdragon") then
		return
	end
	local old_GRA = self.GetRightClickActions
	self.GetRightClickActions = function(self, position, target)
		local ret = old_GRA(self, position, target)
		if not self.inst:HasTag("playerghost") and self.inst:HasTag("canspitfire") and (target or position) then
			local actions = { SPITFIRE }
			for k, v in pairs(ret) do
				table.insert(actions, v.action)
			end
			return self:SortActionList(actions, target or position, nil, true)
		end
		return ret
	end
end)

-- Small number that tells us our fire charges
AddClassPostConstruct("widgets/statusdisplays", function(self)
	if not self.owner:HasTag("spitdragon") then
		return
	end
	self.spitcharges = self:AddChild(Text(BODYTEXTFONT, 30, "0"))
	self.spitcharges:SetPosition(60, -80, 0)
	self.owner:ListenForEvent("spitchargedelta", function(inst) self.spitcharges:SetString(inst.spitcharges:value()) end)
end)

-- Fuel prefabs and fuel values
local spitfuel = {
	charcoal = 1,
	nitre = 2,
}

-- Assigning component for fuel
for k, v in pairs(spitfuel) do
	AddPrefabPostInit(k, function(inst)
		inst:AddComponent("spitfuel")
		inst.components.spitfuel.fuelvalue = v
	end)
end

-- Fuel eating action, we handle the fuel delta on prefab
local PROCESSFUEL = AddAction("PROCESSFUEL", "Consume", function(act)
	if act.doer and act.doer:HasTag("spitdragon") then
		local obj = act.target or act.invobject
		if obj and obj:HasTag("spitedible") then
			act.doer:PushEvent("fueleaten", obj.components.spitfuel.fuelvalue)
			if obj.components.stackable then
				obj.components.stackable:Get():Remove()
			else
				obj:Remove()
			end
			return true
		end
	end
	return true
end)
PROCESSFUEL.rmb = true

-- Fuel eating state
local processhandler = ActionHandler(PROCESSFUEL, "eat")
AddStategraphActionHandler("wilson", processhandler)
AddStategraphActionHandler("wilson_client", processhandler)

-- With this, we right click inventory fuel to eat it
local function invspfu(inst, doer, actions, right)
	if doer:HasTag("spitdragon") and inst:HasTag("spitedible") then
		table.insert(actions, PROCESSFUEL)
	end
end
AddComponentAction("INVENTORY", "spitfuel", invspfu)
