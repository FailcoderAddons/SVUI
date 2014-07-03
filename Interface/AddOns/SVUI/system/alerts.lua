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
local type      = _G.type;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert   = _G.tinsert;
local string    = _G.string;
local table     = _G.table;
--[[ STRING METHODS ]]--
local lower = string.lower;
--[[ TABLE METHODS ]]--
local tremove, twipe = table.remove, table.wipe;
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local BUFFER = {};
local NOOP = function() end;
local function UpdateActionBarOptions()
	if InCombatLockdown() or not SuperVillain.db.SVBar.IsLoaded then return end;
	if (SuperVillain.db.SVBar.Bar2.enable ~= InterfaceOptionsActionBarsPanelBottomRight:GetChecked()) then 
		InterfaceOptionsActionBarsPanelBottomRight:Click()
	end;
	if (SuperVillain.db.SVBar.Bar3.enable ~= InterfaceOptionsActionBarsPanelRightTwo:GetChecked()) then 
		InterfaceOptionsActionBarsPanelRightTwo:Click()
	end;
	if (SuperVillain.db.SVBar.Bar4.enable ~= InterfaceOptionsActionBarsPanelRight:GetChecked()) then 
		InterfaceOptionsActionBarsPanelRight:Click()
	end;
	if (SuperVillain.db.SVBar.Bar5.enable ~= InterfaceOptionsActionBarsPanelBottomLeft:GetChecked()) then 
		InterfaceOptionsActionBarsPanelBottomLeft:Click()
	end;
  	SuperVillain.Registry:Expose("SVBar"):RefreshBar("Bar1")
	SuperVillain.Registry:Expose("SVBar"):RefreshBar("Bar6")
