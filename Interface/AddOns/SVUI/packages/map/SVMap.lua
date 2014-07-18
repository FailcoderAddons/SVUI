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
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert   = _G.tinsert;
local string    = _G.string;
local math      = _G.math;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local match, gsub = string.match, string.gsub;
--[[ MATH METHODS ]]--
local parsefloat = math.parsefloat;  -- Uncommon
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = {};
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local SVUI_CLASS_COLORS = _G.SVUI_CLASS_COLORS
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local gsub,upper = string.gsub,string.upper;
local temp = gsub(SLASH_CALENDAR1, "/", "");
local calendar_string = gsub(temp, "^%l", upper)
local cColor = RAID_CLASS_COLORS[SuperVillain.class];
local MM_COLOR = {"VERTICAL", 0.65, 0.65, 0.65, 0.95, 0.95, 0.95}
local MM_BRDR = 0
local MM_SIZE = 240
local MM_OFFSET_TOP = (MM_SIZE * 0.07)
local MM_OFFSET_BOTTOM = (MM_SIZE * 0.11)
local MM_WIDTH = MM_SIZE + (MM_BRDR * 2)
local MM_HEIGHT = (MM_SIZE - (MM_OFFSET_TOP + MM_OFFSET_BOTTOM) + (MM_BRDR * 2))

local SVUI_MinimapFrame = CreateFrame('Frame', 'SVUI_MinimapFrame', UIParent)
SVUI_MinimapFrame.backdrop = SVUI_MinimapFrame:CreateTexture(nil,"BACKGROUND",nil,-2)
local SVUI_MinimapZonetext = CreateFrame("Frame", 'SVUI_MinimapZonetext', SVUI_MinimapFrame)
local SVUI_MinimapNarrator = CreateFrame("Frame", 'SVUI_MinimapNarrator', SVUI_MinimapFrame)
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function MiniMap_MouseUp(self,btn)
	local position = self:GetPoint()
	if btn == "RightButton" then
		local xoff = -1
		if position:match("RIGHT") then xoff = SuperVillain:Scale(-16) end
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, xoff, SuperVillain:Scale(-3))
	else
		Minimap_OnClick(self)
	end
end

local function MiniMap_MouseWheel(self,d)
	if d > 0 then
		_G.MinimapZoomIn:Click()
	elseif d < 0 then
		_G.MinimapZoomOut:Click()
	end
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
MOD.narrative = "";
MOD.locationPrefix = "";

function MOD:UpdateSizing()
	MM_COLOR = SuperVillain.Media.gradient[MOD.db.bordercolor]
	MM_BRDR = MOD.db.bordersize or 0
	MM_SIZE = MOD.db.size or 240
	MM_OFFSET_TOP = (MM_SIZE * 0.07)
	MM_OFFSET_BOTTOM = (MM_SIZE * 0.11)
	MM_WIDTH = MM_SIZE + (MM_BRDR * 2)
	MM_HEIGHT = MOD.db.customshape and (MM_SIZE - (MM_OFFSET_TOP + MM_OFFSET_BOTTOM) + (MM_BRDR * 2)) or MM_WIDTH
end;

function MOD:RefreshMiniMap()
	MOD:UpdateSizing()
	if(SVUI_MinimapFrame and SVUI_MinimapFrame:IsShown()) then
		SVUI_MinimapFrame:Size(MM_WIDTH, MM_HEIGHT)
		SVUI_MinimapFrame.backdrop:SetGradient(unpack(MM_COLOR))
		Minimap:Size(MM_SIZE,MM_SIZE)
		if MOD.db.customshape then
			Minimap:SetPoint("BOTTOMLEFT", SVUI_MinimapFrame, "BOTTOMLEFT", MM_BRDR, -(MM_OFFSET_BOTTOM - MM_BRDR))
			Minimap:SetPoint("TOPRIGHT", SVUI_MinimapFrame, "TOPRIGHT", -MM_BRDR, (MM_OFFSET_TOP - MM_BRDR))
			Minimap:SetMaskTexture('Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP_MASK_RECTANGLE')
		else
			Minimap:SetHitRectInsets(0, 0, 0, 0)
			Minimap:FillInner(SVUI_MinimapFrame, MM_BRDR, MM_BRDR)
			Minimap:SetMaskTexture('Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP_MASK_SQUARE')
		end
		Minimap:SetParent(SVUI_MinimapFrame)
		Minimap:SetZoom(1)
		Minimap:SetZoom(0)
	end

	SVUI_MinimapZonetext:SetSize(MM_WIDTH,28)
	SVUI_MinimapZonetext.Text:SetSize(MM_WIDTH,32)


	if SVUI_AurasAnchor then
		SVUI_AurasAnchor:Height(MM_HEIGHT)
		if SVUI_Auras_MOVE and not SuperVillain:TestMovableMoved('SVUI_Auras_MOVE') and not SuperVillain:TestMovableMoved('Minimap_MOVE') then
			SVUI_Auras_MOVE:ClearAllPoints()
			SVUI_Auras_MOVE:Point("TOPRIGHT", Minimap_MOVE, "TOPLEFT", -8, 0)
		end
		if SVSVUI_Auras_MOVE then
			SVUI_Auras_MOVE:Height(MM_HEIGHT)
		end
	end
	if SVUI_HyperBuffs then
		SuperVillain.Registry:Expose('SVAura'):Update_HyperBuffsSettings()
	end
	if TimeManagerClockButton then
		TimeManagerClockButton:MUNG()
	end
