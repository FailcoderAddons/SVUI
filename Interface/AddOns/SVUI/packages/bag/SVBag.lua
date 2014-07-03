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
credit: Elv.           original logic from ElvUI. Adapted to SVUI #
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
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local find, format, len = string.find, string.format, string.len;
local sub, byte = string.sub, string.byte;
--[[ MATH METHODS ]]--
local floor = math.floor;
local twipe = table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = {};
local TTIP = SuperVillain.Registry:Expose('SVTip');
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local NewFrame = CreateFrame;
local NewHook = hooksecurefunc;
local iconTex = [[Interface\BUTTONS\WHITE8X8]]
local borderTex = [[Interface\Addons\SVUI\assets\artwork\Template\ROUND]]
local ICON_BAGS = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-BAGS]]
local ICON_SORT = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-SORT]]
local ICON_STACK = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-STACK]]
local ICON_TRANSFER = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-TRANSFER]]
local ICON_PURCHASE = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-PURCHASE]]
local ICON_VENDOR = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-VENDOR]]
local numBagFrame = NUM_BAG_FRAMES + 1;
local gearSet, gearList = {}, {};
local internalTimer, SetBagHooks;
local RefProfessionColors = {
	[0x0008] = {224/255,187/255,74/255},
	[0x0010] = {74/255,77/255,224/255},
	[0x0020] = {18/255,181/255,32/255},
	[0x0040] = {160/255,3/255,168/255},
	[0x0080] = {232/255,118/255,46/255},
	[0x0200] = {8/255,180/255,207/255},
	[0x0400] = {105/255,79/255,7/255},
	[0x10000] = {222/255,13/255,65/255},
	[0x100000] = {18/255,224/255,180/255}
};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function StyleBagToolButton(button)
	if button.styled then return end;

	local outer = button:CreateTexture(nil, "OVERLAY")
	outer:WrapOuter(button, 6, 6)
	outer:SetTexture(borderTex)
	outer:SetGradient("VERTICAL", 0.4, 0.47, 0.5, 0.3, 0.33, 0.35)

	if button.SetNormalTexture then 
		iconTex = button:GetNormalTexture()
		iconTex:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	end;
	
	local icon = button:CreateTexture(nil, "OVERLAY")
	icon:WrapOuter(button, 6, 6)
	SetPortraitToTexture(icon, iconTex)
	NewHook(icon, "SetTexture", SetPortraitToTexture)

	local hover = button:CreateTexture(nil, "HIGHLIGHT")
	hover:WrapOuter(button, 6, 6)
	hover:SetTexture(borderTex)
	hover:SetGradient(unpack(SuperVillain.Media.gradient.yellow))

	if button.SetPushedTexture then 
		local pushed = button:CreateTexture(nil, "BORDER")
		pushed:WrapOuter(button, 6, 6)
		pushed:SetTexture(borderTex)
		pushed:SetGradient(unpack(SuperVillain.Media.gradient.highlight))
		button:SetPushedTexture(pushed)
	end;

	if button.SetCheckedTexture then 
		local checked = button:CreateTexture(nil, "BORDER")
		checked:WrapOuter(button, 6, 6)
		checked:SetTexture(borderTex)
		checked:SetGradient(unpack(SuperVillain.Media.gradient.green))
		button:SetCheckedTexture(checked)
	end;

	if button.SetDisabledTexture then 
		local disabled = button:CreateTexture(nil, "BORDER")
		disabled:WrapOuter(button, 6, 6)
		disabled:SetTexture(borderTex)
		disabled:SetGradient(unpack(SuperVillain.Media.gradient.default))
		button:SetDisabledTexture(disabled)
	end;

	local cd = button:GetName() and _G[button:GetName().."Cooldown"]
	if cd then 
		cd:ClearAllPoints()
		cd:FillInner()
	end;
	button.styled = true
end;

local function encodeSub(i, j, k)
	local l = j;
	while k>0 and l <= #i do
		local m = byte(i, l)
		if m>240 then
			l = l + 4;
		elseif m>225 then
			l = l + 3;
		elseif m>192 then
			l = l + 2;
		else
			l = l + 1;
		end;
		k = k-1;
	end;
	return i:sub(j, (l-1))
end;

local function formatAndSave(level, font, saveTo)
	if level == 1 then
		font:SetFormattedText("|cffffffaa%s|r", encodeSub(saveTo[1], 1, 4))
	elseif level == 2 then
		font:SetFormattedText("|cffffffaa%s %s|r", encodeSub(saveTo[1], 1, 4), encodeSub(saveTo[2], 1, 4))
	elseif level == 3 then
		font:SetFormattedText("|cffffffaa%s %s %s|r", encodeSub(saveTo[1], 1, 4), encodeSub(saveTo[2], 1, 4), encodeSub(saveTo[3], 1, 4))
	else
		font:SetText()
	end
end;

local function BuildEquipmentMap()
	for t, u in pairs(gearList)do
		twipe(u);
	end;
	local set, player, bank, bags, index, bag, loc, _;
	for i = 1, GetNumEquipmentSets() do
		set = GetEquipmentSetInfo(i);
		gearSet = GetEquipmentSetLocations(set);
		for key, location in pairs(gearSet)do
			player, bank, bags, _, index, bag = EquipmentManager_UnpackLocation(location);
			if((bank or bags) and (index and bag)) then
				loc = format("%d_%d", bag, index);
				gearList[loc] = (gearList[loc] or {});
				tinsert(gearList[loc], set);
			end
		end
	end
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:GetContainerFrame(e)
	if type(e) == "boolean" and e == true then 
		return MOD.BankFrame 
	elseif type(e) == "number" then 
		if MOD.BankFrame then 
			for f, g in ipairs(MOD.BankFrame.BagIDs) do 
				if g == e then 
					return MOD.BankFrame 
				end 
			end 
		end 
	end;
	return MOD.BagFrame 
end;

function MOD:DisableBlizzard()
	BankFrame:UnregisterAllEvents()
	for h = 1, NUM_CONTAINER_FRAMES do 
		_G["ContainerFrame"..h]:MUNG()
	end 
end;

function MOD:INVENTORY_SEARCH_UPDATE()
	for _, bag in pairs(self.BagFrames)do 
		for _, bagID in ipairs(bag.BagIDs)do 
			for i = 1, GetContainerNumSlots(bagID)do 
				local _, _, _, _, _, _, _, n = GetContainerItemInfo(bagID, i)
				local item = bag.Bags[bagID][i]
				if item:IsShown()then 
					if n then 
						SetItemButtonDesaturated(item, 1, 1, 1, 1)
						item:SetAlpha(0.4)
					else 
						SetItemButtonDesaturated(item, 0, 1, 1, 1)
						item:SetAlpha(1)
					end 
				end 
			end 
		end 
	end 
end;

