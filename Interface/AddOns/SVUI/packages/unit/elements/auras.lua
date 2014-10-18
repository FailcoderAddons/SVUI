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
--LUA
local unpack        = unpack;
local select        = select;
local pairs         = pairs;
local type          = type;
local rawset        = rawset;
local rawget        = rawget;
local tostring      = tostring;
local error         = error;
local next          = next;
local pcall         = pcall;
local getmetatable  = getmetatable;
local setmetatable  = setmetatable;
local assert        = assert;
--BLIZZARD
local _G            = _G;
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe         = _G.wipe;
--STRING
local string        = string;
local upper         = string.upper;
local format        = string.format;
local find          = string.find;
local match         = string.match;
local gsub          = string.gsub;
--MATH
local math          = math;
local floor         = math.floor
local ceil         	= math.ceil
--TABLE
local table         = table;
local tsort         = table.sort;
local tremove       = table.remove;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local oUF_Villain = SV.oUF

assert(oUF_Villain, "SVUI was unable to locate oUF.");

local L = SV.L;
local LSM = LibStub("LibSharedMedia-3.0")
local MOD = SV.SVUnit

if(not MOD) then return end 

local CustomAuraFilter,CustomBarFilter;
local AURA_FONT = [[Interface\AddOns\SVUI\assets\fonts\Display.ttf]];
local AURA_FONTSIZE = 11;
local AURA_OUTLINE = "OUTLINE";
local shadowTex = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]];
local counterOffsets = {
	["TOPLEFT"] = {6, 1}, 
	["TOPRIGHT"] = {-6, 1}, 
	["BOTTOMLEFT"] = {6, 1}, 
	["BOTTOMRIGHT"] = {-6, 1}, 
	["LEFT"] = {6, 1}, 
	["RIGHT"] = {-6, 1}, 
	["TOP"] = {0, 0}, 
	["BOTTOM"] = {0, 0}, 
}
local textCounterOffsets = {
	["TOPLEFT"] = {"LEFT", "RIGHT", -2, 0}, 
	["TOPRIGHT"] = {"RIGHT", "LEFT", 2, 0}, 
	["BOTTOMLEFT"] = {"LEFT", "RIGHT", -2, 0}, 
	["BOTTOMRIGHT"] = {"RIGHT", "LEFT", 2, 0}, 
	["LEFT"] = {"LEFT", "RIGHT", -2, 0}, 
	["RIGHT"] = {"RIGHT", "LEFT", 2, 0}, 
	["TOP"] = {"RIGHT", "LEFT", 2, 0}, 
	["BOTTOM"] = {"RIGHT", "LEFT", 2, 0}, 
}
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local AuraRemover_OnClick = function(self)
	if not IsShiftKeyDown() then return end 
	local name = self.name;
	if name then 
		SV:AddonMessage((L["The spell '%s' has been added to the Blocked unitframe aura filter."]):format(name))
		SV.db.filter["Blocked"][name] = {["enable"] = true, ["priority"] = 0}
		MOD:RefreshUnitFrames()
	end
end

local AuraBarRemover_OnClick = function(self)
	if not IsShiftKeyDown() then return end 
	local name = self:GetParent().aura.name
	if name then 
		SV:AddonMessage((L["The spell '%s' has been added to the Blocked unitframe aura filter."]):format(name))
		SV.db.filter["Blocked"][name] = {["enable"] = true, ["priority"] = 0}
		MOD:RefreshUnitFrames()
	end 
end

local PostCreateAuraBars = function(self)
	self.iconHolder:RegisterForClicks("RightButtonUp")
	self.iconHolder:SetScript("OnClick", AuraBarRemover_OnClick)
end 

