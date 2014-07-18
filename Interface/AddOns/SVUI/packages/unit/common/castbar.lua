--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_    #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__   #
 __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____   #
  ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____  #
  ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____  #
   _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____ #
   __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
    _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
    ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I  By: Munglunch               #
##############################################################################
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack  = _G.unpack;
local select  = _G.select;
local pairs   = _G.pairs;
local tostring = _G.tostring;
local tonumber = _G.tonumber;
local tinsert  = _G.tinsert;
local string  = _G.string;
local math   = _G.math;
local table   = _G.table;
--[[ STRING METHODS ]]--
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
--[[ MATH METHODS ]]--
local abs, ceil, floor = math.abs, math.ceil, math.floor; -- Basic
local parsefloat = math.parsefloat; -- Uncommon
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat = table.remove, table.copy, table.wipe, table.sort, table.concat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVUnit')
if(not MOD) then return end;
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local ticks = {}
local function SpellName(id)
	local name, _, _, _, _, _, _, _, _ = GetSpellInfo(id) 	
	if not name then
		print('|cffFF9900SVUI:|r Spell not found: (#ID) '..id)
		name = "Voodoo Doll";
	end
	return name
end
local CustomTickData = {
	["ChannelTicks"] = {
		--Warlock
		[SpellName(1120)] = 6, --"Drain Soul"
		[SpellName(689)] = 6, -- "Drain Life"
		[SpellName(108371)] = 6, -- "Harvest Life"
		[SpellName(5740)] = 4, -- "Rain of Fire"
		[SpellName(755)] = 6, -- Health Funnel
		[SpellName(103103)] = 4, --Malefic Grasp
		--Druid
		[SpellName(44203)] = 4, -- "Tranquility"
		[SpellName(16914)] = 10, -- "Hurricane"
		--Priest
		[SpellName(15407)] = 3, -- "Mind Flay"
		[SpellName(129197)] = 3, -- "Mind Flay (Insanity)"
		[SpellName(48045)] = 5, -- "Mind Sear"
		[SpellName(47540)] = 2, -- "Penance"
		[SpellName(64901)] = 4, -- Hymn of Hope
		[SpellName(64843)] = 4, -- Divine Hymn
		--Mage
		[SpellName(5143)] = 5, -- "Arcane Missiles"
		[SpellName(10)] = 8, -- "Blizzard"
		[SpellName(12051)] = 4, -- "Evocation"
		
		--Monk
		[SpellName(115175)] = 9, -- "Smoothing Mist"
	},
	["ChannelTicksSize"] = {
	  --Warlock
	  [SpellName(1120)] = 2, --"Drain Soul"
	  [SpellName(689)] = 1, -- "Drain Life"
		[SpellName(108371)] = 1, -- "Harvest Life"
		[SpellName(103103)] = 1, -- "Malefic Grasp"
	},
	["HastedChannelTicks"] = {
		[SpellName(64901)] = true, -- Hymn of Hope
		[SpellName(64843)] = true, -- Divine Hymn
	},
}
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function HideTicks()
	for i=1,#ticks do 
		ticks[i]:Hide()
	end 
end 

local function SetCastTicks(bar,count,mod)
	mod = mod or 0;
	HideTicks()
	if count and count <= 0 then return end 
	local barWidth = bar:GetWidth()
	local offset = barWidth / count + mod;
	for i=1,count do 
		if not ticks[i] then 
			ticks[i] = bar:CreateTexture(nil,'OVERLAY')
			ticks[i]:SetTexture(SuperVillain.Media.bar.lazer)
			ticks[i]:SetVertexColor(0,0,0,0.8)
			ticks[i]:Width(1)
			ticks[i]:SetHeight(bar:GetHeight())
		end 
		ticks[i]:ClearAllPoints()
		ticks[i]:SetPoint("RIGHT", bar, "LEFT", offset * i, 0)
		ticks[i]:Show()
	end 
end 

