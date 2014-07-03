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
local type 		= _G.type;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local format, split = string.format, string.split;
--[[ MATH METHODS ]]--
local min, floor = math.min, math.floor;
local parsefloat = math.parsefloat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
SuperVillain.MentaloFrames = {}
local Sticky = {};
Sticky.scripts = Sticky.scripts or {}
Sticky.rangeX = 15
Sticky.rangeY = 15
Sticky.sticky = Sticky.sticky or {}

local function SnapStickyFrame(frameA, frameB, left, top, right, bottom)
	local sA, sB = frameA:GetEffectiveScale(), frameB:GetEffectiveScale()
	local xA, yA = frameA:GetCenter()
	local xB, yB = frameB:GetCenter()
	local hA, hB = frameA:GetHeight()  /  2, ((frameB:GetHeight()  *  sB)  /  sA)  /  2
	local wA, wB = frameA:GetWidth()  /  2, ((frameB:GetWidth()  *  sB)  /  sA)  /  2
	local newX, newY = xA, yA
	if not left then left = 0 end
	if not top then top = 0 end
	if not right then right = 0 end
	if not bottom then bottom = 0 end
	if not xB or not yB or not sB or not sA or not sB then return end
	xB, yB = (xB * sB)  /  sA, (yB * sB)  /  sA
	local stickyAx, stickyAy = wA  *  0.75, hA  *  0.75
	local stickyBx, stickyBy = wB  *  0.75, hB  *  0.75
	local lA, tA, rA, bA = frameA:GetLeft(), frameA:GetTop(), frameA:GetRight(), frameA:GetBottom()
	local lB, tB, rB, bB = frameB:GetLeft(), frameB:GetTop(), frameB:GetRight(), frameB:GetBottom()
	local snap = nil
	lB, tB, rB, bB = (lB  *  sB)  /  sA, (tB  *  sB)  /  sA, (rB  *  sB)  /  sA, (bB  *  sB)  /  sA
	if (bA  <= tB and bB  <= tA) then
		if xA  <= (xB  +  Sticky.rangeX) and xA  >= (xB - Sticky.rangeX) then
			newX = xB
			snap = true
		end
		if lA  <= (lB  +  Sticky.rangeX) and lA  >= (lB - Sticky.rangeX) then
			newX = lB  +  wA
			if frameB == UIParent or frameB == WorldFrame or frameB == SVUIParent then 
				newX = newX  +  4
			end
			snap = true
		end
		if rA  <= (rB  +  Sticky.rangeX) and rA  >= (rB - Sticky.rangeX) then
			newX = rB - wA
			if frameB == UIParent or frameB == WorldFrame or frameB == SVUIParent then 
				newX = newX - 4
			end
			snap = true
		end
		if lA  <= (rB  +  Sticky.rangeX) and lA  >= (rB - Sticky.rangeX) then
			newX = rB  +  (wA - left)
			snap = true
		end
		if rA  <= (lB  +  Sticky.rangeX) and rA  >= (lB - Sticky.rangeX) then
			newX = lB - (wA - right)
			snap = true
		end
	end
	if (lA  <= rB and lB  <= rA) then
		if yA  <= (yB  +  Sticky.rangeY) and yA  >= (yB - Sticky.rangeY) then
			newY = yB
			snap = true
		end
		if tA  <= (tB  +  Sticky.rangeY) and tA  >= (tB - Sticky.rangeY) then
			newY = tB - hA
			if frameB == UIParent or frameB == WorldFrame or frameB == SVUIParent then 
				newY = newY - 4
			end
			snap = true
		end
		if bA  <= (bB  +  Sticky.rangeY) and bA  >= (bB - Sticky.rangeY) then
			newY = bB  +  hA
			if frameB == UIParent or frameB == WorldFrame or frameB == SVUIParent then 
				newY = newY  +  4
			end
			snap = true
		end
		if tA  <= (bB  +  Sticky.rangeY  +  bottom) and tA  >= (bB - Sticky.rangeY  +  bottom) then
			newY = bB - (hA - top)
			snap = true
		end
		if bA  <= (tB  +  Sticky.rangeY - top) and bA  >= (tB - Sticky.rangeY - top) then
			newY = tB  +  (hA - bottom)
			snap = true
		end
	end
	if snap then
		frameA:ClearAllPoints()
		frameA:SetPoint("CENTER", UIParent, "BOTTOMLEFT", newX, newY)
		return true
	end
end

