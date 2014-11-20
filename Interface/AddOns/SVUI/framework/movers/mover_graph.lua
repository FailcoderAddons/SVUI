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
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local format, split = string.format, string.split;
--[[ MATH METHODS ]]--
local min, floor = math.min, math.floor;
local parsefloat = math.parsefloat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L;

local Graph = {}

function Graph:Toggle(enabled)
	if((not self.Grid) or (self.CellSize ~= SV.db.general.graphSize)) then
		self:Generate()
	end
	if(not enabled) then
        self.Grid:Hide()
	else
		self.Grid:Show()
	end
end

function Graph:Generate()
	local cellSize = SV.db.general.graphSize
	self.CellSize = cellSize

	self.Grid = CreateFrame('Frame', nil, UIParent)
	self.Grid:SetAllPoints(SV.Screen) 

	local size = 1 
	local width = GetScreenWidth()
	local ratio = width / GetScreenHeight()
	local height = GetScreenHeight() * ratio

	local wStep = width / cellSize
	local hStep = height / cellSize

	for i = 0, cellSize do 
		local tx = self.Grid:CreateTexture(nil, 'BACKGROUND') 
		if(i == cellSize / 2) then 
			tx:SetTexture(0, 1, 0, 0.8) 
		else 
			tx:SetTexture(0, 0, 0, 0.8) 
		end 
		tx:SetPoint("TOPLEFT", self.Grid, "TOPLEFT", i*wStep - (size/2), 0) 
		tx:SetPoint('BOTTOMRIGHT', self.Grid, 'BOTTOMLEFT', i*wStep + (size/2), 0) 
	end

	height = GetScreenHeight()
	
	do
		local tx = self.Grid:CreateTexture(nil, 'BACKGROUND') 
		tx:SetTexture(0, 1, 0, 0.8)
		tx:SetPoint("TOPLEFT", self.Grid, "TOPLEFT", 0, -(height/2) + (size/2))
		tx:SetPoint('BOTTOMRIGHT', self.Grid, 'TOPRIGHT', 0, -(height/2 + size/2))
	end
	
	for i = 1, floor((height/2)/hStep) do
		local tx = self.Grid:CreateTexture(nil, 'BACKGROUND') 
		tx:SetTexture(0, 0, 0, 0.8)
		
		tx:SetPoint("TOPLEFT", self.Grid, "TOPLEFT", 0, -(height/2+i*hStep) + (size/2))
		tx:SetPoint('BOTTOMRIGHT', self.Grid, 'TOPRIGHT', 0, -(height/2+i*hStep + size/2))
		
		tx = self.Grid:CreateTexture(nil, 'BACKGROUND') 
		tx:SetTexture(0, 0, 0, 0.8)
		
		tx:SetPoint("TOPLEFT", self.Grid, "TOPLEFT", 0, -(height/2-i*hStep) + (size/2))
		tx:SetPoint('BOTTOMRIGHT', self.Grid, 'TOPRIGHT', 0, -(height/2-i*hStep + size/2))
	end

	self.Grid:Hide()
end

function Graph:Initialize()
	self:Generate()
end

SV.Graph = Graph;