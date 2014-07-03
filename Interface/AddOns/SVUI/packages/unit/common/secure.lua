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
]]--
--[[ GLOBALS ]]--
local _G 		= _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local tostring 	= _G.tostring;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, upper = string.find, string.format, string.upper;
local match, gsub = string.match, string.gsub;
local min, random = math.min, math.random;
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
LOCAL VARIABLES
##########################################################
]]--
local definedEnvs,tags = {}, {};
local CharacterSelect = {"Munglunch", "Elv", "Tukz", "Azilroka", "Sortokk", "AlleyKat", "Quokka", "Haleth", "P3lim", "Haste", "Totalpackage", "Kryso", "Thepilli", "Doonga", "Judicate", "Cazart506", "Movster", "MuffinMonster", "Joelsoul", "Trendkill09", "Luamar", "Zharooz", "Lyn3x5", "Madh4tt3r", "Xarioth", "Sinnisterr", "Melonmaniac", "Hojowameeat", "Xandeca", "Bkan", "Daigan", "AtomicKiller", "Meljen", "Moondoggy", "Stormblade", "Schreibstift", "Anj", "Risien", "", ""};
local _PROXY;
local _ENV = {
	UnitPower = function(unit, g)
		if unit:find('target') or unit:find('focus') then 
			return UnitPower(unit, g)
		end
		return random(1, UnitPowerMax(unit, g)or 1)
	end, 
	UnitHealth = function(unit)
		if unit:find('target') or unit:find('focus') then 
			return UnitHealth(unit)
		end
		return random(1, UnitHealthMax(unit))
	end, 
	UnitName = function(unit)
		if unit:find('target') or unit:find('focus') then 
			return UnitName(unit)
		end
		local randomSelect = random(1, 40)
		local name = CharacterSelect[randomSelect];
		return name
	end, 
	UnitClass = function(unit)
		if unit:find('target') or unit:find('focus') then 
			return UnitClass(unit)
		end
		local token = CLASS_SORT_ORDER[random(1, #(CLASS_SORT_ORDER))]
		return LOCALIZED_CLASS_NAMES_MALE[token], token 
	end,
	Hex = function(r, g, b)
		if type(r) == "table" then
			if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return format("|cff%02x%02x%02x", r*255, g*255, b*255)
	end,
	ColorGradient = oUF_SuperVillain.ColorGradient,
};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function SetProxyEnv()
	if(_PROXY ~= nil) then return end
	_PROXY = setmetatable(_ENV, {__index = _G, __newindex = function(_,key,value) _G[key]=value end});
	tags['name:color'] = oUF_SuperVillain.Tags.Methods['name:color']
	for i=1, 30 do
		tags['name:'..i] = oUF_SuperVillain.Tags.Methods['name:'..i]
	end
	tags['health:color'] = oUF_SuperVillain.Tags.Methods['health:color']
	tags['health:current'] = oUF_SuperVillain.Tags.Methods['health:current']
	tags['health:deficit'] = oUF_SuperVillain.Tags.Methods['health:deficit']
	tags['health:curpercent'] = oUF_SuperVillain.Tags.Methods['health:curpercent']
	tags['health:curmax'] = oUF_SuperVillain.Tags.Methods['health:curmax']
	tags['health:curmax-percent'] = oUF_SuperVillain.Tags.Methods['health:curmax-percent']
	tags['health:max'] = oUF_SuperVillain.Tags.Methods['health:max']
	tags['health:percent'] = oUF_SuperVillain.Tags.Methods['health:percent']
	tags['power:color'] = oUF_SuperVillain.Tags.Methods['power:color']
	tags['power:current'] = oUF_SuperVillain.Tags.Methods['power:current']
	tags['power:deficit'] = oUF_SuperVillain.Tags.Methods['power:deficit']
	tags['power:curpercent'] = oUF_SuperVillain.Tags.Methods['power:curpercent']
	tags['power:curmax'] = oUF_SuperVillain.Tags.Methods['power:curmax']
	tags['power:curmax-percent'] = oUF_SuperVillain.Tags.Methods['power:curmax-percent']
	tags['power:max'] = oUF_SuperVillain.Tags.Methods['power:max']
	tags['power:percent'] = oUF_SuperVillain.Tags.Methods['power:percent']
end

local function ChangeGroupIndex(self)
	if not self:GetParent().forceShow and not self.forceShow then return end
	if not self:IsShown() then return end

	local max = MAX_RAID_MEMBERS;
	local db = self.db or self:GetParent().db;

	local newIndex = db.rSort and -(min(db.gCount * (db.gRowCol * 5), max) + 1 ) or -4;
	if self:GetAttribute("startingIndex") ~= newIndex then 
		self:SetAttribute("startingIndex", newIndex)
		self.isForced = true;
		MOD:AllowChildren(self, self:GetChildren())
	end
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:SwapElement(unitGroup, numGroup)
	if InCombatLockdown()then return end
	for i=1,numGroup do
		local unitName = unitGroup..i
		if self[unitName] and not self[unitName].isForced then 
			self:AllowElement(self[unitName])
		elseif self[unitName] then 
			self:RestrictElement(self[unitName])
		end 
	end 
end

local attrOverride = {
	["showRaid"] = true,
	["showParty"] = true,
	["showSolo"] = true
}
	
function MOD:UpdateGroupConfig(headerFrame, setForced)
	if InCombatLockdown()then return end

	SetProxyEnv()
	
	headerFrame.forceShow = setForced;
	headerFrame.forceShowAuras = setForced;
	headerFrame.isForced = setForced;

	if setForced then 
		for _, func in pairs(tags) do 
			if type(func) == "function" then 
				if not definedEnvs[func] then 
					definedEnvs[func] = getfenv(func)
					setfenv(func, _PROXY)
				end 
			end 
		end
		RegisterStateDriver(headerFrame, "visibility", "show")
	else 
		for func, fenv in pairs(definedEnvs)do 
			setfenv(func, fenv)
			definedEnvs[func] = nil 
		end
		RegisterStateDriver(headerFrame, "visibility", headerFrame.db.visibility)
		headerFrame:GetScript("OnEvent")(headerFrame, "PLAYER_ENTERING_WORLD")
	end

	for i = 1, #headerFrame.subunits do 
		local groupFrame = headerFrame.subunits[i]
		local db = groupFrame.db;

		if groupFrame:IsShown()then 
			groupFrame.forceShow = headerFrame.forceShow;
			groupFrame.forceShowAuras = headerFrame.forceShowAuras;
			groupFrame:HookScript("OnAttributeChanged", ChangeGroupIndex)
			if setForced then 
				for attr in pairs(attrOverride)do 
					groupFrame:SetAttribute(attr, nil)
				end

				ChangeGroupIndex(groupFrame)
				groupFrame:Update()
			else 
				for attr in pairs(attrOverride)do 
					groupFrame:SetAttribute(attr, true)
				end

				MOD:RestrictChildren(groupFrame, groupFrame:GetChildren())
				groupFrame:SetAttribute("startingIndex", 1)
				groupFrame:Update()
			end
		end 
	end

	headerFrame:SetActiveState()
end