local function GetStickyUpdate(frame, frameList, xoffset, yoffset, left, top, right, bottom)
	return function()
		local x, y = GetCursorPosition()
		local s = frame:GetEffectiveScale()
		local sticky = nil
		x, y = x / s, y / s
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x + xoffset, y + yoffset)
		Sticky.sticky[frame] = nil
		for i = 1, #frameList do
			local v = frameList[i]
			if frame  ~= v and frame  ~= v:GetParent() and not IsShiftKeyDown() and v:IsVisible() then
				if SnapStickyFrame(frame, v, left, top, right, bottom) then
					Sticky.sticky[frame] = v
					break
				end
			end
		end
	end
end

function Sticky:StartMoving(frame, frameList, left, top, right, bottom)
	local x, y = GetCursorPosition()
	local aX, aY = frame:GetCenter()
	local aS = frame:GetEffectiveScale()
	aX, aY = aX * aS, aY * aS
	local xoffset, yoffset = (aX - x), (aY - y)
	self.scripts[frame] = frame:GetScript("OnUpdate")
	frame:SetScript("OnUpdate", GetStickyUpdate(frame, frameList, xoffset, yoffset, left, top, right, bottom))
end

function Sticky:StopMoving(frame)
	frame:SetScript("OnUpdate", self.scripts[frame])
	self.scripts[frame] = nil
	if self.sticky[frame] then
		local sticky = self.sticky[frame]
		self.sticky[frame] = nil
		return true, sticky
	else
		return false, nil
	end
end
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local CurrentFrameTarget = false;
local UpdateFrameTarget = false;
local userHolding = false;
local HandledFrames = {};
local DraggableFrames = {
	"AchievementFrame",
	"AuctionFrame",
	"ArchaeologyFrame",
	"BattlefieldMinimap",
	"BarberShopFrame",
	"BlackMarketFrame",
	"CalendarFrame",
	"CharacterFrame",
	"ClassTrainerFrame",
	"DressUpFrame",
	"EncounterJournal",
	"FriendsFrame",
	"GameMenuFrame",
	"GMSurveyFrame",
	"GossipFrame",
	"GuildFrame",
	"GuildBankFrame",
	"GuildRegistrarFrame",
	"HelpFrame",
	"InterfaceOptionsFrame",
	"ItemUpgradeFrame",
	"KeyBindingFrame",
	"LFGDungeonReadyPopup",
	"LossOfControlFrame",
	"MacOptionsFrame",
	"MacroFrame",
	"MailFrame",
	"MerchantFrame",
	"PlayerTalentFrame",
	"PetJournalParent",
	"PVEFrame",
	"PVPFrame",
	"QuestFrame",
	"QuestLogFrame",
	"RaidBrowserFrame",
	"ReadyCheckFrame",
	"ReforgingFrame",
	"ReportCheatingDialog",
	"ReportPlayerNameDialog",
	"RolePollPopup",
	"ScrollOfResurrectionSelectionFrame",
	"SpellBookFrame",
	"TabardFrame",
	"TaxiFrame",
	"TimeManagerFrame",
	"TradeSkillFrame",
	"TradeFrame",
	"TransmorgifyFrame",
	"TutorialFrame",
	"VideoOptionsFrame",
	"VoidStorageFrame",
	--"WorldStateAlwaysUpFrame"
};

local theHand = CreateFrame("Frame", "SVUI_HandOfMentalo", SuperVillain.UIParent)
theHand:SetFrameStrata("DIALOG")
theHand:SetFrameLevel(99)
theHand:SetClampedToScreen(true)
theHand:SetSize(128,128)
theHand:SetPoint("CENTER")
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function Pinpoint(parent)
    local centerX, centerY = parent:GetCenter()
    local screenWidth = GetScreenWidth()
    local screenHeight = GetScreenHeight()
    local result;
    if not centerX or not centerY then 
        return "CENTER"
    end 
    local heightTop = screenHeight  *  0.75;
    local heightBottom = screenHeight  *  0.25;
    local widthLeft = screenWidth  *  0.25;
    local widthRight = screenWidth  *  0.75;
    if(((centerX > widthLeft) and (centerX < widthRight)) and (centerY > heightTop)) then 
        result = "TOP"
    elseif((centerX < widthLeft) and (centerY > heightTop)) then 
        result = "TOPLEFT"
    elseif((centerX > widthRight) and (centerY > heightTop)) then 
        result = "TOPRIGHT"
    elseif(((centerX > widthLeft) and (centerX < widthRight)) and centerY < heightBottom) then 
        result = "BOTTOM"
    elseif((centerX < widthLeft) and (centerY < heightBottom)) then 
        result = "BOTTOMLEFT"
    elseif((centerX > widthRight) and (centerY < heightBottom)) then 
        result = "BOTTOMRIGHT"
    elseif((centerX < widthLeft) and (centerY > heightBottom) and (centerY < heightTop)) then 
        result = "LEFT"
    elseif((centerX > widthRight) and (centerY < heightTop) and (centerY > heightBottom)) then 
        result = "RIGHT"
    else 
        result = "CENTER"
    end 
    return result 