local PostCreateAuraIcon = function(self, aura)
	aura.cd.noOCC = true;
	aura.cd.noCooldownCount = true;
	aura.cd:SetReverse(true)
	aura.overlay:SetTexture(0,0,0,0)
	aura.stealable:SetTexture(0,0,0,0)
	
    if aura.styled then return end 
    if aura.SetNormalTexture then aura:SetNormalTexture("") end
	if aura.SetHighlightTexture then aura:SetHighlightTexture("") end
	if aura.SetPushedTexture then aura:SetPushedTexture("") end
	if aura.SetDisabledTexture then aura:SetDisabledTexture("") end

    aura:SetBackdrop({
    	bgFile = [[Interface\BUTTONS\WHITE8X8]], 
		tile = false, 
		tileSize = 0, 
		edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
        edgeSize = 2, 
        insets = {
            left = 0, 
            right = 0, 
            top = 0, 
            bottom = 0
        }
    })
    aura:SetBackdropColor(0, 0, 0, 0)
    aura:SetBackdropBorderColor(0, 0, 0)
    aura.icon:FillInner(aura, 1, 1)
    aura.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    aura:RegisterForClicks("RightButtonUp")
	aura:SetScript("OnClick", AuraRemover_OnClick)
	aura.styled = true
end

local ColorizeAuraBars = function(self)
	local bars = self.bars;
	for i = 1, #bars do 
		local auraBar = bars[i]
		if not auraBar:IsVisible()then break end 
		local color
		local spellName = auraBar.statusBar.aura.name;
		local spellID = auraBar.statusBar.aura.spellID;
		if(SV.db.filter["Shield"][spellName]) then 
			color = oUF_Villain.colors.shield_bars
		elseif(SV.db.media.unitframes.spellcolor[spellName]) then
			color = SV.db.media.unitframes.spellcolor[spellName]
		end 
		if color then 
			auraBar.statusBar:SetStatusBarColor(unpack(color))
			auraBar:SetBackdropColor(color[1] * 0.25, color[2] * 0.25, color[3] * 0.25, 0.5)
		else
			local r, g, b = auraBar.statusBar:GetStatusBarColor()
			auraBar:SetBackdropColor(r * 0.25, g * 0.25, b * 0.25, 0.5)
		end 
	end 
end

local UpdateAuraTimer = function(self, elapsed)
	self.expiration = self.expiration - elapsed;
	 
	if(self.expiration <= 0) then 
		self:SetScript("OnUpdate", nil)
		if(self.text:GetFont()) then
			self.text:SetText("")
		end
		return 
	end

	if(self.nextUpdate > 0) then 
		self.nextUpdate = self.nextUpdate - elapsed;
		return 
	end

	local expires = self.expiration;
	local calc, timeLeft = 0, 0;
	local timeFormat;

	if expires < 60 then 
		if expires >= 4 then
			timeLeft = floor(expires)
			timeFormat = "|cffffff00%d|r"
			self.nextUpdate = 0.51
		else
			timeLeft = expires
			timeFormat = "|cffff0000%.1f|r"
			self.nextUpdate = 0.051
		end 
	elseif expires < 3600 then
		timeFormat = "|cffffffff%dm|r"
		timeLeft = ceil(expires  /  60);
		calc = floor((expires  /  60)  +  .5);
		self.nextUpdate = calc > 1 and ((expires - calc)  *  29.5) or (expires - 59.5);
	elseif expires < 86400 then
		timeFormat = "|cff66ffff%dh|r"
		timeLeft = ceil(expires  /  3600);
		calc = floor((expires  /  3600)  +  .5);
		self.nextUpdate = calc > 1 and ((expires - calc)  *  1799.5) or (expires - 3570);
	else
		timeFormat = "|cff6666ff%dd|r"
		timeLeft = ceil(expires  /  86400);
		calc = floor((expires  /  86400)  +  .5);
		self.nextUpdate = calc > 1 and ((expires - calc)  *  43199.5) or (expires - 86400);
	end 
	if self.text:GetFont() then 
		self.text:SetFormattedText(timeFormat, timeLeft)
	else
		self.text:SetFormattedText(timeFormat, timeLeft)
	end 
end 

