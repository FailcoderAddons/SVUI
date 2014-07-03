local parent, ns = ...
local oUF = ns.oUF

oUF.colors.totems = {
	[FIRE_TOTEM_SLOT] = { 181/255, 073/255, 033/255 },
	[EARTH_TOTEM_SLOT] = { 074/255, 142/255, 041/255 },
	[WATER_TOTEM_SLOT] = { 057/255, 146/255, 181/255 },
	[AIR_TOTEM_SLOT] = { 132/255, 056/255, 231/255 }
}

local priorities = STANDARD_TOTEM_PRIORITIES
if(select(2, UnitClass'player') == 'SHAMAN') then
	priorities = SHAMAN_TOTEM_PRIORITIES
end

local OnClick = function(self)
	DestroyTotem(self:GetID())
end

local UpdateTooltip = function(self)
	GameTooltip:SetTotem(self:GetID())
end

local OnEnter = function(self)
	if(not self:IsVisible()) then return end
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	self:UpdateTooltip()
end

local OnLeave = function()
	GameTooltip:Hide()
end

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

local UpdateTotem = function(self, event, slot)
	if(slot > MAX_TOTEMS) then return end
	local totems = self.TotemBars

	local totem = totems[priorities[slot]]
	if(totem) then
		local haveTotem, name, start, duration, icon = GetTotemInfo(slot)
		local timeLeft = (start + duration) - GetTime()
		totem:SetMinMaxValues(0,duration)

		if(timeLeft > 0) then
			totem.expirationTime = (start + duration)
			totem:SetValue(timeLeft)
			totem:SetScript('OnUpdate', UpdateBar)
		else
			totem:SetValue(0)
			totem:SetScript('OnUpdate', nil)
		end
	end
end

local Update = function(self, event)
	local totems = self.TotemBars
	if(totems.PreUpdate) then totems:PreUpdate() end

	for i = 1, MAX_TOTEMS do
		UpdateTotem(self, event, i)
	end

	if(totems.PostUpdate) then
		return totems:PostUpdate()
	end
end

local Path = function(self, ...)
	return (self.TotemBars.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate')
end

local Enable = function(self)
	local totems = self.TotemBars

	if(totems) then
		totems.__owner = self
		totems.__map = { unpack(priorities) }
		totems.ForceUpdate = ForceUpdate

		for i = 1, MAX_TOTEMS do
			local totem = totems[i]
			totem:SetID(priorities[i])

			if(totem:HasScript'OnClick') then
				totem:SetScript('OnClick', OnClick)
			end

			if(totem:IsMouseEnabled()) then
				totem:SetScript('OnEnter', OnEnter)
				totem:SetScript('OnLeave', OnLeave)

				if(not totem.UpdateTooltip) then
					totem.UpdateTooltip = UpdateTooltip
				end
			end
		end

		self:RegisterEvent('PLAYER_TOTEM_UPDATE', Path, true)

		TotemFrame.Show = TotemFrame.Hide
		TotemFrame:Hide()

		TotemFrame:UnregisterEvent"PLAYER_TOTEM_UPDATE"
		TotemFrame:UnregisterEvent"PLAYER_ENTERING_WORLD"
		TotemFrame:UnregisterEvent"UPDATE_SHAPESHIFT_FORM"
		TotemFrame:UnregisterEvent"PLAYER_TALENT_UPDATE"

		return true
	end
end

local Disable = function(self)
	if(self.TotemBars) then
		for i = 1, MAX_TOTEMS do
			self.TotemBars[i]:Hide()
		end
		TotemFrame.Show = nil
		TotemFrame:Show()

		TotemFrame:RegisterEvent"PLAYER_TOTEM_UPDATE"
		TotemFrame:RegisterEvent"PLAYER_ENTERING_WORLD"
		TotemFrame:RegisterEvent"UPDATE_SHAPESHIFT_FORM"
		TotemFrame:RegisterEvent"PLAYER_TALENT_UPDATE"

		self:UnregisterEvent('PLAYER_TOTEM_UPDATE', Path)
	end
end

oUF:AddElement("TotemBars", Path, Enable, Disable)