end 

local function TheHand_SetPos(frame)
	theHand:SetPoint("CENTER", frame, "TOP", 0, 0) 
end

local TheHand_OnUpdate = function(self, elapsed)
	self.elapsedTime = self.elapsedTime  +  elapsed
	if self.elapsedTime > 0.1 then
		self.elapsedTime = 0
		local x, y = GetCursorPosition()
		local scale = SuperVillain.UIParent:GetEffectiveScale()
		self:SetPoint("CENTER", SuperVillain.UIParent, "BOTTOMLEFT", (x  /  scale)  +  50, (y  /  scale)  +  50)
	end 
end

local function EnableTheHand()
	theHand:Show()
	theHand.bg:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\MENTALO-HAND-ON]])
	theHand.energy:Show()
	theHand.flash:Play()
	theHand:SetScript("OnUpdate", TheHand_OnUpdate) 
end

local function DisableTheHand()
	theHand.flash:Stop()
	theHand.energy:Hide()
	theHand.bg:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\MENTALO-HAND-OFF]])
	theHand:SetScript("OnUpdate", nil)
	theHand.elapsedTime = 0
	theHand:Hide()
end

local function Mentalo_OnSizeChanged(frame)
	if InCombatLockdown()then return end 
	if frame.dirtyWidth and frame.dirtyHeight then 
		frame.Avatar:Size(frame.dirtyWidth, frame.dirtyHeight)
	else 
		frame.Avatar:Size(frame:GetSize())
	end 
end

local function MakeMovable(frame)
	if HandledFrames then 
		for _, f in pairs(HandledFrames)do 
			if frame:GetName() == f then return end 
		end 
	end 
	if SVUI and frame:GetName() == "LossOfControlFrame" then return end 
	frame:EnableMouse(true)
	if frame:GetName() == "LFGDungeonReadyPopup" then 
		LFGDungeonReadyDialog:EnableMouse(false)
	end 
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetClampedToScreen(true)
	frame:HookScript("OnUpdate", function(this)
		if InCombatLockdown() or this:GetName() == "GameMenuFrame" then return end 
		if this.IsMoving then return end 
		this:ClearAllPoints()
		if this:GetName() == "QuestFrame" then 
			if SVUI_Cache["Mentalo"]["GossipFrame"].Points  ~= nil then 
				this:SetPoint(unpack(SVUI_Cache["Mentalo"]["GossipFrame"].Points))
			end 
		elseif SVUI_Cache["Mentalo"][this:GetName()].Points  ~= nil then 
			this:SetPoint(unpack(SVUI_Cache["Mentalo"][this:GetName()].Points))
		end 
	end)
	frame:SetScript("OnDragStart", function(this)
		if not this:IsMovable() then return end 
		this:StartMoving()
		this.IsMoving = true 
	end)
	frame:SetScript("OnDragStop", function(this)
		if not this:IsMovable() then return end 
		this.IsMoving = false;
		this:StopMovingOrSizing()
		if this:GetName() == "GameMenuFrame"then return end 
		local anchor1, parent, anchor2, x, y = this:GetPoint()
		parent = this:GetParent():GetName()
		this:ClearAllPoints()
		this:SetPoint(anchor1, parent, anchor2, x, y)
		if this:GetName() == "QuestFrame" then 
			SVUI_Cache["Mentalo"]["GossipFrame"].Points = {anchor1, parent, anchor2, x, y}
		else 
			SVUI_Cache["Mentalo"][this:GetName()].Points = {anchor1, parent, anchor2, x, y}
		end 
	end)
	tinsert(HandledFrames, frame:GetName())
end 

local function GrabUsableRegions(frame)
	local parent = frame or SuperVillain.UIParent
	local right = parent:GetRight()
	local top = parent:GetTop()
	local center = parent:GetCenter()
	return right, top, center
