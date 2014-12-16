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
local assert 	= _G.assert;
local math 		= _G.math;
--[[ MATH METHODS ]]--
local random = math.random;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local oUF_Villain = SV.oUF

assert(oUF_Villain, "SVUI was unable to locate oUF.")

local L = SV.L;
if(SV.class ~= "PALADIN") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end 
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--

--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local db = SV.db.SVUnit.player
	local bar = self.HolyPower;
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
	for i = 1, max do
		bar[i]:ClearAllPoints()
		bar[i]:SetHeight(size)
		bar[i]:SetWidth(size)
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		if i==1 then 
			bar[i]:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		else 
			bar[i]:SetPointToScale("LEFT", bar[i - 1], "RIGHT", -1, 0) 
		end
	end 
end 

local Update = function(self, event, unit, powerType)
	if self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER') then return end 
	local bar = self.HolyPower;
	local baseCount = UnitPower('player',SPELL_POWER_HOLY_POWER)
	local maxCount = UnitPowerMax('player',SPELL_POWER_HOLY_POWER)
	for i=1,maxCount do 
		if i <= baseCount then 
			bar[i]:SetAlpha(1)
		else 
			bar[i]:SetAlpha(0)
		end 
		if i > maxCount then 
			bar[i]:Hide()
		else 
			bar[i]:Show()
			if(not bar[i].swirl[3].anim:IsPlaying()) then 
				bar[i].swirl[3].anim:Play()
			end
		end 
	end
	self.MaxClassPower = maxCount
end 

local AlphaHook = function(self,value)
	self.swirl[3].anim:Finish()
	if value < 1 then 
		self.swirl[1].anim:Finish()
		self.swirl[2].anim:Finish() 
	else 
		if(not self.swirl[1].anim:IsPlaying()) then 
			self.swirl[1].anim:Play()
		end 
		if(not self.swirl[2].anim:IsPlaying()) then 
			self.swirl[2].anim:Play()
		end
		self.swirl[3].anim:Play()
	end 
end
--[[ 
########################################################## 
PALADIN
##########################################################
]]--
function MOD:CreateClassBar(playerFrame)
	local max = 5
	local bar = CreateFrame("Frame", nil, playerFrame)
	bar:SetFrameLevel(playerFrame.TextGrip:GetFrameLevel() + 30)

	for i = 1, max do 
		bar[i] = CreateFrame("StatusBar", nil, bar)
		bar[i]:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\PALADIN-HAMMER")
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		bar[i]:SetStatusBarColor(0.9,0.9,0.8)

		bar[i].backdrop = bar[i]:CreateTexture(nil,"BACKGROUND")
		bar[i].backdrop:SetAllPoints(bar[i])
		bar[i].backdrop:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\PALADIN-HAMMER")
		bar[i].backdrop:SetVertexColor(0,0,0)

		local barAnimation = CreateFrame('Frame',nil,bar[i])
		barAnimation:SetSizeToScale(40,40)
		barAnimation:SetPoint("CENTER",bar[i],"CENTER",0,0)
		barAnimation:SetFrameLevel(0)
		
		barAnimation[1] = barAnimation:CreateTexture(nil,"BACKGROUND",nil,1)
		barAnimation[1]:SetSizeToScale(40,40)
		barAnimation[1]:SetPoint("CENTER")
		barAnimation[1]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\SWIRL")
		barAnimation[1]:SetBlendMode("ADD")
		barAnimation[1]:SetVertexColor(0.5,0.5,0.15)
		SV.Animate:Orbit(barAnimation[1],10)

		barAnimation[2] = barAnimation:CreateTexture(nil,"BACKGROUND",nil,2)
		barAnimation[2]:SetSizeToScale(40,40)
		barAnimation[2]:SetPoint("CENTER")
		barAnimation[2]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\SWIRL")
		barAnimation[2]:SetTexCoord(1,0,1,1,0,0,0,1)
		barAnimation[2]:SetBlendMode("ADD")
		barAnimation[2]:SetVertexColor(0.5,0.5,0.15)
		SV.Animate:Orbit(barAnimation[2],10,true)

		barAnimation[3] = barAnimation:CreateTexture(nil, "OVERLAY")
		barAnimation[3]:SetAllPointsOut(barAnimation, 3, 3)
		barAnimation[3]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\MAGE-FG-ANIMATION")
		barAnimation[3]:SetBlendMode("ADD")
		barAnimation[3]:SetVertexColor(1, 1, 0)
		SV.Animate:Sprite(barAnimation[3], 0.08, 2, true)

		bar[i].swirl = barAnimation;
		hooksecurefunc(bar[i], "SetAlpha", AlphaHook)
	end 
	bar.Override = Update;
	
	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", bar)
	classBarHolder:SetPointToScale("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"])

	playerFrame.MaxClassPower = max;
	playerFrame.ClassBarRefresh = Reposition;
	playerFrame.HolyPower = bar
	return 'HolyPower'  
end 