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
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local find, format, len, split = string.find, string.format, string.len, string.split;
local gmatch, gsub, join = string.gmatch, string.gsub, string.join;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round, min = math.abs, math.ceil, math.floor, math.round, math.min;
--[[ TABLE METHODS ]]--
local twipe = table.wipe;
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
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]-- 
local SETTINGS = {
	["player"]={"BOTTOMLEFT","TOPRIGHT","BOTTOMRIGHT","TOPLEFT",1,-1},
	["target"]={"BOTTOMRIGHT","TOPLEFT","BOTTOMLEFT","TOPRIGHT",-1,1},
	["targettarget"]={"BOTTOMRIGHT","TOPLEFT","BOTTOMLEFT","TOPRIGHT",-1,1},
	["pet"]={"BOTTOMLEFT","TOPRIGHT","BOTTOMRIGHT","TOPLEFT",1,-1},
	["pettarget"]={"BOTTOMRIGHT","TOPLEFT","BOTTOMLEFT","TOPRIGHT",-1,1},
	["focus"]={"BOTTOMLEFT","TOPRIGHT","BOTTOMRIGHT","TOPLEFT",1,-1},
	["focustarget"]={"BOTTOMRIGHT","TOPLEFT","BOTTOMLEFT","TOPRIGHT",-1,1},
	["party"]={"BOTTOMLEFT","TOPRIGHT","BOTTOMRIGHT","TOPLEFT",1,-1},
	["raid"]={"BOTTOMLEFT","TOPRIGHT","BOTTOMRIGHT","TOPLEFT",1,-1},
	["raidpet"]={"BOTTOMLEFT","TOPRIGHT","BOTTOMRIGHT","TOPLEFT",1,-1},
	["assist"]={"BOTTOMLEFT","TOPRIGHT","BOTTOMRIGHT","TOPLEFT",1,-1},
	["tank"]={"BOTTOMLEFT","TOPRIGHT","BOTTOMRIGHT","TOPLEFT",1,-1},
	["boss"]={"BOTTOMRIGHT","TOPLEFT","BOTTOMLEFT","TOPRIGHT",-1,1},
	["arena"]={"BOTTOMRIGHT","TOPLEFT","BOTTOMLEFT","TOPRIGHT",-1,1}
};
local useUnitWidth = {
	["player"] = true,
	["target"] = true,
	["targettarget"] = true,
	["pet"] = true,
	["pettarget"] = true,
	["focus"] = true,
	["focustarget"] = true,
	["party"] = false,
	["raid"] = false,
	["raidpet"] = false,
	["assist"] = true,
	["tank"] = true,
	["boss"] = true,
	["arena"] = true
};
local useSolidTexture = {
	["player"] = false,
	["target"] = false,
	["targettarget"] = true,
	["pet"] = true,
	["pettarget"] = true,
	["focus"] = false,
	["focustarget"] = true,
	["party"] = true,
	["raid"] = true,
	["raidpet"] = true,
	["assist"] = true,
	["tank"] = true,
	["boss"] = true,
	["arena"] = true
};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]-- 
local function FindAnchorFrame(frame, anchor, badPoint)
	if badPoint or anchor == 'FRAME' then 
		return frame 
	elseif(anchor == 'TRINKET') then 
		if select(2,IsInInstance())=="arena" then 
			return frame.Trinket 
		else 
			return frame.PVPSpecIcon 
		end 
	elseif(anchor == 'BUFFS' and frame.Buffs and frame.Buffs:IsShown()) then
		return frame.Buffs 
	elseif(anchor == 'DEBUFFS' and frame.Debuffs and frame.Debuffs:IsShown()) then
		return frame.Debuffs 
	else 
		return frame
	end 