end 

local function FindLoc(frame)
	if not frame then return end 
	local anchor1, parent, anchor2, x, y = frame:GetPoint()
	if not parent then 
		parent = SVUIParent 
	end 
	return format("%s\031%s\031%s\031%d\031%d", anchor1, parent:GetName(), anchor2, parsefloat(x), parsefloat(y))
end

local function ghost(list, alpha)
	local frame;
	for f, _ in pairs(list)do 
		frame = _G[f]
		if frame then 
			frame:SetAlpha(alpha)
		end 
	end 
end 

local function SetSVMovable(frame, moveName, title, raised, snap, dragStopFunc)
	if not frame then return end 
	if SuperVillain.MentaloFrames[moveName].Created then return end 
	if raised == nil then raised = true end 
	local movable = CreateFrame("Button", moveName, SuperVillain.UIParent)
	movable:SetFrameLevel(frame:GetFrameLevel()   +   1)
	movable:SetClampedToScreen(true)
	movable:SetWidth(frame:GetWidth())
	movable:SetHeight(frame:GetHeight())
	movable.parent = frame;
	movable.name = moveName;
	movable.textString = title;
	movable.postdrag = dragStopFunc;
	movable.overlay = raised;
	movable.snapOffset = snap or -2;
	SuperVillain.MentaloFrames[moveName].Avatar = movable;
	SuperVillain["snaps"][#SuperVillain["snaps"] + 1] = movable;
	if raised == true then 
		movable:SetFrameStrata("DIALOG")
	else 
		movable:SetFrameStrata("BACKGROUND")
	end 
	local anchor1, anchorParent, anchor2, xPos, yPos = split("\031", FindLoc(frame))
	if SuperVillain.db.framelocations and SuperVillain.db.framelocations[moveName] then 
		if type(SuperVillain.db.framelocations[moveName]) == "table"then 
			movable:SetPoint(SuperVillain.db.framelocations[moveName]["p"], SuperVillain.UIParent, SuperVillain.db.framelocations[moveName]["p2"], SuperVillain.db.framelocations[moveName]["p3"], SuperVillain.db.framelocations[moveName]["p4"])
			SuperVillain.db.framelocations[moveName] = FindLoc(movable)
			movable:ClearAllPoints()
		end 
		anchor1, anchorParent, anchor2, xPos, yPos = split("\031", SuperVillain.db.framelocations[moveName])
		movable:SetPoint(anchor1, anchorParent, anchor2, xPos, yPos)
	else 
		movable:SetPoint(anchor1, anchorParent, anchor2, xPos, yPos)
	end 
	movable:SetFixedPanelTemplate("Transparent")
	movable:SetAlpha(0.4)
	movable:RegisterForDrag("LeftButton", "RightButton")
	movable:SetScript("OnDragStart", function(this)
		if InCombatLockdown()then SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT)return end 
		if SuperVillain.db["system"].stickyFrames then 
			Sticky:StartMoving(this, SuperVillain["snaps"], movable.snapOffset, movable.snapOffset, movable.snapOffset, movable.snapOffset)
		else 
			this:StartMoving()
		end 
		UpdateFrameTarget = this;
		_G["SVUI_MentaloEventHandler"]:Show()
		EnableTheHand()
		userHolding = true 
	end)
	movable:SetScript("OnMouseUp", SuperVillain.MovableFocused)
	movable:SetScript("OnDragStop", function(this)
		if InCombatLockdown()then SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT)return end 
		userHolding = false;
		if SuperVillain.db["system"].stickyFrames then 
			Sticky:StopMoving(this)
		else 
			this:StopMovingOrSizing()
		end 
		local pR, pT, pC = GrabUsableRegions()
		local cX, cY = this:GetCenter()
		local newAnchor;
		if cY   >= (pT   /   2) then 
			newAnchor = "TOP"; 
			cY = (-(pT - this:GetTop()))
		else 
			newAnchor = "BOTTOM"
			cY = this:GetBottom()
		end 
		if cX   >= ((pR   *   2)   /   3) then 
			newAnchor = newAnchor.."RIGHT"
			cX = this:GetRight() - pR 
		elseif cX   <= (pR   /   3) then 
			newAnchor = newAnchor.."LEFT"
			cX = this:GetLeft()
		else 
			cX = cX - pC 
		end 
		if this.positionOverride then 
			this.parent:ClearAllPoints()
			this.parent:Point(this.positionOverride, this, this.positionOverride)
		end 
		this:ClearAllPoints()
		this:Point(newAnchor, SuperVillain.UIParent, newAnchor, cX, cY)
		SuperVillain:SaveMovableLoc(moveName)
		if SVUI_MentaloPrecision then 
			SuperVillain:MentaloFocusUpdate(this)
		end 
		UpdateFrameTarget = nil;
		_G["SVUI_MentaloEventHandler"]:Hide()
		if dragStopFunc  ~= nil and type(dragStopFunc) == "function" then 
			dragStopFunc(this, Pinpoint(this))
		end 
		this:SetUserPlaced(false)
		DisableTheHand()
	end)

	frame:SetScript("OnSizeChanged", Mentalo_OnSizeChanged)
	frame.Avatar = movable;
	frame:ClearAllPoints()
	frame:SetPoint(anchor1, movable, 0, 0)

	local u = movable:CreateFontString(nil, "OVERLAY")
	u:SetFontTemplate()
	u:SetJustifyH("CENTER")
	u:SetPoint("CENTER")
	u:SetText(title or moveName)
	u:SetTextColor(unpack(SuperVillain.Media.color.highlight))

	movable:SetFontString(u)
	movable.text = u;
	movable:SetScript("OnEnter", function(this)
		if userHolding then return end 
		this:SetAlpha(1)
		this.text:SetTextColor(1, 1, 1)
		UpdateFrameTarget = this;
		_G["SVUI_MentaloEventHandler"]:GetScript("OnUpdate")(_G["SVUI_MentaloEventHandler"])
		SVUI_Mentalo.Avatar:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\MENTALO-ON]])
		TheHand_SetPos(this)
		theHand:Show()
		if CurrentFrameTarget  ~= this then 
			SVUI_MentaloPrecision:Hide()
			SuperVillain.MovableFocused(this)
		end 
	end)
	movable:SetScript("OnMouseDown", function(this, arg)
		if arg == "RightButton"then 
			userHolding = false;
			SVUI_MentaloPrecision:Show()
			if SuperVillain.db["system"].stickyFrames then 
				Sticky:StopMoving(this)
			else 
				this:StopMovingOrSizing()
			end 
		end 
	end)
	movable:SetScript("OnLeave", function(this)
		if userHolding then return end 
		this:SetAlpha(0.4)
		this.text:SetTextColor(unpack(SuperVillain.Media.color.highlight))
		SVUI_Mentalo.Avatar:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\MENTALO-OFF]])
		theHand:Hide()
	end)
	movable:SetScript("OnShow", function(this)this:SetBackdropBorderColor(unpack(SuperVillain.Media.color.highlight))end)
	movable:SetMovable(true)
	movable:Hide()
	if dragStopFunc  ~= nil and type(dragStopFunc) == "function"then 
		movable:RegisterEvent("PLAYER_ENTERING_WORLD")
		movable:SetScript("OnEvent", function(this, event)
			dragStopFunc(movable, Pinpoint(movable))
			this:UnregisterAllEvents()
		end)
	end 
	SuperVillain.MentaloFrames[moveName].Created = true 