function MOD:RefreshSlot(bag, slotID)
	if self.Bags[bag] and self.Bags[bag].numSlots ~= GetContainerNumSlots(bag) or not self.Bags[bag] or not self.Bags[bag][slotID] then return end;
	local slot, _ = self.Bags[bag][slotID], nil;
	local bagType = self.Bags[bag].bagFamily;
	local texture, count, locked = GetContainerItemInfo(bag, slotID)
	local itemLink = GetContainerItemLink(bag, slotID);
	local key;
	slot:Show()
	slot.questIcon:Hide()
	slot.name, slot.rarity = nil, nil;
	local start, duration, enable = GetContainerItemCooldown(bag, slotID)
	CooldownFrame_SetTimer(slot.cooldown, start, duration, enable)
	if duration > 0 and enable == 0 then 
		SetItemButtonTextureVertexColor(slot, 0.4, 0.4, 0.4)
	else 
		SetItemButtonTextureVertexColor(slot, 1, 1, 1)
	end;
	if bagType then
		local r, g, b = bagType[1], bagType[2], bagType[3];
		slot:SetBackdropColor(r, g, b, 0.25)
		slot:SetBackdropBorderColor(r, g, b, 1)
	elseif itemLink then
		local class, subclass, maxStack;
		key, _, slot.rarity, _, _, class, subclass, maxStack = GetItemInfo(itemLink)
		slot.name = key
		local z, A, C = GetContainerItemQuestInfo(bag, slotID)
		if A and not isActive then 
			slot:SetBackdropBorderColor(1.0, 0.3, 0.3)
			slot.questIcon:Show()
		elseif A or z then 
			slot:SetBackdropBorderColor(1.0, 0.3, 0.3)
		elseif slot.rarity and slot.rarity>1 then 
			local D, E, F = GetItemQualityColor(slot.rarity)
			slot:SetBackdropBorderColor(D, E, F)
		else 
			slot:SetBackdropBorderColor(0, 0, 0)
		end 
	else 
		slot:SetBackdropBorderColor(0, 0, 0)
	end;
	if C_NewItems.IsNewItem(bag, slotID)then 
		ActionButton_ShowOverlayGlow(slot)
	else 
		ActionButton_HideOverlayGlow(slot)
	end;
	SetItemButtonTexture(slot, texture)
	SetItemButtonCount(slot, count)
	SetItemButtonDesaturated(slot, locked, 0.5, 0.5, 0.5)
end;

function MOD:RefreshBagSlots(bag)
	if(not bag) then return end;
	for i = 1, GetContainerNumSlots(bag)do 
		if self.RefreshSlot then 
			self:RefreshSlot(bag, i)
		else 
			self:GetParent():RefreshSlot(bag, i)
		end 
	end 
end;

function MOD:RefreshCD()
	for _, bag in ipairs(self.BagIDs)do 
		for i = 1, GetContainerNumSlots(bag)do 
			local start, duration, enable = GetContainerItemCooldown(bag, i)
			if self.Bags[bag] and self.Bags[bag][i] then
				CooldownFrame_SetTimer(self.Bags[bag][i].cooldown, start, duration, enable)
				if duration > 0 and enable == 0 then 
					SetItemButtonTextureVertexColor(self.Bags[bag][i], 0.4, 0.4, 0.4)
				else 
					SetItemButtonTextureVertexColor(self.Bags[bag][i], 1, 1, 1)
				end
			end
		end 
	end 
end;

function MOD:RefreshBagsSlots()
	for _, bag in ipairs(self.BagIDs)do 
		if self.Bags[bag] then 
			self.Bags[bag]:RefreshBagSlots(bag)
		end 
	end
end;

function MOD:UseSlotFading(this)
	for _, id in ipairs(this.BagIDs)do 
		if this.Bags[id] then 
			local numSlots = GetContainerNumSlots(id)
			for i = 1, numSlots do 
				if this.Bags[id][i] then 
					if id == self.id then 
						this.Bags[id][i]:SetAlpha(1)
					else 
						this.Bags[id][i]:SetAlpha(0.1)
					end 
				end 
			end 
		end 
	end 
end;

function MOD:FlushSlotFading(this)
	for _, id in ipairs(this.BagIDs)do 
		if this.Bags[id] then 
			local numSlots = GetContainerNumSlots(id)
			for i = 1, numSlots do 
				if this.Bags[id][i] then 
					this.Bags[id][i]:SetAlpha(1)
				end 
			end 
		end 
	end 
end;

