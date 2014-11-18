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
local SV = select(2, ...);

SV.AFK = _G["SVUI_AFKFrame"];

local Sequences = {
	--{65, 1000}, --shrug
	{70, 1000}, --laugh
	--{74, 1000}, --roar
	--{82, 1000}, --flex
	{5, 1000}, --run
	{125, 1000}, --spell2
	{125, 1000}, --spell2
	{26, 1000}, --attack
	{26, 1000}, --attack
	{26, 1000}, --attack
	{26, 1000}, --attack
	{4, 1000}, --walk
	{5, 1000}, --run
	{69, 1000}, --dance
};

local function rng()
	return random(1, #Sequences)
end

local function WatchAFKTime()
	local time = GetTime() - self.startTime
	self.time:SetText(("%02d:%02d"):format(floor(time/60), time % 60))
end

function SV.AFK:Toggle(enabled)
	if(enabled) then
		MoveViewLeftStart(CAMERA_SPEED);
		self:Show();
		--UIParent:Hide();
		self:SetAlpha(1);
		self.Model:SetAnimation(4)
	else
		--UIParent:Show();
		self:SetAlpha(0);
		self:Hide();
		MoveViewLeftStop();
	end
end

local Activate = function(self)
	if(not SV.db.general.afk) then
		self:Toggle()
		return
	end
	self:SetAlpha(1)
	self.Model:SetAnimation(4)
end

function SV.AFK:Initialize()
	self:SetFrameLevel(0)
	self:SetAllPoints(SV.Screen)

	self.Model:SetUnit("player")
	self.Model:SetCamDistanceScale(1.15)
	self.Model:SetFacing(6)

	-- local splash = self:CreateTexture(nil, "OVERLAY")
	-- splash:SetSize(600, 300)
	-- splash:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\SPLASH-BLACK")
	-- splash:SetBlendMode("ADD")
	-- splash:SetPoint("TOP", 0, 0)

	self:SetScript("OnShow", Activate)
end