end 
--[[ 
########################################################## 
GLOBAL/MODULE FUNCTIONS
##########################################################
]]--
function SuperVillain:MentaloForced(frame)
	if _G[frame] and _G[frame]:GetScript("OnDragStop") then 
		_G[frame]:GetScript("OnDragStop")(_G[frame])
	end 
end 

function SuperVillain:TestMovableMoved(frame)
	if SuperVillain.db.framelocations and SuperVillain.db.framelocations[frame] then 
		return true 
	else 
		return false 
	end 
end 

function SuperVillain:SaveMovableLoc(frame)
	if not _G[frame] then return end 
	if not SuperVillain.db.framelocations then 
		SuperVillain.db.framelocations = {}
	end 
	SuperVillain.db.framelocations[frame] = FindLoc(_G[frame])
end 

function SuperVillain:SetSnapOffset(frame, snapOffset)
	if not _G[frame] or not SuperVillain.MentaloFrames[frame] then return end 
	SuperVillain.MentaloFrames[frame].Avatar.snapOffset = snapOffset or -2;
	SuperVillain.MentaloFrames[frame]["snapoffset"] = snapOffset or -2 
end 

function SuperVillain:SaveMovableOrigin(frame)
	if not _G[frame] then return end 
	SuperVillain.MentaloFrames[frame]["point"] = FindLoc(_G[frame])
	SuperVillain.MentaloFrames[frame]["postdrag"](_G[frame], Pinpoint(_G[frame]))
