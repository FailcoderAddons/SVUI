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
local select  = _G.select;
local pairs   = _G.pairs;
local ipairs  = _G.ipairs;
local type    = _G.type;
local string  = _G.string;
local math    = _G.math;
local table   = _G.table;
local GetTime = _G.GetTime;
--[[ STRING METHODS ]]--
local format, find = string.format, string.find;
--[[ MATH METHODS ]]--
local floor = math.floor;
local tonumber = tonumber;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVBar');
local LibAB = LibStub("LibActionButton-1.0")

local _G = getfenv(0);

local RefreshBindings
local NewFrame = CreateFrame;
local NewHook = hooksecurefunc;

local Binder = NewFrame("Frame", nil, UIParent);
--[[ 
########################################################## 
BINDING UPDATES
##########################################################
]]--
do
  --[[ HANDLERS ]]--
  local GameTooltip_OnHide = function(self)
    self:SetOwner(Binder, "ANCHOR_TOP")
    self:SetPoint("BOTTOM", Binder, "TOP", 0, 1)
    self:AddLine(Binder.button.name, 1, 1, 1)
    Binder.button.bindings = {GetBindingKey(Binder.button.bindstring)}
    local count = #Binder.button.bindings
    if(count == 0) then 
      self:AddLine(L["No bindings set."], .6, .6, .6)
    else 
      self:AddDoubleLine(L["Binding"], L["Key"], .6, .6, .6, .6, .6, .6)
      for i = 1, count do 
        self:AddDoubleLine(i, Binder.button.bindings[i])
      end 
    end;
    self:Show()
    self:SetScript("OnHide", nil)
  end
  --[[ END OF HANDLERS ]]--

  function RefreshBindings(bindTarget, bindType)
    if(not Binder.active or InCombatLockdown()) then return end;
    Binder.button = bindTarget;
    Binder.spellmacro = bindType;
    Binder:ClearAllPoints()
    Binder:SetAllPoints(bindTarget)
    Binder:Show()
    ShoppingTooltip1:Hide()
    if(bindTarget.FlyoutArrow and bindTarget.FlyoutArrow:IsShown()) then 
      Binder:EnableMouse(false)
    elseif(not Binder:IsMouseEnabled()) then 
      Binder:EnableMouse(true)
    end;
    local keyBindID, keyBindName, keyBindString;
    if bindType == "FLYOUT" then
      keyBindName = GetSpellInfo(bindTarget.spellID);
      keyBindString = "SPELL " .. keyBindName;
      Binder.button.name = keyBindName
      Binder.button.bindstring = keyBindString;
      GameTooltip:AddLine(L["Trigger"])
      GameTooltip:Show()
      GameTooltip:SetScript("OnHide", GameTooltip_OnHide)
    elseif bindType == "SPELL" then
      keyBindID = SpellBook_GetSpellBookSlot(bindTarget)
      keyBindName = GetSpellBookItemName(keyBindID, SpellBookFrame.bookType);
      keyBindString = "SPELL " .. keyBindName;
      Binder.button.id = keyBindID
      Binder.button.name = keyBindName
      Binder.button.bindstring = keyBindString;
      GameTooltip:AddLine(L["Trigger"])
      GameTooltip:Show()
      GameTooltip:SetScript("OnHide", GameTooltip_OnHide)
    elseif bindType == "MACRO" then
      keyBindID = bindTarget:GetID()
      if(floor(.5  +  select(2, MacroFrameTab1Text:GetTextColor())  *  10)  /  10 == .8) then 
        keyBindID = keyBindID  +  36
      end;
      keyBindName = GetMacroInfo(keyBindID)
      keyBindString = "MACRO " .. keyBindName;
      Binder.button.id = keyBindID
      Binder.button.name = keyBindName
      Binder.button.bindstring = keyBindString;
      Binder.button.bindings = {GetBindingKey(keyBindString)}
      GameTooltip:SetOwner(Binder, "ANCHOR_TOP")
      GameTooltip:SetPoint("BOTTOM", Binder, "TOP", 0, 1)
      GameTooltip:AddLine(keyBindName, 1, 1, 1)
      if #Binder.button.bindings == 0 then 
        GameTooltip:AddLine(L["No bindings set."], .6, .6, .6)
      else 
        GameTooltip:AddDoubleLine(L["Binding"], L["Key"], .6, .6, .6, .6, .6, .6)
        for i = 1, #Binder.button.bindings do 
          GameTooltip:AddDoubleLine(L["Binding"]..i, Binder.button.bindings[i], 1, 1, 1)
        end 
      end;
      GameTooltip:Show()
    elseif bindType == "STANCE" or bindType == "PET" then
      keyBindID = tonumber(bindTarget:GetID())
      keyBindName = bindTarget:GetName()
      if(not keyBindName) then return end;
      if ((not keyBindID) or (keyBindID < 1) or (keyBindID > (bindType == "STANCE" and 10 or 12))) then 
        keyBindString = "CLICK "..keyBindName..":LeftButton"
      else 
        keyBindString = (bindType == "STANCE" and "StanceButton" or "BONUSACTIONBUTTON")..keyBindID 
      end;
      Binder.button.id = keyBindID
      Binder.button.name = keyBindName
      Binder.button.bindstring = keyBindString
      GameTooltip:AddLine(L["Trigger"])
      GameTooltip:Show()
      GameTooltip:SetScript("OnHide", GameTooltip_OnHide)
    else
      keyBindID = tonumber(bindTarget.action)
      keyBindName = bindTarget:GetName()
      if(not keyBindName) then return end;
      if(not bindTarget.keyBoundTarget and ((not keyBindID) or (keyBindID < 1) or (keyBindID > 132))) then 
        keyBindString = "CLICK "..keyBindName..":LeftButton"
      elseif(bindTarget.keyBoundTarget) then
        keyBindString = bindTarget.keyBoundTarget
      else
        local slotID = 1 + (keyBindID - 1) % 12;
        if((keyBindID < 25) or (keyBindID > 72)) then 
          keyBindString = "ACTIONBUTTON"..slotID;
        elseif((keyBindID < 73) and (keyBindID > 60)) then 
          keyBindString = "MULTIACTIONBAR1BUTTON"..slotID;
        elseif(keyBindID < 61 and keyBindID > 48) then 
          keyBindString = "MULTIACTIONBAR2BUTTON"..slotID;
        elseif(keyBindID < 49 and keyBindID > 36) then 
          keyBindString = "MULTIACTIONBAR4BUTTON"..slotID;
        elseif(keyBindID < 37 and keyBindID > 24) then 
          keyBindString = "MULTIACTIONBAR3BUTTON"..slotID;
        end
      end;
      Binder.button.action = keyBindID
      Binder.button.name = keyBindName
      Binder.button.bindstring = keyBindString
      GameTooltip:AddLine(L["Trigger"])
      GameTooltip:Show()
      GameTooltip:SetScript("OnHide", GameTooltip_OnHide)
    end 
  end;
