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
local MOD = SuperVillain.Registry:Expose('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
--[[ 
########################################################## 
DRUID ALT MANA
##########################################################
]]--
local UpdateAltPower = function(self, unit, arg1, arg2)
	local value = self:GetParent().Power.value;
	if(arg1 ~= arg2) then 
		local color = oUF_SuperVillain['colors'].power['MANA']
		color = SuperVillain:HexColor(color[1],color[2],color[3])
		if value:GetText()then 
			if select(4,value:GetPoint()) < 0 then
				self.Text:SetFormattedText(color.."%d%%|r |cffD7BEA5- |r",floor(arg1/arg2*100))
			else
				self.Text:SetFormattedText("|cffD7BEA5-|r"..color.." %d%%|r",floor(arg1/arg2*100))
			end 
		else
			self.Text:SetFormattedText(color.."%d%%|r",floor(arg1/arg2*100))
		end 
	else 
		self.Text:SetText()
	end 
end;

local function CreateAltMana(playerFrame,eclipse)
	local bar = CreateFrame('Frame', nil, playerFrame)
	bar:SetFrameStrata("LOW")
	bar:SetPoint("TOPLEFT", eclipse, "TOPLEFT", 38, 0)
	bar:SetPoint("BOTTOMRIGHT", eclipse, "BOTTOMRIGHT", 0, 0)
	bar:SetFixedPanelTemplate("Default")
	bar:SetFrameLevel(bar:GetFrameLevel()+1)
	bar.colorPower = true;
	bar.PostUpdatePower = UpdateAltPower;
	bar.ManaBar = CreateFrame('StatusBar', nil, bar)
	bar.ManaBar.noupdate = true;
	bar.ManaBar:SetStatusBarTexture(SuperVillain.Media.bar.glow)
	bar.ManaBar:FillInner(bar)
	bar.bg = bar:CreateTexture(nil, "BORDER")
	bar.bg:SetAllPoints(bar.ManaBar)
	bar.bg:SetTexture([[Interface\BUTTONS\WHITE8X8]])
	bar.bg.multiplier = 0.3;
	bar.Text = bar.ManaBar:CreateFontString(nil, 'OVERLAY')
	bar.Text:SetAllPoints(bar.ManaBar)
	MOD:SetUnitFont(bar.Text)
	return bar 
end;
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local bar = self.EclipseBar;
	if not bar or not self.db then print("Error") return end
	local height = self.db.classbar.height
	local offset = (height - 10)
	local adjustedBar = (height * 1.5)
	local adjustedAnim = (height * 1.25)
	local scaled = (height * 0.8)
	local width = self.db.width * 0.4;
	bar:ClearAllPoints()
	bar:Size(width, height)

	if(self.db and self.db.classbar.slideLeft and (not self.db.power.tags or self.db.power.tags == '')) then
		bar:Point("TOPLEFT", self.InfoPanel, "TOPLEFT", offset, -2)
	else
		bar:Point("TOP", self.InfoPanel, "TOP", 0, -2)
	end
	
	bar.LunarBar:Size(width, adjustedBar)
	bar.LunarBar:SetMinMaxValues(0,0)
	bar.LunarBar:SetStatusBarColor(.13,.32,1)

	bar.Moon:Size(height, height)
	bar.Moon[1]:Size(adjustedAnim, adjustedAnim)
	bar.Moon[2]:Size(scaled, scaled)

	bar.SolarBar:Size(width, adjustedBar)
	bar.SolarBar:SetMinMaxValues(0,0)
	bar.SolarBar:SetStatusBarColor(1,1,0.21)

	bar.Sun:Size(height, height)
	bar.Sun[1]:Size(adjustedAnim, adjustedAnim)
	bar.Sun[2]:Size(scaled, scaled)

	bar.Text:SetPoint("TOPLEFT", bar, "TOPLEFT", 10, 0)
	bar.Text:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -10, 0)
