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
local tremove, tsort = table.remove, table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose("SVUnit");
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH"s FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
local LSM = LibStub("LibSharedMedia-3.0");

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
local function SetAuraTemplate(aura)
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
    aura:RegisterForClicks("RightButtonUp")
	aura:SetScript("OnClick", function(self)
		if not IsShiftKeyDown()then return end 
		local name = self.name;
		if name then 
			SuperVillain:AddonMessage(format(L['The spell "%s" has been added to the Blocked unitframe aura filter.'], name))
			SuperVillain.Filters["Blocked"]["spells"][name] = {["enable"] = true, ["priority"] = 0}
			MOD:RefreshUnitFrames()
		end 
	end)
	aura.styled = true
end 
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreateBuffs(frame)
	local aura = CreateFrame("Frame", nil, frame)
	aura.spacing = 2;
	aura.PostCreateIcon = self.CreateAuraIcon;
	aura.PostUpdateIcon = self.PostUpdateAura;
	aura.CustomFilter = self.AuraFilter;
	aura:SetFrameLevel(10)
	aura.type = "buffs"
	self:WatchUnitMedia("aurafonts", aura)
	return aura 
end 

function MOD:CreateDebuffs(frame)
	local aura = CreateFrame("Frame", nil, frame)
	aura.spacing = 2;
	aura.PostCreateIcon = self.CreateAuraIcon;
	aura.PostUpdateIcon = self.PostUpdateAura;
	aura.CustomFilter = self.AuraFilter;
	aura.type = "debuffs"
	aura:SetFrameLevel(10)
	self:WatchUnitMedia("aurafonts", aura)
	return aura 
end 

function MOD:CreateAuraWatch(frame)
	local aWatch = CreateFrame("Frame", nil, frame)
	aWatch:SetFrameLevel(frame:GetFrameLevel()  +  25)
	aWatch:FillInner(frame.Health)
	aWatch.presentAlpha = 1;
	aWatch.missingAlpha = 0;
	aWatch.strictMatching = true;
	aWatch.icons = {}
	return aWatch
end 

function MOD:UpdateAuraTimer(elapsed)
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
		self.text:SetFont(AURA_FONT, AURA_FONTSIZE, AURA_OUTLINE)
		self.text:SetFormattedText(timeFormat, timeLeft)
	end 
end 

function MOD:CreateAuraIcon(aura, index, offset)
	aura.cd.noOCC = true;
	aura.cd.noCooldownCount = true;
	aura.cd:SetReverse()
	aura.cd:FillInner(aura, 0, 0)

	aura.text = aura.cd:CreateFontString(nil, "OVERLAY")
	aura.text:SetFont(AURA_FONT, AURA_FONTSIZE, AURA_OUTLINE)
	aura.text:SetPoint("CENTER", 1, 1)
	aura.text:SetJustifyH("CENTER")
	
	aura.icon:FillInner(aura, 2, 2)
	aura.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	aura.icon:SetDrawLayer("ARTWORK")
	
	aura.count:ClearAllPoints()
	aura.count:SetFont(AURA_FONT, AURA_FONTSIZE, AURA_OUTLINE)
	aura.count:SetPoint("BOTTOMRIGHT", 1, 1)
	aura.count:SetJustifyH("RIGHT")
	
	aura.overlay:SetTexture(nil)
	
	aura.stealable:SetTexture(nil)

	SetAuraTemplate(aura)
end 

function MOD:PostUpdateAura(unit, button, index, offset, filter, isDebuff, duration, timeLeft)
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
			button:SetScript('OnUpdate', MOD.UpdateAuraTimer)
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

function MOD:UpdateAuraWatchFromHeader(group, override)
	assert(self[group],"Invalid group specified.")
	for i=1,self[group]:GetNumChildren() do 
		local frame = select(i, self[group]:GetChildren())
		if frame and frame.Health then MOD:UpdateAuraWatch(frame,override) end 
	end 
end 

local function CheckAuraFilter(setting,helpful)
	local friend, enemy = false, false
	if type(setting)=='boolean' then 
		friend = setting;
	  	enemy = setting
	elseif setting and type(setting)~='string' then 
		friend = setting.friendly;
	  	enemy = setting.enemy
	end 
	if (friend and helpful) or (enemy and not helpful) then 
	  return true;
	end
  	return false 
end 

