local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF not loaded')

local cos, sin, sqrt2, max, atan2, floor = math.cos, math.sin, math.sqrt(2), math.max, math.atan2, math.floor;
local tinsert, tremove = table.insert, table.remove;
local _FRAME, _GPS, _TRACKER, _SWITCH, _ARROW, _SPINNER, _TEXT, _HANDLER;
local spin, unit, angle, distance;
local SuperVillain;

do
	local function _calc(radius)
		return 0.5 + cos(radius) / sqrt2, 0.5 + sin(radius) / sqrt2;
	end

	function spin(texture, angle)
		local LRx, LRy = _calc(angle + 0.785398163);
		local LLx, LLy = _calc(angle + 2.35619449);
		local ULx, ULy = _calc(angle + 3.92699082);
		local URx, URy = _calc(angle - 0.785398163);
		
		texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy);
	end
end

local Update = function(self, elapsed)
	if self.elapsed and self.elapsed > (self.throttle or 0.02) then
		unit = _FRAME.unit
		if((UnitInParty(unit) or UnitInRaid(unit)) and not UnitIsUnit(unit, "player")) then
			_SWITCH.Trackable = true
		else
			_SWITCH.Trackable = false
		end
		if(_SWITCH.Trackable) then
			if(_TRACKER:IsShown()) then
				_SWITCH:Hide()
				if(not SuperVillain) then SuperVillain = SVUI[1] end
				distance, angle = SuperVillain:Triangulate("player", unit, true)
				if not angle then 
					_TRACKER:Hide()
					_SWITCH:Show()
				else
					local out = floor(tonumber(distance))
					spin(_ARROW, angle)
					if(out > 100) then
						_ARROW:SetVertexColor(1,0.1,0.1)
						_SPINNER:SetVertexColor(0.8,0.1,0.1,0.5)
					elseif(out > 40) then
						_ARROW:SetVertexColor(1,0.8,0.1)
						_SPINNER:SetVertexColor(0.8,0.8,0.1,0.5)
					elseif(out > 5) then
						_ARROW:SetVertexColor(0.1,1,0.8)
						_SPINNER:SetVertexColor(0.1,0.8,0.8,0.5)
					else
						_TRACKER:Hide()
						_SWITCH:Show()
					end
					_TEXT:SetText(out)
				end
			end				
		else
			_TRACKER:Hide()
			_SWITCH:Show()
		end
		self.elapsed = 0
		self.throttle = 0.02
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end

local function Path(self, ...)
	return (self.GPS.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local Enable = function(self)
	if(self.GPS) then
		_FRAME 	 = self
		_GPS 	 = self.GPS
		_TRACKER = self.GPS.Tracker
		_SWITCH  = self.GPS.Switch
		_ARROW	 = self.GPS.Tracker.Arrow
		_SPINNER = self.GPS.Tracker.Spinner
		_TEXT	 = self.GPS.Tracker.Text
		_GPS.__owner 	 = self
		_GPS.ForceUpdate = ForceUpdate

		--self:RegisterEvent('PLAYER_TARGET_CHANGED', Path)

		if not _HANDLER then
			_HANDLER = CreateFrame("Frame")
			_HANDLER:SetScript("OnUpdate", Update)
		end
		_GPS:Show()
		return true
	end
end
 
local Disable = function(self)
	if self.GPS then
		self.GPS.LoopEnabled = nil
		self.GPS:Hide()
		--self:UnregisterEvent('PLAYER_TARGET_CHANGED', Path)
		_FRAME 	 = nil
		_GPS 	 = nil
		_TRACKER = nil
		_SWITCH  = nil
		_ARROW	 = nil
		_SPINNER = nil
		_TEXT	 = nil
	end
end
 
oUF:AddElement('GPS', nil, Enable, Disable)