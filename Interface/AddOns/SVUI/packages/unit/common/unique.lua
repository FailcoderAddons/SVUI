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
local MOD = SuperVillain.Registry:Expose('SVUnit')
if(not MOD) then return end;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local format = string.format
local cos, sin, sqrt2, random, floor, ceil = math.cos, math.sin, math.sqrt(2), math.random, math.floor, math.ceil;
local GetPlayerMapPosition = GetPlayerMapPosition;
local STATE_ICON_FILE = [[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-PLAYER-STATE]]
--[[ 
########################################################## 
PLAYER ONLY COMPONENTS
##########################################################
]]--
function MOD:CreateRestingIndicator(frame)
	local resting = CreateFrame("Frame",nil,frame)
	resting:SetFrameStrata("MEDIUM")
	resting:SetFrameLevel(20)
	resting:Size(26,26)
	resting:Point("TOPRIGHT",frame,3,3)
	resting.bg = resting:CreateTexture(nil,"OVERLAY",nil,1)
	resting.bg:SetAllPoints(resting)
	resting.bg:SetTexture(STATE_ICON_FILE)
	resting.bg:SetTexCoord(0.5,1,0,0.5)
	return resting 
end;

function MOD:CreateCombatIndicator(frame)
	local combat = CreateFrame("Frame",nil,frame)
	combat:SetFrameStrata("MEDIUM")
	combat:SetFrameLevel(30)
	combat:Size(26,26)
	combat:Point("TOPRIGHT",frame,3,3)
	combat.bg = combat:CreateTexture(nil,"OVERLAY",nil,5)
	combat.bg:SetAllPoints(combat)
	combat.bg:SetTexture(STATE_ICON_FILE)
	combat.bg:SetTexCoord(0,0.5,0,0.5)
	SuperVillain.Animate:Pulse(combat)
	combat:SetScript("OnShow", function(this)
		if not this.anim:IsPlaying() then this.anim:Play() end 
	end)
	
	combat:Hide()
	return combat 
end;

local ExRep_OnEnter = function(self)if self:IsShown() then UIFrameFadeIn(self,.1,0,1) end end;
local ExRep_OnLeave = function(self)if self:IsShown() then UIFrameFadeOut(self,.2,1,0) end end;

function MOD:CreateExperienceRepBar(frame)
	local db = MOD.db.player;
	
	if db.playerExpBar then 
		local xp = CreateFrame("StatusBar", "PlayerFrameExperienceBar", frame.Power)
		xp:FillInner(frame.Power, 0, 0)
		xp:SetPanelTemplate()
		xp:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		xp:SetStatusBarColor(0, 0.1, 0.6)
		--xp:SetBackdropColor(1, 1, 1, 0.8)
		xp:SetFrameLevel(xp:GetFrameLevel() + 2)
		xp.Tooltip = true;
		xp.Rested = CreateFrame("StatusBar", nil, xp)
		xp.Rested:SetAllPoints(xp)
		xp.Rested:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		xp.Rested:SetStatusBarColor(1, 0, 1, 0.6)
		xp.Value = xp:CreateFontString(nil, "TOOLTIP")
		xp.Value:SetAllPoints(xp)
		xp.Value:SetFontTemplate(SuperVillain.Media.font.roboto, 10, "NONE")
		xp.Value:SetTextColor(0.2, 0.75, 1)
		xp.Value:SetShadowColor(0, 0, 0, 0)
		xp.Value:SetShadowOffset(0, 0)
		frame:Tag(xp.Value, "[curxp] / [maxxp]")
		xp.Rested:SetBackdrop({bgFile = [[Interface\BUTTONS\WHITE8X8]]})
		xp.Rested:SetBackdropColor(unpack(SuperVillain.Media.color.default))
		xp:SetScript("OnEnter", ExRep_OnEnter)
		xp:SetScript("OnLeave", ExRep_OnLeave)
		xp:SetAlpha(0)
		frame.Experience = xp 
	end;

	if db.playerRepBar then 
		local rep = CreateFrame("StatusBar", "PlayerFrameReputationBar", frame.Power)
		rep:FillInner(frame.Power, 0, 0)
		rep:SetPanelTemplate()
		rep:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		rep:SetStatusBarColor(0, 0.6, 0)
		--rep:SetBackdropColor(1, 1, 1, 0.8)
		rep:SetFrameLevel(rep:GetFrameLevel() + 2)
		rep.Tooltip = true;
		rep.Value = rep:CreateFontString(nil, "TOOLTIP")
		rep.Value:SetAllPoints(rep)
		rep.Value:SetFontTemplate(SuperVillain.Media.font.roboto, 10, "NONE")
		rep.Value:SetTextColor(0.1, 1, 0.2)
		rep.Value:SetShadowColor(0, 0, 0, 0)
		rep.Value:SetShadowOffset(0, 0)
		frame:Tag(rep.Value, "[standing]: [currep] / [maxrep]")
		rep:SetScript("OnEnter", ExRep_OnEnter)
		rep:SetScript("OnLeave", ExRep_OnLeave)
		rep:SetAlpha(0)
		frame.Reputation = rep 
	end 
