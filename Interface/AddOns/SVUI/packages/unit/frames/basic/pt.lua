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
function MOD.Construct:pettarget(frame)
	MOD:SetActionPanel(frame)
	frame.Health = MOD:CreateHealthBar(frame, true, true, "RIGHT")
	frame.Power = MOD:CreatePowerBar(frame, true, true, "LEFT")
	frame.Name = MOD:CreateNameText(frame, "pettarget")
	frame.Buffs = MOD:CreateBuffs(frame)
	frame.Debuffs = MOD:CreateDebuffs(frame)
	frame.Range = { insideAlpha = 1, outsideAlpha = 1 }
	frame:Point("BOTTOM", SVUI_Pet, "TOP", 0, 7)
	SuperVillain:SetSVMovable(frame, frame:GetName().."_MOVE", L["PetTarget Frame"], nil, -7, nil, "ALL, SOLO")
end 
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD.FrameUpdate:pettarget(unit, frame, db)
	frame.db = db;
	local UNIT_WIDTH = db.width;
	local UNIT_HEIGHT = db.height;
	frame.unit = unit;
	frame:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
	frame.colors = oUF_SuperVillain.colors;
	frame:Size(UNIT_WIDTH, UNIT_HEIGHT)
	_G[frame:GetName().."_MOVE"]:Size(frame:GetSize())
	MOD:RefreshUnitLayout(frame, "pettarget")
	frame:UpdateAllElements()
end