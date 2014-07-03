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
local frameNumber, lastFrame = 0
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
local function PrepFrame_OnUpdate(self, event, unit, arg)
	if((event == "ARENA_OPPONENT_UPDATE" or event == "UNIT_NAME_UPDATE") and unit ~= self.unit) then return end 
	local _, check = IsInInstance()
	if(not MOD.db.arena.enable or check ~= "arena" or UnitExists(self.unit) and arg ~= "unseen") then 
		self:Hide()
		return 
	end 

	local spec = GetArenaOpponentSpec(MOD[self.unit]:GetID())
	local _, x, y, z;
	if spec and spec > 0 then 
		_, x, _, y, _, _, z = GetSpecializationInfoByID(spec)
	end 

	if z and x then 
		local color = RAID_CLASS_COLORS[z]
		self.SpecClass:SetText(x .. " - " .. LOCALIZED_CLASS_NAMES_MALE[z])
		self.Health:SetStatusBarColor(color.r, color.g, color.b)
		self.Icon:SetTexture(y or [[INTERFACE\ICONS\INV_MISC_QUESTIONMARK]])
		self:Show()
	else 
		self:Hide()
	end
end 

function MOD.Construct:arena(frame)
	MOD:SetActionPanel(frame)
	frame.ActionPanel:SetFrameLevel(5)
	frame.Health = MOD:CreateHealthBar(frame, true, true, true)
	frame.Power = MOD:CreatePowerBar(frame, true, true, "LEFT")
	frame.Name = MOD:CreateNameText(frame, "arena")
	MOD:CreatePortrait(frame)
	frame.Buffs = MOD:CreateBuffs(frame)
	frame.Debuffs = MOD:CreateDebuffs(frame)
	frame.Castbar = MOD:CreateCastbar(frame, true)
	--frame.HealPrediction = MOD:CreateHealPrediction(frame)
	frame.Trinket = MOD:CreateTrinket(frame)
	frame.PVPSpecIcon = MOD:CreatePVPSpecIcon(frame)
	frame.Range = { insideAlpha = 1, outsideAlpha = 1 }
	frame:SetAttribute("type2", "focus")

	if not frame.prepFrame then 
		frame.prepFrame = CreateFrame("Frame", frame:GetName().."PrepFrame", UIParent)
		frame.prepFrame:SetFrameStrata("BACKGROUND")
		frame.prepFrame:SetAllPoints(frame)
		frame.prepFrame:SetID(frame:GetID())
		frame.prepFrame.Health = CreateFrame("StatusBar", nil, frame.prepFrame)
		frame.prepFrame.Health:Point("BOTTOMLEFT", frame.prepFrame, "BOTTOMLEFT", 1, 1)
		frame.prepFrame.Health:Point("TOPRIGHT", frame.prepFrame, "TOPRIGHT", -(1 + MOD.db.arena.height), -1)
		frame.prepFrame.Health:SetPanelTemplate()
		frame.prepFrame.Icon = frame.prepFrame:CreateTexture(nil, "OVERLAY")
		frame.prepFrame.Icon.bg = CreateFrame("Frame", nil, frame.prepFrame)
		frame.prepFrame.Icon.bg:Point("TOPLEFT", frame.prepFrame, "TOPRIGHT", 1, 0)
		frame.prepFrame.Icon.bg:Point("BOTTOMRIGHT", frame.prepFrame, "BOTTOMRIGHT", 1, 0)
		frame.prepFrame.Icon.bg:SetFixedPanelTemplate()
		frame.prepFrame.Icon:SetParent(frame.prepFrame.Icon.bg)
		frame.prepFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		frame.prepFrame.Icon:FillInner(frame.prepFrame.Icon.bg)
		frame.prepFrame.SpecClass = frame.prepFrame.Health:CreateFontString(nil, "OVERLAY")
		frame.prepFrame.SpecClass:SetPoint("CENTER")
		frame.prepFrame.unit = frame.unit;
		frame.prepFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		frame.prepFrame:RegisterEvent("ARENA_OPPONENT_UPDATE")
		frame.prepFrame:RegisterEvent("UNIT_NAME_UPDATE")
		frame.prepFrame:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
		frame.prepFrame:SetScript("OnEvent", PrepFrame_OnUpdate)
		MOD:SetUnitStatusbar(frame.prepFrame.Health)
		MOD:SetUnitFont(frame.prepFrame.SpecClass)
	end 

	local frameName = frame:GetName()
	frameNumber = frameNumber + 1
	if(not _G["SVUI_Arena_MOVE"]) then
		frame:Point("RIGHT", SuperVillain.UIParent, "RIGHT", -105, 0)
		SuperVillain:SetSVMovable(frame, "SVUI_Arena_MOVE", L["Arena Frames"], nil, nil, nil, "ALL, ARENA")
	else
		frame:Point("TOPRIGHT", lastFrame, "BOTTOMRIGHT", 0, -20)
	end
	lastFrame = frame
