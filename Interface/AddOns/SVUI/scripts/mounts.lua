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
local SuperVillain, L = unpack(select(2, ...));
-- SVUI_Cache.Mounts.types
-- SVUI_Cache.Mounts.names
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

	button["GROUND"].index = index
	button["GROUND"].name = creatureName
	button["FLYING"].index = index
	button["FLYING"].name = creatureName
	button["SWIMMING"].index = index
	button["SWIMMING"].name = creatureName
    button["SPECIAL"].index = index
    button["SPECIAL"].name = creatureName

	if(SVUI_Cache.Mounts.names["GROUND"] == creatureName) then
		if(SVUI_Cache.Mounts.types["GROUND"] ~= index) then
			SVUI_Cache.Mounts.types["GROUND"] = index
		end
		button["GROUND"]:SetChecked(1)
	else
		button["GROUND"]:SetChecked(0)
	end

	if(SVUI_Cache.Mounts.names["FLYING"] == creatureName) then
		if(SVUI_Cache.Mounts.types["FLYING"] ~= index) then
			SVUI_Cache.Mounts.types["FLYING"] = index
		end
		button["FLYING"]:SetChecked(1)
	else
		button["FLYING"]:SetChecked(0)
	end

	if(SVUI_Cache.Mounts.names["SWIMMING"] == creatureName) then
		if(SVUI_Cache.Mounts.types["SWIMMING"] ~= index) then
			SVUI_Cache.Mounts.types["SWIMMING"] = index
		end
		button["SWIMMING"]:SetChecked(1)
	else
		button["SWIMMING"]:SetChecked(0)
	end

	if(SVUI_Cache.Mounts.names["SPECIAL"] == creatureName) then
		if(SVUI_Cache.Mounts.types["SPECIAL"] ~= index) then
			SVUI_Cache.Mounts.types["SPECIAL"] = index
		end
		button["SPECIAL"]:SetChecked(1)
	else
		button["SPECIAL"]:SetChecked(0)
	end
end

local function UpdateMountCache()
	if(not MountJournal or not MountJournal.cachedMounts) then return end
	local num = GetNumCompanions("MOUNT")
	for index = 1, num, 1 do
		local _, info, id = GetCompanionInfo("MOUNT", index)
		if(SVUI_Cache.Mounts.names["GROUND"] == info) then
			if(SVUI_Cache.Mounts.types["GROUND"] ~= index) then
				SVUI_Cache.Mounts.types["GROUND"] = index
			end
		end
		if(SVUI_Cache.Mounts.names["FLYING"] == info) then
			if(SVUI_Cache.Mounts.types["FLYING"] ~= index) then
				SVUI_Cache.Mounts.types["FLYING"] = index
			end
		end
		if(SVUI_Cache.Mounts.names["SWIMMING"] == info) then
			if(SVUI_Cache.Mounts.types["SWIMMING"] ~= index) then
				SVUI_Cache.Mounts.types["SWIMMING"] = index
			end
		end
		if(SVUI_Cache.Mounts.names["SPECIAL"] == info) then
			if(SVUI_Cache.Mounts.types["SPECIAL"] ~= index) then
				SVUI_Cache.Mounts.types["SPECIAL"] = index
			end
		end
	end
end