local Fader_OnEvent = function(self, event, arg)
	if arg ~= "player" then return end 
	if event == "UNIT_SPELLCAST_START" then 
		self.fails = nil;
		self.isokey = nil;
		self.ischanneling = nil;
		self:SetAlpha(0)
		self.mask:SetAlpha(1)
		if self.anim:IsPlaying() then 
			self.anim:Stop()
		end 
	elseif event == "UNIT_SPELLCAST_CHANNEL_START" then 
		self:SetAlpha(0)
		self.mask:SetAlpha(1)
		if self.anim:IsPlaying() then 
			self.anim:Stop()
		end 
		self.iscasting = nil;
		self.fails = nil;
		self.isokey = nil 
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then 
		self.fails = nil;
		self.isokey = true;
		self.fails_a = nil 
	elseif event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_FAILED_QUIET" then 
		self.fails = true;
		self.isokey = nil;
		self.fails_a = nil 
	elseif event == "UNIT_SPELLCAST_INTERRUPTED" then 
		self.fails = nil;
		self.isokey = nil;
		self.fails_a = true 
	elseif event == "UNIT_SPELLCAST_STOP" then 
		if self.fails or self.fails_a then 
			self:SetBackdropColor(1, 0.2, 0.2, 0.5)
			self.txt:SetText(SPELL_FAILED_FIZZLE)
			self.txt:SetTextColor(1, 0.8, 0, 0.5)
		elseif self.isokey then 
			self:SetBackdropColor(0.2, 1, 0.2, 0.5)
			self.txt:SetText(SUCCESS)
			self.txt:SetTextColor(0.5, 1, 0.4, 0.5)
		end 
		self.mask:SetAlpha(0)
		self:SetAlpha(0)
		if not self.anim:IsPlaying() then 
			self.anim:Play()
		end 
	elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then 
		self.mask:SetAlpha(0)
		self:SetAlpha(0)
		if self.fails_a then 
			self:SetBackdropColor(1, 0.2, 0.2, 0.5)
			self.txt:SetText(SPELL_FAILED_FIZZLE)
			self.txt:SetTextColor(0.5, 1, 0.4, 0.5)
			if not self.anim:IsPlaying() then 
				self.anim:Play()
			end 
		end 
	end 
end

local function SetCastbarFading(frame, castbar, texture)
	local fader = CreateFrame("Frame", nil, frame)
	fader:SetFrameLevel(2)
	fader:FillInner(castbar)
	fader:SetBackdrop({bgFile = texture})
	fader:SetBackdropColor(0, 0, 0, 0)
	fader:SetAlpha(0)
	fader:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	fader:RegisterEvent("UNIT_SPELLCAST_START")
	fader:RegisterEvent("UNIT_SPELLCAST_STOP")
	fader:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	fader:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	fader:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	fader:RegisterEvent("UNIT_SPELLCAST_FAILED")
	fader:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
	fader.mask = CreateFrame("Frame", nil, frame)
	fader.mask:SetBackdrop({bgFile = texture})
	fader.mask:FillInner(castbar)
	fader.mask:SetFrameLevel(2)
	fader.mask:SetBackdropColor(0, 0, 0, 0)
	fader.mask:SetAlpha(0)
	fader.txt = fader:CreateFontString(nil, "OVERLAY")
	fader.txt:SetFont(SuperVillain.Media.font.alert, 16)
	fader.txt:SetAllPoints(fader)
	fader.txt:SetJustifyH("CENTER")
	fader.txt:SetJustifyV("CENTER")
	fader.txt:SetText("")
	fader.anim = fader:CreateAnimationGroup("Flash")
	fader.anim.fadein = fader.anim:CreateAnimation("ALPHA", "FadeIn")
	fader.anim.fadein:SetChange(1)
	fader.anim.fadein:SetOrder(1)
	fader.anim.fadeout1 = fader.anim:CreateAnimation("ALPHA", "FadeOut")
	fader.anim.fadeout1:SetChange(-.25)
	fader.anim.fadeout1:SetOrder(2)
	fader.anim.fadeout2 = fader.anim:CreateAnimation("ALPHA", "FadeOut")
	fader.anim.fadeout2:SetChange(-.75)
	fader.anim.fadeout2:SetOrder(3)
	fader.anim.fadein:SetDuration(0)
	fader.anim.fadeout1:SetDuration(.8)
	fader.anim.fadeout2:SetDuration(.4)
	fader:SetScript("OnEvent", Fader_OnEvent)
end 

