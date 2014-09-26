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
if(select(4, GetBuildInfo()) >= 60000) then return end;
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local tonumber	= _G.tonumber;
local tinsert 	= _G.tinsert;
local table 	= _G.table;
local bit 		= _G.bit;

local twipe,band 	= table.wipe, bit.band;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SVUI_ADDON_NAME, SV = ...
local SVLib = LibStub("LibSuperVillain-1.0")
local L = SVLib:Lang()
-- MountCache.types
-- MountCache.names
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local ttSummary = "";
local MountListener = CreateFrame("Frame");
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function UpdateMountCheckboxes(button, index)
	local _, creatureName = GetCompanionInfo("MOUNT", index);

	local n = button.MountBar
	local bar = _G[n]

	if(bar) then
		bar["GROUND"].index = index
		bar["GROUND"].name = creatureName
		bar["FLYING"].index = index
		bar["FLYING"].name = creatureName
		bar["SWIMMING"].index = index
		bar["SWIMMING"].name = creatureName
	    bar["SPECIAL"].index = index
	    bar["SPECIAL"].name = creatureName

		if(MountCache.names["GROUND"] == creatureName) then
			if(MountCache.types["GROUND"] ~= index) then
				MountCache.types["GROUND"] = index
			end
			bar["GROUND"]:SetChecked(1)
		else
			bar["GROUND"]:SetChecked(0)
		end

		if(MountCache.names["FLYING"] == creatureName) then
			if(MountCache.types["FLYING"] ~= index) then
				MountCache.types["FLYING"] = index
			end
			bar["FLYING"]:SetChecked(1)
		else
			bar["FLYING"]:SetChecked(0)
		end

		if(MountCache.names["SWIMMING"] == creatureName) then
			if(MountCache.types["SWIMMING"] ~= index) then
				MountCache.types["SWIMMING"] = index
			end
			bar["SWIMMING"]:SetChecked(1)
		else
			bar["SWIMMING"]:SetChecked(0)
		end

		if(MountCache.names["SPECIAL"] == creatureName) then
			if(MountCache.types["SPECIAL"] ~= index) then
				MountCache.types["SPECIAL"] = index
			end
			bar["SPECIAL"]:SetChecked(1)
		else
			bar["SPECIAL"]:SetChecked(0)
		end
	end
end

local function UpdateMountCache()
	if(not MountJournal or not MountJournal.cachedMounts) then return end
	local num = GetNumCompanions("MOUNT")
	for index = 1, num, 1 do
		local _, info, id = GetCompanionInfo("MOUNT", index)
		if(MountCache.names["GROUND"] == info) then
			if(MountCache.types["GROUND"] ~= index) then
				MountCache.types["GROUND"] = index
			end
		end
		if(MountCache.names["FLYING"] == info) then
			if(MountCache.types["FLYING"] ~= index) then
				MountCache.types["FLYING"] = index
			end
		end
		if(MountCache.names["SWIMMING"] == info) then
			if(MountCache.types["SWIMMING"] ~= index) then
				MountCache.types["SWIMMING"] = index
			end
		end
		if(MountCache.names["SPECIAL"] == info) then
			if(MountCache.types["SPECIAL"] ~= index) then
				MountCache.types["SPECIAL"] = index
			end
		end
	end
end

local function Update_MountCheckButtons()
	if(not MountJournal or not MountJournal.cachedMounts) then return end
	local count = #MountJournal.cachedMounts
	if(type(count) ~= "number") then return end 
	local scrollFrame = MountJournal.ListScrollFrame;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
    local buttons = scrollFrame.buttons;
	for i=1, #buttons do
        local button = buttons[i];
        local displayIndex = i + offset;
        if ( displayIndex <= count ) then
			local index = MountJournal.cachedMounts[displayIndex];
			UpdateMountCheckboxes(button, index)
		end
	end
end

local ProxyUpdate_Mounts = function(self, event, ...)
	if(event == "COMPANION_LEARNED" or event == "COMPANION_UNLEARNED") then
		UpdateMountCache()
	end
	Update_MountCheckButtons()
