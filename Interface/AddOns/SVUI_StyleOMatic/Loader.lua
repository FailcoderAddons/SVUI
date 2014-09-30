--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
local AddonName, AddonObject = ...

assert(LibSuperVillain, AddonName .. " requires LibSuperVillain")

local PLUGIN = LibSuperVillain:NewPlugin(AddonName, AddonObject)

local Schema = PLUGIN.Schema;
local SV = _G["SVUI"];

SV.configs[Schema] = {
	["enable"] = true,
	["blizzard"] = {
		["enable"] = true, 
		["bags"] = true, 
		["bmah"] = true,
		["chat"] = true, 
		["reforge"] = true, 
		["calendar"] = true, 
		["achievement"] = true, 
		["lfguild"] = true, 
		["inspect"] = true, 
		["binding"] = true, 
		["gbank"] = true, 
		["archaeology"] = true, 
		["guildcontrol"] = true, 
		["gossip"] = true, 
		["guild"] = true, 
		["tradeskill"] = true, 
		["raid"] = false, 
		["talent"] = true, 
		["auctionhouse"] = true, 
		["barber"] = true, 
		["macro"] = true, 
		["debug"] = true, 
		["trainer"] = true, 
		["socket"] = true, 
		["loot"] = true, 
		["alertframes"] = true, 
		["bgscore"] = true, 
		["merchant"] = true, 
		["mail"] = true, 
		["help"] = true, 
		["trade"] = true, 
		["gossip"] = true, 
		["greeting"] = true, 
		["worldmap"] = true, 
		["taxi"] = true, 
		["quest"] = true, 
		["petition"] = true, 
		["dressingroom"] = true, 
		["pvp"] = true, 
		["lfg"] = true, 
		["nonraid"] = true, 
		["friends"] = true, 
		["spellbook"] = true, 
		["character"] = true, 
		["misc"] = true, 
		["tabard"] = true, 
		["guildregistrar"] = true, 
		["timemanager"] = true, 
		["encounterjournal"] = true, 
		["voidstorage"] = true, 
		["transmogrify"] = true, 
		["stable"] = true, 
		["bgmap"] = true, 
		["mounts"] = true, 
		["petbattleui"] = true, 
		["losscontrol"] = true, 
		["itemUpgrade"] = true, 
	}, 
	["addons"] = {
		["enable"] = true,
		["Skada"] = true, 
		["Recount"] = true,
		["AuctionLite"] = true,  
		["AtlasLoot"] = true, 
		["SexyCooldown"] = true, 
		["Lightheaded"] = true, 
		["Outfitter"] = true,
		["Quartz"] = true, 
		["TomTom"] = true, 
		["TinyDPS"] = true, 
		["Clique"] = true, 
		["CoolLine"] = true, 
		["ACP"] = true, 
		["DXE"] = true,
		["DBM-Core"] = true,
		["VEM"] = true,
		["MogIt"] = true, 
		["alDamageMeter"] = true, 
		["Omen"] = true, 
		["TradeSkillDW"] = true, 
	}
};