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
if(SV.class ~= "DEATHKNIGHT") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end 
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local runeTextures = {
	[[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\DEATHKNIGHT-BLOOD]],
	[[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\DEATHKNIGHT-BLOOD]],
	[[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\DEATHKNIGHT-FROST]],
	[[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\DEATHKNIGHT-FROST]],
	[[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\DEATHKNIGHT-UNHOLY]],
	[[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\DEATHKNIGHT-UNHOLY]]
};
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local db = SV.db.SVUnit.player
	local bar = self.Runes;
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
	for i = 1, max do
		bar[i]:ClearAllPoints()
		bar[i]:SetHeight(size)
		bar[i]:SetWidth(size)
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		if i==1 then 
			bar[i]:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		elseif i == 2 then
			bar[i]:SetPointToScale("LEFT", bar[1], "RIGHT", -6, 0) 
		else 
			bar[i]:SetPointToScale("LEFT", bar[i - 1], "RIGHT", -2, 0) 
		end
	end
	if bar.UpdateAllRuneTypes then 
		bar.UpdateAllRuneTypes(self)
	end
end
--[[ 
########################################################## 
DEATHKNIGHT
##########################################################
]]--
function MOD:CreateClassBar(playerFrame)
	local max = 6
	local bar = CreateFrame("Frame", nil, playerFrame)
	bar:SetFrameLevel(playerFrame.InfoPanel:GetFrameLevel() + 30)
	for i=1, max do 
		local graphic = runeTextures[i]
		bar[i] = CreateFrame("StatusBar", nil, bar)
		bar[i].noupdate = true;
		bar[i]:SetStatusBarTexture(graphic)
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		bar[i]:SetOrientation("VERTICAL")
		bar[i].bg = bar[i]:CreateTexture(nil,'BORDER')
		bar[i].bg:SetAllPoints()
		bar[i].bg:SetTexture(graphic)
		bar[i].bg:SetAlpha(0.5)
		bar[i].bg.multiplier = 0.1 
	end 
	
	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", bar)
	classBarHolder:SetPointToScale("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"])

	playerFrame.MaxClassPower = max;
	playerFrame.ClassBarRefresh = Reposition;
	playerFrame.Runes = bar
	return 'Runes' 
end 