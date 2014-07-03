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
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, split = string.find, string.format, string.split;
local gsub = string.gsub;
--[[ MATH METHODS ]]--
local ceil = math.ceil;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = {};
local LibAB = LibStub("LibActionButton-1.0");
local LSM = LibStub("LibSharedMedia-3.0");
MOD.Storage = {};
MOD.Storage["Cache"] = {};
MOD.Storage["Bar1"] = {};
MOD.Storage["Bar1"]["bar"] = {};
MOD.Storage["Bar1"]["buttons"] = {};
MOD.Storage["Bar1"]["config"] = {
  outOfRangeColoring = "button",
  tooltip = "enable",
  showGrid = true,
  colors = {
    range = {0.8, 0.1, 0.1},
    mana = {0.5, 0.5, 1.0},
    hp = {0.5, 0.5, 1.0}
  },
  hideElements = {
    macro = false,
    hotkey = false,
    equipped = false
  },
  keyBoundTarget = false,
  clickOnDown = false
}
MOD.Storage["Bar2"] = {};
MOD.Storage["Bar2"]["bar"] = {};
MOD.Storage["Bar2"]["buttons"] = {};
MOD.Storage["Bar2"]["config"] = {
  outOfRangeColoring = "button",
  tooltip = "enable",
  showGrid = true,
  colors = {
    range = {0.8, 0.1, 0.1},
    mana = {0.5, 0.5, 1.0},
    hp = {0.5, 0.5, 1.0}
  },
  hideElements = {
    macro = false,
    hotkey = false,
    equipped = false
  },
  keyBoundTarget = false,
  clickOnDown = false
}
MOD.Storage["Bar3"] = {};
MOD.Storage["Bar3"]["bar"] = {};
MOD.Storage["Bar3"]["buttons"] = {};
MOD.Storage["Bar3"]["config"] = {
  outOfRangeColoring = "button",
  tooltip = "enable",
  showGrid = true,
  colors = {
    range = {0.8, 0.1, 0.1},
    mana = {0.5, 0.5, 1.0},
    hp = {0.5, 0.5, 1.0}
  },
  hideElements = {
    macro = false,
    hotkey = false,
    equipped = false
  },
  keyBoundTarget = false,
  clickOnDown = false
}
MOD.Storage["Bar4"] = {};
MOD.Storage["Bar4"]["bar"] = {};
MOD.Storage["Bar4"]["buttons"] = {};
MOD.Storage["Bar4"]["config"] = {
  outOfRangeColoring = "button",
  tooltip = "enable",
  showGrid = true,
  colors = {
    range = {0.8, 0.1, 0.1},
    mana = {0.5, 0.5, 1.0},
    hp = {0.5, 0.5, 1.0}
  },
  hideElements = {
    macro = false,
    hotkey = false,
    equipped = false
  },
  keyBoundTarget = false,
  clickOnDown = false
}
MOD.Storage["Bar5"] = {};
MOD.Storage["Bar5"]["bar"] = {};
MOD.Storage["Bar5"]["buttons"] = {};
MOD.Storage["Bar5"]["config"] = {
  outOfRangeColoring = "button",
  tooltip = "enable",
  showGrid = true,
  colors = {
    range = {0.8, 0.1, 0.1},
    mana = {0.5, 0.5, 1.0},
    hp = {0.5, 0.5, 1.0}
  },
  hideElements = {
    macro = false,
    hotkey = false,
    equipped = false
  },
  keyBoundTarget = false,
  clickOnDown = false
}
MOD.Storage["Bar6"] = {};
MOD.Storage["Bar6"]["bar"] = {};
MOD.Storage["Bar6"]["buttons"] = {};
MOD.Storage["Bar6"]["config"] = {
  outOfRangeColoring = "button",
  tooltip = "enable",
  showGrid = true,
  colors = {
    range = {0.8, 0.1, 0.1},
    mana = {0.5, 0.5, 1.0},
    hp = {0.5, 0.5, 1.0}
  },
  hideElements = {
    macro = false,
    hotkey = false,
    equipped = false
  },
  keyBoundTarget = false,
  clickOnDown = false
}
MOD.Storage["Pet"] = {};
MOD.Storage["Pet"]["bar"] = {};
MOD.Storage["Pet"]["buttons"] = {};
MOD.Storage["Pet"]["config"] = {
  outOfRangeColoring = "button",
  tooltip = "enable",
  showGrid = true,
  colors = {
    range = {0.8, 0.1, 0.1},
    mana = {0.5, 0.5, 1.0},
    hp = {0.5, 0.5, 1.0}
  },
  hideElements = {
    macro = false,
    hotkey = false,
    equipped = false
  },
  keyBoundTarget = false,
  clickOnDown = false
}
MOD.Storage["Stance"] = {};
MOD.Storage["Stance"]["bar"] = {};
MOD.Storage["Stance"]["buttons"] = {};
MOD.Storage["Stance"]["binding"] = "CLICK SVUI_StanceBarButton%d:LeftButton"
MOD.Storage["Stance"]["config"] = {
  outOfRangeColoring = "button",
  tooltip = "enable",
  showGrid = true,
  colors = {
    range = {0.8, 0.1, 0.1},
    mana = {0.5, 0.5, 1.0},
    hp = {0.5, 0.5, 1.0}
  },
  hideElements = {
    macro = false,
    hotkey = false,
    equipped = false
  },
  keyBoundTarget = false,
  clickOnDown = false
}

