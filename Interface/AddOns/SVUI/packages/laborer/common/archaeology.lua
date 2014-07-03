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
local type 		= _G.type;
local string    = _G.string;
local math 		= _G.math;
local table 	= _G.table;
local rept,format   = string.rep, string.format; 
local tsort,twipe 	= table.sort, table.wipe;
local floor,ceil  	= math.floor, math.ceil;
local min 			= math.min
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVLaborer');
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local archSpell, survey, surveyIsKnown, skillRank, skillModifier;
local EnableListener, DisableListener;
local CanScanResearchSite = CanScanResearchSite
local GetNumArtifactsByRace = GetNumArtifactsByRace
local GetArchaeologyRaceInfo = GetArchaeologyRaceInfo
local GetSelectedArtifactInfo = GetSelectedArtifactInfo
local GetArtifactProgress = GetArtifactProgress
local CanSolveArtifact = CanSolveArtifact
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemInfo = GetContainerItemInfo
local GetContainerItemID = GetContainerItemID
local DockButton, ModeAlert, ModeLogsFrame; 
local refArtifacts = {};
for i = 1, 12 do
	refArtifacts[i] = {}
end
local ArchLaborer = CreateFrame("Frame", "SVUI_ArchLaborer", UIParent)
--[[ 
########################################################## 
DATA
##########################################################
]]--
MOD.Archaeology = {};
MOD.Archaeology.Bars = {};
MOD.Archaeology.Loaded = false;
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function EnableSolve(index, button)
	button:SetAlpha(1)
	button.text:SetTextColor(1, 1, 1)
	button:SetScript("OnEnter", function(self)
		self.text:SetTextColor(1, 1, 0)
	end)
	button:SetScript("OnLeave", function(self)
		self.text:SetTextColor(1, 1, 1)
	end)
	button:SetScript("OnClick", function(self)
		SetSelectedArtifact(index)
		local _, _, _, _, _, numSockets = GetActiveArtifactByRace(index)
		local _, _, itemID = GetArchaeologyRaceInfo(index)
		local ready = true
		if numSockets and numSockets > 0 then
			for socketNum = 1, numSockets do
				if not ItemAddedToArtifact(itemID) then
					SocketItemToArtifact()
				end
			end
		end

		if GetNumArtifactsByRace(index) > 0 then
			print("Solving...")
			SolveArtifact()
		end
	end)
end

local function DisableSolve(button)
	button:SetAlpha(0)
	button.text:SetTextColor(0.5, 0.5, 0.5)
	button.text:SetText("")
	button:SetScript("OnEnter", function() end)
	button:SetScript("OnLeave", function() end)
	button:SetScript("OnMouseUp", function() end)
end

local function UpdateArtifactBars(index)
	local cache = refArtifacts[index]
	local bar = MOD.Archaeology.Bars[index]

	bar["race"]:SetText(cache["race"])

	if GetNumArtifactsByRace(index) ~= 0 then
		local keystoneBonus = 0
		bar["race"]:SetTextColor(1, 1, 1)
		bar["progress"]:SetTextColor(1, 1, 1)
		if cache["numKeysockets"] then
			keystoneBonus = min(cache["numKeystones"], cache["numKeysockets"]) * 12
		end
		local actual = min(cache["progress"], cache["total"])
		local potential = cache["total"]
		local green = 0.75 * (actual / potential);
		bar["bar"]:SetMinMaxValues(0, potential)
		bar["bar"]:SetValue(actual)

		if cache["numKeysockets"] and cache["numKeysockets"] > 0 then
			bar["solve"].text:SetText(SOLVE.." ["..cache["numKeystones"].."/"..cache["numKeysockets"].."]")
		else
			bar["solve"].text:SetText(SOLVE)
		end

		if keystoneBonus > 0 then
			bar["progress"]:SetText(format("|cff00c1ea%d|r/%d", cache["progress"] + keystoneBonus, cache["total"]))
		else
			if cache["total"] > 65 then
				bar["progress"]:SetText(format("%d/|cff00c1ea%d|r", cache["progress"], cache["total"]))
			else
				bar["progress"]:SetText(format("%d/%d", cache["progress"], cache["total"]))
			end
		end
		if cache["canSolve"] then
			EnableSolve(index, bar["solve"])
		else
			DisableSolve(bar["solve"])
		end
		bar["bar"]:SetStatusBarColor(0.1, green, 1, 0.5)
	else
		DisableSolve(bar["solve"])
		bar["progress"]:SetText("")
		bar["bar"]:SetStatusBarColor(0, 0, 0, 0)
		bar["race"]:SetTextColor(0.25, 0.25, 0.25)
		bar["progress"]:SetTextColor(0.25, 0.25, 0.25)
	end