end 
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:RefreshUnitLayout(frame, template)
	local db = frame.db
	local UNIT_TEMPLATE = SETTINGS[template] or {"BOTTOMLEFT","TOPRIGHT","BOTTOMRIGHT","TOPLEFT",1,-1};
	local GAP = SuperVillain:Scale(3);
	local UNIT_WIDTH = db.width;
	local UNIT_HEIGHT = db.height;
	local BEST_SIZE = min(UNIT_WIDTH,UNIT_HEIGHT);
	local AURA_HOLDER = useUnitWidth[template] and db.width or SuperVillain:Scale(100)
	local powerHeight = (db.power and db.power.enable) and (db.power.height - 1) or 1;
	local BOTTOM_ANCHOR1 = UNIT_TEMPLATE[1];
	local TOP_ANCHOR1 = UNIT_TEMPLATE[2];
	local BOTTOM_ANCHOR2 = UNIT_TEMPLATE[3];
	local TOP_ANCHOR2 = UNIT_TEMPLATE[4];
	local MOD1,MOD2 = UNIT_TEMPLATE[5],UNIT_TEMPLATE[6];
	local portraitOverlay = false;
	local overlayAnimation = false;
	local portraitWidth = (1 * MOD1);
	local healthPanel = frame.HealthPanel
	local calculatedHeight = db.height;

	if(db.portrait and db.portrait.enable) then 
		if(not db.portrait.overlay) then
			portraitWidth = ((db.portrait.width * MOD1) + (1 * MOD1))
		else
			portraitOverlay = true
			overlayAnimation = MOD.db.overlayAnimation
		end
	end
	if(frame.PVPSpecIcon and db.pvpSpecIcon) then
		portraitWidth = portraitWidth - UNIT_HEIGHT
	end

	if frame.Portrait then
		frame.Portrait:Hide()
		frame.Portrait:ClearAllPoints()
	end 
	if db.portrait and frame.PortraitTexture and frame.PortraitModel then
		if db.portrait.style == '2D' then
			frame.Portrait = frame.PortraitTexture
		else
			frame.PortraitModel.UserRotation = db.portrait.rotation;
			frame.PortraitModel.UserCamDistance = db.portrait.camDistanceScale;
			frame.Portrait = frame.PortraitModel
		end
	end 

	healthPanel:ClearAllPoints()
	healthPanel:Point(TOP_ANCHOR1, frame, TOP_ANCHOR1, (1 * MOD2), -1)
	healthPanel:Point(BOTTOM_ANCHOR1, frame, BOTTOM_ANCHOR1, portraitWidth, powerHeight)

	if(frame.StatusPanel) then
		if(template ~= "player" and template ~= "pet" and template ~= "target" and template ~= "targettarget" and template ~= "focus" and template ~= "focustarget") then
			local size = healthPanel:GetHeight()
			frame.StatusPanel:SetSize(size, size)
			frame.StatusPanel:SetPoint("CENTER", healthPanel, "CENTER", 0, 0)
		end
	end

	--[[ THREAT LAYOUT ]]--

	if frame.Threat then 
		local threat = frame.Threat;
		if db.threatEnabled then 
			if not frame:IsElementEnabled('Threat')then 
				frame:EnableElement('Threat')
			end 
		elseif frame:IsElementEnabled('Threat')then 
			frame:DisableElement('Threat')
		end 
	end 

	--[[ TARGETGLOW LAYOUT ]]--

	if frame.TargetGlow then 
		local glow=frame.TargetGlow;
		glow:ClearAllPoints()
		glow:Point("TOPLEFT",-GAP,GAP)
		glow:Point("TOPRIGHT",GAP,GAP)
		glow:Point("BOTTOMLEFT",-GAP,-GAP)
		glow:Point("BOTTOMRIGHT",GAP,-GAP)
	end 

	if(frame.InfoPanel.Misc and db.misc) then
		frame:Tag(frame.InfoPanel.Misc, db.misc.tags)
	end

	--[[ HEALTH LAYOUT ]]--

	do 
		local health = frame.Health;
		if(db.health and (db.health.reversed ~= nil)) then
			health.fillInverted = db.health.reversed;
		else
			health.fillInverted = false
		end
		health.Smooth = MOD.db.smoothbars;
		if health.value then
			local point = db.health.position
			health.value:ClearAllPoints()
			SuperVillain:ReversePoint(health.value, point, frame.InfoPanel, db.health.xOffset, db.health.yOffset)
			frame:Tag(health.value, db.health.tags)
		end
		health.colorSmooth = nil;
		health.colorHealth = nil;
		health.colorClass = nil;
		health.colorReaction = nil;
		health.colorOverlay = nil;
		health.overlayAnimation = overlayAnimation;
		health.colors.health = oUF_SuperVillain.colors.health
		health.colors.tapped = oUF_SuperVillain.colors.tapped
		health.colors.disconnected = oUF_SuperVillain.colors.disconnected
		if(db.health and (db.health.frequentUpdates ~= nil)) then
		end
		if(frame.HealPrediction) then
			frame.HealPrediction["frequentUpdates"] = health.frequentUpdates
		end
		if(portraitOverlay and MOD.db.forceHealthColor) then
			health.colorOverlay = true;
		else
			if(db.colorOverride and db.colorOverride == "FORCE_ON") then 
				health.colorClass=true;
				health.colorReaction=true 
			elseif(db.colorOverride and db.colorOverride == "FORCE_OFF") then 
				if MOD.db.colorhealthbyvalue==true then 
					health.colorSmooth=true 
				else 
					health.colorHealth=true 
				end 
			else
				if(not MOD.db.healthclass) then 
					if MOD.db.colorhealthbyvalue == true then 
						health.colorSmooth = true 
					else 
						health.colorHealth = true 
					end 
				else 
					health.colorClass = true;
					health.colorReaction = true 
				end 
			end
		end
		health:ClearAllPoints()
		health:SetAllPoints(healthPanel)
		if db.health and db.health.orientation then
			health:SetOrientation(db.health.orientation)
		end
		MOD:RefreshHealthBar(frame)

	end 

	--[[ NAME LAYOUT ]]--

	if frame.Name then
		if db.name then
			local name = frame.Name
			local parent = frame.InfoPanel
			if not db.power or not db.power.hideonnpc or db.power.tags == "" then 
				name:ClearAllPoints()
				SuperVillain:ReversePoint(name, db.name.position, parent, db.name.xOffset, db.name.yOffset)
			end 
			frame:Tag(name, db.name.tags)
		end
	end

	--[[ POWER LAYOUT ]]--

	do
		if frame.Power then
			local power = frame.Power;
			if db.power.enable then 
				if not frame:IsElementEnabled('Power')then 
					frame:EnableElement('Power')
					power:Show()
				end 
				power.Smooth = MOD.db.smoothbars;
				if power.value then
					if db.power.tags and db.power.tags ~= '' then
						local point = db.power.position
						power.value:ClearAllPoints()
						SuperVillain:ReversePoint(power.value, point, frame.InfoPanel, db.power.xOffset, db.power.yOffset)
						frame:Tag(power.value,db.power.tags)
						if db.power.attachTextToPower then 
							power.value:SetParent(power)
						else 
							power.value:SetParent(frame.InfoPanel)
						end 
					else
						power.value:Hide()
					end
				end 
				power.colorClass = nil;
				power.colorReaction = nil;
				power.colorPower = nil;
				if MOD.db.powerclass then 
					power.colorClass = true;
					power.colorReaction = true 
				else 
					power.colorPower = true 
				end 
				if(db.power.frequentUpdates) then
					power.frequentUpdates = db.power.frequentUpdates
				end
				power:ClearAllPoints()
				power:Height(powerHeight - 2)
				power:Point(BOTTOM_ANCHOR1, frame, BOTTOM_ANCHOR1, (portraitWidth - (1 * MOD2)), 2)
				power:Point(BOTTOM_ANCHOR2, frame, BOTTOM_ANCHOR2, (2 * MOD2), 2)
			elseif frame:IsElementEnabled('Power')then 
				frame:DisableElement('Power')
				power:Hide()
			end 
		end

		--[[ ALTPOWER LAYOUT ]]--

		if frame.AltPowerBar then
			local altPower = frame.AltPowerBar;
			local Alt_OnShow = function()
				healthPanel:Point(TOP_ANCHOR2, portraitWidth, -(powerHeight + 1))
			end 
			local Alt_OnHide = function()
				healthPanel:Point(TOP_ANCHOR2, portraitWidth, -1)
				altPower.text:SetText("")
			end 
			if db.power.enable then 
				frame:EnableElement('AltPowerBar')
				altPower.text:SetAlpha(1)
				altPower:Point(TOP_ANCHOR2, frame, TOP_ANCHOR2, portraitWidth, -1)
				altPower:Point(TOP_ANCHOR1, frame, TOP_ANCHOR1, (1 * MOD2), -1)
				altPower:SetHeight(powerHeight)
				altPower.Smooth = MOD.db.smoothbars;
				altPower:HookScript("OnShow", Alt_OnShow)
				altPower:HookScript("OnHide", Alt_OnHide)
			else 
				frame:DisableElement('AltPowerBar')
				altPower.text:SetAlpha(0)
				altPower:Hide()
			end 
		end
	end

	--[[ PORTRAIT LAYOUT ]]--

	if db.portrait and frame.Portrait then
		local portrait = frame.Portrait;

		portrait:Show()

		if db.portrait.enable then
			if not frame:IsElementEnabled('Portrait')then 
				frame:EnableElement('Portrait')
			end 
			portrait:ClearAllPoints()
			portrait:SetAlpha(1)
		
			if db.portrait.overlay then 
				if db.portrait.style == '3D' then
					portrait:SetFrameLevel(frame.ActionPanel:GetFrameLevel())
					portrait:SetCamDistanceScale(db.portrait.camDistanceScale)
				elseif db.portrait.style == '2D' then 
					portrait.anchor:SetFrameLevel(frame.ActionPanel:GetFrameLevel())
				end 
				
				portrait:Point(TOP_ANCHOR2, healthPanel, TOP_ANCHOR2, (1 * MOD1), -1)
				portrait:Point(BOTTOM_ANCHOR2, healthPanel, BOTTOM_ANCHOR2, (1 * MOD2), 1)
				
				portrait.Panel:Show()
			else
				portrait.Panel:Show()
				if db.portrait.style == '3D' then 
					portrait:SetFrameLevel(frame.ActionPanel:GetFrameLevel())
					portrait:SetCamDistanceScale(db.portrait.camDistanceScale)
				elseif db.portrait.style == '2D' then 
					portrait.anchor:SetFrameLevel(frame.ActionPanel:GetFrameLevel())
				end 
				
				if not frame.Power or not db.power.enable then 
					portrait:Point(TOP_ANCHOR2, frame, TOP_ANCHOR2, (1 * MOD1), -1)
					portrait:Point(BOTTOM_ANCHOR2, healthPanel, BOTTOM_ANCHOR1, (4 * MOD2), 0)
				else 
					portrait:Point(TOP_ANCHOR2, frame, TOP_ANCHOR2, (1 * MOD1), -1)
					portrait:Point(BOTTOM_ANCHOR2, frame.Power, BOTTOM_ANCHOR1, (4 * MOD2), 0)
				end 
			end
		else 
			if frame:IsElementEnabled('Portrait')then 
				frame:DisableElement('Portrait')
				portrait:Hide()
				portrait.Panel:Hide()
			end 
		end
	end 

	--[[ CASTBAR LAYOUT ]]--

	if db.castbar and frame.Castbar then
		local castbar = frame.Castbar;
		local castHeight = db.castbar.height;
		local castWidth = db.castbar.width;

		local sparkSize = castHeight * 4;
		local adjustedWidth = castWidth - 2;
		local lazerScale = castHeight * 1.8;
		
		if(not castbar.pewpew) then
			castbar:SetSize(adjustedWidth, castHeight)
		elseif(castbar:GetHeight() ~= lazerScale) then
			castbar:SetSize(adjustedWidth, lazerScale)
		end

		if castbar.Spark and db.castbar.spark then 
			castbar.Spark:Show()
			castbar.Spark:SetSize(sparkSize, sparkSize)
			if castbar.Spark[1] and castbar.Spark[2] then
				castbar.Spark[1]:SetAllPoints(castbar.Spark)
				castbar.Spark[2]:FillInner(castbar.Spark, 4, 4)
			end
			castbar.Spark.SetHeight = function()return end 
		end 
		castbar:SetFrameStrata("HIGH")
		if castbar.Holder then
			castbar.Holder:Width(castWidth + (1 * 2))
			castbar.Holder:Height(castHeight + (1 * 2))
			local holderUpdate = castbar.Holder:GetScript('OnSizeChanged')
			if holderUpdate then
				holderUpdate(castbar.Holder)
			end
		end
		castbar:GetStatusBarTexture():SetHorizTile(false)
		if db.castbar.latency then 
			castbar.SafeZone = castbar.LatencyTexture;
			castbar.LatencyTexture:Show()
		else 
			castbar.SafeZone = nil;
			castbar.LatencyTexture:Hide()
		end 
		if castbar.Icon then
			if db.castbar.icon then
				castbar.Icon.bg:Width(castHeight + (1 * 2))
				castbar.Icon.bg:Height(castHeight + (1 * 2))
				castbar.Icon.bg:Show()
			else 
				castbar.Icon.bg:Hide()
				castbar.Icon = nil 
			end 
		end
		
		local cr,cg,cb
		if(db.castbar.useCustomColor) then
			cr,cg,cb = db.castbar.castingColor[1], db.castbar.castingColor[2], db.castbar.castingColor[3];
			castbar.CastColor = {cr,cg,cb}
			cr,cg,cb = db.castbar.sparkColor[1], db.castbar.sparkColor[2], db.castbar.sparkColor[3];
			castbar.SparkColor = {cr,cg,cb}
		else
			castbar.CastColor = oUF_SuperVillain.colors.casting
			castbar.SparkColor = oUF_SuperVillain.colors.spark
		end

		if db.castbar.enable and not frame:IsElementEnabled('Castbar')then 
			frame:EnableElement('Castbar')
		elseif not db.castbar.enable and frame:IsElementEnabled('Castbar')then
			SuperVillain:AddonMessage("No castbar")
			frame:DisableElement('Castbar') 
		end
	end 

	--[[ AURA LAYOUT ]]--

	if frame.Buffs and frame.Debuffs then
		do
			if db.debuffs.enable or db.buffs.enable then 
				if not frame:IsElementEnabled('Aura')then 
					frame:EnableElement('Aura')
				end 
			else 
				if frame:IsElementEnabled('Aura')then 
					frame:DisableElement('Aura')
				end 
			end 
			frame.Buffs:ClearAllPoints()
			frame.Debuffs:ClearAllPoints()
		end 

		do 
			local buffs = frame.Buffs;
			local numRows = db.buffs.numrows;
			local perRow = db.buffs.perrow;
			local buffCount = perRow * numRows;
			
			buffs.forceShow = frame.forceShowAuras;
			buffs.num = buffCount;

			local tempSize = (((UNIT_WIDTH + 2) - (buffs.spacing * (perRow - 1))) / perRow);
			local auraSize = min(BEST_SIZE, tempSize)
			if(db.buffs.sizeOverride and db.buffs.sizeOverride > 0) then
				auraSize = db.buffs.sizeOverride
				buffs:SetWidth(perRow * db.buffs.sizeOverride)
			end

			buffs.size = auraSize;

			local attachTo = FindAnchorFrame(frame, db.buffs.attachTo, db.debuffs.attachTo == 'BUFFS' and db.buffs.attachTo == 'DEBUFFS')

			SuperVillain:ReversePoint(buffs, db.buffs.anchorPoint, attachTo, db.buffs.xOffset + MOD2, db.buffs.yOffset)
			buffs:SetWidth((auraSize + buffs.spacing) * perRow)
			buffs:Height((auraSize + buffs.spacing) * numRows)
			buffs["growth-y"] = db.buffs.verticalGrowth;
			buffs["growth-x"] = db.buffs.horizontalGrowth;

			if db.buffs.enable then 
				buffs:Show()
				MOD:UpdateAuraIconSettings(buffs)
			else 
				buffs:Hide()
			end 
		end 
		do 
			local debuffs = frame.Debuffs;
			local numRows = db.debuffs.numrows;
			local perRow = db.debuffs.perrow;
			local debuffCount = perRow * numRows;
			
			debuffs.forceShow = frame.forceShowAuras;
			debuffs.num = debuffCount;

			local tempSize = (((UNIT_WIDTH + 2) - (debuffs.spacing * (perRow - 1))) / perRow);
			local auraSize = min(BEST_SIZE,tempSize)
			if(db.debuffs.sizeOverride and db.debuffs.sizeOverride > 0) then
				auraSize = db.debuffs.sizeOverride
				debuffs:SetWidth(perRow * db.debuffs.sizeOverride)
			end

			debuffs.size = auraSize;

			local attachTo = FindAnchorFrame(frame, db.debuffs.attachTo, db.debuffs.attachTo == 'BUFFS' and db.buffs.attachTo == 'DEBUFFS')

			SuperVillain:ReversePoint(debuffs, db.debuffs.anchorPoint, attachTo, db.debuffs.xOffset + MOD2, db.debuffs.yOffset)
			debuffs:SetWidth((auraSize + debuffs.spacing) * perRow)
			debuffs:Height((auraSize + debuffs.spacing) * numRows)
			debuffs["growth-y"] = db.debuffs.verticalGrowth;
			debuffs["growth-x"] = db.debuffs.horizontalGrowth;

			if db.debuffs.enable then 
				debuffs:Show()
				MOD:UpdateAuraIconSettings(debuffs)
			else 
				debuffs:Hide()
			end 
		end 
	end 

	--[[ AURABAR LAYOUT ]]--

	if frame.AuraBars then
		local auraBar = frame.AuraBars;
		if db.aurabar.enable then 
			if not frame:IsElementEnabled('AuraBars') then frame:EnableElement('AuraBars')end 
			auraBar.auraBarTexture = LSM:Fetch("statusbar", MOD.db.auraBarStatusbar);
			auraBar:Show()
			auraBar.friendlyAuraType = db.aurabar.friendlyAuraType;
			auraBar.enemyAuraType = db.aurabar.enemyAuraType;
			local attachTo = frame.ActionPanel;
			local preOffset = 1;
			if(db.aurabar.attachTo == 'BUFFS' and frame.Buffs and frame.Buffs:IsShown()) then 
				attachTo = frame.Buffs
				preOffset = 10
			elseif(db.aurabar.attachTo == 'DEBUFFS' and frame.Debuffs and frame.Debuffs:IsShown()) then 
				attachTo = frame.Debuffs
				preOffset = 10
			elseif not isPlayer and SVUI_Player and db.aurabar.attachTo == 'PLAYER_AURABARS' then
				attachTo = SVUI_Player.AuraBars
				preOffset = 10
			end 
			local anchorPoint, relativePoint = 'BOTTOM', 'TOP';
			if db.aurabar.anchorPoint == 'BELOW' then 
				anchorPoint, relativePoint = 'TOP', 'BOTTOM';
				auraBar.down = true
			else
				auraBar.down = false
			end 
			local offSet = SuperVillain:Scale(preOffset)
			local yOffset = db.aurabar.anchorPoint == 'BELOW' and -offSet or offSet;
			auraBar.auraBarHeight = db.aurabar.height;
			auraBar:ClearAllPoints()
			auraBar:SetSize(UNIT_WIDTH, db.aurabar.height)
			auraBar:Point(anchorPoint..'LEFT', attachTo, relativePoint..'LEFT', 1, yOffset)
			auraBar.buffColor = oUF_SuperVillain.colors.buff_bars
			if MOD.db.auraBarByType then 
				auraBar.debuffColor = nil;
				auraBar.defaultDebuffColor = oUF_SuperVillain.colors.debuff_bars
			else 
				auraBar.debuffColor = oUF_SuperVillain.colors.debuff_bars
				auraBar.defaultDebuffColor = nil 
			end 
			MOD:SortAuraBars(auraBar, db.aurabar.sort)
			auraBar:SetAnchors()
		else 
			if frame:IsElementEnabled('AuraBars')then frame:DisableElement('AuraBars')auraBar:Hide()end 
		end
	end 

	--[[ ICON LAYOUTS ]]--

	do
		if db.icons then
			local ico = db.icons;

			--[[ RAIDICON ]]--

			if(ico.raidicon and frame.RaidIcon) then
				local raidIcon = frame.RaidIcon;
				if ico.raidicon.enable then
					raidIcon:Show()
					frame:EnableElement('RaidIcon')
					local size = ico.raidicon.size;
					raidIcon:ClearAllPoints()
					raidIcon:Size(size)
					SuperVillain:ReversePoint(raidIcon, ico.raidicon.attachTo, healthPanel, ico.raidicon.xOffset, ico.raidicon.yOffset)
				else 
					frame:DisableElement('RaidIcon')
					raidIcon:Hide()
				end
			end

			--[[ ROLEICON ]]--

			if(ico.roleIcon and frame.LFDRole) then 
				local lfd = frame.LFDRole;
				if ico.roleIcon.enable then
					lfd:Show()
					frame:EnableElement('LFDRole')
					local size = ico.roleIcon.size;
					lfd:ClearAllPoints()
					lfd:Size(size)
					SuperVillain:ReversePoint(lfd, ico.roleIcon.attachTo, healthPanel, ico.roleIcon.xOffset, ico.roleIcon.yOffset)
				else 
					frame:DisableElement('LFDRole')
					lfd:Hide()
				end 
			end 

			--[[ RAIDROLEICON ]]--

			if(ico.raidRoleIcons and frame.RaidRoleFramesAnchor) then 
				local roles = frame.RaidRoleFramesAnchor;
				if ico.raidRoleIcons.enable then 
					roles:Show()
					frame:EnableElement('Leader')
					frame:EnableElement('MasterLooter')
					local size = ico.raidRoleIcons.size;
					roles:ClearAllPoints()
					roles:Size(size)
					SuperVillain:ReversePoint(roles, ico.raidRoleIcons.attachTo, healthPanel, ico.raidRoleIcons.xOffset, ico.raidRoleIcons.yOffset)
				else 
					roles:Hide()
					frame:DisableElement('Leader')
					frame:DisableElement('MasterLooter')
				end 
			end 

		end 
	end

	--[[ HEAL PREDICTION LAYOUT ]]--

	if frame.HealPrediction then
		if db.predict then 
			if not frame:IsElementEnabled('HealPrediction')then 
				frame:EnableElement('HealPrediction')
			end 
		else 
			if frame:IsElementEnabled('HealPrediction')then 
				frame:DisableElement('HealPrediction')
			end 
		end
	end 

	--[[ DEBUFF HIGHLIGHT LAYOUT ]]--

	if frame.Afflicted then
		if MOD.db.debuffHighlighting then
			if(useSolidTexture[template]) then
				frame.Afflicted:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
			end
			frame:EnableElement('Afflicted')
		else 
			frame:DisableElement('Afflicted')
		end
	end 

	--[[ RANGE CHECK LAYOUT ]]--

	if frame.Range then 
		frame.Range.outsideAlpha = MOD.db.OORAlpha or 1;
		if db.rangeCheck then 
			if not frame:IsElementEnabled('Range')then 
				frame:EnableElement('Range')
			end  
		else 
			if frame:IsElementEnabled('Range')then 
				frame:DisableElement('Range')
			end 
		end 
	end 
end 