local function Update_MountCheckButtons()
	if(not MountJournal or not MountJournal.cachedMounts) then return end
	local count = #MountJournal.cachedMounts
	if(type(count) ~= "number") then return end;
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

	if(SVUI_Cache.Mounts.types["FLYING"]) then
		creatureName = SVUI_Cache.Mounts.names["FLYING"]
		if(creatureName) then
			ttSummary = ttSummary .. "\nFlying: " .. creatureName
		end
	end

	if(SVUI_Cache.Mounts.types["SWIMMING"]) then
		creatureName = SVUI_Cache.Mounts.names["SWIMMING"]
		if(creatureName) then
			ttSummary = ttSummary .. "\nSwimming: " .. creatureName
		end
	end

	if(SVUI_Cache.Mounts.types["GROUND"]) then
		creatureName = SVUI_Cache.Mounts.names["GROUND"]
		if(creatureName) then
			ttSummary = ttSummary .. "\nGround: " .. creatureName
		end
	end

	if(SVUI_Cache.Mounts.types["SPECIAL"]) then
		creatureName = SVUI_Cache.Mounts.names["SPECIAL"]
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
			SVUI_Cache.Mounts.types[key] = index
			SVUI_Cache.Mounts.names[key] = name
		else
			SVUI_Cache.Mounts.types[key] = false
			SVUI_Cache.Mounts.names[key] = ""
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
	GameTooltip:SetOwner(self,'ANCHOR_TOPLEFT',0,4)
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
	if not SVUI_Cache["Mounts"] then 
		SVUI_Cache["Mounts"] = {
			["types"] = {
				["GROUND"] = false, 
				["FLYING"] = false, 
				["SWIMMING"] = false, 
				["SPECIAL"] = false
			},
			["names"] = {
				["GROUND"] = "", 
				["FLYING"] = "", 
				["SWIMMING"] = "", 
				["SPECIAL"] = ""
			}	
		} 
	end;
	UpdateMountCache()
	local scrollFrame = MountJournal.ListScrollFrame;
	local scrollBar = _G["MountJournalListScrollFrameScrollBar"]
    local buttons = scrollFrame.buttons;
	for i = 1, #buttons do
		local button = buttons[i];
		local width = (button:GetWidth() - 18) * 0.25
		local height = 7
		--[[ CREATE CHECKBOXES ]]--
		button["GROUND"] = CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate")
		button["GROUND"]:SetSize(width,height)
		button["GROUND"]:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 6, 4)
		button["GROUND"]:Formula409()
	    button["GROUND"]:SetCheckboxTemplate()
	    button["GROUND"]:SetPanelColor(0.2, 0.7, 0.1, 0.15)
	    button["GROUND"]:GetCheckedTexture():SetVertexColor(0.2, 0.7, 0.1, 1)
	    button["GROUND"].key = "GROUND"
		if(enabled) then
			button["GROUND"]:SetChecked(1)
		else
			button["GROUND"]:SetChecked(0)
		end
		button["GROUND"]:SetScript("OnClick", CheckButton_OnClick)
		button["GROUND"]:SetScript("OnEnter", CheckButton_OnEnter)
		button["GROUND"]:SetScript("OnLeave", CheckButton_OnLeave)

	    button["FLYING"] = CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate")
		button["FLYING"]:SetSize(width,height)
		button["FLYING"]:SetPoint("BOTTOMLEFT", button["GROUND"], "BOTTOMRIGHT", 2, 0)
		button["FLYING"]:Formula409()
	    button["FLYING"]:SetCheckboxTemplate()
	    button["FLYING"]:SetPanelColor(1, 1, 0.2, 0.15)
	    button["FLYING"]:GetCheckedTexture():SetVertexColor(1, 1, 0.2, 1)
	    button["FLYING"].key = "FLYING"
		if(enabled) then
			button["FLYING"]:SetChecked(1)
		else
			button["FLYING"]:SetChecked(0)
		end
		button["FLYING"]:SetScript("OnClick", CheckButton_OnClick)
		button["FLYING"]:SetScript("OnEnter", CheckButton_OnEnter)
		button["FLYING"]:SetScript("OnLeave", CheckButton_OnLeave)

	    button["SWIMMING"] = CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate")
		button["SWIMMING"]:SetSize(width,height)
		button["SWIMMING"]:SetPoint("BOTTOMLEFT", button["FLYING"], "BOTTOMRIGHT", 2, 0)
		button["SWIMMING"]:Formula409()
	    button["SWIMMING"]:SetCheckboxTemplate()
	    button["SWIMMING"]:SetPanelColor(0.2, 0.42, 0.76, 0.15)
	    button["SWIMMING"]:GetCheckedTexture():SetVertexColor(0.2, 0.42, 0.76, 1)
	    button["SWIMMING"].key = "SWIMMING"
		if(enabled) then
			button["SWIMMING"]:SetChecked(1)
		else
			button["SWIMMING"]:SetChecked(0)
		end
		button["SWIMMING"]:SetScript("OnClick", CheckButton_OnClick)
		button["SWIMMING"]:SetScript("OnEnter", CheckButton_OnEnter)
		button["SWIMMING"]:SetScript("OnLeave", CheckButton_OnLeave)

		button["SPECIAL"] = CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate")
		button["SPECIAL"]:SetSize(width,height)
		button["SPECIAL"]:SetPoint("BOTTOMLEFT", button["SWIMMING"], "BOTTOMRIGHT", 2, 0)
		button["SPECIAL"]:Formula409()
	    button["SPECIAL"]:SetCheckboxTemplate()
	    button["SPECIAL"]:SetPanelColor(0.7, 0.1, 0.1, 0.15)
	    button["SPECIAL"]:GetCheckedTexture():SetVertexColor(0.7, 0.1, 0.1, 1)
	    button["SPECIAL"].key = "SPECIAL"	
		if(special) then
			button["SPECIAL"]:SetChecked(1)
		else
			button["SPECIAL"]:SetChecked(0)
		end
		button["SPECIAL"]:SetScript("OnClick", CheckButton_OnClick)
		button["SPECIAL"]:SetScript("OnEnter", CheckButton_OnEnter)
		button["SPECIAL"]:SetScript("OnLeave", CheckButton_OnLeave)

		UpdateMountCheckboxes(button, i)
	end


	scrollFrame:HookScript("OnMouseWheel", Update_MountCheckButtons)
	scrollBar:HookScript("OnValueChanged", Update_MountCheckButtons)
	UpdateCurrentMountSelection()
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
	local checkList = SVUI_Cache.Mounts.types
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
	if(IsControlKeyDown() or IsShiftKeyDown()) then
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
				SuperVillain:AddonMessage("No flying mount selected! Using your ground mount.")
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
			SuperVillain:AddonMessage("No swimming mount selected! Using your flying mount.")
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
SuperVillain.Registry:NewScript(SetMountCheckButtons);