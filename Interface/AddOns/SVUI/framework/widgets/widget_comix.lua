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
local unpack 	= _G.unpack;
local select 	= _G.select;
local math 		= _G.math;
--[[ MATH METHODS ]]--
local random = math.random;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L

SV.Comix = CreateFrame("Frame");
SV.Comix.Basic = _G["SVUI_ComixFrame1"]
SV.Comix.Deluxe = _G["SVUI_ComixFrame2"]
SV.Comix.Premium = _G["SVUI_ComixFrame3"]
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local animReady = true;
local playerGUID;
local COMIX_DATA = {
	{
		{0,0.25,0,0.25},
		{0.25,0.5,0,0.25},
		{0.5,0.75,0,0.25},
		{0.75,1,0,0.25},
		{0,0.25,0.25,0.5},
		{0.25,0.5,0.25,0.5},
		{0.5,0.75,0.25,0.5},
		{0.75,1,0.25,0.5},
		{0,0.25,0.5,0.75},
		{0.25,0.5,0.5,0.75},
		{0.5,0.75,0.5,0.75},
		{0.75,1,0.5,0.75},
		{0,0.25,0.75,1},
		{0.25,0.5,0.75,1},
		{0.5,0.75,0.75,1},
		{0.75,1,0.75,1}
	},
	{
		{220, 210, 50, -50, 220, 210, -1, 5},
	    {230, 210, 50, 5, 280, 210, -5, 1},
	    {280, 160, 1, 50, 280, 210, -1, 5},
	    {220, 210, 50, -50, 220, 210, -1, 5},
	    {210, 190, 50, 50, 220, 210, -1, 5},
	    {220, 210, 50, -50, 220, 210, -1, 5},
	    {230, 210, 50, 5, 280, 210, -5, 1},
	    {280, 160, 1, 50, 280, 210, -1, 5},
	    {220, 210, 50, -50, 220, 210, -1, 5},
	    {210, 190, 50, 50, 220, 210, -1, 5},
	    {220, 210, 50, -50, 220, 210, -1, 5},
	    {230, 210, 50, 5, 280, 210, -5, 1},
	    {280, 160, 1, 50, 280, 210, -1, 5},
	    {220, 210, 50, -50, 220, 210, -1, 5},
	    {210, 190, 50, 50, 220, 210, -1, 5},
	    {210, 190, 50, 50, 220, 210, -1, 5}
	}
};
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function SV.Comix:ReadyState(state)
	if(state == nil) then return animReady end
	animReady = state
end

function SV.Comix:LaunchPremiumPopup()
	local rng = random(1, 16);
	local coords = COMIX_DATA[1][rng];
	local offsets = COMIX_DATA[2][rng]

	self.Premium.tex:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
	self.Premium.bg.tex:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
	self.Premium.anim[1]:SetOffset(offsets[1],offsets[2])
	self.Premium.anim[2]:SetOffset(offsets[3],offsets[4])
	self.Premium.anim[3]:SetOffset(0,0)
	self.Premium.bg.anim[1]:SetOffset(offsets[5],offsets[6])
	self.Premium.bg.anim[2]:SetOffset(offsets[7],offsets[8])
	self.Premium.bg.anim[3]:SetOffset(0,0)
	self.Premium.anim:Play()
	self.Premium.bg.anim:Play() 
end

function SV.Comix:LaunchDeluxePopup()
	local rng = random(1, 16);
	local coords = COMIX_DATA[1][rng];
	local step1_x = random(-100, 100);
	if(step1_x > -30 and step1_x < 30) then step1_x = step1_x * 3 end 
	local step1_y = random(-100, 100);
	if(step1_y > -30 and step1_y < 30) then step1_y = step1_y * 3 end 
	local step2_x = step1_x * 0.5;
	local step2_y = step1_y * 0.75;
	self.Deluxe.tex:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
	self.Deluxe.anim[1]:SetOffset(step1_x, step1_y)
	self.Deluxe.anim[2]:SetOffset(step2_x, step2_y)
	self.Deluxe.anim[3]:SetOffset(0,0)
	self.Deluxe.anim:Play() 