local CustomCastDelayText = function(self, value)
	if not self.TimeFormat then return end 
	if self.channeling then 
		if self.TimeFormat == "CURRENT" then 
			self.Time:SetText(("%.1f |cffaf5050%.1f|r"):format(abs(value - self.max), self.delay))
		elseif self.TimeFormat == "CURRENTMAX" then 
			self.Time:SetText(("%.1f / %.1f |cffaf5050%.1f|r"):format(value, self.max, self.delay))
		elseif self.TimeFormat == "REMAINING" then 
			self.Time:SetText(("%.1f |cffaf5050%.1f|r"):format(value, self.delay))
		end 
	else 
		if self.TimeFormat == "CURRENT" then 
			self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(value, "+", self.delay))
		elseif self.TimeFormat == "CURRENTMAX" then 
			self.Time:SetText(("%.1f / %.1f |cffaf5050%s %.1f|r"):format(value, self.max, "+", self.delay))
		elseif self.TimeFormat == "REMAINING"then 
			self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(abs(value - self.max), "+", self.delay))
		end 
	end 
end

local CustomTimeText = function(self, value)
	if not self.TimeFormat then return end 
	if self.channeling then 
		if self.TimeFormat == "CURRENT" then 
			self.Time:SetText(("%.1f"):format(abs(value - self.max)))
		elseif self.TimeFormat == "CURRENTMAX" then 
			self.Time:SetText(("%.1f / %.1f"):format(value, self.max))
			self.Time:SetText(("%.1f / %.1f"):format(abs(value - self.max), self.max))
		elseif self.TimeFormat == "REMAINING" then 
			self.Time:SetText(("%.1f"):format(value))
		end 
	else 
		if self.TimeFormat == "CURRENT" then 
			self.Time:SetText(("%.1f"):format(value))
		elseif self.TimeFormat == "CURRENTMAX" then 
			self.Time:SetText(("%.1f / %.1f"):format(value, self.max))
		elseif self.TimeFormat == "REMAINING" then 
			self.Time:SetText(("%.1f"):format(abs(value - self.max)))
		end 
	end 
end 

local CustomCastTimeUpdate = function(self, duration)
	if(self.Time) then
		if(self.delay ~= 0) then
			if(self.CustomDelayText) then
				self:CustomDelayText(duration)
			else
				self.Time:SetFormattedText("%.1f|cffff0000-%.1f|r", duration, self.delay)
			end
		else
			if(self.CustomTimeText) then
				self:CustomTimeText(duration)
			else
				self.Time:SetFormattedText("%.1f", duration)
			end
		end
	end
	if(self.Spark) then
		local xOffset = 0
		local yOffset = 0
		if self.Spark.xOffset then
			xOffset = self.Spark.xOffset
			yOffset = self.Spark.yOffset
		end
		if(self:GetReverseFill()) then
			self.Spark:SetPoint("CENTER", self, "RIGHT", -((duration / self.max) * self:GetWidth() + xOffset), yOffset)
		else
			self.Spark:SetPoint("CENTER", self, "LEFT", ((duration / self.max) * self:GetWidth() + xOffset), yOffset)
		end
	end
end

local CustomCastBarUpdate = function(self, elapsed)
	self.lastUpdate = (self.lastUpdate or 0) + elapsed

	if not (self.casting or self.channeling) then
		self.unitName = nil
		self.casting = nil
		self.castid = nil
		self.channeling = nil

		self:SetValue(1)
		self:Hide()
		return
	end

	if(self.Spark and self.Spark[1]) then self.Spark[1]:Hide(); self.Spark[1].overlay:Hide() end
	if(self.Spark and self.Spark[2]) then self.Spark[2]:Hide(); self.Spark[2].overlay:Hide() end

	if(self.casting) then
		if self.Spark then 
			if self.Spark.iscustom then 
				self.Spark.xOffset = -12
				self.Spark.yOffset = 0 
			end
			if(self.Spark[1]) then
				self.Spark[1]:Show()
				self.Spark[1].overlay:Show()
				if not self.Spark[1].anim:IsPlaying() then self.Spark[1].anim:Play() end
			end
		end

		local duration = self.duration + self.lastUpdate

		if(duration >= self.max) then
			self.casting = nil
			self:Hide()

			if(self.PostCastStop) then self:PostCastStop(self.__owner.unit) end
			return
		end
			
		CustomCastTimeUpdate(self, duration)

		self.duration = duration
		self:SetValue(duration)
	elseif(self.channeling) then
		if self.Spark then 
			if self.Spark.iscustom then 
				self.Spark.xOffset = 12
				self.Spark.yOffset = 4 
			end
			if(self.Spark[2]) then 
				self.Spark[2]:Show()
				self.Spark[2].overlay:Show()
				if not self.Spark[2].anim:IsPlaying() then self.Spark[2].anim:Play() end
			end
		end
		local duration = self.duration - self.lastUpdate

		if(duration <= 0) then
			self.channeling = nil
			self:Hide()

			if(self.PostChannelStop) then self:PostChannelStop(self.__owner.unit) end
			return
		end
	
		CustomCastTimeUpdate(self, duration)

		self.duration = duration
		self:SetValue(duration)
	end
	
	self.lastUpdate = 0