function MOD:AuraFilter(unit, icon, name, _, _, _, dtype, duration, _, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossAura)
	if spellID == 65148 then return false end 
	local isPlayer,friendly;
	local db = self:GetParent().db;
	local auraType = self.type;
	if not db or not auraType or not db[auraType] then return true end 
	db = db[auraType]
	local filtered=true;
	local allowed=true;
	local pass=false;
	local isPlayer=caster=='player'or caster=='vehicle'
	local friendly=UnitIsFriend('player',unit)==1 and true or false;
	local filterType=friendly and db.friendlyAuraType or db.enemyAuraType;
	icon.isPlayer=isPlayer;
	icon.owner=caster;
	icon.name=name;
	icon.priority=0;
	local shieldSpell = SuperVillain.Filters['Shield'][name]
	if shieldSpell and shieldSpell.enable then 
		icon.priority=shieldSpell.priority 
	end 
	if CheckAuraFilter(db.filterPlayer,friendly)then 
		if isPlayer then filtered=true else filtered=false end 
		allowed=filtered;
		pass=true 
	end 
	if CheckAuraFilter(db.filterDispellable,friendly) then 
		if (auraType=='buffs' and not isStealable) or (auraType=='debuffs' and dtype and not SuperVillain:DispellAvailable(dtype)) or dtype==nil then 
			filtered=false 
		end 
		pass=true 
	end 
	if CheckAuraFilter(db.filterRaid,friendly) then 
		if shouldConsolidate==1 then filtered=false end 
		pass=true 
	end 
	if CheckAuraFilter(db.filterInfinite,friendly)then 
		if duration==0 or not duration then 
			filtered=false 
		end 
		pass=true 
	end 
	if CheckAuraFilter(db.useBlocked,friendly) then 
		local blackListSpell=SuperVillain.Filters['Blocked'][name]
		if blackListSpell and blackListSpell.enable then 
			filtered=false 
		end 
		pass=true 
	end 
	if CheckAuraFilter(db.useAllowed,friendly) then 
		local whiteListSpell=SuperVillain.Filters['Allowed'][name]
		if whiteListSpell and whiteListSpell.enable then 
			filtered=true;
			icon.priority=whiteListSpell.priority 
		elseif not pass then 
			filtered=false 
		end 
		pass=true 
	end 

	if db.useFilter and SuperVillain.Filters[db.useFilter] then
		local spellDB=SuperVillain.Filters[db.useFilter];
		if db.useFilter ~= 'Blocked' then 
			if spellDB[name] and spellDB[name].enable and allowed then 
				filtered=true;
				icon.priority=spellDB[name].priority;
				if db.useFilter == 'Shield' and (spellID==86698 or spellID==86669) then 
					filtered=false 
				end 
			elseif not pass then 
				filtered=false 
			end 
		elseif spellDB[name] and spellDB[name].enable then 
			filtered=false 
		end 
	end 
	return filtered 
end 
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD:UpdateAuraUpvalues()
	AURA_FONT = LSM:Fetch("font",MOD.db.auraFont);
	AURA_FONTSIZE = MOD.db.auraFontSize;
	AURA_OUTLINE = MOD.db.auraFontOutline;
end

function MOD:UpdateAuraIconSettings(aura, useParent)
	if(useParent) then 
		aura.text:SetFont(AURA_FONT, AURA_FONTSIZE, AURA_OUTLINE)
		aura.count:SetFont(AURA_FONT, AURA_FONTSIZE, AURA_OUTLINE)
		-- if aura:IsMouseEnabled() then 
		-- 	aura:EnableMouse(false)
		-- end 
	else
		local i = 1; 
		while aura[i] do 
			local icon = aura[i]
			icon.text:SetFont(AURA_FONT, AURA_FONTSIZE, AURA_OUTLINE)
			icon.count:SetFont(AURA_FONT, AURA_FONTSIZE, AURA_OUTLINE)
			-- if icon:IsMouseEnabled() then 
			-- 	icon:EnableMouse(false)
			-- end 
			i = i + 1 
		end 
	end 
end 

