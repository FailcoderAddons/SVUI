if select(2, UnitClass('player')) ~= "WARLOCK" then return end

local _, ns = ...
local oUF = ns.oUF or oUF

assert(oUF, 'oUF_WarlockShards was unable to locate oUF install')

local MAX_POWER_PER_EMBER = 10
local SPELL_POWER_DEMONIC_FURY = SPELL_POWER_DEMONIC_FURY
local SPELL_POWER_BURNING_EMBERS = SPELL_POWER_BURNING_EMBERS
local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS
local SPEC_WARLOCK_DESTRUCTION = SPEC_WARLOCK_DESTRUCTION
local SPEC_WARLOCK_AFFLICTION = SPEC_WARLOCK_AFFLICTION
local SPEC_WARLOCK_DEMONOLOGY = SPEC_WARLOCK_DEMONOLOGY

oUF.colors.WarlockShards = {
	[1] = {100/255, 0/255, 255/255},
	[2] = {180/255, 30/255, 255/255},
	[3] = {255/255, 115/255, 10/255}
}

local Update = function(self, event, unit, powerType)
	local wsb = self.WarlockShards
	if(wsb.PreUpdate) then wsb:PreUpdate(unit) end
	
	if UnitHasVehicleUI("player") then
		wsb:Hide()
	else
		wsb:Show()
	end
	
	local spec = GetSpecialization()
	if spec then
		if not wsb:IsShown() then 
			wsb:Show()
		end

		for i = 1, 4 do
			wsb[i]:Show()
			wsb[i]:SetStatusBarColor(unpack(oUF.colors.WarlockShards[spec]))
		end

		if (spec == SPEC_WARLOCK_DESTRUCTION) then	
			local maxPower = UnitPowerMax("player", SPELL_POWER_BURNING_EMBERS, true)
			local power = UnitPower("player", SPELL_POWER_BURNING_EMBERS, true)
			local numEmbers = power / MAX_POWER_PER_EMBER
			local numBars = floor(maxPower / MAX_POWER_PER_EMBER)
			wsb.number = numBars
			
			-- bar unavailable
			if numBars == 3 then
				wsb[4]:Hide()
			else
				wsb[4]:Show()
			end

			for i = 1, numBars do
				wsb[i]:SetMinMaxValues((MAX_POWER_PER_EMBER * i) - MAX_POWER_PER_EMBER, MAX_POWER_PER_EMBER * i)
				wsb[i]:SetValue(power)
			end
		elseif ( spec == SPEC_WARLOCK_AFFLICTION ) then
			local numShards = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
			local maxShards = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS)
			wsb.number = maxShards
			
			-- bar unavailable
			if maxShards == 3 then
				wsb[4]:Hide()
			else
				wsb[4]:Show()
			end
			
			for i = 1, maxShards do
				wsb[i]:SetMinMaxValues(0, 1)
				if i <= numShards then
					wsb[i]:SetValue(1)
				else
					wsb[i]:SetValue(0)
				end
			end
		elseif spec == SPEC_WARLOCK_DEMONOLOGY then
			local power = UnitPower("player", SPELL_POWER_DEMONIC_FURY)
			local maxPower = UnitPowerMax("player", SPELL_POWER_DEMONIC_FURY)
			
			wsb.number = 1
			wsb[2]:Hide()
			wsb[3]:Hide()
			wsb[4]:Hide()
			
			wsb[1]:SetMinMaxValues(0, maxPower)
			wsb[1]:SetValue(power)
		end
	else
		if wsb:IsShown() then 
			wsb:Hide()
		end
	end

	if(wsb.PostUpdate) then
		return wsb:PostUpdate(unit, spec)
	end
end

local Path = function(self, ...)
	return (self.WarlockShards.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'SOUL_SHARDS')
end

local function Enable(self, unit)
	if(unit ~= 'player') then return end
	
	local wsb = self.WarlockShards
	if(wsb) then
		wsb.__owner = self
		wsb.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER', Path)
		self:RegisterEvent("PLAYER_TALENT_UPDATE", Path)
		
		for i = 1, 4 do
			if not wsb[i]:GetStatusBarTexture() then
				Point:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
			end

			wsb[i]:SetFrameLevel(wsb:GetFrameLevel() + 1)
			wsb[i]:GetStatusBarTexture():SetHorizTile(false)
		end
		
		wsb.number = 4

		return true
	end
end

local function Disable(self)
	local wsb = self.WarlockShards
	if(wsb) then
		self:UnregisterEvent('UNIT_POWER', Path)
		self:UnregisterEvent("PLAYER_TALENT_UPDATE", Path)
		wsb:Hide()
	end
end

oUF:AddElement('WarlockShards', Path, Enable, Disable)