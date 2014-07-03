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
local MOD = SuperVillain.Registry:Expose('SVBar');
--[[ 
########################################################## 
PACKAGE PLUGIN
##########################################################
]]--
local function SetStanceBarButtons()
  local maxForms = GetNumShapeshiftForms();
  local currentForm = GetShapeshiftForm();
  local maxButtons = NUM_STANCE_SLOTS;
  local texture, name, isActive, isCastable, _;
  for i = 1, maxButtons do
	local button = _G["SVUI_StanceBarButton"..i]
	local icon = _G["SVUI_StanceBarButton"..i.."Icon"]
	local cd = _G["SVUI_StanceBarButton"..i.."Cooldown"]
	if i  <= maxForms then 
	  texture, name, isActive, isCastable = GetShapeshiftFormInfo(i)
	  if texture == "Interface\\Icons\\Spell_Nature_WispSplode" and MOD.db.Stance.style == "darkenInactive" then 
		_, _, texture = GetSpellInfo(name)
	  end;
	  icon:SetTexture(texture)
	  if texture then 
		cd:SetAlpha(1)
	  else 
		cd:SetAlpha(0)
	  end;
	  if isActive then 
		StanceBarFrame.lastSelected = button:GetID()
		if maxForms == 1 then 
		  button:SetChecked(1)
		else
		  if button.checked then button.checked:SetTexture(0, 0.5, 0, 0.2) end
		  button:SetBackdropBorderColor(0.4, 0.8, 0)
		  button:SetChecked(MOD.db.Stance.style ~= "darkenInactive")
		end 
	  else 
		if maxForms == 1 or currentForm == 0 then 
		  button:SetChecked(0)
		else
		  button:SetBackdropBorderColor(0, 0, 0)
		  button:SetChecked(MOD.db.Stance.style == "darkenInactive")
		  if button.checked then 
			button.checked:SetAlpha(1)
			if MOD.db.Stance.style == "darkenInactive" then 
			  button.checked:SetTexture(0, 0, 0, 0.75)
			else 
			  button.checked:SetTexture(1, 1, 1, 0.25)
			end
		  end
		end 
	  end;
	  if isCastable then 
		icon:SetVertexColor(1.0, 1.0, 1.0)
	  else 
		icon:SetVertexColor(0.4, 0.4, 0.4)
	  end 
	end 
  end 
end;

local function UpdateShapeshiftForms(self, event)
  if InCombatLockdown() or not _G["SVUI_StanceBar"] then return end;
  local bar = _G["SVUI_StanceBar"];
  for i = 1, #MOD.Storage["Stance"].buttons do 
	MOD.Storage["Stance"].buttons[i]:Hide()
  end;
  local ready = false;
  local maxForms = GetNumShapeshiftForms()
  for i = 1, NUM_STANCE_SLOTS do 
	if not MOD.Storage["Stance"].buttons[i]then 
	  MOD.Storage["Stance"].buttons[i] = CreateFrame("CheckButton", format("SVUI_StanceBarButton%d", i), bar, "StanceButtonTemplate")
	  MOD.Storage["Stance"].buttons[i]:SetID(i)
	  ready = true 
	end;
	if i <= maxForms then 
	  MOD.Storage["Stance"].buttons[i]:Show()
	else 
	  MOD.Storage["Stance"].buttons[i]:Hide()
	end 
  end;
  MOD:RefreshBar("Stance")
  if event == "UPDATE_SHAPESHIFT_FORMS" then 
	SetStanceBarButtons()
  end;
  if not C_PetBattles.IsInBattle() or ready then 
	if maxForms == 0 then 
	  UnregisterStateDriver(bar, "show")
	  bar:Hide()
	else 
	  bar:Show()
	  RegisterStateDriver(bar, "show", "[petbattle] hide;show")
	end 
  end 
end;

local function UpdateShapeshiftCD()
  local maxForms = GetNumShapeshiftForms()
  for i = 1, NUM_STANCE_SLOTS do 
	if i  <= maxForms then 
	  local cooldown = _G["SVUI_StanceBarButton"..i.."Cooldown"]
	  local start, duration, enable = GetShapeshiftFormCooldown(i)
	  CooldownFrame_SetTimer(cooldown, start, duration, enable)
	end 
  end
end;

local CreateStanceBar = function(self)
  local barID = "Stance";
  local parent = _G["SVUI_ActionBar1"]
  local maxForms = GetNumShapeshiftForms();
  if self.db["Bar2"].enable then 
	parent = _G["SVUI_ActionBar2"]
  end;
  local stanceBar = CreateFrame("Frame", "SVUI_StanceBar", SuperVillain.UIParent, "SecureHandlerStateTemplate")
  stanceBar:Point("BOTTOMRIGHT",parent,"TOPRIGHT",0,2);
  stanceBar:SetFrameLevel(5);
  local bg = CreateFrame("Frame", nil, stanceBar)
  bg:SetAllPoints();
  bg:SetFrameLevel(0);
  bg:SetPanelTemplate("Component")
  bg:SetPanelColor("dark")
  stanceBar.backdrop = bg;
  for i = 1, NUM_STANCE_SLOTS do
	self.Storage[barID].buttons[i] = _G["SVUI_StanceBarButton"..i]
  end
  stanceBar:SetAttribute("_onstate-show", [[    
	if newstate == "hide" then
	  self:Hide();
	else
	  self:Show();
	end 
  ]]);
  self.Storage[barID].bar = stanceBar;
  self:RegisterEvent("UPDATE_SHAPESHIFT_FORMS", UpdateShapeshiftForms)
  self:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN", UpdateShapeshiftCD)
  self:RegisterEvent("UPDATE_SHAPESHIFT_USABLE", SetStanceBarButtons)
  self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", SetStanceBarButtons)
  self:RegisterEvent("ACTIONBAR_PAGE_CHANGED", SetStanceBarButtons)
  UpdateShapeshiftForms()
  SuperVillain:SetSVMovable(stanceBar, "SVUI_StanceBar_MOVE", L["Stance Bar"], nil, -3, nil, "ALL, ACTIONBARS")
  self:RefreshBar("Stance")
  SetStanceBarButtons()
  self:UpdateBarBindings(false, true)
end;

SuperVillain.Registry:Temp("SVBar", CreateStanceBar)