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
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ TABLE METHODS ]]--
local tremove, tsort, twipe = table.remove, table.sort, table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose("SVUnit")
if(not MOD) then return end;
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH"s FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");

local CustomAuraFilter;
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
		SuperVillain:AddonMessage(format(L["The spell '%s' has been added to the Blocked unitframe aura filter."], name))
		SuperVillain.Filters["Blocked"][name] = {["enable"] = true, ["priority"] = 0};
		MOD:RefreshUnitFrames()
	end
end

local PostCreateAuraIcon = function(self, aura)
	aura.cd.noOCC = true;
	aura.cd.noCooldownCount = true;
	aura.cd:SetReverse()
	aura.overlay:SetTexture(nil)
	aura.stealable:SetTexture(nil)
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

local UpdateAuraTimer = function(self, elapsed)
	self.expiration = self.expiration - elapsed;
	if(self.nextUpdate > 0) then 
		self.nextUpdate = self.nextUpdate - elapsed;
		return 
	end 
	if(self.expiration  <= 0) then 
		self:SetScript("OnUpdate", nil)
		if(self.text:GetFont()) then
			self.text:SetText("")
		end
		return 
	end 

	local expires = self.expiration;
	local calc, timeLeft = 0, 0;
	local timeFormat;

	if expires < 60 then 
		if expires  >= 4 then
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
		if(not isFriend and button.owner ~= "player" and button.owner ~= "vehicle") then
			button:SetBackdropBorderColor(0.9, 0.1, 0.1)
			button.icon:SetDesaturated((unit and not unit:find('arena%d')) and true or false)
		else
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			if (name == "Unstable Affliction" or name == "Vampiric Touch") and SuperVillain.class ~= "WARLOCK" then
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
		if not button:GetScript('OnUpdate') then
			button.expirationTime = expiration
			button.expiration = expiration - GetTime()
			button.nextUpdate = -1
			button:SetScript('OnUpdate', UpdateAuraTimer)
		end
		if button.expirationTime ~= expiration  then
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
		local db = MOD.db[self.db]
		local auraType = self.type;
		if(not auraType) then return true end;
		if((not db) or (db and not db[auraType]) or (spellID == 65148)) then 
			return false;
		end
		local auraDB = db[auraType]
		local filtered = (caster == "player" or caster == "vehicle") and true or false;
		local allowed = true;
		local pass = false;
		local friendly = UnitIsFriend("player", unit) == 1 and true or false;

		icon.isPlayer = filtered;
		icon.owner = caster;
		icon.name = name;
		icon.priority = 0;

		local shieldSpell = SuperVillain.Filters["Shield"][name]
		if shieldSpell and shieldSpell.enable then 
			icon.priority = shieldSpell.priority 
		end

		if _test(auraDB.filterPlayer, friendly) then
			allowed = filtered;
			pass = true 
		end 
		if _test(auraDB.filterDispellable, friendly) then 
			if (auraType == "buffs" and not isStealable) or (auraType == "debuffs" and debuffType and not SuperVillain.Dispellable[debuffType]) or debuffType == nil then 
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
		if _test(auraDB.useBlocked, friendly) then 
			local blackListSpell = SuperVillain.Filters["Blocked"][name]
			if blackListSpell and blackListSpell.enable then 
				filtered = false 
			end 
			pass = true 
		end 
		if _test(auraDB.useAllowed, friendly) then 
			local whiteListSpell = SuperVillain.Filters["Allowed"][name]
			if whiteListSpell and whiteListSpell.enable then 
				filtered = true;
				icon.priority = whiteListSpell.priority 
			elseif not pass then 
				filtered = false 
			end 
			pass = true 
		end 
		local active = auraDB.useFilter
		if active and active ~= "" and SuperVillain.Filters[active] then
			local spellDB = SuperVillain.Filters[active];
			if active ~= "Blocked" then 
				if spellDB[name] and spellDB[name].enable and allowed then 
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
end
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreateBuffs(frame, unit)
	local aura = CreateFrame("Frame", nil, frame)
	aura.db = unit
	aura.spacing = 2;
	aura.PostCreateIcon = PostCreateAuraIcon;
	aura.PostUpdateIcon = PostUpdateAuraIcon;
	aura.CustomFilter = CustomAuraFilter;
	aura:SetFrameLevel(10)
	aura.type = "buffs"
	aura.textFont = SuperVillain.Shared:Fetch("font", MOD.db.auraFont)
	aura.textSize = MOD.db.auraFontSize
	aura.textOutline = MOD.db.auraFontOutline
	return aura 
