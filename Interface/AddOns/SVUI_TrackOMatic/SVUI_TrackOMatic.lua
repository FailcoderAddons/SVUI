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
local type      = _G.type;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert   = _G.tinsert;
local tremove   = _G.tremove;
local string    = _G.string;
local math      = _G.math;
local bit       = _G.bit;
local table     = _G.table;
--[[ STRING METHODS ]]--
local format, find, lower, match = string.format, string.find, string.lower, string.match;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
local fmod, modf, sqrt = math.fmod, math.modf, math.sqrt;   -- Algebra
local atan2, cos, deg, rad, sin = math.atan2, math.cos, math.deg, math.rad, math.sin;  -- Trigonometry
local min, huge, random = math.min, math.huge, math.random;  -- Uncommon
local sqrt2, max = math.sqrt(2), math.max;
--[[ TABLE METHODS ]]--
local tcopy, twipe, tsort, tconcat, tdump = table.copy, table.wipe, table.sort, table.concat, table.dump;
--[[ BINARY METHODS ]]--
local band = bit.band;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local PLUGIN = select(2, ...)
local Schema = PLUGIN.Schema;
local VERSION = PLUGIN.Version;

local SV = _G["SVUI"];
local L = SV.L;
--[[ 
########################################################## 
LOCALS AND BINDING
##########################################################
]]--
BINDING_HEADER_SVUITRACK = "Supervillain UI: Track-O-Matic";
BINDING_NAME_SVUITRACK_DOODAD = "Toggle Tracking Device";

local NewHook = hooksecurefunc;
local playerGUID = UnitGUID('player')
local classColor = RAID_CLASS_COLORS
local radian90 = (3.141592653589793 / 2) * -1;
local GetDistance, GetTarget, GetFromPlayer;
--[[ 
########################################################## 
BUILD
##########################################################
]]--
function SVUI_TrackingDoodad_OnLoad()
    local frame = _G["SVUI_TrackingDoodad"]
    frame.Border:SetGradient(unpack(SV.Media.gradient.special))
    frame.Arrow:SetVertexColor(0.1, 0.8, 0.8)
    frame.Range:SetFont(SV.Media.font.roboto, 14, "OUTLINE")
    frame.Range:SetTextColor(1, 1, 1, 0.75)
    SV.Animate:Orbit(frame.Radar, 8, true)
    frame:RegisterForDrag("LeftButton");
    frame:Hide()
end

function SVUIToggleTrackingDoodad()
    if(not SVUI_TrackingDoodad.Trackable) then
        SVUI_TrackingDoodad.Trackable = true
        if((UnitInParty("target") or UnitInRaid("target")) and not UnitIsUnit("target", "player")) then
            SVUI_TrackingDoodad:Show()
        end
        SV:AddonMessage("Tracking Device |cff00FF00Enabled|r")
    else
        SVUI_TrackingDoodad.Trackable = false
        SVUI_TrackingDoodad:Hide()
        SV:AddonMessage("Tracking Device |cffFF0000Disabled|r")
    end
end