end

local function UpdateCurrentMountSelection()
	ttSummary = ""
	local creatureName

	if(MountCache.types["FLYING"]) then
		creatureName = MountCache.names["FLYING"]
		if(creatureName) then
			ttSummary = ttSummary .. "\nFlying: " .. creatureName
		end
	end

	if(MountCache.types["SWIMMING"]) then
		creatureName = MountCache.names["SWIMMING"]
		if(creatureName) then
			ttSummary = ttSummary .. "\nSwimming: " .. creatureName
		end
	end

	if(MountCache.types["GROUND"]) then
		creatureName = MountCache.names["GROUND"]
		if(creatureName) then
			ttSummary = ttSummary .. "\nGround: " .. creatureName
		end
	end

	if(MountCache.types["SPECIAL"]) then
		creatureName = MountCache.names["SPECIAL"]
		if(creatureName) then
			ttSummary = ttSummary .. "\nSpecial: " .. creatureName
		end
	end
end

local CheckButton_OnClick = function(self)
	local index = self.index
	local name = self.name
	local key = self.key

	if(index) then
		if(self:GetChecked() == 1) then
			MountCache.types[key] = index
			MountCache.names[key] = name
		else
			MountCache.types[key] = false
			MountCache.names[key] = ""
		end
		Update_MountCheckButtons()
		UpdateCurrentMountSelection()
	end
	GameTooltip:Hide()
end

local CheckButton_OnEnter = function(self)
	local index = self.name
	local key = self.key
	local r,g,b = self:GetBackdropColor()
	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 20)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(key,r,g,b)
	GameTooltip:AddLine("",1,1,0)
	GameTooltip:AddLine("Check this box to enable/disable \nthis mount for \nthe 'Lets Ride' key-binding",1,1,1)
	if(key == "SPECIAL") then
		GameTooltip:AddLine("",1,1,0)
		GameTooltip:AddLine("Hold |cff00FF00[SHIFT]|r or |cff00FF00[CTRL]|r while \nclicking to force this mount \nover all others.",1,1,1)
	end
	GameTooltip:AddLine(ttSummary,1,1,1)
	
	GameTooltip:Show()
end

local CheckButton_OnLeave = function(self)
	GameTooltip:Hide()
