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
local MOD = SuperVillain.Registry:Expose('SVDock');
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
MOD.DefaultWindow = false
local tinsert, wipe, pairs, ipairs, unpack, pcall, select = tinsert, table.wipe, pairs, ipairs, unpack, pcall, select;
local format, gsub, strfind, strmatch, tonumber = format, gsub, strfind, strmatch, tonumber;
local TOOL_DATA = {
	["Alchemy"] 		= {0,0.25,0,0.25}, 					-- PRO-ALCHEMY
    ["Archaeology"] 	= {0.25,0.5,0,0.25,"Survey"}, 		-- PRO-ARCHAELOGY
    ["Blacksmithing"] 	= {0.5,0.75,0,0.25}, 				-- PRO-BLACKSMITH
    ["Cooking"] 		= {0.75,1,0,0.25,"Cooking Fire"}, 	-- PRO-COOKING
    ["Enchanting"] 		= {0,0.25,0.25,0.5,"Disenchant"}, 	-- PRO-ENCHANTING
    ["Engineering"] 	= {0.25,0.5,0.25,0.5}, 				-- PRO-ENGINEERING
    ["First Aid"] 		= {0.5,0.75,0.25,0.5}, 				-- PRO-FIRSTAID
    ["Herbalism"] 		= {0.75,1,0.25,0.5,"Lifeblood"}, 	-- PRO-HERBALISM
    ["Inscription"] 	= {0,0.25,0.5,0.75,"Milling"}, 		-- PRO-INSCRIPTION
    ["Jewelcrafting"] 	= {0.25,0.5,0.5,0.75,"Prospecting"},-- PRO-JEWELCRAFTING
    ["Leatherworking"] 	= {0.5,0.75,0.5,0.75}, 				-- PRO-LEATHERWORKING
    ["Mining"] 			= {0.75,1,0.5,0.75}, 				-- PRO-MINING
    ["Skinning"] 		= {0,0.25,0.75,1}, 					-- PRO-SKINNING
    ["Tailoring"] 		= {0.25,0.5,0.75,1}, 				-- PRO-TAILORING
    ["Default"] 		= {0.5,0.75,0,0.25}
}
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local function GetDefaultWindow()
	local window = MOD.DefaultWindow
	if window and _G[window] and not _G[window]:IsShown() then
		SuperDockWindowRight.FrameName = window
		SuperDockWindowRight:Show()
	end
end

local Button_OnEnter = function(b)
	if not b.IsOpen then
		b:SetPanelColor("highlight")
   	b.icon:SetGradient(unpack(SuperVillain.Media.gradient.bizzaro))
	end
	GameTooltip:SetOwner(b, "ANCHOR_TOPLEFT", 0, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(b.TText, 1, 1, 1)
	GameTooltip:Show()
end 

local Button_OnLeave = function(b)
	if not b.IsOpen then
		b:SetPanelColor("special")
		b.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	end
	GameTooltip:Hide()
end 

local Button_OnClick = function(self)
	if InCombatLockdown() then return end
	local linkedFrame = self.FrameName
	if linkedFrame and _G[linkedFrame] then
		SuperDockWindowRight.FrameName = linkedFrame
		if not _G[linkedFrame]:IsShown() then
			if not SuperDockWindowRight:IsShown()then
				SuperDockWindowRight:Show()
			end
			MOD:DockletHide()
			_G[linkedFrame]:Show()
			self.IsOpen = true;
			self:SetPanelColor("green")
			self.icon:SetGradient(unpack(SuperVillain.Media.gradient.green))
		elseif not SuperDockWindowRight:IsShown()then
			SuperDockWindowRight:Show()
			_G[linkedFrame]:Show()
			self.IsOpen = true;
			self:SetPanelColor("green")
			self.icon:SetGradient(unpack(SuperVillain.Media.gradient.green))
		end 
	else
		if SuperDockWindowRight:IsShown()then 
			SuperDockWindowRight:Hide()
		else 
			SuperDockWindowRight:Show()
		end
		self.IsOpen = false;
		self:SetPanelColor("special")
		self.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		GetDefaultWindow()
	end 
end 

local Macro_OnEnter = function(self)
	self:SetPanelColor("highlight")
    self.icon:SetGradient(unpack(SuperVillain.Media.gradient.bizzaro))
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 2, 4)
	GameTooltip:ClearLines()
	if not self.TText2 then 
		GameTooltip:AddLine(self.TText, 1, 1, 1)
	else 
		GameTooltip:AddDoubleLine(self.TText, self.TText2, 1, 1, 1)
	end 
	GameTooltip:Show()
end 

local Macro_OnLeave = function(self)
	self:SetPanelColor("special")
	self.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	GameTooltip:Hide()
end

