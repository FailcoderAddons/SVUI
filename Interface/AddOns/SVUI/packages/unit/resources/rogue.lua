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
local assert 	= _G.assert;
local math 		= _G.math;
--[[ MATH METHODS ]]--
local random = math.random;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local oUF_Villain = SV.oUF

assert(oUF_Villain, "SVUI was unable to locate oUF.")

local L = SV.L;
if(SV.class ~= "ROGUE") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end 
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local TRACKER_FONT = [[Interface\AddOns\SVUI\assets\fonts\Combo.ttf]]
local ICON_FILE = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\ROGUE]];
local ICON_COORDS = {
	{0,0.5,0,0.5},
	{0.5,1,0,0.5},
	{0,0.5,0.5,1},
	{0.5,1,0.5,1},
};
local cpointColor = {
	{0.69,0.31,0.31},
	{0.69,0.31,0.31},
	{0.65,0.63,0.35},
	{0.65,0.63,0.35},
	{0.33,0.59,0.33}
};
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local db = SV.db.SVUnit.target
	local bar = self.HyperCombo.CPoints;
	local max = MAX_COMBO_POINTS;
	local height = db.combobar.height
	local isSmall = db.combobar.smallIcons
	local size = isSmall and 22 or (height - 4)
	local width = (size + 4) * max;
	bar:ClearAllPoints()
	bar:Size(width, height)
	bar:Point("TOPLEFT", self.ActionPanel, "TOPLEFT", 2, (height * 0.25))
	for i = 1, max do
		bar[i]:ClearAllPoints()
		bar[i]:Size(size, size)
		bar[i].Icon:ClearAllPoints()
		bar[i].Icon:SetAllPoints(bar[i])
		if(bar[i].Blood) then
			bar[i].Blood:ClearAllPoints()
			bar[i].Blood:SetAllPoints(bar[i])
		end
		if i==1 then 
			bar[i]:SetPoint("LEFT", bar)
		else 
			bar[i]:Point("LEFT", bar[i - 1], "RIGHT", -2, 0) 
		end
	end 
end 
--[[ 
########################################################## 
ROGUE COMBO POINTS
##########################################################
]]--
local ShowPoint = function(self)
	self:SetAlpha(1)
end 

local HidePoint = function(self)
	local coords = ICON_COORDS[random(2,4)];
	self.Icon:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
	self:SetAlpha(0)
end 

local ShowSmallPoint = function(self)
	self:SetAlpha(1)
end 

local HideSmallPoint = function(self, i)
	self.Icon:SetVertexColor(unpack(cpointColor[i]))
	self:SetAlpha(0)
end 

function MOD:CreateRogueCombobar(targetFrame, isSmall)
	local max = 5
	local size = isSmall and 22 or 30
	local bar = CreateFrame("Frame",nil,targetFrame)
	local coords
	bar:SetFrameStrata("DIALOG")
	bar.CPoints = CreateFrame("Frame",nil,bar)
	for i = 1, max do 
		local cpoint = CreateFrame('Frame',nil,bar.CPoints)
		cpoint:Size(size,size)

		local icon = cpoint:CreateTexture(nil,"OVERLAY",nil,1)
		icon:Size(size,size)
		icon:SetPoint("CENTER")
		icon:SetBlendMode("BLEND")
		icon:SetTexture(ICON_FILE)

		if(not isSmall) then
			coords = ICON_COORDS[random(2,4)]
			icon:SetTexCoord(coords[1],coords[2],coords[3],coords[4])

			local blood = cpoint:CreateTexture(nil,"OVERLAY",nil,2)
			blood:Size(size,size)
			blood:SetPoint("BOTTOMRIGHT",cpoint,12,-12)
			blood:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Unitframe\Class\COMBO-ANIMATION]])
			blood:SetBlendMode("ADD")
			cpoint.Blood = blood
			
			SV.Animate:SmallSprite(blood,0.08,2,true)
		else
			coords = ICON_COORDS[1]
			icon:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
		end
		cpoint.Icon = icon

		bar.CPoints[i] = cpoint 
	end 

	targetFrame.ComboRefresh = Reposition;
	bar.PointShow = isSmall and ShowSmallPoint or ShowPoint;
	bar.PointHide = isSmall and HideSmallPoint or HidePoint;

	return bar 