end;
--[[ 
########################################################## 
TARGET ONLY COMPONENTS
##########################################################
]]--
local function GPS_OnEnter(self)
	self:SetAlpha(1)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
	if(not self.Trackable) then
  		self.Icon:SetVertexColor(1, 0.5, 0)
  		GameTooltip:ClearLines()
		GameTooltip:AddLine("Can not track this unit", 1, 1, 1)
  	else
  		self.Icon:SetVertexColor(0.1, 1, 0.5)
		GameTooltip:ClearLines()
		GameTooltip:AddLine("Start tracking your target", 1, 1, 1)
  	end
	GameTooltip:Show()
end;

local function GPS_OnLeave(self)
	self:SetAlpha(0.25)
  	self.Icon:SetVertexColor(0.1, 0.1, 0.1)
  	GameTooltip:Hide()
end;

local function GPS_OnMouseDown(self)
	if(not self.Trackable) then
  		self.Icon:SetVertexColor(1, 0, 0)
  	end
end;

local function GPS_OnMouseUp(self)
  	if(not self.Trackable) then
  		self.Icon:SetVertexColor(1, 0.5, 0)
  	else
  		self.Icon:SetVertexColor(0.1, 1, 0.5)
  		self:GetParent().Tracker:Show()
  	end
end;

function MOD:CreateGPS(frame)
	if not frame then return end;

	local gps = CreateFrame("Frame", nil, frame)
	gps:Size(50, 50)
	gps:Point("BOTTOMLEFT", frame, "BOTTOMRIGHT", 6, 0)
	gps:EnableMouse(false)

	local tracker = CreateFrame("Frame", nil, gps)
	tracker:SetAllPoints(gps)
	tracker:SetFrameLevel(gps:GetFrameLevel()  +  2)

	local border = tracker:CreateTexture(nil, "BORDER")
	border:SetAllPoints(tracker)
	border:SetTexture([[Interface\Addons\SVUI\assets\artwork\Doodads\GPS-BORDER]])
	border:SetGradient(unpack(SuperVillain.Media.gradient.dark))

	tracker.Arrow = tracker:CreateTexture(nil, "OVERLAY", nil, -2)
	tracker.Arrow:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\GPS-ARROW]])
	tracker.Arrow:Size(50, 50)
	tracker.Arrow:SetPoint("CENTER", tracker, "CENTER", 0, 0)
	tracker.Arrow:SetVertexColor(0.1, 0.8, 0.8)

	tracker.Text = tracker:CreateFontString(nil, "OVERLAY")
	tracker.Text:SetAllPoints(tracker)
	tracker.Text:SetFont(SuperVillain.Media.font.roboto, 14, "OUTLINE")
	tracker.Text:SetTextColor(1, 1, 1, 0.75)

	tracker.Spinner = tracker:CreateTexture(nil, "ARTWORK", nil, 2)
	tracker.Spinner:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\GPS-ANIMATION]])
	tracker.Spinner:Size(50, 50)
	tracker.Spinner:SetPoint("CENTER", tracker, "CENTER", 0, 0)

	SuperVillain.Animate:Orbit(tracker.Spinner, 8, true)

	local switch = CreateFrame("Frame", nil, gps)
	switch:SetAllPoints(gps)
	switch:EnableMouse(true)

	switch.Icon = switch:CreateTexture(nil, "BACKGROUND")
	switch.Icon:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\GPS-OPEN]])
	switch.Icon:Size(32, 32)
	switch.Icon:SetPoint("BOTTOMLEFT", switch, "BOTTOMLEFT", 0, 0)
	switch.Icon:SetVertexColor(0.1, 0.1, 0.1)

	switch.Trackable = false;

	switch:SetScript("OnEnter", GPS_OnEnter)
	switch:SetScript("OnLeave", GPS_OnLeave)
	switch:SetScript("OnMouseDown", GPS_OnMouseDown)
	switch:SetScript("OnMouseUp", GPS_OnMouseUp)

	switch:SetAlpha(0.25)

	gps.Tracker = tracker
	gps.Switch = switch
	
	gps.Tracker:Hide()
	gps:Hide()

	return gps 
