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
local pairs     = _G.pairs;
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local assert 	= _G.assert;
local math 		= _G.math;
--[[ MATH METHODS ]]--
local random = math.random;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local oUF_Villain = SV.oUF

assert(oUF_Villain, "SVUI was unable to locate oUF.")

local L = SV.L;
local MOD = SV.SVUnit
if(not MOD) then return end 

local DEFAULT_EFFECT = [[Spells\Fill_holy_cast_01.m2]];
-- local CASTEFFECT = [[Spells\Fel_fire_precast_high_hand.m2]]
-- local CASTEFFECT = [[Spells\Fire_precast_high_hand.m2]]
-- local CASTEFFECT = [[Spells\Fire_precast_low_hand.m2]]
-- local CASTEFFECT = [[Spells\Focused_casting_state.m2]]
-- local CASTEFFECT = [[Spells\Fill_holy_cast_01.m2]]
-- local CASTEFFECT = [[Spells\Fill_fire_cast_01.m2]]
-- local CASTEFFECT = [[Spells\Paladin_healinghands_state_01.m2]]
-- local CASTEFFECT = [[Spells\Fill_magma_cast_01.m2]]
-- local CASTEFFECT = [[Spells\Fill_shadow_cast_01.m2]]
-- local CASTEFFECT2 = [[Spells\Fill_arcane_precast_01.m2]]

-- local CASTEFFECT = [[Spells\Ice_cast_low_hand.m2]]

-- local CASTEFFECT = [[Spells\Immolate_state.m2]]
-- local CASTEFFECT = [[Spells\Immolate_state_v2_illidari.m2]]
-- local CASTEFFECT = [[Spells\Intervenetrail.m2]]

-- local CASTEFFECT = [[Spells\Invisibility_impact_base.m2]]
-- local CASTEFFECT2 = [[Spells\Fire_dot_state_chest.m2]]
-- local CASTEFFECT2 = [[Spells\Fire_dot_state_chest_jade.m2]]
-- local CASTEFFECT = [[Spells\Cast_arcane_01.m2]]
-- local CASTEFFECT2 = [[Spells\Spellsteal_missile.m2]] --SetPosition(0.2,-0.2,0.9)

-- local CASTEFFECT = [[Spells\Missile_bomb.m2]]

--local DEFAULT_EFFECT = [[Spells\Shadow_frost_weapon_effect.m2]]; --0.25
--local DEFAULT_EFFECT = [[Spells\Shadow_precast_high_base.m2]];
--local DEFAULT_EFFECT = [[Spells\Shadow_precast_high_hand.m2]];
--local DEFAULT_EFFECT = [[Spells\Shadow_precast_low_hand.m2]];
--local DEFAULT_EFFECT = [[Spells\Shadow_precast_med_base.m2]];
--local DEFAULT_EFFECT = [[Spells\Shadow_precast_uber_hand.m2]]; --SetPosition(-0.21,-0.11,0)
--local DEFAULT_EFFECT = [[Spells\Shadow_strikes_state_hand.m2]];
--local DEFAULT_EFFECT = [[Spells\Shadowbolt_missile.m2]]; --SetPosition(-0.21,-0.03,0)
--local DEFAULT_EFFECT = [[Spells\Shadowworddominate_chest.m2]];
--local DEFAULT_EFFECT = [[Spells\Infernal_smoke_rec.m2]];
--local DEFAULT_EFFECT = [[Spells\Largebluegreenradiationfog.m2]];
--local DEFAULT_EFFECT = [[Spells\Leishen_lightning_fill.m2]];
--local DEFAULT_EFFECT = [[Spells\Mage_arcanebarrage_missile.m2]];
--local DEFAULT_EFFECT = [[Spells\Mage_firestarter.m2]];
--local DEFAULT_EFFECT = [[Spells\Mage_greaterinvis_state_chest.m2]];
--local DEFAULT_EFFECT = [[Spells\Magicunlock.m2]];
--local DEFAULT_EFFECT = [[Spells\Chiwave_impact_hostile.m2]];
--local DEFAULT_EFFECT = [[Spells\Cripple_state_base.m2]];
--local DEFAULT_EFFECT = [[Spells\Monk_expelharm_missile.m2]];
--local DEFAULT_EFFECT = [[Spells\Monk_forcespere_orb.m2]];
--local DEFAULT_EFFECT = [[Spells\Fill_holy_cast_01.m2]]
--local DEFAULT_EFFECT = [[Spells\Fill_fire_cast_01.m2]]
--local DEFAULT_EFFECT = [[Spells\Fill_lightning_cast_01.m2]]
--local DEFAULT_EFFECT = [[Spells\Fill_magma_cast_01.m2]]
--local DEFAULT_EFFECT = [[Spells\Fill_shadow_cast_01.m2]]
--local DEFAULT_EFFECT = [[Spells\Sprint_impact_chest.m2]]
--local DEFAULT_EFFECT = [[Spells\Spellsteal_missile.m2]] --SetPosition(0,-1.8,0.9)
--local DEFAULT_EFFECT = [[Spells\Warlock_destructioncharge_impact_chest.m2]]
--local DEFAULT_EFFECT = [[Spells\Warlock_destructioncharge_impact_chest_fel.m2]]
--local DEFAULT_EFFECT = [[Spells\Xplosion_twilight_impact_noflash.m2]]
--local DEFAULT_EFFECT = [[Spells\Warlock_bodyofflames_medium_state_shoulder_right_purple.m2]]
--local DEFAULT_EFFECT = [[Spells\Blink_impact_chest.m2]]
--local DEFAULT_EFFECT = [[Spells\Christmassnowrain.m2]]
--local DEFAULT_EFFECT = [[Spells\Detectinvis_impact_base.m2]]
--local DEFAULT_EFFECT = [[Spells\Eastern_plaguelands_beam_effect.m2]]