end

do
	local function _updateCoords()
		local a, b = IsInInstance()
		local c, d = GetPlayerMapPosition("player")
		local xF, yF = "|cffffffffx:  |r%.1f", "|cffffffffy:  |r%.1f"
		if(MOD.db.playercoords == "SIMPLE") then
			xF, yF = "%.1f", "%.1f";
		end;
		c = parsefloat(100 * c, 2)
		d = parsefloat(100 * d, 2)
		if c ~= 0 and d ~= 0 then 
			SVUI_MiniMapCoords.playerXCoords:SetFormattedText(xF, c)
			SVUI_MiniMapCoords.playerYCoords:SetFormattedText(yF, d)
		else 
			SVUI_MiniMapCoords.playerXCoords:SetText("")
			SVUI_MiniMapCoords.playerYCoords:SetText("")
		end; 
	end

	local function _createCoords()
		local x, y = GetPlayerMapPosition("player")
		x = tonumber(parsefloat(100  *  x, 0))
		y = tonumber(parsefloat(100  *  y, 0))
		return x, y
	end

	local function Tour_OnEnter(self,...)
		if InCombatLockdown() then
			GameTooltip:Hide()
		else
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -4)
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(L["Click : "], L["Toggle WorldMap"], 0.7, 0.7, 1, 0.7, 0.7, 1)
			GameTooltip:AddDoubleLine(L["ShiftClick : "], L["Announce your position in chat"],0.7, 0.7, 1, 0.7, 0.7, 1)
			GameTooltip:Show()
		end
	end;

	local function Tour_OnLeave(self,...)
		GameTooltip:Hide()
	end;

	local function Tour_OnClick(self, btn)
		local zoneText = GetRealZoneText() or UNKNOWN;
		if IsShiftKeyDown() then
			local edit_box = ChatEdit_ChooseBoxForSend()
			local x, y = _createCoords()
			local message
			local coords = x..", "..y
				if zoneText  ~= GetSubZoneText() then
					message = format("%s: %s (%s)", zoneText, GetSubZoneText(), coords)
				else
					message = format("%s (%s)", zoneText, coords)
				end
			ChatEdit_ActivateChat(edit_box)
			edit_box:Insert(message) 
		else
			ToggleFrame(WorldMapFrame)
		end
		GameTooltip:Hide()
	end

	function MOD:SetMiniMapCoords()
		if(not SVUI_MiniMapCoords) then
			local CoordsHolder = CreateFrame("Frame", "SVUI_MiniMapCoords", Minimap)
			CoordsHolder:SetFrameLevel(Minimap:GetFrameLevel()  +  1)
			CoordsHolder:SetFrameStrata(Minimap:GetFrameStrata())
			CoordsHolder:SetPoint("TOPLEFT", SVUI_MinimapFrame, "BOTTOMLEFT", 0, -4)
			CoordsHolder:SetPoint("TOPRIGHT", SVUI_MinimapFrame, "BOTTOMRIGHT", 0, -4)
			CoordsHolder:SetHeight(17)
			CoordsHolder:EnableMouse(true)
			CoordsHolder:SetScript("OnEnter",Tour_OnEnter)
			CoordsHolder:SetScript("OnLeave",Tour_OnLeave)
			CoordsHolder:SetScript("OnMouseDown",Tour_OnClick)

			CoordsHolder.playerXCoords = CoordsHolder:CreateFontString(nil, "OVERLAY")
			CoordsHolder.playerXCoords:SetPoint("BOTTOMLEFT", CoordsHolder, "BOTTOMLEFT", 0, 0)
			CoordsHolder.playerXCoords:SetWidth(70)
			CoordsHolder.playerXCoords:SetHeight(17)
			CoordsHolder.playerXCoords:SetFontTemplate(SuperVillain.Media.font.numbers, 12, "OUTLINE")
			CoordsHolder.playerXCoords:SetTextColor(cColor.r, cColor.g, cColor.b)
			
			CoordsHolder.playerYCoords = CoordsHolder:CreateFontString(nil, "OVERLAY")
			CoordsHolder.playerYCoords:SetPoint("BOTTOMLEFT", CoordsHolder.playerXCoords, "BOTTOMRIGHT", 4, 0)
			CoordsHolder.playerXCoords:SetWidth(70)
			CoordsHolder.playerYCoords:SetHeight(17)
			CoordsHolder.playerYCoords:SetFontTemplate(SuperVillain.Media.font.numbers, 12, "OUTLINE")
			CoordsHolder.playerYCoords:SetTextColor(cColor.r, cColor.g, cColor.b)
		end

		if(not MOD.db.playercoords or MOD.db.playercoords == "HIDE") then
			if MOD.CoordTimer then
				SuperVillain:RemoveLoop(MOD.CoordTimer)
				MOD.CoordTimer = nil;
			end
			SVUI_MiniMapCoords.playerXCoords:SetText("")
			SVUI_MiniMapCoords.playerYCoords:SetText("")
			SVUI_MiniMapCoords:Hide()
		else
			SVUI_MiniMapCoords:Show()
			MOD.CoordTimer = SuperVillain:ExecuteLoop(_updateCoords, 0.05)
			_updateCoords()
		end 
	end