end;

function MOD:CreateXRay(frame)
	local xray=CreateFrame("BUTTON","XRayFocus",frame,"SecureActionButtonTemplate")
	xray:EnableMouse(true)
	xray:RegisterForClicks("AnyUp")
	xray:SetAttribute("type","macro")
	xray:SetAttribute("macrotext","/focus")
	xray:Size(64,64)
	xray:SetFrameStrata("DIALOG")
	xray.icon=xray:CreateTexture(nil,"ARTWORK")
	xray.icon:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\UNIT-XRAY")
	xray.icon:SetAllPoints(xray)
	xray.icon:SetAlpha(0)
	xray:SetScript("OnLeave",function()GameTooltip:Hide()xray.icon:SetAlpha(0)end)
	xray:SetScript("OnEnter",function(self)
		xray.icon:SetAlpha(1)
		local r,s,b,m=GetScreenHeight(),GetScreenWidth(),self:GetCenter()
		local t,u,v="RIGHT","TOP","BOTTOM"
		if (b < (r / 2)) then t="LEFT" end;
		if (m < (s / 2)) then u,v=v,u end;
		GameTooltip:SetOwner(self,"ANCHOR_NONE")
		GameTooltip:SetPoint(u..t,self,v..t)
		GameTooltip:SetText(FOCUSTARGET.."\n")
	end)
	return xray 
end;

function MOD:CreateXRay_Closer(frame)
	local close=CreateFrame("BUTTON","ClearXRay",frame,"SecureActionButtonTemplate")
	close:EnableMouse(true)
	close:RegisterForClicks("AnyUp")
	close:SetAttribute("type","macro")
	close:SetAttribute("macrotext","/clearfocus")
	close:Size(64,64)
	close:SetFrameStrata("DIALOG")
	close.icon=close:CreateTexture(nil,"ARTWORK")
	close.icon:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\UNIT-XRAY-CLOSE")
	close.icon:SetAllPoints(close)
	close.icon:SetVertexColor(1,0.2,0.1)
	close:SetScript("OnLeave",function()GameTooltip:Hide()close.icon:SetVertexColor(1,0.2,0.1)end)
	close:SetScript("OnEnter",function(self)close.icon:SetVertexColor(1,1,0.2)local r,s,b,m=GetScreenHeight(),GetScreenWidth(),self:GetCenter()local t,u,v="RIGHT","TOP","BOTTOM"if b<r/2 then t="LEFT"end;if m<s/2 then u,v=v,u end;GameTooltip:SetOwner(self,"ANCHOR_NONE")GameTooltip:SetPoint(u..t,self,v..t)GameTooltip:SetText(CLEAR_FOCUS.."\n")end)
	return close 
end;