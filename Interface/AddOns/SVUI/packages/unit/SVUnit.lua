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
local _G 		= _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local tostring 	= _G.tostring;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local find, format, upper = string.find, string.format, string.upper;
local match, gsub = string.match, string.gsub;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
local MOD = {}
local LSM = LibStub("LibSharedMedia-3.0")
local NewHook = hooksecurefunc;
--[[ 
########################################################## 
MODULE DATA
##########################################################
]]--
local LoadedBasicFrames, LoadedGroupFrames, LoadedExtraFrames;
local BasicFrames, GroupFrames, ExtraFrames = {},{},{}
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local dummy = CreateFrame("Frame")
dummy:Hide()
local KillBlizzardUnit = function(unit)
	local frame;
	if type(unit)=='string' then frame=_G[unit] else frame=unit end
	if frame then 
		frame:UnregisterAllEvents()
		frame:Hide()
		frame:SetParent(dummy)
		local h = frame.healthbar;
		if h then h:UnregisterAllEvents()end
		local m = frame.manabar;
		if m then m:UnregisterAllEvents()end
		local s = frame.spellbar;
		if s then s:UnregisterAllEvents()end
		local p = frame.powerBarAlt;
		if p then p:UnregisterAllEvents()end 
	end 
end
--[[ 
########################################################## 
INNER CLASSES
##########################################################
]]--
MOD.Construct = {}
MOD.FrameUpdate = {}
MOD.HeaderUpdate = {}
MOD.VisibilityUpdate = {}
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:DetachSubFrames(...)
	for i = 1, select("#", ...) do 
		local frame = select(i,...)
		frame:ClearAllPoints()
	end 
end

function MOD:AllowElement(unitFrame)
	if InCombatLockdown() then return; end
	if not unitFrame.isForced then 
		unitFrame.sourceElement = unitFrame.unit;
		unitFrame.unit = "player"
		unitFrame.isForced = true;
		unitFrame.sourceEvent = unitFrame:GetScript("OnUpdate")
	end

	unitFrame:SetScript("OnUpdate", nil)
	unitFrame.forceShowAuras = true;
	UnregisterUnitWatch(unitFrame)
	RegisterUnitWatch(unitFrame, true)

	unitFrame:Show()
	if unitFrame:IsVisible() and unitFrame.Update then 
		unitFrame:Update()
	end 
end

function MOD:RestrictElement(unitFrame)
	if(InCombatLockdown() or (not unitFrame.isForced)) then return; end

	unitFrame.forceShowAuras = nil
	unitFrame.isForced = nil

	UnregisterUnitWatch(unitFrame)
	RegisterUnitWatch(unitFrame)

	if unitFrame.sourceEvent then 
		unitFrame:SetScript("OnUpdate", unitFrame.sourceEvent)
		unitFrame.sourceEvent = nil 
	end

	unitFrame.unit = unitFrame.sourceElement or unitFrame.unit;

	if unitFrame:IsVisible() and unitFrame.Update then 
		unitFrame:Update()
	end 
end

function MOD:RestrictChildren(parentFrame, ...)
	parentFrame.isForced = nil;

	for i=1,select("#",...) do 
		local childFrame = select(i,...)
		childFrame:RegisterForClicks(self.db.fastClickTarget and 'AnyDown' or 'AnyUp')
		childFrame.TargetGlow:SetAlpha(1)
		self:RestrictElement(childFrame)
	end 
end

function MOD:AllowChildren(parentFrame, ...)
	parentFrame.isForced = true;
	
	for i=1, select("#", ...) do
		local childFrame = select(i, ...)
		childFrame:RegisterForClicks(nil)
		childFrame:SetID(i)
		childFrame.TargetGlow:SetAlpha(0)
		self:AllowElement(childFrame)
	end  
end

function MOD:ResetUnitOptions(unit)
	SuperVillain.db:SetDefault("SVUnit", unit)
	self:RefreshUnitFrames()
end