local PostUpdateAuraIcon = function(self, unit, button, index, offset)
	local name, _, _, _, dtype, duration, expiration, _, isStealable = UnitAura(unit, index, button.filter)
	local isFriend = UnitIsFriend('player', unit) == 1 and true or false
	if button.isDebuff then
		if(not isFriend and button.owner and button.owner ~= "player" and button.owner ~= "vehicle") then
			button:SetBackdropBorderColor(0.9, 0.1, 0.1)
			button.icon:SetDesaturated((unit and not unit:find('arena%d')) and true or false)
		else
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			if (name == "Unstable Affliction" or name == "Vampiric Touch") and SV.class ~= "WARLOCK" then
				button:SetBackdropBorderColor(0.05, 0.85, 0.94)
			else
				button:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
			end
			button.icon:SetDesaturated(false)
		end
	else
		if (isStealable) and not isFriend then
			button:SetBackdropBorderColor(237/255, 234/255, 142/255)
		else
			button:SetBackdropBorderColor(0,0,0,1)		
		end	
	end

	local size = button:GetParent().size
	if size then
		button:Size(size)
	end
	
	button.spell = name
	button.isStealable = isStealable
	if expiration and duration ~= 0 then
		if(not button:GetScript('OnUpdate')) then
			button.expirationTime = expiration
			button.expiration = expiration - GetTime()
			button.nextUpdate = -1
			button:SetScript('OnUpdate', UpdateAuraTimer)
		elseif(button.expirationTime ~= expiration) then
			button.expirationTime = expiration
			button.expiration = expiration - GetTime()
			button.nextUpdate = -1
		end
	end	
	if duration == 0 or expiration == 0 then
		button:SetScript('OnUpdate', nil)
		if(button.text:GetFont()) then
			button.text:SetText('')
		end
	end
end 