end 

function SuperVillain:SetSVMovable(frame, moveName, title, raised, snapOffset, dragStopFunc, movableGroup)
	if not movableGroup then movableGroup = "ALL, GENERAL" end 
	if SuperVillain.MentaloFrames[moveName] == nil then 
		SuperVillain.MentaloFrames[moveName] = {}
		SuperVillain.MentaloFrames[moveName]["parent"] = frame;
		SuperVillain.MentaloFrames[moveName]["text"] = title;
		SuperVillain.MentaloFrames[moveName]["overlay"] = raised;
		SuperVillain.MentaloFrames[moveName]["postdrag"] = dragStopFunc;
		SuperVillain.MentaloFrames[moveName]["snapoffset"] = snapOffset;
		SuperVillain.MentaloFrames[moveName]["point"] = FindLoc(frame)
		SuperVillain.MentaloFrames[moveName]["type"] = {}
		local group = {split(", ", movableGroup)}
		for i = 1, #group do 
			local this = group[i]
			SuperVillain.MentaloFrames[moveName]["type"][this] = true 
		end 
	end 
	SetSVMovable(frame, moveName, title, raised, snapOffset, dragStopFunc)
end 

function SuperVillain:ToggleMovables(enabled, configType)
	for frameName, _ in pairs(SuperVillain.MentaloFrames)do 
		if(_G[frameName]) then 
			local movable = _G[frameName] 
			if(not enabled) then 
				movable:Hide() 
			else 
				if SuperVillain.MentaloFrames[frameName]["type"][configType]then 
					movable:Show() 
				else 
					movable:Hide() 
				end 
			end 
		end 
	end 
end 

function SuperVillain:ResetMovables(request)
	if request == "" or request == nil then 
		for name, _ in pairs(SuperVillain.MentaloFrames)do 
			local frame = _G[name];
			if SuperVillain.MentaloFrames[name]["point"] then
				local u, v, w, x, y = split("\031", SuperVillain.MentaloFrames[name]["point"])
				frame:ClearAllPoints()
				frame:SetPoint(u, v, w, x, y)
				for arg, func in pairs(SuperVillain.MentaloFrames[name])do 
					if arg == "postdrag" and type(func) == "function" then 
						func(frame, Pinpoint(frame))
					end 
				end
			end 
		end 
		SuperVillain.db:SetDefault("framelocations") 
	else 
		for name, _ in pairs(SuperVillain.MentaloFrames)do
			if SuperVillain.MentaloFrames[name]["point"] then
				for arg1, arg2 in pairs(SuperVillain.MentaloFrames[name])do 
					local mover;
					if arg1 == "text" then 
						if request == arg2 then 
							local frame = _G[name]
							local u, v, w, x, y = split("\031", SuperVillain.MentaloFrames[name]["point"])
							frame:ClearAllPoints()
							frame:SetPoint(u, v, w, x, y)
							if SuperVillain.db.framelocations then 
								SuperVillain.db.framelocations[name] = nil 
							end 
							if (SuperVillain.MentaloFrames[name]["postdrag"] ~= nil and type(SuperVillain.MentaloFrames[name]["postdrag"]) == "function")then 
								SuperVillain.MentaloFrames[name]["postdrag"](frame, Pinpoint(frame))
							end 
						end 
					end 
				end
			end
		end 
	end 
end 

function SuperVillain:SetSVMovablesPositions()
	for name, _ in pairs(SuperVillain.MentaloFrames)do 
		local frame = _G[name];
		local anchor1, parent, anchor2, x, y;
		if frame then
			if (SuperVillain.db.framelocations and SuperVillain.db.framelocations[name] and type(SuperVillain.db.framelocations[name]) == "string") then 
				anchor1, parent, anchor2, x, y = split("\031", SuperVillain.db.framelocations[name])
				frame:ClearAllPoints()
				frame:SetPoint(anchor1, parent, anchor2, x, y)
			elseif SuperVillain.MentaloFrames[name]["point"] then 
				anchor1, parent, anchor2, x, y = split("\031", SuperVillain.MentaloFrames[name]["point"])
				frame:ClearAllPoints()
				frame:SetPoint(anchor1, parent, anchor2, x, y)
			end
		end
	end 
end 