MOD.Storage['Bar1']["binding"]    = "ACTIONBUTTON%d"
MOD.Storage['Bar2']["binding"]    = "MULTIACTIONBAR2BUTTON%d"
MOD.Storage['Bar3']["binding"]    = "MULTIACTIONBAR1BUTTON%d"
MOD.Storage['Bar4']["binding"]    = "MULTIACTIONBAR4BUTTON%d"
MOD.Storage['Bar5']["binding"]    = "MULTIACTIONBAR3BUTTON%d"
MOD.Storage['Bar6']["binding"]    = "SVUIACTIONBAR6BUTTON%d"
MOD.Storage['Pet']["binding"]     = "BONUSACTIONBUTTON%d"
MOD.Storage['Stance']["binding"]  = "CLICK SVUI_StanceBarButton%d:LeftButton"

MOD.Storage['Bar1']["page"]       = 1
MOD.Storage['Bar2']["page"]       = 5
MOD.Storage['Bar3']["page"]       = 6
MOD.Storage['Bar4']["page"]       = 4
MOD.Storage['Bar5']["page"]       = 3
MOD.Storage['Bar6']["page"]       = 2

MOD.Storage['Bar1']["conditions"]    = ""
MOD.Storage['Bar2']["conditions"]    = ""
MOD.Storage['Bar3']["conditions"]    = ""
MOD.Storage['Bar4']["conditions"]    = ""
MOD.Storage['Bar5']["conditions"]    = ""
MOD.Storage['Bar6']["conditions"]    = ""
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local maxFlyoutCount = 0;
local CLEANFONT = SuperVillain.Media.font.roboto;
local SetSpellFlyoutHook;
local NewFrame = CreateFrame;
local NewHook = hooksecurefunc;
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local Bar_OnEnter = function(self)
	if(self._fade) then
		SuperVillain:SecureFadeIn(self, 0.2, self:GetAlpha(), self._alpha)
	end
end;

local Bar_OnLeave = function(self)
	if(self._fade) then
		SuperVillain:SecureFadeOut(self, 1, self:GetAlpha(), 0)
	end
end;

local function FixKeybindText(button)
	local hotkey = _G[button:GetName()..'HotKey']
	local hotkeyText = hotkey:GetText()
	if hotkeyText then
		hotkeyText = gsub(hotkeyText, 'SHIFT%-', "S")
		hotkeyText = gsub(hotkeyText, 'ALT%-',  "A")
		hotkeyText = gsub(hotkeyText, 'CTRL%-',  "C")
		hotkeyText = gsub(hotkeyText, 'BUTTON',  "MB")
		hotkeyText = gsub(hotkeyText, 'MOUSEWHEELUP', "MU")
		hotkeyText = gsub(hotkeyText, 'MOUSEWHEELDOWN', "MD")
		hotkeyText = gsub(hotkeyText, 'NUMPAD',  "NP")
		hotkeyText = gsub(hotkeyText, 'PAGEUP', "PgU")
		hotkeyText = gsub(hotkeyText, 'PAGEDOWN', "PgD")
		hotkeyText = gsub(hotkeyText, 'SPACE', "SP")
		hotkeyText = gsub(hotkeyText, 'INSERT', "IN")
		hotkeyText = gsub(hotkeyText, 'HOME', "HM")
		hotkeyText = gsub(hotkeyText, 'DELETE', "DEL")
		hotkeyText = gsub(hotkeyText, 'NMULTIPLY', "*")
		hotkeyText = gsub(hotkeyText, 'NMINUS', "N-")
		hotkeyText = gsub(hotkeyText, 'NPLUS', "N+")
		-- hotkeyText = gsub(hotkeyText, 'SHIFT%-', L['KEY_SHIFT'])
		-- hotkeyText = gsub(hotkeyText, 'ALT%-', L['KEY_ALT'])
		-- hotkeyText = gsub(hotkeyText, 'CTRL%-', L['KEY_CTRL'])
		-- hotkeyText = gsub(hotkeyText, 'BUTTON', L['KEY_MOUSEBUTTON'])
		-- hotkeyText = gsub(hotkeyText, 'MOUSEWHEELUP', L['KEY_MOUSEWHEELUP'])
		-- hotkeyText = gsub(hotkeyText, 'MOUSEWHEELDOWN', L['KEY_MOUSEWHEELDOWN'])
		-- hotkeyText = gsub(hotkeyText, 'NUMPAD', L['KEY_NUMPAD'])
		-- hotkeyText = gsub(hotkeyText, 'PAGEUP', L['KEY_PAGEUP'])
		-- hotkeyText = gsub(hotkeyText, 'PAGEDOWN', L['KEY_PAGEDOWN'])
		-- hotkeyText = gsub(hotkeyText, 'SPACE', L['KEY_SPACE'])
		-- hotkeyText = gsub(hotkeyText, 'INSERT', L['KEY_INSERT'])
		-- hotkeyText = gsub(hotkeyText, 'HOME', L['KEY_HOME'])
		-- hotkeyText = gsub(hotkeyText, 'DELETE', L['KEY_DELETE'])
		hotkey:SetText(hotkeyText)
	end;
	hotkey:ClearAllPoints()
	hotkey:SetAllPoints()
end;