end 
--[[ 
########################################################## 
ROGUE COMBO TRACKER
##########################################################
]]--
local RepositionTracker = function(self)
	local db = SV.db.SVUnit.player
	local bar = self.HyperCombo;
	if not db then return end
	local size = db.classbar.height
	local width = size * 3;
	local textwidth = size * 1.25;
	bar.Holder:Size(width, size)
    if(not db.classbar.detachFromFrame) then
    	SV.Mentalo:Reset(L["Classbar"])
    end
    local holderUpdate = bar.Holder:GetScript('OnSizeChanged')
    if holderUpdate then
        holderUpdate(bar.Holder)
    end

    bar:ClearAllPoints()
    bar:SetAllPoints(bar.Holder)
	if(bar.Tracking) then
		bar.Tracking:ClearAllPoints()
		bar.Tracking:SetHeight(size)
		bar.Tracking:SetWidth(textwidth)
		bar.Tracking:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		bar.Tracking.Text:ClearAllPoints()
		bar.Tracking.Text:SetAllPoints(bar.Tracking)
		bar.Tracking.Text:SetFont(TRACKER_FONT, size, 'OUTLINE')
	end
	if(bar.Anticipation) then
		bar.Anticipation:ClearAllPoints()
		bar.Anticipation:SetHeight(size)
		bar.Anticipation:SetWidth(textwidth)
		bar.Anticipation:SetPoint("LEFT", bar.Tracking, "RIGHT", -2, 0)
		bar.Anticipation.Text:ClearAllPoints()
		bar.Anticipation.Text:SetAllPoints(bar.Anticipation)
		bar.Anticipation.Text:SetFont(TRACKER_FONT, size, 'OUTLINE')
	end
	if(bar.Guile) then
		bar.Guile:ClearAllPoints()
		bar.Guile:SetHeight(size)
		bar.Guile:SetWidth(textwidth)
		bar.Guile:SetPoint("LEFT", bar.Anticipation, "RIGHT", -2, 0)
		bar.Guile.Text:ClearAllPoints()
		bar.Guile.Text:SetAllPoints(bar.Guile)
		bar.Guile.Text:SetFont(TRACKER_FONT, size, 'OUTLINE')
	end
end 

function MOD:CreateClassBar(playerFrame)
	local bar = CreateFrame("Frame",nil,playerFrame)
	bar:SetFrameStrata("DIALOG")
	bar:Size(150, 30)
	local points = CreateFrame('Frame',nil,bar)
	points:SetFrameStrata("DIALOG")
	points:Size(30,30)

	points.Text = points:CreateFontString(nil,'OVERLAY')
	points.Text:SetAllPoints(points)
	points.Text:SetFont(TRACKER_FONT,30,'OUTLINE')
	points.Text:SetTextColor(1,1,1)

	bar.Tracking = points;

	local anticipation = CreateFrame('Frame',nil,bar)
	anticipation:SetFrameStrata("DIALOG")
	anticipation:Size(30,30)

	anticipation.Text = anticipation:CreateFontString(nil,'OVERLAY')
	anticipation.Text:SetAllPoints(anticipation)
	anticipation.Text:SetFont(TRACKER_FONT,30,'OUTLINE')
	anticipation.Text:SetTextColor(1,1,1)

	bar.Anticipation = anticipation;

	local guile = CreateFrame('Frame',nil,bar)
	guile:SetFrameStrata("DIALOG")
	guile:Size(30,30)

	guile.Text = guile:CreateFontString(nil,'OVERLAY')
	guile.Text:SetAllPoints(guile)
	guile.Text:SetFont(TRACKER_FONT,30,'OUTLINE')
	guile.Text:SetTextColor(1,1,1)

	bar.Guile = guile;

	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", bar)
	classBarHolder:Point("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"], nil, nil, nil, "ALL, SOLO")

	playerFrame.MaxClassPower = 5;
	playerFrame.ClassBarRefresh = RepositionTracker;
	playerFrame.HyperCombo = bar
	return 'HyperCombo' 
end 