function MOD:Layout(isBank)
	if SuperVillain.db.SVBag.enable ~= true then return; end;
	local f = MOD:GetContainerFrame(isBank);
	if not f then return; end;
	local buttonSize = isBank and MOD.db.bankSize or MOD.db.bagSize;
	local buttonSpacing = 8;
	local containerWidth = (MOD.db.alignToChat == true and (SuperVillain.db.SVDock.dockWidth - 14)) or (isBank and MOD.db.bankWidth) or MOD.db.bagWidth
	local numContainerColumns = floor(containerWidth / (buttonSize + buttonSpacing));
	local holderWidth = ((buttonSize + buttonSpacing) * numContainerColumns) - buttonSpacing;
	local numContainerRows = 0;
	local bottomPadding = (containerWidth - holderWidth) / 2;
	f.holderFrame:Width(holderWidth);
	f.totalSlots = 0;
	local lastButton;
	local lastRowButton;
	local lastContainerButton;
	local globalName;
	local numContainerSlots, fullContainerSlots = GetNumBankSlots();
	for i, bagID in ipairs(f.BagIDs) do 
		if (not isBank and bagID <= 3) or (isBank and bagID ~= -1 and numContainerSlots >= 1 and not (i - 1 > numContainerSlots)) then 
			if not f.ContainerHolder[i] then 
				if isBank then 
					globalName = "SuperBankBag" .. (bagID - 4);
					f.ContainerHolder[i] = NewFrame("CheckButton", globalName, f.ContainerHolder, "BankItemButtonBagTemplate") 
				else 
					globalName = "SuperMainBag" .. bagID .. "Slot";
					f.ContainerHolder[i] = NewFrame("CheckButton", globalName, f.ContainerHolder, "BagSlotButtonTemplate")
				end
				--f.ContainerHolder[i]:SetSlotTemplate(true, 2, 4, 4, true)
				f.ContainerHolder[i]:SetNormalTexture("")
				f.ContainerHolder[i]:SetCheckedTexture(nil)
				f.ContainerHolder[i]:SetPushedTexture("")
				f.ContainerHolder[i]:SetScript("OnClick", nil)
				f.ContainerHolder[i].id = isBank and bagID or bagID + 1;
				f.ContainerHolder[i]:HookScript("OnEnter", function(self) 
					MOD.UseSlotFading(self, f) end)
				f.ContainerHolder[i]:HookScript("OnLeave", function(self) 
					MOD.FlushSlotFading(self, f) end)
				if isBank then 
					f.ContainerHolder[i]:SetID(bagID)
					if not f.ContainerHolder[i].tooltipText then 
						f.ContainerHolder[i].tooltipText = "" 
					end 
				end 
				f.ContainerHolder[i].iconTexture = _G[f.ContainerHolder[i]:GetName().."IconTexture"];
				f.ContainerHolder[i].iconTexture:FillInner()
				f.ContainerHolder[i].iconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9 )
			end 
			f.ContainerHolder:Size(((buttonSize + buttonSpacing) * (isBank and i - 1 or i)) + buttonSpacing, buttonSize + (buttonSpacing * 2))
			if isBank then 
				BankFrameItemButton_Update(f.ContainerHolder[i])BankFrameItemButton_UpdateLocked(f.ContainerHolder[i])
			end 
			f.ContainerHolder[i]:Size(buttonSize) 
			f.ContainerHolder[i]:ClearAllPoints()
			if (isBank and i == 2) or (not isBank and i == 1) then 
				f.ContainerHolder[i]:SetPoint("BOTTOMLEFT", f.ContainerHolder, "BOTTOMLEFT", buttonSpacing, buttonSpacing)
			else 
				f.ContainerHolder[i]:SetPoint("LEFT", lastContainerButton, "RIGHT", buttonSpacing, 0)
			end 
			lastContainerButton = f.ContainerHolder[i];
		end;
		local numSlots = GetContainerNumSlots(bagID);
		if numSlots > 0 then 
			if not f.Bags[bagID] then 
				f.Bags[bagID] = NewFrame("Frame", f:GetName().."Bag"..bagID, f); 
				f.Bags[bagID]:SetID(bagID);
				f.Bags[bagID].RefreshBagSlots = MOD.RefreshBagSlots;
				f.Bags[bagID].RefreshSlot = RefreshSlot;
			end 
			f.Bags[bagID].numSlots = numSlots;
			local btype = select(2, GetContainerNumFreeSlots(bagID));
			if RefProfessionColors[btype] then
				local r, g, b = unpack(RefProfessionColors[btype]);
				f.Bags[bagID].bagFamily = {r, g, b};
				f.Bags[bagID]:SetBackdropColor(r, g, b, 0.25)
				f.Bags[bagID]:SetBackdropBorderColor(r, g, b, 1)
			else
				f.Bags[bagID].bagFamily = false;
			end
			for i = 1, MAX_CONTAINER_ITEMS do 
				if f.Bags[bagID][i] then 
					f.Bags[bagID][i]:Hide();
				end 
			end 
			for slotID = 1, numSlots do 
				f.totalSlots = f.totalSlots + 1;
				if not f.Bags[bagID][slotID] then 
					f.Bags[bagID][slotID] = NewFrame("CheckButton", f.Bags[bagID]:GetName().."Slot"..slotID, f.Bags[bagID], bagID == -1 and "BankItemButtonGenericTemplate" or "ContainerFrameItemButtonTemplate");
					f.Bags[bagID][slotID]:SetNormalTexture(nil);
					f.Bags[bagID][slotID]:SetCheckedTexture(nil);
					f.Bags[bagID][slotID]:SetSlotTemplate(true, 2, 0, 0, true);
					if(_G[f.Bags[bagID][slotID]:GetName().."NewItemTexture"]) then 
						_G[f.Bags[bagID][slotID]:GetName().."NewItemTexture"]:Hide()
					end 
					f.Bags[bagID][slotID].count:ClearAllPoints();
					f.Bags[bagID][slotID].count:Point("BOTTOMRIGHT", 0, 2);
					f.Bags[bagID][slotID].questIcon = _G[f.Bags[bagID][slotID]:GetName().."IconQuestTexture"];
					f.Bags[bagID][slotID].questIcon:SetTexture(TEXTURE_ITEM_QUEST_BANG);
					f.Bags[bagID][slotID].questIcon:FillInner(f.Bags[bagID][slotID]);
					f.Bags[bagID][slotID].questIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9 );
					f.Bags[bagID][slotID].questIcon:Hide();
					f.Bags[bagID][slotID].iconTexture = _G[f.Bags[bagID][slotID]:GetName().."IconTexture"];
					f.Bags[bagID][slotID].iconTexture:FillInner(f.Bags[bagID][slotID]);
					f.Bags[bagID][slotID].iconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9 );
					f.Bags[bagID][slotID].cooldown = _G[f.Bags[bagID][slotID]:GetName().."Cooldown"];
					SuperVillain:AddCD(f.Bags[bagID][slotID].cooldown)
					f.Bags[bagID][slotID].bagID = bagID
					f.Bags[bagID][slotID].slotID = slotID
				end
				f.Bags[bagID][slotID]:SetID(slotID);
				f.Bags[bagID][slotID]:Size(buttonSize);
				f:RefreshSlot(bagID, slotID);
				if f.Bags[bagID][slotID]:GetPoint() then 
					f.Bags[bagID][slotID]:ClearAllPoints();
				end 
				if lastButton then 
					if (f.totalSlots - 1) % numContainerColumns == 0 then 
						f.Bags[bagID][slotID]:Point("TOP", lastRowButton, "BOTTOM", 0, -buttonSpacing);
						lastRowButton = f.Bags[bagID][slotID];
						numContainerRows = numContainerRows + 1;
					else 
						f.Bags[bagID][slotID]:Point("LEFT", lastButton, "RIGHT", buttonSpacing, 0);
					end 
				else 
					f.Bags[bagID][slotID]:Point("TOPLEFT", f.holderFrame, "TOPLEFT");
					lastRowButton = f.Bags[bagID][slotID];
					numContainerRows = numContainerRows + 1;
				end 
				lastButton = f.Bags[bagID][slotID];	
			end 
		else 
			for i = 1, MAX_CONTAINER_ITEMS do 
				if f.Bags[bagID] and f.Bags[bagID][i] then 
					f.Bags[bagID][i]:Hide();
				end 
			end 
			if f.Bags[bagID] then 
				f.Bags[bagID].numSlots = numSlots;
			end 
			if self.isBank then 
				if self.ContainerHolder[i] then 
					BankFrameItemButton_Update(self.ContainerHolder[i])
					BankFrameItemButton_UpdateLocked(self.ContainerHolder[i])
				end 
			end 
		end 
	end 
	f:Size(containerWidth, (((buttonSize + buttonSpacing) * numContainerRows) - buttonSpacing) + f.topOffset + f.bottomOffset);
end;

function MOD:RefreshBags()
	if MOD.BagFrame then 
		MOD:Layout(false)
	end;
	if MOD.BankFrame then 
		MOD:Layout(true)
	end 
end;

function MOD:UpdateGoldText()
	MOD.BagFrame.goldText:SetText(GetCoinTextureString(GetMoney(), 12))
end;

function MOD:VendorGrays(arg1, arg2, arg3)
	if(not MerchantFrame or not MerchantFrame:IsShown()) and not arg1 and not arg3 then 
		SuperVillain:AddonMessage(L["You must be at a vendor."])
		return 
	end;
	local copper = 0;
	local deleted = 0;
	for i = 0, 4 do 
		for silver = 1, GetContainerNumSlots(i) do 
			local a2 = GetContainerItemLink(i, silver)
			if a2 and select(11, GetItemInfo(a2)) then 
				local a3 = select(11, GetItemInfo(a2)) * select(2, GetContainerItemInfo(i, silver))
				if arg1 then 
					if find(a2, "ff9d9d9d") then 
						if not arg3 then 
							PickupContainerItem(i, silver)
							DeleteCursorItem()
						end;
						copper = copper + a3;
						deleted = deleted + 1 
					end 
				else 
					if select(3, GetItemInfo(a2)) == 0 and a3 > 0 then 
						if not arg3 then 
							UseContainerItem(i, silver)
							PickupMerchantItem()
						end;
						copper = copper + a3 
					end 
				end 
			end 
		end 
	end;
	if arg3 then return copper end;
	if copper > 0 and not arg1 then 
		local gold, silver, copper = floor(copper / 10000) or 0, floor(copper%10000 / 100) or 0, copper%100;
		SuperVillain:AddonMessage(L["Vendored gray items for:"].." |cffffffff"..gold..L.goldabbrev.." |cffffffff"..silver ..L.silverabbrev.." |cffffffff"..copper ..L.copperabbrev..".")
	elseif not arg1 and not arg2 then 
		SuperVillain:AddonMessage(L["No gray items to sell."])
	elseif deleted > 0 then 
		local gold, silver, copper = floor(copper / 10000) or 0, floor(copper%10000 / 100) or 0, copper%100;
		SuperVillain:AddonMessage(format(L["Deleted %d gray items. Total Worth: %s"], deleted, " |cffffffff"..gold..L.goldabbrev.." |cffffffff"..silver ..L.silverabbrev.." |cffffffff"..copper ..L.copperabbrev.."."))
	elseif not arg2 then 
		SuperVillain:AddonMessage(L["No gray items to delete."])
	end 
