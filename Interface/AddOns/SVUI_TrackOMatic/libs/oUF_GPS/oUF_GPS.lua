local oUF = oUF_Villain or oUF
assert(oUF, 'oUF not loaded')

local PLUGIN = select(2, ...);

local max, floor = math.max, math.floor;
local tinsert, tremove, tsort, twipe = table.insert, table.remove, table.sort, table.wipe;

local playerGUID = UnitGUID("player")
local _FRAMES, _PROXIMITY, OnUpdateFrame = {}, {}
local minThrottle = 0.02
local numArrows, inRange, GPS
--[[ 
########################################################## 
oUF TAGS
##########################################################
]]--
local taggedUnits = {}
local groupTagManager = CreateFrame("Frame")
groupTagManager:RegisterEvent("GROUP_ROSTER_UPDATE")
groupTagManager:SetScript("OnEvent", function()
	local group, count;
	twipe(taggedUnits)
	if IsInRaid() then
		group = "raid"
		count = GetNumGroupMembers()
	elseif IsInGroup() then 
		group = "party"
		count = GetNumGroupMembers() - 1;
		taggedUnits["player"] = true 
	else
		group = "solo"
		count = 1 
	end 
	for i = 1, count do 
		local realName = group..i;
		if not UnitIsUnit(realName, "player") then
			taggedUnits[realName] = true 
		end 
	end 
end);

oUF.Tags.OnUpdateThrottle['nearbyplayers:8'] = 0.25
oUF.Tags.Methods["nearbyplayers:8"] = function(unit)
    local unitsInRange, distance = 0;
    if UnitIsConnected(unit)then 
        for taggedUnit, _ in pairs(taggedUnits)do 
            if not UnitIsUnit(unit, taggedUnit) and UnitIsConnected(taggedUnit)then 
                distance = Triangulate(unit, taggedUnit, true)
                if distance and distance <= 8 then 
                    unitsInRange = unitsInRange + 1 
                end 
            end 
        end 
    end 
    return unitsInRange
end 

oUF.Tags.OnUpdateThrottle['nearbyplayers:10'] = 0.25
oUF.Tags.Methods["nearbyplayers:10"] = function(unit)
    local unitsInRange, distance = 0;
    if UnitIsConnected(unit)then 
        for taggedUnit, _ in pairs(taggedUnits)do 
            if not UnitIsUnit(unit, taggedUnit) and UnitIsConnected(taggedUnit)then 
                distance = Triangulate(unit, taggedUnit, true)
                if distance and distance <= 10 then 
                    unitsInRange = unitsInRange + 1 
                end 
            end 
        end 
    end 
    return unitsInRange 
end 

oUF.Tags.OnUpdateThrottle['nearbyplayers:30'] = 0.25
oUF.Tags.Methods["nearbyplayers:30"] = function(unit)
    local unitsInRange, distance = 0;
    if UnitIsConnected(unit)then 
        for taggedUnit, _ in pairs(taggedUnits)do 
            if not UnitIsUnit(unit, taggedUnit) and UnitIsConnected(taggedUnit)then 
                distance = Triangulate(unit, taggedUnit, true)
                if distance and distance <= 30 then 
                    unitsInRange = unitsInRange + 1 
                end 
            end 
        end 
    end 
    return unitsInRange 
end 

oUF.Tags.OnUpdateThrottle['distance'] = 0.25
oUF.Tags.Methods["distance"] = function(unit)
    if not UnitIsConnected(unit) or UnitIsUnit(unit, "player")then return "" end 
    local dst = Triangulate("player", unit, true)
    if dst and dst > 0 then 
        return format("%d", dst)
    end 
    return ""
end
--[[ 
########################################################## 
GPS ELEMENT
##########################################################
]]--
local sortFunc = function(a,b) return a[1] < b[1] end

local Update = function(self, elapsed)
	if self.elapsed and self.elapsed > (self.throttle or minThrottle) then
		numArrows = 0
		twipe(_PROXIMITY)
		for _, object in next, _FRAMES do
			if(object:IsShown()) then
				GPS = object.GPS
				local unit = object.unit
				if(unit) then
					if(GPS.PreUpdate) then GPS:PreUpdate(frame) end

					local outOfRange = GPS.outOfRange and UnitInRange(unit) or false

					if(not unit or not (UnitInParty(unit) or UnitInRaid(unit)) or UnitIsUnit(unit, "player") or not UnitIsConnected(unit) or (not GPS.OnlyProximity and ((GPS.onMouseOver and (GetMouseFocus() ~= object)) or outOfRange))) then
						GPS:Hide()
					else
						local distance, angle = Triangulate(unit)
						if not angle then 
							GPS:Hide()
						else
							if(GPS.OnlyProximity == false) then
								GPS:Show()
							else
								GPS:Hide()
							end
							
							if GPS.Arrow then
								if(distance > 40) then
									GPS.Arrow:SetVertexColor(1,0.1,0.1)
								else
									if(distance > 30) then
										GPS.Arrow:SetVertexColor(0.4,0.8,0.1)
									else
										GPS.Arrow:SetVertexColor(0.1,1,0.1)
									end
									if(GPS.OnlyProximity and object.Health.percent and object.Health.percent < 80) then
										local value = object.Health.percent + distance
										_PROXIMITY[#_PROXIMITY + 1] = {value, GPS}
									end
								end
								GPS:Spin(angle)
							end

							if GPS.Text then
								GPS.Text:SetText(floor(distance))
							end

							if(GPS.PostUpdate) then GPS:PostUpdate(frame, distance, angle) end
							numArrows = numArrows + 1
						end
					end				
				else
					GPS:Hide()
				end
			end
		end

        if(_PROXIMITY[1]) then
        	tsort(_PROXIMITY, sortFunc)
        	if(_PROXIMITY[1][2]) then
	        	_PROXIMITY[1][2]:Show()
	        end
        end

		self.elapsed = 0
		self.throttle = max(minThrottle, 0.005 * numArrows)
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end

local Enable = function(self)
	local unit = self.unit 
	if(unit:find("raid") or unit:find("party")) then
		if not self.GPS then PLUGIN:CreateGPS(self) end
		tinsert(_FRAMES, self)

		if not OnUpdateFrame then
			OnUpdateFrame = CreateFrame("Frame")
			OnUpdateFrame:SetScript("OnUpdate", Update)
		end

		OnUpdateFrame:Show()
		return true
	end
end
 
local Disable = function(self)
	local GPS = self.GPS
	if GPS then
		for k, frame in next, _FRAMES do
			if(frame == self) then
				tremove(_FRAMES, k)
				GPS:Hide()
				break
			end
		end

		if #_FRAMES == 0 and OnUpdateFrame then
			OnUpdateFrame:Hide()
		end
	end
end

oUF:AddElement('GPS', nil, Enable, Disable)