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

--[[  CONSTANTS ]]--

_G.BINDING_HEADER_SVUITRACK = "Supervillain UI: Track-O-Matic";
_G.BINDING_NAME_SVUITRACK_DOODAD = "Toggle Tracking Device";
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
LOCALS
##########################################################
]]--
local NewHook = hooksecurefunc;
local playerGUID = UnitGUID('player')
local classColor = RAID_CLASS_COLORS
--[[ 
########################################################## 
BUILD
##########################################################
]]--
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
        SVUI_TrackingDoodad:Hide()
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

local Tracker_OnUpdate = function(self, elapsed)
    if self.elapsed and self.elapsed > (self.throttle or 0.02) then
        if(self.Trackable) then
            local distance, angle = self.Track("target", true)
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
                elseif(range > 0) then
                    self.Arrow:SetVertexColor(0.1,1,0.8,0.9)
                    self.Radar:SetVertexColor(0.1,0.8,0.8,0.75)
                    self.BG:SetVertexColor(0.1,0.8,0.1,0.75)
                else
                    self.Arrow:SetVertexColor(0.1,0.1,0.1,0.1)
                    self.Radar:SetVertexColor(0.1,0.1,0.1,0.1)
                    self.BG:SetVertexColor(0.1,0.1,0.1,0.1)
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
CORE
##########################################################
]]--
function PLUGIN:ReLoad()
    local frameSize = self.db.size or 70
    local arrowSize = frameSize * 0.5
    local fontSize = self.db.fontSize or 14
    local frame = _G["SVUI_TrackingDoodad"]

    frame:SetSize(frameSize, frameSize)
    frame.Arrow:SetSize(arrowSize, arrowSize)
    frame.Range:SetFont(SV.Media.font.roboto, fontSize, "OUTLINE")
end

function PLUGIN:Load()
    local _TRACKER = SVUI_TrackingDoodad
    local _TARGET = SVUI_Target

    if(_TRACKER) then
        _TRACKER.Border:SetGradient(unpack(SV.Media.gradient.special))
        _TRACKER.Arrow:SetVertexColor(0.1, 0.8, 0.8)
        _TRACKER.Range:SetFont(SV.Media.font.roboto, 14, "OUTLINE")
        _TRACKER.Range:SetTextColor(1, 1, 1, 0.75)
        _TRACKER.Spin = Rotate_Arrow
        _TRACKER.Track = _G.Triangulate

        _TRACKER:RegisterForDrag("LeftButton");
        _TRACKER:SetScript("OnUpdate", Tracker_OnUpdate)

        SV.Animate:Orbit(_TRACKER.Radar, 8, true)

        _TRACKER:Hide()

        if(_TARGET) then
            _TRACKER:SetParent(_TARGET)
            _TRACKER:SetPoint("LEFT", _TARGET, "RIGHT", 2, 0)
        end

        self:RegisterEvent("PLAYER_TARGET_CHANGED")
    end
end