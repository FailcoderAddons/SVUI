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
local pairs     = _G.pairs;
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local math 		= _G.math;
--[[ MATH METHODS ]]--
local random = math.random;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SVUI_ADDON_NAME, SV = ...
local oUF_Villain = SV.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_Villain, "SVUI was unable to locate oUF.")

local L = LibStub("LibSuperVillain-1.0"):Lang();
if(SV.class ~= "PRIEST") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end 

local ICON_FILE = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\Class\PRIEST]]
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local db = MOD.db.player
	local bar = self.PriestOrbs;
	local max = self.MaxClassPower;
	local size = db.classbar.height
	local width = size * max;
	
	bar.Holder:Size(width, size)
    if(not db.classbar.detachFromFrame) then
    	SV.Mentalo:Reset(L["Classbar"])
    end
    local holderUpdate = bar.Holder:GetScript('OnSizeChanged')
    if holderUpdate then
        holderUpdate(bar.Holder)
    end

    bar:ClearAllPoints()
    bar:SetAllPoints(bar.Holder)
	    
	for i = 1, max do
		bar[i]:ClearAllPoints()
		bar[i]:SetHeight(size)
		bar[i]:SetWidth(size)
		if i==1 then 
			bar[i]:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		else 
			bar[i]:Point("LEFT", bar[i - 1], "RIGHT", -1, 0) 
		end
	end 
end 
--[[ 
########################################################## 
PRIEST
##########################################################
]]--
local innerOrbs = {
	[1] = {1, 0.7, 0, 0.2, 0.08, 0.01},
	[2] = {0, 0.5, 0.9, 0.02, 0.1, 0.1},
	[3] = {0.7, 0.5, 1, 0.1, 0.02, 0.4}	
};

local PreUpdate = function(self, spec)
	local color = innerOrbs[spec] or {0.7, 0.5, 1, 1, 1, 0.5};
	for i = 1, 5 do
		self[i].swirl[1]:SetVertexColor(color[1], color[2], color[3])
		self[i].swirl[2]:SetVertexColor(color[4], color[5], color[6])
	end 
end 

function MOD:CreateClassBar(playerFrame)
	local max = 5
	local bar = CreateFrame("Frame", nil, playerFrame)
	bar:SetFrameLevel(playerFrame.InfoPanel:GetFrameLevel() + 30)

	for i=1, max do 
		bar[i] = CreateFrame("StatusBar", nil, bar)
		bar[i]:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\ORB")
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		bar[i].noupdate = true;
		bar[i].backdrop = bar[i]:CreateTexture(nil, "BACKGROUND")
		bar[i].backdrop:SetAllPoints(bar[i])
		bar[i].backdrop:SetTexture(ICON_FILE)
		bar[i].backdrop:SetTexCoord(0,0.5,0,0.5)
		local swirl = CreateFrame('Frame', nil, bar[i])
		swirl:Size(30, 30)
		swirl:SetPoint("CENTER", bar[i], "CENTER", 0, 0)
		swirl[1] = swirl:CreateTexture(nil, "OVERLAY", nil, 2)
		swirl[1]:Size(30, 30)
		swirl[1]:SetPoint("CENTER")
		swirl[1]:SetTexture(ICON_FILE)
		swirl[1]:SetTexCoord(0.5,1,0.5,1)
		swirl[1]:SetBlendMode("ADD")
		swirl[1]:SetVertexColor(0.7, 0.5, 1)
		SV.Animate:Orbit(swirl[1], 10, false)
		swirl[2] = swirl:CreateTexture(nil, "OVERLAY", nil, 1)
		swirl[2]:Size(30, 30)
		swirl[2]:SetPoint("CENTER")
		swirl[2]:SetTexture(ICON_FILE)
		swirl[2]:SetTexCoord(0.5,1,0.5,1)
		swirl[2]:SetBlendMode("BLEND")
		swirl[2]:SetVertexColor(0.2, 0.08, 0.01)
		SV.Animate:Orbit(swirl[2], 10, true)
		bar[i].swirl = swirl;
		bar[i]:SetScript("OnShow", function(self)
			if not self.swirl[1].anim:IsPlaying() then
				self.swirl[1].anim:Play()
			end 
			if not self.swirl[2].anim:IsPlaying() then
				self.swirl[2].anim:Play()
			end 
		end)
		bar[i]:SetScript("OnHide", function(self)
			self.swirl[1].anim:Finish()
			self.swirl[2].anim:Finish() 
		end)

	end 
	bar.PreUpdate = PreUpdate

	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", classBar)
	classBarHolder:Point("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"], nil, nil, nil, "ALL, SOLO")

	playerFrame.MaxClassPower = max;
	playerFrame.ClassBarRefresh = Reposition;

	playerFrame.PriestOrbs = bar
	return 'PriestOrbs' 
end 