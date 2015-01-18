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
if(SV.class ~= "MONK") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end

local ORB_ICON = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\Class\ORB]];
local ORB_BG = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\Class\ORB-BG]];

local STAGGER_BAR = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\Class\MONK-STAGGER-BAR]];
local STAGGER_BG = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\Class\MONK-STAGGER-BG]];
local STAGGER_FG = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\Class\MONK-STAGGER-FG]];
local STAGGER_ICON = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\Class\MONK-STAGGER-ICON]];

local CHI_FILE = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\MONK]];
local CHI_COORDS = {
	[1] = {0,0.5,0,0.5},
	[2] = {0.5,1,0,0.5},
	[3] = {0,0.5,0.5,1},
	[4] = {0.5,1,0.5,1},
	[5] = {0.5,1,0,0.5},
	[6] = {0,0.5,0.5,1},
};
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local OnMove = function()
	SV.db.SVUnit.player.classbar.detachFromFrame = true
end

local Reposition = function(self)
	local db = SV.db.SVUnit.player
	local bar = self.KungFu;
	local max = self.MaxClassPower;
	local size = db.classbar.height
	local width = size * max;
	bar.Holder:SetSizeToScale(width, size)
    if(not db.classbar.detachFromFrame) then
    	SV.Mentalo:Reset(L["Classbar"])
    end
    local holderUpdate = bar.Holder:GetScript('OnSizeChanged')
    if holderUpdate then
        holderUpdate(bar.Holder)
    end

    bar:ClearAllPoints()
    bar:SetAllPoints(bar.Holder)
	local tmp = 0.67
	for i = 1, max do
		local chi = tmp - (i * 0.1)
		bar[i]:ClearAllPoints()
		bar[i]:SetHeight(size)
		bar[i]:SetWidth(size)
		bar[i]:SetStatusBarColor(chi, 0.87, 0.35)
		if i==1 then 
			bar[i]:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		else 
			bar[i]:SetPointToScale("LEFT", bar[i - 1], "RIGHT", -2, 0) 
		end
	end 
end 

local StartFlash = function(self) SV.Animate:Flash(self.overlay,1,true) end
local StopFlash = function(self) SV.Animate:StopFlash(self.overlay) end
--[[ 
########################################################## 
MONK HARMONY
##########################################################
]]--
function MOD:CreateClassBar(playerFrame)
	local max = 6
	local bar = CreateFrame("Frame", nil, playerFrame)
	bar:SetFrameLevel(playerFrame.TextGrip:GetFrameLevel() + 30)
	for i=1, max do
		local coords = CHI_COORDS[i]
		bar[i] = CreateFrame("StatusBar", nil, bar)
		bar[i]:SetStatusBarTexture(ORB_ICON)
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		bar[i].noupdate = true;

		bar[i].bg = bar[i]:CreateTexture(nil, "BACKGROUND")
		bar[i].bg:SetAllPoints(bar[i])
		bar[i].bg:SetTexture(ORB_BG)

		bar[i].glow = bar[i]:CreateTexture(nil, "OVERLAY")
		bar[i].glow:SetAllPoints(bar[i])
		bar[i].glow:SetTexture(CHI_FILE)
		bar[i].glow:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
		
		bar[i].overlay = bar[i]:CreateTexture(nil, "OVERLAY", nil, 7)
		bar[i].overlay:SetAllPoints(bar[i])
		bar[i].overlay:SetTexture(CHI_FILE)
		bar[i].overlay:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
		bar[i].overlay:SetVertexColor(0, 0, 0)

		bar[i]:SetScript("OnShow", StartFlash)
		bar[i]:SetScript("OnHide", StopFlash)

		SV.SpecialFX:SetFXFrame(bar[i], "chi")
		bar[i].FX:SetFrameLevel(bar[i]:GetFrameLevel())
	end

	local stagger = CreateFrame("Statusbar",nil,playerFrame)
	stagger:SetPointToScale('TOPLEFT', playerFrame, 'TOPRIGHT', 3, 0)
	stagger:SetPointToScale('BOTTOMLEFT', playerFrame, 'BOTTOMRIGHT', 3, 0)
	stagger:SetWidth(10)
	stagger:SetStylePanel("Frame", "Bar")
	stagger:SetOrientation("VERTICAL")
	stagger:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
	--stagger:GetStatusBarTexture():SetHorizTile(false)

	stagger.bg = stagger:CreateTexture(nil,'BORDER',nil,1)
	stagger.bg:SetAllPoints(stagger)
	stagger.bg:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
	stagger.bg:SetVertexColor(0,0,0,0.33)

	-- stagger.overlay = stagger:CreateTexture(nil,'OVERLAY')
	-- stagger.overlay:SetAllPoints(stagger)
	-- stagger.overlay:SetTexture(STAGGER_FG)
	-- stagger.overlay:SetVertexColor(1,1,1)

	-- stagger.icon = stagger:CreateTexture(nil,'OVERLAY')
	-- stagger.icon:SetAllPoints(stagger)
	-- stagger.icon:SetTexture(STAGGER_ICON)

	bar.DrunkenMaster = stagger

	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", bar)
	classBarHolder:SetPointToScale("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"], nil, OnMove)

	playerFrame.MaxClassPower = max
	playerFrame.ClassBarRefresh = Reposition

	playerFrame.KungFu = bar
	return 'KungFu'  
end 