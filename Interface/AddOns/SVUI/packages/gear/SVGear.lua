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
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, match, split, join = string.find, string.format, string.match, string.split, string.join;
--[[ MATH METHODS ]]--
local ceil, floor, round = math.ceil, math.floor, math.round;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = {};
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local NewHook = hooksecurefunc;
local UPDATE_TIMER = 0;
local REGEX_HEIRLOOM = "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?";
local COLOR_KEYS = { [0] = "|cffff0000", [1] = "|cff00ff00", [2] = "|cffffff88" };
local LIVESET, EQUIP_SET, SPEC_SET, SHOW_LEVEL, SHOW_DURABILITY, ONLY_DAMAGED, AVG_LEVEL, _;
local EquipmentSlots = {
    ["HeadSlot"] = {true,true},
    ["NeckSlot"] = {true,false},
    ["ShoulderSlot"] = {true,true},
    ["BackSlot"] = {true,false},
    ["ChestSlot"] = {true,true},
    ["WristSlot"] = {true,true},
    ["MainHandSlot"] = {true,true,true},
    ["SecondaryHandSlot"] = {true,true},
    ["HandsSlot"] = {true,true,true},
    ["WaistSlot"] = {true,true,true},
    ["LegsSlot"] = {true,true,true},
    ["FeetSlot"] = {true,true,true},
    ["Finger0Slot"] = {true,false,true},
    ["Finger1Slot"] = {true,false,true},
    ["Trinket0Slot"] = {true,false,true},
    ["Trinket1Slot"] = {true,false,true}
};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function UpdateUpvalues()
	SHOW_LEVEL = MOD.db.itemlevel.enable
	SHOW_DURABILITY = MOD.db.durability.enable
	ONLY_DAMAGED = MOD.db.durability.onlydamaged
	_, AVG_LEVEL = GetAverageItemLevel()
end

local function SetItemLevelDisplay(globalName, iLevel)
	local frame = _G[globalName]
	if(not frame) then return; end
	frame.ItemLevel:SetText()
	if(SHOW_LEVEL) then 
		local key = (iLevel < (AVG_LEVEL - 10)) and 0 or (iLevel > (AVG_LEVEL + 10)) and 1 or 2;
		frame.ItemLevel:SetFormattedText("%s%d|r", COLOR_KEYS[key], iLevel) 
	end
end

local function SetItemDurabilityDisplay(globalName, slotId)
	local frame = _G[globalName]
	if(not frame) then return; end
	if(SHOW_DURABILITY) then
		local current,total,actual,perc,r,g,b;
		current,total = GetInventoryItemDurability(slotId)
		if(current and total) then
			frame.DurabilityInfo.bar:SetMinMaxValues(0, 100)
			if(current == total and ONLY_DAMAGED) then
				frame.DurabilityInfo:Hide()
			else
				if(current ~= total) then
					actual = current / total;
					perc = actual * 100;
					r,g,b = SuperVillain:ColorGradient(actual,1,0,0,1,1,0,0,1,0)
					frame.DurabilityInfo.bar:SetValue(perc)
					frame.DurabilityInfo.bar:SetStatusBarColor(r,g,b)
					if not frame.DurabilityInfo:IsShown() then
						frame.DurabilityInfo:Show()
					end
				else
					frame.DurabilityInfo.bar:SetValue(100)
					frame.DurabilityInfo.bar:SetStatusBarColor(0, 1, 0)
				end
			end 
		else
			frame.DurabilityInfo:Hide()
		end
	else
		frame.DurabilityInfo:Hide()
	end
end

local function GetActiveGear()
	local count = GetNumEquipmentSets()
	local resultSpec = GetActiveSpecGroup()
	local resultSet
	EQUIP_SET = MOD.db.equipmentset
	SPEC_SET = nil
	if(resultSpec and GetSpecializationInfo(resultSpec)) then
		SPEC_SET = resultSpec == 1 and MOD.db.primary or MOD.db.secondary
	end
	if(count == 0) then 
		return resultSpec,false
	end;
	for i=1, count do 
		local setName,_,_,setUsed = GetEquipmentSetInfo(i)
		if setUsed then 
			resultSet = setName
			break
		end
	end;
	return resultSpec,resultSet 
end