end;

function MOD:ModifyBags()
	if self.BagFrame then 
		self.BagFrame:ClearAllPoints()
		self.BagFrame:Point("BOTTOMRIGHT", RightSuperDock, "BOTTOMRIGHT", 0-MOD.db.xOffset, 0 + MOD.db.yOffset)
	end;
	if self.BankFrame then 
		self.BankFrame:ClearAllPoints()
		self.BankFrame:Point("BOTTOMLEFT", LeftSuperDock, "BOTTOMLEFT", 0 + MOD.db.xOffset, 0 + MOD.db.yOffset)
	end 
end;

do
	local function Bags_OnEnter()
		if MOD.db.bagBar.mouseover ~= true then return end;
		UIFrameFadeIn(SVUI_BagBar, 0.2, SVUI_BagBar:GetAlpha(), 1)
	end

	local function Bags_OnLeave()
		if MOD.db.bagBar.mouseover ~= true then return end;
		UIFrameFadeOut(SVUI_BagBar, 0.2, SVUI_BagBar:GetAlpha(), 0)
	end

	local function AlterBagBar(bar)
		local icon = _G[bar:GetName().."IconTexture"]
		bar.oldTex = icon:GetTexture()
		bar:Formula409()
		bar:SetFixedPanelTemplate("Default")
		bar:SetSlotTemplate(false, 1, nil, nil, true)
		icon:SetTexture(bar.oldTex)
		icon:FillInner()
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9 )
	end

	local function LoadBagBar()
		if MOD.BagBarLoaded then return end;
		local bar = NewFrame("Frame", "SVUI_BagBar", SuperVillain.UIParent)
		bar:SetPoint("TOPRIGHT", RightSuperDock, "TOPLEFT", -4, 0)
		bar.buttons = {}
		bar:SetPanelTemplate()
		bar:EnableMouse(true)
		bar:SetScript("OnEnter", Bags_OnEnter)
		bar:SetScript("OnLeave", Bags_OnLeave)
		MainMenuBarBackpackButton:SetParent(bar)
		MainMenuBarBackpackButton.SetParent = SuperVillain.dummy;
		MainMenuBarBackpackButton:ClearAllPoints()
		MainMenuBarBackpackButtonCount:SetFontTemplate(nil, 10)
		MainMenuBarBackpackButtonCount:ClearAllPoints()
		MainMenuBarBackpackButtonCount:Point("BOTTOMRIGHT", MainMenuBarBackpackButton, "BOTTOMRIGHT", -1, 4)
		MainMenuBarBackpackButton:HookScript("OnEnter", Bags_OnEnter)
		MainMenuBarBackpackButton:HookScript("OnLeave", Bags_OnLeave)
		tinsert(bar.buttons, MainMenuBarBackpackButton)
		AlterBagBar(MainMenuBarBackpackButton)
		local count = #bar.buttons
		local frameCount = NUM_BAG_FRAMES - 1;
		for i = 0, frameCount do 
			local bagSlot = _G["CharacterBag"..i.."Slot"]
			bagSlot:SetParent(bar)
			bagSlot.SetParent = SuperVillain.dummy;
			bagSlot:HookScript("OnEnter", Bags_OnEnter)
			bagSlot:HookScript("OnLeave", Bags_OnLeave)
			AlterBagBar(bagSlot)
			count = count + 1
			bar.buttons[count] = bagSlot
		end;
		SuperVillain:SetSVMovable(bar, "Bags_MOVE", L["Bags"])
		MOD.BagBarLoaded = true
	end

	function MOD:ModifyBagBar()
		if not SuperVillain.db.SVBag.bagBar.enable then return end;
		if not MOD.BagBarLoaded then 
			LoadBagBar() 
		end;
		if MOD.db.bagBar.mouseover then 
			SVUI_BagBar:SetAlpha(0)
		else 
			SVUI_BagBar:SetAlpha(1)
		end;
		if MOD.db.bagBar.showBackdrop then 
			SVUI_BagBar.Panel:Show()
		else 
			SVUI_BagBar.Panel:Hide()
		end;
		for i = 1, #SVUI_BagBar.buttons do 
			local button = SVUI_BagBar.buttons[i]
			local lastButton = SVUI_BagBar.buttons[i - 1]
			button:Size(MOD.db.bagBar.size)
			button:ClearAllPoints()
			if MOD.db.bagBar.showBy == "HORIZONTAL" and MOD.db.bagBar.sortDirection == "ASCENDING" then 
				if i == 1 then 
					button:SetPoint("LEFT", SVUI_BagBar, "LEFT", MOD.db.bagBar.spacing, 0)
				elseif lastButton then 
					button:SetPoint("LEFT", lastButton, "RIGHT", MOD.db.bagBar.spacing, 0)
				end 
			elseif MOD.db.bagBar.showBy == "VERTICAL" and MOD.db.bagBar.sortDirection == "ASCENDING" then 
				if i == 1 then 
					button:SetPoint("TOP", SVUI_BagBar, "TOP", 0, -MOD.db.bagBar.spacing)
				elseif lastButton then 
					button:SetPoint("TOP", lastButton, "BOTTOM", 0, -MOD.db.bagBar.spacing)
				end 
			elseif MOD.db.bagBar.showBy == "HORIZONTAL" and MOD.db.bagBar.sortDirection == "DESCENDING" then 
				if i == 1 then 
					button:SetPoint("RIGHT", SVUI_BagBar, "RIGHT", -MOD.db.bagBar.spacing, 0)
				elseif lastButton then 
					button:SetPoint("RIGHT", lastButton, "LEFT", -MOD.db.bagBar.spacing, 0)
				end 
			else 
				if i == 1 then 
					button:SetPoint("BOTTOM", SVUI_BagBar, "BOTTOM", 0, MOD.db.bagBar.spacing)
				elseif lastButton then 
					button:SetPoint("BOTTOM", lastButton, "TOP", 0, MOD.db.bagBar.spacing)
				end 
			end 
		end;
		if MOD.db.bagBar.showBy == "HORIZONTAL" then 
			SVUI_BagBar:Width(MOD.db.bagBar.size * numBagFrame + MOD.db.bagBar.spacing * numBagFrame + MOD.db.bagBar.spacing)
			SVUI_BagBar:Height(MOD.db.bagBar.size + MOD.db.bagBar.spacing * 2)
		else 
			SVUI_BagBar:Height(MOD.db.bagBar.size * numBagFrame + MOD.db.bagBar.spacing * numBagFrame + MOD.db.bagBar.spacing)
			SVUI_BagBar:Width(MOD.db.bagBar.size + MOD.db.bagBar.spacing * 2)
		end 
	end
end;