end;
--[[ 
########################################################## 
DRUID ECLIPSE BAR
##########################################################
]]--
local directionHandler = {
	["sun"] = function(b)
		b.Text:SetJustifyH("LEFT")
		b.Text:SetText(" >")
		b.Text:SetTextColor(0.2, 1, 1, 0.5)
		b.Sun[1]:Hide()
		b.Sun[1].anim:Finish()
		b.Moon[1]:Show()
		b.Moon[1].anim:Play()
	end,
	["moon"] = function(b)
		b.Text:SetJustifyH("RIGHT")
		b.Text:SetText("< ")
		b.Text:SetTextColor(1, 0.5, 0, 0.5)
		b.Moon[1]:Hide()
		b.Moon[1].anim:Finish()
		b.Sun[1]:Show()
		b.Sun[1].anim:Play()
	end,
	["none"] = function(b)
		b.Text:SetJustifyH("CENTER")
		b.Text:SetText()
		b.Sun[1]:Hide()
		b.Sun[1].anim:Finish()
		b.Moon[1]:Hide()
		b.Moon[1].anim:Finish()
	end
};

local TrackerCallback = function(energy, direction, virtual_energy, virtual_direction, virtual_eclipse)
	local playerFrame = _G['SVUI_Player'];
	if(not playerFrame) then return; end
	if playerFrame.EclipseBar and playerFrame.EclipseBar:IsVisible() then 
		energy, direction, virtual_energy, virtual_direction, virtual_eclipse = LibBalancePowerTracker:GetEclipseEnergyInfo()
		directionHandler[virtual_direction](playerFrame.EclipseBar)
	end 
end;

function MOD:CreateDruidResourceBar(playerFrame)
	local bar = CreateFrame('Frame', nil, playerFrame)
	bar:SetFrameLevel(playerFrame.InfoPanel:GetFrameLevel() + 30)
	--bar:SetPanelTemplate("Transparent", false, 2, 2, 2)
	bar:Size(100,40)

	local lunar = CreateFrame('StatusBar', nil, bar)
	lunar:SetPoint('LEFT', bar)
	lunar:Size(100,40)
	lunar:SetStatusBarTexture(SuperVillain.Media.bar.lazer)
	lunar.noupdate = true;

	local moon = CreateFrame('Frame', nil, bar)
	moon:SetFrameLevel(bar:GetFrameLevel() + 2)
	moon:Size(40, 40)
	moon:SetPoint("RIGHT", lunar, "LEFT", 10, 0)

	moon[1] = moon:CreateTexture(nil, "BACKGROUND", nil, 1)
	moon[1]:Size(40, 40)
	moon[1]:SetPoint("CENTER")
	moon[1]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\VORTEX")
	moon[1]:SetBlendMode("ADD")
	moon[1]:SetVertexColor(0, 0.5, 1)
	SuperVillain.Animate:Orbit(moon[1], 10, false)

	moon[2] = moon:CreateTexture(nil, "OVERLAY", nil, 2)
	moon[2]:Size(30, 30)
	moon[2]:SetPoint("CENTER")
	moon[2]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\DRUID-MOON")
	moon[1]:Hide()
	bar.Moon = moon;

	bar.LunarBar = lunar;

	local solar = CreateFrame('StatusBar', nil, bar)
	solar:SetPoint('LEFT', lunar:GetStatusBarTexture(), 'RIGHT')
	solar:Size(100,40)
	solar:SetStatusBarTexture(SuperVillain.Media.bar.lazer)
	solar.noupdate = true;

	local sun = CreateFrame('Frame', nil, bar)
	sun:SetFrameLevel(bar:GetFrameLevel() + 2)
	sun:Size(40, 40)
	sun:SetPoint("LEFT", lunar, "RIGHT", -10, 0)
	sun[1] = sun:CreateTexture(nil, "BACKGROUND", nil, 1)
	sun[1]:Size(40, 40)
	sun[1]:SetPoint("CENTER")
	sun[1]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\VORTEX")
	sun[1]:SetBlendMode("ADD")
	sun[1]:SetVertexColor(1, 0.5, 0)
	SuperVillain.Animate:Orbit(sun[1], 10, false)

	sun[2] = sun:CreateTexture(nil, "OVERLAY", nil, 2)
	sun[2]:Size(30, 30)
	sun[2]:SetPoint("CENTER")
	sun[2]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\DRUID-SUN")
	sun[1]:Hide()
	bar.Sun = sun;

	bar.SolarBar = solar;

	bar.Text = lunar:CreateFontString(nil, 'OVERLAY', nil, 2)
	bar.Text:SetPoint("TOPLEFT", bar, "TOPLEFT", 10, 0)
	bar.Text:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -10, 0)
	bar.Text:SetFontTemplate(SuperVillain.Media.font.roboto, 16, "NONE")
	bar.Text:SetShadowOffset(0,0)

	local hyper = CreateFrame("Frame",nil,playerFrame)
	hyper:SetFrameStrata("DIALOG")
	hyper:Size(45,30)
	hyper:Point("TOPLEFT", playerFrame.InfoPanel, "TOPLEFT", 0, -2)

	local points = CreateFrame('Frame',nil,hyper)
	points:SetFrameStrata("DIALOG")
	points:SetAllPoints(hyper)

	points.Text = points:CreateFontString(nil,'OVERLAY')
	points.Text:SetAllPoints(points)
	points.Text:SetFontTemplate([[Interface\AddOns\SVUI\assets\fonts\Combo.ttf]],26,'OUTLINE')
	points.Text:SetTextColor(1,1,1)

	playerFrame.HyperCombo = hyper;
	playerFrame.HyperCombo.Tracking = points;

	playerFrame.MaxClassPower = 1;
	playerFrame.DruidAltMana = CreateAltMana(playerFrame, bar)

	bar.callbackid = LibBalancePowerTracker:RegisterCallback(TrackerCallback)
	
	playerFrame.ClassBarRefresh = Reposition;

	return bar 
