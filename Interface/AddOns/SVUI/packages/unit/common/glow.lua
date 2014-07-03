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
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
local MOD = SuperVillain.Registry:Expose('SVUnit');
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local find, gsub, split, format, min, abs, tremove, tinsert, twipe = string.find, string.gsub, string.split, string.format, math.min, math.abs, table.remove, table.insert, table.wipe;
local GetNumGroupMembers, GetNumSubgroupMembers = GetNumGroupMembers, GetNumSubgroupMembers
local IsInRaid, IsInGroup, GetTime = IsInRaid, IsInGroup, GetTime;
local playerId, healGlowFrame, healGlowTime;
local spells, groupUnits, frameBuffers, frameGroups = {}, {}, {}, {5, 10, 25, 40};
local glowingSpells = {102792, 130654, 124040, 115464, 116670, 114852, 114871, 82327, 85222, 121148, 34861, 64844, 110745, 122128, 120692, 120696, 23455, 596, 1064};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local ShowHealGlows = function(self, elapsed)
	self.elapsed = (self.elapsed or 0)  +  elapsed;
	if(self.elapsed < .1) then return end;
	self.elapsed = 0;
	local current = GetTime();
	local expireTime = 0;
	for _, u in pairs(groupUnits)do 
		expireTime = u[2]  +  healGlowTime;
		for _, group in ipairs(frameGroups)do 
			for _, frame in pairs(frameBuffers[group])do 
				if(frame.unit == u[1]) then 
					frame.HealGlow:SetShown(current < expireTime)
				end 
			end 
		end 
	end 
end;

function MOD:InitHealGlow()
	playerId = UnitGUID("player")
	for _, spellID in ipairs(glowingSpells) do
		local name, rank, icon, _, _, _, _, _, _ = GetSpellInfo(spellID)
		if name then 
			spells[name] = {spellID, icon}
		end 
	end 
	twipe(frameBuffers)
	for _, mark in ipairs(frameGroups) do 
		frameBuffers[mark] = {}
		local x = mark  /  5
		for i = 1, x do 
			for k = 1, 5 do 
				frame = mark == 5 and _G[("SVUI_PartyGroup%dUnitButton%i"):format(i, k)] or _G[("SVUI_Raid%dGroup%dUnitButton%i"):format(mark, i, k)]
				if frame then 
					frame.HealGlow = MOD:CreateHealGlow(frame, ((mark == 5 and "party%d" or "raid%d")):format(i))
					tinsert(frameBuffers[mark], frame)
				end 
			end 
		end 
	end 
	healGlowFrame = CreateFrame("Frame")
	healGlowFrame:SetScript("OnEvent", function(self, event, ...)
		if event == "COMBAT_LOG_EVENT_UNFILTERED"then 
			local _, subevent, _, source, _, _, _, dest, _, _, _, _, name = select(1, ...)
			if not(source == playerId and subevent == "SPELL_HEAL" and spells[name]) then return end;
			if groupUnits[dest] then 
				groupUnits[dest][2] = GetTime()
			end 
		end 
	end)
	MOD:UpdateGlowSettings()
end;

function MOD:UpdateGlowSettings()
	local color = self.db.glowcolor;
	for _, group in ipairs(frameGroups)do 
		for _, frame in ipairs(frameBuffers[group])do 
			frame.HealGlow:SetBackdropBorderColor(color[1], color[2], color[3])
		end 
	end;
	healGlowTime = self.db.glowtime;
	if self.db.healglow then 
		healGlowFrame:SetScript("OnUpdate", ShowHealGlows)
		healGlowFrame:RegisterUnitEvent("COMBAT_LOG_EVENT_UNFILTERED", playerId)
	else 
		healGlowFrame:SetScript("OnUpdate", nil)
		healGlowFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end 
end;

function MOD:UpdateGlowRoster()
	twipe(groupUnits)
	local count = IsInRaid() and GetNumGroupMembers() or IsInGroup() and GetNumSubgroupMembers() or 0;
	local str = IsInRaid() and "raid%d" or IsInGroup() and "party%d" or "solo";
	local result;
	for i = 1, count do 
		result = (str):format(i)
		if not UnitIsUnit(result, "player") then 
			groupUnits[UnitGUID(result)] = {result, 0}
		end 
	end;
	if str == "solo" then 
		groupUnits[UnitGUID("player")] = {"player", 0}
	end 
end;

function MOD:CreateHealGlow(frame)
	local shadow = CreateFrame("Frame", nil, frame)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(frame:GetFrameStrata())
	shadow:WrapOuter(frame, 3, 3)
	shadow:SetBackdrop({edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]], edgeSize = 3});
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, 0.9)
	shadow:Hide()
	return shadow
end;