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
--]]
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
local ceil,tinsert = math.ceil,table.insert
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD.Construct:pet(frame)
	MOD:SetActionPanel(frame, "pet")
	frame.Health = MOD:CreateHealthBar(frame, true, true)
	frame.Health.frequentUpdates = true;
	frame.Power = MOD:CreatePowerBar(frame, true, true, "LEFT")
	frame.Power.frequentUpdates = false;
	MOD:CreatePortrait(frame, true)
	frame.Name = MOD:CreateNameText(frame, "pet")
	frame.Name:ClearAllPoints()
	frame.Name:SetParent(frame.InfoPanel)
	frame.Name:Point("CENTER", frame.InfoPanel, "CENTER")
	frame.Buffs = MOD:CreateBuffs(frame)
	frame.RaidIcon = MOD:CreateRaidIcon(frame)
	frame.Debuffs = MOD:CreateDebuffs(frame)
	frame.Castbar = MOD:CreateCastbar(frame, false, nil, false)
	frame.HealPrediction = MOD:CreateHealPrediction(frame)
	frame.AuraWatch = MOD:CreateAuraWatch(frame)
	frame.Range = { insideAlpha = 1, outsideAlpha = 1 }
	frame:Point("BOTTOM", SuperVillain.UIParent, "BOTTOM", 0, 182)
	SuperVillain:SetSVMovable(frame, frame:GetName().."_MOVE", L["Pet Frame"], nil, nil, nil, "ALL, SOLO")
end 
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD.FrameUpdate:pet(unit, frame, db)
	frame.db = db;
	local UNIT_WIDTH = db.width;
	local UNIT_HEIGHT = db.height;
	frame.unit = unit;
	frame:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
	frame.colors = oUF_SuperVillain.colors;
	frame:Size(UNIT_WIDTH, UNIT_HEIGHT)
	_G[frame:GetName().."_MOVE"]:Size(frame:GetSize())
	MOD:RefreshUnitLayout(frame, "pet")
	do 
		if SVUI_Player and not InCombatLockdown()then 
			frame:SetParent(SVUI_Player)
		end 
	end 
	MOD:UpdateAuraWatch(frame)
	frame:UpdateAllElements()
end