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
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
-- local MYSTERY_MODEL_FILE = [[Spells\Blackmagic_precast_base.m2]];
-- local MYSTERY_MODEL_FILE = [[Spells\Crow_baked.m2]];
local WORKING_MODEL_FILE = [[Spells\Monk_travelingmist_missile.m2]];
-- local WORKING_MODEL_FILE = [[Spells\monsterlure01.m2]];
-- local WORKING_MODEL_FILE = [[interface\buttons\talktome_gears.m2]];
-- local DEAD_MODEL_FILE = [[creature\Ghostlyskullpet\ghostlyskullpet.m2]];
-- local DEAD_MODEL_FILE = [[creature\ghost\ghost.m2]];
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
local function UpdatePortraitColors(portrait, unit)
	local r,g,b = 0.25,0.25,0.25
	if (UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
		r,g,b = 0.5,0.5,0.5
	elseif not UnitIsPlayer(unit)then 
		local unitReact = oUF_SuperVillain.colors.reaction[UnitReaction(unit,"player")]
		if(unitReact ~= nil) then 
			r,g,b = unitReact[1], unitReact[2], unitReact[3] 
		end;
	else 
		local unitClass = select(2,UnitClass(unit))
		if unitClass then 
			r,g,b = unpack(oUF_SuperVillain.colors.class[unitClass]) 
		end 
	end
	portrait:SetBackdropColor(r,g,b)
	if portrait.UpdateColor then 
		portrait:UpdateColor(r,g,b)
	end
end;

local UpdatePortrait = function(self, event, unit)
	if(not unit or not UnitIsUnit(self.unit, unit)) then return end
	local portrait = self.Portrait
	SetPortraitTexture(portrait, unit)
end
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreatePortrait(frame,smallUnit,isPlayer)
	-- 3D Portrait
	local portrait3D = CreateFrame("PlayerModel",nil,frame)
	portrait3D:SetFrameStrata("LOW")
	portrait3D:SetFrameLevel(2)

	if smallUnit then 
		portrait3D:SetPanelTemplate("UnitSmall")
	else 
		portrait3D:SetPanelTemplate("UnitLarge")
	end;

	local overlay = CreateFrame("Frame",nil,portrait3D)
	overlay:SetAllPoints(portrait3D.Panel)
	overlay:SetFrameLevel(3)
	portrait3D.overlay = overlay;
	portrait3D.UserRotation = 0;
	portrait3D.UserCamDistance = 1.3;

	-- 2D Portrait
	local portrait2Danchor = CreateFrame('Frame',nil,frame)
	portrait2Danchor:SetFrameStrata("LOW")
	portrait2Danchor:SetFrameLevel(2)

	local portrait2D = portrait2Danchor:CreateTexture(nil,'OVERLAY')
	portrait2D:SetTexCoord(0.15,0.85,0.15,0.85)
	portrait2D:SetAllPoints(portrait2Danchor)
	portrait2D.anchor = portrait2Danchor;
	if smallUnit then 
		portrait2Danchor:SetFixedPanelTemplate("UnitSmall")
	else 
		portrait2Danchor:SetFixedPanelTemplate("UnitLarge")
	end;
	portrait2D.Panel = portrait2Danchor.Panel;

	local overlay = CreateFrame("Frame",nil,portrait2Danchor)
	overlay:SetAllPoints(portrait2D.Panel)
	overlay:SetFrameLevel(3)
	portrait2D.overlay = overlay;

	-- Set Updates
	portrait2D.Override = UpdatePortrait
	portrait3D.Override = MOD.Update3DPortrait

	-- Assign To Frame
	frame.PortraitModel = portrait3D;
	frame.PortraitTexture = portrait2D;
end;

function MOD:Update3DPortrait(event, unit)
	if(not unit or not UnitIsUnit(self.unit, unit)) then return end
	local portrait = self.Portrait
	if(not portrait:IsObjectType'Model') then return; end
	local guid = UnitGUID(unit)
	local camera = portrait.UserCamDistance or 1
	local rotate = portrait.UserRotation
	if(not UnitExists(unit) or not UnitIsConnected(unit) or not UnitIsVisible(unit) or (unit ~= "player" and UnitIsDeadOrGhost(unit))) then
		portrait:SetCamDistanceScale(1)
		portrait:SetPortraitZoom(0)
		portrait:SetPosition(4,-1,1)
		portrait:ClearModel()
		portrait:SetModel(WORKING_MODEL_FILE)
		portrait.guid = nil
	else
		portrait.isdead = nil
		portrait:SetAlpha(1)
		if(portrait.guid ~= guid or event == 'UNIT_MODEL_CHANGED') then
			portrait:SetCamDistanceScale(camera)
			portrait:SetPortraitZoom(1)
			portrait:SetPosition(0,0,0)
			portrait:ClearModel()
			portrait:SetUnit(unit)
			portrait.guid = guid

			if(rotate and portrait:GetFacing() ~= rotate / 60) then 
				portrait:SetFacing(rotate / 60)
			end;
		end
		
	end
	UpdatePortraitColors(portrait, unit) 
end