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
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local PVP_NODES = {
	[461] = { --Arathi Basin (5)
		"Stables", "Lumber", "Blacksmith", "Mine", "Farm"
	},
	[935] = { --Deepwind Gorge (3)
		"Center Mine", "North Mine", "South Mine"
	},
	[482] = { --Eye of the Storm (4)
		"Fel Reaver", "Blood Elf", "Draenei", "Mage"
	},
	[736] = { --The Battle for Gilneas (3)
		"LightHouse", "WaterWorks", "Mines"
	},
}

-- local PVP_POI = {
-- 	[401] = { --Alterac Valley (15)
-- 		"Stormpike Aid Station", "Dun Baldar North Bunker", "Dun Baldar South Bunker",
-- 		"Stormpike Graveyard", "Icewing Bunker", "Stonehearth Graveyard",
-- 		"Stonehearth Bunker", "Snowfall Graveyard", "Iceblood Tower",
-- 		"Iceblood Graveyard", "Tower Point", "Frostwolf Graveyard",
-- 		"West Frostwolf Tower", "East Frostwolf Tower", "Frostwolf Relief Hut"
-- 	},
-- 	[935] = { --Deepwind Gorge (2)
-- 		"Horde Cart", "Alliance Cart"
-- 	},
-- 	[482] = { --Eye of the Storm (1)
-- 		"Flag"
-- 	},
-- 	[860] = { --Silvershard Mines (1)
-- 		"Cart"
-- 	},
-- 	[512] = { --Strand of the Ancients (5)
-- 		"Green Emerald", "Blue Sapphire", "Purple Amethyst", "Red Sun", "Yellow Moon"
-- 	},
-- 	[540] = { --Isle of Conquest (5)
-- 		"Quarry", "Hangar", "Workshop", "Docks", "Refinery"
-- 	},
-- 	[856] = { --Temple of Kotmogu (4)
-- 		"Red Orb", "Blue Orb", "Orange Orb", "Purple Orb"
-- 	},
-- 	[626] = { --Twin Peaks (2)
-- 		"Horde Flag", "Alliance Flag"
-- 	},
-- 	[443] = { --Warsong Gulch (2)
-- 		"Horde Flag", "Alliance Flag"
-- 	},
-- }

local function EnteringBattleGround()
	SVUI_PVPComm:Show()
	local mapID = GetCurrentMapAreaID()
	local points = PVP_NODES[mapID]
	if(not points) then 
		SVUI_PVPComm:Hide() 
		return 
	end
	for i = 1, #points do
		local name = points[i]
		local nodeName = ("SVUI_PVPNode%d"):format(i)
		local node = _G[nodeName]
		local safe = node.Safe
		local help = node.Help
		safe.name = name
		help.name = name
		node.Text:SetText(name)
		node:Show()
	end
end

local function ExitingBattleGround()
	for i = 1, 5 do
		local nodeName = ("SVUI_PVPNode%d"):format(i)
		local node = _G[nodeName]
		local safe = node.Safe
		local help = node.Help
		safe.name = ""
		help.name = ""
		node.Text:SetText("")
		node:Hide()
	end
	SVUI_PVPComm:Hide()
end
--[[ 
########################################################## 
HANDLERS
##########################################################
]]--
local Safe_OnEnter = function(self)
	if InCombatLockdown() then return end
	if(self.name and self.name ~= "") then
		self:SetBackdropBorderColor(1,0.45,0)
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(self.name .. " is Safe!", 1, 1, 1)
		GameTooltip:Show()
	end
end

local Safe_OnLeave = function(self)
	if InCombatLockdown() then return end 
	self:SetBackdropBorderColor(0,0,0)
	if(GameTooltip:IsShown()) then GameTooltip:Hide() end
end

local Safe_OnClick = function(self)
	if(self.name and self.name ~= "") then
		local msg = ("%s Safe"):format(self.name)
		SendChatMessage(msg, "INSTANCE_CHAT")
	end
end

