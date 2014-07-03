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
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose("SVStyle");
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local PBAB_WIDTH = 382;
local PBAB_HEIGHT = 72;
local PetBattleActionBar = CreateFrame("Frame", "SVUI_PetBattleActionBar", UIParent)

local function PetBattleSetTooltip(frame)
	frame.Background:SetTexture(nil)
	if frame.Delimiter1 then 
		frame.Delimiter1:SetTexture(nil)
		frame.Delimiter2:SetTexture(nil)
	end;
	frame.BorderTop:SetTexture(nil)
	frame.BorderTopLeft:SetTexture(nil)
	frame.BorderTopRight:SetTexture(nil)
	frame.BorderLeft:SetTexture(nil)
	frame.BorderRight:SetTexture(nil)
	frame.BorderBottom:SetTexture(nil)
	frame.BorderBottomRight:SetTexture(nil)
	frame.BorderBottomLeft:SetTexture(nil)
	frame:SetFixedPanelTemplate("Transparent", true)
end;

local function PetBattleButtonHelper(frame)
	frame:SetNormalTexture("")
	frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	frame.Icon:SetDrawLayer('BORDER')
	frame.checked = true;
	frame:SetSlotTemplate(true, 1, nil, nil, true)
	frame.Icon:SetParent(frame.Panel)
	frame.SelectedHighlight:SetAlpha(0)
	frame.pushed:FillInner(frame.Panel)
	frame.hover:FillInner(frame.Panel)
	frame:SetFrameStrata('LOW')