function MOD:RepositionBags()
	local a9, xOffset, yOffset, aa, ab, ac, ad;
	local ae = GetScreenWidth()
	local af = 1;
	local ag = 0;
	if BankFrame:IsShown()then 
		ag = BankFrame:GetRight()-25 
	end;
	while af>CONTAINER_SCALE do 
		aa = GetScreenHeight() / af;
		xOffset = CONTAINER_OFFSET_X / af;
		yOffset = CONTAINER_OFFSET_Y / af;
		ab = aa-yOffset;
		ac = ae-xOffset;
		ad = 1;
		local ah;
		for ai, aj in ipairs(ContainerFrame1.bags)do 
			ah = _G[aj]:GetHeight()
			if ab<ah then 
				ad = ad + 1;
				ac = ae-ad * CONTAINER_WIDTH * af-xOffset;
				ab = aa-yOffset 
			end;
			ab = ab-ah-VISIBLE_CONTAINER_SPACING 
		end;
		if ac<ag then 
			af = af-0.01 
		else 
			break 
		end 
	end;
	if af<CONTAINER_SCALE then 
		af = CONTAINER_SCALE 
	end;
	aa = GetScreenHeight() / af;
	xOffset = CONTAINER_OFFSET_X / af;
	yOffset = CONTAINER_OFFSET_Y / af;
	ab = aa-yOffset;
	ad = 0;
	local ak = 0;
	for ai, aj in ipairs(ContainerFrame1.bags)do 
		a9 = _G[aj]
		a9:SetScale(1)
		if ai == 1 then 
			a9:SetPoint("BOTTOMRIGHT", RightSuperDock, "BOTTOMRIGHT", 2, 2)
			ak = ak + 1 
		elseif ab<a9:GetHeight()then 
			ad = ad + 1;
			ab = aa-yOffset;
			if ad>1 then 
				a9:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[ai-ak-1], "BOTTOMLEFT", -CONTAINER_SPACING, 0)
			else 
				a9:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[ai-ak], "BOTTOMLEFT", -CONTAINER_SPACING, 0)
			end;
			ak = 0 
		else 
			a9:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[ai-1], "TOPRIGHT", 0, CONTAINER_SPACING)
			ak = ak + 1 
		end;
		ab = ab-a9:GetHeight()-VISIBLE_CONTAINER_SPACING 
	end
