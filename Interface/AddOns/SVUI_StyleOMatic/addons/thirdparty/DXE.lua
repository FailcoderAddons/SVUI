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
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose('SVStyle');
--[[ 
########################################################## 
DXE
##########################################################
]]--
LoadAddOn("DXE")
local function StyleDXE()
	local function StyleDXEBar(bar)
		bar:SetFixedPanelTemplate("Transparent")
		bar.bg:SetTexture(nil)
		bar.border.Show = function() end
		bar.border:Hide()
		bar.statusbar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		bar.statusbar:ClearAllPoints()
		bar.statusbar:FillInner()
		bar.righticon:SetFixedPanelTemplate("Default")
		bar.righticon.border.Show = function() end
		bar.righticon.border:Hide()
		bar.righticon:ClearAllPoints()
		bar.righticon:SetPoint("LEFT", bar, "RIGHT", 2, 0)
		bar.righticon.t:SetTexCoord(0.1,0.9,0.1,0.9)
		bar.righticon.t:ClearAllPoints()
		bar.righticon.t:FillInner()
		bar.righticon.t:SetDrawLayer("ARTWORK")
		bar.lefticon:SetFixedPanelTemplate("Default")
		bar.lefticon.border.Show = function() end
		bar.lefticon.border:Hide()
		bar.lefticon:ClearAllPoints()
		bar.lefticon:SetPoint("RIGHT", bar, "LEFT", -2, 0)
		bar.lefticon.t:SetTexCoord(0.1,0.9,0.1,0.9)
		bar.lefticon.t:ClearAllPoints()
		bar.lefticon.t:FillInner()
		bar.lefticon.t:SetDrawLayer("ARTWORK")
	end
	DXE.LayoutHealthWatchers_ = DXE.LayoutHealthWatchers
	DXE.LayoutHealthWatchers = function(frame)
		DXE:LayoutHealthWatchers_()
		for i,hw in ipairs(frame.HW) do
			if hw:IsShown() then
				hw:SetFixedPanelTemplate("Transparent")
				hw.border.Show = function() end
				hw.border:Hide()
				hw.healthbar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
			end
		end
	end
	local function RefreshDXEBars(frame)
		if frame.refreshing then return end
		frame.refreshing = true
		local i = 1
		while _G["DXEAlertBar"..i] do
			local bar = _G["DXEAlertBar"..i]
			if not bar.styled then
				bar:SetScale(1)
				bar.SetScale = function() return end
				StyleDXEBar(bar)
				bar.styled = true
			end
			i = i + 1
		end
		frame.refreshing = false
	end
	local DXEAlerts = DXE.Registry:Expose("Alerts")
	local frame = CreateFrame("Frame")
	frame.elapsed = 1
	frame:SetScript("OnUpdate", function(frame,elapsed)
		frame.elapsed = frame.elapsed + elapsed
		if(frame.elapsed >= 1) then
			RefreshDXEBars(DXEAlerts)
			frame.elapsed = 0
		end
	end)
	hooksecurefunc(DXEAlerts, "Simple", RefreshDXEBars)
	hooksecurefunc(DXEAlerts, "RefreshBars", RefreshDXEBars)
	DXE:LayoutHealthWatchers()
	DXE.Alerts:RefreshBars()
	if not DXEDB then DXEDB = {} end
	if not DXEDB["profiles"] then DXEDB["profiles"] = {} end
	if not DXEDB["profiles"][SuperVillain.name.." - "..SuperVillain.realm] then DXEDB["profiles"][SuperVillain.name.." - "..SuperVillain.realm] = {} end
	if not DXEDB["profiles"][SuperVillain.name.." - "..SuperVillain.realm]["Globals"] then DXEDB["profiles"][SuperVillain.name.." - "..SuperVillain.realm]["Globals"] = {} end
	DXEDB["profiles"][SuperVillain.name.." - "..SuperVillain.realm]["Globals"]["BackgroundTexture"] = [[Interface\BUTTONS\WHITE8X8]]
	DXEDB["profiles"][SuperVillain.name.." - "..SuperVillain.realm]["Globals"]["BarTexture"] = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]]
	DXEDB["profiles"][SuperVillain.name.." - "..SuperVillain.realm]["Globals"]["Border"] = "None"
	DXEDB["profiles"][SuperVillain.name.." - "..SuperVillain.realm]["Globals"]["Font"] = SuperVillain.Media.font.default
	DXEDB["profiles"][SuperVillain.name.." - "..SuperVillain.realm]["Globals"]["TimerFont"] = SuperVillain.Media.font.default
end
MOD:SaveAddonStyle("DXE", StyleDXE)