local function Pinpoint(parent)
    local centerX,centerY = parent:GetCenter()
    local screenWidth = GetScreenWidth()
    local screenHeight = GetScreenHeight()
    local result;
    if not centerX or not centerY then 
        return "CENTER"
    end;
    local heightTop = screenHeight * 0.75;
    local heightBottom = screenHeight * 0.25;
    local widthLeft = screenWidth * 0.25;
    local widthRight = screenWidth * 0.75;
    if(((centerX > widthLeft) and (centerX < widthRight)) and (centerY > heightTop)) then 
        result="TOP"
    elseif((centerX < widthLeft) and (centerY > heightTop)) then 
        result="TOPLEFT"
    elseif((centerX > widthRight) and (centerY > heightTop)) then 
        result="TOPRIGHT"
    elseif(((centerX > widthLeft) and (centerX < widthRight)) and centerY < heightBottom) then 
        result="BOTTOM"
    elseif((centerX < widthLeft) and (centerY < heightBottom)) then 
        result="BOTTOMLEFT"
    elseif((centerX > widthRight) and (centerY < heightBottom)) then 
        result="BOTTOMRIGHT"
    elseif((centerX < widthLeft) and (centerY > heightBottom) and (centerY < heightTop)) then 
        result="LEFT"
    elseif((centerX > widthRight) and (centerY < heightTop) and (centerY > heightBottom)) then 
        result="RIGHT"
    else 
        result="CENTER"
    end;
    return result 
end;

local function SaveActionButton(parent)
	local button = parent:GetName()
	local cooldown = _G[button.."Cooldown"]
	cooldown.SizeOverride = MOD.db.cooldownSize
	FixKeybindText(parent)
	if not MOD.Storage.Cache[parent] then 
		SuperVillain:AddCD(cooldown)
		MOD.Storage.Cache[parent] = true 
	end
	parent:SetSlotTemplate(true, 2, 0, 0)
end;

local function SetFlyoutButton(button)
	if not button or not button.FlyoutArrow or not button.FlyoutArrow:IsShown() or not button.FlyoutBorder then return end;
	local LOCKDOWN = InCombatLockdown()
	button.FlyoutBorder:SetAlpha(0)
	button.FlyoutBorderShadow:SetAlpha(0)
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	for i = 1, GetNumFlyouts()do 
		local id = GetFlyoutID(i)
		local _, _, max, check = GetFlyoutInfo(id)
		if check then 
			maxFlyoutCount = max;
			break 
		end 
	end;
	local offset = 0;
	if SpellFlyout:IsShown() and SpellFlyout:GetParent() == button or GetMouseFocus() == button then offset = 5 else offset = 2 end;
	if button:GetParent() and button:GetParent():GetParent() and button:GetParent():GetParent():GetName() and button:GetParent():GetParent():GetName() == "SpellBookSpellIconsFrame" then return end;
	if button:GetParent() then 
		local point = Pinpoint(button:GetParent())
		if strfind(point, "RIGHT") then 
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("LEFT", button, "LEFT", -offset, 0)
			SetClampedTextureRotation(button.FlyoutArrow, 270)
			if not LOCKDOWN then 
				button:SetAttribute("flyoutDirection", "LEFT")
			end 
		elseif strfind(point, "LEFT") then 
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("RIGHT", button, "RIGHT", offset, 0)
			SetClampedTextureRotation(button.FlyoutArrow, 90)
			if not LOCKDOWN then 
				button:SetAttribute("flyoutDirection", "RIGHT")
			end 
		elseif strfind(point, "TOP") then 
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("BOTTOM", button, "BOTTOM", 0, -offset)
			SetClampedTextureRotation(button.FlyoutArrow, 180)
			if not LOCKDOWN then 
				button:SetAttribute("flyoutDirection", "DOWN")
			end 
		elseif point == "CENTER" or strfind(point, "BOTTOM") then 
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("TOP", button, "TOP", 0, offset)
			SetClampedTextureRotation(button.FlyoutArrow, 0)
			if not LOCKDOWN then 
				button:SetAttribute("flyoutDirection", "UP")
			end 
		end
	end 
end;

local function ModifyActionButton(parent)
	local button = parent:GetName()
	local icon = _G[button.."Icon"]
	local count = _G[button.."Count"]
	local flash = _G[button.."Flash"]
	local hotkey = _G[button.."HotKey"]
	local border = _G[button.."Border"]
	local normal = _G[button.."NormalTexture"]
	local cooldown = _G[button.."Cooldown"]
	local parentTex = parent:GetNormalTexture()
	local shine = _G[button.."Shine"]
	local highlight = parent:GetHighlightTexture()
	local pushed = parent:GetPushedTexture()
	local checked = parent:GetCheckedTexture()
	if cooldown then
		cooldown.SizeOverride = MOD.db.cooldownSize
	end;
	if highlight then 
		highlight:SetTexture(1,1,1,.2)
	end;
	if pushed then 
		pushed:SetTexture(0,0,0,.4)
	end;
	if checked then 
		checked:SetTexture(1,1,1,.2)
	end;
	if flash then 
		flash:SetTexture(nil)
	end;
	if normal then 
		normal:SetTexture(nil)
		normal:Hide()
		normal:SetAlpha(0)
	end;
	if parentTex then 
		parentTex:SetTexture(nil)
		parentTex:Hide()
		parentTex:SetAlpha(0)
	end;
	if border then border:MUNG()end;
	if count then 
		count:ClearAllPoints()
		count:SetPoint("BOTTOMRIGHT",1,1)
		count:SetShadowOffset(1,-1)
		count:SetFontTemplate(LSM:Fetch("font",MOD.db.font),MOD.db.fontSize,MOD.db.fontOutline)
	end;
	if icon then 
		icon:SetTexCoord(.1,.9,.1,.9)
		icon:SetGradient("VERTICAL",.5,.5,.5,1,1,1)
		icon:FillInner()
	end;
	if shine then shine:SetAllPoints()end;
	if MOD.db.hotkeytext then 
		hotkey:ClearAllPoints()
		hotkey:SetAllPoints()
		hotkey:SetFont(CLEANFONT,10,"OUTLINE")
		hotkey:SetJustifyH("RIGHT")
    	hotkey:SetJustifyV("TOP")
		hotkey:SetShadowOffset(1,-1)
	end;
	if parent.style then 
		parent.style:SetDrawLayer('BACKGROUND',-7)
	end;
	parent.FlyoutUpdateFunc = SetFlyoutButton;
	FixKeybindText(parent)