local function SetDisplayStats(arg)
	for slotName, flags in pairs(EquipmentSlots) do
		local globalName = format("%s%s", arg, slotName)
		local frame = _G[globalName]

		if(flags[1]) then 
			frame.ItemLevel = frame:CreateFontString(nil, "OVERLAY")
			frame.ItemLevel:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, 1)
			frame.ItemLevel:SetFontTemplate(SuperVillain.Media.font.roboto, 10, "OUTLINE", "RIGHT")
		end;
		
		if(arg == "Character" and flags[2]) then
			frame.DurabilityInfo = CreateFrame("Frame", nil, frame)
			frame.DurabilityInfo:Width(7)
			if flags[3] then
				frame.DurabilityInfo:Point("TOPRIGHT", frame, "TOPLEFT", -1, 1)
				frame.DurabilityInfo:Point("BOTTOMRIGHT", frame, "BOTTOMLEFT", -1, -1)
			else
				frame.DurabilityInfo:Point("TOPLEFT", frame, "TOPRIGHT", 1, 1)
				frame.DurabilityInfo:Point("BOTTOMLEFT", frame, "BOTTOMRIGHT", 1, -1)
			end
			frame.DurabilityInfo:SetFrameLevel(frame:GetFrameLevel()-1)
			frame.DurabilityInfo:SetBackdrop({
				bgFile = [[Interface\BUTTONS\WHITE8X8]], 
				edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]], 
				tile = false, 
				tileSize = 0, 
				edgeSize = 2, 
				insets = {
					left = 0, 
					right = 0, 
					top = 0,
					bottom = 0
				}
			})
			frame.DurabilityInfo:SetBackdropColor(0, 0, 0, 0.5)
			frame.DurabilityInfo:SetBackdropBorderColor(0, 0, 0, 0.8)
			frame.DurabilityInfo.bar = CreateFrame("StatusBar", nil, frame.DurabilityInfo)
			frame.DurabilityInfo.bar:FillInner(frame.DurabilityInfo, 2, 2)
			frame.DurabilityInfo.bar:SetStatusBarTexture(SuperVillain.Media.bar.default)
			frame.DurabilityInfo.bar:SetOrientation("VERTICAL")
			frame.DurabilityInfo.bg = frame.DurabilityInfo:CreateTexture(nil, "BORDER")
			frame.DurabilityInfo.bg:FillInner(frame.DurabilityInfo, 2, 2)
			frame.DurabilityInfo.bg:SetTexture([[Interface\BUTTONS\WHITE8X8]])
			frame.DurabilityInfo.bg:SetVertexColor("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		end 
	end 
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local function RefreshInspectedGear()
	if(not MOD.PreBuildComplete) then return end;
	if(InCombatLockdown()) then 
		MOD:RegisterEvent("PLAYER_REGEN_ENABLED", RefreshInspectedGear)
		return 
	else 
		MOD:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end;

	local unit = InspectFrame and InspectFrame.unit or "player";
	if(not unit or (unit and not CanInspect(unit,false))) then return end;

	UpdateUpvalues()

	if(SHOW_LEVEL) then 
		SuperVillain:ParseGearSlots(unit, true, SetItemLevelDisplay)
	else
		SuperVillain:ParseGearSlots(unit, true)
	end
end

local function RefreshGear()
	if(not MOD.PreBuildComplete) then return end;
	if(InCombatLockdown()) then 
		MOD:RegisterEvent("PLAYER_REGEN_ENABLED", RefreshGear)
		return 
	else 
		MOD:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end;

	UpdateUpvalues()
	if(SHOW_LEVEL) then 
		SuperVillain:ParseGearSlots("player", false, SetItemLevelDisplay, SetItemDurabilityDisplay)
	else
		SuperVillain:ParseGearSlots("player", false, nil, SetItemDurabilityDisplay)
	end
end

local Gear_UpdateTabs = function() 
	SuperVillain:ExecuteTimer(RefreshInspectedGear, 0.2)
end

local function GearSwap()
	if(InCombatLockdown()) then return; end
	local gearSpec, gearSet = GetActiveGear()
	if(not gearSet) then return; end
	if MOD.db.battleground.enable then 
		local inDungeon,dungeonType = IsInInstance()
		if(inDungeon and dungeonType == "pvp" or dungeonType == "arena") then 
			if EQUIP_SET ~= "none" and EQUIP_SET ~= gearSet then 
				LIVESET = EQUIP_SET;
				UseEquipmentSet(EQUIP_SET)
			end;
			return 
		end 
	end
	if(SPEC_SET and SPEC_SET ~= "none" and SPEC_SET ~= gearSet) then 
		LIVESET = SPEC_SET;
		UseEquipmentSet(SPEC_SET)
	end
end

local function GearPreBuild()
	MOD:UnregisterEvent("PLAYER_ENTERING_WORLD")
	LoadAddOn("Blizzard_InspectUI")
	SetDisplayStats("Character")
	SetDisplayStats("Inspect")
	NewHook('InspectFrame_UpdateTabs', Gear_UpdateTabs)
	SuperVillain:ExecuteTimer(RefreshGear, 10)
	GearSwap()
	MOD.PreBuildComplete = true
end

local GearSwapComplete = function()
	if LIVESET then 
		SuperVillain:AddonMessage(join('',L["You have equipped equipment set: "],LIVESET))
		LIVESET = nil 
	end 
end;

function MOD:ReLoad()
	RefreshGear()
end;

function MOD:Load()
	self.PreBuildComplete = false
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", RefreshGear)
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", RefreshGear)
	self:RegisterEvent("SOCKET_INFO_UPDATE", RefreshGear)
	self:RegisterEvent("COMBAT_RATING_UPDATE", RefreshGear)
	self:RegisterEvent("MASTERY_UPDATE", RefreshGear)
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", GearSwap)
	self:RegisterEvent("EQUIPMENT_SWAP_FINISHED", GearSwapComplete)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", GearPreBuild)
end;
SuperVillain.Registry:NewPackage(MOD, "SVGear");