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
local frameNumber, lastFrame = 0
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD.Construct:boss(frame)
	MOD:SetActionPanel(frame)
	frame.Health = MOD:CreateHealthBar(frame, true, true, true)
	frame.Power = MOD:CreatePowerBar(frame, true, true, "RIGHT")
	frame.Name = MOD:CreateNameText(frame, "boss")
	MOD:CreatePortrait(frame)
	frame.Buffs = MOD:CreateBuffs(frame)
	frame.Debuffs = MOD:CreateDebuffs(frame)
	frame.Afflicted = MOD:CreateAfflicted(frame)
	frame.Castbar = MOD:CreateCastbar(frame, true, nil, true, nil, true)
	frame.RaidIcon = MOD:CreateRaidIcon(frame)
	frame.AltPowerBar = MOD:CreateAltPowerBar(frame)
	frame.Range = { insideAlpha = 1, outsideAlpha = 1 }
	frame:SetAttribute("type2", "focus")
	local frameName = frame:GetName()
	frameNumber = frameNumber + 1
	if(not _G["SVUI_Boss_MOVE"]) then
		frame:Point("RIGHT", SuperVillain.UIParent, "RIGHT", -105, 0)
		SuperVillain:SetSVMovable(frame, "SVUI_Boss_MOVE", L["Boss Frames"], nil, nil, nil, "ALL, PARTY, RAID10, RAID25, RAID40")
	else
		frame:Point("TOPRIGHT", lastFrame, "BOTTOMRIGHT", 0, -20)
	end
	lastFrame = frame
end
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD.FrameUpdate:boss(unit, frame, db)
	frame.db = db;
	frameNumber = frame.index;
	local holder = _G["SVUI_Boss_MOVE"]
	local UNIT_WIDTH = db.width;
	local UNIT_HEIGHT = db.height;
	frame.unit = unit;
	frame.colors = oUF_SuperVillain.colors;
	frame:Size(UNIT_WIDTH, UNIT_HEIGHT)
	frame:ClearAllPoints()
	if frameNumber == 1 then
		holder:Width(UNIT_WIDTH)
		holder:Height(UNIT_HEIGHT + (UNIT_HEIGHT + 12 + db.castbar.height) * 4)
		if db.showBy == "UP"then 
			frame:Point("BOTTOMRIGHT", holder, "BOTTOMRIGHT")
		else 
			frame:Point("TOPRIGHT", holder, "TOPRIGHT")
		end 
	else
		local yOffset = (UNIT_HEIGHT + 12 + db.castbar.height) * (frameNumber - 1)
		if db.showBy == "UP"then 
			frame:Point("BOTTOMRIGHT", holder, "BOTTOMRIGHT", 0, yOffset)
		else 
			frame:Point("TOPRIGHT", holder, "TOPRIGHT", 0, -yOffset)
		end 
	end 

	frame:RegisterForClicks(MOD.db.fastClickTarget and"AnyDown"or"AnyUp")

	MOD:RefreshUnitLayout(frame, "boss")
	frame:UpdateAllElements()
end 