function MOD:RefreshUnitFrames()
	if SuperVillain.db['SVUnit'].enable~=true then return end
	self:UpdateAuraUpvalues()
	self:RefreshUnitColors()
	self:RefreshUnitFonts()
	self:RefreshUnitTextures()

	for unit in pairs(BasicFrames)do 
		if self.db[unit].enable then 
			self[unit]:Enable()
			self[unit]:Update()
		else 
			self[unit]:Disable()
		end 
	end

	for unit,group in pairs(ExtraFrames)do 
		if self.db[group].enable then 
			self[unit]:Enable()
			self[unit]:Update()
		else 
			self[unit]:Disable()
		end 
	end

	local _,groupType = IsInInstance()
	local raidDebuffs = ns.oUF_RaidDebuffs or oUF_RaidDebuffs;
	if raidDebuffs then
		raidDebuffs:ResetDebuffData()
		if groupType == "party" or groupType == "raid" then
		  raidDebuffs:RegisterDebuffs(SuperVillain.Filters["Raid"])
		else
		  raidDebuffs:RegisterDebuffs(SuperVillain.Filters["CC"])
		end 
	end

	for _,group in pairs(GroupFrames) do
		group:Update()
		if group.SetConfigEnvironment then 
		  group:SetConfigEnvironment()
		end 
	end

	if SuperVillain.db.SVUnit.disableBlizzard then 
		oUF_SuperVillain:DisableBlizzard('party')
	end

	-- self:SetFadeManager()
end

do
	local SecureHeaderUpdate = function(self)
		local unit = self.NameKey;
		local db = MOD.db[unit]
		MOD.HeaderUpdate[unit](MOD, self, db)

		local index = 1;
		local childFrame = self:GetAttribute("child"..index)
		while childFrame do 
			MOD.FrameUpdate[unit](MOD, childFrame, db)
			if _G[childFrame:GetName().."Pet"] then 
				MOD.FrameUpdate[unit](MOD, _G[childFrame:GetName().."Pet"], db)
			end

			if _G[childFrame:GetName().."Target"] then 
				MOD.FrameUpdate[unit](MOD, _G[childFrame:GetName().."Target"], db)
			end

			index = index + 1;
			childFrame = self:GetAttribute("child"..index)
		end 
	end
		
	local SecureHeaderClear = function(self)
		self:Hide()
		self:SetAttribute("showPlayer", true)
		self:SetAttribute("showSolo", true)
		self:SetAttribute("showParty", true)
		self:SetAttribute("showRaid", true)
		self:SetAttribute("columnSpacing", nil)
		self:SetAttribute("columnAnchorPoint", nil)
		self:SetAttribute("sortMethod", nil)
		self:SetAttribute("groupFilter", nil)
		self:SetAttribute("groupingOrder", nil)
		self:SetAttribute("maxColumns", nil)
		self:SetAttribute("nameList", nil)
		self:SetAttribute("point", nil)
		self:SetAttribute("sortDir", nil)
		self:SetAttribute("sortMethod", "NAME")
		self:SetAttribute("startingIndex", nil)
		self:SetAttribute("strictFiltering", nil)
		self:SetAttribute("unitsPerColumn", nil)
		self:SetAttribute("xOffset", nil)
		self:SetAttribute("yOffset", nil)
	end

	function MOD:SpawnGroupHeader(parentFrame, filter, realName, template1, secureName, template2)
		local name = parentFrame.NameKey or secureName;
		local db = MOD.db[name]
		local frameName = name:gsub("(.)", upper, 1)
		oUF_SuperVillain:SetActiveStyle("SVUI_" .. frameName)
		local header = oUF_SuperVillain:SpawnHeader(realName, template2, nil, 
			"oUF-initialConfigFunction", ("self:SetWidth(%d); self:SetHeight(%d); self:SetFrameLevel(5)"):format(db.width, db.height), 
			"groupFilter", filter, 
			"showParty", true, 
			"showRaid", true, 
			"showSolo", true, 
			template1 and "template", template1
		);
		header.NameKey = name;
		header:SetParent(parentFrame)
		header:Show()
		header.Update = SecureHeaderUpdate 
		header.ClearAllAttributes = SecureHeaderClear 
		return header 
	end
end

