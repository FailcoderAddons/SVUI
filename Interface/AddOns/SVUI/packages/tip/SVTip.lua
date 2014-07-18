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
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local find, format, match, sub, gsub = string.find, string.format, string.match, string.sub, string.gsub;
--[[ MATH METHODS ]]--
local floor,min = math.floor, math.min;
--[[ TABLE METHODS ]]--
local twipe, tconcat = table.wipe, table.concat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = {};
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local NewHook = hooksecurefunc;
local _G = getfenv(0);
local GameTooltip, GameTooltipStatusBar = _G["GameTooltip"], _G["GameTooltipStatusBar"];
local playerGUID = UnitGUID("player");
local targetList, inspectCache = {}, {};
local NIL_COLOR = { r = 1, g = 1, b = 1 };
local TAPPED_COLOR = { r = .6, g = .6, b = .6 };
local SKULL_ICON = "|TInterface\\TARGETINGFRAME\\UI-TargetingFrame-Skull.blp:16:16|t";
local TAMABLE_INDICATOR = "|cffFFFF00Tamable|r";
local TT_TOP = [[Interface\Addons\SVUI\assets\artwork\Template\Tooltip\TT-TOP]]
local TT_BOTTOM = [[Interface\Addons\SVUI\assets\artwork\Template\Tooltip\TT-BOTTOM]]
local TT_RIGHT = [[Interface\Addons\SVUI\assets\artwork\Template\Tooltip\TT-RIGHT-OVERLAY]]
local TT_LEFT = [[Interface\Addons\SVUI\assets\artwork\Template\Tooltip\TT-LEFT-OVERLAY]]

local TAMABLE_FAMILIES = {
	["Basilisk"] = true, 	 ["Bat"] = true, 		  ["Bear"] = true, 		   ["Beetle"] = true, 
	["Bird of Prey"] = true, ["Boar"] = true, 		  ["Carrion Bird"] = true, ["Cat"] = true, 
	["Chimaera"] = true, 	 ["Core Hound"] = true,   ["Crab"] = true, 		   ["Crane"] = true, 
	["Crocolisk"] = true, 	 ["Devilsaur"] = true, 	  ["Direhorn"] = true, 	   ["Dog"] = true, 
	["Dragonhawk"] = true, 	 ["Fox"] = true, 		  ["Goat"] = true, 		   ["Gorilla"] = true, 
	["Wasp"] = true, 		 ["Hydra"] = true, 		  ["Hyena"] = true, 	   ["Monkey"] = true, 
	["Moth"] = true, 		 ["Nether Ray"] = true,   ["Porcupine"] = true,    ["Quilen"] = true, 
	["Raptor"] = true, 		 ["Ravager"] = true, 	  ["Rhino"] = true, 	   ["Riverbeast"] = true, 
	["Scorpid"] = true, 	 ["Shale Spider"] = true, ["Spirit Beast"] = true, ["Serpent"] = true, 
	["Silithid"] = true, 	 ["Spider"] = true, 	  ["Sporebat"] = true, 	   ["Tallstrider"] = true, 
	["Turtle"] = true,		 ["Warp Stalker"] = true, ["Wasp"] = true, 		   ["Water strider"] = true, 
	["Wind Serpent"] = true, ["Wolf"] = true, 		  ["Worm"] = true
}

local tooltips = {
	GameTooltip, ItemRefTooltip, ItemRefShoppingTooltip1, 
	ItemRefShoppingTooltip2, ItemRefShoppingTooltip3, AutoCompleteBox, 
	FriendsTooltip, ConsolidatedBuffsTooltip, ShoppingTooltip1, 
	ShoppingTooltip2, ShoppingTooltip3, WorldMapTooltip, 
	WorldMapCompareTooltip1, WorldMapCompareTooltip2, 
	WorldMapCompareTooltip3, DropDownList1MenuBackdrop, 
	DropDownList2MenuBackdrop, DropDownList3MenuBackdrop, BNToastFrame
}