end

local function UpdateArtifactCache()
	local found, raceName, raceItemID, cache, _;
	for index=1, 12 do
		found = GetNumArtifactsByRace(index)
		raceName, _, raceItemID = GetArchaeologyRaceInfo(index)
		cache = refArtifacts[index]
		cache["race"] = raceName
		cache["keyID"] = raceItemID
		cache["numKeystones"] = 0
		local oldNum = cache["progress"]
		if found == 0 then
			cache["numKeysockets"] = 0
			cache["progress"] = 0
			cache["modifier"] = 0
			cache["total"] = 0
			cache["canSolve"] = false
		else
			SetSelectedArtifact(index)
			local _, _, _, _, _, keystoneCount = GetSelectedArtifactInfo()
			local numFragmentsCollected, numFragmentsAdded, numFragmentsRequired = GetArtifactProgress()

			cache["numKeysockets"] = keystoneCount
			cache["progress"] = numFragmentsCollected
			cache["modifier"] = numFragmentsAdded
			cache["total"] = numFragmentsRequired
			cache["canSolve"] = CanSolveArtifact()

			for i = 0, 4 do
				for j = 1, GetContainerNumSlots(i) do
					local slotID = GetContainerItemID(i, j)
					if slotID == cache["keyID"] then
						local _, count = GetContainerItemInfo(i, j)
						if cache["numKeystones"] < cache["numKeysockets"] then
							cache["numKeystones"] = cache["numKeystones"] + count
						end
						if min(cache["numKeystones"], cache["numKeysockets"]) * 12 + cache["progress"] >= cache["total"] then
							cache["canSolve"] = true
						end
					end
				end
			end
		end
		UpdateArtifactBars(index)
	end
end

local function GetTitleAndSkill()
	local msg = "|cff22ff11Archaeology Mode|r"
	if(skillRank) then
		if(skillModifier) then
			skillRank = skillRank + skillModifier;
		end
		msg = msg .. " (|cff00ddff" .. skillRank .. "|r)";
	end;
	return msg
end

local function SendModeMessage(...)
	if not CombatText_AddMessage then return end;
	CombatText_AddMessage(...)