end
--[[ 
########################################################## 
PACKAGE PLUGIN
##########################################################
]]--
function MOD:ToggleKeyBindingMode(deactivate, saveRequested)
  if not deactivate then
    Binder.active = true;
    SuperVillain:StaticPopupSpecial_Show(SVUI_KeyBindPopup)
    MOD:RegisterEvent('PLAYER_REGEN_DISABLED','ToggleKeyBindingMode',true,false)
  else
    if saveRequested then 
      SaveBindings(GetCurrentBindingSet())
      SuperVillain:AddonMessage(L["Binding Changes Stored"])
    else 
      LoadBindings(GetCurrentBindingSet())
      SuperVillain:AddonMessage(L["Binding Changes Discarded"])
    end;
    Binder.active = false;
    Binder:ClearAllPoints()
    Binder:Hide()
    GameTooltip:Hide()
    MOD:UnregisterEvent("PLAYER_REGEN_DISABLED")
    SuperVillain:StaticPopupSpecial_Hide(SVUI_KeyBindPopup)
    MOD.bindingsChanged = false
  end
end;

local blockedButtons = {true,true,true,true,true,true,true,true}
blockedButtons = {
  ["LSHIFT"] = true,
  ["RSHIFT"] = true,
  ["LCTRL"] = true,
  ["RCTRL"] = true,
  ["LALT"] = true,
  ["RALT"] = true,
  ["UNKNOWN"] = true,
  ["LeftButton"] = true
}