function SuperVillain:LoadMovables()
	theHand.bg = theHand:CreateTexture(nil, "OVERLAY")
	theHand.bg:SetAllPoints(theHand)
	theHand.bg:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\MENTALO-HAND-OFF]])
	theHand.energy = theHand:CreateTexture(nil, "OVERLAY")
	theHand.energy:SetAllPoints(theHand)
	theHand.energy:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\MENTALO-ENERGY]])
	SuperVillain.Animate:Orbit(theHand.energy, 10)
	theHand.flash = theHand.energy.anim;
	theHand.energy:Hide()
	theHand.elapsedTime = 0;
	theHand.flash:Stop()
	theHand:Hide()

	for name, _ in pairs(SuperVillain.MentaloFrames)do 
		local parent, text, overlay, snapoffset, postdrag;
		for key, value in pairs(SuperVillain.MentaloFrames[name])do 
			if key == "parent"then 
				parent = value 
			elseif key == "text"then 
				text = value 
			elseif key == "overlay"then 
				overlay = value 
			elseif key == "snapoffset"then 
				snapoffset = value 
			elseif key == "postdrag"then 
				postdrag = value 
			end 
		end 
		SuperVillain:SetMentaloAlphas()
		SetSVMovable(parent, name, text, overlay, snapoffset, postdrag)
	end 
end 

function SuperVillain:UseMentalo(isConfigMode, configType)
	if(InCombatLockdown()) then return end 
	local enabled = false;
	if(isConfigMode  ~= nil and isConfigMode  ~= "") then 
		self.ConfigurationMode = isConfigMode 
	end 

	if(not self.ConfigurationMode) then
		if IsAddOnLoaded("SVUI_ConfigOMatic")then 
			LibStub("AceConfigDialog-3.0"):Close("SVUI")
			GameTooltip:Hide()
			self.ConfigurationMode = true 
		else 
			self.ConfigurationMode = false 
		end 
	else
		self.ConfigurationMode = false
	end

	if(SVUI_Mentalo:IsShown()) then
		SVUI_Mentalo:Hide()
	else
		SVUI_Mentalo:Show()
		enabled = true
	end

	if(not configType or (configType and type(configType)  ~= "string")) then 
		configType = "ALL" 
	end 

	self:ToggleMovables(enabled, configType)
end 

function SuperVillain:MentaloFocus()
	local frame = CurrentFrameTarget;
	local s, t, u = GrabUsableRegions()
	local v, w = frame:GetCenter()
	local x;
	local y = s / 3;
	local z = s * 2 / 3;
	local A = t / 2;
	if w >= A then x = "TOP"else x = "BOTTOM"end 
	if v >= z then x = x.."RIGHT"elseif v <= y then x = x.."LEFT"end 
	v = tonumber(SVUI_MentaloPrecisionSetX.CurrentValue)
	w = tonumber(SVUI_MentaloPrecisionSetY.CurrentValue)
	frame:ClearAllPoints()
	frame:Point(x, SuperVillain.UIParent, x, v, w)
	SuperVillain:SaveMovableLoc(frame.name)
end 

function SuperVillain:MentaloFocusUpdate(frame)
	local s, t, u = GrabUsableRegions()
	local v, w = frame:GetCenter()
	local y = (s / 3);
	local z = ((s * 2) / 3);
	local A = (t / 2);
	if w  >= A then w = -(t - frame:GetTop())else w = frame:GetBottom()end 
	if v >= z then v = (frame:GetRight() - s) elseif v  <= y then v = frame:GetLeft()else v = (v - u) end 
	v = parsefloat(v, 0)
	w = parsefloat(w, 0)
	SVUI_MentaloPrecisionSetX:SetText(v)
	SVUI_MentaloPrecisionSetY:SetText(w)
	SVUI_MentaloPrecisionSetX.CurrentValue = v;
	SVUI_MentaloPrecisionSetY.CurrentValue = w;
	SVUI_MentaloPrecision.Title:SetText(frame.textSting)
end 

function SuperVillain:MovableFocused()
	CurrentFrameTarget = self;
	SuperVillain:MentaloFocusUpdate(self)
end 

function SuperVillain:SetMentaloAlphas()
	hooksecurefunc(SuperVillain, "SetSVMovable", function(_, frame)
		frame.Avatar:SetAlpha(0.5)
	end)
	ghost(SuperVillain.MentaloFrames, 0.5)