end;
--[[ 
########################################################## 
BAG CONTAINER CREATION
##########################################################
]]--
do
	local function UpdateEquipmentInfo(slot, bag, index)
		if not slot.equipmentinfo then 
			slot.equipmentinfo = slot:CreateFontString(nil,"OVERLAY")
			slot.equipmentinfo:SetFontTemplate(SuperVillain.Media.font.roboto, 10, "OUTLINE")
			slot.equipmentinfo:SetAllPoints(slot)
			slot.equipmentinfo:SetWordWrap(true)
			slot.equipmentinfo:SetJustifyH('LEFT')
			slot.equipmentinfo:SetJustifyV('BOTTOM')
		end;
		if slot.equipmentinfo then 
			slot.equipmentinfo:SetAllPoints(slot)
			local loc = format("%d_%d", bag, index)
			local level = 0;
			if gearList[loc] then
				level = #gearList[loc] < 4 and #gearList[loc] or 3;
				formatAndSave(level, slot.equipmentinfo, gearList[loc])
			else
				formatAndSave(level, slot.equipmentinfo, nil)
			end 
		end 
	end;

	local Search_OnKeyPressed = function(self)
		self:GetParent().detail:Show()
		self:ClearFocus()
		SetItemSearch('')
	end;

	local Search_OnInput = function(self)
		local i = 3;
		local j = self:GetText()
		if len(j) > i then 
			local k=true;
			for h=1,i,1 do 
				if sub(j,0-h,0-h) ~= sub(j,-1-h,-1-h) then 
					k=false;
					break 
				end 
			end;
			if k then 
				Search_OnKeyPressed(self)
				return 
			end 
		end;
		SetItemSearch(j)
	end;

	local Search_OnClick = function(self, button)
		local container = self:GetParent()
		if button == "RightButton"then 
			container.detail:Hide()
			container.editBox:Show()
			container.editBox:SetText(SEARCH)
			container.editBox:HighlightText()
		else 
			if container.editBox:IsShown()then 
				container.editBox:Hide()
				container.editBox:ClearFocus()
				container.detail:Show()
				SetItemSearch('')
			else 
				container.detail:Hide()
				container.editBox:Show()
				container.editBox:SetText(SEARCH)
				container.editBox:HighlightText()
			end 
		end 
	end;

	local Container_OnEvent = function(self, event, ...)
		if(event == "ITEM_LOCK_CHANGED" or event == "ITEM_UNLOCKED") then 
			self:RefreshSlot(...)
		elseif(event == "BAG_UPDATE" or event == "EQUIPMENT_SETS_CHANGED") then
			BuildEquipmentMap()
			for _, id in ipairs(self.BagIDs) do 
				local numSlots = GetContainerNumSlots(id)
				if(not self.Bags[id] and numSlots ~= 0 or self.Bags[id] and numSlots ~= self.Bags[id].numSlots) then 
					MOD:Layout(self.isBank)
					return 
				end
				if(SuperVillain.db.SVGear.misc.setoverlay) then
					for i = 1, numSlots do
						if self.Bags[id] and self.Bags[id][i] then 
							UpdateEquipmentInfo(self.Bags[id][i], id, i) 
						end
					end
				end
			end;
			self:RefreshBagSlots(...)
		elseif(event == "BAG_UPDATE_COOLDOWN") then 
			self:RefreshCD()
		elseif(event == "PLAYERBANKSLOTS_CHANGED") then 
			self:RefreshBagsSlots()
		end 
	end;

	local Vendor_OnClick = function(self)
		if IsShiftKeyDown()then 
			SuperVillain.SystemAlert["DELETE_GRAYS"].Money = MOD:VendorGrays(false,true,true)
			SuperVillain:StaticPopup_Show('DELETE_GRAYS')
		else 
			MOD:VendorGrays()
		end 
	end;

	local Token_OnEnter = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetBackpackToken(self:GetID())
	end;

	local Token_OnLeave = function(self)
		GameTooltip:Hide() 
	end;

	local Token_OnClick = function(self)
		if IsModifiedClick("CHATLINK") then 
			HandleModifiedItemClick(GetCurrencyLink(self.currencyID))
		end 
	end;

	local Tooltip_Show = function(self)
		GameTooltip:SetOwner(self:GetParent(),"ANCHOR_TOP",0,4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(self.ttText)
		if self.ttText2 then 
			GameTooltip:AddLine(' ')
			GameTooltip:AddDoubleLine(self.ttText2,self.ttText2desc,1,1,1)
		end;
		self:GetNormalTexture():SetGradient(unpack(SuperVillain.Media.gradient.highlight))
		GameTooltip:Show()
	end;

	local Tooltip_Hide = function(self)
		self:GetNormalTexture():SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		GameTooltip:Hide()
	end;

	local Container_OnDragStart = function(self)
		if IsShiftKeyDown()then self:StartMoving()end
	end;
	local Container_OnDragStop = function(self)
		self:StopMovingOrSizing()
	end;
	local Container_OnClick = function(self)
		if IsControlKeyDown()then MOD:ModifyBags()end
	end;
	local Container_OnEnter = function(self)
		GameTooltip:SetOwner(self,"ANCHOR_TOPLEFT",0,4)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(L['Hold Shift + Drag:'],L['Temporary Move'],1,1,1)
		GameTooltip:AddDoubleLine(L['Hold Control + Right Click:'],L['Reset Position'],1,1,1)
		GameTooltip:Show()
	end;

	function MOD:ToggleEquipmentOverlay()
		local numSlots, container;
		if(MOD.BagFrame) then
			container = MOD.BagFrame
			for _,id in ipairs(container.BagIDs) do
				numSlots = GetContainerNumSlots(id)
				if(SuperVillain.db.SVGear.misc.setoverlay) then
					for i=1,numSlots do
						if container.Bags[id] and container.Bags[id][i] then 
							UpdateEquipmentInfo(container.Bags[id][i], id, i) 
						end
					end
				else
					for i=1,numSlots do
						if(container.Bags[id] and container.Bags[id][i] and container.Bags[id][i].equipmentinfo) then 
							container.Bags[id][i].equipmentinfo:SetText()
						end
					end
				end
			end
		end
		if(MOD.BankFrame) then
			container = MOD.BankFrame
			for _,id in ipairs(container.BagIDs) do 
				numSlots = GetContainerNumSlots(id)
				if(SuperVillain.db.SVGear.misc.setoverlay) then
					for i=1,numSlots do
						if container.Bags[id] and container.Bags[id][i] then 
							UpdateEquipmentInfo(container.Bags[id][i], id, i) 
						end
					end
				else
					for i=1,numSlots do
						if(container.Bags[id] and container.Bags[id][i] and container.Bags[id][i].equipmentinfo) then 
							container.Bags[id][i].equipmentinfo:SetText()
						end
					end
				end
			end
		end
	end

	function MOD:MakeBags(parent, isBank)
		local uisCount = #UISpecialFrames + 1;
		local bagsCount = #self.BagFrames + 1;
		local frame = NewFrame('Button', parent, SuperVillain.UIParent)
		frame:SetPanelTemplate("Container")
		frame.Panel:SetAllPoints()
		frame:SetFrameStrata('HIGH')
		frame.RefreshSlot=MOD.RefreshSlot;
		frame.RefreshBagsSlots=MOD.RefreshBagsSlots;
		frame.RefreshBagSlots=MOD.RefreshBagSlots;
		frame.RefreshCD=MOD.RefreshCD;
		frame:RegisterEvent('ITEM_LOCK_CHANGED')
		frame:RegisterEvent('ITEM_UNLOCKED')
		frame:RegisterEvent('BAG_UPDATE_COOLDOWN')
		frame:RegisterEvent('BAG_UPDATE')
		frame:RegisterEvent("EQUIPMENT_SETS_CHANGED")
		frame:RegisterEvent('PLAYERBANKSLOTS_CHANGED')
		frame:SetMovable(true)
		frame:RegisterForDrag("LeftButton","RightButton")
		frame:RegisterForClicks("AnyUp")
		frame:SetScript("OnDragStart", Container_OnDragStart)
		frame:SetScript("OnDragStop", Container_OnDragStop)
		frame:SetScript("OnClick", Container_OnClick)
		frame:SetScript("OnEnter", Container_OnEnter)
		frame:SetScript('OnLeave', Token_OnLeave)
		frame:SetScript('OnEvent', Container_OnEvent)
		frame.isBank = isBank;
		frame:Hide()
		frame.bottomOffset=isBank and 8 or 32;
		frame.topOffset=isBank and 60 or 65;
		frame.BagIDs=isBank and {-1,5,6,7,8,9,10,11} or {0,1,2,3,4}
		frame.Bags={}
		frame.closeButton=NewFrame('Button',parent..'CloseButton',frame,'UIPanelCloseButton')
		frame.closeButton:Point('TOPRIGHT',-4,-4)
		frame.holderFrame=NewFrame('Frame',nil,frame)
		frame.holderFrame:Point('TOP',frame,'TOP',0,-frame.topOffset)
		frame.holderFrame:Point('BOTTOM',frame,'BOTTOM',0,frame.bottomOffset)
		frame.ContainerHolder=NewFrame('Button',parent..'ContainerHolder',frame)
		frame.ContainerHolder:Point('BOTTOMLEFT',frame,'TOPLEFT',0,1)
		frame.ContainerHolder:SetFixedPanelTemplate('Transparent')
		frame.ContainerHolder:Hide()

		if isBank then 
			frame.sortButton=NewFrame('Button',nil,frame)
			frame.sortButton:Point('TOPRIGHT',frame,'TOP',0,-10)
			frame.sortButton:Size(25,25)
			frame.sortButton:SetNormalTexture(ICON_SORT)
			StyleBagToolButton(frame.sortButton)
			frame.sortButton.ttText=L['Sort Bags']
			frame.sortButton:SetScript("OnEnter", Tooltip_Show)
			frame.sortButton:SetScript("OnLeave", Tooltip_Hide)
			local Sort_OnClick = MOD:RunSortingProcess(MOD.Sort,'bank')
			frame.sortButton:SetScript('OnClick', Sort_OnClick)

			frame.stackButton=NewFrame('Button',nil,frame)
			frame.stackButton:Point('LEFT',frame.sortButton,'RIGHT',10,0)
			frame.stackButton:Size(25,25)
			frame.stackButton:SetNormalTexture(ICON_STACK)
			StyleBagToolButton(frame.stackButton)
			frame.stackButton.ttText=L['Stack Items']
			frame.stackButton:SetScript("OnEnter", Tooltip_Show)
			frame.stackButton:SetScript("OnLeave", Tooltip_Hide)
			local Stack_OnClick = MOD:RunSortingProcess(MOD.Stack,'bank')
			frame.stackButton:SetScript('OnClick', Stack_OnClick)

			frame.transferButton=NewFrame('Button',nil,frame)
			frame.transferButton:Point('LEFT',frame.stackButton,'RIGHT',10,0)
			frame.transferButton:Size(25,25)
			frame.transferButton:SetNormalTexture(ICON_TRANSFER)
			StyleBagToolButton(frame.transferButton)
			frame.transferButton.ttText=L['Stack Bank to Bags']
			frame.transferButton:SetScript("OnEnter", Tooltip_Show)
			frame.transferButton:SetScript("OnLeave", Tooltip_Hide)
			local Transfer_OnClick = MOD:RunSortingProcess(MOD.Transfer,'bank bags')
			frame.transferButton:SetScript('OnClick', Transfer_OnClick)

			frame.bagsButton=NewFrame('Button',nil,frame)
			frame.bagsButton:Point('RIGHT',frame.sortButton,'LEFT',-10,0)
			frame.bagsButton:Size(25,25)
			frame.bagsButton:SetNormalTexture(ICON_BAGS)
			StyleBagToolButton(frame.bagsButton)
			frame.bagsButton.ttText=L['Toggle Bags']
			frame.bagsButton:SetScript("OnEnter", Tooltip_Show)
			frame.bagsButton:SetScript("OnLeave", Tooltip_Hide)
			local BagBtn_OnClick = function()
				local numSlots,_ = GetNumBankSlots()
				if numSlots >= 1 then 
					ToggleFrame(frame.ContainerHolder)
				else 
					SuperVillain:StaticPopup_Show("NO_BANK_BAGS")
				end 
			end
			frame.bagsButton:SetScript('OnClick', BagBtn_OnClick)

			frame.purchaseBagButton=NewFrame('Button',nil,frame)
			frame.purchaseBagButton:Size(25,25)
			frame.purchaseBagButton:Point('RIGHT',frame.bagsButton,'LEFT',-10,0)
			frame.purchaseBagButton:SetFrameLevel(frame.purchaseBagButton:GetFrameLevel()+2)
			frame.purchaseBagButton:SetNormalTexture(ICON_PURCHASE)
			StyleBagToolButton(frame.purchaseBagButton)
			frame.purchaseBagButton.ttText=L['Purchase']
			frame.purchaseBagButton:SetScript("OnEnter", Tooltip_Show)
			frame.purchaseBagButton:SetScript("OnLeave", Tooltip_Hide)
			local PurchaseBtn_OnClick = function()
				local _,full = GetNumBankSlots()
				if not full then 
					SuperVillain:StaticPopup_Show("BUY_BANK_SLOT")
				else 
					SuperVillain:StaticPopup_Show("CANNOT_BUY_BANK_SLOT")
				end 
			end
			frame.purchaseBagButton:SetScript("OnClick", PurchaseBtn_OnClick)
			frame:SetScript('OnHide',CloseBankFrame)
			UISpecialFrames[uisCount] = "SVUI_BankContainerFrame";
		else 
			frame.goldText = frame:CreateFontString(nil,'OVERLAY')
			frame.goldText:SetFontTemplate(SuperVillain.Media.font.numbers)
			frame.goldText:Point('BOTTOMRIGHT',frame.holderFrame,'TOPRIGHT',-2,4)
			frame.goldText:SetJustifyH("RIGHT")

			frame.editBox = NewFrame('EditBox', parent..'EditBox', frame)
			frame.editBox:SetFrameLevel(frame.editBox:GetFrameLevel()+2)
			frame.editBox:SetEditboxTemplate()
			frame.editBox:Height(15)
			frame.editBox:Hide()
			frame.editBox:Point('BOTTOMLEFT',frame.holderFrame,'TOPLEFT',2,4)
			frame.editBox:Point('RIGHT',frame.goldText,'LEFT',-5,0)
			frame.editBox:SetAutoFocus(true)
			frame.editBox:SetScript("OnEscapePressed", Search_OnKeyPressed)
			frame.editBox:SetScript("OnEnterPressed", Search_OnKeyPressed)
			frame.editBox:SetScript("OnEditFocusLost", frame.editBox.Hide)
			frame.editBox:SetScript("OnEditFocusGained", frame.editBox.HighlightText)
			frame.editBox:SetScript("OnTextChanged", Search_OnInput)
			frame.editBox:SetScript('OnChar', Search_OnInput)
			frame.editBox:SetText(SEARCH)
			frame.editBox:SetFontTemplate(SuperVillain.Media.font.roboto)

			local searchButton = NewFrame("Button", nil, frame)
			searchButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
			searchButton:SetSize(60, 18)
			searchButton:SetPoint("BOTTOMLEFT", frame.editBox, "BOTTOMLEFT", -2, 0)
			searchButton:SetButtonTemplate()
			searchButton:SetScript("OnClick", Search_OnClick)

			local searchText = searchButton:CreateFontString(nil,"OVERLAY")
			searchText:SetFont(SuperVillain.Media.font.roboto, 12, "NONE")
			searchText:SetAllPoints(searchButton)
			searchText:SetJustifyH("CENTER")
			searchText:SetText("|cff9999ff"..SEARCH.."|r")
			searchButton:SetFontString(searchText)

			frame.detail = searchButton

			frame.sortButton=NewFrame('Button',nil,frame)
			frame.sortButton:Point('TOP',frame,'TOP',0,-10)
			frame.sortButton:Size(25,25)
			frame.sortButton:SetNormalTexture(ICON_SORT)
			StyleBagToolButton(frame.sortButton)
			frame.sortButton.ttText=L['Sort Bags']
			frame.sortButton:SetScript("OnEnter", Tooltip_Show)
			frame.sortButton:SetScript("OnLeave", Tooltip_Hide)
			local Sort_OnClick = MOD:RunSortingProcess(MOD.Sort,'bags')
			frame.sortButton:SetScript('OnClick', Sort_OnClick)

			frame.stackButton=NewFrame('Button',nil,frame)
			frame.stackButton:Point('LEFT',frame.sortButton,'RIGHT',10,0)
			frame.stackButton:Size(25,25)
			frame.stackButton:SetNormalTexture(ICON_STACK)
			StyleBagToolButton(frame.stackButton)
			frame.stackButton.ttText=L['Stack Items']
			frame.stackButton:SetScript("OnEnter", Tooltip_Show)
			frame.stackButton:SetScript("OnLeave", Tooltip_Hide)
			local Stack_OnClick = MOD:RunSortingProcess(MOD.Stack,'bags')
			frame.stackButton:SetScript('OnClick', Stack_OnClick)

			frame.vendorButton=NewFrame('Button',nil,frame)
			frame.vendorButton:Point('RIGHT',frame.sortButton,'LEFT',-10,0)
			frame.vendorButton:Size(25,25)
			frame.vendorButton:SetNormalTexture(ICON_VENDOR)
			StyleBagToolButton(frame.vendorButton)
			frame.vendorButton.ttText=L['Vendor Grays']
			frame.vendorButton.ttText2=L['Hold Shift:']
			frame.vendorButton.ttText2desc=L['Delete Grays']
			frame.vendorButton:SetScript("OnEnter", Tooltip_Show)
			frame.vendorButton:SetScript("OnLeave", Tooltip_Hide)
			frame.vendorButton:SetScript('OnClick', Vendor_OnClick)

			frame.bagsButton=NewFrame('Button',nil,frame)
			frame.bagsButton:Point('RIGHT',frame.vendorButton,'LEFT',-10,0)
			frame.bagsButton:Size(25,25)
			frame.bagsButton:SetNormalTexture(ICON_BAGS)
			StyleBagToolButton(frame.bagsButton)
			frame.bagsButton.ttText=L['Toggle Bags']
			frame.bagsButton:SetScript("OnEnter", Tooltip_Show)
			frame.bagsButton:SetScript("OnLeave", Tooltip_Hide)
			local BagBtn_OnClick = function()
				ToggleFrame(frame.ContainerHolder)
			end
			frame.bagsButton:SetScript('OnClick', BagBtn_OnClick)

			frame.transferButton=NewFrame('Button',nil,frame)
			frame.transferButton:Point('LEFT',frame.stackButton,'RIGHT',10,0)
			frame.transferButton:Size(25,25)
			frame.transferButton:SetNormalTexture(ICON_TRANSFER)
			StyleBagToolButton(frame.transferButton)
			frame.transferButton.ttText=L['Stack Bags to Bank']
			frame.transferButton:SetScript("OnEnter", Tooltip_Show)
			frame.transferButton:SetScript("OnLeave", Tooltip_Hide)
			local Transfer_OnClick = MOD:RunSortingProcess(MOD.Transfer,'bags bank')
			frame.transferButton:SetScript('OnClick', Transfer_OnClick)

			frame.currencyButton=NewFrame('Frame',nil,frame)
			frame.currencyButton:Point('BOTTOMLEFT',frame,'BOTTOMLEFT',4,0)
			frame.currencyButton:Point('BOTTOMRIGHT',frame,'BOTTOMRIGHT',-4,0)
			frame.currencyButton:Height(32)
			for h=1,MAX_WATCHED_TOKENS do 
				frame.currencyButton[h]=NewFrame('Button',nil,frame.currencyButton)
				frame.currencyButton[h]:Size(22)
				frame.currencyButton[h]:SetFixedPanelTemplate('Default')
				frame.currencyButton[h]:SetID(h)
				frame.currencyButton[h].icon=frame.currencyButton[h]:CreateTexture(nil,'OVERLAY')
				frame.currencyButton[h].icon:FillInner()
				frame.currencyButton[h].icon:SetTexCoord(0.1,0.9,0.1,0.9)
				frame.currencyButton[h].text = frame.currencyButton[h]:CreateFontString(nil,'OVERLAY')
				frame.currencyButton[h].text:Point('LEFT',frame.currencyButton[h],'RIGHT',2,0)
				frame.currencyButton[h].text:SetFontTemplate(SuperVillain.Media.font.numbers,18,"NONE")
				frame.currencyButton[h]:SetScript('OnEnter', Token_OnEnter)
				frame.currencyButton[h]:SetScript('OnLeave', Token_OnLeave)
				frame.currencyButton[h]:SetScript('OnClick', Token_OnClick)
				frame.currencyButton[h]:Hide()
			end;
			frame:SetScript('OnHide',CloseAllBags)
			UISpecialFrames[uisCount] = "SVUI_ContainerFrame";
		end;
		self.BagFrames[bagsCount] = frame
		return frame
	end;
end;

do
	local function RefreshTKN()
		local frame = MOD.BagFrame;
		local index = 0;
		for i=1,MAX_WATCHED_TOKENS do
			local name,count,icon,currencyID = GetBackpackCurrencyInfo(i)
			local set = frame.currencyButton[i]
			set:ClearAllPoints()
			if name then 
				set.icon:SetTexture(icon)
				if MOD.db.currencyFormat == 'ICON_TEXT' then 
					set.text:SetText(name..': '..count)
				elseif MOD.db.currencyFormat == 'ICON' then 
					set.text:SetText(count)
				end;
				set.currencyID = currencyID;
				set:Show()
				index = index + 1; 
			else 
				set:Hide()
			end 
		end;
		if index == 0 then 
			frame.bottomOffset = 8;
			if frame.currencyButton:IsShown() then 
				frame.currencyButton:Hide()
				MOD:Layout(false)
			end;
			return 
		elseif not frame.currencyButton:IsShown() then 
			frame.bottomOffset = 28;
			frame.currencyButton:Show()
			MOD:Layout(false)
		end;
		frame.bottomOffset = 28;
		local set = frame.currencyButton;
		if index == 1 then 
			set[1]:Point("BOTTOM", set, "BOTTOM", -(set[1].text:GetWidth() / 2), 3)
		elseif index == 2 then 
			set[1]:Point("BOTTOM", set, "BOTTOM", -set[1].text:GetWidth()-set[1]:GetWidth() / 2, 3)
			frame.currencyButton[2]:Point("BOTTOMLEFT", set, "BOTTOM", set[2]:GetWidth() / 2, 3)
		else 
			set[1]:Point("BOTTOMLEFT", set, "BOTTOMLEFT", 3, 3)
			set[2]:Point("BOTTOM", set, "BOTTOM", -(set[2].text:GetWidth() / 3), 3)
			set[3]:Point("BOTTOMRIGHT", set, "BOTTOMRIGHT", -set[3].text:GetWidth()-set[3]:GetWidth() / 2, 3)
		end 
	end;

	local function OpenBags()
		GameTooltip:Hide()
		MOD.BagFrame:Show()
		MOD.BagFrame:RefreshBagsSlots()
		TTIP.GameTooltip_SetDefaultAnchor(GameTooltip)
	end

	local function CloseBags()
		GameTooltip:Hide()
		MOD.BagFrame:Hide()
		if(MOD.BankFrame) then 
			MOD.BankFrame:Hide()
		end;
		if(BreakStuffHandler and BreakStuffButton and BreakStuffButton.icon) then
			BreakStuffHandler:MODIFIER_STATE_CHANGED()
			BreakStuffHandler.ReadyToSmash = false
			BreakStuffButton.ttText = "BreakStuff : OFF";
			BreakStuffButton.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		end
		TTIP.GameTooltip_SetDefaultAnchor(GameTooltip)
	end

	local function ToggleBags(id)
		if id and GetContainerNumSlots(id)==0 then return end;
		if MOD.BagFrame:IsShown()then 
			CloseBags()
		else 
			OpenBags()
		end 
	end

	local function ToggleBackpack()
		if IsOptionFrameOpen()then return end;
		if IsBagOpen(0) then 
			OpenBags()
		else 
			CloseBags()
		end 
	end

	local function OpenBank()
		if not MOD.BankFrame then 
			MOD.BankFrame = MOD:MakeBags('SVUI_BankContainerFrame',true)
			MOD:ModifyBags()
		end;
		MOD:Layout(true)
		MOD.BankFrame:Show()
		MOD.BankFrame:RefreshBagsSlots()
		MOD.BagFrame:Show()
		MOD.BagFrame:RefreshBagsSlots()
		RefreshTKN()
	end

	local function CloseBank()
		if not MOD.BankFrame then return end;
		MOD.BankFrame:Hide()
	end

	function SetBagHooks()
		NewHook("OpenAllBags", OpenBags)
		NewHook("CloseAllBags", CloseBags)
		NewHook("ToggleBag", ToggleBags)
		NewHook("ToggleAllBags", ToggleBackpack)
		NewHook("ToggleBackpack", ToggleBackpack)
		NewHook("BackpackTokenFrame_Update", RefreshTKN)
		MOD:RegisterEvent("BANKFRAME_OPENED", OpenBank)
		MOD:RegisterEvent("BANKFRAME_CLOSED", CloseBank)
	end
end;

function MOD:PLAYERBANKBAGSLOTS_CHANGED()
	MOD:Layout(true)
end;
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:UpdateThisPackage()
	self:Layout();
	self:Layout(true);
	self:ModifyBags();
	self:ModifyBagBar();
end;

function MOD:ConstructThisPackage()
	if not SuperVillain.db.SVBag.enable then return end;
	self:ModifyBagBar()
	SuperVillain.bags = self;
	self.BagFrames = {}
	self.BagFrame = self:MakeBags("SVUI_ContainerFrame")
	SetBagHooks()
	self:ModifyBags()
	self:Layout(false)
	self:DisableBlizzard()
	self:Protect("BreakStuffLoader");
	SuperVillain:ExecuteTimer(MOD.BreakStuffLoader, 5)
	self:RegisterEvent("INVENTORY_SEARCH_UPDATE")
	self:RegisterEvent("PLAYER_MONEY", "UpdateGoldText")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateGoldText")
	self:RegisterEvent("PLAYER_TRADE_MONEY", "UpdateGoldText")
	self:RegisterEvent("TRADE_MONEY_CHANGED", "UpdateGoldText")
	self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED");
	StackSplitFrame:SetFrameStrata("DIALOG")
	self.BagFrame:RefreshBagsSlots()
end;

SuperVillain.Registry:NewPackage(MOD, "SVBag");