end;

do
	local SpellFlyoutButton_OnEnter = function(self)
		local parent = self:GetParent()
		local anchor = select(2, parent:GetPoint())
		if not MOD.Storage.Cache[anchor] then return end;
		local anchorParent = anchor:GetParent()
		if anchorParent._fade then
			local alpha = anchorParent._alpha
			local actual = anchorParent:GetAlpha()
			SuperVillain:SecureFadeIn(anchorParent, 0.2, actual, alpha)
		end
	end

	local SpellFlyoutButton_OnLeave = function(self)
		local parent = self:GetParent()
		local anchor = select(2, parent:GetPoint())
		if not MOD.Storage.Cache[anchor] then return end;
		local anchorParent = anchor:GetParent()
		if anchorParent._fade then
			local actual = anchorParent:GetAlpha()
			SuperVillain:SecureFadeOut(anchorParent, 1, actual, 0)
		end
	end

	local SpellFlyout_OnEnter = function(self)
		local anchor = select(2,self:GetPoint())
		if not MOD.Storage.Cache[anchor] then return end;
		local anchorParent = anchor:GetParent()
		if anchorParent._fade then 
			Bar_OnEnter(anchorParent)	
		end
	end

	local SpellFlyout_OnLeave = function(self)
		local anchor = select(2, self:GetPoint())
		if not MOD.Storage.Cache[anchor] then return end;
		local anchorParent=anchor:GetParent()
		if anchorParent._fade then 
			Bar_OnLeave(anchorParent)
		end
	end

	local SpellFlyout_OnShow = function()
		for i=1,maxFlyoutCount do
			if _G["SpellFlyoutButton"..i] then 
				ModifyActionButton(_G["SpellFlyoutButton"..i])
				SaveActionButton(_G["SpellFlyoutButton"..i])

				_G["SpellFlyoutButton"..i]:HookScript('OnEnter', SpellFlyoutButton_OnEnter)
				
				_G["SpellFlyoutButton"..i]:HookScript('OnLeave', SpellFlyoutButton_OnLeave)
			end 
		end;
		SpellFlyout:HookScript('OnEnter', SpellFlyout_OnEnter)
		SpellFlyout:HookScript('OnLeave', SpellFlyout_OnLeave)
	end

	local QualifyFlyouts = function()
		if InCombatLockdown() then return end;
		for button,_ in pairs(MOD.Storage.Cache)do 
			if(button and button.FlyoutArrow) then
				SetFlyoutButton(button)
			end 
		end;
	end;

	function SetSpellFlyoutHook()
		SpellFlyout:HookScript("OnShow",SpellFlyout_OnShow);
		SuperVillain:ExecuteTimer(QualifyFlyouts, 5)
	end
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdateBarBindings(pet,stance)
	if stance == true then
		local preset = self.Storage['Stance'];
		local bindText = preset.binding;
	  	for i=1,NUM_STANCE_SLOTS do
		    if self.db.hotkeytext then
		    	local key = format(bindText, i);
		    	local binding = GetBindingKey(key)
		      	_G["SVUI_StanceBarButton"..i.."HotKey"]:Show()
		      	_G["SVUI_StanceBarButton"..i.."HotKey"]:SetText(binding)
		      	FixKeybindText(_G["SVUI_StanceBarButton"..i])
		    else 
		      	_G["SVUI_StanceBarButton"..i.."HotKey"]:Hide()
		    end 
	  	end
  	end
  	if pet == true then
  		local preset = self.Storage['Pet'];
		local bindText = preset.binding;
	  	for i=1,NUM_PET_ACTION_SLOTS do 
		    if self.db.hotkeytext then 
		      	local key = format(bindText, i);
		    	local binding = GetBindingKey(key)
		      	_G["PetActionButton"..i.."HotKey"]:Show()
		      	_G["PetActionButton"..i.."HotKey"]:SetText(binding)
		      	FixKeybindText(_G["PetActionButton"..i])
		    else
	    		_G["PetActionButton"..i.."HotKey"]:Hide()
	    	end;
	  	end
	end
end;

function MOD:UpdateAllBindings(event)
	if event == "UPDATE_BINDINGS" then 
		MOD:UpdateBarBindings(true,true)
	end;
	MOD:UnregisterEvent("PLAYER_REGEN_DISABLED")
	if InCombatLockdown()then return end;
	for barID,stored in pairs(MOD.Storage)do
		if (type(stored) == "table" and (barID ~= "Pet" and barID ~= "Stance" and barID ~= "Cache")) then
			local bar = stored.bar;
			local buttons = stored.buttons;
			if not bar or not buttons then return end;
			ClearOverrideBindings(bar);
			local nameMod = bar:GetName().."Button";
			local thisBinding = stored.binding;
			for i=1,#buttons do 
				local binding = format(thisBinding, i);
				local btn = nameMod..i;
				for x=1,select('#',GetBindingKey(binding)) do 
					local key = select(x,GetBindingKey(binding))
					if (key and key ~= "") then 
						SetOverrideBindingClick(bar,false,key,btn)
					end;
				end 
			end 
		end
	end;
end;

