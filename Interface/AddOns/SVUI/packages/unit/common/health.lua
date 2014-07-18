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
local assert 	= _G.assert;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVUnit')
if(not MOD) then return end;
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local HEALTH_ANIM_FILE = [[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-HEALTH-ANIMATION]];

local Anim_OnUpdate = function(self)
	local parent = self.parent
	local coord = self._coords;
	parent:SetTexCoord(coord[1],coord[2],coord[3],coord[4])
end 

local Anim_OnPlay = function(self)
	local parent = self.parent
	parent:SetAlpha(1)
	if not parent:IsShown() then
		parent:Show()
	end
end 

local Anim_OnStop = function(self)
	local parent = self.parent
	parent:SetAlpha(0)
	if parent:IsShown() then
		parent:Hide()
	end
end 

local function SetNewAnimation(frame, animType, parent)
	local anim = frame:CreateAnimation(animType, subType)
	anim.parent = parent
	return anim
end

local function SetAnim(frame, parent)
	local speed = 0.08
	frame.anim = frame:CreateAnimationGroup("Sprite")
	frame.anim.parent = parent;
	frame.anim:SetScript("OnPlay", Anim_OnPlay)
	frame.anim:SetScript("OnFinished", Anim_OnStop)
	frame.anim:SetScript("OnStop", Anim_OnStop)

	frame.anim[1] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[1]:SetOrder(1)
	frame.anim[1]:SetDuration(speed)
	frame.anim[1]._coords = {0,0.5,0,0.25}
	frame.anim[1]:SetScript("OnUpdate", Anim_OnUpdate)

	frame.anim[2] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[2]:SetOrder(2)
	frame.anim[2]:SetDuration(speed)
	frame.anim[2]._coords = {0.5,1,0,0.25}
	frame.anim[2]:SetScript("OnUpdate", Anim_OnUpdate)

	frame.anim[3] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[3]:SetOrder(3)
	frame.anim[3]:SetDuration(speed)
	frame.anim[3]._coords = {0,0.5,0.25,0.5}
	frame.anim[3]:SetScript("OnUpdate", Anim_OnUpdate)
	
	frame.anim[4] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[4]:SetOrder(4)
	frame.anim[4]:SetDuration(speed)
	frame.anim[4]._coords = {0.5,1,0.25,0.5}
	frame.anim[4]:SetScript("OnUpdate", Anim_OnUpdate)
	
	frame.anim[5] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[5]:SetOrder(5)
	frame.anim[5]:SetDuration(speed)
	frame.anim[5]._coords = {0,0.5,0.5,0.75}
	frame.anim[5]:SetScript("OnUpdate", Anim_OnUpdate)
	
	frame.anim[6] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[6]:SetOrder(6)
	frame.anim[6]:SetDuration(speed)
	frame.anim[6]._coords = {0.5,1,0.5,0.75}
	frame.anim[6]:SetScript("OnUpdate", Anim_OnUpdate)
	
	frame.anim[7] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[7]:SetOrder(7)
	frame.anim[7]:SetDuration(speed)
	frame.anim[7]._coords = {0,0.5,0.75,1}
	frame.anim[7]:SetScript("OnUpdate", Anim_OnUpdate)
	
	frame.anim[8] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[8]:SetOrder(8)
	frame.anim[8]:SetDuration(speed)
	frame.anim[8]._coords = {0.5,1,0.75,1}
	frame.anim[8]:SetScript("OnUpdate", Anim_OnUpdate)

	frame.anim:SetLooping("REPEAT")
end

local function updateFrequentUpdates(self)
	local health = self.Health
	if health.frequentUpdates and not self:IsEventRegistered("UNIT_HEALTH_FREQUENT") then
		if GetCVarBool("predictedHealth") ~= 1 then
			SetCVar("predictedHealth", 1)
		end

		self:RegisterEvent('UNIT_HEALTH_FREQUENT', Path)

		if self:IsEventRegistered("UNIT_HEALTH") then
			self:UnregisterEvent("UNIT_HEALTH", Path)
		end
	elseif not self:IsEventRegistered("UNIT_HEALTH") then
		self:RegisterEvent('UNIT_HEALTH', Path)

		if self:IsEventRegistered("UNIT_HEALTH_FREQUENT") then
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT", Path)
		end		
	end
end

local CustomUpdate = function(self, event, unit)
	if(self.unit ~= unit) or not unit then return end
	local health = self.Health

	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local disconnected = not UnitIsConnected(unit)
	local invisible = ((min == max) or UnitIsDeadOrGhost(unit) or disconnected);
	local tapped = (UnitIsTapped(unit) and (not UnitIsTappedByPlayer(unit)));
	
	if health.fillInverted then
		health:SetReverseFill(true)
	end

	health:SetMinMaxValues(-max, 0)
	health:SetValue(-min)
	
	health.disconnected = disconnected

	if health.frequentUpdates ~= health.__frequentUpdates then
		health.__frequentUpdates = health.frequentUpdates
		updateFrequentUpdates(self)
	end

	local bg = health.bg;
	local mu = (min / max);

	if(invisible or not health.overlayAnimation) then
		health.animation[1].anim:Stop()
		health.animation[1]:SetAlpha(0)
	end

	if(invisible) then
		health:SetStatusBarColor(0.6,0.4,1,0.5)
		health.animation[1]:SetVertexColor(0.8,0.3,1,0.4)
	elseif(health.colorOverlay) then
		local t = oUF_SuperVillain.colors.health
		health:SetStatusBarColor(t[1], t[2], t[3], 0.9)
	else
		health:SetStatusBarColor(1, 0.25 * mu, 0, 0.85)
		health.animation[1]:SetVertexColor(1, 0.1 * mu, 0, 0.5) 
	end

	if(bg) then 
		bg:SetVertexColor(0,0,0,0)
	end

	if(health.overlayAnimation and not invisible) then 
		if(mu <= 0.25) then
			health.animation[1]:SetAlpha(1)
			health.animation[1].anim:Play()
		else
			health.animation[1].anim:Stop()
			health.animation[1]:SetAlpha(0)
		end
	end

	if self.ResurrectIcon then 
		self.ResurrectIcon:SetAlpha(min == 0 and 1 or 0)
	end 
	if self.isForced then 
		local current = random(1,max)
		health:SetValue(-current)
	end
