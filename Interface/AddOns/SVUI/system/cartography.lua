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
local tinsert   = _G.tinsert;
local math      = _G.math;
local bit       = _G.bit;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
local fmod, modf, sqrt = math.fmod, math.modf, math.sqrt;   -- Algebra
local atan2, cos, deg, rad, sin = math.atan2, math.cos, math.deg, math.rad, math.sin;  -- Trigonometry
local min, huge, random = math.min, math.huge, math.random;  -- Uncommon
--[[ BINARY METHODS ]]--
local band = bit.band;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...))
--[[ 
########################################################## 
MEASURING UTILITY FUNCTIONS (from Astrolabe  by: Esamynn)
##########################################################
]]--
local radian90 = (3.141592653589793  /  2)
local GetDistance, GetTarget

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
            SetMapZoom(C, 0);
            zones[0] = GetCurrentMapAreaID();
            _getmapdata(_cache);
            for Z in ipairs(zones) do
                SetMapZoom(C, Z);
                zones[Z] = GetCurrentMapAreaID();
                _getmapdata(_cache);
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
        if (mapFloor ~= 0) then
            map = rawget(map, mapFloor) or _dungeons[map.origin][mapFloor];
        end
        x = x * map.width + map.xOffset;
        y = y * map.height + map.yOffset;
        return x, y;
    end

    function GetDistance(map1, floor1, x1, y1, map2, floor2, x2, y2)
        if not (map1 and map2) then return end;
        floor1 = floor1 or min(#_mapdata[map1], 1);
        floor2 = floor2 or min(#_mapdata[map2], 1);
        local dist, xDelta, yDelta;
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
            xDelta = (x2 - x1) * w;
            yDelta = (y2 - y1) * h;
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
            dist = sqrt(xDelta*xDelta + yDelta*yDelta);
        end
        return dist, xDelta, yDelta;
    end
end

do
    local function _findunit(unit, noMapChange)
        local x, y = GetPlayerMapPosition(unit);
        if(x <= 0 and y <= 0) then
            if(noMapChange) then return; end
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
            if(WorldMap:IsShown()) then return; end
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

    function GetTarget(unit, checkMap)
        local plot1, plot2, plot3, plot4;
        if unit == "player" or UnitIsUnit("player", unit) then 
            plot1, plot2, plot3, plot4 = _findplayer()
        else 
            plot1, plot2, plot3, plot4 = _findunit(unit, checkMap or WorldMapFrame:IsVisible())
        end;
        if not (plot1 and plot4) then 
            return false 
        else 
            return true, plot1, plot2, plot3, plot4 
        end 
    end
end;

function SuperVillain:Triangulate(unit1, unit2, checkMap)
    local allowed, plot1, plot2, plot3, plot4 = GetTarget(unit1, checkMap)
    if not allowed then return end;
    local allowed, plot5, plot6, plot7, plot8 = GetTarget(unit2, checkMap)
    if not allowed then return end;
    local distance, deltaX, deltaY = GetDistance(plot1, plot2, plot3, plot4, plot5, plot6, plot7, plot8)
    if distance and deltaX and deltaY then 
        return distance, -radian90 - GetPlayerFacing() - atan2(deltaY, deltaX) 
    elseif distance then 
        return distance 
    end
end;