function MOD:SetBarConfigData(barID)
	local data = self.Storage[barID]
	local thisBinding = data.binding;
	local buttonList = data.buttons;
	data.config.hideElements.macro = self.db.macrotext;
	data.config.hideElements.hotkey = self.db.hotkeytext;
	data.config.showGrid = self.db.showGrid;
	data.config.clickOnDown = self.db.keyDown;
	data.config.colors.range = self.db.unc
	data.config.colors.mana = self.db.unpc
	data.config.colors.hp = self.db.unpc
	SetModifiedClick("PICKUPACTION", self.db.unlock)
	for i,button in pairs(buttonList)do
		if thisBinding then
			data.config.keyBoundTarget = format(thisBinding,i)
		end
		button.keyBoundTarget = data.config.keyBoundTarget;
		button.postKeybind = self.FixKeybindText;
		button:SetAttribute("buttonlock",true)
		button:SetAttribute("checkselfcast",true)
		button:SetAttribute("checkfocuscast",true)
		button:UpdateConfig(data.config)
	end
end;

function MOD:UpdateBarPagingDefaults()
	local parse = "[vehicleui,mod:alt,mod:ctrl] %d; [possessbar] %d; [overridebar] %d; [form,noform] 0; [shapeshift] 13; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;";
	if self.db.Bar6.enable then
		parse = "[vehicleui,mod:alt,mod:ctrl] %d; [possessbar] %d; [overridebar] %d; [form,noform] 0; [shapeshift] 13; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;";
	end;
	if self.db.Bar1.useCustomPaging then
		parse = parse .. " " .. self.db.Bar1.customPaging[SuperVillain.class];
	end
	self.Storage['Bar1'].conditions = format(parse, GetVehicleBarIndex(), GetVehicleBarIndex(), GetOverrideBarIndex());
	for i=2, 6 do
		if self.db['Bar'..i].useCustomPaging then
			self.Storage['Bar'..i].conditions = self.db['Bar'..i].customPaging[SuperVillain.class];
		end
	end;
	if((not SuperVillain.db.SVBar.enable or InCombatLockdown()) or not self.isInitialized) then return end;
	local Bar2Option = InterfaceOptionsActionBarsPanelBottomRight
	local Bar3Option = InterfaceOptionsActionBarsPanelBottomLeft
	local Bar4Option = InterfaceOptionsActionBarsPanelRightTwo
	local Bar5Option = InterfaceOptionsActionBarsPanelRight

	if (self.db.Bar2.enable and not Bar2Option:GetChecked()) or (not self.db.Bar2.enable and Bar2Option:GetChecked())  then
		Bar2Option:Click()
	end
	
	if (self.db.Bar3.enable and not Bar3Option:GetChecked()) or (not self.db.Bar3.enable and Bar3Option:GetChecked())  then
		Bar3Option:Click()
	end
	
	if not self.db.Bar5.enable and not self.db.Bar4.enable then
		if Bar4Option:GetChecked() then
			Bar4Option:Click()
		end				
		
		if Bar5Option:GetChecked() then
			Bar5Option:Click()
		end
	elseif not self.db.Bar5.enable then
		if not Bar5Option:GetChecked() then
			Bar5Option:Click()
		end
		
		if not Bar4Option:GetChecked() then
			Bar4Option:Click()
		end
	elseif (self.db.Bar4.enable and not Bar4Option:GetChecked()) or (not self.db.Bar4.enable and Bar4Option:GetChecked()) then
		Bar4Option:Click()
	elseif (self.db.Bar5.enable and not Bar5Option:GetChecked()) or (not self.db.Bar5.enable and Bar5Option:GetChecked()) then
		Bar5Option:Click()
	end
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
do
	local Button_OnEnter = function(self)
		local parent = self:GetParent()
		if parent and parent._fade then 
			SuperVillain:SecureFadeIn(parent, 0.2, parent:GetAlpha(), parent._alpha)
		end
	end;

	local Button_OnLeave = function(self)
		local parent = self:GetParent()
		GameTooltip:Hide()
		if parent and parent._fade then 
			SuperVillain:SecureFadeOut(parent, 1, parent:GetAlpha(), 0)
		end
	end;

	local function _refreshButtons(bar, id, max, space, cols, totalButtons, size, point, selfcast)
		if InCombatLockdown() then return end;
		if not bar then return end;
		local hideByScale = id == "Pet" and true or false;
		local isStance = id == "Stance" and true or false;
		local button,lastButton,lastRow;
		for i=1, max do 
			button = MOD.Storage[id].buttons[i]
			lastButton = MOD.Storage[id].buttons[i - 1]
			lastRow = MOD.Storage[id].buttons[i - cols]
			button:SetParent(bar)
			button:ClearAllPoints()
			button:Size(size)
			button:SetAttribute("showgrid",1)

			if(selfcast) then
				button:SetAttribute("unit2", "player")
			end;

			if(not button._hookFade) then 
				button:HookScript('OnEnter', Button_OnEnter)
				button:HookScript('OnLeave', Button_OnLeave)
				-- if(hideByScale) then
				-- 	NewHook(button, "SetAlpha", function(self) print(self:GetName());print(self:GetAlpha()) end)
				-- end
				button._hookFade = true;
			end;

			local x,y,anchor1,anchor2;

			if(i == 1) then
				x, y = 0, 0
				if(point:find("BOTTOM")) then
					y = space
				elseif(point:find("TOP")) then
					y = -space
				end
				if(point:find("RIGHT")) then
					x = -space
				elseif(point:find("LEFT")) then
					x = space
				end
				button:Point(point,bar,point,x,y)
			elseif((i - 1) % cols == 0) then 
				x, y = 0, -space
				anchor1, anchor2 = "TOP", "BOTTOM"
		      	if(point:find("BOTTOM")) then 
		        	y = space;
		        	anchor1 = "BOTTOM"
		        	anchor2 = "TOP"
		      	end
				button:Point(anchor1,lastRow,anchor2,x,y)
			else 
				x, y = space, 0
		      	anchor1, anchor2 = "LEFT", "RIGHT";
		      	if(point:find("RIGHT")) then 
		        	x = -space;
		        	anchor1 = "RIGHT"
		        	anchor2 = "LEFT"
		      	end
				button:Point(anchor1,lastButton,anchor2,x,y)
			end;

			if(i > totalButtons) then
				if hideByScale then
					button:SetScale(0.000001)
	      			button:SetAlpha(0)
				else 
					button:Hide()
				end
			else 
				if hideByScale then
					button:SetScale(1)
	      			button:SetAlpha(1)
				else 
					button:Show()
				end
			end;

			if (not isStance or (isStance and not button.FlyoutUpdateFunc)) then 
	      		ModifyActionButton(button);
	      		SaveActionButton(button);
	    	end
		end;
	end;

	local function _getPage(bar, defaultPage, condition)
		local page = MOD.db[bar].customPaging[SuperVillain.class]
		if not condition then condition = '' end
		if not page then page = '' end
		if page then
			condition = condition.." "..page
		end
		condition = condition.." "..defaultPage
		return condition
	end

	function MOD:RefreshBar(id)
		if(InCombatLockdown() or (not self.Storage[id] or not self.Storage[id].bar or not self.db[id])) then return end;
		local db = self.db[id];
		local data = self.Storage[id]
		local selfcast = self.db.rightClickSelf
		local bar = data.bar;
		local space = db.buttonspacing;
		local cols = db.buttonsPerRow;
		local size = db.buttonsize;
		local point = db.point;
		local barVisibility = db.customVisibility;
		local isPet = id == "Pet" and true or false;
		local isStance = id == "Stance" and true or false;
		local totalButtons = db.buttons;
		local max = isStance and GetNumShapeshiftForms() or totalButtons;
		local rows = ceil(max  /  cols);

		if max < cols then cols = max end;
		if rows < 1 then rows = 1 end;
		bar:Width(space  +  (size  *  cols)  +  ((space  *  (cols - 1))  +  space));
		bar:Height((space  +  (size  *  rows))  +  ((space  *  (rows - 1))  +  space));
		bar.backdrop:ClearAllPoints()
	  	bar.backdrop:SetAllPoints()
		bar._fade = db.mouseover;
		bar._alpha = db.alpha;

		if db.backdrop == true then 
			bar.backdrop:Show()
		else 
			bar.backdrop:Hide()
		end;

		if(not bar._hookFade) then 
			bar:HookScript('OnEnter', Bar_OnEnter)
			bar:HookScript('OnLeave', Bar_OnLeave)
			bar._hookFade = true;
		end;

		if(db.mouseover == true) then 
			bar:SetAlpha(0)
			bar._fade = true
		else 
			bar:SetAlpha(db.alpha)
			bar._fade = false 
		end;
		
		_refreshButtons(bar, id, max, space, cols, totalButtons, size, point, selfcast);

		if(isPet or isStance) then
			if db.enable then 
				bar:SetScale(1)
				bar:SetAlpha(db.alpha)
			else 
				bar:SetScale(0.000001)
				bar:SetAlpha(0)
			end
			if isPet then
				RegisterStateDriver(bar, "show", barVisibility)
			end
		else
		  	local page = _getPage(id, data.page, data.conditions)
			if data.conditions:find("[form, noform]") then
				bar:SetAttribute("hasTempBar", true)
				local newCondition = gsub(data.conditions, " %[form, noform%] 0; ", "");
				bar:SetAttribute("newCondition", newCondition)
			else
				bar:SetAttribute("hasTempBar", false)
			end

			RegisterStateDriver(bar, "page", page)
			if not bar.ready then
				bar.ready = true;
				self:RefreshBar(id) 
				return
			end
			
			if db.enable == true then
				bar:Show()
				RegisterStateDriver(bar, "visibility", barVisibility)
			else
				bar:Hide()
				UnregisterStateDriver(bar, "visibility")
			end;
			SuperVillain:SetSnapOffset("SVUI_Action"..id.."_MOVE", (space  /  2))
		end
	end;