end

function SV.Comix:LaunchPopup()
	local rng = random(1, 16);
	local coords = COMIX_DATA[1][rng];
	local step1_x = random(-100, 100);
	if(step1_x > -30 and step1_x < 30) then step1_x = step1_x * 3 end 
	local step1_y = random(-100, 100);
	if(step1_y > -30 and step1_y < 30) then step1_y = step1_y * 3 end 
	self.Basic.tex:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
	self.Basic:Point("CENTER", SV.Screen, "CENTER", step1_x, step1_y)
	self.Basic.anim:Play()
end 

local Comix_OnEvent = function(self, event, ...)
	if(not SV.db.general.comix) then 
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:SetScript("OnEvent", nil)
		return
	end
	local subEvent = select(2,...)
	local guid = select(4,...)
	local ready = self:ReadyState()
	playerGUID = UnitGUID('player')
	if subEvent == "PARTY_KILL" and guid == playerGUID and ready then 
		self:ReadyState(false)
		local rng = random(1,15)
		if rng < 8 then
			self:LaunchDeluxePopup()
		else
			self:LaunchPopup()
		end
	end  
end

function SV.Comix:Toggle(enabled)
	if(not enabled) then 
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:SetScript("OnEvent", nil)
	else 
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:SetScript("OnEvent", Comix_OnEvent)
	end 
end 

function SV:ToastyKombat()
	--SV.Comix:LaunchPopup("DELUXE")
	ComixToastyPanelBG.anim[2]:SetOffset(256, -256)
	ComixToastyPanelBG.anim[2]:SetOffset(0, 0)
	ComixToastyPanelBG.anim:Play()
	PlaySoundFile([[Interface\AddOns\SVUI\assets\sounds\toasty.mp3]])
end 

local Comix_OnUpdate = function() SV.Comix:ReadyState(true) end
local Toasty_OnUpdate = function(self) SV.Comix:ReadyState(true); self.parent:SetAlpha(0) end

function SV.Comix:Initialize()
	self.Basic.tex:SetTexCoord(0,0.25,0,0.25)
	SV.Animate:Kapow(self.Basic, true)
	self.Basic:SetAlpha(0)
	self.Basic.anim[2]:SetScript("OnFinished", Comix_OnUpdate)

	self.Deluxe.tex:SetTexCoord(0,0.25,0,0.25)
	SV.Animate:RandomSlide(self.Deluxe, true)
	self.Deluxe:SetAlpha(0)
	self.Deluxe.anim[3]:SetScript("OnFinished", Comix_OnUpdate)

	self.Premium.tex:SetTexCoord(0,0.25,0,0.25)
	SV.Animate:RandomSlide(self.Premium, true)
	self.Premium:SetAlpha(0)
	self.Premium.anim[3]:SetScript("OnFinished", Comix_OnUpdate)

	self.Premium.bg.tex:SetTexCoord(0,0.25,0,0.25)
	SV.Animate:RandomSlide(self.Premium.bg, false)
	self.Premium.bg:SetAlpha(0)
	self.Premium.bg.anim[3]:SetScript("OnFinished", Comix_OnUpdate)

	--MOD
	local toasty = CreateFrame("Frame", "ComixToastyPanelBG", UIParent)
	toasty:SetSize(256, 256)
	toasty:SetFrameStrata("DIALOG")
	toasty:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
	toasty.tex = toasty:CreateTexture(nil, "ARTWORK")
	toasty.tex:FillInner(toasty)
	toasty.tex:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\TOASTY]])
	SV.Animate:Slide(toasty, 256, -256, true)
	toasty:SetAlpha(0)
	toasty.anim[4]:SetScript("OnFinished", Toasty_OnUpdate)

	self:ReadyState(true)

	if SV.db.general.comix then 
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:SetScript("OnEvent", Comix_OnEvent)
	end
end