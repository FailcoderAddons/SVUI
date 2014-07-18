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
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local lower, trim = string.lower, string.trim
--[[ 
########################################################## 
GLOBAL SLASH FUNCTIONS
##########################################################
]]--
function SVUIFishingMode()
	if InCombatLockdown() then SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT); return; end
	if SuperVillain.Modes.CurrentMode and SuperVillain.Modes.CurrentMode == "Fishing" then SuperVillain.Modes:EndJobModes() else SuperVillain.Modes:SetJobMode("Fishing") end
end
function SVUIFarmingMode()
	if InCombatLockdown() then SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT); return; end
	if SuperVillain.Modes.CurrentMode and SuperVillain.CurrentMode == "Farming" then SuperVillain.Modes:EndJobModes() else SuperVillain.Modes:SetJobMode("Farming") end
end
function SVUIArchaeologyMode()
	if InCombatLockdown() then SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT); return; end
	if SuperVillain.Modes.CurrentMode and SuperVillain.Modes.CurrentMode == "Archaeology" then SuperVillain.Modes:EndJobModes() else SuperVillain.Modes:SetJobMode("Archaeology") end
end
function SVUICookingMode()
	if InCombatLockdown() then SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT); return; end
	if SuperVillain.Modes.CurrentMode and SuperVillain.Modes.CurrentMode == "Cooking" then SuperVillain.Modes:EndJobModes() else SuperVillain.Modes:SetJobMode("Cooking") end
end
function SVUISayIncoming()
	local subzoneText = GetSubZoneText()
	local msg = ("{rt8} Incoming %s {rt8}"):format(subzoneText)
	SendChatMessage(msg, "INSTANCE_CHAT")
	return
end
--[[ 
########################################################## 
LOCAL SLASH FUNCTIONS
##########################################################
]]--
local function SVUIMasterCommand(msg)
	if msg then
		msg = lower(trim(msg))
		if (msg == "install") then
			SuperVillain:Install()
		elseif (msg == "move" or msg == "mentalo") then
			SuperVillain:UseMentalo()
		elseif (msg == "kb" or msg == "bind") and SuperVillain.db.SVBar.enable then
			SuperVillain.Registry:Expose("SVBar"):ToggleKeyBindingMode()
		elseif (msg == "reset" or msg == "resetui") then
			SuperVillain:ResetAllUI()
		elseif (msg == "fish" or msg == "fishing") then
			SVUIFishingMode()
		elseif (msg == "farm" or msg == "farming") then
			SVUIFarmingMode()
		elseif (msg == "cook" or msg == "cooking") then
			SVUIArchaeologyMode()
		elseif (msg == "dig" or msg == "survey" or msg == "archaeology") then
			SVUICookingMode()
		elseif (msg == "bg" or msg == "pvp") then
			local MOD = SuperVillain.Registry:Expose('SVStats')
			MOD.ForceHideBGStats = nil;
			MOD:Generate()
			SuperVillain:AddonMessage(L['Battleground statistics will now show again if you are inside a battleground.'])
		elseif (msg == "toasty" or msg == "kombat") then
			SuperVillain:ToastyKombat()
		elseif (msg == "lol") then
			PlaySoundFile("Sound\\Character\\Human\\HumanVocalFemale\\HumanFemalePissed04.wav")
		else
			SuperVillain:ToggleConfig()
		end
	else
		SuperVillain:ToggleConfig()
	end
end

local function EnableAddon(addon)
	local _, _, _, _, _, reason, _ = GetAddOnInfo(addon)
	if reason ~= "MISSING" then 
		EnableAddOn(addon) 
		ReloadUI() 
	else 
		print("|cffff0000Error, Addon '"..addon.."' not found.|r") 
	end	
end

local function DisableAddon(addon)
	local _, _, _, _, _, reason, _ = GetAddOnInfo(addon)
	if reason ~= "MISSING" then 
		DisableAddOn(addon) 
		ReloadUI() 
	else 
		print("|cffff0000Error, Addon '"..addon.."' not found.|r") 
	end
end
--[[ 
########################################################## 
LEEEEEROY
##########################################################
]]--
do
	local PullCountdown = CreateFrame("Frame", "PullCountdown")
	local PullCountdownHandler = CreateFrame("Frame")
	local firstdone, delay, target
	local interval = 1.5
	local lastupdate = 0

	local function reset()
		PullCountdownHandler:SetScript("OnUpdate", nil)
		firstdone, delay, target = nil, nil, nil
		lastupdate = 0
	end

	local function pull(self, elapsed)
		local tname = UnitName("target")
		if tname then
			target = tname
		else
			target = ""
		end
		if not firstdone then
			SendChatMessage(string.format(L["Pulling %s in %s.."], target, tostring(delay)), MsgTest(true))
			firstdone = true
			delay = delay - 1
		end
		lastupdate = lastupdate + elapsed
		if lastupdate >= interval then
			lastupdate = 0
			if delay > 0 then
				SendChatMessage(tostring(delay).."..", MsgTest(true))
				delay = delay - 1
			else
				SendChatMessage(L["Leeeeeroy!"], MsgTest(true))
				reset()
			end
		end
	end

	function PullCountdown.Pull(timer)
		delay = timer or 3
		if PullCountdownHandler:GetScript("OnUpdate") then
			reset()
			SendChatMessage(L["Pull ABORTED!"], MsgTest(true))
		else
			PullCountdownHandler:SetScript("OnUpdate", pull)
		end
	end

	SlashCmdList.PULLCOUNTDOWN = function(msg)
		if tonumber(msg) ~= nil then
			PullCountdown.Pull(msg)
		else
			PullCountdown.Pull()
		end
	end
	SLASH_PULLCOUNTDOWN1 = "/pc"
end
--[[ 
########################################################## 
LOAD ALL SLASH FUNCTIONS
##########################################################
]]--
SLASH_SVUI_SV1="/sv"
SlashCmdList["SVUI_SV"] = SVUIMasterCommand;
SLASH_SVUI_SVUI1="/svui"
SlashCmdList["SVUI_SVUI"] = SVUIMasterCommand;
SLASH_SVUI_ENABLE1="/enable"
SlashCmdList["SVUI_ENABLE"] = EnableAddon;
SLASH_SVUI_DISABLE1="/disable"
SlashCmdList["SVUI_DISABLE"] = DisableAddon;