end;

function MOD:RefreshActionBars()
	if InCombatLockdown() then return end;
	self:UpdateBarPagingDefaults()
	for button,_ in pairs(self.Storage.Cache)do 
		if button then 
			ModifyActionButton(button)
			SaveActionButton(button)
			if(button.FlyoutArrow) then
				SetFlyoutButton(button)
			end
		else 
			self.Storage.Cache[button]=nil 
		end 
	end;
	for t=1,6 do 
		self:RefreshBar("Bar"..t)
	end;
	self:RefreshBar("Pet")
	self:RefreshBar("Stance")
	self:UpdateBarBindings(true,true)
	for barID,stored in pairs(self.Storage)do
		if barID ~= "Pet" and barID ~= "Stance" then
			self:SetBarConfigData(barID)
		end
	end;
end;

local Vehicle_Updater = function()
	local bar = MOD.Storage['Bar1'].bar
	local space = SuperVillain:Scale(MOD.db['Bar1'].buttonspacing)
	local total = MOD.db['Bar1'].buttons;
	local rows = MOD.db['Bar1'].buttonsPerRow;
	local size = SuperVillain:Scale(MOD.db['Bar1'].buttonsize)
	local point = MOD.db['Bar1'].point;
	local columns = ceil(total / rows)
	if (HasOverrideActionBar() or HasVehicleActionBar()) and total==12 then 
		bar.backdrop:ClearAllPoints()
		bar.backdrop:Point(MOD.db['Bar1'].point, bar, MOD.db['Bar1'].point)
		bar.backdrop:Width(space + ((size * rows) + (space * (rows - 1)) + space))
		bar.backdrop:Height(space + ((size * columns) + (space * (columns - 1)) + space))
		bar.backdrop:SetFrameLevel(0);
	else 
		bar.backdrop:SetAllPoints()
		bar.backdrop:SetFrameLevel(0);
	end
	MOD:RefreshBar("Bar1")