end;
--[[ 
########################################################## 
EVENT HANDLER
##########################################################
]]--
do
	local SURVEYCDFONT = SuperVillain.Media.font.numbers
	local SURVEYRED = {0,1,1}
	local SURVEYGRN = {1,0.5,0}
	local last = 0
	local time = 3

	local ArchEventHandler = CreateFrame("Frame");
	local SurveyCooldown = CreateFrame("Frame", nil, UIParent);
	local ArchSiteFound;
	local ArchCanSurvey, ArchWillSurvey = false, false;

	SurveyCooldown:SetPoint("CENTER", 0, -80)
	SurveyCooldown:SetSize(40, 40)
	SurveyCooldown.text = SurveyCooldown:CreateFontString(nil, "OVERLAY")
	SurveyCooldown.text:SetFont(SURVEYCDFONT, 99, "OUTLINE")
	SurveyCooldown.text:SetTextColor(0,1,0.12,0.5)
	SurveyCooldown.text:SetPoint("CENTER")

	local Arch_OnEvent = function(self, event, ...)
		if(InCombatLockdown() or not archSpell) then return end
		if(event == "ZONE_CHANGED" or event == "ARTIFACT_DIG_SITE_UPDATED" or event == "ARTIFACT_DIGSITE_COMPLETE") then
			ArchCanSurvey = CanScanResearchSite()
			if(ArchCanSurvey and not ArchWillSurvey) then
				_G["SVUI_ModeCaptureWindow"]:SetAttribute("type", "spell")
				_G["SVUI_ModeCaptureWindow"]:SetAttribute('spell', survey)
				ModeAlert.HelpText = "Double-Right-Click anywhere on the screen to survey.";
				ArchWillSurvey = true
			elseif(not ArchCanSurvey and ArchWillSurvey) then
				_G["SVUI_ModeCaptureWindow"]:SetAttribute("type", "spell")
				_G["SVUI_ModeCaptureWindow"]:SetAttribute('spell', archSpell)
				ModeAlert.HelpText = "Double-Right-Click anywhere on the screen to open the artifacts window.";
				ArchWillSurvey = false
			end
			if(not ArchSiteFound) then
				local sites = ArchaeologyMapUpdateAll();
				if(sites and sites > 0) then
					ArchSiteFound = true
					SendModeMessage("Digsite Located", CombatText_StandardScroll, 0.91, 0.78, 0.12);
				else
					ArchSiteFound = nil
				end
			end
		elseif(ArchCanSurvey and (event == "ARTIFACT_HISTORY_READY" or event == "CURRENCY_DISPLAY_UPDATE" or event == "ARTIFACT_COMPLETE")) then
			UpdateArtifactCache()
		end
	end;

	local Survey_OnUpdate = function(self, elapsed)
		last = last + elapsed
		if last > 1 then
			time = time - 1
			self.text:SetText(time)
			if time <= 0 then
				self:SetScript("OnUpdate", nil)
				self.text:SetText("")
				time = 3
			end
			self.text:SetTextColor(SURVEYRED[time],SURVEYGRN[time],0.12,0.5)
			last = 0
		end
	end;

	local Survey_OnEvent = function(self, event, unit, _, _, _, spellid)
		if not unit == "player" then return end
		if spellid == 80451 then
			self.text:SetText("3")
			self:SetScript("OnUpdate", Survey_OnUpdate)
		end
	end;

	function EnableListener()
		UpdateArtifactCache()
		
		ArchEventHandler:RegisterEvent("ZONE_CHANGED")
		ArchEventHandler:RegisterEvent("ARTIFACT_DIG_SITE_UPDATED")
		ArchEventHandler:RegisterEvent("ARTIFACT_DIGSITE_COMPLETE")
		ArchEventHandler:RegisterEvent("ARTIFACT_HISTORY_READY")
		ArchEventHandler:RegisterEvent("ARTIFACT_COMPLETE")
		ArchEventHandler:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
		--ArchEventHandler:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		--ArchEventHandler:RegisterEvent("ZONE_CHANGED_INDOORS")
		--ArchEventHandler:RegisterEvent("ARCHAEOLOGY_SURVEY_CAST")
		
		ArchEventHandler:SetScript("OnEvent", Arch_OnEvent)
		if(SuperVillain.race ~= "Dwarf") then
			SurveyCooldown:RegisterEvent("UNIT_SPELLCAST_STOP")
			SurveyCooldown:SetScript("OnEvent", Survey_OnEvent)
		end
	end

	function DisableListener()
		ArchEventHandler:UnregisterAllEvents()
		ArchEventHandler:SetScript("OnEvent", nil)
		if(SuperVillain.race ~= "Dwarf") then
			SurveyCooldown:UnregisterAllEvents()
			SurveyCooldown:SetScript("OnEvent", nil)
		end
	end
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD.Archaeology:Enable()
	MOD.Archaeology:Update()
	if(not SVUI_ModesDockFrame:IsShown()) then DockButton:Click() end

	PlaySoundFile("Sound\\Item\\UseSounds\\UseCrinklingPaper.wav")
	ModeAlert:SetBackdropColor(0.25, 0.52, 0.1)
	if(not IsSpellKnown(80451)) then
		MOD:ModeLootLoader("Archaeology", "WTF is Archaeology?", "You don't know archaeology! \nPicking up a rock and telling everyone that \nyou found a fossil is cute, BUT WRONG!! \nGo find someone who can train you to do this job.");
		MOD.TitleWindow:Clear();
		MOD.TitleWindow:AddMessage("WTF is Archaeology?");
		MOD.LogWindow:Clear();
		MOD.LogWindow:AddMessage("You don't know archaeology! \nPicking up a rock and telling everyone that \nyou found a fossil is cute, BUT WRONG!! \nGo find someone who can train you to do this job.", 1, 1, 1);
		MOD.LogWindow:AddMessage(" ", 1, 1, 1);
	else
		ArchLaborer:Show()
		local msg = GetTitleAndSkill()
		if surveyIsKnown and CanScanResearchSite() then
			MOD:ModeLootLoader("Archaeology", msg, "Double-Right-Click anywhere on the screen to survey.");
			_G["SVUI_ModeCaptureWindow"]:SetAttribute("type", "spell")
			_G["SVUI_ModeCaptureWindow"]:SetAttribute('spell', survey)
		else
			MOD:ModeLootLoader("Archaeology", msg, "Double-Right-Click anywhere on the screen to open the artifacts window.");
			_G["SVUI_ModeCaptureWindow"]:SetAttribute("type", "spell")
			_G["SVUI_ModeCaptureWindow"]:SetAttribute('spell', archSpell)
		end
		MOD.TitleWindow:Clear();
		MOD.TitleWindow:AddMessage(msg);
	end
	EnableListener()
	ModeAlert:Show()
	SendModeMessage("Archaeology Mode Enabled", CombatText_StandardScroll, 0.28, 0.9, 0.1);
