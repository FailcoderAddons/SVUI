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
local MOD = SuperVillain.Registry:Expose('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
local ceil,tinsert = math.ceil,table.insert
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD.Construct:player(frame)
	MOD:SetActionPanel(frame, "player")
	frame.Health = MOD:CreateHealthBar(frame, true, true)
	frame.Health.frequentUpdates = true;
	frame.Health.value:ClearAllPoints()
	frame.Health.value:SetParent(frame.InfoPanel)
	frame.Health.value:Point("RIGHT", frame.InfoPanel, "RIGHT")
	frame.Power = MOD:CreatePowerBar(frame, true, true, "LEFT")
	frame.Power.frequentUpdates = true;
	frame.Power.value:ClearAllPoints()
	frame.Power.value:SetParent(frame.InfoPanel)
	frame.Power.value:Point("LEFT", frame.InfoPanel, "LEFT")
	frame.Name = MOD:CreateNameText(frame, "player")
	frame.Name:ClearAllPoints()
	frame.Name:SetParent(frame.InfoPanel)
	frame.Name:Point("CENTER", frame.InfoPanel, "CENTER")
	MOD:CreatePortrait(frame, false, true)
	frame.Buffs = MOD:CreateBuffs(frame)
	frame.Debuffs = MOD:CreateDebuffs(frame)
	frame.Castbar = MOD:CreateCastbar(frame, false, L["Player Castbar"], true, true)
	MOD:CreateExperienceRepBar(frame)
	MOD:GetClassResources(frame)
	frame.RaidIcon = MOD:CreateRaidIcon(frame)
	frame.Resting = MOD:CreateRestingIndicator(frame)
	frame.Combat = MOD:CreateCombatIndicator(frame)
	frame.PvPText = frame.InfoPanel:CreateFontString(nil,'OVERLAY')
	MOD:SetUnitFont(frame.PvPText)
	frame.Afflicted = MOD:CreateAfflicted(frame)
	frame.HealPrediction = MOD:CreateHealPrediction(frame, true)
	frame.AuraBars = MOD:CreateAuraBarHeader(frame, "player")
	frame.CombatFade = true;
	frame:Point("BOTTOMLEFT", SuperVillain.UIParent, "BOTTOM", -413, 182)
	SuperVillain:SetSVMovable(frame, frame:GetName().."_MOVE", L["Player Frame"], nil, nil, nil, "ALL, SOLO")
end 
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD.FrameUpdate:player(unit, frame, db)
	frame.db = db;
	local OFFSET = SuperVillain:Scale(1);
	local UNIT_WIDTH = db.width;
	local UNIT_HEIGHT = db.height;
	local USE_CLASSBAR = db.classbar.enable;
	local classBarHeight = db.classbar.height;
	local classBarWidth = db.width * 0.4;
	local healthPanel = frame.HealthPanel
	local iconDB = db.icons
	frame.unit = unit
	frame:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
	frame.colors = oUF_SuperVillain.colors;
	frame:Size(UNIT_WIDTH, UNIT_HEIGHT)
	_G[frame:GetName().."_MOVE"]:Size(frame:GetSize())

	MOD:RefreshUnitLayout(frame, "player")

	do 
		local resting = frame.Resting;
		if resting then
			if iconDB and iconDB.restIcon and iconDB.restIcon.enable then
				local size = iconDB.restIcon.size;
				resting:ClearAllPoints()
				resting:Size(size)
				SuperVillain:ReversePoint(resting, iconDB.restIcon.attachTo, healthPanel, iconDB.restIcon.xOffset, iconDB.restIcon.yOffset)
				if not frame:IsElementEnabled("Resting")then 
					frame:EnableElement("Resting")
				end 
			elseif frame:IsElementEnabled("Resting")then 
				frame:DisableElement("Resting")
				resting:Hide()
			end
		end
	end 
	do 
		local combat = frame.Combat;
		if combat then
			if iconDB and iconDB.combatIcon and iconDB.combatIcon.enable then
				local size = iconDB.combatIcon.size;
				combat:ClearAllPoints()
				combat:Size(size)
				SuperVillain:ReversePoint(combat, iconDB.combatIcon.attachTo, healthPanel, iconDB.combatIcon.xOffset, iconDB.combatIcon.yOffset)
				if not frame:IsElementEnabled("Combat")then 
					frame:EnableElement("Combat")
				end 
			elseif frame:IsElementEnabled("Combat")then 
				frame:DisableElement("Combat")
				combat:Hide()
			end
		end
	end 
	do 
		local pvp = frame.PvPText;
		local point = db.pvp.position;
		pvp:ClearAllPoints()
		pvp:Point(db.pvp.position, healthPanel, db.pvp.position)
		frame:Tag(pvp, db.pvp.tags)
	end 
	do 
		local power = frame.Power;
		if frame.DruidAltMana then 
			if db.power.druidMana then 
				frame:EnableElement("DruidAltMana")
			else 
				frame:DisableElement("DruidAltMana")
				frame.DruidAltMana:Hide()
			end 
		end 
		if SuperVillain.class == "MONK" then 
			local stagger = frame.DrunkenMaster;
			if db.stagger.enable then 
				if not frame:IsElementEnabled("DrunkenMaster")then 
					frame:EnableElement("DrunkenMaster")
				end 
			else 
				if frame:IsElementEnabled("DrunkenMaster")then 
					frame:DisableElement("DrunkenMaster")
				end 
			end 
		end 
	end 
	do
		if(frame.DruidAltMana) then 
			if db.power.druidMana then 
				frame:EnableElement("DruidAltMana")
			else 
				frame:DisableElement("DruidAltMana")
				frame.DruidAltMana:Hide()
			end 
		end 
		if(frame.DrunkenMaster) then
			if db.stagger.enable then 
				if not frame:IsElementEnabled("DrunkenMaster")then 
					frame:EnableElement("DrunkenMaster")
				end 
			else 
				if frame:IsElementEnabled("DrunkenMaster")then 
					frame:DisableElement("DrunkenMaster")
				end 
			end 
		end
		
		if(frame.ClassBar or frame.HyperCombo) then
			if frame.ClassBarRefresh then 
				frame.ClassBarRefresh(frame)
			end 
			if(frame.ClassBar) then
				local classBar = frame[frame.ClassBar];
				if not db.classbar.detachFromFrame then
					if classBar.Avatar then 
						classBar.Avatar:SetScale(0.000001)
						classBar.Avatar:SetAlpha(0)
					end 
				else 
					classBarWidth = db.classbar.detachedWidth;
					if not classBar.Avatar then 
						classBar:Point("TOPLEFT", frame, "BOTTOMLEFT", 0, -2)
						SuperVillain:SetSVMovable(classBar, "ClassBar_MOVE", L["Classbar"], nil, nil, nil, "ALL, SOLO")
					else
						classBar.Avatar:SetScale(1)
						classBar.Avatar:SetAlpha(1)
					end 
				end 
				if USE_CLASSBAR then
					if(not frame:IsElementEnabled(frame.ClassBar)) then 
						frame:EnableElement(frame.ClassBar)
					end
					classBar:Show()
				else
					if(frame:IsElementEnabled(frame.ClassBar)) then 
						frame:DisableElement(frame.ClassBar)
					end
					classBar:Hide()
				end
			end
			if(frame.HyperCombo) then
				if not frame:IsElementEnabled("HyperCombo") then 
					frame:EnableElement("HyperCombo")
				end 
			else
				if frame:IsElementEnabled("HyperCombo") then 
					frame:DisableElement("HyperCombo")
				end 
			end 
		end
	end 
	do 
		if db.combatfade and not frame:IsElementEnabled("CombatFade")then 
			frame:EnableElement("CombatFade")
		elseif 
			not db.combatfade and frame:IsElementEnabled("CombatFade")then 
			frame:DisableElement("CombatFade")
		end 
	end 
	frame:UpdateAllElements()
end