--local ORB_EFFECT = [[Spells\battlemasterglow_high.m2]]
--local ORB_EFFECT = [[Spells\blueflame_low.m2]]
--local ORB_EFFECT = [[Spells\greenflame_low.m2]]
--local ORB_EFFECT = [[Spells\purpleglow_high.m2]]
--local ORB_EFFECT = [[Spells\redflame_low.m2]]
--local ORB_EFFECT = [[Spells\poisondrip.m2]]

--local ORB_EFFECT = [[Spells\savageryglow_high.m2]]
--local ORB_EFFECT = [[Spells\spellsurgeglow_high.m2]]
--local ORB_EFFECT = [[Spells\sunfireglow_high.m2]]
--local ORB_EFFECT = [[Spells\whiteflame_low.m2]]
--local ORB_EFFECT = [[Spells\yellowflame_low.m2]]
--local ORB_EFFECT = [[Spells\Food_healeffect_base.m2]]

--local ORB_EFFECT = [[Spells\Bloodlust_state_hand.m2]]
--local ORB_EFFECT = [[Spells\Deathwish_state_hand.m2]]
--local ORB_EFFECT = [[Spells\Disenchant_precast_hand.m2]]
--local ORB_EFFECT = [[Spells\Enchant_cast_hand.m2]]

--local ORB_EFFECT = [[Spells\Eviscerate_cast_hands.m2]]
--local ORB_EFFECT = [[Spells\Fire_blue_precast_hand.m2]]
--local ORB_EFFECT = [[Spells\Fire_blue_precast_high_hand.m2]]

--local ORB_EFFECT = [[Spells\Fire_precast_hand.m2]]
--local ORB_EFFECT = [[Spells\Fire_precast_hand_pink.m2]]
--local ORB_EFFECT = [[Spells\Fire_precast_hand_sha.m2]]
--local ORB_EFFECT = [[Spells\Fire_precast_high_hand.m2]]
--local ORB_EFFECT = [[Spells\Fire_precast_low_hand.m2]]

--local ORB_EFFECT = [[Spells\Ice_precast_high_hand.m2]]

--local ORB_EFFECT = [[Spells\Sand_precast_hand.m2]]
--local ORB_EFFECT = [[Spells\Solar_precast_hand.m2]]
--local ORB_EFFECT = [[Spells\Twilight_fire_precast_high_hand.m2]]
--local ORB_EFFECT = [[Spells\Vengeance_state_hand.m2]]
--local ORB_EFFECT = [[Spells\Fel_djinndeath_fire_02.m2]]
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local EffectModel_OnShow = function(self)
	local EFFECT = self.EffectModel.modelFile or DEFAULT_EFFECT;
	self.EffectModel:ClearModel();
	self.EffectModel:SetModel(EFFECT);
end 
--[[ 
########################################################## 
PRIEST
##########################################################
]]--
function MOD:CreateModelEffect(parent, zoom, outSet, modelFile, pos1, pos2, pos3)
	modelFile = modelFile or DEFAULT_EFFECT
	pos1 = pos1 or 0
	pos2 = pos2 or 0
	pos3 = pos3 or 0
	local effectFrame = CreateFrame("PlayerModel", nil, parent)
	effectFrame:SetAllPointsOut(parent, outSet, outSet)
	effectFrame:SetCamDistanceScale(zoom)
	effectFrame:SetPosition(-0.21,-0.15,0)
	effectFrame:SetPortraitZoom(0)
	effectFrame:SetModel(modelFile)
	effectFrame.modelFile = modelFile
	parent.EffectModel = effectFrame
	if(parent:GetScript("OnShow")) then
		parent:HookScript("OnShow", EffectModel_OnShow)
	else
		parent:SetScript("OnShow", EffectModel_OnShow)
	end
end 