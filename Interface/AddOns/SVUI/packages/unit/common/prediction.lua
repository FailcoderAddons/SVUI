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
--]]
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
HEAL PREDICTION
##########################################################
]]--
local OverrideUpdate = function(self, event, unit)
	if(self.unit ~= unit) or not unit then return end

	local hp = self.HealPrediction
	hp.parent = self
	local hbar = self.Health;
	local anchor, relative, relative2 = 'TOPLEFT', 'BOTTOMRIGHT', 'BOTTOMLEFT';
	local reversed = true
	hp.reversed = hbar.fillInverted or false
	if(hp.reversed == true) then
		anchor, relative, relative2 = 'TOPRIGHT', 'BOTTOMLEFT', 'BOTTOMRIGHT';
		reversed = false
	end

	local myIncomingHeal = UnitGetIncomingHeals(unit, 'player') or 0
	local allIncomingHeal = UnitGetIncomingHeals(unit) or 0
	local totalAbsorb = UnitGetTotalAbsorbs(unit) or 0
	local myCurrentHealAbsorb = UnitGetTotalHealAbsorbs(unit) or 0
	local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)

	local overHealAbsorb = false
	if(health < myCurrentHealAbsorb) then
		overHealAbsorb = true
		myCurrentHealAbsorb = health
	end

	if(health - myCurrentHealAbsorb + allIncomingHeal > maxHealth * hp.maxOverflow) then
		allIncomingHeal = maxHealth * hp.maxOverflow - health + myCurrentHealAbsorb
	end

	local otherIncomingHeal = 0
	if(allIncomingHeal < myIncomingHeal) then
		myIncomingHeal = allIncomingHeal
	else
		otherIncomingHeal = allIncomingHeal - myIncomingHeal
	end

	local overAbsorb = false
	if(health - myCurrentHealAbsorb + allIncomingHeal + totalAbsorb >= maxHealth or health + totalAbsorb >= maxHealth) then
		if(totalAbsorb > 0) then
			overAbsorb = true
		end

		if(allIncomingHeal > myCurrentHealAbsorb) then
			totalAbsorb = max(0, maxHealth - (health - myCurrentHealAbsorb + allIncomingHeal))
		else
			totalAbsorb = max(0, maxHealth - health)
		end
	end

	if(myCurrentHealAbsorb > allIncomingHeal) then
		myCurrentHealAbsorb = myCurrentHealAbsorb - allIncomingHeal
	else
		myCurrentHealAbsorb = 0
	end

	local barMin, barMax, barMod = 0, maxHealth, 1;

	local previous = hbar:GetStatusBarTexture()
	if(hp.myBar) then
		hp.myBar:SetMinMaxValues(barMin, barMax)
		if(not hp.otherBar) then
			hp.myBar:SetValue(allIncomingHeal)
		else
			hp.myBar:SetValue(myIncomingHeal)
		end
		hp.myBar:SetPoint(anchor, hbar, anchor, 0, 0)
		hp.myBar:SetPoint(relative, previous, relative, 0, 0)
		hp.myBar:SetReverseFill(reversed)
		previous = hp.myBar
		hp.myBar:Show()
	end

	-- if(hp.otherBar) then
	-- 	hp.otherBar:SetMinMaxValues(barMin, barMax)
	-- 	hp.otherBar:SetValue(otherIncomingHeal)
	-- 	hp.otherBar:SetPoint(anchor, hbar, anchor, 0, 0)
	-- 	hp.otherBar:SetPoint(relative, previous, relative, 0, 0)
	-- 	hp.otherBar:SetReverseFill(reversed)
	-- 	previous = hp.otherBar
	-- 	hp.otherBar:Show()
	-- end

	if(hp.absorbBar) then
		hp.absorbBar:SetMinMaxValues(barMin, barMax * 0.5)
		hp.absorbBar:SetValue(totalAbsorb)
		hp.absorbBar:SetAllPoints(hbar)
		--hp.absorbBar:SetPoint(relative, previous, relative, 0, 0)
		hp.absorbBar:SetReverseFill(not reversed)
		--previous = hp.absorbBar
		hp.absorbBar:Show()
	end

	if(hp.healAbsorbBar) then
		hp.healAbsorbBar:SetMinMaxValues(barMin, barMax)
		hp.healAbsorbBar:SetValue(myCurrentHealAbsorb)
		hp.healAbsorbBar:SetPoint(anchor, hbar, anchor, 0, 0)
		hp.healAbsorbBar:SetPoint(relative, previous, relative, 0, 0)
		hp.healAbsorbBar:SetReverseFill(reversed)
		previous = hp.healAbsorbBar
		hp.healAbsorbBar:Show()
	end
end

function MOD:CreateHealPrediction(frame, fullSet)
	local health = frame.Health;
	local isReversed = false
	if(health.fillInverted and health.fillInverted == true) then
		isReversed = true
	end
	local hTex = health:GetStatusBarTexture()
	local myBar = CreateFrame('StatusBar', nil, health)
	myBar:SetFrameStrata("LOW")
	myBar:SetFrameLevel(6)
	myBar:SetStatusBarTexture([[Interface\BUTTONS\WHITE8X8]])
	myBar:SetStatusBarColor(0.15, 0.7, 0.05, 0.9)

	local absorbBar = CreateFrame('StatusBar', nil, health)
	absorbBar:SetFrameStrata("LOW")
	absorbBar:SetFrameLevel(7)
	absorbBar:SetStatusBarTexture(SuperVillain.Media.bar.gradient)
	absorbBar:SetStatusBarColor(1, 1, 0, 0.5)

	-- local otherBar = CreateFrame('StatusBar', nil, health)
	-- otherBar:SetFrameStrata("LOW")
	-- otherBar:SetFrameLevel(7)
	-- otherBar:SetStatusBarTexture([[Interface\BUTTONS\WHITE8X8]])
	-- otherBar:SetStatusBarColor(0.15, 0.9, 0.05, 0.9)

	local healPrediction = {
		myBar = myBar,
		absorbBar = absorbBar,
		maxOverflow = 1,
		reversed = isReversed,
		Override = OverrideUpdate
	}

	if(fullSet) then
		local healAbsorbBar = CreateFrame('StatusBar', nil, health)
		healAbsorbBar:SetFrameStrata("LOW")
		healAbsorbBar:SetFrameLevel(9)
		healAbsorbBar:SetStatusBarTexture(SuperVillain.Media.bar.gradient)
		healAbsorbBar:SetStatusBarColor(0.5, 0.2, 1, 0.9)
		healPrediction["healAbsorbBar"] = healAbsorbBar;
	end

	return healPrediction
end;