--[[ HANDLERS ]]--
local tipTimeLapse = 0;
local GameTooltip_OnUpdate = function(self, elapsed)
  tipTimeLapse = (tipTimeLapse + elapsed);
  if tipTimeLapse < .2 then 
    return 
  else 
    tipTimeLapse = 0 
  end;
  if(not self.comparing and IsModifiedClick("COMPAREITEMS")) then 
    GameTooltip_ShowCompareItem(self)
    self.comparing = true 
  elseif(self.comparing and not IsModifiedClick("COMPAREITEMS")) then 
    for _,tip in pairs(self.shoppingTooltips)do 
      tip:Hide()
    end;
    self.comparing = false 
  end 
end;

local GameTooltip_OnHide = function(self)
  for _, tip in pairs(self.shoppingTooltips)do 
    tip:Hide()
  end 
end;

local GameTooltip_OnHide = function(self)
  for _, tip in pairs(self.shoppingTooltips)do 
    tip:Hide()
  end 
end;

local SpellButton_OnEnter = function(self)
  RefreshBindings(self, "SPELL")
end

local Button_Proxy = function(self)
  RefreshBindings(self)
end
local Stance_Proxy = function(self)
  RefreshBindings(self,"STANCE")
end
local Pet_Proxy = function(self)
  RefreshBindings(self,"PET")
end
local Flyout_Proxy = function(self)
  RefreshBindings(self,"FLYOUT")
end
local Macro_Proxy = function(self)
  RefreshBindings(self, "MACRO")
end

local BinderButton_OnEnter = function(self)
  local parent = self.button:GetParent()
  if parent and parent._fade then 
    SuperVillain:SecureFadeIn(parent, 0.2, parent:GetAlpha(), parent._alpha)
  end
end;

local BinderButton_OnLeave = function(self)
  local parent = self.button:GetParent()
  self:ClearAllPoints()
  self:Hide()
  GameTooltip:Hide()
  if parent and parent._fade then 
    SuperVillain:SecureFadeOut(parent, 1, parent:GetAlpha(), 0)
  end
end;

local Binder_OnBinding = function(self, event)
  MOD.bindingsChanged = true;
  if(event == "ESCAPE" or event == "RightButton") then
    local count = #Binder.button.bindings
    for i=1, count do 
      SetBinding(Binder.button.bindings[i])
    end;
    SuperVillain:AddonMessage(format(L["All keybindings cleared for |cff00ff00%s|r."], Binder.button.name))
    RefreshBindings(Binder.button, Binder.spellmacro)
    if(Binder.spellmacro ~= "MACRO") then 
      GameTooltip:Hide()
    end;
    return 
  end;

  if(blockedButtons[event]) then return end;
  if(event == "MiddleButton") then 
    event = "BUTTON3" 
  end;
  if(event:find('Button%d')) then 
    event = event:upper()
  end;

  local altText = IsAltKeyDown() and "ALT-" or "";
  local ctrlText = IsControlKeyDown() and "CTRL-" or "";
  local shiftText = IsShiftKeyDown() and "SHIFT-" or "";

  if(not Binder.spellmacro or Binder.spellmacro == "PET" or Binder.spellmacro == "STANCE" or Binder.spellmacro == "FLYOUT") then 
    SetBinding(altText..ctrlText..shiftText..event, Binder.button.bindstring)
  else 
    SetBinding(altText..ctrlText..shiftText..event, Binder.spellmacro.." "..Binder.button.name)
  end;

  SuperVillain:AddonMessage(altText..ctrlText..shiftText..event..L[" |cff00ff00bound to |r"]..Binder.button.name..".")
  RefreshBindings(Binder.button, Binder.spellmacro)

  if Binder.spellmacro~="MACRO" then 
    GameTooltip:Hide()
  end 
end;

local BinderButton_OnMouseWheel = function(self, delta)
  if delta > 0 then 
    Binder_OnBinding(self, "MOUSEWHEELUP")
  else 
    Binder_OnBinding(self, "MOUSEWHEELDOWN")
  end
end;