MOD.ToolsList = {};
MOD.ToolsSafty = {};
MOD.LastAddedTool = false;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:RemoveTool(frame)
	if not frame or not frame.listIndex then return end 
	local name = frame:GetName();
	if not MOD.ToolsSafty[name] then return end 
	MOD.ToolsSafty[name] = false;
	local i = frame.listIndex;
	tremove(MOD.ToolsList, i)
	local width;
	local height = SuperDockToolBarRight.currentSize;
	MOD.LastAddedTool = MOD.ToolsList[#MOD.ToolsList]
	width = #MOD.ToolsList * (height + 6)
	SuperDockToolBarRight:Size(width, height)
end 

function MOD:AddTool(frame)
	local name = frame:GetName();
	if MOD.ToolsSafty[name] then return end 
	MOD.ToolsSafty[name] = true;
	local width;
	local height = SuperDockToolBarRight.currentSize;
	if not MOD.LastAddedTool or MOD.LastAddedTool == frame then
		frame:Point("RIGHT", SuperDockToolBarRight, "RIGHT", -6, 0);
	else
		frame:Point("RIGHT", MOD.LastAddedTool, "LEFT", -6, 0);
	end
	tinsert(MOD.ToolsList, frame)
 	frame.listIndex = #MOD.ToolsList;
	MOD.LastAddedTool = frame;
	width = #MOD.ToolsList * (height + 6)
	SuperDockToolBarRight:Size(width, height)
end 

function MOD:CreateBasicToolButton(name,texture,onclick,frameName,isdefault)
	local fName = frameName or name;
	local dockIcon = texture or [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-ADDON]];
	local clickFunction = (type(onclick)=="function") and onclick or Button_OnClick;
	local size = SuperDockToolBarRight.currentSize;
	local button = _G[fName .. "_ToolBarButton"] or CreateFrame("Button",("%s_ToolBarButton"):format(fName),SuperDockToolBarRight)
	MOD:AddTool(button)
	button:Size(size,size)
	button:SetFramedButtonTemplate()
	button.icon = button:CreateTexture(nil,"OVERLAY")
	button.icon:FillInner(button,2,2)
	button.icon:SetTexture(dockIcon)
	button.TText = "Open " .. name;
	button.FrameName = fName;
	if isdefault == true then
		MOD.DefaultWindow = fName;
	end 
	button.IsOpen = isdefault and true or false;
	button:SetScript("OnEnter",Button_OnEnter)
	button:SetScript("OnLeave",Button_OnLeave)
	button:SetScript("OnClick",clickFunction)
	_G[fName].ToggleName = fName.."_ToolBarButton";
	if(isdefault) then
		button:SetPanelColor("green")
		button.icon:SetGradient(unpack(SuperVillain.Media.gradient.green))
	else
		button.icon:SetGradient(unpack(SuperVillain.Media.gradient.light))
	end
end 

