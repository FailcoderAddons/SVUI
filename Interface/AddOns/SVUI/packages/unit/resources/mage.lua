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
if(SV.class ~= "MAGE") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end 
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local db = SV.db.SVUnit.player
	local bar = self.ArcaneChargeBar;
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
		bar[i]:SetStatusBarColor(0,0.6,0.9)
		if i==1 then 
			bar[i]:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		else 
			bar[i]:Point("LEFT", bar[i - 1], "RIGHT", -1, 0) 
		end
	end 
end 
--[[ 
########################################################## 
MAGE CHARGES
##########################################################
]]--
local function UpdateBar(self, elapsed)
	if not self.expirationTime then return end
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.5 then	
		local timeLeft = self.expirationTime - GetTime()
		if timeLeft > 0 then
			self:SetValue(timeLeft)
		else
			self:SetScript("OnUpdate", nil)
		end
	end		
end

local Update = function(self, event)
	local unit = self.unit or 'player'
	local bar = self.ArcaneChargeBar
	local talentSpecialization = GetSpecialization()
	if talentSpecialization == 1 then
		bar:Show()
	else
		bar:Hide()
	end
	
	local arcaneCharges, maxCharges, duration, expirationTime = 0, 4
	if bar:IsShown() then		
		for index=1, 30 do
			local _, _, _, count, _, start, timeLeft, _, _, _, spellID = UnitDebuff(unit, index)
			if spellID == 36032 then
				arcaneCharges = count or 0
				duration = start
				expirationTime = timeLeft
				break
			end			
		end

		for i = 1, maxCharges do
			if duration and expirationTime then
				bar[i]:SetMinMaxValues(0, duration)
				bar[i].duration = duration
				bar[i].expirationTime = expirationTime
			end
			if i <= arcaneCharges then
				bar[i]:Show()
				bar[i]:SetValue(duration)
				if not bar[i].sparks:IsShown() then bar[i].sparks:Show()end 
				if not bar[i].charge:IsShown() then bar[i].charge:Show()end 
				if not bar[i].under.anim:IsPlaying()then bar[i].under.anim:Play()end 
				if not bar[i].sparks.anim:IsPlaying()then bar[i].sparks.anim:Play()end 
				if not bar[i].charge.anim:IsPlaying()then bar[i].charge.anim:Play()end 
				bar[i]:SetScript('OnUpdate', UpdateBar)
			else
				bar[i]:SetValue(0)
				if bar[i].under.anim:IsPlaying()then bar[i].under.anim:Stop()end 
				if bar[i].sparks.anim:IsPlaying()then bar[i].sparks.anim:Stop()end 
				if bar[i].charge.anim:IsPlaying()then bar[i].charge.anim:Stop()end 
				bar[i].sparks:Hide()
				bar[i].charge:Hide()
				bar[i]:SetScript('OnUpdate', nil)
				bar[i]:Hide()
			end
		end		
	end
end

function MOD:CreateClassBar(playerFrame)
	local max = 4
	local bar = CreateFrame("Frame",nil,playerFrame)
	bar:SetFrameLevel(playerFrame.InfoPanel:GetFrameLevel() + 30)

	for i = 1, max do 
		bar[i] = CreateFrame("StatusBar", nil, bar)
		bar[i]:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\ORB")
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		bar[i]:SetOrientation("VERTICAL")
		bar[i].noupdate = true;
		local under = CreateFrame("Frame", nil, bar[i])
		under:SetAllPoints()
		under.under = under:CreateTexture(nil, "BORDER")
		under.under:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\ORB-BG")
		under.bg = under:CreateTexture(nil, "BORDER")
		under.bg:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\ORB-BG")
		local sparks = under:CreateTexture(nil, "OVERLAY")
		sparks:WrapOuter(under, 3, 3)
		sparks:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\MAGE-FG-ANIMATION")
		sparks:SetBlendMode("ADD")
		sparks:SetVertexColor(1, 1, 0)
		local charge = under:CreateTexture(nil, "OVERLAY", nil, 2)
		charge:SetAllPoints(under)
		charge:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\MAGE-BG-ANIMATION")
		charge:SetBlendMode("ADD")
		charge:SetVertexColor(0.5, 1, 1)
		SV.Animate:Sprite(charge, 10, false, true)
		charge.anim:Play()
		SV.Animate:Sprite(sparks, 0.08, 5, true)
		sparks.anim:Play()
		bar[i].charge = charge;
		bar[i].sparks = sparks;
		SV.Animate:Orbit(under, 15, false)
		bar[i].under = under;
		bar[i].bg = under.bg;
	end 

	bar.Override = Update;
	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", classBar)
	classBarHolder:Point("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"], nil, nil, nil, "ALL, SOLO")

	playerFrame.MaxClassPower = max;
	playerFrame.ClassBarRefresh = Reposition;
	playerFrame.ArcaneChargeBar = bar
	return 'ArcaneChargeBar' 
end 