local SetBindingMacro = function(self, arg)
  if(arg == "Blizzard_MacroUI") then 
    for i=1,36 do 
      local btn = _G["MacroButton"..i]
      btn:HookScript("OnEnter", MacroBinding_OnEnter)
    end 
  end 
end;

local Check_OnShow = function(self)
  self:SetChecked(GetCurrentBindingSet() == 2)
end;

local Check_OnEnter = function(self)
  GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
  GameTooltip:SetText(CHARACTER_SPECIFIC_KEYBINDING_TOOLTIP, nil, nil, nil, nil, 1) 
end;

local Check_OnClick = function(self)
  if(MOD.bindingsChanged) then 
    SuperVillain:StaticPopup_Show("CONFIRM_LOSE_BINDING_CHANGES")
  else 
    if SVUI_KeyBindPopupCheckButton:GetChecked() then 
      LoadBindings(2)
      SaveBindings(2)
    else 
      LoadBindings(1)
      SaveBindings(1)
    end
  end 
end;

local Save_OnClick = function(self)
  MOD:ToggleKeyBindingMode(true, true) 
end;

local Discard_OnClick = function(self)
  MOD:ToggleKeyBindingMode(true, false)
end;
--[[ END OF HANDLERS ]]--

local function SetBindingButton(button, force)
  local click1 = StanceButton1:GetScript("OnClick")
  local click2 = PetActionButton1:GetScript("OnClick")
  local click3 = SecureActionButton_OnClick;
  local button_OnClick = button:GetScript("OnClick")
  if button_OnClick == click3 or force then 
    button:HookScript("OnEnter", Button_Proxy)
  elseif button_OnClick == click1 then 
    button:HookScript("OnEnter", Stance_Proxy)
  elseif button_OnClick == click2 then 
    button:HookScript("OnEnter", Pet_Proxy)
  end 
end;

local function RefreshAllFlyouts()
  local count = GetNumFlyouts()
  for i = 1, count do 
    local id = GetFlyoutID(i)
    local _,_,numSlots,isKnown = GetFlyoutInfo(id)
    if isKnown then 
      for x = 1, numSlots do 
        local btn = _G["SpellFlyoutButton"..x]
        if(SpellFlyout:IsShown() and btn and btn:IsShown()) then 
          if(not btn.hookedFlyout) then 
            btn:HookScript("OnEnter", Flyout_Proxy)
            btn.hookedFlyout = true 
          end 
        end 
      end 
    end 
  end 
end;