end
--[[ 
########################################################## 
ADDING CHECKBOXES TO JOURNAL
##########################################################
]]--
local function SetMountCheckButtons()
	MountCache = SVLib:NewCache("Mounts")
	if not MountCache.types then 
		MountCache.types = {
			["GROUND"] = false, 
			["FLYING"] = false, 
			["SWIMMING"] = false, 
			["SPECIAL"] = false
		}
	end
	if not MountCache.names then 
		MountCache.names = {
			["GROUND"] = "", 
			["FLYING"] = "", 
			["SWIMMING"] = "", 
			["SPECIAL"] = ""	
		} 
	end

	UpdateMountCache()

	local scrollFrame = MountJournal.ListScrollFrame;
	local scrollBar = _G["MountJournalListScrollFrameScrollBar"]
    local buttons = scrollFrame.buttons;

	for i = 1, #buttons do
		local button = buttons[i]
		local barWidth = button:GetWidth()
		local width = (barWidth - 18) * 0.25
		local height = 7
		local barName = ("SVUI_MountSelectBar%d"):format(i)

		local buttonBar = CreateFrame("Frame", barName, button)
		buttonBar:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, 0)
		buttonBar:SetSize(barWidth, height + 8)

		--[[ CREATE CHECKBOXES ]]--
		buttonBar["GROUND"] = CreateFrame("CheckButton", ("%s_GROUND"):format(barName), buttonBar, "UICheckButtonTemplate")
		buttonBar["GROUND"]:SetSize(width,height)
		buttonBar["GROUND"]:SetPoint("BOTTOMLEFT", buttonBar, "BOTTOMLEFT", 6, 4)
		buttonBar["GROUND"]:RemoveTextures()
	    buttonBar["GROUND"]:SetCheckboxTemplate()
	    buttonBar["GROUND"]:SetPanelColor(0.2, 0.7, 0.1, 0.15)
	    buttonBar["GROUND"]:GetCheckedTexture():SetVertexColor(0.2, 0.7, 0.1, 1)
	    buttonBar["GROUND"].key = "GROUND"
		if(enabled) then
			buttonBar["GROUND"]:SetChecked(1)
		else
			buttonBar["GROUND"]:SetChecked(0)
		end
		buttonBar["GROUND"]:SetScript("OnClick", CheckButton_OnClick)
		buttonBar["GROUND"]:SetScript("OnEnter", CheckButton_OnEnter)
		buttonBar["GROUND"]:SetScript("OnLeave", CheckButton_OnLeave)

	    buttonBar["FLYING"] = CreateFrame("CheckButton", ("%s_FLYING"):format(barName), buttonBar, "UICheckButtonTemplate")
		buttonBar["FLYING"]:SetSize(width,height)
		buttonBar["FLYING"]:SetPoint("BOTTOMLEFT", buttonBar["GROUND"], "BOTTOMRIGHT", 2, 0)
		buttonBar["FLYING"]:RemoveTextures()
	    buttonBar["FLYING"]:SetCheckboxTemplate()
	    buttonBar["FLYING"]:SetPanelColor(1, 1, 0.2, 0.15)
	    buttonBar["FLYING"]:GetCheckedTexture():SetVertexColor(1, 1, 0.2, 1)
	    buttonBar["FLYING"].key = "FLYING"
		if(enabled) then
			buttonBar["FLYING"]:SetChecked(1)
		else
			buttonBar["FLYING"]:SetChecked(0)
		end
		buttonBar["FLYING"]:SetScript("OnClick", CheckButton_OnClick)
		buttonBar["FLYING"]:SetScript("OnEnter", CheckButton_OnEnter)
		buttonBar["FLYING"]:SetScript("OnLeave", CheckButton_OnLeave)

	    buttonBar["SWIMMING"] = CreateFrame("CheckButton", ("%s_SWIMMING"):format(barName), buttonBar, "UICheckButtonTemplate")
		buttonBar["SWIMMING"]:SetSize(width,height)
		buttonBar["SWIMMING"]:SetPoint("BOTTOMLEFT", buttonBar["FLYING"], "BOTTOMRIGHT", 2, 0)
		buttonBar["SWIMMING"]:RemoveTextures()
	    buttonBar["SWIMMING"]:SetCheckboxTemplate()
	    buttonBar["SWIMMING"]:SetPanelColor(0.2, 0.42, 0.76, 0.15)
	    buttonBar["SWIMMING"]:GetCheckedTexture():SetVertexColor(0.2, 0.42, 0.76, 1)
	    buttonBar["SWIMMING"].key = "SWIMMING"
		if(enabled) then
			buttonBar["SWIMMING"]:SetChecked(1)
		else
			buttonBar["SWIMMING"]:SetChecked(0)
		end
		buttonBar["SWIMMING"]:SetScript("OnClick", CheckButton_OnClick)
		buttonBar["SWIMMING"]:SetScript("OnEnter", CheckButton_OnEnter)
		buttonBar["SWIMMING"]:SetScript("OnLeave", CheckButton_OnLeave)

		buttonBar["SPECIAL"] = CreateFrame("CheckButton", ("%s_SPECIAL"):format(barName), buttonBar, "UICheckButtonTemplate")
		buttonBar["SPECIAL"]:SetSize(width,height)
		buttonBar["SPECIAL"]:SetPoint("BOTTOMLEFT", buttonBar["SWIMMING"], "BOTTOMRIGHT", 2, 0)
		buttonBar["SPECIAL"]:RemoveTextures()
	    buttonBar["SPECIAL"]:SetCheckboxTemplate()
	    buttonBar["SPECIAL"]:SetPanelColor(0.7, 0.1, 0.1, 0.15)
	    buttonBar["SPECIAL"]:GetCheckedTexture():SetVertexColor(0.7, 0.1, 0.1, 1)
	    buttonBar["SPECIAL"].key = "SPECIAL"	
		if(special) then
			buttonBar["SPECIAL"]:SetChecked(1)
		else
			buttonBar["SPECIAL"]:SetChecked(0)
		end
		buttonBar["SPECIAL"]:SetScript("OnClick", CheckButton_OnClick)
		buttonBar["SPECIAL"]:SetScript("OnEnter", CheckButton_OnEnter)
		buttonBar["SPECIAL"]:SetScript("OnLeave", CheckButton_OnLeave)

		button.MountBar = barName

		UpdateMountCheckboxes(button, i)
	end


	scrollFrame:HookScript("OnMouseWheel", Update_MountCheckButtons)
	scrollBar:HookScript("OnValueChanged", Update_MountCheckButtons)
	UpdateCurrentMountSelection()

	if(SV.GameVersion >= 60000) then
		MountListener:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
	end
	
	MountListener:RegisterEvent("COMPANION_LEARNED")
	MountListener:RegisterEvent("COMPANION_UNLEARNED")
	MountListener:RegisterEvent("COMPANION_UPDATE")
	MountListener:SetScript("OnEvent", ProxyUpdate_Mounts)