end;
--[[ 
########################################################## 
PETBATTLE STYLER
##########################################################
]]--
local function PetBattleStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.petbattleui ~= true then
		return 
	end;
	local PetBattleFrame = _G["PetBattleFrame"];
	local BottomFrame = PetBattleFrame.BottomFrame;
	local ActiveFramesList = { PetBattleFrame.ActiveAlly, PetBattleFrame.ActiveEnemy }
	local StandardFramesList = { PetBattleFrame.Ally2, PetBattleFrame.Ally3, PetBattleFrame.Enemy2, PetBattleFrame.Enemy3 }

	MOD:ApplyCloseButtonStyle(FloatingBattlePetTooltip.CloseButton)
	PetBattleFrame:Formula409()
	for i, frame in pairs(ActiveFramesList) do 
		if(not frame.isStyled) then
			frame.Border:SetAlpha(0)
			frame.Border2:SetAlpha(0)
			frame.healthBarWidth = 300;
			frame.IconBackdrop = CreateFrame("Frame", nil, frame)
			frame.IconBackdrop:SetFrameLevel(frame:GetFrameLevel()-1)
			frame.IconBackdrop:WrapOuter(frame.Icon)
			frame.IconBackdrop:SetFixedPanelTemplate("Slot")
			frame.BorderFlash:MUNG()
			frame.HealthBarBG:MUNG()
			frame.HealthBarFrame:MUNG()
			frame.HealthBarBackdrop = CreateFrame("Frame", nil, frame)
			frame.HealthBarBackdrop:SetFrameLevel(frame:GetFrameLevel()-1)
			frame.HealthBarBackdrop:SetFixedPanelTemplate("Inset")
			frame.HealthBarBackdrop:Width(frame.healthBarWidth+(2))
			frame.ActualHealthBar:SetTexture([[Interface\BUTTONS\WHITE8X8]])
			frame.PetTypeFrame = CreateFrame("Frame", nil, frame)
			frame.PetTypeFrame:Size(100, 23)
			frame.PetTypeFrame.text = frame.PetTypeFrame:CreateFontString(nil, 'OVERLAY')
			frame.PetTypeFrame.text:SetFontTemplate()
			frame.PetTypeFrame.text:SetText("")
			frame.ActualHealthBar:ClearAllPoints()
			frame.Name:ClearAllPoints()
			frame.FirstAttack = frame:CreateTexture(nil, "ARTWORK")
			frame.FirstAttack:Size(30)
			frame.FirstAttack:SetTexture("Interface\\PetBattles\\PetBattle-StatIcons")
			if i == 1 then 
				frame.HealthBarBackdrop:Point('TOPLEFT', frame.ActualHealthBar, 'TOPLEFT', -1, 1)
				frame.HealthBarBackdrop:Point('BOTTOMLEFT', frame.ActualHealthBar, 'BOTTOMLEFT', -1, -1)
				frame.ActualHealthBar:SetVertexColor(171/255, 214/255, 116/255)
				PetBattleFrame.Ally2.iconPoint = frame.IconBackdrop;
				PetBattleFrame.Ally3.iconPoint = frame.IconBackdrop;
				frame.ActualHealthBar:Point('BOTTOMLEFT', frame.Icon, 'BOTTOMRIGHT', 10, 0)
				frame.Name:Point('BOTTOMLEFT', frame.ActualHealthBar, 'TOPLEFT', 0, 10)
				frame.PetTypeFrame:SetPoint("BOTTOMRIGHT", frame.HealthBarBackdrop, "TOPRIGHT", 0, 4)
				frame.PetTypeFrame.text:SetPoint("RIGHT")
				frame.FirstAttack:SetPoint("LEFT", frame.HealthBarBackdrop, "RIGHT", 5, 0)
				frame.FirstAttack:SetTexCoord(frame.SpeedIcon:GetTexCoord())
				frame.FirstAttack:SetVertexColor(.1, .1, .1, 1)
			else
				frame.HealthBarBackdrop:Point('TOPRIGHT', frame.ActualHealthBar, 'TOPRIGHT', 1, 1)
				frame.HealthBarBackdrop:Point('BOTTOMRIGHT', frame.ActualHealthBar, 'BOTTOMRIGHT', 1, -1)
				frame.ActualHealthBar:SetVertexColor(196/255, 30/255, 60/255)
				PetBattleFrame.Enemy2.iconPoint = frame.IconBackdrop;
				PetBattleFrame.Enemy3.iconPoint = frame.IconBackdrop;
				frame.ActualHealthBar:Point('BOTTOMRIGHT', frame.Icon, 'BOTTOMLEFT', -10, 0)
				frame.Name:Point('BOTTOMRIGHT', frame.ActualHealthBar, 'TOPRIGHT', 0, 10)
				frame.PetTypeFrame:SetPoint("BOTTOMLEFT", frame.HealthBarBackdrop, "TOPLEFT", 2, 4)
				frame.PetTypeFrame.text:SetPoint("LEFT")
				frame.FirstAttack:SetPoint("RIGHT", frame.HealthBarBackdrop, "LEFT", -5, 0)
				frame.FirstAttack:SetTexCoord(.5, 0, .5, 1)
				frame.FirstAttack:SetVertexColor(.1, .1, .1, 1)
			end;
			frame.HealthText:ClearAllPoints()
			frame.HealthText:SetPoint('CENTER', frame.HealthBarBackdrop, 'CENTER')
			frame.PetType:ClearAllPoints()
			frame.PetType:SetAllPoints(frame.PetTypeFrame)
			frame.PetType:SetFrameLevel(frame.PetTypeFrame:GetFrameLevel()+2)
			frame.PetType:SetAlpha(0)
			frame.LevelUnderlay:SetAlpha(0)
			frame.Level:SetFontObject(NumberFont_Outline_Huge)
			frame.Level:ClearAllPoints()
			frame.Level:Point('BOTTOMLEFT', frame.Icon, 'BOTTOMLEFT', 2, 2)
			if frame.SpeedIcon then 
				frame.SpeedIcon:ClearAllPoints()
				frame.SpeedIcon:SetPoint("CENTER")
				frame.SpeedIcon:SetAlpha(0)
				frame.SpeedUnderlay:SetAlpha(0)
			end
			frame.isStyled = true
		end 
	end;

	for _, frame in pairs(StandardFramesList) do
		if(not frame.hasTempBG) then
			frame.BorderAlive:SetAlpha(0)
			frame.HealthBarBG:SetAlpha(0)
			frame.HealthDivider:SetAlpha(0)
			frame:Size(40)

			local tempBG = CreateFrame('Frame', nil, frame)
			tempBG:WrapOuter(frame, 2, 2)
			tempBG:SetFrameLevel(0)
			tempBG:SetBackdrop({ edgeFile = [[Interface\BUTTONS\WHITE8X8]], edgeSize = 2 })
			tempBG:SetBackdropBorderColor(0, 0, 0)

			frame.bgTexture = tempBG:CreateTexture(nil, "BACKGROUND", nil, -5)
			frame.bgTexture:FillInner(frame, 2, 2)
			frame.bgTexture:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
			frame.bgTexture:SetVertexColor(0.1, 0.1, 0.1)
			frame.bgTexture:SetBlendMode("ADD")

			frame:ClearAllPoints()
			frame.healthBarWidth = 40;
			frame.ActualHealthBar:ClearAllPoints()
			frame.ActualHealthBar:SetPoint("TOPLEFT", tempBG, 'BOTTOMLEFT', 1, -3)
			frame.HealthBarBackdrop = CreateFrame("Frame", nil, frame)
			frame.HealthBarBackdrop:SetFrameLevel(frame:GetFrameLevel()-1)
			frame.HealthBarBackdrop:SetFixedPanelTemplate("Inset")
			frame.HealthBarBackdrop:Width(frame.healthBarWidth+2)
			frame.HealthBarBackdrop:Point('TOPLEFT', frame.ActualHealthBar, 'TOPLEFT', -1, 1)
			frame.HealthBarBackdrop:Point('BOTTOMLEFT', frame.ActualHealthBar, 'BOTTOMLEFT', -1, -1)
			frame.hasTempBG = true
		end
	end;

	PetBattleActionBar:SetParent(PetBattleFrame)
	PetBattleActionBar:SetSize(PBAB_WIDTH, PBAB_HEIGHT)
	PetBattleActionBar:EnableMouse(true)
	PetBattleActionBar:SetFrameLevel(0)
	PetBattleActionBar:SetFrameStrata('BACKGROUND')
	PetBattleActionBar:SetFixedPanelTemplate("Inset")
	PetBattleActionBar:SetPoint("BOTTOM", SuperVillain.UIParent, "BOTTOM", 0, 4)

	PetBattleFrame.TopVersusText:ClearAllPoints()
	PetBattleFrame.TopVersusText:SetPoint("TOP", PetBattleFrame, "TOP", 0, -42)
	PetBattleSetTooltip(PetBattlePrimaryAbilityTooltip)
	PetBattleSetTooltip(PetBattlePrimaryUnitTooltip)
	PetBattleSetTooltip(BattlePetTooltip)
	PetBattleSetTooltip(FloatingBattlePetTooltip)
	PetBattleSetTooltip(FloatingPetBattleAbilityTooltip)

	PetBattleFrame.Ally2:SetPoint("TOPRIGHT", PetBattleFrame.Ally2.iconPoint, "TOPLEFT", -6, -2)
	PetBattleFrame.Ally3:SetPoint('TOPRIGHT', PetBattleFrame.Ally2, 'TOPLEFT', -8, 0)
	PetBattleFrame.Enemy2:SetPoint("TOPLEFT", PetBattleFrame.Enemy2.iconPoint, "TOPRIGHT", 6, -2)
	PetBattleFrame.Enemy3:SetPoint('TOPLEFT', PetBattleFrame.Enemy2, 'TOPRIGHT', 8, 0)

	BottomFrame:Formula409()
	BottomFrame.TurnTimer:Formula409()
	BottomFrame.TurnTimer.SkipButton:SetParent(PetBattleActionBar)
	BottomFrame.TurnTimer.SkipButton:SetButtonTemplate()
	BottomFrame.TurnTimer.SkipButton:Width(PBAB_WIDTH)
	BottomFrame.TurnTimer.SkipButton:ClearAllPoints()
	BottomFrame.TurnTimer.SkipButton:SetPoint("BOTTOM", PetBattleActionBar, "TOP", 0, -1)
	BottomFrame.TurnTimer:Size(BottomFrame.TurnTimer.SkipButton:GetWidth(), BottomFrame.TurnTimer.SkipButton:GetHeight())
	BottomFrame.TurnTimer:ClearAllPoints()
	BottomFrame.TurnTimer:SetPoint("TOP", SuperVillain.UIParent, "TOP", 0, -140)
	BottomFrame.TurnTimer.TimerText:SetPoint("CENTER")
	BottomFrame.FlowFrame:Formula409()
	BottomFrame.MicroButtonFrame:MUNG()
	BottomFrame.Delimiter:Formula409()
	BottomFrame.xpBar:ClearAllPoints()
	BottomFrame.xpBar:SetParent(PetBattleActionBar)
	BottomFrame.xpBar:Width(PBAB_WIDTH - 2)
	BottomFrame.xpBar:SetPanelTemplate("Inset")
	BottomFrame.xpBar:SetPoint("BOTTOM", BottomFrame.TurnTimer.SkipButton, "TOP", 0, 1)
	BottomFrame.xpBar:SetScript("OnShow", function(self)
		self:Formula409()
		self:SetStatusBarTexture(SuperVillain.Media.bar.default)
	end)

	for i = 1, 3 do 
		local pet = BottomFrame.PetSelectionFrame["Pet"..i]
		pet.HealthBarBG:SetAlpha(0)
		pet.HealthDivider:SetAlpha(0)
		pet.ActualHealthBar:SetAlpha(0)
		pet.SelectedTexture:SetAlpha(0)
		pet.MouseoverHighlight:SetAlpha(0)
		pet.Framing:SetAlpha(0)
		pet.Icon:SetAlpha(0)
		pet.Name:SetAlpha(0)
		pet.DeadOverlay:SetAlpha(0)
		pet.Level:SetAlpha(0)
		pet.HealthText:SetAlpha(0)
	end;

	PetBattleQueueReadyFrame:Formula409()
	PetBattleQueueReadyFrame:SetPanelTemplate("Transparent", true)
	PetBattleQueueReadyFrame.AcceptButton:SetButtonTemplate()
	PetBattleQueueReadyFrame.DeclineButton:SetButtonTemplate()
	PetBattleQueueReadyFrame.Art:SetTexture([[Interface\PetBattles\PetBattlesQueue]])
	
	--[[ TOO MANY GOD DAMN HOOKS ]]--
	hooksecurefunc("PetBattleFrame_UpdateSpeedIndicators", function()
		if not PetBattleFrame.ActiveAlly.SpeedIcon:IsShown() and not PetBattleFrame.ActiveEnemy.SpeedIcon:IsShown() then
			PetBattleFrame.ActiveAlly.FirstAttack:Hide()
			PetBattleFrame.ActiveEnemy.FirstAttack:Hide()
			return 
		end;
		PetBattleFrame.ActiveAlly.FirstAttack:Show()
		if PetBattleFrame.ActiveAlly.SpeedIcon:IsShown() then
			PetBattleFrame.ActiveAlly.FirstAttack:SetVertexColor(0, 1, 0, 1)
		else
			PetBattleFrame.ActiveAlly.FirstAttack:SetVertexColor(.8, 0, .3, 1)
		end
		PetBattleFrame.ActiveEnemy.FirstAttack:Show()
		if PetBattleFrame.ActiveEnemy.SpeedIcon:IsShown() then
			PetBattleFrame.ActiveEnemy.FirstAttack:SetVertexColor(0, 1, 0, 1)
		else
			PetBattleFrame.ActiveEnemy.FirstAttack:SetVertexColor(.8, 0, .3, 1)
		end 
	end)

	hooksecurefunc("PetBattleUnitFrame_UpdatePetType", function(self)
		if self.PetType then 
			local pettype = C_PetBattles.GetPetType(self.petOwner, self.petIndex)
			if self.PetTypeFrame then
				self.PetTypeFrame.text:SetText(PET_TYPE_SUFFIX[pettype])
			end 
		end 
	end)

	hooksecurefunc("PetBattleAuraHolder_Update", function(self)
	    if ( not self.petOwner or not self.petIndex ) then
	        self:Hide();
	        return;
	    end
	 
	    local nextFrame = 1;
	    for i=1, C_PetBattles.GetNumAuras(self.petOwner, self.petIndex) do
	        local auraID, instanceID, turnsRemaining, isBuff = C_PetBattles.GetAuraInfo(self.petOwner, self.petIndex, i);
	        if ( (isBuff and self.displayBuffs) or (not isBuff and self.displayDebuffs) ) then
				local frame = self.frames[nextFrame]
				frame.DebuffBorder:Hide()
				if not frame.isStyled then
					frame:SetSlotTemplate(true, 2, -8,-2)
					frame.Icon:FillInner(frame.Panel, 2, 2)
					frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					frame.isStyled = true
				end;
				if isBuff then
					frame:SetBackdropBorderColor(0, 1, 0)
				else
					frame:SetBackdropBorderColor(1, 0, 0)
				end;
				frame.Duration:SetFont(SuperVillain.Media.font.numbers, 16, "OUTLINE")
				frame.Duration:ClearAllPoints()
				frame.Duration:SetPoint("BOTTOMLEFT", frame.Icon, "BOTTOMLEFT", 4, 4)
				if turnsRemaining > 0 then
					frame.Duration:SetText(turnsRemaining)
				end;
				nextFrame = nextFrame + 1 
			end 
		end
	end)

	hooksecurefunc("PetBattleWeatherFrame_Update", function(self)
		local auraID = C_PetBattles.GetAuraInfo(LE_BATTLE_PET_WEATHER, PET_BATTLE_PAD_INDEX, 1)
		if auraID then
			self.Icon:Hide()
			self.Name:Hide()
			self.DurationShadow:Hide()
			self.Label:Hide()
			self.Duration:SetPoint("CENTER", self, 0, 8)
			self:ClearAllPoints()
			self:SetPoint("TOP", SuperVillain.UIParent, 0, -15)
		end 
	end)

	hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", function(self)
		self.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	end)

	hooksecurefunc("PetBattleAbilityTooltip_Show", function()
		PetBattlePrimaryAbilityTooltip:ClearAllPoints()
		PetBattlePrimaryAbilityTooltip:SetPoint("BOTTOMLEFT", RightSuperDock, "TOPLEFT")
	end)

	hooksecurefunc(BottomFrame.TurnTimer.SkipButton, "SetPoint", function(self, arg1, _, arg2, arg3, arg4)
		if (arg1 ~= "BOTTOM" or arg2 ~= "TOP" or arg3 ~= 0 or arg4 ~= -1) then
			self:ClearAllPoints()
			self:SetPoint("BOTTOM", PetBattleActionBar, "TOP", 0, -1)
		end 
	end)

	hooksecurefunc("PetBattlePetSelectionFrame_Show", function()
		BottomFrame.PetSelectionFrame:ClearAllPoints()
		BottomFrame.PetSelectionFrame:SetPoint("BOTTOM", BottomFrame.xpBar, "TOP", 0, 8)
	end)

	hooksecurefunc("PetBattleFrame_UpdateActionBarLayout", function(self)
		for i = 1, NUM_BATTLE_PET_ABILITIES do 
			local actionButton = self.BottomFrame.abilityButtons[i]
			PetBattleButtonHelper(actionButton)
			actionButton:SetParent(PetBattleActionBar)
			actionButton:ClearAllPoints()
			if i == 1 then
				actionButton:SetPoint("BOTTOMLEFT", 10, 10)
			else
				local lastActionButton = self.BottomFrame.abilityButtons[i - 1]
				actionButton:SetPoint("LEFT", lastActionButton, "RIGHT", 10, 0)
			end 
		end;
		self.BottomFrame.SwitchPetButton:ClearAllPoints()
		self.BottomFrame.SwitchPetButton:SetPoint("LEFT", self.BottomFrame.abilityButtons[3], "RIGHT", 10, 0)
		PetBattleButtonHelper(self.BottomFrame.SwitchPetButton)
		self.BottomFrame.CatchButton:SetParent(PetBattleActionBar)
		self.BottomFrame.CatchButton:ClearAllPoints()
		self.BottomFrame.CatchButton:SetPoint("LEFT", self.BottomFrame.SwitchPetButton, "RIGHT", 10, 0)
		PetBattleButtonHelper(self.BottomFrame.CatchButton)
		self.BottomFrame.ForfeitButton:SetParent(PetBattleActionBar)
		self.BottomFrame.ForfeitButton:ClearAllPoints()
		self.BottomFrame.ForfeitButton:SetPoint("LEFT", self.BottomFrame.CatchButton, "RIGHT", 10, 0)
		PetBattleButtonHelper(self.BottomFrame.ForfeitButton)
	end)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(PetBattleStyle)