end 

local CustomChannelUpdate = function(self, unit, index, hasTicks)
	if not(unit == "player" or unit == "vehicle") then return end 
	if hasTicks then
		local activeTicks = CustomTickData.ChannelTicks[index]
		if activeTicks and CustomTickData.ChannelTicksSize[index] and CustomTickData.HastedChannelTicks[index] then 
			local mod1 = 1 / activeTicks;
			local haste = UnitSpellHaste("player") * 0.01;
			local mod2 = mod1 / 2;
			local total = 0;
			if haste >= mod2 then total = total + 1 end 
			local calc1 = tonumber(parsefloat(mod2 + mod1, 2))
			while haste >= calc1 do 
				calc1 = tonumber(parsefloat(mod2 + mod1 * total, 2))
				if haste >= calc1 then 
					total = total + 1 
				end 
			end 
			local activeSize = CustomTickData.ChannelTicksSize[index]
			local sizeMod = activeSize / 1 + haste;
			local calc2 = self.max - sizeMod * activeTicks + total;
			if self.chainChannel then 
				self.extraTickRatio = calc2 / sizeMod;
				self.chainChannel = nil 
			end 
			SetCastTicks(self, activeTicks + total, self.extraTickRatio)
		elseif activeTicks and CustomTickData.ChannelTicksSize[index] then 
			local haste = UnitSpellHaste("player") * 0.01;
			local activeSize = CustomTickData.ChannelTicksSize[index]
			local sizeMod = activeSize / 1 + haste;
			local calc2 = self.max - sizeMod * activeTicks;
			if self.chainChannel then 
				self.extraTickRatio = calc2 / sizeMod;
				self.chainChannel = nil 
			end 
			SetCastTicks(self, activeTicks, self.extraTickRatio)
		elseif activeTicks then 
			SetCastTicks(self, activeTicks)
		else 
			HideTicks()
		end 
	else 
		HideTicks()
	end 
end 

local CustomInterruptible = function(self, unit, useClass)
	local colors = oUF_SuperVillain.colors
	local r, g, b = self.CastColor[1], self.CastColor[2], self.CastColor[3]
	if useClass then 
		local colorOverride;
		if UnitIsPlayer(unit) then 
			local _, class = UnitClass(unit)
			colorOverride = colors.class[class]
		elseif UnitReaction(unit, "player") then 
			colorOverride = colors.reaction[UnitReaction(unit, "player")]
		end 
		if colorOverride then 
			r, g, b = colorOverride[1], colorOverride[2], colorOverride[3]
		end 
	end 
	if self.interrupt and unit ~= "player" and UnitCanAttack("player", unit) then 
		r, g, b = colors.interrupt[1], colors.interrupt[2], colors.interrupt[3]
	end 
	self:SetStatusBarColor(r, g, b)
	if self.bg:IsShown() then 
		self.bg:SetVertexColor(r * 0.2, g * 0.2, b * 0.2)
	end 
	
	if(self.Spark and self.Spark[1]) then
		r, g, b = self.SparkColor[1], self.SparkColor[2], self.SparkColor[3]
		self.Spark[1]:SetVertexColor(r, g, b)
		self.Spark[2]:SetVertexColor(r, g, b)
	end