local classification = {
	worldboss = format("|cffAF5050%s|r", BOSS), 
	rareelite = format("|cffAF5050+%s|r", ITEM_QUALITY3_DESC), 
	elite = "|cffAF5050+|r", 
	rare = format("|cffAF5050%s|r", ITEM_QUALITY3_DESC)
}
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function Pinpoint(parent)
    local centerX,centerY = parent:GetCenter()
    local screenWidth = GetScreenWidth()
    local screenHeight = GetScreenHeight()
    local result;
    if not centerX or not centerY then 
        return "CENTER"
    end 
    local heightTop = screenHeight * 0.75;
    local heightBottom = screenHeight * 0.25;
    local widthLeft = screenWidth * 0.25;
    local widthRight = screenWidth * 0.75;
    if(((centerX > widthLeft) and (centerX < widthRight)) and (centerY > heightTop)) then 
        result="TOP"
    elseif((centerX < widthLeft) and (centerY > heightTop)) then 
        result="TOPLEFT"
    elseif((centerX > widthRight) and (centerY > heightTop)) then 
        result="TOPRIGHT"
    elseif(((centerX > widthLeft) and (centerX < widthRight)) and centerY < heightBottom) then 
        result="BOTTOM"
    elseif((centerX < widthLeft) and (centerY < heightBottom)) then 
        result="BOTTOMLEFT"
    elseif((centerX > widthRight) and (centerY < heightBottom)) then 
        result="BOTTOMRIGHT"
    elseif((centerX < widthLeft) and (centerY > heightBottom) and (centerY < heightTop)) then 
        result="LEFT"
    elseif((centerX > widthRight) and (centerY < heightTop) and (centerY > heightBottom)) then 
        result="RIGHT"
    else 
        result="CENTER"
    end 
    return result 
end 

local function TruncateString(value)
    if value >= 1e9 then 
        return ("%.1fb"):format(value/1e9):gsub("%.?0+([kmb])$","%1")
    elseif value >= 1e6 then 
        return ("%.1fm"):format(value/1e6):gsub("%.?0+([kmb])$","%1")
    elseif value >= 1e3 or value <= -1e3 then 
        return ("%.1fk"):format(value/1e3):gsub("%.?0+([kmb])$","%1")
    else 
        return value 
    end 
end

local function GetTalentSpec(unit,isPlayer)
	local spec;
	if isPlayer then 
		spec = GetSpecialization()
	else 
		spec = GetInspectSpecialization(unit)
	end 
	if spec ~= nil and spec > 0 then 
		if not isPlayer then 
			local byRole = GetSpecializationRoleByID(spec)
			if byRole ~= nil then 
				local _,byRoleData = GetSpecializationInfoByID(spec)
				return byRoleData 
			end 
		else 
			local _,specData = GetSpecializationInfo(spec)
			return specData 
		end 
	end 
end 
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local _hook_GameTooltip_ShowCompareItem = function(self, shift)
	if not self then self = GameTooltip end 
	local _,link = self:GetItem()
	if not link then return; end
	local shoppingTooltip1, shoppingTooltip2, shoppingTooltip3 = unpack(self.shoppingTooltips)
	local item1 = nil;
	local item2 = nil;
	local item3 = nil;
	local side = "left"
	if shoppingTooltip1:SetHyperlinkCompareItem(link, 1, shift, self) then item1 = true end 
	if shoppingTooltip2:SetHyperlinkCompareItem(link, 2, shift, self) then item2 = true end 
	if shoppingTooltip3:SetHyperlinkCompareItem(link, 3, shift, self) then item3 = true end 
	local rightDist = 0;
	local leftPos = self:GetLeft()
	local rightPos = self:GetRight()
	if not rightPos then rightPos = 0 end 
	if not leftPos then leftPos = 0 end 
	rightDist = GetScreenWidth() - rightPos;
	if(leftPos and (rightDist < leftPos)) then
		side = "left"
	else
		side = "right"
	end 

	if(self:GetAnchorType() and (self:GetAnchorType() ~= "ANCHOR_PRESERVE")) then 
		local totalWidth = 0;
		if item1 then
			totalWidth = totalWidth + shoppingTooltip1:GetWidth()
		end 
		if item2 then
			totalWidth = totalWidth + shoppingTooltip2:GetWidth()
		end 
		if item3 then
			totalWidth = totalWidth + shoppingTooltip3:GetWidth()
		end 
		if(side == "left" and (totalWidth > leftPos)) then
			self:SetAnchorType(self:GetAnchorType(), (totalWidth - leftPos), 0)
		elseif(side == "right" and ((rightPos + totalWidth) > GetScreenWidth())) then 
			self:SetAnchorType(self:GetAnchorType(), -((rightPos + totalWidth) - GetScreenWidth()), 0)
		end 
	end 

	if item3 then
		shoppingTooltip3:SetOwner(self, "ANCHOR_NONE")
		shoppingTooltip3:ClearAllPoints()
		if(side and side == "left") then
			shoppingTooltip3:SetPoint("TOPRIGHT", self, "TOPLEFT", -2, -10)
		else
			shoppingTooltip3:SetPoint("TOPLEFT", self, "TOPRIGHT", 2, -10)
		end 
		shoppingTooltip3:SetHyperlinkCompareItem(link, 3, shift, self)
		shoppingTooltip3:Show()
	end 

	if item1 then
		if item3 then 
			shoppingTooltip1:SetOwner(shoppingTooltip3, "ANCHOR_NONE")
		else
			shoppingTooltip1:SetOwner(self, "ANCHOR_NONE")
		end 
		shoppingTooltip1:ClearAllPoints()
		
		if(side and side == "left") then
			if item3 then 
				shoppingTooltip1:SetPoint("TOPRIGHT", shoppingTooltip3, "TOPLEFT", -2, 0)
			else
				shoppingTooltip1:SetPoint("TOPRIGHT", self, "TOPLEFT", -2, -10)
			end 
		else
			if item3 then
				shoppingTooltip1:SetPoint("TOPLEFT", shoppingTooltip3, "TOPRIGHT", 2, 0)
			else
				shoppingTooltip1:SetPoint("TOPLEFT", self, "TOPRIGHT", 2, -10)
			end 
		end 
		shoppingTooltip1:SetHyperlinkCompareItem(link, 1, shift, self)
		shoppingTooltip1:Show()

		if item2 then
			shoppingTooltip2:SetOwner(shoppingTooltip1, "ANCHOR_NONE")
			shoppingTooltip2:ClearAllPoints()
			if (side and side == "left") then
				shoppingTooltip2:SetPoint("TOPRIGHT", shoppingTooltip1, "TOPLEFT", -2, 0)
			else
				shoppingTooltip2:SetPoint("TOPLEFT", shoppingTooltip1, "TOPRIGHT", 2, 0)
			end 
			shoppingTooltip2:SetHyperlinkCompareItem(link, 2, shift, self)
			shoppingTooltip2:Show()
		end 
	end 
