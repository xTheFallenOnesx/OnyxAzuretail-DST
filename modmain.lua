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
local azuretiara_recipe = AddRecipe("azuretiara",
{
    GLOBAL.Ingredient("goldnugget", 3), 
    GLOBAL.Ingredient("charcoal", 1), 
    GLOBAL.Ingredient("ash", 2)
},
RECIPETABS.DRESS, TECH.NONE,
nil, nil, nil, nil, nil,
"images/inventoryimages/azuretiara.xml", "azuretiara.tex")
azuretiara_recipe.tagneeded = true
azuretiara_recipe.builder_tag = "azurebuilder"


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