do
	local function _test(setting, helpful)
		local friend, enemy = false, false
		if type(setting) == "boolean" then 
			friend = setting;
		  	enemy = setting
		elseif setting and type(setting) ~= "string" then 
			friend = setting.friendly;
		  	enemy = setting.enemy
		end 
		if (friend and helpful) or (enemy and not helpful) then 
		  return true;
		end
	  	return false 
	end 

	CustomAuraFilter = function(self, unit, icon, name, _, _, _, debuffType, duration, _, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossAura)
		local db = SV.db.SVUnit[self.___key]
		local auraType = self.type;
		if(not auraType) then return true end 
		if((not db) or (db and not db[auraType]) or (spellID == 65148)) then 
			return false;
		end
		local auraDB = db[auraType]
		local isPlayer = caster == "player" or caster == "vehicle"
		local filtered = true
		local fromPlayer = true;
		local pass = false;
		local friendly = UnitIsFriend("player", unit) == 1 and true or false;

		icon.isPlayer = isPlayer;
		icon.owner = caster;
		icon.name = name;
		icon.priority = 0;

		local shieldSpell = SV.db.filter["Shield"][name]
		if shieldSpell and shieldSpell.enable then 
			icon.priority = shieldSpell.priority 
		end

		if _test(auraDB.filterPlayer, friendly) then
			if isPlayer then
				filtered = true
			else
				filtered = false
			end
			fromPlayer = filtered;
			pass = true 
		end 
		if _test(auraDB.filterDispellable, friendly) then 
			if (auraType == "buffs" and not isStealable) or (auraType == "debuffs" and debuffType and not MOD.Dispellable[debuffType]) or debuffType == nil then 
				filtered = false 
			end 
			pass = true 
		end 
		if _test(auraDB.filterRaid, friendly) then 
			if shouldConsolidate == 1 then filtered = false end 
			pass = true 
		end 
		if _test(auraDB.filterInfinite, friendly)then 
			if duration == 0 or not duration then 
				filtered = false 
			end 
			pass = true 
		end 
		if _test(auraDB.filterBlocked, friendly) then 
			local blackListSpell = SV.db.filter["Blocked"][name]
			if blackListSpell and blackListSpell.enable then 
				filtered = false 
			end 
			pass = true 
		end 
		if _test(auraDB.filterAllowed, friendly) then 
			local whiteListSpell = SV.db.filter["Allowed"][name]
			if whiteListSpell and whiteListSpell.enable then 
				filtered = true;
				icon.priority = whiteListSpell.priority 
			elseif not pass then 
				filtered = false 
			end 
			pass = true 
		end

		local active = auraDB.useFilter

		if active and active ~= "" and SV.db.filter[active] then
			local spellDB = SV.db.filter[active];
			if active ~= "Blocked" then 
				if spellDB[name] and spellDB[name].enable and fromPlayer then 
					filtered = true;
					icon.priority = spellDB[name].priority;
					if active == "Shield" and (spellID == 86698 or spellID == 86669) then 
						filtered = false 
					end 
				elseif not pass then 
					filtered = false 
				end 
			elseif spellDB[name] and spellDB[name].enable then 
				filtered = false 
			end
		end 
		return filtered 
	end

	CustomBarFilter = function(self, unit, name, _, _, _, debuffType, duration, _, caster, isStealable, shouldConsolidate, spellID)
		local db = SV.db.SVUnit[self.___key]
		if((not db) or (db and not db.aurabar) or (spellID == 65148)) then 
			return false;
		end
		local barDB = db.aurabar
		local isPlayer = caster == "player" or caster == "vehicle"
		local filtered = true
		local fromPlayer = true
		local pass = false;
		local friendly = UnitIsFriend("player", unit) == 1 and true or false;

		if _test(barDB.filterPlayer, friendly) then
			if isPlayer then
				filtered = true
			else
				filtered = false
			end
			fromPlayer = filtered;
			pass = true 
		end 
		if _test(barDB.filterDispellable, friendly) then 
			if (debuffType and not MOD.Dispellable[debuffType]) or debuffType == nil then 
				filtered = false 
			end 
			pass = true 
		end 
		if _test(barDB.filterRaid, friendly) then 
			if shouldConsolidate == 1 then filtered = false end 
			pass = true 
		end 
		if _test(barDB.filterInfinite, friendly) then 
			if duration == 0 or not duration then 
				filtered = false 
			end 
			pass = true 
		end 
		if _test(barDB.filterBlocked, friendly) then
			local blackList = SV.db.filter["Blocked"][name]
			if blackList and blackList.enable then filtered = false end 
			pass = true 
		end 
		if _test(barDB.filterAllowed, friendly) then 
			local whiteList = SV.db.filter["Allowed"][name]
			if whiteList and whiteList.enable then 
				filtered = true 
			elseif not pass then 
				filtered = false 
			end 
			pass = true 
		end
		local active = barDB.useFilter
		if active and active ~= "" and SV.db.filter[active] then
			local spellsDB = SV.db.filter[active];
			if active ~= "Blocked" then 
				if spellsDB[name] and spellsDB[name].enable and fromPlayer then 
					filtered = true 
				elseif not pass then 
					filtered = false
				end 
			elseif spellsDB[name] and spellsDB[name].enable then 
				filtered = false 
			end 
		end 
		return filtered 
	end
end
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreateBuffs(frame, unit)
	local aura = CreateFrame("Frame", nil, frame)
	aura.___key = unit
	aura.spacing = 2;
	aura.PostCreateIcon = PostCreateAuraIcon;
	aura.PostUpdateIcon = PostUpdateAuraIcon;
	aura.CustomFilter = CustomAuraFilter;
	aura:SetFrameLevel(10)
	aura.type = "buffs"
	aura.textFont = LSM:Fetch("font", SV.db.SVUnit.auraFont)
	aura.textSize = SV.db.SVUnit.auraFontSize
	aura.textOutline = SV.db.SVUnit.auraFontOutline
	return aura 
end 

