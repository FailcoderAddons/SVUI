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
local SV = select(2, ...)
local L = SV.L;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local lower, trim = string.lower, string.trim

local MsgTest = function(warning)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if warning and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant()) then
			return "RAID_WARNING"
		else
			return "RAID"
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end
	return "SAY"
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
			SV.Setup:Install()
		elseif (msg == "move" or msg == "mentalo") then
			SV.Mentalo:Toggle()
		elseif (msg == "kb" or msg == "bind") and SV.db.SVBar.enable then
			SV.SVBar:ToggleKeyBindingMode()
		elseif (msg == "reset" or msg == "resetui") then
			SV:ResetAllUI()
		elseif (msg == "bg" or msg == "pvp") then
			local MOD = SV.SVStats
			MOD.ForceHideBGStats = nil;
			MOD:Generate()
			SV:AddonMessage(L['Battleground statistics will now show again if you are inside a battleground.'])
		elseif (msg == "toasty" or msg == "kombat") then
			SV:ToastyKombat()
		elseif (msg == "lol") then
			PlaySoundFile("Sound\\Character\\Human\\HumanVocalFemale\\HumanFemalePissed04.wav")
		else
			SV:ToggleConfig()
		end
	else
		SV:ToggleConfig()
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
			SendChatMessage((L["Pulling %s in %s.."]):format(target, tostring(delay)), MsgTest(true))
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
	
	SLASH_PULLCOUNTDOWN1 = "/jenkins"
	SlashCmdList["PULLCOUNTDOWN"] = function(msg)
		if(tonumber(msg) ~= nil) then
			PullCountdown.Pull(msg)
		else
			PullCountdown.Pull()
		end
	end
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