end 

function MOD:INSPECT_READY(_,guid)
	if MOD.lastGUID ~= guid then return end 
	local unit = "mouseover"
	if UnitExists(unit) then 
		local itemLevel = SuperVillain:ParseGearSlots(unit, true)
		local spec = GetTalentSpec(unit)
		inspectCache[guid] = {time = GetTime()}
		if spec then 
			inspectCache[guid].talent=spec 
		end 
		if itemLevel then 
			inspectCache[guid].itemLevel = itemLevel 
		end 
		GameTooltip:SetUnit(unit)
	end 
	MOD:UnregisterEvent("INSPECT_READY")
end 

local function ShowInspectInfo(this,unit,unitLevel,r,g,b,iteration)
	local inspectable = CanInspect(unit)
	if not inspectable or unitLevel < 10 or iteration > 2 then return end 
	local guid = UnitGUID(unit)
	if guid == playerGUID then 
		this:AddDoubleLine(L["Talent Specialization:"],GetTalentSpec(unit,true),nil,nil,nil,r,g,b)
		this:AddDoubleLine(L["Item Level:"],floor(select(2,GetAverageItemLevel())),nil,nil,nil,1,1,1)
	elseif inspectCache[guid] then 
		local talent=inspectCache[guid].talent;
		local itemLevel=inspectCache[guid].itemLevel;
		if GetTime() - inspectCache[guid].time > 900 or not talent or not itemLevel then 
			inspectCache[guid] = nil;
			return ShowInspectInfo(this,unit,unitLevel,r,g,b,iteration+1)
		end 
		this:AddDoubleLine(L["Talent Specialization:"],talent,nil,nil,nil,r,g,b)
		this:AddDoubleLine(L["Item Level:"],itemLevel,nil,nil,nil,1,1,1)
	else 
		if not inspectable or InspectFrame and InspectFrame:IsShown() then 
			return 
		end 
		MOD.lastGUID = guid;
		NotifyInspect(unit)
		MOD:RegisterEvent("INSPECT_READY")
	end 
end 

local function tipcleaner(this)
	for i=3, this:NumLines() do 
		local tip = _G["GameTooltipTextLeft"..i]
		local tipText = tip:GetText()
		if tipText:find(PVP) or tipText:find(FACTION_ALLIANCE) or tipText:find(FACTION_HORDE) then 
			tip:SetText(nil)
			tip:Hide()
		end 
	end 
end 

local function tiplevel(this, start)
	for i = start, this:NumLines() do 
		local tip = _G["GameTooltipTextLeft"..i]
		if tip:GetText() and tip:GetText():find(LEVEL) then 
			return tip 
		end 
	end 
end

