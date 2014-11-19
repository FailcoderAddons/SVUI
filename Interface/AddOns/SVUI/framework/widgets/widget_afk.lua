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

function SV.AFK:Activate(enabled)
	if(InCombatLockdown()) then return end
	if(enabled) then
		MoveViewLeftStart(0.05);
		self:Show();
		UIParent:Hide();
		self:SetAlpha(1);
		self.Model:SetAnimation(119)
		DoEmote("READ")
	else
		UIParent:Show();
		self:SetAlpha(0);
		self:Hide();
		MoveViewLeftStop();
	end
end

local AFK_OnEvent = function(self, event)
	if(event == "PLAYER_REGEN_DISABLED") then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
		self:Activate(false)
	else
		if(UnitIsAFK("player")) then
			self:Activate(true)
		else
			self:Activate(false)
		end
	end
end

function SV.AFK:Initialize()
	local classToken = select(2,UnitClass("player"))
	local color = SVUI_CLASS_COLORS[classToken]
	self.BG:SetVertexColor(color.r, color.g, color.b)
	self.BG:ClearAllPoints()
	self.BG:Size(500,600)
	self.BG:Point("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)

	self:SetFrameLevel(0)
	self:SetAllPoints(SV.Screen)

	self.Model:ClearAllPoints()
	self.Model:Size(600,600)
	self.Model:Point("BOTTOMRIGHT", self, "BOTTOMRIGHT", 64, -64)
	self.Model:SetUnit("player")
	self.Model:SetCamDistanceScale(1.15)
	self.Model:SetFacing(6)

	local splash = self.Model:CreateTexture(nil, "OVERLAY")
	splash:Size(256,256)
	splash:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\PLAYER-AFK")
	splash:Point("TOPRIGHT", self, "TOPRIGHT", 0, -64)

	self:Hide()
	if(SV.db.general.afk) then
		self:RegisterEvent("PLAYER_FLAGS_CHANGED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:SetScript("OnEvent", AFK_OnEvent)
	end
end

function SV.AFK:Toggle()
	if(SV.db.general.afk) then
		self:RegisterEvent("PLAYER_FLAGS_CHANGED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:SetScript("OnEvent", AFK_OnEvent)
	else
		self:UnregisterEvent("PLAYER_FLAGS_CHANGED")
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:SetScript("OnEvent", nil)
	end
end