end 
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD.FrameUpdate:arena(unit, frame, db)
	frame.db = db;
	frameNumber = frame.index;
	local holder = _G["SVUI_Arena_MOVE"]
	local UNIT_WIDTH = db.width;
	local UNIT_HEIGHT = db.height;
	frame.unit = unit
	frame.colors = oUF_SuperVillain.colors;
	frame:Size(UNIT_WIDTH, UNIT_HEIGHT)
	frame:ClearAllPoints()
	if(frameNumber == 1) then
		holder:Width(UNIT_WIDTH)
		holder:Height(UNIT_HEIGHT + (UNIT_HEIGHT + 12 + db.castbar.height) * 4)
		if(db.showBy == "UP") then 
			frame:Point("BOTTOMRIGHT", holder, "BOTTOMRIGHT")
		else 
			frame:Point("TOPRIGHT", holder, "TOPRIGHT")
		end 
	else
		local yOffset = (UNIT_HEIGHT + 12 + db.castbar.height) * (frameNumber - 1)
		if(db.showBy == "UP") then 
			frame:Point("BOTTOMRIGHT", holder, "BOTTOMRIGHT", 0, yOffset)
		else 
			frame:Point("TOPRIGHT", holder, "TOPRIGHT", 0, -yOffset)
		end 
	end

	do 
		local trinket = frame.Trinket;
		trinket.bg:Size(db.pvpTrinket.size)
		trinket.bg:ClearAllPoints()
		if(db.pvpTrinket.position == "RIGHT") then 
			trinket.bg:Point("LEFT", frame, "RIGHT", db.pvpTrinket.xOffset, db.pvpTrinket.yOffset)
		else 
			trinket.bg:Point("RIGHT", frame, "LEFT", db.pvpTrinket.xOffset, db.pvpTrinket.yOffset)
		end 
		if db.pvpTrinket.enable and not frame:IsElementEnabled("Trinket")then 
			frame:EnableElement("Trinket")
		elseif not db.pvpTrinket.enable and frame:IsElementEnabled("Trinket")then 
			frame:DisableElement("Trinket")
		end 
	end
	do 
		local pvp = frame.PVPSpecIcon;
		pvp.bg:Point("RIGHT", frame, "RIGHT")
		pvp.bg:Size(UNIT_HEIGHT, UNIT_HEIGHT)
		if db.pvpSpecIcon then
			frame.InfoPanel:Point("TOPLEFT", frame, "TOPLEFT", 0, 0)
			frame.InfoPanel:Point("BOTTOMRIGHT", frame.PVPSpecIcon, "BOTTOMLEFT", 0, 0)
			if frame:IsElementEnabled("PVPSpecIcon")then 
				frame:EnableElement("PVPSpecIcon")
			end
		elseif frame:IsElementEnabled("PVPSpecIcon")then 
			frame:DisableElement("PVPSpecIcon")
		end 
	end

	frame:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
	MOD:RefreshUnitLayout(frame, "arena")

	frame:UpdateAllElements()
end