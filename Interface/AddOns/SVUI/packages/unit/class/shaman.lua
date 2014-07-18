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
local math 		= _G.math;
--[[ MATH METHODS ]]--
local random = math.random;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVUnit')
if(not MOD) then return end;
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local totemTextures = {
	[1] = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\SHAMAN-EARTH]],
	[2] = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\SHAMAN-FIRE]],
	[3] = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\SHAMAN-WATER]],
	[4] = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\SHAMAN-AIR]],
};
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local db = MOD.db.player
	local bar = self.TotemBars;
	local max = self.MaxClassPower;
	local height = db.classbar.height
	local size = (height - 4)
	local width = (size + 2) * max;
	bar:ClearAllPoints()
	bar:Size(width, height)
	if(db and db.classbar.slideLeft and (not db.power.tags or db.power.tags == '')) then
		bar:Point("TOPLEFT", self.InfoPanel, "TOPLEFT", 0, -2)
	else
		bar:Point("TOP", self.InfoPanel, "TOP", 0, -2)
	end
	for i = 1, max do
		bar[i]:ClearAllPoints()
		bar[i]:SetHeight(size)
		bar[i]:SetWidth(size)
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		if i==1 then 
			bar[i]:SetPoint("LEFT", bar)
		else 
			bar[i]:Point("LEFT", bar[i - 1], "RIGHT", -1, 0) 
		end
	end 
end;
--[[ 
########################################################## 
SHAMAN
##########################################################
]]--
function MOD:CreateShamanResourceBar(playerFrame)
	local max = 4
	local bar = CreateFrame("Frame",nil,playerFrame)
	bar:SetFrameLevel(playerFrame.InfoPanel:GetFrameLevel() + 30)
	for i=1, max do 
		bar[i] = CreateFrame("StatusBar",nil,bar)
		bar[i]:SetStatusBarTexture(totemTextures[i])
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		bar[i]:SetOrientation("VERTICAL")
		bar[i].noupdate=true;
		bar[i].backdrop = bar[i]:CreateTexture(nil,"BACKGROUND")
		bar[i].backdrop:SetAllPoints(bar[i])
		bar[i].backdrop:SetTexture(totemTextures[i])
		bar[i].backdrop:SetDesaturated(true)
		bar[i].backdrop:SetVertexColor(0.2,0.2,0.2,0.7)
	end;

	playerFrame.MaxClassPower = max;
	playerFrame.ClassBarRefresh = Reposition;

	return bar 
end;