do
	local LastAddedMacro;
	local MacroCount = 0;

	local function HearthTime()
		local start,duration = GetItemCooldown(6948)
		local expires = duration - (GetTime() - start)
		if expires > 0.05 then 
			local timeLeft = 0;
			local calc = 0;
			if expires < 4 then
				return format("|cffff0000%.1f|r", expires)
			elseif expires < 60 then 
				return format("|cffffff00%d|r", floor(expires)) 
			elseif expires < 3600 then
				timeLeft = ceil(expires / 60);
				calc = floor((expires / 60) + .5);
				return format("|cffff9900%dm|r", timeLeft)
			elseif expires < 86400 then
				timeLeft = ceil(expires / 3600);
				calc = floor((expires / 3600) + .5);
				return format("|cff66ffff%dh|r", timeLeft)
			else
				timeLeft = ceil(expires / 86400);
				calc = floor((expires / 86400) + .5);
				return format("|cff6666ff%dd|r", timeLeft)
			end
		else 
			return "|cff6666ffReady|r"
		end 
	end

	local Hearth_OnEnter = function(self)
		if InCombatLockdown() then return end 
		self.glow:Show()
		self:SetPanelColor("highlight")
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["Hearthstone"], 1, 1, 1)
		local remaining = HearthTime()
		GameTooltip:AddDoubleLine(L["Time Remaining"], remaining, 1, 1, 1, 0, 1, 1)
		if(self.ExtraSpell) then
			GameTooltip:AddLine(" ", 1, 1, 1)
			GameTooltip:AddDoubleLine(self.ExtraSpell, "[Right Click]", 1, 1, 1, 0, 1, 0)
		end
		GameTooltip:Show()
	end 

	local Hearth_OnLeave = function(self)
		if InCombatLockdown() then return end 
		self.glow:Hide()
		self:SetPanelColor("special")
		GameTooltip:Hide()
	end 

	local function AddMacroTool(frame)
		local width;
		local height = SuperDockToolBarRight.currentSize;
		if not LastAddedMacro then
			frame:Point("RIGHT", SuperDockMacroBar, "RIGHT", -6, 0);
		else
			frame:Point("RIGHT", LastAddedMacro, "LEFT", -6, 0);
		end
		LastAddedMacro = frame;
		MacroCount = MacroCount + 1;
		width = MacroCount * (height + 6)
		SuperDockMacroBar:Size(width, height)
	end 

	local function CreateMacroToolButton(proName, itemID, size)
		if proName == "Mining" then proName = "Smelting" end 
		local data = TOOL_DATA[proName] or TOOL_DATA["Default"]
		local button = CreateFrame("Button", ("%s_MacroBarButton"):format(itemID), SuperDockMacroBar, "SecureActionButtonTemplate")
		button:Size(size, size)
		AddMacroTool(button)
		button:SetFramedButtonTemplate()
		button.icon = button:CreateTexture(nil, "OVERLAY")
		button.icon:FillInner(button, 2, 2)
		button.icon:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\PROFESSIONS]])
		button.icon:SetTexCoord(data[1], data[2], data[3], data[4])
		button.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		button.skillName = proName;
		button.itemId = itemID;
		button.TText = "Open " .. proName;
		button:SetAttribute("type", "macro")
		if(data[5]) then
			local rightClickSpell = data[5]
			button:SetAttribute("macrotext", "/cast [mod:shift]" .. rightClickSpell .. "; " .. proName)
			button.TText2 = "Shift-Click to use " .. rightClickSpell 
		else 
			button:SetAttribute("macrotext","/cast " .. proName)
		end 
		button:SetScript("OnEnter", Macro_OnEnter)
		button:SetScript("OnLeave", Macro_OnLeave)
	end 

	function MOD:LoadToolBarProfessions()
		if(MOD.ToolBarLoaded) then return end
		local size = SuperDockMacroBar.currentSize
		local hearth = CreateFrame("Button", "RightSuperDockHearthButton", SuperDockMacroBar, "SecureActionButtonTemplate")
		hearth:Size(size, size)
		AddMacroTool(hearth)
		hearth:SetFramedButtonTemplate()
		hearth.icon = hearth:CreateTexture(nil, "OVERLAY", nil, 0)
		hearth.icon:FillInner(hearth,2,2)
		hearth.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\DOCK-HEARTH")
		hearth.icon:SetTexCoord(0,0.5,0,1)
		hearth.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		hearth.glow = hearth:CreateTexture(nil, "OVERLAY", nil, 2)
		hearth.glow:FillInner(hearth,2,2)
		hearth.glow:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\DOCK-HEARTH")
		hearth.glow:SetTexCoord(0.5,1,0,1)
		hearth.glow:Hide()
		hearth:SetScript("OnEnter", Hearth_OnEnter)
		hearth:SetScript("OnLeave", Hearth_OnLeave)

		hearth:RegisterForClicks("AnyUp")
		hearth:SetAttribute("type","item")
		hearth:SetAttribute("item","Hearthstone")

		if(SuperVillain.class == "SHAMAN") then
			hearth:SetAttribute("type2","spell")
			hearth:SetAttribute("spell","Astral Recall")
			hearth.ExtraSpell = "Astral Recall"
		elseif(SuperVillain.class == "DEATHKNIGHT") then
			hearth:SetAttribute("type2","spell")
			hearth:SetAttribute("spell","Death Gate")
			hearth.ExtraSpell = "Death Gate"
		elseif(SuperVillain.class == "DRUID") then
			hearth:SetAttribute("type2","spell")
			hearth:SetAttribute("spell","Teleport: Moonglade")
			hearth.ExtraSpell = "Teleport: Moonglade"
		elseif(SuperVillain.class == "MONK") then
			hearth:SetAttribute("type2","spell")
			hearth:SetAttribute("spell","Zen Pilgrimage")
			hearth.ExtraSpell = "Zen Pilgrimage"
		end

		local proName
		local prof1, prof2, archaeology, _, cooking, firstAid = GetProfessions();

		if(firstAid ~= nil) then 
			proName, _ = GetProfessionInfo(firstAid)
			if(proName ~= "Herbalism" and proName ~= "Skinning") then
				CreateMacroToolButton(proName, firstAid, size)
			end
		end 
		if(archaeology ~= nil) then 
			proName, _ = GetProfessionInfo(archaeology)
			if(proName ~= "Herbalism" and proName ~= "Skinning") then
				CreateMacroToolButton(proName, archaeology, size)
			end
		end 
		if(cooking ~= nil) then 
			proName, _ = GetProfessionInfo(cooking)
			if(proName ~= "Herbalism" and proName ~= "Skinning") then
				CreateMacroToolButton(proName, cooking, size)
			end
		end 
		if(prof2 ~= nil) then 
			proName, _ = GetProfessionInfo(prof2)
			if(proName ~= "Herbalism" and proName ~= "Skinning") then
				CreateMacroToolButton(proName, prof2, size)
			end
		end 
		if(prof1 ~= nil) then 
			proName, _ = GetProfessionInfo(prof1)
			if(proName ~= "Herbalism" and proName ~= "Skinning") then
				CreateMacroToolButton(proName, prof1, size)
			end
		end

		MOD.ToolBarLoaded = true
	end
end