local _hook_GameTooltip_OnTooltipSetUnit = function(self)
	local unit = select(2, self:GetUnit())
	local TamablePet;
	if self:GetOwner()  ~= UIParent and MOD.db.visibility.unitFrames  ~= "NONE" then 
		local vis = MOD.db.visibility.unitFrames;
		if vis == "ALL" or not (vis == "SHIFT" and IsShiftKeyDown() or vis == "CTRL" and IsControlKeyDown() or vis == "ALT" and IsAltKeyDown()) then 
			self:Hide()
			return 
		end 
	end 
	if not unit then 
		local mFocus = GetMouseFocus()
		if mFocus and mFocus:GetAttribute("unit") then 
			unit = mFocus:GetAttribute("unit")
		end 
		if not unit or not UnitExists(unit) then return end 
	end 
	tipcleaner(self)
	local unitLevel = UnitLevel(unit)
	local colors, qColor, totColor;
	local lvlLine;
	local isShiftKeyDown = IsShiftKeyDown()

	if UnitIsPlayer(unit) then 
		local className, classToken = UnitClass(unit)
		local unitName, unitRealm = UnitName(unit)
		local guildName, guildRankName, _, guildRealm = GetGuildInfo(unit)
		local pvpName = UnitPVPName(unit)
		local realmRelation = UnitRealmRelationship(unit)
		colors = RAID_CLASS_COLORS[classToken]

		if MOD.db.playerTitles and pvpName then 
			unitName = pvpName 
		end 
		if unitRealm and unitRealm ~= "" then 
			if(isShiftKeyDown) then 
				unitName = unitName.."-"..unitRealm 
			elseif(realmRelation == LE_REALM_RELATION_COALESCED) then 
				unitName = unitName..FOREIGN_SERVER_LABEL 
			elseif(realmRelation == LE_REALM_RELATION_VIRTUAL) then 
				unitName = unitName..INTERACTIVE_SERVER_LABEL 
			end 
		end

		if(UnitIsAFK(unit)) then
			GameTooltipTextLeft1:SetFormattedText("[|cffFF0000%s|r] |c%s%s|r ", L["AFK"], colors.colorStr, unitName)
		elseif(UnitIsDND(unit)) then
			GameTooltipTextLeft1:SetFormattedText("[|cffFF9900%s|r] |c%s%s|r ", L["DND"], colors.colorStr, unitName)
		else
			GameTooltipTextLeft1:SetFormattedText("|c%s%s|r", colors.colorStr, unitName)
		end

		if(guildName) then
			if(guildRealm and isShiftKeyDown) then
				guildName = guildName.."-"..guildRealm
			end

			if guildRankName and MOD.db.guildRanks then 
				GameTooltipTextLeft2:SetText(("<|cff00ff10%s|r> [|cff00ff10%s|r]"):format(guildName, guildRankName))
			else 
				GameTooltipTextLeft2:SetText(("<|cff00ff10%s|r>"):format(guildName))
			end 
			lvlLine = tiplevel(self, 3)
		else
			lvlLine = tiplevel(self, 2)
		end 

		if(lvlLine) then 
			qColor = GetQuestDifficultyColor(unitLevel)
			local race, englishRace = UnitRace(unit)
			local _, factionGroup = UnitFactionGroup(unit)
			if(factionGroup and englishRace == "Pandaren") then
				race = factionGroup.." "..race
			end	
			lvlLine:SetFormattedText("|cff%02x%02x%02x%s|r %s |c%s%s|r", qColor.r * 255, qColor.g * 255, qColor.b * 255, unitLevel > 0 and unitLevel or SKULL_ICON, race or "", colors.colorStr, className)
		end 

		if MOD.db.inspectInfo and isShiftKeyDown then 
			ShowInspectInfo(self, unit, unitLevel, colors.r, colors.g, colors.b, 0)
		end 
	else
		if UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then 
			colors = TAPPED_COLOR 
		else 
			colors = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
		end 

		lvlLine = tiplevel(self, 2)

		if(lvlLine) then
			local creatureClassification = UnitClassification(unit)
			local creatureType = UnitCreatureType(unit)
			local temp = ""
			if(UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit)) then 
				unitLevel = UnitBattlePetLevel(unit)
				local ab = C_PetJournal.GetPetTeamAverageLevel()
				if ab then 
					qColor = GetRelativeDifficultyColor(ab, unitLevel)
				else 
					qColor = GetQuestDifficultyColor(unitLevel)
				end 
			else 
				qColor = GetQuestDifficultyColor(unitLevel)
			end 

			if UnitIsPVP(unit) then 
				temp = format(" (%s)", PVP)
			end 

			if(creatureType) then
				local family = UnitCreatureFamily(unit) or creatureType
				if(SuperVillain.class == "HUNTER" and creatureType == PET_TYPE_SUFFIX[8] and (family and TAMABLE_FAMILIES[family])) then
					local hunterLevel = UnitLevel("player")
					if(unitLevel <= hunterLevel) then
						TamablePet = true
					end
				end
				creatureType = family
			else
				creatureType = ""
			end

			lvlLine:SetFormattedText("|cff%02x%02x%02x%s|r%s %s%s", qColor.r * 255, qColor.g * 255, qColor.b * 255, unitLevel > 0 and unitLevel or "??", classification[creatureClassification] or "", creatureType, temp)
		end 
	end
	if(TamablePet) then
		GameTooltip:AddLine(TAMABLE_INDICATOR)
	end
	if MOD.db.targetInfo then
		local unitTarget = unit.."target"
		if(unit ~= "player" and UnitExists(unitTarget)) then 
			if UnitIsPlayer(unitTarget) and not UnitHasVehicleUI(unitTarget) then 
				totColor = RAID_CLASS_COLORS[select(2, UnitClass(unitTarget))]
			else 
				totColor = FACTION_BAR_COLORS[UnitReaction(unitTarget, "player")]
			end 
			GameTooltip:AddDoubleLine(format("%s:", TARGET), format("|cff%02x%02x%02x%s|r", totColor.r * 255, totColor.g * 255, totColor.b * 255, UnitName(unitTarget)))
		end 
		if IsInGroup() then 
			for i = 1, GetNumGroupMembers() do 
				local groupedUnit = IsInRaid() and "raid"..i or "party"..i;
				if UnitIsUnit(groupedUnit.."target", unit) and not UnitIsUnit(groupedUnit, "player") then 
					local _, classToken = UnitClass(groupedUnit)
					tinsert(targetList, format("|c%s%s|r", RAID_CLASS_COLORS[classToken].colorStr, UnitName(groupedUnit)))
				end 
			end 
			local maxTargets = #targetList;
			if maxTargets > 0 then 
				GameTooltip:AddLine(format("%s (|cffffffff%d|r): %s", L["Targeted By:"], maxTargets, tconcat(targetList, ", ")), nil, nil, nil, true)
				twipe(targetList)
			end 
		end 
	end 
	if colors then 
		GameTooltipStatusBar:SetStatusBarColor(colors.r, colors.g, colors.b)
	else 
		GameTooltipStatusBar:SetStatusBarColor(0.6, 0.6, 0.6)
	end 