function MOD:CreateDebuffs(frame, unit)
	local aura = CreateFrame("Frame", nil, frame)
	aura.___key = unit
	aura.spacing = 2;
	aura.PostCreateIcon = PostCreateAuraIcon;
	aura.PostUpdateIcon = PostUpdateAuraIcon;
	aura.CustomFilter = CustomAuraFilter;
	aura.type = "debuffs"
	aura:SetFrameLevel(10)
	aura.textFont = LSM:Fetch("font", SV.db.SVUnit.auraFont)
	aura.textSize = SV.db.SVUnit.auraFontSize
	aura.textOutline = SV.db.SVUnit.auraFontOutline
	return aura 
end 

function MOD:CreateAuraWatch(frame, unit)
	local aWatch = CreateFrame("Frame", nil, frame)
	aWatch:SetFrameLevel(frame:GetFrameLevel()  +  25)
	aWatch:SetAllPoints(frame)
	aWatch.presentAlpha = 1;
	aWatch.missingAlpha = 0;
	aWatch.strictMatching = true;
	aWatch.icons = {}
	return aWatch
end

function MOD:CreateAuraBarHeader(frame, unitName)
	local auraBarParent = CreateFrame("Frame", nil, frame)
	auraBarParent.parent = frame;
	auraBarParent.PostCreateBar = PostCreateAuraBars;
	auraBarParent.gap = 2;
	auraBarParent.spacing = 1;
	auraBarParent.spark = true;
	auraBarParent.filter = CustomBarFilter;
	auraBarParent.PostUpdate = ColorizeAuraBars;
	auraBarParent.barTexture = LSM:Fetch("statusbar", SV.db.SVUnit.auraBarStatusbar)
	auraBarParent.timeFont = LSM:Fetch("font", "Roboto")
	auraBarParent.textFont = LSM:Fetch("font", SV.db.SVUnit.auraFont)
	auraBarParent.textSize = SV.db.SVUnit.auraFontSize
	auraBarParent.textOutline = SV.db.SVUnit.auraFontOutline
	return auraBarParent 
end

function MOD:SmartAuraDisplay()
	local unit = self.unit;
	local db = SV.db.SVUnit[unit];
	if not db or not db.smartAuraDisplay or db.smartAuraDisplay == 'DISABLED' or not UnitExists(unit) then return end 
	local buffs = self.Buffs;
	local debuffs = self.Debuffs;
	local bars = self.AuraBars;
	local friendly = UnitIsFriend('player',unit) == 1 and true or false;
	
	if friendly then 
		if db.smartAuraDisplay == 'SHOW_DEBUFFS_ON_FRIENDLIES' then 
			buffs:Hide()
			debuffs:Show()
		else 
			buffs:Show()
			debuffs:Hide()
		end 
	else
		if db.smartAuraDisplay == 'SHOW_DEBUFFS_ON_FRIENDLIES' then 
			buffs:Show()
			debuffs:Hide()
		else 
			buffs:Hide()
			debuffs:Show()
		end 
	end 

	if buffs:IsShown() then
		buffs:ClearAllPoints()
		SV:ReversePoint(buffs, db.buffs.anchorPoint, self, db.buffs.xOffset, db.buffs.yOffset)
		if db.aurabar.attachTo ~= 'FRAME' then 
			bars:ClearAllPoints()
			bars:SetPoint('BOTTOMLEFT', buffs, 'TOPLEFT', 0, 1)
			bars:SetPoint('BOTTOMRIGHT', buffs, 'TOPRIGHT', 0, 1)
		end 
	end 

	if debuffs:IsShown() then
		debuffs:ClearAllPoints()
		SV:ReversePoint(debuffs, db.debuffs.anchorPoint, self, db.debuffs.xOffset, db.debuffs.yOffset)
		if db.aurabar.attachTo ~= 'FRAME' then 
			bars:ClearAllPoints()
			bars:SetPoint('BOTTOMLEFT', debuffs, 'TOPLEFT', 0, 1)
			bars:SetPoint('BOTTOMRIGHT', debuffs, 'TOPRIGHT', 0, 1)
		end 
	end 
