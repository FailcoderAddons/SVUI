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
local SuperVillain, L = unpack(select(2, ...));
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
end;

function Comix:LaunchPopup(comicType)
	local rng = random(1, 16);
	local coords = COMIX_DATA[1][rng];
	if(comicType == "PREMIUM") then
		ComixPremiumPanel.tex:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
		ComixPremiumPanelBG.tex:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
		local offsets = COMIX_DATA[2][rng]
		ComixPremiumPanel.anim[1]:SetOffset(offsets[1],offsets[2])
		ComixPremiumPanel.anim[2]:SetOffset(offsets[3],offsets[4])
		ComixPremiumPanel.anim[3]:SetOffset(0,0)
		ComixPremiumPanelBG.anim[1]:SetOffset(offsets[5],offsets[6])
		ComixPremiumPanelBG.anim[2]:SetOffset(offsets[7],offsets[8])
		ComixPremiumPanelBG.anim[3]:SetOffset(0,0)
		ComixPremiumPanel.anim:Play()
		ComixPremiumPanelBG.anim:Play()
	else
		local frame = ComixBasicPanel
		if(comicType == "DELUXE") then
			frame = ComixDeluxePanel
		end
		local step1_x = random(-280, 280);
		if(step1_x > -30 and step1_x < 30) then step1_x = 150 end;
		local step2_x = step1_x * 0.5;
		local step1_y = random(50, 100);
		local step2_y = step1_y * 0.75;
		frame.tex:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
		frame.anim[1]:SetOffset(step1_x, step1_y)
		frame.anim[2]:SetOffset(step2_x, step2_y)
		frame.anim[3]:SetOffset(0,0)
		frame.anim:Play()
	end 
end;

local Comix_OnEvent = function(self, event, ...)
	local subEvent = select(2,...)
	local guid = select(4,...)
	local ready = self:ReadyState()
	playerGUID = UnitGUID('player')
	if subEvent == "PARTY_KILL" and guid == playerGUID and ready then 
		self:ReadyState(false)
		local rng = random(1,15)
		if rng < 8 then
			self:LaunchPopup("BASIC")
		elseif rng < 13 then
			self:LaunchPopup("DELUXE")
		else
			self:LaunchPopup("PREMIUM")
		end 
	end  
end

function SuperVillain:ToggleComix()
	if not SuperVillain.db.system.comix then 
		Comix:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		Comix:SetScript("OnEvent", nil)
	else 
		Comix:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		Comix:SetScript("OnEvent", Comix_OnEvent)
	end 
end;

function SuperVillain:ToastyKombat()
	Comix:LaunchPopup("DELUXE")
	-- ComixToastyPanelBG.anim[2]:SetOffset(256, -256)
	-- ComixToastyPanelBG.anim[2]:SetOffset(0, 0)
	-- ComixToastyPanelBG.anim:Play()
	-- PlaySoundFile([[Interface\AddOns\SVUI\assets\sounds\toasty.mp3]])
end;

local Comix_OnUpdate = function() Comix:ReadyState(true) end
local Toasty_OnUpdate = function(self) Comix:ReadyState(true);self.parent:SetAlpha(0) end

local function LoadSuperVillainComix()
	local basic = CreateFrame("Frame", "ComixBasicPanel", SuperVillain.UIParent)
	basic:SetSize(100, 100)
	basic:SetFrameStrata("DIALOG")
	basic:Point("CENTER", SuperVillain.UIParent, "CENTER", 0, -50)
	basic.tex = basic:CreateTexture(nil, "ARTWORK")
	basic.tex:FillInner(basic)
	basic.tex:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\COMICS-TYPE1]])
	basic.tex:SetTexCoord(0,0.25,0,0.25)
	SuperVillain.Animate:RandomSlide(basic, true)
	basic:SetAlpha(0)
	basic.anim[3]:SetScript("OnFinished", Comix_OnUpdate)

	local deluxe = CreateFrame("Frame", "ComixDeluxePanel", SuperVillain.UIParent)
	deluxe:SetSize(100, 100)
	deluxe:SetFrameStrata("DIALOG")
	deluxe:Point("CENTER", SuperVillain.UIParent, "CENTER", 0, -50)
	deluxe.tex = deluxe:CreateTexture(nil, "ARTWORK")
	deluxe.tex:FillInner(deluxe)
	deluxe.tex:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\COMICS-TYPE2]])
	deluxe.tex:SetTexCoord(0,0.25,0,0.25)
	SuperVillain.Animate:RandomSlide(deluxe, true)
	deluxe:SetAlpha(0)
	deluxe.anim[3]:SetScript("OnFinished", Comix_OnUpdate)

	local premium = CreateFrame("Frame", "ComixPremiumPanel", SuperVillain.UIParent)
	premium:SetSize(100, 100)
	premium:SetFrameStrata("DIALOG")
	premium:Point("CENTER", SuperVillain.UIParent, "CENTER", 0, -50)
	premium.tex = premium:CreateTexture(nil, "ARTWORK")
	premium.tex:FillInner(premium)
	premium.tex:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\COMICS-TYPE3]])
	premium.tex:SetTexCoord(0,0.25,0,0.25)
	SuperVillain.Animate:RandomSlide(premium, true)
	premium:SetAlpha(0)
	premium.anim[3]:SetScript("OnFinished", Comix_OnUpdate)

	local premiumbg = CreateFrame("Frame", "ComixPremiumPanelBG", SuperVillain.UIParent)
	premiumbg:SetSize(128, 128)
	premiumbg:SetFrameStrata("BACKGROUND")
	premiumbg:Point("CENTER", SuperVillain.UIParent, "CENTER", 0, -50)
	premiumbg.tex = premiumbg:CreateTexture(nil, "ARTWORK")
	premiumbg.tex:FillInner(premiumbg)
	premiumbg.tex:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\COMICS-TYPE3-BG]])
	premiumbg.tex:SetTexCoord(0,0.25,0,0.25)
	SuperVillain.Animate:RandomSlide(premiumbg, false)
	premiumbg:SetAlpha(0)
	premiumbg.anim[3]:SetScript("OnFinished", Comix_OnUpdate)
	--MOD
	local toasty = CreateFrame("Frame", "ComixToastyPanelBG", UIParent)
	toasty:SetSize(256, 256)
	toasty:SetFrameStrata("DIALOG")
	toasty:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
	toasty.tex = toasty:CreateTexture(nil, "ARTWORK")
	toasty.tex:FillInner(toasty)
	toasty.tex:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\TOASTY]])
	SuperVillain.Animate:Slide(toasty, 256, -256, true)
	toasty:SetAlpha(0)
	toasty.anim[4]:SetScript("OnFinished", Toasty_OnUpdate)

	Comix:ReadyState(true)
	SuperVillain:ToggleComix()
end
SuperVillain.Registry:NewScript(LoadSuperVillainComix)