function MOD:SetBasicFrame(unit)
	assert(unit, "No unit provided to create or update.")
	if InCombatLockdown()then self:FrameForge() return end
	local realName = unit:gsub("(.)", upper, 1);
	realName = realName:gsub("t(arget)", "T%1");
	if not self[unit] then 
		self[unit] = oUF_SuperVillain:Spawn(unit, "SVUI_"..realName)
		BasicFrames[unit] = unit 
	end
	self[unit].Update = function()
		self.FrameUpdate[unit](MOD, unit, MOD[unit], MOD.db[unit]) 
	end
	if self[unit]:GetParent() ~= SVUI_UnitFrameParent then 
		self[unit]:SetParent(SVUI_UnitFrameParent)
	end
	if self.db[unit].enable then 
		self[unit]:Enable()
		self[unit].Update()
	else 
		self[unit]:Disable()
	end
end

function MOD:SetExtraFrame(name, count)
	if InCombatLockdown() then self:FrameForge() return end

	for i = 1, count do 
		local unit = name..i;
		local realName = unit:gsub("(.)", upper, 1)
		realName = realName:gsub("t(arget)", "T%1")
		if not self[unit]then 
			ExtraFrames[unit] = name;
			self[unit] = oUF_SuperVillain:Spawn(unit, "SVUI_"..realName)
			self[unit].index = i;
			self[unit]:SetParent(SVUI_UnitFrameParent)
			self[unit]:SetID(i)
		end

		local secureName = name:gsub("(.)", upper, 1)
		secureName = secureName:gsub("t(arget)", "T%1")
		self[unit].Update = function()
			self.FrameUpdate[name](MOD, unit, MOD[unit], MOD.db[name])
		end

		if self.db[name].enable then 
			self[unit]:Enable()
			self[unit].Update()

			if self[unit].isForced then 
				self:AllowElement(self[unit])
			end 
		else 
			self[unit]:Disable()
		end 
	end 
end

