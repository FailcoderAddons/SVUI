--GLOBAL NAMESPACE
local _G = _G;
--LUA
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type         	= _G.type;
--BLIZZARD API
local GetTime       	= _G.GetTime;
local GetSpecialization = _G.GetSpecialization;
local UnitDebuff      	= _G.UnitDebuff;

if select(2, UnitClass('player')) ~= "HUNTER" then return end

local _, ns = ...
local oUF = oUF or ns.oUF
if not oUF then return end

local FIRE_TRAP = GetSpellInfo(13813);
local ICE_TRAP = GetSpellInfo(13809);
local FROST_TRAP = GetSpellInfo(1499);
local SNAKE_TRAP = GetSpellInfo(34600);

local TRAP_IDS = {
	[1] = FIRE_TRAP, 
	[2] = ICE_TRAP, 
	[3] = FROST_TRAP, 
	[4] = SNAKE_TRAP
};

local function UpdateBar(self, elapsed)
	if not self.duration then return end
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.5 then
		local timeLeft = (self.duration - (self.duration - (GetTime() - self.start))) * 1000
		if timeLeft < self.duration then
			self:SetValue(timeLeft)
		else
			self.elapsed = 0
			self.start = nil
			self.duration = nil
			self:SetScript("OnUpdate", nil)
			self:Update(true)
		end
	end		
end

local Update = function(self, event, ...)
	local unit, spellName, _, _, spellID = ...
	if(self.unit ~= unit or not spellID) then return end
	local bar = self.HunterTraps
	if(bar.PreUpdate) then bar:PreUpdate(event) end
	local name = GetSpellInfo(spellID)
	local start, duration = GetSpellCooldown(spellID)
	duration = GetSpellBaseCooldown(spellID)
	if bar:IsShown() then		
		for i = 1, 4 do
			if(TRAP_IDS[i] == name) then
				bar[i]:Show()
				if((start and start > 0) and (duration and duration > 0)) then
					bar[i]:SetMinMaxValues(0, duration)
					bar[i]:SetValue(0)
					bar[i].start = start
					bar[i].duration = duration
					bar[i]:SetScript('OnUpdate', UpdateBar)
					bar[i]:Update(false)
				end
			end
		end		
	end
	
	if(bar.PostUpdate) then
		return bar:PostUpdate(event)
	end
end


local Path = function(self, ...)
	return (self.HunterTraps.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local bar = self.HunterTraps

	if(bar) then
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", Path)
		--self:RegisterEvent('SPELL_UPDATE_USABLE', Path)
		self:RegisterEvent("PLAYER_TALENT_UPDATE", Path)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", Path)
		bar.__owner = self
		bar.ForceUpdate = ForceUpdate

		local barWidth,barHeight = bar:GetSize()
		local trapSize = barWidth * 0.25
		for i = 1, 4 do
			if not bar[i] then
				bar[i] = CreateFrame("Statusbar", nil, bar)
				bar[i]:SetPoint("LEFT", bar, "LEFT", (trapSize * (i - 1)), 0)
				bar[i]:SetSize(trapSize,trapSize)
			end

			if not bar[i]:GetStatusBarTexture() then
				bar[i]:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
			end

			bar[i]:SetFrameLevel(bar:GetFrameLevel() + 1)
			bar[i]:GetStatusBarTexture():SetHorizTile(false)
			
			if bar[i].bg then
				bar[i]:SetMinMaxValues(0, 1)
				bar[i]:SetValue(1)
				bar[i].bg:SetAllPoints()
			end		
		end
		
		return true;
	end	
end

local function Disable(self,unit)
	local bar = self.HunterTraps

	if(bar) then
		self:UnregisterEvent('UNIT_SPELLCAST_SUCCEEDED', Path)
		--self:UnregisterEvent('SPELL_UPDATE_USABLE', Path)
		self:UnregisterEvent("PLAYER_TALENT_UPDATE", Path)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", Path)
		bar:Hide()
	end
end
			
oUF:AddElement("HunterTraps",Path,Enable,Disable)