end 
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD:UpdateAuraWatch(frame, key, override)
	local AW = frame.AuraWatch
	if not SV.db.SVUnit[key] then return end 
	local db = SV.db.SVUnit[key].auraWatch
	if not db then return end 

	if not db.enable then 
		AW:Hide()
		return 
	else
		AW:Show()
	end

	local WATCH_CACHE

	if key == "pet" and not override then 
		local petBW = SV.db.filter["PetBuffWatch"]
		if(petBW) then
			WATCH_CACHE = {}
			for _, buff in pairs(petBW)do 
				if(buff.style == "text") then 
					buff.style = "NONE"
				end 
				tinsert(WATCH_CACHE, buff)
			end
		end
	else 
		local unitBW = SV.db.filter["BuffWatch"]
		if(unitBW) then
			WATCH_CACHE = {}
			for _, buff in pairs(unitBW)do 
				if(buff.style == "text") then 
					buff.style = "NONE"
				end 
				tinsert(WATCH_CACHE, buff)
			end
		end
	end  

	if WATCH_CACHE then
		local fontFile = LSM:Fetch("font", SV.db.SVUnit.auraFont)
		local fontSize = SV.db.SVUnit.auraFontSize
		local fontOutline = SV.db.SVUnit.auraFontOutline
		
		if AW.icons then 
			for i = 1, #AW.icons do 
				local iconTest = false;
				for j = 1, #WATCH_CACHE do 
					if(#WATCH_CACHE[j].id and #WATCH_CACHE[j].id == AW.icons[i]) then 
						iconTest = true;
						break 
					end 
				end 
				if not iconTest then 
					AW.icons[i]:Hide()
					AW.icons[i] = nil 
				end 
			end 
		end

		for i = 1, #WATCH_CACHE do 
			if WATCH_CACHE[i].id then 
				local buffName, _, buffTexture = GetSpellInfo(WATCH_CACHE[i].id)
				if buffName then 
					local watchedAura;
					if not AW.icons[WATCH_CACHE[i].id]then 
						watchedAura = CreateFrame("Frame", nil, AW)
					else 
						watchedAura = AW.icons[WATCH_CACHE[i].id]
					end 
					watchedAura.name = buffName;
					watchedAura.image = buffTexture;
					watchedAura.spellID = WATCH_CACHE[i].id;
					watchedAura.anyUnit = WATCH_CACHE[i].anyUnit;
					watchedAura.style = WATCH_CACHE[i].style;
					watchedAura.onlyShowMissing = WATCH_CACHE[i].onlyShowMissing;
					watchedAura.presentAlpha = watchedAura.onlyShowMissing and 0 or 1;
					watchedAura.missingAlpha = watchedAura.onlyShowMissing and 1 or 0;
					watchedAura.textThreshold = WATCH_CACHE[i].textThreshold or -1;
					watchedAura.displayText = WATCH_CACHE[i].displayText;
					watchedAura:Width(db.size)
					watchedAura:Height(db.size)
					watchedAura:ClearAllPoints()

					watchedAura:SetPoint(WATCH_CACHE[i].point, frame.Health, WATCH_CACHE[i].point, WATCH_CACHE[i].xOffset, WATCH_CACHE[i].yOffset)
					if not watchedAura.icon then 
						watchedAura.icon = watchedAura:CreateTexture(nil, "BORDER")
						watchedAura.icon:SetAllPoints(watchedAura)
					end 
					if not watchedAura.text then 
						local awText = CreateFrame("Frame", nil, watchedAura)
						awText:SetFrameLevel(watchedAura:GetFrameLevel() + 50)
						watchedAura.text = awText:CreateFontString(nil, "BORDER")
					end 
					if not watchedAura.border then 
						watchedAura.border = watchedAura:CreateTexture(nil, "BACKGROUND")
						watchedAura.border:Point("TOPLEFT", -1, 1)
						watchedAura.border:Point("BOTTOMRIGHT", 1, -1)
						watchedAura.border:SetTexture([[Interface\BUTTONS\WHITE8X8]])
						watchedAura.border:SetVertexColor(0, 0, 0)
					end 
					if not watchedAura.cd then 
						watchedAura.cd = CreateFrame("Cooldown", nil, watchedAura)
						watchedAura.cd:SetAllPoints(watchedAura)
						watchedAura.cd:SetReverse(true)
						watchedAura.cd:SetFrameLevel(watchedAura:GetFrameLevel())
					end 
					if watchedAura.style == "coloredIcon"then 
						watchedAura.icon:SetTexture([[Interface\BUTTONS\WHITE8X8]])
						if WATCH_CACHE[i]["color"]then 
							watchedAura.icon:SetVertexColor(WATCH_CACHE[i]["color"].r, WATCH_CACHE[i]["color"].g, WATCH_CACHE[i]["color"].b)
						else 
							watchedAura.icon:SetVertexColor(0.8, 0.8, 0.8)
						end 
						watchedAura.icon:Show()
						watchedAura.border:Show()
						watchedAura.cd:SetAlpha(1)
					elseif watchedAura.style == "texturedIcon" then 
						watchedAura.icon:SetVertexColor(1, 1, 1)
						watchedAura.icon:SetTexCoord(.18, .82, .18, .82)
						watchedAura.icon:SetTexture(watchedAura.image)
						watchedAura.icon:Show()
						watchedAura.border:Show()
						watchedAura.cd:SetAlpha(1)
					else 
						watchedAura.border:Hide()
						watchedAura.icon:Hide()
						watchedAura.cd:SetAlpha(0)
					end 
					if watchedAura.displayText then 
						watchedAura.text:Show()
						local r, g, b = 1, 1, 1;
						if WATCH_CACHE[i].textColor then 
							r, g, b = WATCH_CACHE[i].textColor.r, WATCH_CACHE[i].textColor.g, WATCH_CACHE[i].textColor.b 
						end 
						watchedAura.text:SetTextColor(r, g, b)
					else 
						watchedAura.text:Hide()
					end 
					if not watchedAura.count then 
						watchedAura.count = watchedAura:CreateFontString(nil, "OVERLAY")
					end 
					watchedAura.count:ClearAllPoints()
					if watchedAura.displayText then 
						local anchor, relative, x, y = unpack(textCounterOffsets[WATCH_CACHE[i].point])
						watchedAura.count:SetPoint(anchor, watchedAura.text, relative, x, y)
					else 
						watchedAura.count:SetPoint("CENTER", unpack(counterOffsets[WATCH_CACHE[i].point]))
					end

					watchedAura.count:SetFont(fontFile, fontSize, fontOutline)
					watchedAura.text:SetFont(fontFile, fontSize, fontOutline)
					watchedAura.text:ClearAllPoints()
					watchedAura.text:SetPoint(WATCH_CACHE[i].point, watchedAura, WATCH_CACHE[i].point)
					if WATCH_CACHE[i].enabled then 
						AW.icons[WATCH_CACHE[i].id] = watchedAura;
						if AW.watched then 
							AW.watched[WATCH_CACHE[i].id] = watchedAura 
						end 
					else
						AW.icons[WATCH_CACHE[i].id] = nil;
						if AW.watched then 
							AW.watched[WATCH_CACHE[i].id] = nil 
						end 
						watchedAura:Hide()
						watchedAura = nil 
					end 
				end 
			end 
		end
		
		WATCH_CACHE = nil
	end
	if frame.AuraWatch.Update then 
		frame.AuraWatch.Update(frame)
	end 
end

function MOD:UpdateGroupAuraWatch(header, override)
	assert(self.Headers[header], "Invalid group specified.")
	local group = self.Headers[header]
	for i = 1, group:GetNumChildren() do 
		local frame = select(i, group:GetChildren())
		if frame and frame.Health then self:UpdateAuraWatch(frame, header, override) end 
	end 
end  