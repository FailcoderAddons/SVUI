local parent, ns = ...
local oUF = ns.oUF

local ActionUpdate = function(self, event, unit)
	if(self.unit ~= unit) or not unit then return end
	local action = self.ActionPanel
	local border = action.border
	local special = action.special
	local showSpecial = false
	local r,g,b = 0,0,0;
	local category = UnitClassification(unit)
	if(category == "elite") then 
		r,g,b = 1,0.75,0,0.7;
		showSpecial = true
	elseif(category == "rare" or category == "rareelite") then
		r,g,b = 0.59,0.79,1,0.7;
		showSpecial = true
	end
	if(UnitIsDeadOrGhost(unit)) then
		r,g,b = 0,0,0
	end
	border[1]:SetTexture(r,g,b)
	border[2]:SetTexture(r,g,b)
	border[3]:SetTexture(r,g,b)
	border[4]:SetTexture(r,g,b)
	if(special) then
		if(showSpecial) then
			special[1]:SetVertexColor(r,g,b)
			special[2]:SetVertexColor(r,g,b)
			special[3]:SetVertexColor(r,g,b)
			special:Show()
		else
			special:Hide()
		end
	end
end

local StatusUpdate = function(self, event, unit)
	if(self.unit ~= unit) or not unit then return end
	local action = self.ActionPanel
	local border = action.border
	local special = action.special
	local showSpecial = false
	local r,g,b = 0,0,0;
	local category = UnitClassification(unit)
	local status = self.StatusPanel
	local texture = status.texture
	local media = status.media

	if(category == "elite") then 
		r,g,b = 1,0.75,0,0.7;
		showSpecial = true
	elseif(category == "rare" or category == "rareelite") then
		r,g,b = 0.59,0.79,1,0.7;
		showSpecial = true
	end
	if(UnitIsDeadOrGhost(unit)) then
		r,g,b = 0,0,0
	end
	border[1]:SetTexture(r,g,b)
	border[2]:SetTexture(r,g,b)
	border[3]:SetTexture(r,g,b)
	border[4]:SetTexture(r,g,b)
	if(special) then
		if(showSpecial) then
			special[1]:SetVertexColor(r,g,b)
			special[2]:SetVertexColor(r,g,b)
			special[3]:SetVertexColor(r,g,b)
			special:Show()
		else
			special:Hide()
		end
	end

	if(not UnitIsConnected(unit)) then
		texture:SetAlpha(1)
		texture:SetTexture(media[1])
		texture:SetGradient("VERTICAL",0,1,1,1,1,0)
	elseif(UnitIsDeadOrGhost(unit)) then
		texture:SetAlpha(1)
		texture:SetTexture(media[2])
		texture:SetGradient("VERTICAL",0,0,1,0,1,0)
	elseif(UnitIsTapped(unit) and (not UnitIsTappedByPlayer(unit))) then
		texture:SetAlpha(1)
		texture:SetTexture(media[3])
		texture:SetGradient("VERTICAL",1,1,0,1,0,0)
	else
		texture:SetAlpha(0)
	end
end

local Path = function(self, ...)
	return (self.ActionPanel.Override or ActionUpdate) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate')
end

local Enable = function(self, unit)
	local action = self.ActionPanel
	if(action) then
		action.__owner = self
		action.ForceUpdate = ForceUpdate
		local status = self.StatusPanel
		if(status and status.texture) then
			action.Override = StatusUpdate
			self:RegisterEvent('UNIT_FACTION', Path)
		end
		self:RegisterEvent("UNIT_TARGET", Path, true)
		self:RegisterEvent("PLAYER_TARGET_CHANGED", Path, true)
		return true
	end
end

local Disable = function(self)
	local action = self.ActionPanel
	if(action) then
		local status = self.StatusPanel
		if(status) then
			if(self:IsEventRegistered("UNIT_FACTION")) then
				self:UnregisterEvent("UNIT_FACTION", Path)
			end
		end
		if(self:IsEventRegistered("PLAYER_TARGET_CHANGED")) then
			self:UnregisterEvent("PLAYER_TARGET_CHANGED", Path)
		end
		if(self:IsEventRegistered("UNIT_TARGET")) then
			self:UnregisterEvent("UNIT_TARGET", Path)
		end
	end
end

oUF:AddElement('ActionPanel', Path, Enable, Disable)