end 

local _hook_GameTooltipStatusBar_OnValueChanged = function(self, value)
	if not value or not MOD.db.healthBar.text or not self.text then return end 
	local unit = select(2,self:GetParent():GetUnit())
	if not unit then 
		local mFocus = GetMouseFocus()
		if mFocus and mFocus:GetAttribute("unit") then 
			unit = mFocus:GetAttribute("unit")
		end 
	end 
	local min,max = self:GetMinMaxValues()
	if value > 0 and max==1 then 
		self.text:SetText(format("%d%%",floor(value * 100)))
		self:SetStatusBarColor(TAPPED_COLOR.r,TAPPED_COLOR.g,TAPPED_COLOR.b)
	elseif value==0 or unit and UnitIsDeadOrGhost(unit) then 
		self.text:SetText(DEAD)
	else 
		self.text:SetText(TruncateString(value).." / "..TruncateString(max))
	end 
end 

local _hook_GameTooltip_OnTooltipSetItem = function(self)
	if not self.itemCleared then
		local key,itemID = self:GetItem()
		local left = "";
		local right = "";
		if itemID ~= nil and MOD.db.spellID then 
			left = "|cFFCA3C3CSpell ID: |r"
			right = ("|cFFCA3C3C%s|r %s"):format(ID,itemID):match(":(%w+)")
		end 
		if left ~= "" or right ~= "" then 
			self:AddLine(" ")
			self:AddDoubleLine(left,right)
		end 
		self.itemCleared = true 
	end
end 

local _hook_GameTooltip_ShowStatusBar = function(self, ...)
	local bar = _G[self:GetName() .. "StatusBar" .. self.shownStatusBars]
	if bar and not bar.styled then 
		bar:Formula409()
		bar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		bar:SetFixedPanelTemplate('Inset',true)
		if not bar.border then 
			local border=CreateFrame("Frame",nil,bar)
			border:WrapOuter(bar,1,1)
			border:SetFrameLevel(bar:GetFrameLevel() - 1)
			border:SetBackdrop({
				edgeFile=[[Interface\BUTTONS\WHITE8X8]],
				edgeSize=1,
				insets={left=1,right=1,top=1,bottom=1}
			})
			border:SetBackdropBorderColor(0,0,0,1)
			bar.border=border 
		end 
		bar.styled=true 
	end 