end 
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreateCastbar(frame, reversed, moverName, ryu, useFader, isBoss)
	local colors = oUF_SuperVillain.colors;
	local castbar = CreateFrame("StatusBar", nil, frame)
	castbar.OnUpdate = CustomCastBarUpdate;
	castbar.CustomDelayText = CustomCastDelayText;
	castbar.CustomTimeText = CustomTimeText;
	castbar.PostCastStart = MOD.PostCastStart;
	castbar.PostChannelStart = MOD.PostCastStart;
	castbar.PostCastStop = MOD.PostCastStop;
	castbar.PostChannelStop = MOD.PostCastStop;
	castbar.PostChannelUpdate = MOD.PostChannelUpdate;
	castbar.PostCastInterruptible = MOD.PostCastInterruptible;
	castbar.PostCastNotInterruptible = MOD.PostCastNotInterruptible;
	castbar:SetClampedToScreen(true)
	castbar:SetFrameLevel(2)

	castbar.LatencyTexture = castbar:CreateTexture(nil, "OVERLAY")

	local castbarHolder = CreateFrame("Frame", nil, castbar)

	local iconHolder = CreateFrame("Frame", nil, castbar)
	iconHolder:SetFixedPanelTemplate("Inset", false)
	local buttonIcon = iconHolder:CreateTexture(nil, "BORDER")
	buttonIcon:FillInner()
	buttonIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	buttonIcon.bg = iconHolder;
	castbar.Icon = buttonIcon;
	local shieldIcon = iconHolder:CreateTexture(nil, "ARTWORK")
	shieldIcon:Point("TOPLEFT",buttonIcon,"TOPLEFT",-7,7)
	shieldIcon:Point("BOTTOMRIGHT",buttonIcon,"BOTTOMRIGHT",7,-8)
	shieldIcon:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\SHIELD")
	castbar.Shield = shieldIcon;

	castbar.Time = iconHolder:CreateFontString(nil, "OVERLAY")
	castbar.Text = castbar:CreateFontString(nil, "OVERLAY")
	
	local bgFrame = CreateFrame("Frame", nil, castbar)
	local hadouken = CreateFrame("Frame", nil, castbar)

	if ryu then
		castbar.Time:SetFont(SuperVillain.Media.font.numbers, 12, "OUTLINE")
		castbar.Time:SetShadowOffset(1, -1)
		castbar.Time:SetTextColor(1, 1, 1, 0.9)
		castbar.Text:SetFont(SuperVillain.Media.font.alert, 13)
		castbar.Text:SetShadowOffset(1, -1)
		castbar.Text:SetTextColor(1, 1, 1)

		castbar:SetStatusBarTexture(SuperVillain.Media.bar.lazer)

		bgFrame:FillInner(castbar, -2, 10)
		bgFrame:SetFrameLevel(bgFrame:GetFrameLevel() - 1)

	  castbar.LatencyTexture:SetTexture(SuperVillain.Media.bar.lazer)
		castbar.noupdate = true;
		castbar.pewpew = true
		hadouken.iscustom = true;
		hadouken:SetHeight(50)
		hadouken:SetWidth(50)
		hadouken:SetAlpha(0.9)

		castbarHolder:Point("TOP", frame, "BOTTOM", 0, isBoss and -4 or -35)

		if reversed then 
			castbar:SetReverseFill(true)
			hadouken[1] = hadouken:CreateTexture(nil, "ARTWORK")
			hadouken[1]:SetAllPoints(hadouken)
			hadouken[1]:SetBlendMode("ADD")
			hadouken[1]:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\HADOUKEN-REVERSED")
			hadouken[1]:SetVertexColor(colors.spark[1],colors.spark[2],colors.spark[3])
			hadouken[1].overlay = hadouken:CreateTexture(nil, "OVERLAY")
			hadouken[1].overlay:SetHeight(50)
			hadouken[1].overlay:SetWidth(50)
			hadouken[1].overlay:SetPoint("CENTER", hadouken)
			hadouken[1].overlay:SetBlendMode("ADD")
			hadouken[1].overlay:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\SKULLS-REVERSED")
			hadouken[1].overlay:SetVertexColor(1, 1, 1)

			SuperVillain.Animate:Sprite(hadouken[1],false,false,true)

			hadouken[2] = hadouken:CreateTexture(nil, "ARTWORK")
			hadouken[2]:FillInner(hadouken, 4, 4)
			hadouken[2]:SetBlendMode("ADD")
			hadouken[2]:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\CHANNEL-REVERSED")
			hadouken[2]:SetVertexColor(colors.spark[1],colors.spark[2],colors.spark[3])
			hadouken[2].overlay = hadouken:CreateTexture(nil, "OVERLAY")
			hadouken[2].overlay:SetHeight(50)
			hadouken[2].overlay:SetWidth(50)
			hadouken[2].overlay:SetPoint("CENTER", hadouken)
			hadouken[2].overlay:SetBlendMode("ADD")
			hadouken[2].overlay:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\CHANNEL-REVERSED")
			hadouken[2].overlay:SetVertexColor(1, 1, 1)

			SuperVillain.Animate:Sprite(hadouken[2],false,false,true)

			castbar:Point("BOTTOMLEFT", castbarHolder, "BOTTOMLEFT", 1, 1)
			iconHolder:Point("LEFT", castbar, "RIGHT", 4, 0)

			castbar.Time:Point("RIGHT", castbar, "LEFT", -4, 0)
			castbar.Time:SetJustifyH("CENTER")
		else
			hadouken[1] = hadouken:CreateTexture(nil, "ARTWORK")
			hadouken[1]:SetAllPoints(hadouken)
			hadouken[1]:SetBlendMode("ADD")
			hadouken[1]:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\HADOUKEN")
			hadouken[1]:SetVertexColor(colors.spark[1],colors.spark[2],colors.spark[3])
			hadouken[1].overlay = hadouken:CreateTexture(nil, "OVERLAY")
			hadouken[1].overlay:SetHeight(50)
			hadouken[1].overlay:SetWidth(50)
			hadouken[1].overlay:SetPoint("CENTER", hadouken)
			hadouken[1].overlay:SetBlendMode("ADD")
			hadouken[1].overlay:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\HADOUKEN")
			hadouken[1].overlay:SetVertexColor(1, 1, 1)

			SuperVillain.Animate:Sprite(hadouken[1],false,false,true)

			hadouken[2] = hadouken:CreateTexture(nil, "ARTWORK")
			hadouken[2]:FillInner(hadouken, 4, 4)
			hadouken[2]:SetBlendMode("ADD")
			hadouken[2]:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\CHANNEL")
			hadouken[2]:SetVertexColor(colors.spark[1],colors.spark[2],colors.spark[3])
			hadouken[2].overlay = hadouken:CreateTexture(nil, "OVERLAY")
			hadouken[2].overlay:SetHeight(50)
			hadouken[2].overlay:SetWidth(50)
			hadouken[2].overlay:SetPoint("CENTER", hadouken)
			hadouken[2].overlay:SetBlendMode("ADD")
			hadouken[2].overlay:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\Castbar\\CHANNEL")
			hadouken[2].overlay:SetVertexColor(1, 1, 1)

			SuperVillain.Animate:Sprite(hadouken[2],false,false,true)
			
			castbar:Point("BOTTOMRIGHT", castbarHolder, "BOTTOMRIGHT", -1, 1)
			iconHolder:Point("RIGHT", castbar, "LEFT", -4, 0)

			castbar.Time:Point("LEFT", castbar, "RIGHT", 4, 0)
			castbar.Time:SetJustifyH("CENTER")
		end

		-- castbar.Time:Point("CENTER", iconHolder, "CENTER", 0, 0)
		-- castbar.Time:SetJustifyH("CENTER")

		castbar.Text:SetPoint("CENTER", castbar, "CENTER", 0, 0)
		castbar.Text:SetJustifyH("CENTER")
	else
		castbar.Time:SetFont(SuperVillain.Media.font.roboto, 11)
		castbar.Time:SetShadowOffset(1, -1)
		castbar.Time:SetTextColor(1, 1, 1, 0.9)
		castbar.Time:SetPoint("RIGHT", castbar, "LEFT", -1, 0)
		castbar.Time:SetJustifyH("RIGHT")

		castbar.Text:SetFont(SuperVillain.Media.font.roboto, 11)
		castbar.Text:SetShadowOffset(1, -1)
		castbar.Text:SetTextColor(1, 1, 1, 0.9)
		castbar.Text:Point("CENTER", castbar, "CENTER", 0, 0)
		castbar.Text:SetJustifyH("CENTER")

		castbar.pewpew = false

		castbar:SetStatusBarTexture(SuperVillain.Media.bar.glow)
		castbarHolder:Point("TOP", frame, "BOTTOM", 0, -4)
		castbar:FillInner(castbarHolder, 2, 2)

		bgFrame:SetAllPoints(castbarHolder)
		bgFrame:SetFrameLevel(bgFrame:GetFrameLevel() - 1)

		castbar.LatencyTexture:SetTexture(SuperVillain.Media.bar.default)

		if reversed then 
			castbar:SetReverseFill(true)
			iconHolder:Point("LEFT", castbar, "RIGHT", 6, 0)
		else
			iconHolder:Point("RIGHT", castbar, "LEFT", -6, 0)
		end
	end 

	castbar.bg = bgFrame:CreateTexture(nil, "BACKGROUND")
	castbar.bg:SetAllPoints(bgFrame)
	castbar.bg:SetTexture(SuperVillain.Media.bar.default)
  	castbar.bg:SetVertexColor(0,0,0,0.5)

	local borderB = bgFrame:CreateTexture(nil,"OVERLAY")
	borderB:SetTexture(0,0,0)
	borderB:SetPoint("BOTTOMLEFT")
	borderB:SetPoint("BOTTOMRIGHT")
	borderB:SetHeight(2)

	local borderT = bgFrame:CreateTexture(nil,"OVERLAY")
	borderT:SetTexture(0,0,0)
	borderT:SetPoint("TOPLEFT")
	borderT:SetPoint("TOPRIGHT")
	borderT:SetHeight(2)

	local borderL = bgFrame:CreateTexture(nil,"OVERLAY")
	borderL:SetTexture(0,0,0)
	borderL:SetPoint("TOPLEFT")
	borderL:SetPoint("BOTTOMLEFT")
	borderL:SetWidth(2)

	local borderR = bgFrame:CreateTexture(nil,"OVERLAY")
	borderR:SetTexture(0,0,0)
	borderR:SetPoint("TOPRIGHT")
	borderR:SetPoint("BOTTOMRIGHT")
	borderR:SetWidth(2)

	castbar:SetStatusBarColor(colors.casting[1],colors.casting[2],colors.casting[3])
	castbar.LatencyTexture:SetVertexColor(0.1, 1, 0.2, 0.5)

	castbar.Spark = hadouken;
	castbar.Holder = castbarHolder;

	castbar.CastColor = oUF_SuperVillain.colors.casting
	castbar.SparkColor = oUF_SuperVillain.colors.spark

	if moverName then 
		SuperVillain:SetSVMovable(castbar.Holder, frame:GetName().."Castbar_MOVE", moverName, nil, -6, nil, "ALL, SOLO")
	end 
	
	if useFader then
		SetCastbarFading(frame, castbar, SuperVillain.Media.bar.lazer)
	end 

	castbar.TimeFormat = "REMAINING"
	return castbar 