end 
--[[ 
########################################################## 
XML FRAME SCRIPT HANDLERS
##########################################################
]]--
function SVUI_MoveEventHandler_OnEvent()
	for _, frame in pairs(DraggableFrames)do 
		if _G[frame] then
			if SVUI_Cache["Mentalo"][frame] == nil then 
				SVUI_Cache["Mentalo"][frame] = {}
			end 
			SVUI_Cache["Mentalo"]["GameMenuFrame"] = {}
			MakeMovable(_G[frame])
		end 
	end
end 

function SVUI_MentaloEventHandler_Update(self)
	_G["SVUI_MentaloEventHandler"] = self;
	local frame = UpdateFrameTarget;
	local rightPos, topPos, centerPos = GrabUsableRegions()
	local centerX, centerY = frame:GetCenter()
	local calc1 = rightPos  /  3;
	local calc2 = ((rightPos  *  2)  /  3);
	local calc3 = topPos  /  2;
	local anchor1, anchor2;
	if centerY  >= calc3 then 
		anchor1 = "TOP"
		anchor2 = "BOTTOM"
		centerY = -(topPos - frame:GetTop())
	else 
		anchor1 = "BOTTOM"
		anchor2 = "TOP"
		centerY = frame:GetBottom()
	end 
	if centerX  >= calc2 then 
		anchor1 = "RIGHT"
		anchor2 = "LEFT"
		centerX = (frame:GetRight() - rightPos) 
	elseif centerX  <= calc1 then 
		anchor1 = "LEFT"
		anchor2 = "RIGHT"
		centerX = frame:GetLeft()
	else 
		centerX = (centerX - centerPos) 
	end 
	SVUI_MentaloPrecision:ClearAllPoints()
	SVUI_MentaloPrecision:SetPoint(anchor1, frame, anchor2, 0, 0)
	SuperVillain:MentaloFocusUpdate(frame)
end 

function SVUI_Mentalo_OnLoad()
	_G["SVUI_Mentalo"]:RegisterEvent("PLAYER_REGEN_DISABLED")
	_G["SVUI_Mentalo"]:RegisterForDrag("LeftButton");
	_G["SVUI_Mentalo"]:SetButtonTemplate()
end 

function SVUI_Mentalo_OnEvent()
	if _G["SVUI_Mentalo"]:IsShown() then 
		_G["SVUI_Mentalo"]:Hide()
		SuperVillain:UseMentalo(true)
	end
end 

function SVUI_MentaloLockButton_OnClick()
	SuperVillain:UseMentalo(true)
	if IsAddOnLoaded("SVUI_ConfigOMatic")then 
		LibStub("AceConfigDialog-3.0"):Open("SVUI")
	end 
end 

function SVUI_MentaloPrecisionResetButton_OnClick()
	local name = CurrentFrameTarget.name
	SuperVillain:ResetMovables(name)
end 

function SVUI_MentaloPrecisionInput_EscapePressed(self)
	self:SetText(parsefloat(self.CurrentValue))
	EditBox_ClearFocus(self)
end 

function SVUI_MentaloPrecisionInput_EnterPressed(self)
	local txt = tonumber(self:GetText())
	if(txt) then 
		self.CurrentValue = txt;
		SuperVillain:MentaloFocus()
	end 
	self:SetText(parsefloat(self.CurrentValue))
	EditBox_ClearFocus(self)
end 

function SVUI_MentaloPrecisionInput_FocusLost(self)
	self:SetText(parsefloat(self.CurrentValue))
end 

function SVUI_MentaloPrecisionInput_OnShow(self)
	EditBox_ClearFocus(self)
	self:SetText(parsefloat(self.CurrentValue or 0))
end 

function SVUI_MentaloPrecision_OnLoad()
	_G["SVUI_MentaloPrecisionSetX"].CurrentValue = 0;
	_G["SVUI_MentaloPrecisionSetY"].CurrentValue = 0;
	_G["SVUI_MentaloPrecision"]:EnableMouse(true)
	_G["SVUI_MentaloPrecisionSetX"]:SetEditboxTemplate()
	_G["SVUI_MentaloPrecisionSetY"]:SetEditboxTemplate()
	_G["SVUI_MentaloPrecisionUpButton"]:SetButtonTemplate()
	_G["SVUI_MentaloPrecisionDownButton"]:SetButtonTemplate()
	_G["SVUI_MentaloPrecisionLeftButton"]:SetButtonTemplate()
	_G["SVUI_MentaloPrecisionRightButton"]:SetButtonTemplate()
	CurrentFrameTarget = false;
end 