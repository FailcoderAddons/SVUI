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
--]]
local SuperVillain, L = unpack(select(2, ...));
local twipe=table.wipe;
local CurrentThreats = {};
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local function UMadBro(scaledPercent)
	local highestThreat,unitWithHighestThreat = 0,nil;
	for unit,threat in pairs(CurrentThreats)do 
		if threat > highestThreat then 
			highestThreat = threat;
			unitWithHighestThreat = unit 
		end 
	end;
	return (scaledPercent - highestThreat),unitWithHighestThreat 
end;

local function GetThreatBarColor(unitWithHighestThreat)
	local react = UnitReaction(unitWithHighestThreat,'player')
	local _,unitClass = UnitClass(unitWithHighestThreat)
	if UnitIsPlayer(unitWithHighestThreat)then 
		local colors = RAID_CLASS_COLORS[unitClass]
		if not colors then return 15,15,15 end;
		return colors.r*255, colors.g*255, colors.b*255 
	elseif react then 
		local reaction=oUF_SuperVillain['colors'].reaction[react]
		return reaction[1]*255, reaction[2]*255, reaction[3]*255 
	else 
		return 15,15,15 
	end 
end;

local function ThreatBar_OnEvent(self, event)
	local grouped,inRaid,hasPet=IsInGroup(),IsInRaid(),UnitExists('pet')
	local isTanking, status, scaledPercent = UnitDetailedThreatSituation('player','target')
	if scaledPercent and scaledPercent > 0 then 
		self:Show()
		if scaledPercent==100 then 
			if hasPet then 
				CurrentThreats['pet']=select(3,UnitDetailedThreatSituation('pet','target'))
			end;
			if inRaid then 
				for i=1,40 do 
					if UnitExists('raid'..i) and not UnitIsUnit('raid'..i,'player') then 
						CurrentThreats['raid'..i]=select(3,UnitDetailedThreatSituation('raid'..i,'target'))
					end 
				end 
			else 
				for i=1,4 do 
					if UnitExists('party'..i) then 
						CurrentThreats['party'..i]=select(3,UnitDetailedThreatSituation('party'..i,'target'))
					end 
				end 
			end;
			local highestThreat,unitWithHighestThreat = UMadBro(scaledPercent)
			if highestThreat > 0 and unitWithHighestThreat ~= nil then 
				local r,g,b = GetThreatBarColor(unitWithHighestThreat)
				if SuperVillain.ClassRole == 'T' then 
					self:SetStatusBarColor(0,0.839,0)
					self:SetValue(highestThreat)
				else 
					self:SetStatusBarColor(GetThreatStatusColor(status))
					self:SetValue(scaledPercent)
				end 
			else 
				self:SetStatusBarColor(GetThreatStatusColor(status))
				self:SetValue(scaledPercent)
			end 
		else 
			self:SetStatusBarColor(0.3,1,0.3)
			self:SetValue(scaledPercent)
		end;
		self.text:SetFormattedText('%.0f%%',scaledPercent)
	else 
		self:Hide()
	end;
	twipe(CurrentThreats);
end;
--[[ 
########################################################## 
LOADER
##########################################################
]]--
local BARFILE = [[Interface\AddOns\SVUI\assets\artwork\Doodads\THREAT-BAR-ELEMENTS]]
local function LoadThreatBar()
	if(SuperVillain.db.system.threatbar == true) then
		local ThreatBar = CreateFrame('StatusBar', 'SVUI_ThreatBar', SuperVillain.UIParent);
		ThreatBar:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Doodads\\THREAT-BAR")
		ThreatBar:SetSize(50,100)
		ThreatBar:SetFrameStrata('MEDIUM')
		ThreatBar:SetOrientation("VERTICAL")
		ThreatBar:SetMinMaxValues(0,100)
		ThreatBar:Point('LEFT',SVUI_Target,'RIGHT',0,10)
		ThreatBar.backdrop = ThreatBar:CreateTexture(nil,"BACKGROUND")
		ThreatBar.backdrop:SetAllPoints(ThreatBar)
		ThreatBar.backdrop:SetTexture(BARFILE)
		ThreatBar.backdrop:SetTexCoord(0.5,0.75,0,0.5)
		ThreatBar.backdrop:SetBlendMode("ADD")
		ThreatBar.overlay = ThreatBar:CreateTexture(nil,"OVERLAY",nil,1)
		ThreatBar.overlay:SetAllPoints(ThreatBar)
		ThreatBar.overlay:SetTexture(BARFILE)
		ThreatBar.overlay:SetTexCoord(0.75,1,0,0.5)
		ThreatBar.text = ThreatBar:CreateFontString(nil,'OVERLAY')
		ThreatBar.text:SetFont(SuperVillain.Media.font.numbers, 10, "OUTLINE")
		ThreatBar.text:SetPoint('TOP',ThreatBar,'BOTTOM',0,0)
		ThreatBar:RegisterEvent('PLAYER_TARGET_CHANGED');
		ThreatBar:RegisterEvent('UNIT_THREAT_LIST_UPDATE')
		ThreatBar:RegisterEvent('GROUP_ROSTER_UPDATE')
		ThreatBar:RegisterEvent('UNIT_PET')
		ThreatBar:SetScript("OnEvent", ThreatBar_OnEvent)
		SuperVillain:SetSVMovable(ThreatBar,"SVUI_ThreatBar_MOVE","Threat Bar");
	end
end

SuperVillain.Registry:NewScript(LoadThreatBar);