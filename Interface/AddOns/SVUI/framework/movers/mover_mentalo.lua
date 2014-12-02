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
local SV = select(2, ...)
local L = SV.L;

local Mentalo = CreateFrame("Frame", nil)
Mentalo.Frames = {}
Mentalo.Blizzard = {}

local DraggableFrames = {
	"AchievementFrame", "AuctionFrame", "ArchaeologyFrame",
	"BattlefieldMinimap", "BarberShopFrame", "BlackMarketFrame",
	"CalendarFrame", "CharacterFrame", "ClassTrainerFrame",
	"DressUpFrame", "DraenorZoneAbilityFrame",
	"EncounterJournal",
	"FriendsFrame",
	"GMSurveyFrame", "GossipFrame", "GuildFrame", "GuildBankFrame", "GuildRegistrarFrame",
	"GarrisonLandingPage", "GarrisonMissionFrame", "GarrisonCapacitiveDisplayFrame",
	"HelpFrame",
	"InterfaceOptionsFrame",
	"ItemUpgradeFrame",
	"KeyBindingFrame",
	"LFGDungeonReadyPopup",
	"MacOptionsFrame", "MacroFrame", "MailFrame", "MerchantFrame",
	"PlayerTalentFrame", "PetJournalParent", "PetStableFrame", "PVEFrame", "PVPFrame",
	"QuestFrame", "QuestLogFrame",
	"RaidBrowserFrame", "ReadyCheckFrame", "ReforgingFrame", "ReportCheatingDialog", "ReportPlayerNameDialog", "RolePollPopup",
	"ScrollOfResurrectionSelectionFrame", "SpellBookFrame",
	"TabardFrame", "TaxiFrame", "TimeManagerFrame", "TradeSkillFrame", "TradeFrame", "TransmogrifyFrame", "TutorialFrame",
	"VideoOptionsFrame", "VoidStorageFrame",
	--"WorldStateAlwaysUpFrame"
};

local CenteredFrames = {
	["BattlefieldMinimap"] = {"TOP", "TOP", 0, -80},
	["CalendarFrame"] = {"TOP", "TOP", 0, -80},
	["GameMenuFrame"] = {"TOP", "TOP", 0, -80}, 
	["GMSurveyFrame"] = {"TOP", "TOP", 0, -80},
	["GarrisonLandingPage"] = {"TOP", "TOP", 0, -80}, 
	["GarrisonMissionFrame"] = {"TOP", "TOP", 0, -80},
	["HelpFrame"] = {"TOP", "TOP", 0, -80},
	["InterfaceOptionsFrame"] = {"TOP", "TOP", 0, -80},
	["KeyBindingFrame"] = {"TOP", "TOP", 0, -80},
	["LFGDungeonReadyPopup"] = {"TOP", "TOP", 0, -80},
	["MacOptionsFrame"] = {"TOP", "TOP", 0, -80},
	["ReadyCheckFrame"] = {"TOP", "TOP", 0, -80}, 
	["RolePollPopup"] = {"TOP", "TOP", 0, -80},
	["TutorialFrame"] = {"TOP", "TOP", 0, -80},
	["VideoOptionsFrame"] = {"TOP", "TOP", 0, -80},
};
--[[
  /$$$$$$   /$$     /$$           /$$                
 /$$__  $$ | $$    |__/          | $$                
| $$  \__//$$$$$$   /$$  /$$$$$$$| $$   /$$ /$$   /$$
|  $$$$$$|_  $$_/  | $$ /$$_____/| $$  /$$/| $$  | $$
 \____  $$ | $$    | $$| $$      | $$$$$$/ | $$  | $$
 /$$  \ $$ | $$ /$$| $$| $$      | $$_  $$ | $$  | $$
|  $$$$$$/ |  $$$$/| $$|  $$$$$$$| $$ \  $$|  $$$$$$$
 \______/   \___/  |__/ \_______/|__/  \__/ \____  $$
                                            /$$  | $$
                                           |  $$$$$$/
                                            \______/ 
--]]
local Sticky = {};
Sticky.Frames = {};
Sticky.Frames[1] = SV.Screen;
Sticky.scripts = Sticky.scripts or {}
Sticky.rangeX = 15
Sticky.rangeY = 15
Sticky.StuckTo = Sticky.StuckTo or {}

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