end;
--[[ 
########################################################## 
HOOKED / REGISTERED FUNCTIONS
##########################################################
]]--
local CreateExtraBar = function(self)
	local specialBar = CreateFrame("Frame", "SVUI_SpecialAbility", SuperVillain.UIParent)
	specialBar:Point("BOTTOM", SuperVillain.UIParent, "BOTTOM", 0, 150)
	specialBar:Size(ExtraActionBarFrame:GetSize())
	ExtraActionBarFrame:SetParent(specialBar)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", specialBar, "CENTER")
	ExtraActionBarFrame.ignoreFramePositionManager = true;
	local max = ExtraActionBarFrame:GetNumChildren()
	for i = 1, max do 
		if _G["ExtraActionButton"..i] then 
			_G["ExtraActionButton"..i].noResize = true;
			_G["ExtraActionButton"..i].pushed = true;
			_G["ExtraActionButton"..i].checked = true;
			ModifyActionButton(_G["ExtraActionButton"..i])
			_G["ExtraActionButton"..i]:SetFixedPanelTemplate()
			_G["ExtraActionButton"..i.."Icon"]:SetDrawLayer("ARTWORK")
			_G["ExtraActionButton"..i.."Cooldown"]:FillInner()
			local checkedTexture = _G["ExtraActionButton"..i]:CreateTexture(nil, "OVERLAY")
			checkedTexture:SetTexture(0.9, 0.8, 0.1, 0.3)
			checkedTexture:FillInner()
			_G["ExtraActionButton"..i]:SetCheckedTexture(checkedTexture)
		end 
	end
	if HasExtraActionBar()then 
		ExtraActionBarFrame:Show()
	end
	SuperVillain:SetSVMovable(specialBar, "SVUI_SpecialAbility_MOVE", L["Boss Button"], nil, nil, nil, "ALL, ACTIONBAR")
	
	local exitButton = CreateFrame("Button", "SVUI_BailOut", SuperVillain.UIParent, "SecureHandlerClickTemplate")
	exitButton:Size(64, 64)
	exitButton:Point("TOPLEFT", SVUI_MinimapFrame, "BOTTOMLEFT", 2, -2)
	exitButton:SetNormalTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\EXIT")
	exitButton:SetPushedTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\EXIT")
	exitButton:SetHighlightTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\EXIT")
	exitButton:SetFixedPanelTemplate("Transparent")
	exitButton:RegisterForClicks("AnyUp")
	exitButton:SetScript("OnClick", VehicleExit)
	RegisterStateDriver(exitButton, "visibility", "[vehicleui] show;hide")
end

local SVUIOptionsPanel_OnEvent = function()
	InterfaceOptionsActionBarsPanelBottomRight.Text:SetText(format(L['Remove Bar %d Action Page'],2))
	InterfaceOptionsActionBarsPanelBottomLeft.Text:SetText(format(L['Remove Bar %d Action Page'],3))
	InterfaceOptionsActionBarsPanelRightTwo.Text:SetText(format(L['Remove Bar %d Action Page'],4))
	InterfaceOptionsActionBarsPanelRight.Text:SetText(format(L['Remove Bar %d Action Page'],5))
	InterfaceOptionsActionBarsPanelBottomRight:SetScript('OnEnter',nil)
	InterfaceOptionsActionBarsPanelBottomLeft:SetScript('OnEnter',nil)
	InterfaceOptionsActionBarsPanelRightTwo:SetScript('OnEnter',nil)
	InterfaceOptionsActionBarsPanelRight:SetScript('OnEnter',nil)
end;

local SVUIButton_ShowOverlayGlow = function(self)
	if not self.overlay then return end; 
	local size = self:GetWidth() / 3;
	self.overlay:WrapOuter(self, size)
end;

local function ResetAllBindings()
	if InCombatLockdown()then return end;
	for barID,stored in pairs(MOD.Storage)do
		local bar = stored.bar;
		if not bar then return end;
		ClearOverrideBindings(bar);
	end;
	MOD:RegisterEvent("PLAYER_REGEN_DISABLED","UpdateAllBindings")
end;