end

function MOD.Archaeology:Disable()
	DisableListener()
	ArchLaborer:Hide()
end

function MOD.Archaeology:Bind()
	if InCombatLockdown() then return end
	if(archSpell) then
		if surveyIsKnown and CanScanResearchSite() then
			_G["SVUI_ModeCaptureWindow"]:SetAttribute("type", "spell")
			_G["SVUI_ModeCaptureWindow"]:SetAttribute('spell', survey)
			ModeAlert.HelpText = 'Double-Right-Click anywhere on the screen to survey.'
		else
			_G["SVUI_ModeCaptureWindow"]:SetAttribute("type", "spell")
			_G["SVUI_ModeCaptureWindow"]:SetAttribute('spell', archSpell)
			ModeAlert.HelpText = 'Double-Right-Click anywhere on the screen to open the artifacts window.'
		end
		SetOverrideBindingClick(_G["SVUI_ModeCaptureWindow"], true, "BUTTON2", "SVUI_ModeCaptureWindow");
		_G["SVUI_ModeCaptureWindow"].Grip:Show();
	end
end

function MOD.Archaeology:Update()
	surveyIsKnown = IsSpellKnown(80451);
	survey = GetSpellInfo(80451);
	local _,_,arch,_,_,_ = GetProfessions();
	if(arch) then
		archSpell, _, skillRank, _, _, _, _, skillModifier = GetProfessionInfo(arch)
	end