end 

local _hook_OnSetUnitAura = function(self, unit, index, filter)
	local _, _, _, _, _, _, _, caster, _, _, spellID = UnitAura(unit, index, filter)
	if spellID and MOD.db.spellID then 
		if caster then 
			local name = UnitName(caster)
			local _, class = UnitClass(caster)
			local color = RAID_CLASS_COLORS[class]
			if color then 
				self:AddDoubleLine(("|cFFCA3C3C%s|r %d"):format(ID, spellID), format("|c%s%s|r", color.colorStr, name))
			end
		else 
			self:AddLine(("|cFFCA3C3C%s|r %d"):format(ID, spellID))
		end 
		self:Show()
	end 
end 

local _hook_OnSetHyperUnitAura = function(self, unit, index, filter)
	if unit  ~= "player" then return end
	local auraName, _, _, _, _, _, _, caster, _, shouldConsolidate, spellID = UnitAura(unit, index, filter)
	if shouldConsolidate then 
		if caster then 
			local name = UnitName(caster)
			local _, class = UnitClass(caster)
			local color = RAID_CLASS_COLORS[class]
			if color then 
				self:AddDoubleLine(("|cFFCA3C3C%s|r"):format(auraName), format("|c%s%s|r", color.colorStr, name))
			end
		else 
			self:AddLine(("|cFFCA3C3C%s|r"):format(auraName))
		end 
		self:Show()
	end 
end 

local _hook_GameTooltip_OnTooltipSetSpell = function(self)
	local ref = select(3, self:GetSpell())
	if not ref then return end 
	local text = ("|cFFCA3C3C%s|r%d"):format(ID, ref)
	local max = self:NumLines()
	local check;
	for i = 1, max do 
		local tip = _G[("GameTooltipTextLeft%d"):format(i)]
		if tip and tip:GetText() and tip:GetText():find(text) then 
			check = true;
			break 
		end 
	end 
	if not check then 
		self:AddLine(text)
		self:Show()
	end 
end 

local _hook_GameTooltip_SetDefaultAnchor = function(self, parent)
	if SuperVillain.db.SVTip.enable ~= true then return end 
	if self:GetAnchorType() ~= "ANCHOR_NONE" then return end 
	if InCombatLockdown() and MOD.db.visibility.combat then 
		self:Hide()
		return 
	end 
	if parent then 
		if(MOD.db.cursorAnchor) then 
			self:SetOwner(parent, "ANCHOR_CURSOR")
			if not GameTooltipStatusBar.anchoredToTop then 
				GameTooltipStatusBar:ClearAllPoints()
				GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltip, "TOPLEFT", 1, 3)
				GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltip, "TOPRIGHT", -1, 3)
				GameTooltipStatusBar.text:Point("CENTER", GameTooltipStatusBar, 0, 3)
				GameTooltipStatusBar.anchoredToTop = true 
			end 
			return 
		else 
			self:SetOwner(parent, "ANCHOR_NONE")
			self:ClearAllPoints()
			if GameTooltipStatusBar.anchoredToTop then 
				GameTooltipStatusBar:ClearAllPoints()
				GameTooltipStatusBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 1, -3)
				GameTooltipStatusBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -1, -3)
				GameTooltipStatusBar.text:Point("CENTER", GameTooltipStatusBar, 0, -3)
				GameTooltipStatusBar.anchoredToTop = nil 
			end 
		end 
	end 
	if not SuperVillain:TestMovableMoved("SVUI_ToolTip_MOVE")then 
		if(SVUI_ContainerFrame and SVUI_ContainerFrame:IsShown()) then 
			self:SetPoint("BOTTOMLEFT", SVUI_ContainerFrame, "TOPLEFT", 0, 18)
		elseif(RightSuperDock:GetAlpha() == 1 and RightSuperDock:IsShown()) then 
			self:SetPoint("BOTTOMRIGHT", RightSuperDock, "TOPRIGHT", -44, 18)
		else 
			self:SetPoint("BOTTOMRIGHT", SuperVillain.UIParent, "BOTTOMRIGHT", -44, 78)
		end 
	else
		local point = Pinpoint(SVUI_ToolTip_MOVE)
		if(point == "TOPLEFT") then 
			self:SetPoint("TOPLEFT", SVUI_ToolTip_MOVE, "TOPLEFT", 0, 0)
		elseif(point == "TOPRIGHT") then 
			self:SetPoint("TOPRIGHT", SVUI_ToolTip_MOVE, "TOPRIGHT", 0, 0)
		elseif(point == "BOTTOMLEFT" or point == "LEFT" )then 
			self:SetPoint("BOTTOMLEFT", SVUI_ToolTip_MOVE, "BOTTOMLEFT", 0, 0)
		else 
			self:SetPoint("BOTTOMRIGHT", SVUI_ToolTip_MOVE, "BOTTOMRIGHT", 0, 0)
		end 
	end 