function Sticky:GetStickyUpdate(frame, xoffset, yoffset, left, top, right, bottom)
	return function()
		local x, y = GetCursorPosition()
		local s = frame:GetEffectiveScale()
		x, y = x / s, y / s
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x + xoffset, y + yoffset)
		self.StuckTo[frame] = nil
		for i = 1, #Sticky.Frames do
			local v = Sticky.Frames[i]
			if(frame ~= v and frame ~= v:GetParent() and not IsShiftKeyDown() and v:IsVisible()) then
				if SnapStickyFrame(frame, v, left, top, right, bottom) then
					self.StuckTo[frame] = v
					break
				end
			end
		end
	end
end

function Sticky:StartMoving(frame, left, top, right, bottom)
	local x, y = GetCursorPosition()
	local aX, aY = frame:GetCenter()
	local aS = frame:GetEffectiveScale()
	aX, aY = aX * aS, aY * aS
	local xoffset, yoffset = (aX - x), (aY - y)
	self.scripts[frame] = frame:GetScript("OnUpdate")
	frame:SetScript("OnUpdate", Sticky.GetStickyUpdate(Sticky, frame, xoffset, yoffset, left, top, right, bottom))
end

function Sticky:StopMoving(frame)
	frame:SetScript("OnUpdate", self.scripts[frame])
	self.scripts[frame] = nil
	if self.StuckTo[frame] then
		local frame2 = self.StuckTo[frame]
		self.StuckTo[frame] = nil
		return true, frame2
	else
		return false, nil
	end
end
--[[
 /$$      /$$                       /$$               /$$          
| $$$    /$$$                      | $$              | $$          
| $$$$  /$$$$  /$$$$$$  /$$$$$$$  /$$$$$$    /$$$$$$ | $$  /$$$$$$ 
| $$ $$/$$ $$ /$$__  $$| $$__  $$|_  $$_/   |____  $$| $$ /$$__  $$
| $$  $$$| $$| $$$$$$$$| $$  \ $$  | $$      /$$$$$$$| $$| $$  \ $$
| $$\  $ | $$| $$_____/| $$  | $$  | $$ /$$ /$$__  $$| $$| $$  | $$
| $$ \/  | $$|  $$$$$$$| $$  | $$  |  $$$$/|  $$$$$$$| $$|  $$$$$$/
|__/     |__/ \_______/|__/  |__/   \___/   \_______/|__/ \______/ 
--]]
local CurrentFrameTarget, UpdateFrameTarget;
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

local function CurrentPosition(frame)
	if not frame then return end 
	local anchor1, parent, anchor2, x, y = frame:GetPoint()
	if((not anchor1) or (not anchor2) or (not x) or (not y)) then
		local frameName = frame:GetName()
		if(CenteredFrames[frameName]) then
			anchor1, anchor2, x, y = unpack(CenteredFrames[frameName])
		else
			anchor1, anchor2, x, y = "TOPLEFT", "TOPLEFT", 160, -80
		end
	end
	
	local parentName
	if not parent then 
		parentName = "SVUIParent" 
	elseif not parent:GetName() then 
		parentName = "SVUI_Player" 
	else
		parentName = parent:GetName()
	end
	return ("%s\031%s\031%s\031%d\031%d"):format(anchor1, parentName, anchor2, parsefloat(x), parsefloat(y))
end

local function GrabUsableRegions(frame)
	local parent = frame or SV.Screen
	local right = parent:GetRight()
	local top = parent:GetTop()
	local center = parent:GetCenter()
	return right, top, center
end

local function CalculateOffsets(frame)
	if(not CurrentFrameTarget) then return end
	local right, top, center = GrabUsableRegions()
	local xOffset, yOffset = CurrentFrameTarget:GetCenter()
	local screenLeft = (right * 0.33);
	local screenRight = (right * 0.66);
	local topMedian = (top * 0.5);
	local anchor, a1, a2;

	if(yOffset >= (top * 0.5)) then
		a1 = "TOP"
		yOffset = -(top - CurrentFrameTarget:GetTop())
	else
		a1 = "BOTTOM"
		yOffset = CurrentFrameTarget:GetBottom()
	end 

	if xOffset >= screenRight then
		a2 = "RIGHT"
		xOffset = (CurrentFrameTarget:GetRight() - right) 
	elseif xOffset <= screenLeft then
		a2 = "LEFT"
		xOffset = CurrentFrameTarget:GetLeft() 
	else
		a2 = ""
		xOffset = (xOffset - center) 
	end 

	xOffset = parsefloat(xOffset, 0)
	yOffset = parsefloat(yOffset, 0)
	anchor = ("%s%s"):format(a1,a2)

	return xOffset, yOffset, anchor