do
    local WORLDMAPAREA_DEFAULT_DUNGEON_FLOOR_IS_TERRAIN = 0x00000004
    local WORLDMAPAREA_VIRTUAL_CONTINENT = 0x00000008
    local DUNGEONMAP_MICRO_DUNGEON = 0x00000001
    local _failsafe, _cache, _dungeons, _transform = {}, {}, {}, {};

    local _mapdata = {
        [0] = {
            height = 22266.74312,
            system = -1,
            width = 33400.121,
            xOffset = 0,
            yOffset = 0,
            [1] = {
                xOffset = -10311.71318,
                yOffset = -19819.33898,
                scale = 0.56089997291565,
            },
            [0] = {
                xOffset = -48226.86993,
                yOffset = -16433.90283,
                scale = 0.56300002336502,
            },
            [571] = {
                xOffset = -29750.89905,
                yOffset = -11454.50802,
                scale = 0.5949000120163,
            },
            [870] = {
                xOffset = -27693.71178,
                yOffset = -29720.0585,
                scale = 0.65140002965927,
            },
        },
    }

    local _failsafeFunc = function(tbl, key)
        if(type(key) == "number") then
            return _failsafe;
        else
            return rawget(_failsafe, key);
        end
    end

    setmetatable(_failsafe, { xOffset = 0, height = 1, yOffset = 0, width = 1, __index = _failsafeFunc });
    setmetatable(_mapdata, _failsafe);

    for _, ID in ipairs(GetWorldMapTransforms()) do
        local terrain, newterrain, _, _, transformMinY, transformMaxY, transformMinX, transformMaxX, offsetY, offsetX = GetWorldMapTransformInfo(ID)
        if ( offsetX ~= 0 or offsetY ~= 0 ) then
            _transform[ID] = {
                terrain = terrain,
                newterrain = newterrain,
                BRy = -transformMinY,
                TLy = -transformMaxY,
                BRx = -transformMinX,
                TLx = -transformMaxX,
                offsetY = offsetY,
                offsetX = offsetX,
            }
        end
    end

    local function _getmapdata(t)
        local chunk = {}
        local mapName = GetMapInfo();
        local id = GetCurrentMapAreaID();
        local numFloors = GetNumDungeonMapLevels();
        chunk.mapName = mapName;
        chunk.cont = (GetCurrentMapContinent()) or -100;
        chunk.zone = (GetCurrentMapZone()) or -100;
        chunk.numFloors = numFloors;
        local _, TLx, TLy, BRx, BRy = GetCurrentMapZone();
        if(TLx and TLy and BRx and BRy and (TLx~=0 or TLy~=0 or BRx~=0 or BRy~=0)) then
            chunk[0] = {};
            chunk[0].TLx = TLx;
            chunk[0].TLy = TLy;
            chunk[0].BRx = BRx;
            chunk[0].BRy = BRy;
        end
        if(not chunk[0] and numFloors == 0 and (GetCurrentMapDungeonLevel()) == 1) then
            numFloors = 1;
            chunk.hiddenFloor = true;
        end
        if(numFloors > 0) then
            for f = 1, numFloors do
                SetDungeonMapLevel(f);
                local _, TLx, TLy, BRx, BRy = GetCurrentMapDungeonLevel();
                if(TLx and TLy and BRx and BRy) then
                    chunk[f] = {};
                    chunk[f].TLx = TLx;
                    chunk[f].TLy = TLy;
                    chunk[f].BRx = BRx;
                    chunk[f].BRy = BRy;
                end
            end
        end

        t[id] = chunk;
    end

    do
        local continents = { GetMapContinents() };
        for C in pairs(continents) do
            local zones = { GetMapZones(C) };
            continents[C] = zones;
            local pass, error = pcall(SetMapZoom, C, 0)
            if(pass) then
                zones[0] = GetCurrentMapAreaID();
                _getmapdata(_cache);
                for Z in ipairs(zones) do
                    SetMapZoom(C, Z);
                    zones[Z] = GetCurrentMapAreaID();
                    _getmapdata(_cache);
                end
            end
        end
        
        for _, id in ipairs(GetAreaMaps()) do
            if not (_cache[id]) then
                if(SetMapByID(id)) then
                    _getmapdata(_cache);
                end
            end
        end
    end

    for id, map in pairs(_cache) do
        local terrain, _, _, _, _, _, _, _, _, flags = GetAreaMapInfo(id)
        local origin = terrain;
        local chunk = _mapdata[id];
        if not (chunk) then chunk = {}; end
        if(map.numFloors > 0 or map.hiddenFloor) then
            for f, coords in pairs(map) do
                if(type(f) == "number" and f > 0) then
                    if not (chunk[f]) then
                        chunk[f] = {};
                    end
                    local flr = chunk[f]
                    local TLx, TLy, BRx, BRy = -coords.BRx, -coords.BRy, -coords.TLx, -coords.TLy
                    if not (flr.width) then
                        flr.width = BRx - TLx
                    end
                    if not (flr.height) then
                        flr.height = BRy - TLy
                    end
                    if not (flr.xOffset) then
                        flr.xOffset = TLx
                    end
                    if not (flr.yOffset) then
                        flr.yOffset = TLy
                    end
                end
            end
            for f = 1, map.numFloors do
                if not (chunk[f]) then
                    if(f == 1 and map[0] and map[0].TLx and map[0].TLy and map[0].BRx and map[0].BRy and
                      band(flags, WORLDMAPAREA_DEFAULT_DUNGEON_FLOOR_IS_TERRAIN) == WORLDMAPAREA_DEFAULT_DUNGEON_FLOOR_IS_TERRAIN) then
                        chunk[f] = {};
                        local flr = chunk[f]
                        local coords = map[0]
                        local TLx, TLy, BRx, BRy = -coords.TLx, -coords.TLy, -coords.BRx, -coords.BRy
                        flr.width = BRx - TLx
                        flr.height = BRy - TLy
                        flr.xOffset = TLx
                        flr.yOffset = TLy
                    end
                end
            end
            if(map.hiddenFloor) then
                chunk.width = chunk[1].width
                chunk.height = chunk[1].height
                chunk.xOffset = chunk[1].xOffset
                chunk.yOffset = chunk[1].yOffset
            end
        else
            local coords = map[0]
            if(coords ~= nil) then
                local TLx, TLy, BRx, BRy = -coords.TLx, -coords.TLy, -coords.BRx, -coords.BRy
                for _, trans in pairs(_transform) do
                    if(trans.terrain == terrain) then
                        if((trans.TLx < TLx and BRx < trans.BRx) and (trans.TLy < TLy and BRy < trans.BRy)) then
                            TLx = TLx - trans.offsetX;
                            BRx = BRx - trans.offsetX;
                            BRy = BRy - trans.offsetY;
                            TLy = TLy - trans.offsetY;
                            terrain = trans.newterrain;
                            break;
                        end
                    end
                end
                if not (TLx==0 and TLy==0 and BRx==0 and BRy==0) then
                    if not (TLx < BRx) then
                        printError("Bad x-axis Orientation (Zone): ", id, TLx, BRx);
                    end
                    if not (TLy < BRy) then
                        printError("Bad y-axis Orientation (Zone): ", id, TLy, BRy);
                    end
                end
                if not (chunk.width) then
                    chunk.width = BRx - TLx
                end
                if not (chunk.height) then
                    chunk.height = BRy - TLy
                end
                if not (chunk.xOffset) then
                    chunk.xOffset = TLx
                end
                if not (chunk.yOffset) then
                    chunk.yOffset = TLy
                end
            end
        end
        if not (next(chunk, nil)) then
            chunk = { xOffset = 0, height = 1, yOffset = 0, width = 1 };
        end
        if not (chunk.origin) then
            chunk.origin = origin;
        end
        _mapdata[id] = chunk;
        if(chunk and chunk ~= _failsafe) then
            if not (chunk.system) then
                chunk.system = terrain;
            end
            if(map.cont > 0 and map.zone > 0) then
                _dungeons[terrain] = {}
            end
            setmetatable(chunk, _failsafe);
        end
    end

    local function _getpos(map, mapFloor, x, y)
        if not map then return end
        if (mapFloor ~= 0) then
            map = rawget(map, mapFloor) or _dungeons[map.origin][mapFloor];
        end
        x = x * map.width + map.xOffset;
        y = y * map.height + map.yOffset;
        return x, y;
    end

    function GetDistance(map1, floor1, x1, y1, map2, floor2, x2, y2)
        if not (map1 and map2) then return end 
        floor1 = floor1 or min(#_mapdata[map1], 1);
        floor2 = floor2 or min(#_mapdata[map2], 1);
        local dist, xDelta, yDelta, angle;
        if(map1 == map2 and floor1 == floor2) then
            local chunk = _mapdata[map1];
            local tmp = chunk
            if(floor1 ~= 0) then
                tmp = rawget(chunk, floor1)
            end
            local w,h = 1,1
            if(not tmp) then
                if(_dungeons[chunk.origin] and _dungeons[chunk.origin][floor1]) then
                    chunk = _dungeons[chunk.origin][floor1]
                    w = chunk.width
                    h = chunk.height
                else
                    w = 1
                    h = 1
                end
            else
                w = chunk.width
                h = chunk.height
            end
            xDelta = (x2 - x1) * (w or 1);
            yDelta = (y2 - y1) * (h or 1);
        else
            local map1 = _mapdata[map1];
            local map2 = _mapdata[map2];
            if(map1.system == map2.system) then
                x1, y1 = _getpos(map1, floor1, x1, y1);
                x2, y2 = _getpos(map2, floor2, x2, y2);
                xDelta = (x2 - x1);
                yDelta = (y2 - y1);
            else
                local s1 = map1.system;
                local s2 = map2.system;
                if((map1==0 or _mapdata[0][s1]) and (map2 == 0 or _mapdata[0][s2])) then
                    x1, y1 = _getpos(map1, floor1, x1, y1);
                    x2, y2 = _getpos(map2, floor2, x2, y2);
                    if(map1 ~= 0) then
                        local cont1 = _mapdata[0][s1];
                        x1 = (x1 - cont1.xOffset) * cont1.scale;
                        y1 = (y1 - cont1.yOffset) * cont1.scale;
                    end
                    if(map2 ~= 0) then
                        local cont2 = _mapdata[0][s2];
                        x2 = (x2 - cont2.xOffset) * cont2.scale;
                        y2 = (y2 - cont2.yOffset) * cont2.scale; 
                    end
                    xDelta = x2 - x1;
                    yDelta = y2 - y1;
                end
            end
        end

        if(xDelta and yDelta) then
            local playerAngle = GetPlayerFacing()
            dist = sqrt(xDelta * xDelta + yDelta * yDelta);
            angle = (radian90 - playerAngle) - atan2(yDelta, xDelta)
        end

        return dist, angle;
    end
end

do
    local function _findunit(unit, doNotCheckMap)
        local x, y = GetPlayerMapPosition(unit);
        if(x <= 0 and y <= 0) then
            if(doNotCheckMap) then return; end
            local lastMapID, lastFloor = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel();
            SetMapToCurrentZone();
            x, y = GetPlayerMapPosition(unit);
            if(x <= 0 and y <= 0) then
                    if(ZoomOut()) then
                    elseif(GetCurrentMapZone() ~= WORLDMAP_WORLD_ID) then
                        SetMapZoom(GetCurrentMapContinent());
                    else
                        SetMapZoom(WORLDMAP_WORLD_ID);
                    end
                x, y = GetPlayerMapPosition(unit);
                if(x <= 0 and y <= 0) then
                    return;
                end
            end
            local thisMapID, thisFloor = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel();
            if(thisMapID ~= lastMapID or thisFloor ~= lastFloor) then
                SetMapByID(lastMapID);
                SetDungeonMapLevel(lastFloor);
            end
            return thisMapID, thisFloor, x, y;
        end
        return GetCurrentMapAreaID(), GetCurrentMapDungeonLevel(), x, y;
    end

    local function _findplayer()
        local x, y = GetPlayerMapPosition("player");
        if(x <= 0 and y <= 0) then
            if(WorldMap and WorldMap:IsShown()) then return end
            SetMapToCurrentZone();
            x, y = GetPlayerMapPosition("player");
            if(x <= 0 and y <= 0) then
                    if(ZoomOut()) then
                    elseif(GetCurrentMapZone() ~= WORLDMAP_WORLD_ID) then
                        SetMapZoom(GetCurrentMapContinent());
                    else
                        SetMapZoom(WORLDMAP_WORLD_ID);
                    end
                x, y = GetPlayerMapPosition("player");
                if(x <= 0 and y <= 0) then
                    return;
                end
            end
        end
        return GetCurrentMapAreaID(), GetCurrentMapDungeonLevel(), x, y;
    end

    function GetTarget(unit, doNotCheckMap)
        local plot1, plot2, plot3, plot4;
        if unit == "player" or UnitIsUnit("player", unit) then 
            plot1, plot2, plot3, plot4 = _findplayer()
        else 
            plot1, plot2, plot3, plot4 = _findunit(unit, doNotCheckMap or WorldMapFrame:IsVisible())
        end 
        if not (plot1 and plot4) then 
            return false 
        else 
            return true, plot1, plot2, plot3, plot4 
        end 
    end

    function GetFromPlayer(unit, noMapLocation)
        if(WorldMap and WorldMap:IsShown()) then return end
        local plot3, plot4 = GetPlayerMapPosition("player");
        if(plot3 <= 0 and plot4 <= 0) then
            SetMapToCurrentZone();
            plot3, plot4 = GetPlayerMapPosition("player");
            if(plot3 <= 0 and plot4 <= 0) then
                    if(ZoomOut()) then
                    elseif(GetCurrentMapZone() ~= WORLDMAP_WORLD_ID) then
                        SetMapZoom(GetCurrentMapContinent());
                    else
                        SetMapZoom(WORLDMAP_WORLD_ID);
                    end
                plot3, plot4 = GetPlayerMapPosition("player");
                if(plot3 <= 0 and plot4 <= 0) then
                    return;
                end
            end
        end

        local plot1 = GetCurrentMapAreaID()
        local plot2 = GetCurrentMapDungeonLevel()

        local plot5, plot6;
        local plot7, plot8 = GetPlayerMapPosition(unit);

        if(noMapLocation and (plot7 <= 0 and plot8 <= 0)) then
            local lastMapID, lastFloor = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel();
            SetMapToCurrentZone();
            plot7, plot8 = GetPlayerMapPosition(unit);
            if(plot7 <= 0 and plot8 <= 0) then
                    if(ZoomOut()) then
                    elseif(GetCurrentMapZone() ~= WORLDMAP_WORLD_ID) then
                        SetMapZoom(GetCurrentMapContinent());
                    else
                        SetMapZoom(WORLDMAP_WORLD_ID);
                    end
                plot7, plot8 = GetPlayerMapPosition(unit);
                if(plot7 <= 0 and plot8 <= 0) then
                    return;
                end
            end
            plot5, plot6 = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel();
            if(plot5 ~= lastMapID or plot6 ~= lastFloor) then
                SetMapByID(lastMapID);
                SetDungeonMapLevel(lastFloor);
            end
            local distance, angle = GetDistance(plot1, plot2, plot3, plot4, plot5, plot6, plot7, plot8)
            return distance, angle
        end

        local distance, angle = GetDistance(plot1, plot2, plot3, plot4, plot1, plot2, plot7, plot8)
        return distance, angle
    end
end

function Triangulate(unit, noMapLocation)
    local distance, angle = GetFromPlayer(unit, noMapLocation)
    return distance, angle 
end 
--[[ 
########################################################## 
MAIN MOVABLE TRACKER
##########################################################
]]--
function PLUGIN:PLAYER_TARGET_CHANGED()
    if not SVUI_TrackingDoodad then return end
    if((UnitInParty("target") or UnitInRaid("target")) and not UnitIsUnit("target", "player")) then
        SVUI_TrackingDoodad.Trackable = true
        SVUI_TrackingDoodad:Show()
    else
        SVUI_TrackingDoodad.Trackable = false
    end
end

local Rotate_Arrow = function(self, angle)
    local radius, ULx, ULy, LLx, LLy, URx, URy, LRx, LRy

    radius = angle - 0.785398163
    URx = 0.5 + cos(radius) / sqrt2
    URy =  0.5 + sin(radius) / sqrt2
    -- (-1)
    radius = angle + 0.785398163
    LRx = 0.5 + cos(radius) / sqrt2
    LRy =  0.5 + sin(radius) / sqrt2
    -- 1
    radius = angle + 2.35619449
    LLx = 0.5 + cos(radius) / sqrt2
    LLy =  0.5 + sin(radius) / sqrt2
    -- 3
    radius = angle + 3.92699082
    ULx = 0.5 + cos(radius) / sqrt2
    ULy =  0.5 + sin(radius) / sqrt2
    -- 5
    
    self.Arrow:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy);
end

local TargetFrame_OnChange = function()
    if not SVUI_TrackingDoodad then return end
    if((UnitInParty("target") or UnitInRaid("target")) and not UnitIsUnit("target", "player")) then
        SVUI_TrackingDoodad.Trackable = true
        SVUI_TrackingDoodad:Show()
    else
        SVUI_TrackingDoodad.Trackable = false
    end
end

local Tracker_OnUpdate = function(self, elapsed)
    if self.elapsed and self.elapsed > (self.throttle or 0.02) then
        if(self.Trackable) then
            local distance, angle = Triangulate("target", true)
            if not angle then
                self.throttle = 4
                self.Arrow:SetAlpha(0)
                self.Radar:SetVertexColor(0.8,0.1,0.1,0.15)
                self.BG:SetVertexColor(1,0,0,0.15)
            else
                self.throttle = 0.02
                local range = floor(tonumber(distance))
                self:Spin(angle)
                if(range > 100) then
                    self.Arrow:SetVertexColor(1,0.1,0.1,0.4)
                    self.Radar:SetVertexColor(0.8,0.1,0.1,0.25)
                    self.BG:SetVertexColor(0.8,0.4,0.1,0.25)
                elseif(range > 40) then
                    self.Arrow:SetVertexColor(1,0.8,0.1,0.6)
                    self.Radar:SetVertexColor(0.8,0.8,0.1,0.5)
                    self.BG:SetVertexColor(0.4,0.8,0.1,0.5)
                elseif(range > 5) then
                    self.Arrow:SetVertexColor(0.1,1,0.8,0.9)
                    self.Radar:SetVertexColor(0.1,0.8,0.8,0.75)
                    self.BG:SetVertexColor(0.1,0.8,0.1,0.75)
                end
                self.Arrow:SetAlpha(1)
                self.Range:SetText(range)
            end            
        else
            self:Hide()
        end
        self.elapsed = 0
    else
        self.elapsed = (self.elapsed or 0) + elapsed
    end
end
--[[ 
########################################################## 
GROUP UNIT TRACKERS
##########################################################
]]--
local GPS_Triangulate = function(self, unit)
    local available = (self.OnlyProximity == false and self.onMouseOver == false)
    local distance, angle = Triangulate(unit, available)
    return distance, angle
end

local RefreshGPS = function(self, frame, template)
    if(frame.GPS) then
        local config = SV.db[Schema]
        if(config.groups) then
            frame.GPS.OnlyProximity = config.proximity
            local actualSz = min(frame.GPS.DefaultSize, (frame:GetHeight() - 2))
            if(not frame:IsElementEnabled("GPS")) then
                frame:EnableElement("GPS")
            end
        else
            if(frame:IsElementEnabled("GPS")) then
                frame:DisableElement("GPS")
            end
        end
    end 
end

function PLUGIN:CreateGPS(frame)
    if not frame then return end
    local size = 32

    local gps = CreateFrame("Frame", nil, frame.InfoPanel)
    gps:SetFrameLevel(99)
    gps:Size(size, size)
    gps.DefaultSize = size
    gps:Point("RIGHT", frame, "RIGHT", 0, 0)

    gps.Arrow = gps:CreateTexture(nil, "OVERLAY", nil, 7)
    gps.Arrow:SetTexture([[Interface\AddOns\SVUI_TrackOMatic\artwork\GPS-ARROW]])
    gps.Arrow:Size(size, size)
    gps.Arrow:SetPoint("CENTER", gps, "CENTER", 0, 0)
    gps.Arrow:SetVertexColor(0.1, 0.8, 0.8)
    gps.Arrow:SetBlendMode("ADD")

    gps.onMouseOver = true
    gps.OnlyProximity = false

    gps.Spin = Rotate_Arrow

    frame.GPS = gps

    --frame.GPS:Hide()
end
--[[ 
########################################################## 
CORE
##########################################################
]]--
function PLUGIN:ReLoad()
    if(not SV.db[Schema].enable) then return end

    local frameSize = SV.db[Schema].size or 70
    local arrowSize = frameSize * 0.5
    local fontSize = SV.db[Schema].fontSize or 14
    local frame = _G["SVUI_TrackingDoodad"]

    frame:SetSize(frameSize, frameSize)
    frame.Arrow:SetSize(arrowSize, arrowSize)
    frame.Range:SetFont(SV.Media.font.roboto, fontSize, "OUTLINE")
end

function PLUGIN:Load()
    if(not SV.db[Schema].enable) then return end
    
    local _TRACKER = SVUI_TrackingDoodad
    local _TARGET = SVUI_Target

    if(_TRACKER) then

        _TRACKER.Spin = Rotate_Arrow
        _TRACKER:SetParent(SVUI_Target)
        _TRACKER:SetScript("OnUpdate", Tracker_OnUpdate)

        self:RegisterEvent("PLAYER_TARGET_CHANGED")
    end

    if(_TARGET) then
        local frame = _G["SVUI_TrackingDoodad"]
        frame:SetPoint("LEFT", _TARGET, "RIGHT", 2, 0)
        _TARGET:HookScript("OnShow", TargetFrame_OnChange)
    end

    NewHook(SV.SVUnit, "RefreshUnitLayout", RefreshGPS)
end