local CreateKeyBinder = function(self)
  self:RefreshActionBars()
  Binder:SetParent(SuperVillain.UIParent)
  Binder:SetFrameStrata("DIALOG")
  Binder:SetFrameLevel(99)
  Binder:EnableMouse(true)
  Binder:EnableKeyboard(true)
  Binder:EnableMouseWheel(true)
  Binder.texture = Binder:CreateTexture()
  Binder.texture:SetAllPoints(a)
  Binder.texture:SetTexture(0, 0, 0, .25)
  Binder:Hide()

  GameTooltip:HookScript("OnUpdate", GameTooltip_OnUpdate)
  NewHook(GameTooltip, "Hide", GameTooltip_OnHide)

  Binder:SetScript("OnEnter", BinderButton_OnEnter)
  Binder:SetScript("OnLeave", BinderButton_OnLeave)
  Binder:SetScript("OnKeyUp", Binder_OnBinding)
  Binder:SetScript("OnMouseUp", Binder_OnBinding)
  Binder:SetScript("OnMouseWheel", BinderButton_OnMouseWheel)

  local OBJECT = EnumerateFrames()
  while OBJECT do
    if(OBJECT.IsProtected and OBJECT:IsProtected() and OBJECT.GetObjectType and OBJECT:GetObjectType() == "CheckButton" and OBJECT.GetScript) then
      SetBindingButton(OBJECT)
    end
    OBJECT = EnumerateFrames(OBJECT)
  end;

  for OBJECT, _ in pairs(self.Storage.Cache)do
    if(OBJECT.IsProtected and OBJECT:IsProtected() and OBJECT.GetObjectType and OBJECT:GetObjectType() == "CheckButton" and OBJECT.GetScript) then
      SetBindingButton(OBJECT, true)
    end
  end;

  for l = 1, 12 do 
    local spellButton = _G["SpellButton"..l]
    spellButton:HookScript("OnEnter", SpellButton_OnEnter)
  end;

  if not IsAddOnLoaded("Blizzard_MacroUI")then 
    NewHook("LoadAddOn", SetBindingMacro)
  else 
    for i=1,36 do 
      local btn = _G["MacroButton"..i]
      btn:HookScript("OnEnter", Macro_Proxy)
    end
  end;

  NewHook("ActionButton_UpdateFlyout", RefreshAllFlyouts)
  RefreshAllFlyouts()

  local pop = NewFrame("Frame", "SVUI_KeyBindPopup", UIParent)
  pop:SetFrameStrata("DIALOG")
  pop:SetToplevel(true)
  pop:EnableMouse(true)
  pop:SetMovable(true)
  pop:SetFrameLevel(99)
  pop:SetClampedToScreen(true)
  pop:SetWidth(360)
  pop:SetHeight(130)
  pop:SetFixedPanelTemplate("Transparent")
  pop:Hide()

  local moveHandle = NewFrame("Button", nil, pop)
  moveHandle:SetFixedPanelTemplate("Button", true)
  moveHandle:SetWidth(100)
  moveHandle:SetHeight(25)
  moveHandle:SetPoint("CENTER", pop, "TOP")
  moveHandle:SetFrameLevel(moveHandle:GetFrameLevel() + 2)
  moveHandle:EnableMouse(true)
  moveHandle:RegisterForClicks("AnyUp", "AnyDown")
  local onMouseDown = function() pop:StartMoving() end
  moveHandle:SetScript("OnMouseDown", onMouseDown)
  local onMouseUp = function() pop:StopMovingOrSizing() end
  moveHandle:SetScript("OnMouseUp", onMouseUp)

  local moveText = moveHandle:CreateFontString("OVERLAY")
  moveText:SetFontTemplate()
  moveText:SetPoint("CENTER", moveHandle, "CENTER")
  moveText:SetText("Key Binds")

  local moveDesc = pop:CreateFontString("ARTWORK")
  moveDesc:SetFontObject("GameFontHighlight")
  moveDesc:SetJustifyV("TOP")
  moveDesc:SetJustifyH("LEFT")
  moveDesc:SetPoint("TOPLEFT", 18, -32)
  moveDesc:SetPoint("BOTTOMRIGHT", -18, 48)
  moveDesc:SetText(L["Hover your mouse over any actionbutton or spellbook button to bind it. Press the escape key or right click to clear the current actionbutton's keybinding."])

  local checkButton = NewFrame("CheckButton", "SVUI_KeyBindPopupCheckButton", pop, "OptionsCheckButtonTemplate")
  checkButton:SetCheckboxTemplate(true)
  _G["SVUI_KeyBindPopupCheckButtonText"]:SetText(CHARACTER_SPECIFIC_KEYBINDINGS)
  checkButton:SetScript("OnShow", Check_OnShow)
  checkButton:SetScript("OnClick", Check_OnClick)
  checkButton:SetScript("OnEnter", Check_OnEnter)
  checkButton:SetScript("OnLeave", GameTooltip_Hide)

  local saveButton = NewFrame("Button", "SVUI_KeyBindPopupSaveButton", pop, "OptionsButtonTemplate")
  saveButton:Width(150)
  saveButton:SetButtonTemplate()
  _G["SVUI_KeyBindPopupSaveButtonText"]:SetText(L["Save"])
  saveButton:SetScript("OnClick", Save_OnClick)

  local discardButton = NewFrame("Button", "SVUI_KeyBindPopupDiscardButton", pop, "OptionsButtonTemplate")
  discardButton:Width(150)
  discardButton:SetButtonTemplate()
  _G["SVUI_KeyBindPopupDiscardButtonText"]:SetText(L["Discard"])
  discardButton:SetScript("OnClick", Discard_OnClick)

  checkButton:SetPoint("BOTTOMLEFT", discardButton, "TOPLEFT", 0, 2)
  saveButton:SetPoint("BOTTOMRIGHT", -14, 10)
  discardButton:SetPoint("BOTTOMLEFT", 14, 10)
end

SuperVillain.Registry:Temp("SVBar", CreateKeyBinder)