end
--[[ 
########################################################## 
LOADER
##########################################################
]]--
function MOD:LoadArchaeologyMode()
	ModeLogsFrame = MOD.LogWindow;
	DockButton = _G["SVUI_ModesDockFrame_ToolBarButton"];
	ModeAlert = _G["SVUI_ModeAlert"];

	local progressBars = MOD.Archaeology.Bars

	ArchLaborer:SetParent(ModeLogsFrame)
	ArchLaborer:SetFrameStrata("MEDIUM")
	ArchLaborer:FillInner(ModeLogsFrame)

	local BAR_WIDTH = (ArchLaborer:GetWidth() * 0.5) - 4
	local BAR_HEIGHT = (ArchLaborer:GetHeight() / 6) - 4

	for i = 1, 12 do
		local bar = CreateFrame("StatusBar", nil, ArchLaborer)
		local race = bar:CreateFontString()
		local progress = bar:CreateFontString()
		local solve = CreateFrame("Button", nil, bar, "SecureHandlerClickTemplate")
		local yOffset;

		bar:SetPanelTemplate("Inset")
		bar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		bar:SetSize(BAR_WIDTH,BAR_HEIGHT)
		if(i > 6) then
			yOffset = ((i - 7) * (BAR_HEIGHT + 4)) + 4
			bar:SetPoint("TOPRIGHT", ArchLaborer, "TOPRIGHT", -2, -yOffset)
		else
			yOffset = ((i - 1) * (BAR_HEIGHT + 4)) + 4;
			bar:SetPoint("TOPLEFT", ArchLaborer, "TOPLEFT", 2, -yOffset)
		end
		bar:SetStatusBarColor(0.2, 0.2, 0.8, 0.5)
		bar:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 2, 250)
			GameTooltip:ClearLines()
			if GetNumArtifactsByRace(i) > 0 then
				SetSelectedArtifact(i)
				local artifactName, artifactDescription, artifactRarity, _, _, keystoneCount = GetSelectedArtifactInfo()
				local numFragmentsCollected, numFragmentsAdded, numFragmentsRequired = GetArtifactProgress()
				local r, g, b
				if artifactRarity == 1 then
					artifactRarity = ITEM_QUALITY3_DESC
					r, g, b = GetItemQualityColor(3)
				else
					artifactRarity = ITEM_QUALITY1_DESC
					r, g, b = GetItemQualityColor(1)
				end
				GameTooltip:AddLine(artifactName, r, g, b, 1)
				GameTooltip:AddLine(artifactRarity, r, g, b, r, g, b)
				GameTooltip:AddDoubleLine(ARCHAEOLOGY_RUNE_STONES..": "..numFragmentsCollected.."/"..numFragmentsRequired, "Keystones: "..keystoneCount, 1, 1, 1, 1, 1, 1)
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(artifactDescription, 1, 1, 1, 1)
				GameTooltip:Show()
			end
		end)
		bar:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		-- Race Text
		race:SetFont(SuperVillain.Media.font.roboto, 12, "OUTLINE")
		race:SetText(RACE)
		race:SetPoint("LEFT", bar, "LEFT", 2, 0)

		-- Progress Text
		progress:SetFont(SuperVillain.Media.font.roboto, 12, "OUTLINE")
		progress:SetText("")
		progress:SetPoint("RIGHT", bar, "RIGHT", 1, 0)

		-- Solve
		solve:SetAllPoints(bar)

		solve.bg = solve:CreateTexture(nil,"BORDER")
		solve.bg:SetAllPoints(solve)
		solve.bg:SetTexture(SuperVillain.Media.bar.default)
		solve.bg:SetVertexColor(0.1,0.5,0)

		solve.text = solve:CreateFontString(nil,"OVERLAY")
		solve.text:SetFont(SuperVillain.Media.font.roboto, 14, "NONE")
		solve.text:SetShadowOffset(-1,-1)
		solve.text:SetShadowColor(0,0,0,0.5)
		solve.text:SetText(SOLVE)
		solve.text:SetPoint("CENTER", solve, "CENTER", 2, 0)

		progressBars[i] = {
			["bar"] = bar,
			["race"] = race,
			["progress"] = progress,
			["solve"] = solve
		}
	end
	ArchLaborer:Hide()
	MOD.Archaeology:Update()
	UpdateArtifactCache()
end