end

local function ResetAllAlphas()
	for entry,_ in pairs(Mentalo.Frames) do
		local frame = _G[entry]
		if(frame) then 
			frame:SetAlpha(0.4)
		end 
	end 
end
--[[
 /$$$$$$$$/$$   /$$ /$$$$$$$$       /$$   /$$  /$$$$$$  /$$   /$$ /$$$$$$$ 
|__  $$__/ $$  | $$| $$_____/      | $$  | $$ /$$__  $$| $$$ | $$| $$__  $$
   | $$  | $$  | $$| $$            | $$  | $$| $$  \ $$| $$$$| $$| $$  \ $$
   | $$  | $$$$$$$$| $$$$$         | $$$$$$$$| $$$$$$$$| $$ $$ $$| $$  | $$
   | $$  | $$__  $$| $$__/         | $$__  $$| $$__  $$| $$  $$$$| $$  | $$
   | $$  | $$  | $$| $$            | $$  | $$| $$  | $$| $$\  $$$| $$  | $$
   | $$  | $$  | $$| $$$$$$$$      | $$  | $$| $$  | $$| $$ \  $$| $$$$$$$/
   |__/  |__/  |__/|________/      |__/  |__/|__/  |__/|__/  \__/|_______/ 
--]]
local TheHand = CreateFrame("Frame", "SVUI_HandOfMentalo", SV.Screen)
TheHand:SetFrameStrata("DIALOG")
TheHand:SetFrameLevel(99)
TheHand:SetClampedToScreen(true)
TheHand:SetSize(128,128)
TheHand:SetPoint("CENTER")
TheHand.bg = TheHand:CreateTexture(nil, "OVERLAY")
TheHand.bg:SetAllPoints(TheHand)
TheHand.bg:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\MENTALO-HAND-OFF]])
TheHand.energy = TheHand:CreateTexture(nil, "OVERLAY")
TheHand.energy:SetAllPoints(TheHand)
TheHand.energy:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\MENTALO-ENERGY]])
SV.Animate:Orbit(TheHand.energy, 10)
TheHand.flash = TheHand.energy.anim;
TheHand.energy:Hide()
TheHand.elapsedTime = 0;
TheHand.flash:Stop()
TheHand:Hide()
TheHand.UserHeld = false;

local TheHand_OnUpdate = function(self, elapsed)
	self.elapsedTime = self.elapsedTime  +  elapsed
	if self.elapsedTime > 0.1 then
		self.elapsedTime = 0
		local x, y = GetCursorPosition()
		local scale = SV.Screen:GetEffectiveScale()
		self:SetPoint("CENTER", SV.Screen, "BOTTOMLEFT", (x  /  scale)  +  50, (y  /  scale)  +  50)
	end 
end

function TheHand:Enable()
	self:Show()
	self.bg:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\MENTALO-HAND-ON]])
	self.energy:Show()
	self.flash:Play()
	self:SetScript("OnUpdate", TheHand_OnUpdate) 
end

function TheHand:Disable()
	self.flash:Stop()
	self.energy:Hide()
	self.bg:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\MENTALO-HAND-OFF]])
	self:SetScript("OnUpdate", nil)
	self.elapsedTime = 0
	self:Hide()
end
--[[ 
########################################################## 
HANDLERS
##########################################################
]]--
local MentaloUpdateHandler = CreateFrame("Frame", nil)

local Movable_OnMouseUp = function(self)
	CurrentFrameTarget = self;
	local xOffset, yOffset, anchor = CalculateOffsets()

	SVUI_MentaloPrecisionSetX.CurrentValue = xOffset;
	SVUI_MentaloPrecisionSetX:SetText(xOffset)
	
	SVUI_MentaloPrecisionSetY.CurrentValue = yOffset;
	SVUI_MentaloPrecisionSetY:SetText(yOffset)

	SVUI_MentaloPrecision.Title:SetText(self.textString)
end