end 

local Update = function(self, event, unit)
	if(self.unit ~= unit) or not unit then return end
	local health = self.Health
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local disconnected = not UnitIsConnected(unit)
	if health.fillInverted then
		health:SetReverseFill(true)
	end
	health:SetMinMaxValues(0, max)

	if(disconnected) then
		health:SetValue(max)
	else
		health:SetValue(min)
	end

	health.disconnected = disconnected

	if health.frequentUpdates ~= health.__frequentUpdates then
		health.__frequentUpdates = health.frequentUpdates
		updateFrequentUpdates(self)
	end

	local bg = health.bg;
	local db = MOD.db or SuperVillain.db.SVUnit;
	local r, g, b, t, t2;

	if(health.colorTapping and not UnitPlayerControlled(unit) and UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) and not UnitIsTappedByAllThreatList(unit)) then
		t = oUF_SuperVillain.colors.tapped
	elseif(health.colorDisconnected and not UnitIsConnected(unit)) then
		t = oUF_SuperVillain.colors.disconnected
	elseif(health.colorClass and UnitIsPlayer(unit)) or
		(health.colorClassNPC and not UnitIsPlayer(unit)) or
		(health.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		local tmp = oUF_SuperVillain.colors.class[class] or oUF_SuperVillain.colors.health
		t = {(tmp[1] * 0.75),(tmp[2] * 0.75),(tmp[3] * 0.75)}
		if(bg and db.classbackdrop and UnitIsPlayer(unit)) then
			t2 = t
		end
	elseif(health.colorReaction and UnitReaction(unit, 'player')) then
		t = oUF_SuperVillain.colors.reaction[UnitReaction(unit, "player")]
		if(bg and db.classbackdrop and not UnitIsPlayer(unit) and UnitReaction(unit, "player")) then
			t2 = t
		end
	elseif(health.colorSmooth) then
		r, g, b = oUF_SuperVillain.ColorGradient(min, max, unpack(health.smoothGradient or oUF_SuperVillain.colors.smooth))
	elseif(health.colorHealth) then
		t = oUF_SuperVillain.colors.health
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end

	if(b) then
		if(db.healthclass == true and db.colorhealthbyvalue == true or db.colorhealthbyvalue and self.isForced and not(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit))) then 
			r, g, b = oUF_SuperVillain.ColorGradient(min,max,1,0,0,1,1,0,r,g,b)
		end
		health:SetStatusBarColor(r, g, b)
		if(bg) then 
			local mu = bg.multiplier or 1
			if(t2) then
				r, g, b = t2[1], t2[2], t2[3] 
			end
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end

	if self.ResurrectIcon then 
		self.ResurrectIcon:SetAlpha(min == 0 and 1 or 0)
	end 
	if self.isForced then 
		min = random(1,max)
		health:SetValue(min)
	end 
	if(db.gridMode) then 
		health:SetOrientation("VERTICAL")
	end
end
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreateHealthBar(frame, hasbg, reverse)
	local healthBar = CreateFrame("StatusBar", nil, frame)
	healthBar:SetFrameStrata("LOW")
	healthBar:SetFrameLevel(4)
	healthBar:SetStatusBarTexture(SuperVillain.Media.bar.default)
	if hasbg then 
		healthBar.bg = healthBar:CreateTexture(nil, "BORDER")
		healthBar.bg:SetAllPoints()
		healthBar.bg:SetTexture(SuperVillain.Media.bar.gradient)
		healthBar.bg:SetVertexColor(0.4, 0.1, 0.1)
		healthBar.bg.multiplier = 0.25
	end 

	local flasher = CreateFrame("Frame", nil, frame)
	flasher:SetFrameLevel(3)
	flasher:SetAllPoints(healthBar)

	flasher[1] = flasher:CreateTexture(nil, "OVERLAY", nil, 1)
	flasher[1]:SetTexture(HEALTH_ANIM_FILE)
	flasher[1]:SetTexCoord(0, 0.5, 0, 0.25)
	flasher[1]:SetVertexColor(1, 0.3, 0.1, 0.5)
	flasher[1]:SetBlendMode("ADD")
	flasher[1]:SetAllPoints(flasher)
	SetAnim(flasher[1], flasher)
	flasher:Hide() 

	healthBar.animation = flasher
	healthBar.noupdate = false;
	healthBar.fillInverted = reverse;
	healthBar.colorTapping = true;
	healthBar.colorDisconnected = true
	healthBar.Override = Update;
	return healthBar 
end 

function MOD:RefreshHealthBar(frame, overlay)
	if(overlay) then
		frame.Health.Override = CustomUpdate;
	else
		frame.Health.Override = Update;
	end 
end