end

local function UpdateMinimapNarration()
	SVUI_MinimapNarrator.Text:SetText(MOD.narrative)
end;

local function UpdateMinimapLocation()
	SVUI_MinimapZonetext.Text:SetText(MOD.locationPrefix .. strsub(GetMinimapZoneText(), 1, 25))
end;

function MOD:UpdateMinimapTexts()
	MOD.narrative = "";
	MOD.locationPrefix = "";
	if(not MOD.db.locationText or MOD.db.locationText == "HIDE") then
		SVUI_MinimapNarrator:Hide();
		SVUI_MinimapZonetext:Hide();
	elseif(MOD.db.locationText == "SIMPLE") then
		SVUI_MinimapNarrator:Hide();
		SVUI_MinimapZonetext:Show();
		UpdateMinimapLocation()
		UpdateMinimapNarration()
	else
		SVUI_MinimapNarrator:Show();
		SVUI_MinimapZonetext:Show();
		MOD.narrative = L['Meanwhile...'];
		MOD.locationPrefix = L["..at "];
		UpdateMinimapLocation()
		UpdateMinimapNarration()
	end
end;

function MOD:CreateMiniMapElements()
	MOD:UpdateSizing()

	Minimap:SetPlayerTexture('Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP_ARROW')
	Minimap:SetCorpsePOIArrowTexture('Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP_CORPSE_ARROW')
	Minimap:SetPOIArrowTexture('Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP_GUIDE_ARROW')
	Minimap:SetBlipTexture('Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP_ICONS')
	Minimap:SetClampedToScreen(false)

	SVUI_MinimapFrame:Point("TOPRIGHT", SuperVillain.UIParent, "TOPRIGHT", -10, -10)
	SVUI_MinimapFrame:Size(MM_WIDTH, MM_HEIGHT)
	SVUI_MinimapFrame.backdrop:ClearAllPoints()
	SVUI_MinimapFrame.backdrop:WrapOuter(SVUI_MinimapFrame,2)
	SVUI_MinimapFrame.backdrop:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	SVUI_MinimapFrame.backdrop:SetGradient(unpack(MM_COLOR))

	local border = CreateFrame("Frame", nil, SVUI_MinimapFrame)
	border:WrapOuter(SVUI_MinimapFrame.backdrop)
	border.left = border:CreateTexture(nil,"BACKGROUND",nil,-1)
	border.left:SetTexture(0,0,0)
	border.left:SetPoint("TOPLEFT")
	border.left:SetPoint("BOTTOMLEFT")
	border.left:SetWidth(1)
	border.right = border:CreateTexture(nil,"BACKGROUND",nil,-1)
	border.right:SetTexture(0,0,0)
	border.right:SetPoint("TOPRIGHT")
	border.right:SetPoint("BOTTOMRIGHT")
	border.right:SetWidth(1)
	border.top = border:CreateTexture(nil,"BACKGROUND",nil,-1)
	border.top:SetTexture(0,0,0)
	border.top:SetPoint("TOPLEFT")
	border.top:SetPoint("TOPRIGHT")
	border.top:SetHeight(1)
	border.bottom = border:CreateTexture(nil,"BACKGROUND",nil,-1)
	border.bottom:SetTexture(0,0,0)
	border.bottom:SetPoint("BOTTOMLEFT")
	border.bottom:SetPoint("BOTTOMRIGHT")
	border.bottom:SetHeight(1)

	MOD:RefreshMiniMap()

	Minimap:SetQuestBlobRingAlpha(0) 
	Minimap:SetArchBlobRingAlpha(0)
	Minimap:SetParent(SVUI_MinimapFrame)
	Minimap:SetFrameLevel(Minimap:GetFrameLevel() + 2)
	ShowUIPanel(SpellBookFrame)
	HideUIPanel(SpellBookFrame)
	MinimapBorder:Hide()
	MinimapBorderTop:Hide()
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()
	MiniMapVoiceChatFrame:Hide()
	MinimapNorthTag:MUNG()
	GameTimeFrame:Hide()
	MinimapZoneTextButton:Hide()
	MiniMapTracking:Hide()
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:Point("TOPRIGHT", SVUI_MinimapFrame, 3, 4)
	MiniMapMailBorder:Hide()
	MiniMapMailIcon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP-MAIL")
	MiniMapWorldMapButton:Hide()
	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:SetParent(Minimap)
	MiniMapInstanceDifficulty:Point("BOTTOMLEFT", SVUI_MinimapFrame, "BOTTOMLEFT", 0, 0)
	GuildInstanceDifficulty:ClearAllPoints()
	GuildInstanceDifficulty:SetParent(Minimap)
	GuildInstanceDifficulty:Point("BOTTOMLEFT", SVUI_MinimapFrame, "BOTTOMLEFT", 0, 0)
	MiniMapChallengeMode:ClearAllPoints()
	MiniMapChallengeMode:SetParent(Minimap)
	MiniMapChallengeMode:Point("BOTTOMLEFT", SVUI_MinimapFrame, "BOTTOMLEFT", 8, -8)
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:Point("BOTTOMLEFT", SVUI_MinimapFrame, "BOTTOMLEFT", 6, 5)
	QueueStatusMinimapButton:SetPanelTemplate("Button",false,1,-2,-2)
	QueueStatusFrame:SetClampedToScreen(true)
	QueueStatusMinimapButtonBorder:Hide()
	QueueStatusMinimapButton:SetScript("OnShow",function()
		MiniMapInstanceDifficulty:Point("BOTTOMLEFT", QueueStatusMinimapButton, "TOPLEFT", 0, 0)
		GuildInstanceDifficulty:Point("BOTTOMLEFT", QueueStatusMinimapButton, "BOTTOMLEFT", 0, 0)
		MiniMapChallengeMode:Point("BOTTOMLEFT", QueueStatusMinimapButton, "BOTTOMLEFT", 0, 0)
	end)
	QueueStatusMinimapButton:SetScript("OnHide",function()
		MiniMapInstanceDifficulty:Point("BOTTOMLEFT", SVUI_MinimapFrame, "BOTTOMLEFT", 0, 0)
		GuildInstanceDifficulty:Point("BOTTOMLEFT", SVUI_MinimapFrame, "BOTTOMLEFT", 0, 0)
		MiniMapChallengeMode:Point("BOTTOMLEFT", SVUI_MinimapFrame, "BOTTOMLEFT", 8, -8)
	end)
	if FeedbackUIButton then
		FeedbackUIButton:MUNG()
	end

	local mwfont = SuperVillain.Media.font.dialog

	SVUI_MinimapNarrator:Point("TOPLEFT", SVUI_MinimapFrame, "TOPLEFT", 2, -2)
	SVUI_MinimapNarrator:SetSize(100,22)
	SVUI_MinimapNarrator:SetFixedPanelTemplate("Component", true)
    SVUI_MinimapNarrator:SetPanelColor("yellow")
    SVUI_MinimapNarrator:SetBackdropColor(1,1,0,1)
	SVUI_MinimapNarrator:SetFrameLevel(Minimap:GetFrameLevel() + 2)
	SVUI_MinimapNarrator:SetParent(Minimap)

	SVUI_MinimapNarrator.Text = SVUI_MinimapNarrator:CreateFontString(nil, "ARTWORK", nil, 7)
	SVUI_MinimapNarrator.Text:SetFontTemplate(mwfont, 12, "OUTLINE", "CENTER", "MIDDLE")
	SVUI_MinimapNarrator.Text:SetAllPoints(SVUI_MinimapNarrator)
	SVUI_MinimapNarrator.Text:SetTextColor(1,1,1)
	SVUI_MinimapNarrator.Text:SetShadowColor(0,0,0,0.3)
	SVUI_MinimapNarrator.Text:SetShadowOffset(2,-2)

	SVUI_MinimapZonetext:Point("BOTTOMRIGHT", SVUI_MinimapFrame, "BOTTOMRIGHT", 2, -3)
	SVUI_MinimapZonetext:SetSize(MM_WIDTH,28)
	SVUI_MinimapZonetext:SetFrameLevel(Minimap:GetFrameLevel() + 1)
	SVUI_MinimapZonetext:SetParent(Minimap)

	SVUI_MinimapZonetext.Text = SVUI_MinimapZonetext:CreateFontString(nil, 'ARTWORK', nil, 7)
	SVUI_MinimapZonetext.Text:SetFontTemplate(mwfont, 12, "OUTLINE", "RIGHT", "MIDDLE")
	SVUI_MinimapZonetext.Text:Point("RIGHT",SVUI_MinimapZonetext)
	SVUI_MinimapZonetext.Text:SetSize(MM_WIDTH,32)
	SVUI_MinimapZonetext.Text:SetTextColor(1,1,0)
	SVUI_MinimapZonetext.Text:SetShadowColor(0,0,0,0.3)
	SVUI_MinimapZonetext.Text:SetShadowOffset(-2,2)

	MOD:UpdateMinimapTexts()

	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", MiniMap_MouseWheel)	
	Minimap:SetScript("OnMouseUp", MiniMap_MouseUp)

	local info = UIPanelWindows['PetJournalParent'];
	for name, value in pairs(info) do
		PetJournalParent:SetAttribute("UIPanelLayout-"..name, value);
	end	
	PetJournalParent:SetAttribute("UIPanelLayout-defined", true);
	SuperVillain:SetSVMovable(SVUI_MinimapFrame, 'Minimap_MOVE', L['Minimap'])
