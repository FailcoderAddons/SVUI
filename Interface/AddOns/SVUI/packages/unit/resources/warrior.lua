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
local SV = select(2, ...)
local oUF_Villain = SV.oUF

local assert = assert;
assert(oUF_Villain, "SVUI was unable to locate oUF.")

local L = SV.L;
if(SV.class ~= "WARRIOR") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end

local ORB_ICON = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\Class\ORB]];
local ORB_BG = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\Class\ORB-BG]];
SV.SpecialFX:Register("conqueror", [[Spells\Warlock_destructioncharge_impact_chest.m2]], 2, -2, -2, 2, 0.9, 0, 0.8)
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local OnMove = function()
  SV.db.SVUnit.player.classbar.detachFromFrame = true
end

local Reposition = function(self)
	local db = SV.db.SVUnit.player
	local bar = self.Conqueror;
	local max = self.MaxClassPower;
	local size = db.classbar.height
	local width = size * max;

	bar.Holder:SetSizeToScale(width, size)
  if(not db.classbar.detachFromFrame) then
  	SV.Mentalo:Reset(L["Classbar"])
  end
  local holderUpdate = bar.Holder:GetScript('OnSizeChanged')
  if holderUpdate then
      holderUpdate(bar.Holder)
  end

  bar:ClearAllPoints()
  bar:SetAllPoints(bar.Holder)
end

local EffectModel_OnShow = function(self)
	self:SetEffect("conqueror");
end

function MOD:CreateClassBar(playerFrame)
	local max = 6
	local bar = CreateFrame("Frame",nil,playerFrame)

	bar:SetFrameLevel(playerFrame.TextGrip:GetFrameLevel() + 30)
	--SV.SpecialFX:SetFXFrame(bar, "conqueror")
	--bar.FX:SetFrameStrata("BACKGROUND")
	--bar.FX:SetFrameLevel(playerFrame.TextGrip:GetFrameLevel() + 1)

	local bgFrame = CreateFrame("Frame", nil, bar)
	bgFrame:SetAllPointsIn(bar, 1, 4)
	SV.SpecialFX:SetFXFrame(bgFrame, "conqueror")

	local bgTexture = bgFrame:CreateTexture(nil, "BACKGROUND")
	bgTexture:SetAllPoints(bgFrame)
	bgTexture:SetTexture(0.2,0,0,0.5)

	local borderB = bgFrame:CreateTexture(nil,"OVERLAY")
  borderB:SetTexture(0,0,0)
  borderB:SetPoint("BOTTOMLEFT")
  borderB:SetPoint("BOTTOMRIGHT")
  borderB:SetHeight(2)

  local borderT = bgFrame:CreateTexture(nil,"OVERLAY")
  borderT:SetTexture(0,0,0)
  borderT:SetPoint("TOPLEFT")
  borderT:SetPoint("TOPRIGHT")
  borderT:SetHeight(2)

  local borderL = bgFrame:CreateTexture(nil,"OVERLAY")
  borderL:SetTexture(0,0,0)
  borderL:SetPoint("TOPLEFT")
  borderL:SetPoint("BOTTOMLEFT")
  borderL:SetWidth(2)

  local borderR = bgFrame:CreateTexture(nil,"OVERLAY")
  borderR:SetTexture(0,0,0)
  borderR:SetPoint("TOPRIGHT")
  borderR:SetPoint("BOTTOMRIGHT")
  borderR:SetWidth(2)

  bar.bg = bgTexture;

	local enrage = CreateFrame("StatusBar", nil, bgFrame)
	enrage.noupdate = true;
	enrage:SetAllPointsIn(bgFrame)
	enrage:SetOrientation("HORIZONTAL")
	enrage:SetStatusBarTexture(SV.Media.bar.glow)
  enrage:SetStatusBarColor(1, 0, 0, 0.75)

  bgFrame.bar = enrage;
  --SV.SpecialFX:SetFXFrame(enrage, "conqueror", true)
	--enrage.FX:SetScript("OnShow", EffectModel_OnShow)
	bar.Enrage = bgFrame;


	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", bar)
	classBarHolder:SetPointToScale("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"], nil, OnMove)

	playerFrame.MaxClassPower = max
	playerFrame.ClassBarRefresh = Reposition

	playerFrame.Conqueror = bar
	return 'Conqueror'  
end 