local function RemoveDefaults()
  local removalManager=CreateFrame("Frame")
  removalManager:Hide()
  MultiBarBottomLeft:SetParent(removalManager)
  MultiBarBottomRight:SetParent(removalManager)
  MultiBarLeft:SetParent(removalManager)
  MultiBarRight:SetParent(removalManager)
  for i=1,12 do 
  	_G["ActionButton"..i]:Hide()
  	_G["ActionButton"..i]:UnregisterAllEvents()
  	_G["ActionButton"..i]:SetAttribute("statehidden",true)
  	_G["MultiBarBottomLeftButton"..i]:Hide()
  	_G["MultiBarBottomLeftButton"..i]:UnregisterAllEvents()
  	_G["MultiBarBottomLeftButton"..i]:SetAttribute("statehidden",true)
  	_G["MultiBarBottomRightButton"..i]:Hide()
  	_G["MultiBarBottomRightButton"..i]:UnregisterAllEvents()
  	_G["MultiBarBottomRightButton"..i]:SetAttribute("statehidden",true)
  	_G["MultiBarRightButton"..i]:Hide()
  	_G["MultiBarRightButton"..i]:UnregisterAllEvents()
  	_G["MultiBarRightButton"..i]:SetAttribute("statehidden",true)
  	_G["MultiBarLeftButton"..i]:Hide()
  	_G["MultiBarLeftButton"..i]:UnregisterAllEvents()
  	_G["MultiBarLeftButton"..i]:SetAttribute("statehidden",true)
  	if _G["VehicleMenuBarActionButton"..i] then 
  		_G["VehicleMenuBarActionButton"..i]:Hide()
  		_G["VehicleMenuBarActionButton"..i]:UnregisterAllEvents()
  		_G["VehicleMenuBarActionButton"..i]:SetAttribute("statehidden",true)
  	end;
  	if _G['OverrideActionBarButton'..i] then 
  		_G['OverrideActionBarButton'..i]:Hide()
  		_G['OverrideActionBarButton'..i]:UnregisterAllEvents()
  		_G['OverrideActionBarButton'..i]:SetAttribute("statehidden",true)
  	end;
  	_G['MultiCastActionButton'..i]:Hide()
  	_G['MultiCastActionButton'..i]:UnregisterAllEvents()
  	_G['MultiCastActionButton'..i]:SetAttribute("statehidden",true)
  end;
  ActionBarController:UnregisterAllEvents()
  ActionBarController:RegisterEvent('UPDATE_EXTRA_ACTIONBAR')
  MainMenuBar:EnableMouse(false)
  MainMenuBar:SetAlpha(0)
  MainMenuExpBar:UnregisterAllEvents()
  MainMenuExpBar:Hide()
  MainMenuExpBar:SetParent(removalManager)
  local maxChildren = MainMenuBar:GetNumChildren();
  for i=1,maxChildren do
  	local child=select(i,MainMenuBar:GetChildren())
  	if child then 
  		child:UnregisterAllEvents()
  		child:Hide()
  		child:SetParent(removalManager)
  	end 
  end;
  ReputationWatchBar:UnregisterAllEvents()
  ReputationWatchBar:Hide()
  ReputationWatchBar:SetParent(removalManager)
  MainMenuBarArtFrame:UnregisterEvent("ACTIONBAR_PAGE_CHANGED")
  MainMenuBarArtFrame:UnregisterEvent("ADDON_LOADED")
  MainMenuBarArtFrame:Hide()
  MainMenuBarArtFrame:SetParent(removalManager)
  StanceBarFrame:UnregisterAllEvents()
  StanceBarFrame:Hide()
  StanceBarFrame:SetParent(removalManager)
  OverrideActionBar:UnregisterAllEvents()
  OverrideActionBar:Hide()
  OverrideActionBar:SetParent(removalManager)
  PossessBarFrame:UnregisterAllEvents()
  PossessBarFrame:Hide()
  PossessBarFrame:SetParent(removalManager)
  PetActionBarFrame:UnregisterAllEvents()
  PetActionBarFrame:Hide()
  PetActionBarFrame:SetParent(removalManager)
  MultiCastActionBarFrame:UnregisterAllEvents()
  MultiCastActionBarFrame:Hide()
  MultiCastActionBarFrame:SetParent(removalManager)
  IconIntroTracker:UnregisterAllEvents()
  IconIntroTracker:Hide()
  IconIntroTracker:SetParent(removalManager)
  InterfaceOptionsCombatPanelActionButtonUseKeyDown:SetScale(0.0001)
  InterfaceOptionsCombatPanelActionButtonUseKeyDown:SetAlpha(0)
  InterfaceOptionsActionBarsPanelAlwaysShowActionBars:EnableMouse(false)
  InterfaceOptionsActionBarsPanelPickupActionKeyDropDownButton:SetScale(0.0001)
  InterfaceOptionsActionBarsPanelLockActionBars:SetScale(0.0001)
  InterfaceOptionsActionBarsPanelAlwaysShowActionBars:SetAlpha(0)
  InterfaceOptionsActionBarsPanelPickupActionKeyDropDownButton:SetAlpha(0)
  InterfaceOptionsActionBarsPanelLockActionBars:SetAlpha(0)
  InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetAlpha(0)
  InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetScale(0.00001)
  InterfaceOptionsStatusTextPanelXP:SetAlpha(0)
  InterfaceOptionsStatusTextPanelXP:SetScale(0.00001)
  if PlayerTalentFrame then
    PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
  else
    hooksecurefunc("TalentFrame_LoadUI", function() PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED") end)
  end
end;
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:UpdateThisPackage()
	self:RefreshActionBars();
end;

function MOD:ConstructThisPackage()
	if not SuperVillain.db.SVBar.enable then return end;
	RemoveDefaults();
	self:Protect("RefreshActionBars");
	self:UpdateBarPagingDefaults();
	SuperVillain.Registry:RunTemp("SVBar");
	self:RegisterEvent("UPDATE_BINDINGS", "UpdateAllBindings")
	self:RegisterEvent("PET_BATTLE_CLOSE", "UpdateAllBindings")
	self:RegisterEvent("PET_BATTLE_OPENING_DONE", ResetAllBindings)
	self:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR", Vehicle_Updater)
	self:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR", Vehicle_Updater)
	if C_PetBattles.IsInBattle()then 
		ResetAllBindings()
	else 
		self:UpdateAllBindings()
	end;
	NewHook("BlizzardOptionsPanel_OnEvent", SVUIOptionsPanel_OnEvent)
	NewHook("ActionButton_ShowOverlayGlow", SVUIButton_ShowOverlayGlow)
	if not GetCVarBool("lockActionBars") then SetCVar("lockActionBars", 1) end;
	SetSpellFlyoutHook()
	MOD.IsLoaded = true
end;

SuperVillain.Registry:NewPackage(MOD, "SVBar")
SuperVillain.Registry:Temp("SVBar", CreateExtraBar)