end 

function MOD:CreateDebuffs(frame, unit)
	local aura = CreateFrame("Frame", nil, frame)
	aura.db = unit
	aura.spacing = 2;
	aura.PostCreateIcon = PostCreateAuraIcon;
	aura.PostUpdateIcon = PostUpdateAuraIcon;
	aura.CustomFilter = CustomAuraFilter;
	aura.type = "debuffs"
	aura:SetFrameLevel(10)
	aura.textFont = SuperVillain.Shared:Fetch("font", MOD.db.auraFont)
	aura.textSize = MOD.db.auraFontSize
	aura.textOutline = MOD.db.auraFontOutline
	return aura 
end 

function MOD:CreateAuraWatch(frame, unit)
	local aWatch = CreateFrame("Frame", nil, frame)
	aWatch.db = unit
	aWatch:SetFrameLevel(frame:GetFrameLevel()  +  25)
	aWatch:FillInner(frame.Health)
	aWatch.presentAlpha = 1;
	aWatch.missingAlpha = 0;
	aWatch.strictMatching = true;
	aWatch.icons = {}
	return aWatch
end  

function MOD:SmartAuraDisplay()
	local unit = self.unit;
	local db = MOD.db[unit];
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
		SuperVillain:ReversePoint(buffs, db.buffs.anchorPoint, self, db.buffs.xOffset, db.buffs.yOffset)
		if db.aurabar.attachTo ~= 'FRAME' then 
			bars:ClearAllPoints()
			bars:SetPoint('BOTTOMLEFT', buffs, 'TOPLEFT', 0, 1)
			bars:SetPoint('BOTTOMRIGHT', buffs, 'TOPRIGHT', 0, 1)
		end 
	end 

	if debuffs:IsShown() then
		debuffs:ClearAllPoints()
		SuperVillain:ReversePoint(debuffs, db.debuffs.anchorPoint, self, db.debuffs.xOffset, db.debuffs.yOffset)
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
local WATCH_CACHE = {}
function MOD:UpdateAuraWatch(frame, key, override)
	twipe(WATCH_CACHE)
	local AW = frame.AuraWatch

	if not MOD.db[key] then return end 
	local db = MOD.db[key].buffIndicator
	if not db then return end 

	if not db.enable then 
		AW:Hide()
		return 
	else 
		AW:Show()
	end

	local bwSize = db.size;

	if key == "pet" and not override then 
		local petBW = SuperVillain.Filters["PetBuffWatch"]
		if(petBW) then
			for _, buff in pairs(petBW)do 
				if buff.style == "text" then 
					buff.style = "NONE"
				end 
				tinsert(WATCH_CACHE, buff)
			end
		end
	else 
		local unitBW = SuperVillain.Filters["BuffWatch"]
		if(unitBW) then
			for _, buff in pairs(unitBW)do 
				if buff.style == "text" then 
					buff.style = "NONE"
				end 
				tinsert(WATCH_CACHE, buff)
			end
		end
	end 

	if AW.icons then 
		for i = 1, #AW.icons do 
			local iconTest = false;
			for j = 1, #WATCH_CACHE do 
				if #WATCH_CACHE[j].id and #WATCH_CACHE[j].id == AW.icons[i] then 
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

	local fontFile = SuperVillain.Shared:Fetch("font", MOD.db.auraFont)
	local fontSize = MOD.db.auraFontSize
	local fontOutline = MOD.db.auraFontOutline

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
				watchedAura:Width(bwSize)
				watchedAura:Height(bwSize)
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
				if WATCH_CACHE[i].enable then 
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
	if frame.AuraWatch.Update then 
		frame.AuraWatch.Update(frame)
	end 
	twipe(WATCH_CACHE) 
end

function MOD:UpdateGroupAuraWatch(header, override)
	assert(self.Headers[header], "Invalid group specified.")
	local group = self.Headers[header]
	for i = 1, group:GetNumChildren() do 
		local frame = select(i, group:GetChildren())
		if frame and frame.Health then MOD:UpdateAuraWatch(frame, header, override) end 
	end 
end 