do
	local _POINTMAP = {
		["DOWN_RIGHT"] = {[1]="TOP",[2]="TOPLEFT",[3]="LEFT",[4]="RIGHT",[5]="LEFT",[6]=1,[7]=-1,[8]=false},
		["DOWN_LEFT"] = {[1]="TOP",[2]="TOPRIGHT",[3]="RIGHT",[4]="LEFT",[5]="RIGHT",[6]=1,[7]=-1,[8]=false},
		["UP_RIGHT"] = {[1]="BOTTOM",[2]="BOTTOMLEFT",[3]="LEFT",[4]="RIGHT",[5]="LEFT",[6]=1,[7]=1,[8]=false},
		["UP_LEFT"] = {[1]="BOTTOM",[2]="BOTTOMRIGHT",[3]="RIGHT",[4]="LEFT",[5]="RIGHT",[6]=-1,[7]=1,[8]=false},
		["RIGHT_DOWN"] = {[1]="LEFT",[2]="TOPLEFT",[3]="TOP",[4]="BOTTOM",[5]="TOP",[6]=1,[7]=-1,[8]=true},
		["RIGHT_UP"] = {[1]="LEFT",[2]="BOTTOMLEFT",[3]="BOTTOM",[4]="TOP",[5]="BOTTOM",[6]=1,[7]=1,[8]=true},
		["LEFT_DOWN"] = {[1]="RIGHT",[2]="TOPRIGHT",[3]="TOP",[4]="BOTTOM",[5]="TOP",[6]=-1,[7]=-1,[8]=true},
		["LEFT_UP"] = {[1]="RIGHT",[2]="BOTTOMRIGHT",[3]="BOTTOM",[4]="TOP",[5]="BOTTOM",[6]=-1,[7]=1,[8]=true},
		["UP"] = {[1]="BOTTOM",[2]="BOTTOM",[3]="BOTTOM",[4]="TOP",[5]="TOP",[6]=1,[7]=1,[8]=false},
		["DOWN"] = {[1]="TOP",[2]="TOP",[3]="TOP",[4]="BOTTOM",[5]="BOTTOM",[6]=1,[7]=1,[8]=false},
		["CUSTOM1"] = {
			['TOPTOP'] = 'UP_RIGHT',
			['BOTTOMBOTTOM'] = 'TOP_RIGHT',
			['LEFTLEFT'] = 'RIGHT_UP',
			['RIGHTRIGHT'] = 'LEFT_UP',
			['RIGHTTOP'] = 'LEFT_DOWN',
			['LEFTTOP'] = 'RIGHT_DOWN',
			['LEFTBOTTOM'] = 'RIGHT_UP',
			['RIGHTBOTTOM'] = 'LEFT_UP',
			['BOTTOMRIGHT'] = 'UP_LEFT',
			['BOTTOMLEFT'] = 'UP_RIGHT',
			['TOPRIGHT'] = 'DOWN_LEFT',
			['TOPLEFT'] = 'DOWN_RIGHT'
		}
	};

	local _GSORT = {
		['CLASS']=function(frame)
			frame:SetAttribute("groupingOrder","DEATHKNIGHT,DRUID,HUNTER,MAGE,PALADIN,PRIEST,SHAMAN,WARLOCK,WARRIOR,MONK")
			frame:SetAttribute('sortMethod','NAME')
			frame:SetAttribute("sortMethod",'CLASS')
		end,
		['MTMA']=function(frame)
			frame:SetAttribute("groupingOrder","MAINTANK,MAINASSIST,NONE")
			frame:SetAttribute('sortMethod','NAME')
			frame:SetAttribute("sortMethod",'ROLE')
		end,
		['ROLE']=function(frame)
			frame:SetAttribute("groupingOrder","TANK,HEALER,DAMAGER,NONE")
			frame:SetAttribute('sortMethod','NAME')
			frame:SetAttribute("sortMethod",'ASSIGNEDROLE')
		end,
		['ROLE_TDH']=function(frame)
			frame:SetAttribute("groupingOrder","TANK,DAMAGER,HEALER,NONE")
			frame:SetAttribute('sortMethod','NAME')
			frame:SetAttribute("sortMethod",'ASSIGNEDROLE')
		end,
		['ROLE_HTD']=function(frame)
			frame:SetAttribute("groupingOrder","HEALER,TANK,DAMAGER,NONE")
			frame:SetAttribute('sortMethod','NAME')
			frame:SetAttribute("sortMethod",'ASSIGNEDROLE')
		end,
		['ROLE_HDT']=function(frame)
			frame:SetAttribute("groupingOrder","HEALER,DAMAGER,TANK,NONE")
			frame:SetAttribute('sortMethod','NAME')
			frame:SetAttribute("sortMethod",'ASSIGNEDROLE')
		end,
		['NAME']=function(frame)
			frame:SetAttribute("groupingOrder","1,2,3,4,5,6,7,8")
			frame:SetAttribute('sortMethod','NAME')
			frame:SetAttribute("sortMethod",nil)
		end,
		['GROUP']=function(frame)
			frame:SetAttribute("groupingOrder","1,2,3,4,5,6,7,8")
			frame:SetAttribute('sortMethod','INDEX')
			frame:SetAttribute("sortMethod",'GROUP')
		end,
		['PETNAME']=function(frame)
			frame:SetAttribute("groupingOrder","1,2,3,4,5,6,7,8")
			frame:SetAttribute('sortMethod','NAME')
			frame:SetAttribute("sortMethod",nil)
			frame:SetAttribute("filterOnPet",true)
		end
	};

	local function dbMapping(frame)
		local db = MOD.db[frame.NameKey]
		if(db.showBy == "UP") then 
			db.showBy = "UP_RIGHT"
		end
		if(db.showBy == "DOWN") then 
			db.showBy = "DOWN_RIGHT"
		end 
	end

	local function AppendUpdateHandler(unit)
		return function()
			local db = MOD.db[unit]
			if db.enable  ~= true then 
				UnregisterAttributeDriver(MOD[unit], "state-visibility")
				MOD[unit]:Hide()
				return 
			end
			MOD.HeaderUpdate[unit](MOD, MOD[unit], db)
			for i = 1, MOD[unit]:GetNumChildren()do 
				local childFrame = select(i, MOD[unit]:GetChildren())
				MOD.FrameUpdate[unit](MOD, childFrame, MOD.db[unit])
				if _G[childFrame:GetName().."Target"]then 
					MOD.FrameUpdate[unit](MOD, _G[childFrame:GetName().."Target"], MOD.db[unit])
				end
				if _G[childFrame:GetName().."Pet"]then 
					MOD.FrameUpdate[unit](MOD, _G[childFrame:GetName().."Pet"], MOD.db[unit])
				end 
			end 
		end
	end

	local GroupSetConfigEnvironment = function(self)
		local db = MOD.db[self.NameKey]
		local anchorPoint;
		local widthCalc,heightCalc,xCalc,yCalc = 0,0,0,0;
		local sorting = db.showBy;
		local pointMap = _POINTMAP[sorting]
		local point1,point2,point3,point4,point5,horizontal,vertical,isHorizontal = pointMap[1],pointMap[2],pointMap[3],pointMap[4],pointMap[5],pointMap[6],pointMap[7],pointMap[8];
		for i=1,db.gCount do 
			local frame = self.subunits[i] --<<
			if frame then 
				dbMapping(frame)
				if isHorizontal then 
					frame:SetAttribute("xOffset",db.wrapXOffset * horizontal)
					frame:SetAttribute("yOffset",0)
					frame:SetAttribute("columnSpacing",db.wrapYOffset)
				else 
					frame:SetAttribute("xOffset",0)
					frame:SetAttribute("yOffset",db.wrapYOffset * vertical)
					frame:SetAttribute("columnSpacing",db.wrapXOffset)
				end
				if not frame.isForced then 
					if not frame.initialized then 
						frame:SetAttribute("startingIndex",db.rSort and (-min(db.gCount * db.gRowCol * 5, MAX_RAID_MEMBERS) + 1) or -4)
						frame:Show()
						frame.initialized=true 
					end
					frame:SetAttribute('startingIndex',1)
				end
				frame:ClearAllPoints()
				if db.rSort and db.invertGroupingOrder then 
					frame:SetAttribute("columnAnchorPoint",point4)
				else 
					frame:SetAttribute("columnAnchorPoint",point3)
				end
				MOD:DetachSubFrames(frame:GetChildren())
				frame:SetAttribute("point",point1)
				if not frame.isForced then 
					frame:SetAttribute("maxColumns",db.rSort and db.gCount or 1)
					frame:SetAttribute("unitsPerColumn",db.rSort and (db.gRowCol * 5) or 5)
					_GSORT[db.sortMethod](frame)
					frame:SetAttribute('sortDir',db.sortDir)
					frame:SetAttribute("showPlayer",db.showPlayer)
				end
				if i==1 and db.rSort then 
					frame:SetAttribute("groupFilter","1,2,3,4,5,6,7,8")
				else 
					frame:SetAttribute("groupFilter",tostring(i))
				end 
			end
			local anchorPoint=point2
			if db.rSort and db.startFromCenter then 
				anchorPoint=point5
			end
			if (i - 1) % db.gRowCol==0 then 
				if isHorizontal then 
					if frame then 
						frame:SetPoint(anchorPoint, self, anchorPoint, 0, heightCalc * vertical)
					end
					heightCalc=heightCalc + db.height + db.wrapYOffset;
					yCalc = yCalc + 1 
				else 
					if frame then 
						frame:SetPoint(anchorPoint, self, anchorPoint, widthCalc * horizontal, 0)
					end
					widthCalc=widthCalc + db.width + db.wrapXOffset;
					xCalc = xCalc + 1 
				end 
			else 
				if isHorizontal then 
					if yCalc==1 then 
						if frame then 
							frame:SetPoint(anchorPoint, self, anchorPoint, widthCalc * horizontal, 0)
						end
						widthCalc=widthCalc + (db.width + db.wrapXOffset) * 5;
						xCalc = xCalc + 1 
					elseif frame then 
						frame:SetPoint(anchorPoint, self, anchorPoint, (((db.width + db.wrapXOffset) * 5) * ((i - 1) % db.gRowCol)) * horizontal, ((db.height + db.wrapYOffset) * (yCalc - 1)) * vertical)
					end 
				else 
					if xCalc==1 then 
						if frame then 
							frame:SetPoint(anchorPoint, self, anchorPoint, 0, heightCalc * vertical)
						end
						heightCalc=heightCalc + (db.height + db.wrapYOffset) * 5;
						yCalc = yCalc + 1 
					elseif frame then 
						frame:SetPoint(anchorPoint, self, anchorPoint, ((db.width + db.wrapXOffset) * (xCalc - 1)) * horizontal, (((db.height + db.wrapYOffset) * 5) * ((i - 1) % db.gRowCol)) * vertical)
					end 
				end 
			end
			if heightCalc == 0 then 
				heightCalc = heightCalc + (db.height + db.wrapYOffset) * 5 
			elseif widthCalc == 0 then 
				widthCalc = widthCalc + (db.width + db.wrapXOffset) * 5 
			end 
		end
		self:SetSize(widthCalc - db.wrapXOffset, heightCalc - db.wrapYOffset)
	end
	
	local GroupUpdate = function(self) --<<
		local unitName = self.NameKey;
		MOD[unitName].db = MOD.db[unitName]
		for i=1,#self.subunits do 
			self.subunits[i].db = MOD.db[unitName]
			self.subunits[i]:Update()
		end 
	end

	local GroupSetActiveState = function(self) --<<
		if not self.isForced then 
			for i=1,#self.subunits do
				local frame = self.subunits[i]
				if i <= self.db.gCount and self.db.rSort and i <= 1 or not self.db.rSort then 
					frame:Show()
				else 
					if frame.forceShow then 
						frame:Hide()
						MOD:RestrictChildren(frame, frame:GetChildren())
						frame:SetAttribute('startingIndex',1)
					else 
						frame:ClearAllAttributes()
					end 
				end 
			end 
		end 
	end

	function MOD:SetGroupFrame(group, filter, template1, forceUpdate, template2)
		if not self.db[group] then return end
		local db = self.db[group]

		if not self[group] then 
			local realName = group:gsub("(.)", upper, 1)
			oUF_SuperVillain:RegisterStyle("SVUI_"..realName, MOD.Construct[group])
			oUF_SuperVillain:SetActiveStyle("SVUI_"..realName)

			if db.gCount then 
				self[group] = CreateFrame("Frame", "SVUI_"..realName, SVUI_UnitFrameParent, "SecureHandlerStateTemplate")
				self[group].subunits = {} --<<
				self[group].NameKey = group;
				self[group].SetConfigEnvironment = GroupSetConfigEnvironment
				self[group].Update = GroupUpdate
				self[group].SetActiveState = GroupSetActiveState
			else 
				self[group] = self:SpawnGroupHeader(SVUI_UnitFrameParent, filter, "SVUI_"..realName, template1, group, template2)
			end

			self[group].db = db;
			GroupFrames[group] = self[group]
			self[group]:Show()
		end

		if db.gCount then
			local xname = self[group].NameKey
			realName = xname:gsub("(.)", upper, 1)
			if(db.enable  ~= true and group  ~= "raidpet") then 
				UnregisterStateDriver(self[group], "visibility")
				self[group]:Hide()
				return 
			end

			if db.rSort then 
				if not self[group].subunits[1] then 
					self[group].subunits[1] = self:SpawnGroupHeader(self[group], 1, "SVUI_" .. realName .. "Group1", template1, nil, template2)
				end 
			else 
				while db.gCount > #self[group].subunits do 
					local index = tostring(#self[group].subunits + 1)
					tinsert(self[group].subunits, self:SpawnGroupHeader(self[group], index, "SVUI_" .. realName .. "Group"..index, template1, nil, template2))
				end 
			end

			if self[group].SetActiveState then 
				self[group]:SetActiveState() 
			end

			if forceUpdate or not self[group].Avatar then 
				self[group]:SetConfigEnvironment()
				if not self[group].isForced and not self[group].blockVisibilityChanges then 
					RegisterStateDriver(self[group], "visibility", db.visibility)
				end 
			else 
				self[group]:SetConfigEnvironment()
				self[group]:Update()
			end

			if(db.enable  ~= true and group == "raidpet") then 
				UnregisterStateDriver(self[group], "visibility")
				self[group]:Hide()
				return 
			end 
		else 
			self[group].db = db;
			self[group].Update = AppendUpdateHandler(group)

			if forceUpdate then 
				self.HeaderUpdate[xname](self, self[group], db)
			else 
				self[group].Update()
			end 
		end 
	end
end

function MOD:FrameForge()
	if not LoadedBasicFrames then
		self:SetBasicFrame("player")
		self:SetBasicFrame("pet")
		self:SetBasicFrame("pettarget")
		self:SetBasicFrame("target")
		self:SetBasicFrame("targettarget")
		self:SetBasicFrame("focus")
		self:SetBasicFrame("focustarget")
		LoadedBasicFrames = true;
	end

	if not LoadedExtraFrames then
		self:SetExtraFrame("boss", MAX_BOSS_FRAMES)
		self:SetExtraFrame("arena", 5)
		LoadedExtraFrames = true;
	end

	if not LoadedGroupFrames then
		self:SetGroupFrame("raid10")
		self:SetGroupFrame("raid25")
		self:SetGroupFrame("raid40")
		self:SetGroupFrame("raidpet", nil, "SVUI_UNITPET", nil, "SecureGroupPetHeaderTemplate")
		self:SetGroupFrame("party", nil, "SVUI_UNITPET, SVUI_UNITTARGET")
		self:SetGroupFrame("tank", "MAINTANK", "SVUI_UNITTARGET")
		self:SetGroupFrame("assist", "MAINASSIST", "SVUI_UNITTARGET")
		for i, group in pairs(LoadedGroupFrames)do
			local filter, template1, template2;
			local config = group_settings[i]
			if(type(config) == "table") then 
				filter, template1, template2 = unpack(config)
			end
			MOD:SetGroupFrame(group, filter, template1, nil, template2)
		end
		LoadedGroupFrames = true
	end

	MOD:UnProtect("FrameForge");
	MOD:Protect("RefreshUnitFrames");
end

function MOD:KillBlizzardRaidFrames()
	CompactRaidFrameManager:MUNG()
	CompactRaidFrameContainer:MUNG()
	CompactUnitFrameProfiles:MUNG()
	local crfmTest = CompactRaidFrameManager_GetSetting("IsShown")
	if crfmTest and crfmTest ~= "0" then 
		CompactRaidFrameManager_SetSetting("IsShown","0")
	end
end

function oUF_SuperVillain:DisableBlizzard(unit)
	if (not unit) or InCombatLockdown() then return end
	if (unit == "player") then
		KillBlizzardUnit(PlayerFrame)
		PlayerFrame:RegisterUnitEvent("UNIT_ENTERING_VEHICLE", "player")
		PlayerFrame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
		PlayerFrame:RegisterUnitEvent("UNIT_EXITING_VEHICLE", "player")
		PlayerFrame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
		PlayerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		PlayerFrame:SetUserPlaced(true)
		PlayerFrame:SetDontSavePosition(true)
		RuneFrame:SetParent(PlayerFrame)
	elseif(unit == "pet") then
		KillBlizzardUnit(PetFrame)
	elseif(unit == "target") then
		KillBlizzardUnit(TargetFrame)
		KillBlizzardUnit(ComboFrame)
	elseif(unit == "focus") then
		KillBlizzardUnit(FocusFrame)
		KillBlizzardUnit(TargetofFocusFrame)
	elseif(unit == "targettarget") then
		KillBlizzardUnit(TargetFrameToT)
	elseif(unit:match"(boss)%d?$" == "boss") then
	local id = unit:match"boss(%d)"
		if(id) then
			KillBlizzardUnit("Boss"..id.."TargetFrame")
		else
			for i = 1, 4 do
				KillBlizzardUnit(("Boss%dTargetFrame"):format(i))
			end
		end
	elseif(unit:match"(party)%d?$" == "party") then
		local id = unit:match"party(%d)"
		if(id) then
			KillBlizzardUnit("PartyMemberFrame"..id)
		else
			for i = 1, 4 do
				KillBlizzardUnit(("PartyMemberFrame%d"):format(i))
			end
		end
	elseif(unit:match"(arena)%d?$" == "arena") then
		local id = unit:match"arena(%d)"
		if(id) then
			KillBlizzardUnit("ArenaEnemyFrame"..id)
			KillBlizzardUnit("ArenaPrepFrame"..id)
			KillBlizzardUnit("ArenaEnemyFrame"..id.."PetFrame")
		else
			for i = 1, 5 do
				KillBlizzardUnit(("ArenaEnemyFrame%d"):format(i))
				KillBlizzardUnit(("ArenaPrepFrame%d"):format(i))
				KillBlizzardUnit(("ArenaEnemyFrame%dPetFrame"):format(i))
			end
		end
	end
end

function MOD:PLAYER_REGEN_DISABLED()
	for _,frame in pairs(GroupFrames) do 
		if frame.forceShow then 
			self:UpdateGroupConfig(frame)
		end 
	end

	for _,unit in pairs(BasicFrames) do 
		local frame = self[unit]
		if frame and frame.forceShow then 
			self:RestrictElement(frame)
		end 
	end

	for unit,group in pairs(ExtraFrames)do 
		if(self[unit] and self[unit].isForced) then 
			self:RestrictElement(self[unit])
		end 
	end
end

function MOD:ADDON_LOADED(event, addon)
	if addon ~= 'Blizzard_ArenaUI' then return end
	oUF_SuperVillain:DisableBlizzard('arena')
	self:UnregisterEvent("ADDON_LOADED")
end

function MOD:PLAYER_ENTERING_WORLD()
	self:RefreshUnitFrames()
	if SuperVillain.class == 'WARLOCK' and not self.QualifiedShards then
		self:QualifyWarlockShards()
		self.QualifiedShards = true
	end
end

function MOD:GROUP_ROSTER_UPDATE()
	self:KillBlizzardRaidFrames()
end

local UnitFrameThreatIndicator_Hook = function(unit, unitFrame)
	unitFrame:UnregisterAllEvents()
end
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:UpdateThisPackage()
	self:RefreshUnitFrames()
end

function MOD:ConstructThisPackage()
	self:RefreshUnitColors()
	local SVUI_UnitFrameParent = CreateFrame("Frame", "SVUI_UnitFrameParent", SuperVillain.UIParent, "SecureHandlerStateTemplate")
	RegisterStateDriver(SVUI_UnitFrameParent, "visibility", "[petbattle] hide; show")
	oUF_SuperVillain:RegisterStyle("oUF_SuperVillain", function(frame, unit)
		frame:SetScript("OnEnter", UnitFrame_OnEnter)
		frame:SetScript("OnLeave", UnitFrame_OnLeave)
		frame:SetFrameLevel(2)
		local frameName = ExtraFrames[unit] or unit;
		MOD.Construct[frameName](MOD, frame, unit);
		return frame
	end)
	self:Protect("FrameForge", true);
	-- self:SetFadeManager();
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	--self:RegisterEvent("PLAYER_REGEN_DISABLED")
	if SuperVillain.db.SVUnit.disableBlizzard then 
		self:Protect("KillBlizzardRaidFrames", true);
		NewHook("CompactUnitFrame_RegisterEvents", CompactUnitFrame_UnregisterEvents)
		NewHook("UnitFrameThreatIndicator_Initialize", UnitFrameThreatIndicator_Hook)
		InterfaceOptionsFrameCategoriesButton10:SetScale(0.0001)
		InterfaceOptionsFrameCategoriesButton11:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelPlayer:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelTarget:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelParty:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelPet:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelPlayer:SetAlpha(0)
		InterfaceOptionsStatusTextPanelTarget:SetAlpha(0)
		InterfaceOptionsStatusTextPanelParty:SetAlpha(0)
		InterfaceOptionsStatusTextPanelPet:SetAlpha(0)
		InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait:SetAlpha(0)
		InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait:EnableMouse(false)
		InterfaceOptionsCombatPanelTargetOfTarget:SetScale(0.0001)
		InterfaceOptionsCombatPanelTargetOfTarget:SetAlpha(0)
		InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates:ClearAllPoints()
		InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates:SetPoint(InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait:GetPoint())
		InterfaceOptionsDisplayPanelShowAggroPercentage:SetScale(0.0001)
		InterfaceOptionsDisplayPanelShowAggroPercentage:SetAlpha(0)

		if not IsAddOnLoaded("Blizzard_ArenaUI") then 
			self:RegisterEvent("ADDON_LOADED")
		else 
			oUF_SuperVillain:DisableBlizzard("arena")
		end

		self:RegisterEvent("GROUP_ROSTER_UPDATE", "KillBlizzardRaidFrames")
		UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")
	else 
		CompactUnitFrameProfiles:RegisterEvent("VARIABLES_LOADED")
	end
	
	local rDebuffs = ns.oUF_RaidDebuffs or oUF_RaidDebuffs;
	if not rDebuffs then return end
	rDebuffs.ShowDispelableDebuff = true;
	rDebuffs.FilterDispellableDebuff = true;
	rDebuffs.MatchBySpellName = true;
end
SuperVillain.Registry:NewPackage(MOD, "SVUnit", "pre");
MOD:RegisterEvent('PLAYER_REGEN_DISABLED')