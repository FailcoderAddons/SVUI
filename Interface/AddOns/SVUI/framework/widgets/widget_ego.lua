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
local GameMenuFrame = _G.GameMenuFrame
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...);

SV.Ego = _G["SVUI_EgoFrame"];

local Sequences = {
	{65, 1000}, --shrug
	{70, 1000}, --laugh
	{74, 1000}, --roar
	{82, 1000}, --flex
};

local function rng()
	return random(1, #Sequences)
end

local Activate = function(self)
	if(not SV.db.general.ego) then
		self:Toggle()
		return
	end

	local key = rng()
	local emote = Sequences[key][1]
	self:SetAlpha(1)
	self.ModelLeft:SetAnimation(emote)
	-- self.ModelRight:SetAnimation(emote)
end

function SV.Ego:Initialize()
	self:SetFrameLevel(0)
	self:SetAllPoints(SV.Screen)

	self.ModelLeft:SetUnit("player")
	self.ModelLeft:SetRotation(1)
	self.ModelLeft:SetPortraitZoom(0.3)
	self.ModelLeft:SetPosition(0,0,-0.25)

	-- self.ModelRight:SetUnit("player")
	-- self.ModelRight:SetRotation(-1)
	-- self.ModelRight:SetPortraitZoom(0.3)
	-- self.ModelRight:SetPosition(0,0,-0.25)

	self:SetScript("OnShow", Activate)
end

function SV.Ego:Toggle()
	if(SV.db.general.ego) then
		self:Show()
		self:SetScript("OnShow", Activate)
	else
		self:Hide()
		self:SetScript("OnShow", nil)
	end
end