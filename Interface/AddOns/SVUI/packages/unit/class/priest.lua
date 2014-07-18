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
local ICON_FILE = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\Class\PRIEST]]
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local db = MOD.db.player
	local bar = self.PriestOrbs;
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
		if i==1 then 
			bar[i]:SetPoint("LEFT", bar)
		else 
			bar[i]:Point("LEFT", bar[i - 1], "RIGHT", -1, 0) 
		end
	end 
end;
--[[ 
########################################################## 
PRIEST
##########################################################
]]--
local innerOrbs = {
	[1] = {1, 0.7, 0},
	[2] = {1, 1, 0.3},
	[3] = {0.7, 0.5, 1}	
};

local PreUpdate = function(self, spec)
	local color = innerOrbs[spec] or {0.7, 0.5, 1};
	for i = 1, 5 do
		self[i].swirl[1]:SetVertexColor(unpack(color))
	end 
end;

function MOD:CreatePriestResourceBar(playerFrame)
	local max = 5
	local bar = CreateFrame("Frame",nil,playerFrame)
	bar:SetFrameLevel(playerFrame.InfoPanel:GetFrameLevel() + 30)

	for i=1, max do 
		bar[i] = CreateFrame("StatusBar", nil, bar)
		bar[i]:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\ORB")
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		bar[i].noupdate = true;
		bar[i].backdrop = bar[i]:CreateTexture(nil, "BACKGROUND")
		bar[i].backdrop:SetAllPoints(bar[i])
		bar[i].backdrop:SetTexture(ICON_FILE)
		bar[i].backdrop:SetTexCoord(0,0.5,0,0.5)
		local swirl = CreateFrame('Frame', nil, bar[i])
		swirl:Size(30, 30)
		swirl:SetPoint("CENTER", bar[i], "CENTER", 0, 0)
		swirl[1] = swirl:CreateTexture(nil, "OVERLAY", nil, 2)
		swirl[1]:Size(30, 30)
		swirl[1]:SetPoint("CENTER")
		swirl[1]:SetTexture(ICON_FILE)
		swirl[1]:SetTexCoord(0.5,1,0.5,1)
		swirl[1]:SetBlendMode("ADD")
		swirl[1]:SetVertexColor(0.7, 0.5, 1)
		SuperVillain.Animate:Orbit(swirl[1], 10, false)
		swirl[2] = swirl:CreateTexture(nil, "OVERLAY", nil, 1)
		swirl[2]:Size(30, 30)
		swirl[2]:SetPoint("CENTER")
		swirl[2]:SetTexture(ICON_FILE)
		swirl[2]:SetTexCoord(0.5,1,0.5,1)
		swirl[2]:SetBlendMode("BLEND")
		swirl[2]:SetVertexColor(0, 0, 0)
		SuperVillain.Animate:Orbit(swirl[2], 10, true)
		bar[i].swirl = swirl;
		bar[i]:SetScript("OnShow", function(self)
			if not self.swirl[1].anim:IsPlaying() then
				self.swirl[1].anim:Play()
			end;
			if not self.swirl[2].anim:IsPlaying() then
				self.swirl[2].anim:Play()
			end 
		end)
		bar[i]:SetScript("OnHide", function(self)
			self.swirl[1].anim:Finish()
			self.swirl[2].anim:Finish() 
		end)

	end;
	bar.PreUpdate = PreUpdate
	playerFrame.MaxClassPower = max;
	playerFrame.ClassBarRefresh = Reposition;

	return bar 
end;