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

local Sequences = {
	{65, 1000}, --shrug
	{70, 1000}, --laugh
	{74, 1000}, --roar
	{82, 1000}, --flex
};

local function rng()
	return random(1, #Sequences)
end

local GoGoGadget = function(self, key)
	key = key or rng()
	local emote = Sequences[key][1]
	self:SetAlpha(1)
	self.Model1:SetAnimation(emote)
	self.Model2:SetAnimation(emote)
end

local function LoadSVEgo()
	if(not SV.db.general.ego) then return end
	local GameMenuFrame = _G.GameMenuFrame

	local EgoFrame = CreateFrame("Frame", "SVUI_EgoFrame", UIParent);
	EgoFrame:SetParent(GameMenuFrame)
	EgoFrame:SetFrameLevel(0)
	EgoFrame:SetAllPoints(SV.Screen)

	EgoFrame.BG1 = EgoFrame:CreateTexture(nil, "BACKGROUND", nil, -7)
    EgoFrame.BG1:SetPoint("TOPLEFT", EgoFrame, "TOPLEFT", 0, 0)
    EgoFrame.BG1:SetPoint("BOTTOMRIGHT", EgoFrame, "TOPRIGHT", 0, -300)
    EgoFrame.BG1:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	EgoFrame.BG1:SetVertexColor(0, 0, 0, 0.8)

	EgoFrame.BG2 = EgoFrame:CreateTexture(nil, "BACKGROUND", nil, -7)
    EgoFrame.BG2:SetPoint("BOTTOMLEFT", EgoFrame, "BOTTOMLEFT", 0, 0)
    EgoFrame.BG2:SetPoint("TOPRIGHT", EgoFrame, "BOTTOMRIGHT", 0, 300)
    EgoFrame.BG2:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	EgoFrame.BG2:SetVertexColor(0, 0, 0, 0.8)

	EgoFrame.Model1 = CreateFrame("PlayerModel", "SVUI_EgoModel1", EgoFrame);
	EgoFrame.Model1:SetUnit("player")
	EgoFrame.Model1:SetRotation(1)
	EgoFrame.Model1:SetPortraitZoom(0.3)
	EgoFrame.Model1:SetPosition(0,0,-0.25)
	EgoFrame.Model1:SetFrameStrata("BACKGROUND")
	EgoFrame.Model1:SetPoint("TOPLEFT", EgoFrame, "TOPLEFT", -250, -300)
	EgoFrame.Model1:SetPoint("BOTTOMRIGHT", EgoFrame, "BOTTOM", 0, 300)

	EgoFrame.Model2 = CreateFrame("PlayerModel", "SVUI_EgoModel2", EgoFrame);
	EgoFrame.Model2:SetUnit("player")
	EgoFrame.Model2:SetRotation(-1)
	EgoFrame.Model2:SetPortraitZoom(0.3)
	EgoFrame.Model2:SetPosition(0,0,-0.25)
	EgoFrame.Model2:SetFrameStrata("BACKGROUND")
	EgoFrame.Model2:SetPoint("TOPRIGHT", EgoFrame, "TOPRIGHT", 250, -300)
	EgoFrame.Model2:SetPoint("BOTTOMLEFT", EgoFrame, "BOTTOM", 250, 300)

	EgoFrame.GoGoGadget = GoGoGadget

	EgoFrame:SetScript("OnShow", function(self) 
		self:GoGoGadget()
	end)
end

SV:NewScript(LoadSVEgo)