end
--[[ 
########################################################## 
HOOKED / REGISTERED FUNCTIONS
##########################################################
]]--
function MOD:ADDON_LOADED(event, addon)
	if TimeManagerClockButton then
		TimeManagerClockButton:MUNG()
	end
	self:UnregisterEvent("ADDON_LOADED")
	if addon == "Blizzard_FeedbackUI" then
		FeedbackUIButton:MUNG()
	end
	if(MOD.db.minimapbar.enable) then
		SuperVillain:ExecuteTimer(MOD.StyleMinimapButtons, 5)
	end;
end;
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:ReLoad()
	if(not SuperVillain.db.SVMap.enable) then return; end
	self:RefreshMiniMap()
end

function MOD:Load()
	if(not SuperVillain.db.SVMap.enable) then 
		Minimap:SetMaskTexture('Textures\\MinimapMask')
		return; 
	end
	self:Protect("RefreshMiniMap")
	self:CreateMiniMapElements();
	self:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateMinimapLocation)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", UpdateMinimapLocation)
	self:RegisterEvent("ZONE_CHANGED", UpdateMinimapLocation)
	self:RegisterEvent("ZONE_CHANGED_INDOORS", UpdateMinimapLocation)		
	self:RegisterEvent('ADDON_LOADED')
	self:LoadMinimapButtons()
	self:LoadWorldMap()
	self:SetMiniMapCoords()
	self:ReLoad()
	SuperVillain:AddToDisplayAudit(SVUI_MinimapFrame)
end
SuperVillain.Registry:NewPackage(MOD, "SVMap", "pre")