function MOD:UpdateAuraWatch(frame,override)
	local temp = {}
	local AW = frame.AuraWatch;
	local db = frame.db.buffIndicator;
	if not db then return end 
	if not db.enable then 
		AW:Hide()
		return 
	else 
		AW:Show()
	end 
	local bwSize = db.size;

	if frame.unit=='pet' and not override then 
		local petBW = SuperVillain.Filters["PetBuffWatch"] or {}
		for _,buff in pairs(petBW)do 
			if buff.style=='text'then 
				buff.style='NONE'
			end 
			tinsert(temp,buff)
		end 
	else 
		local unitBW = SuperVillain.Filters["BuffWatch"] or {}
		for _,buff in pairs(unitBW)do 
			if buff.style=='text'then 
				buff.style='NONE'
			end 
			tinsert(temp,buff)
		end 
	end 

	if AW.icons then 
		for i=1,#AW.icons do 
			local iconTest=false;
			for j=1,#temp do 
				if #temp[j].id and #temp[j].id==AW.icons[i] then 
					iconTest=true;
					break 
				end 
			end 
			if not iconTest then 
				AW.icons[i]:Hide()
				AW.icons[i]=nil 
			end 
		end 
	end 

	for i=1,#temp do 
		if temp[i].id then 
			local buffName,_,buffTexture = GetSpellInfo(temp[i].id)
			if buffName then 
				local watchedAura;
				if not AW.icons[temp[i].id]then 
					watchedAura=CreateFrame("Frame",nil,AW)
				else 
					watchedAura=AW.icons[temp[i].id]
				end 
				watchedAura.name = buffName;
				watchedAura.image = buffTexture;
				watchedAura.spellID = temp[i].id;
				watchedAura.anyUnit = temp[i].anyUnit;
				watchedAura.style = temp[i].style;
				watchedAura.onlyShowMissing = temp[i].onlyShowMissing;
				watchedAura.presentAlpha = watchedAura.onlyShowMissing and 0 or 1;
				watchedAura.missingAlpha = watchedAura.onlyShowMissing and 1 or 0;
				watchedAura.textThreshold = temp[i].textThreshold or -1;
				watchedAura.displayText = temp[i].displayText;
				watchedAura:Width(bwSize)
				watchedAura:Height(bwSize)
				watchedAura:ClearAllPoints()
				watchedAura:SetPoint(temp[i].point, frame.Health, temp[i].point, temp[i].xOffset, temp[i].yOffset)
				if not watchedAura.icon then 
					watchedAura.icon = watchedAura:CreateTexture(nil,"BORDER")
					watchedAura.icon:SetAllPoints(watchedAura)
				end 
				if not watchedAura.text then 
					local awText = CreateFrame('Frame',nil,watchedAura)
					awText:SetFrameLevel(watchedAura:GetFrameLevel()+50)
					watchedAura.text = awText:CreateFontString(nil,'BORDER')
				end 
				if not watchedAura.border then 
					watchedAura.border = watchedAura:CreateTexture(nil,"BACKGROUND")
					watchedAura.border:Point("TOPLEFT",-1,1)
					watchedAura.border:Point("BOTTOMRIGHT",1,-1)
					watchedAura.border:SetTexture([[Interface\BUTTONS\WHITE8X8]])
					watchedAura.border:SetVertexColor(0,0,0)
				end 
				if not watchedAura.cd then 
					watchedAura.cd = CreateFrame("Cooldown",nil,watchedAura)
					watchedAura.cd:SetAllPoints(watchedAura)
					watchedAura.cd:SetReverse(true)
					watchedAura.cd:SetFrameLevel(watchedAura:GetFrameLevel())
				end 
				if watchedAura.style=='coloredIcon'then 
					watchedAura.icon:SetTexture([[Interface\BUTTONS\WHITE8X8]])
					if temp[i]["color"]then 
						watchedAura.icon:SetVertexColor(temp[i]["color"].r, temp[i]["color"].g, temp[i]["color"].b)
					else 
						watchedAura.icon:SetVertexColor(0.8,0.8,0.8)
					end 
					watchedAura.icon:Show()
					watchedAura.border:Show()
					watchedAura.cd:SetAlpha(1)
				elseif watchedAura.style=='texturedIcon' then 
					watchedAura.icon:SetVertexColor(1,1,1)
					watchedAura.icon:SetTexCoord(.18,.82,.18,.82)
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
					local r,g,b=1,1,1;
					if temp[i].textColor then 
						r,g,b = temp[i].textColor.r, temp[i].textColor.g, temp[i].textColor.b 
					end 
					watchedAura.text:SetTextColor(r,g,b)
				else 
					watchedAura.text:Hide()
				end 
				if not watchedAura.count then 
					watchedAura.count=watchedAura:CreateFontString(nil,"OVERLAY")
				end 
				watchedAura.count:ClearAllPoints()
				if watchedAura.displayText then 
					local anchor,relative,x,y=unpack(textCounterOffsets[temp[i].point])
					watchedAura.count:SetPoint(anchor, watchedAura.text, relative, x, y)
				else 
					watchedAura.count:SetPoint("CENTER",unpack(counterOffsets[temp[i].point]))
				end 
				watchedAura.count:SetFont(AURA_FONT, AURA_FONTSIZE, AURA_OUTLINE)
				watchedAura.text:SetFont(AURA_FONT, AURA_FONTSIZE, AURA_OUTLINE)
				watchedAura.text:ClearAllPoints()
				watchedAura.text:SetPoint(temp[i].point,watchedAura,temp[i].point)
				if temp[i].enable then 
					AW.icons[temp[i].id]=watchedAura;
					if AW.watched then 
						AW.watched[temp[i].id]=watchedAura 
					end 
				else 
					AW.icons[temp[i].id]=nil;
					if AW.watched then 
						AW.watched[temp[i].id]=nil 
					end 
					watchedAura:Hide()
					watchedAura=nil 
				end 
			end 
		end 
	end 
	if frame.AuraWatch.Update then 
		frame.AuraWatch.Update(frame)
	end 
	temp=nil 
end 
--[[ 
########################################################## 
UTILITY
##########################################################
]]--
function MOD:SmartAuraDisplay()
	local db = self.db;
	local unit = self.unit;
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