local Movable_OnUpdate = function(self)
	local frame = UpdateFrameTarget;
	if not frame then return end
	local rightPos, topPos, centerPos = GrabUsableRegions()
	local centerX, centerY = frame:GetCenter()
	local calc1 = rightPos * 0.33;
	local calc2 = rightPos * 0.66;
	local calc3 = topPos * 0.5;
	local anchor1, anchor2;
	if centerY >= calc3 then 
		anchor1 = "TOP"
		anchor2 = "BOTTOM"
		centerY = -4
	else 
		anchor1 = "BOTTOM"
		anchor2 = "TOP"
		centerY = 4
	end 
	if centerX >= calc2 then 
		anchor1 = "RIGHT"
		anchor2 = "LEFT"
		centerX = -4 
	elseif centerX <= calc1 then 
		anchor1 = "LEFT"
		anchor2 = "RIGHT"
		centerX = 4
	else 
		centerX = 0
	end 
	SVUI_MentaloPrecision:ClearAllPoints()
	SVUI_MentaloPrecision:SetPoint(anchor1, frame, anchor2, centerX, centerY)
	Movable_OnMouseUp(frame)
end

local Movable_OnSizeChanged = function(self)
	if InCombatLockdown()then return end 
	if self.dirtyWidth and self.dirtyHeight then 
		self.Grip:Size(self.dirtyWidth, self.dirtyHeight)
	else 
		self.Grip:Size(self:GetSize())
	end 
end

local Movable_OnDragStart = function(self)
	if InCombatLockdown() then SV:AddonMessage(ERR_NOT_IN_COMBAT)return end 
	if SV.db.general.stickyFrames then 
		Sticky:StartMoving(self, self.snapOffset)
	else 
		self:StartMoving()
	end 
	UpdateFrameTarget = self;
	MentaloUpdateHandler:Show()
	MentaloUpdateHandler:SetScript("OnUpdate", Movable_OnUpdate)
	TheHand:Enable()
	TheHand.UserHeld = true 
end

local Movable_OnDragStop = function(self)
	if InCombatLockdown()then SV:AddonMessage(ERR_NOT_IN_COMBAT)return end 
	TheHand.UserHeld = false;
	if SV.db.general.stickyFrames then 
		Sticky:StopMoving(self)
	else 
		self:StopMovingOrSizing()
	end 
	local pR, pT, pC = GrabUsableRegions()
	local cX, cY = self:GetCenter()
	local newAnchor;
	if cY >= (pT * 0.5) then 
		newAnchor = "TOP"; 
		cY = (-(pT - self:GetTop()))
	else 
		newAnchor = "BOTTOM"
		cY = self:GetBottom()
	end 
	if cX >= (pR * 0.66) then 
		newAnchor = newAnchor.."RIGHT"
		cX = self:GetRight() - pR 
	elseif cX <= (pR * 0.33) then 
		newAnchor = newAnchor.."LEFT"
		cX = self:GetLeft()
	else 
		cX = cX - pC 
	end 
	if self.positionOverride then 
		self.parent:ClearAllPoints()
		self.parent:Point(self.positionOverride, self, self.positionOverride)
	end

	self:ClearAllPoints()
	self:Point(newAnchor, SV.Screen, newAnchor, cX, cY)

	Mentalo:SaveMovable(self.name)

	if SVUI_MentaloPrecision then 
		Movable_OnMouseUp(self)
	end

	UpdateFrameTarget = nil;

	MentaloUpdateHandler:SetScript("OnUpdate", nil)
	MentaloUpdateHandler:Hide()

	if(self.postdrag ~= nil and type(self.postdrag) == "function") then 
		self:postdrag(Pinpoint(self))
	end 
	self:SetUserPlaced(false)
	TheHand:Disable()
end

local Movable_OnEnter = function(self)
	if TheHand.UserHeld then return end
	ResetAllAlphas()
	self:SetAlpha(1)
	self.text:SetTextColor(0, 1, 1)
	self:SetBackdropBorderColor(0, 0.7, 1)
	UpdateFrameTarget = self;
	SVUI_Mentalo.Portrait:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\MENTALO-ON]])
	TheHand:SetPoint("CENTER", self, "TOP", 0, 0)
	TheHand:Show()
	if CurrentFrameTarget ~= self then 
		SVUI_MentaloPrecision:Hide()
		Movable_OnMouseUp(self)
	end 
end