local Help_OnEnter = function(self)
	if InCombatLockdown() then return end
	if(self.name and self.name ~= "") then
		self:SetBackdropBorderColor(1,0.45,0)
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(self.name .. " Needs Help!", 1, 1, 1)
		GameTooltip:Show()
	end
end

local Help_OnLeave = function(self)
	if InCombatLockdown() then return end 
	self:SetBackdropBorderColor(0,0,0)
	if(GameTooltip:IsShown()) then GameTooltip:Hide() end
end

local Help_OnClick = function(self)
	if(self.name and self.name ~= "") then
		local msg = ("{rt8} Incoming %s {rt8}"):format(self.name)
		SendChatMessage(msg, "INSTANCE_CHAT")
	end
end

local PVPCommunicator = CreateFrame("Frame", nil)
local PVPCommunicator_OnEvent = function(self, event, ...)
	local instance, groupType = IsInInstance()
	if(instance and groupType == "pvp") then
		if(not self.InPVP) then
			EnteringBattleGround()
			self.InPVP = true
		end
	else
		if(self.InPVP) then
			ExitingBattleGround()
			self.InPVP = nil
		end
	end
end
--[[ 
########################################################## 
LOADER
##########################################################
]]--
local function LoadPVPComm()
	local width = 156
	local height = 156
	local holder = CreateFrame("Frame", "SVUI_PVPComm", UIParent)
	holder:SetSize(width, height)
	holder:SetPoint("RIGHT", UIParent, "CENTER", -200, 0)

	for i = 1, 5 do
		local yOffset = (24 * (i - 1)) + 2

		local poiName = ("SVUI_PVPNode%d"):format(i)
		local poi = CreateFrame("Frame", poiName, holder)
		poi:SetSize(180, 22)
		poi:SetPoint("TOP", holder, "TOP", 0, -yOffset)
		poi:SetPanelTemplate("Transparent")
		poi.Text = poi:CreateFontString(nil,"OVERLAY")
		poi.Text:SetFont(SuperVillain.Media.font.roboto, 12, "NONE")
		poi.Text:SetPoint("LEFT", poi, "LEFT", 2, 0)
		poi.Text:SetHeight(22)
		poi.Text:SetWidth(130)
		poi.Text:SetJustifyH("CENTER")
		poi.Text:SetText("")

		local safe = CreateFrame("Button", nil, poi)
		safe:SetSize(22, 22)
		safe:SetPoint("RIGHT", poi, "RIGHT", -2, 0)
		safe:SetButtonTemplate()
		local sicon = safe:CreateTexture(nil, "OVERLAY")
		sicon:SetAllPoints(safe)
		sicon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		sicon:SetTexture([[Interface\PaperDollInfoFrame\Character-Plus]])
		safe:SetScript("OnEnter", Safe_OnEnter)
		safe:SetScript("OnLeave", Safe_OnLeave)
		safe:SetScript("OnClick", Safe_OnClick)

		poi.Safe = safe

		local help = CreateFrame("Button", nil, poi)
		help:SetSize(22, 22)
		help:SetPoint("RIGHT", safe, "LEFT", -2, 0)
		help:SetButtonTemplate()
		local hicon = help:CreateTexture(nil, "OVERLAY")
		hicon:SetAllPoints(help)
		hicon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		hicon:SetTexture([[Interface\WorldMap\Skull_64Red]])
		help:SetScript("OnEnter", Help_OnEnter)
		help:SetScript("OnLeave", Help_OnLeave)
		help:SetScript("OnClick", Help_OnClick)

		poi.Help = help
	end
	SuperVillain:SetSVMovable(holder, "SVUI_PVPComm_MOVE", L["PvP Communicator"])

	PVPCommunicator:RegisterEvent("PLAYER_ENTERING_WORLD")
	PVPCommunicator:SetScript("OnEvent", PVPCommunicator_OnEvent)
	holder:Hide()
end

SuperVillain.Registry:NewScript(LoadPVPComm)