end 
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD:PostCastStart(unit, index, ...)
	if unit == "vehicle" then unit = "player" end
	local db = MOD.db
	if(not db or not(db and db[unit] and db[unit].castbar)) then return end
	local unitDB = db[unit].castbar
	if unitDB.displayTarget and self.curTarget then 
		self.Text:SetText(sub(index.." --> "..self.curTarget, 0, floor(32 / 245 * self:GetWidth() / db.fontSize * 12)))
	else 
		self.Text:SetText(sub(index, 0, floor(32 / 245 * self:GetWidth() / db.fontSize * 12)))
	end 
	self.unit = unit;
	if unit == "player" or unit == "target" then 
		CustomChannelUpdate(self, unit, index, unitDB.ticks)
		CustomInterruptible(self, unit, db.castClassColor)
	end  
end 

function MOD:PostCastStop(unit, ...)
	self.chainChannel = nil;
	self.prevSpellCast = nil 
end 

function MOD:PostChannelUpdate(unit, index)
	if unit == "vehicle" then unit = "player" end 
	local db = MOD.db[unit];
	if(not db or not db.castbar or not(unit == "player")) then return end 
	CustomChannelUpdate(self, unit, index, db.castbar.ticks)
end 

function MOD:PostCastInterruptible(unit)
	if unit == "vehicle" or unit == "player" then return end 
	CustomInterruptible(self, unit, MOD.db.castClassColor)
end 

function MOD:PostCastNotInterruptible(unit)
	local castColor = self.CastColor;
	self:SetStatusBarColor(castColor[1], castColor[2], castColor[3])
	if(self.Spark and self.Spark[1]) then
		local sparkColor = self.SparkColor;
		self.Spark[1]:SetVertexColor(sparkColor[1], sparkColor[2], sparkColor[3])
		self.Spark[2]:SetVertexColor(sparkColor[1], sparkColor[2], sparkColor[3])
	end
end 