end;
--[[ 
########################################################## 
DRUID COMBO POINTS
##########################################################
]]--
local cpointColor = {
	[1]={0.69,0.31,0.31},
	[2]={0.69,0.31,0.31},
	[3]={0.65,0.63,0.35},
	[4]={0.65,0.63,0.35},
	[5]={0.33,0.59,0.33}
};

local comboTextures = {
	[1]=[[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\DRUID-CLAW-UP]],
	[2]=[[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\DRUID-CLAW-DOWN]],
	[3]=[[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\DRUID-BITE]],
};

local ShowPoint = function(self)
	self:SetAlpha(1)
end;

local HidePoint = function(self)
	self.Icon:SetTexture(comboTextures[random(1,3)])
	self:SetAlpha(0)
end;

local ShowSmallPoint = function(self)
	self:SetAlpha(1)
end;

local HideSmallPoint = function(self)
	self.Icon:SetVertexColor(unpack(cpointColor[i]))
	self:SetAlpha(0)
end;

local RepositionCombo = function(self)
	local bar = self.HyperCombo.CPoints;
	local max = MAX_COMBO_POINTS;
	local height = self.db.combobar.height
	local isSmall = self.db.combobar.smallIcons
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
end;

function MOD:CreateDruidCombobar(targetFrame, isSmall)
	local max = 5
	local size = isSmall and 22 or 30
	local bar = CreateFrame("Frame",nil,targetFrame)
	bar:SetFrameStrata("DIALOG")
	bar.CPoints = CreateFrame("Frame",nil,bar)
	for i = 1, max do 
		local cpoint = CreateFrame('Frame',nil,bar.CPoints)
		cpoint:Size(size,size)

		local icon = cpoint:CreateTexture(nil,"OVERLAY",nil,1)
		icon:Size(size,size)
		icon:SetPoint("CENTER")
		icon:SetBlendMode("BLEND")

		if(not isSmall) then
			icon:SetTexture(comboTextures[random(1,3)])

			local blood = cpoint:CreateTexture(nil,"OVERLAY",nil,2)
			blood:Size(size,size)
			blood:SetPoint("BOTTOMRIGHT",cpoint,12,-12)
			blood:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Unitframe\Class\COMBO-ANIMATION]])
			blood:SetBlendMode("ADD")
			cpoint.Blood = blood
			
			SuperVillain.Animate:SmallSprite(blood,0.08,2,true)
		else
			icon:SetTexture([[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\COMBO-POINT-SMALL]])
		end
		cpoint.Icon = icon

		bar.CPoints[i] = cpoint 
	end;

	targetFrame.ComboRefresh = RepositionCombo;
	bar.PointShow = isSmall and ShowSmallPoint or ShowPoint;
	bar.PointHide = isSmall and HideSmallPoint or HidePoint;

	return bar 
end;