end;
--[[ 
########################################################## 
DEFINITIONS
##########################################################
]]--
SuperVillain.SystemAlert = {};
SuperVillain.ActiveAlerts = {};
SuperVillain.SystemAlert["CLIENT_UPDATE_REQUEST"] = {
	text = L["Detected that your SVUI Config addon is out of date. Update as soon as possible."], 
	button1 = OKAY, 
	OnAccept = NOOP, 
	state1 = 1
};
SuperVillain.SystemAlert["FAILED_UISCALE"] = {
	text = L["You have changed your UIScale, however you still have the AutoScale option enabled in SVUI. Press accept if you would like to disable the Auto Scale option."], 
	button1 = ACCEPT, 
	button2 = CANCEL, 
	OnAccept = function() SuperVillain.db.system.autoScale = false; ReloadUI(); end, 
	timeout = 0, 
	whileDead = 1, 	
	hideOnEscape = false, 
}
SuperVillain.SystemAlert["RL_CLIENT"] = {
	text = L["A setting you have changed requires that you reload your User Interface."], 
	button1 = ACCEPT, 
	button2 = CANCEL, 
	OnAccept = function()ReloadUI()end, 
	timeout = 0, 
	whileDead = 1, 
	hideOnEscape = false
};
SuperVillain.SystemAlert["KEYBIND_MODE"] = {
	text = L["Hover your mouse over any actionbutton or spellbook button to bind it. Press the escape key or right click to clear the current actionbutton's keybinding."], 
	button1 = L["Save"], 
	button2 = L["Discard"], 
	OnAccept = function()local b = SuperVillain.Registry:Expose("SVBar")b:ToggleKeyBindingMode(true, true)end, 
	OnCancel = function()local b = SuperVillain.Registry:Expose("SVBar")b:ToggleKeyBindingMode(true, false)end, 
	timeout = 0, 
	whileDead = 1, 
	hideOnEscape = false
};
SuperVillain.SystemAlert["DELETE_GRAYS"] = {
	text = L["Are you sure you want to delete all your gray items?"], 
	button1 = YES, 
	button2 = NO, 
	OnAccept = function()local c = SuperVillain.Registry:Expose("SVBag")c:VendorGrays(true)end, 
	OnShow = function(a)MoneyFrame_Update(a.moneyFrame, SuperVillain.SystemAlert["DELETE_GRAYS"].Money)end, 
	timeout = 0, 
	whileDead = 1, 
	hideOnEscape = false, 
	hasMoneyFrame = 1
};
SuperVillain.SystemAlert["BUY_BANK_SLOT"] = {
	text = CONFIRM_BUY_BANK_SLOT, 
	button1 = YES, 
	button2 = NO, 
	OnAccept = function(a)PurchaseSlot()end, 
	OnShow = function(a)MoneyFrame_Update(a.moneyFrame, GetBankSlotCost())end, 
	hasMoneyFrame = 1, 
	timeout = 0, 
	hideOnEscape = 1
};
SuperVillain.SystemAlert["CANNOT_BUY_BANK_SLOT"] = {
	text = L["Can't buy anymore slots!"], 
	button1 = ACCEPT, 
	timeout = 0, 
	whileDead = 1
};
SuperVillain.SystemAlert["NO_BANK_BAGS"] = {
	text = L["You must purchase a bank slot first!"], 
	button1 = ACCEPT, 
	timeout = 0, 
	whileDead = 1
};
SuperVillain.SystemAlert["DISBAND_RAID"] = {
	text = L["Are you sure you want to disband the group?"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() SuperVillain.Registry:Expose('SVOverride'):DisbandRaidGroup() end,
	timeout = 0,
	whileDead = 1,
};
SuperVillain.SystemAlert["RESETMOVERS_CHECK"] = {
	text = L["Are you sure you want to reset every mover back to it's default position?"], 
	button1 = ACCEPT, 
	button2 = CANCEL, 
	OnAccept = function(a)SuperVillain:ResetUI(true)end, 
	timeout = 0, 
	whileDead = 1
};
SuperVillain.SystemAlert["RESET_UI_CHECK"] = {
	text = L["I will attempt to preserve some of your basic settings but no promises. This will clean out everything else. Are you sure you want to reset everything?"], 
	button1 = ACCEPT, 
	button2 = CANCEL, 
	OnAccept = function(a)SuperVillain:ResetAllUI(true)end, 
	timeout = 0, 
	whileDead = 1
};
SuperVillain.SystemAlert["CONFIRM_LOOT_DISTRIBUTION"] = {
	text = CONFIRM_LOOT_DISTRIBUTION, 
	button1 = YES, 
	button2 = NO, 
	timeout = 0, 
	hideOnEscape = 1
};
SuperVillain.SystemAlert["RESET_PROFILE_PROMPT"] = {
	text = L["Are you sure you want to reset all the settings on this profile?"], 
	button1 = YES, 
	button2 = NO, 
	timeout = 0, 
	hideOnEscape = 1, 
	OnAccept = function()
		SuperVillain.db = nil
    	_G["SVUI_Profile"] = nil
    	_G["SVUI_Filters"] = nil
    	_G["SVUI_Cache"] = nil
    	ReloadUI()
	end
};
SuperVillain.SystemAlert["BAR6_CONFIRMATION"] = {
	text = L["Enabling / Disabling Bar #6 will toggle a paging option from your main actionbar to prevent duplicating bars, are you sure you want to do this?"], 
	button1 = YES, 
	button2 = NO, 
	OnAccept = function(a)
		if SuperVillain.db.SVBar["BAR6"].enable ~= true then 
			SuperVillain.db.SVBar.Bar6.enable = true;
			UpdateActionBarOptions()
		else 
			SuperVillain.db.SVBar.Bar6.enable = false;
			UpdateActionBarOptions()
		end 
	end, 
	OnCancel = NOOP, 
	timeout = 0, 
	whileDead = 1, 
	state1 = 1
};

SuperVillain.SystemAlert["CONFIRM_LOSE_BINDING_CHANGES"] = {
	text = CONFIRM_LOSE_BINDING_CHANGES, 
	button1 = OKAY, 
	button2 = CANCEL, 
	OnAccept = function(a)
		if SVUI_KeyBindPopupCheckButton:GetChecked() then 
			LoadBindings(2)
			SaveBindings(2)
		else 
			LoadBindings(1)
			SaveBindings(1)
		end
		SuperVillain.Registry:Expose("SVBar").bindingsChanged = nil 
	end, 
	OnCancel = function(a)
		if SVUI_KeyBindPopupCheckButton:GetChecked()then 
			SVUI_KeyBindPopupCheckButton:SetChecked()
		else 
			SVUI_KeyBindPopupCheckButton:SetChecked(1)
		end 
	end, 
	timeout = 0, 
	whileDead = 1, 
	state1 = 1
};
SuperVillain.SystemAlert["INCOMPATIBLE_ADDON"] = {
	text = L["INCOMPATIBLE_ADDON"], 
	OnAccept = function(a)DisableAddOn(SuperVillain.SystemAlert["INCOMPATIBLE_ADDON"].addon)ReloadUI()end, 
	OnCancel = function(a)SuperVillain.db[lower(SuperVillain.SystemAlert["INCOMPATIBLE_ADDON"].package)].enable = false;ReloadUI()end, 
	timeout = 0, 
	whileDead = 1, 
	hideOnEscape = false
};
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local MAX_STATIC_POPUPS = 4
local SysPop_Event_Show = function(self)
	PlaySound("igMainMenuOpen");

	local dialog = SuperVillain.SystemAlert[self.which];
	local OnShow = dialog.OnShow;

	if ( OnShow ) then
		OnShow(self, self.data);
	end
	if ( dialog.hasMoneyInputFrame ) then
		_G[self:GetName().."MoneyInputFrameGold"]:SetFocus();
	end
	if ( dialog.enterClicksFirstButton ) then
		self:SetScript("OnKeyDown", SysPop_Event_KeyDown);
	end
end

local SysBox_Event_KeyEscape = function(self)
	local closed = nil;
	for _, frame in pairs(SuperVillain.ActiveAlerts) do
		if( frame:IsShown() and frame.hideOnEscape ) then
			local standardDialog = SuperVillain.SystemAlert[frame.which];
			if ( standardDialog ) then
				local OnCancel = standardDialog.OnCancel;
				local noCancelOnEscape = standardDialog.noCancelOnEscape;
				if ( OnCancel and not noCancelOnEscape) then
					OnCancel(frame, frame.data, "clicked");
				end
				frame:Hide();
			else
				SuperVillain:StaticPopupSpecial_Hide(frame);
			end
			closed = 1;
		end
	end
	return closed;
end

local SysPop_Close_Unique = function(self)
	SysPop_Close_Unique:Hide();
	SysPop_Close_Table();
end

local SysPop_Close_Table = function()
	local displayedFrames = SuperVillain.ActiveAlerts;
	local index = #displayedFrames;
	while ( ( index >= 1 ) and ( not displayedFrames[index]:IsShown() ) ) do
		tremove(displayedFrames, index);
		index = index - 1;
	end
end

local SysPop_Move = function(self)
	if ( not tContains(SuperVillain.ActiveAlerts, self) ) then
		local lastFrame = SuperVillain.ActiveAlerts[#SuperVillain.ActiveAlerts];
		if ( lastFrame ) then	
			self:SetPoint("TOP", lastFrame, "BOTTOM", 0, -4);
		else
			self:SetPoint("TOP", SuperVillain.UIParent, "TOP", 0, -100);
		end
		tinsert(SuperVillain.ActiveAlerts, self);
	end
end

local SysPop_Event_KeyDown = function(self, key)
	if ( GetBindingFromClick(key) == "TOGGLEGAMEMENU" ) then
		return SysBox_Event_KeyEscape();
	elseif ( GetBindingFromClick(key) == "SCREENSHOT" ) then
		RunBinding("SCREENSHOT");
		return;
	end

	local dialog = SuperVillain.SystemAlert[self.which];
	if ( dialog ) then
		if ( key == "ENTER" and dialog.enterClicksFirstButton ) then
			local frameName = self:GetName();
			local button;
			local i = 1;
			while ( true ) do
				button = _G[frameName.."Button"..i];
				if ( button ) then
					if ( button:IsShown() ) then
						SysPop_Event_Click(self, i);
						return;
					end
					i = i + 1;
				else
					break;
				end
			end
		end
	end
end

local SysPop_Event_Click = function(self, index)
	if ( not self:IsShown() ) then
		return;
	end
	local which = self.which;
	local info = SuperVillain.SystemAlert[which];
	if ( not info ) then
		return nil;
	end
	local hide = true;
	if ( index == 1 ) then
		local OnAccept = info.OnAccept;
		if ( OnAccept ) then
			hide = not OnAccept(self, self.data, self.data2);
		end
	elseif ( index == 3 ) then
		local OnAlt = info.OnAlt;
		if ( OnAlt ) then
			OnAlt(self, self.data, "clicked");
		end
	else
		local OnCancel = info.OnCancel;
		if ( OnCancel ) then
			hide = not OnCancel(self, self.data, "clicked");
		end
	end

	if ( hide and (which == self.which) ) then
		self:Hide();
	end
end

local SysPop_Event_Hide = function(self)
	PlaySound("igMainMenuClose");

	SysPop_Close_Table();
	
	local dialog = SuperVillain.SystemAlert[self.which];
	local OnHide = dialog.OnHide;
	if ( OnHide ) then
		OnHide(self, self.data);
	end
	self.extraFrame:Hide();
	if ( dialog.enterClicksFirstButton ) then
		self:SetScript("OnKeyDown", nil);
	end
end

local SysPop_Event_Update = function(self, elapsed)
	if ( self.timeleft and self.timeleft > 0 ) then
		local which = self.which;
		local timeleft = self.timeleft - elapsed;
		if ( timeleft <= 0 ) then
			if ( not SuperVillain.SystemAlert[which].timeoutInformationalOnly ) then
				self.timeleft = 0;
				local OnCancel = SuperVillain.SystemAlert[which].OnCancel;
				if ( OnCancel ) then
					OnCancel(self, self.data, "timeout");
				end
				self:Hide();
			end
			return;
		end
		self.timeleft = timeleft;
	end
	
	if ( self.startDelay ) then
		local which = self.which;
		local timeleft = self.startDelay - elapsed;
		if ( timeleft <= 0 ) then
			self.startDelay = nil;
			local text = _G[self:GetName().."Text"];
			text:SetFormattedText(SuperVillain.SystemAlert[which].text, text.text_arg1, text.text_arg2);
			local button1 = _G[self:GetName().."Button1"];
			button1:Enable();
			StaticPopup_Resize(self, which);
			return;
		end
		self.startDelay = timeleft;
	end

	local onUpdate = SuperVillain.SystemAlert[self.which].OnUpdate;
	if ( onUpdate ) then
		onUpdate(self, elapsed);
	end
end

local SysBox_Event_KeyEnter = function(self)
	local EditBoxOnEnterPressed, which, dialog;
	local parent = self:GetParent();
	if ( parent.which ) then
		which = parent.which;
		dialog = parent;
	elseif ( parent:GetParent().which ) then
		-- This is needed if this is a money input frame since it's nested deeper than a normal edit box
		which = parent:GetParent().which;
		dialog = parent:GetParent();
	end
	if ( not self.autoCompleteParams or not AutoCompleteEditBox_OnEnterPressed(self) ) then
		EditBoxOnEnterPressed = SuperVillain.SystemAlert[which].EditBoxOnEnterPressed;
		if ( EditBoxOnEnterPressed ) then
			EditBoxOnEnterPressed(self, dialog.data);
		end
	end
end

local SysBox_Event_KeyEscape = function(self)
	local EditBoxOnEscapePressed = SuperVillain.SystemAlert[self:GetParent().which].EditBoxOnEscapePressed;
	if ( EditBoxOnEscapePressed ) then
		EditBoxOnEscapePressed(self, self:GetParent().data);
	end
end

local SysBox_Event_Change = function(self, userInput)
	if ( not self.autoCompleteParams or not AutoCompleteEditBox_OnTextChanged(self, userInput) ) then
		local EditBoxOnTextChanged = SuperVillain.SystemAlert[self:GetParent().which].EditBoxOnTextChanged;
		if ( EditBoxOnTextChanged ) then
			EditBoxOnTextChanged(self, self:GetParent().data);
		end
	end
end

local SysPop_Size = function(self, which)
	local info = SuperVillain.SystemAlert[which];
	if ( not info ) then
		return nil;
	end

	local text = _G[self:GetName().."Text"];
	local editBox = _G[self:GetName().."EditBox"];
	local button1 = _G[self:GetName().."Button1"];
	
	local maxHeightSoFar, maxWidthSoFar = (self.maxHeightSoFar or 0), (self.maxWidthSoFar or 0);
	local width = 320;
	
	if ( self.numButtons == 3 ) then
		width = 440;
	elseif (info.showAlert or info.showAlertGear or info.closeButton) then
		-- Widen
		width = 420;
	elseif ( info.editBoxWidth and info.editBoxWidth > 260 ) then
		width = width + (info.editBoxWidth - 260);
	end
	
	if ( width > maxWidthSoFar )  then
		self:SetWidth(width);
		self.maxWidthSoFar = width;
	end
	
	local height = 32 + text:GetHeight() + 8 + button1:GetHeight();
	if ( info.hasEditBox ) then
		height = height + 8 + editBox:GetHeight();
	elseif ( info.hasMoneyFrame ) then
		height = height + 16;
	elseif ( info.hasMoneyInputFrame ) then
		height = height + 22;
	end
	if ( info.hasItemFrame ) then
		height = height + 64;
	end

	if ( height > maxHeightSoFar ) then
		self:SetHeight(height);
		self.maxHeightSoFar = height;
	end
end

local SysPop_Event_Listener = function(self)
	self.maxHeightSoFar = 0;
	SysPop_Size(self, self.which);
end

local SysPop_Find = function(which, data)
	local info = SuperVillain.SystemAlert[which];
	if ( not info ) then
		return nil;
	end
	for index = 1, MAX_STATIC_POPUPS, 1 do
		local frame = _G["SVUI_SystemAlert"..index];
		if ( frame:IsShown() and (frame.which == which) and (not info.multiple or (frame.data == data)) ) then
			return frame;
		end
	end
	return nil;
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function SuperVillain:StaticPopupSpecial_Hide(frame)
	frame:Hide();
	SysPop_Close_Table();
end

function SuperVillain:StaticPopup_HideExclusive()
	for _, frame in pairs(self.ActiveAlerts) do
        if ( frame:IsShown() and frame.exclusive ) then
            local standardDialog = self.SystemAlert[frame.which];
            if ( standardDialog ) then
                frame:Hide();
                local OnCancel = standardDialog.OnCancel;
                if ( OnCancel ) then
                    OnCancel(frame, frame.data, "override");
                end
            else
                self:StaticPopupSpecial_Hide(frame);
            end
            break;
        end
    end
end

function SuperVillain:StaticPopupSpecial_Show(frame)
	if ( frame.exclusive ) then
		self:StaticPopup_HideExclusive();
	end
	SysPop_Move(frame);
	frame:Show();
end

function SuperVillain:StaticPopup_Show(which, text_arg1, text_arg2, data)
	local info = SuperVillain.SystemAlert[which];
	if ( not info ) then
		return nil;
	end
	if ( UnitIsDeadOrGhost("player") and not info.whileDead ) then
		if ( info.OnCancel ) then
			info.OnCancel();
		end
		return nil;
	end
	if ( InCinematic() and not info.interruptCinematic ) then
		if ( info.OnCancel ) then
			info.OnCancel();
		end
		return nil;
	end
	if ( info.cancels ) then
		for index = 1, MAX_STATIC_POPUPS, 1 do
			local frame = _G["SVUI_SystemAlert"..index];
			if ( frame:IsShown() and (frame.which == info.cancels) ) then
				frame:Hide();
				local OnCancel = SuperVillain.SystemAlert[frame.which].OnCancel;
				if ( OnCancel ) then
					OnCancel(frame, frame.data, "override");
				end
			end
		end
	end
	local dialog = nil;
	dialog = SysPop_Find(which, data);
	if ( dialog ) then
		if ( not info.noCancelOnReuse ) then
			local OnCancel = info.OnCancel;
			if ( OnCancel ) then
				OnCancel(dialog, dialog.data, "override");
			end
		end
		dialog:Hide();
	end
	if ( not dialog ) then
		local index = 1;
		if ( info.preferredIndex ) then
			index = info.preferredIndex;
		end
		for i = index, MAX_STATIC_POPUPS do
			local frame = _G["SVUI_SystemAlert"..i];
			if ( not frame:IsShown() ) then
				dialog = frame;
				break;
			end
		end
		if ( not dialog and info.preferredIndex ) then
			for i = 1, info.preferredIndex do
				local frame = _G["SVUI_SystemAlert"..i];
				if ( not frame:IsShown() ) then
					dialog = frame;
					break;
				end
			end
		end
	end
	if ( not dialog ) then
		if ( info.OnCancel ) then
			info.OnCancel();
		end
		return nil;
	end
	dialog.maxHeightSoFar, dialog.maxWidthSoFar = 0, 0;
	local text = _G[dialog:GetName().."Text"];
	text:SetFormattedText(info.text, text_arg1, text_arg2);
	if ( info.closeButton ) then
		local closeButton = _G[dialog:GetName().."CloseButton"];
		if ( info.closeButtonIsHide ) then
			closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-HideButton-Up");
			closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-HideButton-Down");
		else
			closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up");
			closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down");
		end
		closeButton:Show();
	else
		_G[dialog:GetName().."CloseButton"]:Hide();
	end
	local editBox = _G[dialog:GetName().."EditBox"];
	if ( info.hasEditBox ) then
		editBox:Show();
		if ( info.maxLetters ) then
			editBox:SetMaxLetters(info.maxLetters);
			editBox:SetCountInvisibleLetters(info.countInvisibleLetters);
		end
		if ( info.maxBytes ) then
			editBox:SetMaxBytes(info.maxBytes);
		end
		editBox:SetText("");
		if ( info.editBoxWidth ) then
			editBox:SetWidth(info.editBoxWidth);
		else
			editBox:SetWidth(130);
		end
	else
		editBox:Hide();
	end
	if ( info.hasMoneyFrame ) then
		_G[dialog:GetName().."MoneyFrame"]:Show();
		_G[dialog:GetName().."MoneyInputFrame"]:Hide();
	elseif ( info.hasMoneyInputFrame ) then
		local moneyInputFrame = _G[dialog:GetName().."MoneyInputFrame"];
		moneyInputFrame:Show();
		_G[dialog:GetName().."MoneyFrame"]:Hide();
		if ( info.EditBoxOnEnterPressed ) then
			moneyInputFrame.gold:SetScript("OnEnterPressed", SysBox_Event_KeyEnter);
			moneyInputFrame.silver:SetScript("OnEnterPressed", SysBox_Event_KeyEnter);
			moneyInputFrame.copper:SetScript("OnEnterPressed", SysBox_Event_KeyEnter);
		else
			moneyInputFrame.gold:SetScript("OnEnterPressed", nil);
			moneyInputFrame.silver:SetScript("OnEnterPressed", nil);
			moneyInputFrame.copper:SetScript("OnEnterPressed", nil);
		end
	else
		_G[dialog:GetName().."MoneyFrame"]:Hide();
		_G[dialog:GetName().."MoneyInputFrame"]:Hide();
	end
	if ( info.hasItemFrame ) then
		_G[dialog:GetName().."ItemFrame"]:Show();
		if ( data and type(data) == "table" ) then
			_G[dialog:GetName().."ItemFrame"].link = data.link
			_G[dialog:GetName().."ItemFrameIconTexture"]:SetTexture(data.texture);
			local nameText = _G[dialog:GetName().."ItemFrameText"];
			nameText:SetTextColor(unpack(data.color or {1, 1, 1, 1}));
			nameText:SetText(data.name);
			if ( data.count and data.count > 1 ) then
				_G[dialog:GetName().."ItemFrameCount"]:SetText(data.count);
				_G[dialog:GetName().."ItemFrameCount"]:Show();
			else
				_G[dialog:GetName().."ItemFrameCount"]:Hide();
			end
		end
	else
		_G[dialog:GetName().."ItemFrame"]:Hide();
	end
	dialog.which = which;
	dialog.timeleft = info.timeout;
	dialog.hideOnEscape = info.hideOnEscape;
	dialog.exclusive = info.exclusive;
	dialog.enterClicksFirstButton = info.enterClicksFirstButton;
	dialog.data = data;
	local button1 = _G[dialog:GetName().."Button1"];
	local button2 = _G[dialog:GetName().."Button2"];
	local button3 = _G[dialog:GetName().."Button3"];
	do
		assert(#BUFFER == 0);
		tinsert(BUFFER, button1);
		tinsert(BUFFER, button2);
		tinsert(BUFFER, button3);
		for i=#BUFFER, 1, -1 do
			BUFFER[i]:SetText(info["button"..i]);
			BUFFER[i]:Hide();
			BUFFER[i]:ClearAllPoints();
			if ( not (info["button"..i] and ( not info["DisplayButton"..i] or info["DisplayButton"..i](dialog))) ) then
				tremove(BUFFER, i);
			end
		end
		local numButtons = #BUFFER;
		dialog.numButtons = numButtons;
		if ( numButtons == 3 ) then
			BUFFER[1]:SetPoint("BOTTOMRIGHT", dialog, "BOTTOM", -72, 16);
		elseif ( numButtons == 2 ) then
			BUFFER[1]:SetPoint("BOTTOMRIGHT", dialog, "BOTTOM", -6, 16);
		elseif ( numButtons == 1 ) then
			BUFFER[1]:SetPoint("BOTTOM", dialog, "BOTTOM", 0, 16);
		end
		for i=1, numButtons do
			if ( i > 1 ) then
				BUFFER[i]:SetPoint("LEFT", BUFFER[i-1], "RIGHT", 13, 0);
			end
			local width = BUFFER[i]:GetTextWidth();
			if ( width > 110 ) then
				BUFFER[i]:SetWidth(width + 20);
			else
				BUFFER[i]:SetWidth(120);
			end
			BUFFER[i]:Enable();
			BUFFER[i]:Show();
		end
		table.wipe(BUFFER);
	end
	local alertIcon = _G[dialog:GetName().."AlertIcon"];
	if ( info.showAlert ) then
		alertIcon:SetTexture(STATICPOPUP_TEXTURE_ALERT);
		if ( button3:IsShown() )then
			alertIcon:SetPoint("LEFT", 24, 10);
		else
			alertIcon:SetPoint("LEFT", 24, 0);
		end
		alertIcon:Show();
	elseif ( info.showAlertGear ) then
		alertIcon:SetTexture(STATICPOPUP_TEXTURE_ALERTGEAR);
		if ( button3:IsShown() )then
			alertIcon:SetPoint("LEFT", 24, 0);
		else
			alertIcon:SetPoint("LEFT", 24, 0);
		end
		alertIcon:Show();
	else
		alertIcon:SetTexture();
		alertIcon:Hide();
	end
	if ( info.StartDelay ) then
		dialog.startDelay = info.StartDelay();
		button1:Disable();
	else
		dialog.startDelay = nil;
		button1:Enable();
	end
	editBox.autoCompleteParams = info.autoCompleteParams;
	editBox.autoCompleteRegex = info.autoCompleteRegex;
	editBox.autoCompleteFormatRegex = info.autoCompleteFormatRegex;
	editBox.addHighlightedText = true;
	SysPop_Move(dialog);
	dialog:Show();
	SysPop_Size(dialog, which);
	if (not dialog:IsShown() and info.sound) then
		PlaySound(info.sound);
	end
	return dialog;
end

function SuperVillain:StaticPopup_Hide(which, data)
	for index = 1, MAX_STATIC_POPUPS, 1 do
		local dialog = _G["SVUI_SystemAlert"..index];
		if ( (dialog.which == which) and (not data or (data == dialog.data)) ) then
			dialog:Hide();
		end
	end
end

local AlertButton_OnClick = function(self)
	SysPop_Event_Click(self:GetParent(), self:GetID())
end

function SuperVillain:LoadSystemAlerts()
	for i = 1, 4 do 
		local alert = CreateFrame("Frame", "SVUI_SystemAlert"..i, SuperVillain.UIParent, "StaticPopupTemplate")
		alert:SetID(i)
		alert:SetScript("OnShow", SysPop_Event_Show)
		alert:SetScript("OnHide", SysPop_Event_Hide)
		alert:SetScript("OnUpdate", SysPop_Event_Update)
		alert:SetScript("OnEvent", SysPop_Event_Listener)
		alert.input = _G["SVUI_SystemAlert"..i.."EditBox"];
		alert.input:SetScript("OnEnterPressed", SysBox_Event_KeyEnter)
		alert.input:SetScript("OnEscapePressed", SysBox_Event_KeyEscape)
		alert.input:SetScript("OnTextChanged", SysBox_Event_Change)
		alert.gold = _G["SVUI_SystemAlert"..i.."MoneyInputFrameGold"];
		alert.silver = _G["SVUI_SystemAlert"..i.."MoneyInputFrameSilver"];
		alert.copper = _G["SVUI_SystemAlert"..i.."MoneyInputFrameCopper"];
		alert.buttons = {}
		for b = 1, 3 do
			local button = _G["SVUI_SystemAlert"..i.."Button"..b];
			button:SetScript("OnClick", AlertButton_OnClick)
			alert.buttons[b] = button
		end;
		_G["SVUI_SystemAlert"..i.."ItemFrameNameFrame"]:MUNG()
		_G["SVUI_SystemAlert"..i.."ItemFrame"]:GetNormalTexture():MUNG()
		_G["SVUI_SystemAlert"..i.."ItemFrame"]:SetButtonTemplate()
		_G["SVUI_SystemAlert"..i.."ItemFrameIconTexture"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		_G["SVUI_SystemAlert"..i.."ItemFrameIconTexture"]:FillInner()
	end 
end;