local Movable_OnLeave = function(self)
	if TheHand.UserHeld then return end
	self.text:SetTextColor(0.5, 0.5, 0.5)
	self:SetBackdropBorderColor(0.5, 0.5, 0.5)
	SVUI_Mentalo.Portrait:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\MENTALO-OFF]])
	TheHand:Hide()
	if(CurrentFrameTarget ~= self and not SVUI_MentaloPrecision:IsShown()) then
		self:SetAlpha(0.4)
	end
end

local Movable_OnMouseDown = function(self, arg)
	if arg == "RightButton"then 
		TheHand.UserHeld = false;
		if(CurrentFrameTarget == self and not SVUI_MentaloPrecision:IsShown()) then
			Movable_OnUpdate()
			SVUI_MentaloPrecision:Show()
		else
			SVUI_MentaloPrecision:Hide()
		end
		if SV.db.general.stickyFrames then 
			Sticky:StopMoving(self)
		else 
			self:StopMovingOrSizing()
		end 
	end 
end

local Movable_OnShow = function(self)
	self:SetBackdropBorderColor(0.5, 0.5, 0.5)
end
--[[ 
########################################################## 
CONSTRUCTS
##########################################################
]]--
function Mentalo:New(frame, moveName, title, snap, dragStopFunc)
	if(not frame or (self.Frames[moveName] ~= nil)) then return end

	self.Frames[moveName] = {
		text = title,
		postdrag = dragStopFunc,
		point = CurrentPosition(frame)
	} 

	local movable = CreateFrame("Button", moveName, SV.Screen)
	movable:SetFrameLevel(frame:GetFrameLevel() + 1)
	movable:SetClampedToScreen(true)
	movable:SetWidth(frame:GetWidth())
	movable:SetHeight(frame:GetHeight())
	movable:SetFrameStrata("DIALOG")

	movable.parent = frame;
	movable.name = moveName;
	movable.textString = title;
	movable.postdrag = dragStopFunc;
	movable.snapOffset = snap or -2; 

	local anchor1, anchorParent, anchor2, xPos, yPos = split("\031", CurrentPosition(frame))
	if(SV.cache.Anchors and SV.cache.Anchors[moveName] and (type(SV.cache.Anchors[moveName]) == "string")) then 
		anchor1, anchorParent, anchor2, xPos, yPos = split("\031", SV.cache.Anchors[moveName])
		movable:SetPoint(anchor1, anchorParent, anchor2, xPos, yPos)
	else 
		movable:SetPoint(anchor1, anchorParent, anchor2, xPos, yPos)
	end 

	movable:SetFixedPanelTemplate("Transparent")
	movable:SetAlpha(0.4)

	frame:SetScript("OnSizeChanged", Movable_OnSizeChanged)
	frame.Grip = movable;
	frame:ClearAllPoints()
	frame:SetPoint(anchor1, movable, anchor1, 0, 0)

	local mtext = movable:CreateFontString(nil, "OVERLAY")
	mtext:FontManager()
	mtext:SetJustifyH("CENTER")
	mtext:SetPoint("CENTER")
	mtext:SetText(title or moveName)
	mtext:SetTextColor(0.5, 0.5, 0.5)

	movable:SetFontString(mtext)
	movable.text = mtext;

	movable:RegisterForDrag("LeftButton", "RightButton")
	movable:SetScript("OnMouseUp", Movable_OnMouseUp)
	movable:SetScript("OnDragStart", Movable_OnDragStart)
	movable:SetScript("OnDragStop", Movable_OnDragStop)
	movable:SetScript("OnEnter", Movable_OnEnter)
	movable:SetScript("OnMouseDown", Movable_OnMouseDown)
	movable:SetScript("OnLeave", Movable_OnLeave)
	movable:SetScript("OnShow", Movable_OnShow)

	movable:SetMovable(true)
	movable:Hide()

	if(dragStopFunc and (type(dragStopFunc) == "function")) then 
		movable:RegisterEvent("PLAYER_ENTERING_WORLD")
		movable:SetScript("OnEvent", function(this, event)
			local point = Pinpoint(this)
			dragStopFunc(this, point)
			this:UnregisterAllEvents()
		end)
	end 

	Sticky.Frames[#Sticky.Frames + 1] = movable;
end

function Mentalo:HasMoved(frameName)
	if(SV.cache.Anchors and SV.cache.Anchors[frameName]) then 
		return true 
	else 
		return false 
	end 
end 

function Mentalo:SaveMovable(frameName)
	if((not _G[frameName]) or (not SV.cache.Anchors)) then return end 
	SV.cache.Anchors[frameName] = CurrentPosition(_G[frameName])
end

function Mentalo:ChangeSnapOffset(frameName, snapOffset)
	if(not _G[frameName]) then return end 
	_G[frameName].snapOffset = snapOffset or -2;
end 

function Mentalo:Add(frame, title, snapOffset, dragStopFunc, overrideName)
	if(not frame or (not overrideName and not frame:GetName())) then return end
	local frameName = overrideName or frame:GetName()
	local moveName = ("%s_MOVE"):format(frameName) 
	self:New(frame, moveName, title, snapOffset, dragStopFunc)
end

function Mentalo:Reset(request)
	if(request == "" or request == nil) then 
		for frameName, frameData in pairs(self.Frames) do 
			local frame = _G[frameName];
			if(frameData.point) then
				local u, v, w, x, y = split("\031", frameData.point)
				frame:ClearAllPoints()
				frame:SetPoint(u, v, w, x, y)
				if(frameData.postdrag and (type(frameData.postdrag) == "function")) then 
					frameData.postdrag(frame, Pinpoint(frame))
				end
			end
			if(SV.cache.Anchors and SV.cache.Anchors[frameName]) then 
				SV.cache.Anchors[frameName] = nil 
			end 
		end
	elseif(request == "Blizzard") then
		for frameName, point in pairs(self.Blizzard) do 
			if(SV.cache.Anchors and SV.cache.Anchors[frameName]) then 
				SV.cache.Anchors[frameName] = nil 
			end
		end
		ReloadUI()
	else 
		for frameName, frameData in pairs(self.Frames) do
			if(frameData.point and (request == frameData.text)) then
				local frame = _G[frameName]
				local u, v, w, x, y = split("\031", frameData.point)
				frame:ClearAllPoints()
				frame:SetPoint(u, v, w, x, y) 
				if (frameData.postdrag and (type(frameData.postdrag) == "function"))then 
					frameData.postdrag(frame, Pinpoint(frame))
				end
				if(SV.cache.Anchors and SV.cache.Anchors[frameName]) then 
					SV.cache.Anchors[frameName] = nil 
				end
				break
			end
		end 
	end 
end 

function Mentalo:SetPositions()
	for frameName, frameData in pairs(self.Frames) do 
		local frame = _G[frameName];
		local anchor1, parent, anchor2, x, y;
		if frame then
			if (SV.cache.Anchors and SV.cache.Anchors[frameName] and (type(SV.cache.Anchors[frameName]) == "string")) then 
				anchor1, parent, anchor2, x, y = split("\031", SV.cache.Anchors[frameName])
				frame:ClearAllPoints()
				frame:SetPoint(anchor1, parent, anchor2, x, y)
			elseif(frameData.point) then 
				anchor1, parent, anchor2, x, y = split("\031", frameData.point)
				frame:ClearAllPoints()
				frame:SetPoint(anchor1, parent, anchor2, x, y)
			end
		end
	end

	for frameName, point in pairs(self.Blizzard) do 
		local frame = _G[frameName];
		local anchor1, parent, anchor2, x, y;
		if(frame) then
			if (SV.cache.Anchors and SV.cache.Anchors[frameName] and (type(SV.cache.Anchors[frameName]) == "string")) then 
				anchor1, parent, anchor2, x, y = split("\031", SV.cache.Anchors[frameName])
				frame:ClearAllPoints()
				frame:SetPoint(anchor1, parent, anchor2, x, y)
			elseif(point and (type(point) == "string")) then
				anchor1, parent, anchor2, x, y = split("\031", point)
				frame:ClearAllPoints()
				frame:SetPoint(anchor1, parent, anchor2, x, y)
			end
		end
	end
end  

function Mentalo:Toggle(isConfigMode)
	if(InCombatLockdown()) then return end 
	local enabled = false;
	if(isConfigMode  ~= nil and isConfigMode  ~= "") then 
		self.ConfigurationMode = isConfigMode 
	end 

	if(not self.ConfigurationMode) then
		if IsAddOnLoaded(SV.ConfigID)then 
			LibStub("AceConfigDialog-3.0"):Close(SV.NameID)
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

	for frameName, _ in pairs(self.Frames)do 
		if(_G[frameName]) then 
			local movable = _G[frameName] 
			if(not enabled) then 
				movable:Hide() 
			else 
				movable:Show() 
			end 
		end 
	end
end
--[[ 
########################################################## 
SCRIPT AND EVENT HANDLERS
##########################################################
]]--
local XML_Mentalo_OnEvent = function(self)
	if self:IsShown() then 
		self:Hide()
		Mentalo:Toggle(true)
	end
end 

local XML_MentaloGridButton_OnClick = function(self)
	local enabled = true
	if(SV.Graph.Grid and SV.Graph.Grid:IsShown()) then
		enabled = false
	end

	SV.Graph:Toggle(enabled)
end

local XML_MentaloLockButton_OnClick = function(self)
	SV.Graph:Toggle()
	Mentalo:Toggle(true)
	if IsAddOnLoaded(SV.ConfigID)then 
		LibStub("AceConfigDialog-3.0"):Open(SV.NameID)
	end 
end

local SVUI_MentaloPrecisionResetButton_OnClick = function(self)
	if(not CurrentFrameTarget) then return end
	local name = CurrentFrameTarget.name
	Mentalo:Reset(name)
end 

local XML_MentaloPrecisionInputX_EnterPressed = function(self)
	local current = tonumber(self:GetText())
	if(current) then 
		if(CurrentFrameTarget) then
			local xOffset, yOffset, anchor = CalculateOffsets()
			yOffset = tonumber(SVUI_MentaloPrecisionSetY.CurrentValue)
			CurrentFrameTarget:ClearAllPoints()
			CurrentFrameTarget:Point(anchor, SVUIParent, anchor, current, yOffset)
			Mentalo:SaveMovable(CurrentFrameTarget.name)
		end
		self.CurrentValue = current
	end
	self:SetText(floor((self.CurrentValue or 0) + 0.5))
	EditBox_ClearFocus(self)
end

local XML_MentaloPrecisionInputY_EnterPressed = function(self)
	local current = tonumber(self:GetText())
	if(current) then 
		if(CurrentFrameTarget) then
			local xOffset, yOffset, anchor = CalculateOffsets()
			xOffset = tonumber(SVUI_MentaloPrecisionSetX.CurrentValue)
			CurrentFrameTarget:ClearAllPoints()
			CurrentFrameTarget:Point(anchor, SVUIParent, anchor, xOffset, current)
			Mentalo:SaveMovable(CurrentFrameTarget.name)
		end
		self.CurrentValue = current
	end
	self:SetText(floor((self.CurrentValue or 0) + 0.5))
	EditBox_ClearFocus(self)
end
--[[ 
########################################################## 
DRAGGABLE HANDLERS
##########################################################
]]--
local BlizzardFrame_OnUpdate = function(self)
	local frameName = self:GetName();
	if(InCombatLockdown() or (self.IsMoving)) then return end 
	if(frameName == "QuestFrame") then
		frameName = "GossipFrame"
	end
	if (SV.cache.Anchors and SV.cache.Anchors[frameName] and (type(SV.cache.Anchors[frameName]) == "string")) then 
		local anchor1, parent, anchor2, x, y = split("\031", SV.cache.Anchors[frameName])
		self:ClearAllPoints()
		self:SetPoint(anchor1, parent, anchor2, x, y)
	else
		local defaultPoint = Mentalo.Blizzard[frameName]
		if(defaultPoint and (type(defaultPoint) == "string")) then 
			local anchor1, parent, anchor2, x, y = split("\031", defaultPoint)
			self:ClearAllPoints()
			self:SetPoint(anchor1, parent, anchor2, x, y)
		end
	end
end

local BlizzardFrame_OnDragStart = function(self)
	if not self:IsMovable() then return end 
	self:StartMoving()
	self.IsMoving = true
end

local BlizzardFrame_OnDragStop = function(self)
	if(not self:IsMovable()) then return end
	local frameName = self:GetName();
	self.IsMoving = false;
	self:StopMovingOrSizing()
	local anchor1, parent, anchor2, x, y = self:GetPoint()
	parent = self:GetParent():GetName()
	self:ClearAllPoints()
	self:SetPoint(anchor1, parent, anchor2, x, y)
	if(frameName == "QuestFrame") then
		frameName = "GossipFrame"
	end
	Mentalo:SaveMovable(frameName)
end

local UIPanelsAdjusted = {};

local MentaloDraggablesUpdate = function(self, event, ...)
	if(InCombatLockdown()) then return end
	for _, frameName in pairs(DraggableFrames) do
		if((not self.Blizzard[frameName]) or (self.Blizzard[frameName] and (self.Blizzard[frameName] == "TBD"))) then 
			local frame = _G[frameName]
			if(frame) then
				frame:EnableMouse(true)

				if(frameName == "LFGDungeonReadyPopup") then 
					LFGDungeonReadyDialog:EnableMouse(false)
				end

				frame:SetMovable(true)
				frame:RegisterForDrag("LeftButton")
				frame:SetClampedToScreen(true)
				frame:HookScript("OnUpdate", BlizzardFrame_OnUpdate)
				frame:SetScript("OnDragStart", BlizzardFrame_OnDragStart)
				frame:SetScript("OnDragStop", BlizzardFrame_OnDragStop)

				if(self.CenterEverything and (not UIPanelsAdjusted[panelName])) then
					frame:ClearAllPoints()
					frame:SetPoint('TOP', SV.Screen, 'TOP', 0, -180)
					UIPanelsAdjusted[frameName] = true
				end

				self.Blizzard[frameName] = CurrentPosition(frame)
			else
				self.Blizzard[frameName] = "TBD"
			end 
		end
	end
end
--[[ 
########################################################## 
Initialize
##########################################################
]]--
function Mentalo:Initialize()
	SVUI_Mentalo:SetFixedPanelTemplate("Component")
	SVUI_Mentalo:SetPanelColor("yellow")
	SVUI_Mentalo:RegisterForDrag("LeftButton")
	SVUI_Mentalo:RegisterEvent("PLAYER_REGEN_DISABLED")
	SVUI_Mentalo:SetScript("OnEvent", XML_Mentalo_OnEvent)

	SVUI_MentaloGridButton:SetScript("OnClick", XML_MentaloGridButton_OnClick)
	SVUI_MentaloLockButton:SetScript("OnClick", XML_MentaloLockButton_OnClick)

	SVUI_MentaloPrecision:SetPanelTemplate("Transparent")
	SVUI_MentaloPrecision:EnableMouse(true)

	SVUI_MentaloPrecisionSetX:SetEditboxTemplate()
	SVUI_MentaloPrecisionSetX.CurrentValue = 0;
	SVUI_MentaloPrecisionSetX:SetScript("OnEnterPressed", XML_MentaloPrecisionInputX_EnterPressed)

	SVUI_MentaloPrecisionSetY:SetEditboxTemplate()
	SVUI_MentaloPrecisionSetY.CurrentValue = 0;
	SVUI_MentaloPrecisionSetY:SetScript("OnEnterPressed", XML_MentaloPrecisionInputY_EnterPressed)

	SVUI_MentaloPrecisionUpButton:SetButtonTemplate()
	SVUI_MentaloPrecisionDownButton:SetButtonTemplate()
	SVUI_MentaloPrecisionLeftButton:SetButtonTemplate()
	SVUI_MentaloPrecisionRightButton:SetButtonTemplate()

	SV.cache.Anchors = SV.cache.Anchors or {}
	self.CenterEverything = SV.db.general.multiMonitor

	MentaloDraggablesUpdate(self)

	self:SetPositions()

	Mentalo:RegisterEvent("ADDON_LOADED")
	Mentalo:RegisterEvent("LFG_UPDATE")
	Mentalo:RegisterEvent("ROLE_POLL_BEGIN")
	Mentalo:RegisterEvent("READY_CHECK")
	Mentalo:RegisterEvent("UPDATE_WORLD_STATES")
	Mentalo:RegisterEvent("WORLD_STATE_TIMER_START")
	Mentalo:RegisterEvent("WORLD_STATE_UI_TIMER_UPDATE")
	Mentalo:SetScript("OnEvent", MentaloDraggablesUpdate)

	--PET JOURNAL TAINT FIX (STILL NEEDED?)
	-- local info = UIPanelWindows["PetJournalParent"];
	-- for name, value in pairs(info) do
	-- 	PetJournalParent:SetAttribute("UIPanelLayout-"..name, value);
	-- end	
	-- PetJournalParent:SetAttribute("UIPanelLayout-defined", true);
end

SV.Mentalo = Mentalo