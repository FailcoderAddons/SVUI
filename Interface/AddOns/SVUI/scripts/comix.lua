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
local Comix = CreateFrame("Frame");
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
function Comix:ReadyState(state)
	if(state == nil) then return animReady end
	animReady = state
end

function Comix:LaunchPremiumPopup()
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

function Comix:LaunchDeluxePopup()
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

function Comix:LaunchPopup()
	local rng = random(1, 16);
	local coords = COMIX_DATA[1][rng];
	local step1_x = random(-100, 100);
	if(step1_x > -30 and step1_x < 30) then step1_x = step1_x * 3 end 
	local step1_y = random(-100, 100);
	if(step1_y > -30 and step1_y < 30) then step1_y = step1_y * 3 end 
	self.Basic.tex:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
	self.Basic:Point("CENTER", SV.UIParent, "CENTER", step1_x, step1_y)
	self.Basic.anim:Play()
end 

local Comix_OnEvent = function(self, event, ...)
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

function SV:ToggleComix()
	if not SV.db.general.comix then 
		Comix:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		Comix:SetScript("OnEvent", nil)
	else 
		Comix:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		Comix:SetScript("OnEvent", Comix_OnEvent)
	end 
end 

function SV:ToastyKombat()
	--Comix:LaunchPopup("DELUXE")
	ComixToastyPanelBG.anim[2]:SetOffset(256, -256)
	ComixToastyPanelBG.anim[2]:SetOffset(0, 0)
	ComixToastyPanelBG.anim:Play()
	PlaySoundFile([[Interface\AddOns\SVUI\assets\sounds\toasty.mp3]])
end 

local Comix_OnUpdate = function() Comix:ReadyState(true) end
local Toasty_OnUpdate = function(self) Comix:ReadyState(true); self.parent:SetAlpha(0) end

local function LoadSVComix()
	local basic = CreateFrame("Frame", "ComixBasicPanel", SV.UIParent)
	basic:SetSize(100, 100)
	basic:SetFrameStrata("DIALOG")
	basic:Point("CENTER", SV.UIParent, "CENTER", 0, -50)
	basic.tex = basic:CreateTexture(nil, "ARTWORK")
	basic.tex:FillInner(basic)
	basic.tex:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\COMICS-TYPE1]])
	basic.tex:SetTexCoord(0,0.25,0,0.25)
	SV.Animate:Kapow(basic, true)
	basic:SetAlpha(0)
	basic.anim[2]:SetScript("OnFinished", Comix_OnUpdate)

	Comix.Basic = basic

	local deluxe = CreateFrame("Frame", "ComixDeluxePanel", SV.UIParent)
	deluxe:SetSize(100, 100)
	deluxe:SetFrameStrata("DIALOG")
	deluxe:Point("CENTER", SV.UIParent, "CENTER", 0, -50)
	deluxe.tex = deluxe:CreateTexture(nil, "ARTWORK")
	deluxe.tex:FillInner(deluxe)
	deluxe.tex:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\COMICS-TYPE2]])
	deluxe.tex:SetTexCoord(0,0.25,0,0.25)
	SV.Animate:RandomSlide(deluxe, true)
	deluxe:SetAlpha(0)
	deluxe.anim[3]:SetScript("OnFinished", Comix_OnUpdate)

	Comix.Deluxe = deluxe

	local premium = CreateFrame("Frame", "ComixPremiumPanel", SV.UIParent)
	premium:SetSize(100, 100)
	premium:SetFrameStrata("DIALOG")
	premium:Point("CENTER", SV.UIParent, "CENTER", 0, -50)
	premium.tex = premium:CreateTexture(nil, "ARTWORK")
	premium.tex:FillInner(premium)
	premium.tex:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\COMICS-TYPE3]])
	premium.tex:SetTexCoord(0,0.25,0,0.25)
	SV.Animate:RandomSlide(premium, true)
	premium:SetAlpha(0)
	premium.anim[3]:SetScript("OnFinished", Comix_OnUpdate)

	local bg = CreateFrame("Frame", "ComixPremiumPanelBG", SV.UIParent)
	bg:SetSize(128, 128)
	bg:SetFrameStrata("BACKGROUND")
	bg:Point("CENTER", SV.UIParent, "CENTER", 0, -50)
	bg.tex = bg:CreateTexture(nil, "ARTWORK")
	bg.tex:FillInner(bg)
	bg.tex:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\COMICS-TYPE3-BG]])
	bg.tex:SetTexCoord(0,0.25,0,0.25)
	SV.Animate:RandomSlide(bg, false)
	bg:SetAlpha(0)
	bg.anim[3]:SetScript("OnFinished", Comix_OnUpdate)

	premium.bg = bg

	Comix.Premium = premium

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

	Comix:ReadyState(true)
	SV:ToggleComix()
end

SV:NewScript(LoadSVComix)