end 
MOD.GameTooltip_SetDefaultAnchor = _hook_GameTooltip_SetDefaultAnchor

local _hook_BNToastOnShow = function(self,anchor,parent,relative,x,y)
	if parent ~= BNET_MOVE then 
		BNToastFrame:ClearAllPoints()
		BNToastFrame:Point('TOPLEFT',BNET_MOVE,'TOPLEFT')
	end
end

local _hook_OnTipCleared = function(self)
	self.itemCleared = nil 
end

local _hook_OnTipShow = function(self)
	local width,height = self:GetSize()
	local heightScale = min(64, height)
	local widthScale = min(128, width)
	local heightWidth = widthScale * 0.35
	self.SuperBorder[1]:SetSize(widthScale,heightWidth)
	self.SuperBorder[2]:SetSize(heightScale,heightScale)
	self.SuperBorder[3]:SetSize(heightScale,heightScale)
	self.SuperBorder[4]:SetSize(widthScale,heightWidth)
end

local _hook_OnItemRef = function(link,text,button,chatFrame)
	if find(link,"^spell:") then 
		local ref = sub(link,7)
		ItemRefTooltip:AddLine(("|cFFCA3C3C%s|r %d"):format(ID,ref))
		ItemRefTooltip:Show()
	end 
end

local TooltipModifierChangeHandler = function(self, event, mod)
	if (mod == "LSHIFT" or mod == "RSHIFT") and UnitExists("mouseover") then 
		GameTooltip:SetUnit("mouseover")
	end 
end 