end
--[[ 
########################################################## 
SLASH FUNCTION
##########################################################
]]--
function SVUILetsRide()
	local checkList = MountCache.types
	local letsFly, letsSwim, letsSeahorse, vjZone, IbelieveIcantFly
	local maxMounts = GetNumCompanions("MOUNT")
	if(not maxMounts or IsMounted()) then
		Dismount()
		return
	end
	if(CanExitVehicle()) then
		VehicleExit()
		return
	end
	if(IsUsableSpell(59569) == nil) then
		IbelieveIcantFly = true
	end
	if(not IbelieveIcantFly and IsFlyableArea()) then
		letsFly = true
	end
	for i = 1, 40 do
		local auraID = select(11, UnitBuff("player", i))
		if(auraID == 73701 or auraID == 76377) then
			vjZone = true
		end
	end
	if(vjZone and IsSwimming()) then
		letsSeahorse = true
	end
	if(IsSwimming() and IbelieveIcantFly and not letsSeahorse) then
		letsSwim = true
	end
	if(IsModifierKeyDown()) then
		if(checkList["SPECIAL"]) then
			CallCompanion("MOUNT", checkList["SPECIAL"])
			return
		elseif(checkList["GROUND"]) then
			CallCompanion("MOUNT", checkList["GROUND"])
			return
		end
	end
	if(letsSeahorse) then
		for index = 1, maxMounts, 1 do
			local _, info, id = GetCompanionInfo("MOUNT", index)
			if(letsSeahorse and id == 75207) then CallCompanion("MOUNT", index) end
		end
	end
	if(letsFly and not letsSwim) then
		if(checkList["FLYING"]) then
			CallCompanion("MOUNT", checkList["FLYING"])
			return
		else
			if(checkList["GROUND"]) then
				SV:AddonMessage("No flying mount selected! Using your ground mount.")
				CallCompanion("MOUNT", checkList["GROUND"])
				return
			end
		end
	elseif(not letsFly and not letsSwim) then
		if(checkList["GROUND"]) then
			CallCompanion("MOUNT", checkList["GROUND"])
			return
		end
	elseif(letsSwim) then
		if(checkList["SWIMMING"]) then
			CallCompanion("MOUNT", checkList["SWIMMING"])
			return
		elseif(letsFly and checkList["FLYING"]) then
			SV:AddonMessage("No swimming mount selected! Using your flying mount.")
			CallCompanion("MOUNT", checkList["FLYING"])
			return
		end
	elseif(checkList["GROUND"]) then
		CallCompanion("MOUNT", checkList["GROUND"])
		return
	end
	if(not checkList["GROUND"] and not checkList["FLYING"] and not checkList["SWIMMING"]) then
		CallCompanion("MOUNT", random(1, maxMounts))
	end
	return
end
--[[ 
########################################################## 
LOADER
##########################################################
]]--
SVLib:NewScript(SetMountCheckButtons);