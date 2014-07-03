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
--[[ GLOBALS ]]--
local _G = _G;
local unpack    = _G.unpack;
local select    = _G.select;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local classBarConstruct = {
	["PALADIN"] = function(frame)
		frame.HolyPower = MOD:CreatePaladinResourceBar(frame)
		frame.ClassBar = 'HolyPower'
	end,
	["WARLOCK"] = function(frame)
		frame.WarlockShards = MOD:CreateWarlockResourceBar(frame)
		frame.ClassBar = 'WarlockShards'
	end,
	["DEATHKNIGHT"] = function(frame)
		frame.Runes = MOD:CreateDeathKnightResourceBar(frame)
		frame.ClassBar = 'Runes'
	end,
	["DRUID"] = function(frame)
		frame.EclipseBar = MOD:CreateDruidResourceBar(frame)
		frame.ClassBar = 'EclipseBar'
	end,
	["MONK"] = function(frame)
		frame.MonkHarmony = MOD:CreateMonkResourceBar(frame)
		frame.ClassBar = 'MonkHarmony'
	end,
	["PRIEST"] = function(frame)
		frame.PriestOrbs = MOD:CreatePriestResourceBar(frame)
		frame.ClassBar = 'PriestOrbs';
	end,
	['MAGE'] = function(frame)
		frame.ArcaneChargeBar = MOD:CreateMageResourceBar(frame)
		frame.ClassBar = 'ArcaneChargeBar'
	end,
	["SHAMAN"] = function(frame)
		frame.TotemBars = MOD:CreateShamanResourceBar(frame)
		frame.ClassBar='TotemBars'
	end,
	["ROGUE"] = function(frame)
		frame.HyperCombo = MOD:CreateRoguePointTracker(frame)
	end,
	["HUNTER"] = function(frame) 
	end,
	['WARRIOR'] = function(frame) 
	end,
};
--[[ 
########################################################## 
CORE FUNCTION
##########################################################
]]--
function MOD:GetClassResources(frame)
	classBarConstruct[SuperVillain.class](frame)
end;