function MOD:Load()
	BNToastFrame:Point("TOPRIGHT", SVUI_MinimapFrame, "BOTTOMLEFT", 0, -10)
	SuperVillain:SetSVMovable(BNToastFrame, "BNET_MOVE", L["BNet Frame"])
	NewHook(BNToastFrame, "SetPoint", _hook_BNToastOnShow)
	if not SuperVillain.db.SVTip.enable then return end 
	GameTooltipStatusBar:Height(MOD.db.healthBar.height)
	GameTooltipStatusBar:SetStatusBarTexture(SuperVillain.Media.bar.default)
	GameTooltipStatusBar:SetFixedPanelTemplate("Inset", true)
	GameTooltipStatusBar:ClearAllPoints()
	GameTooltipStatusBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 1, -3)
	GameTooltipStatusBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -1, -3)
	GameTooltipStatusBar.text = GameTooltipStatusBar:CreateFontString(nil, "OVERLAY")
	GameTooltipStatusBar.text:Point("CENTER", GameTooltipStatusBar, 0, -3)
	GameTooltipStatusBar.text:SetFontTemplate(SuperVillain.Shared:Fetch("font", MOD.db.healthBar.font), MOD.db.healthBar.fontSize, "OUTLINE")
	
	if not GameTooltipStatusBar.border then 
		local border = CreateFrame("Frame", nil, GameTooltipStatusBar)
		border:WrapOuter(GameTooltipStatusBar, 1, 1)
		border:SetFrameLevel(GameTooltipStatusBar:GetFrameLevel() - 1)
		border:SetBackdrop({edgeFile = [[Interface\BUTTONS\WHITE8X8]], edgeSize = 1})
		border:SetBackdropBorderColor(0, 0, 0, 1)
		GameTooltipStatusBar.border = border 
	end

	local anchor = CreateFrame("Frame", "GameTooltipAnchor", SuperVillain.UIParent)
	anchor:Point("BOTTOMRIGHT", RightSuperDock, "TOPRIGHT", 0, 60)
	anchor:Size(130, 20)
	anchor:SetFrameLevel(anchor:GetFrameLevel()  +  50)
	SuperVillain:SetSVMovable(anchor, "SVUI_ToolTip_MOVE", L["Tooltip"])

	NewHook("GameTooltip_SetDefaultAnchor", _hook_GameTooltip_SetDefaultAnchor)
	NewHook("GameTooltip_ShowStatusBar", _hook_GameTooltip_ShowStatusBar)
	NewHook("GameTooltip_ShowCompareItem", _hook_GameTooltip_ShowCompareItem)
	NewHook(GameTooltip, "SetUnitAura", _hook_OnSetUnitAura)
	NewHook(GameTooltip, "SetUnitBuff", _hook_OnSetUnitAura)
	NewHook(GameTooltip, "SetUnitDebuff", _hook_OnSetUnitAura)
	NewHook(GameTooltip, "SetUnitConsolidatedBuff", _hook_OnSetHyperUnitAura)

	if self.db.spellID then
		NewHook("SetItemRef", _hook_OnItemRef)
		GameTooltip:HookScript("OnTooltipSetSpell", _hook_GameTooltip_OnTooltipSetSpell)
	end

	GameTooltip:HookScript("OnTooltipCleared", _hook_OnTipCleared)
	GameTooltip:HookScript("OnTooltipSetItem", _hook_GameTooltip_OnTooltipSetItem)
	GameTooltip:HookScript("OnTooltipSetUnit", _hook_GameTooltip_OnTooltipSetUnit)
	GameTooltipStatusBar:HookScript("OnValueChanged", _hook_GameTooltipStatusBar_OnValueChanged)
	self:RegisterEvent("MODIFIER_STATE_CHANGED", TooltipModifierChangeHandler)
	-- local MINI_BG = [[Interface\Addons\SVUI\assets\artwork\Template\Tooltip\MINITIP-BG]]
	-- local MINI_LEFT = [[Interface\Addons\SVUI\assets\artwork\Template\Tooltip\MINITIP-LEFT]]
	-- local MINI_RIGHT = [[Interface\Addons\SVUI\assets\artwork\Template\Tooltip\MINITIP-RIGHT]]
	for _, tooltip in pairs(tooltips) do
		if(tooltip.SuperBorder) then return end
		local mask = CreateFrame("Frame", nil, tooltip)
		mask:SetAllPoints()
		mask[1] = mask:CreateTexture(nil, "BACKGROUND")
		mask[1]:SetPoint("BOTTOMLEFT", mask, "TOPLEFT", 0, 0)
		mask[1]:SetHeight(mask:GetWidth() * 0.25)
		mask[1]:SetWidth(mask:GetWidth() * 0.25)
		mask[1]:SetTexture(TT_TOP)
		mask[1]:SetVertexColor(0,0,0)
		mask[1]:SetBlendMode("BLEND")
		mask[1]:SetAlpha(0.65)
		mask[2] = mask:CreateTexture(nil, "BACKGROUND")
		mask[2]:SetPoint("LEFT", mask, "RIGHT", 0, 0)
		mask[2]:SetSize(64,64)
		mask[2]:SetTexture(TT_RIGHT)
		mask[2]:SetVertexColor(0,0,0)
		mask[2]:SetBlendMode("BLEND")
		mask[2]:SetAlpha(0.75)
		mask[3] = mask:CreateTexture(nil, "BACKGROUND")
		mask[3]:SetPoint("RIGHT", mask, "LEFT", 0, 0)
		mask[3]:SetSize(64,64)
		mask[3]:SetTexture(TT_LEFT)
		mask[3]:SetVertexColor(0,0,0)
		mask[3]:SetBlendMode("BLEND")
		mask[3]:SetAlpha(0.75)
		mask[4] = mask:CreateTexture(nil, "BACKGROUND")
		mask[4]:SetPoint("TOPRIGHT", mask, "BOTTOMRIGHT", 0, 0)
		mask[4]:SetHeight(mask:GetWidth() * 0.25)
		mask[4]:SetWidth(mask:GetWidth() * 0.25)
		mask[4]:SetTexture(TT_BOTTOM)
		mask[4]:SetVertexColor(0,0,0)
		mask[4]:SetBlendMode("BLEND")
		mask[4]:SetAlpha(0.5)
		tooltip.SuperBorder = mask
		tooltip:SetBackdrop({
			bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\Tooltip\TOOLTIP]], 
			edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
			tile = false, 
			edgeSize = 1
		})
		tooltip:SetBackdropColor(0, 0, 0, 0.8)
		tooltip:SetBackdropBorderColor(0, 0, 0) 
		tooltip.SetBackdrop = function() end
		tooltip.SetBackdropColor = function() end
		tooltip.SetBackdropBorderColor = function() end
		tooltip:HookScript("OnShow", _hook_OnTipShow)
	end 
end 
SuperVillain.Registry:NewPackage(MOD, "SVTip")