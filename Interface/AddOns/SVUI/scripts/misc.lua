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
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
--[[ 
########################################################## 
MERCHANT MAX STACK
##########################################################
]]--
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
function MerchantItemButton_OnModifiedClick(self, ...)
	if ( IsAltKeyDown() ) then
		local itemLink = GetMerchantItemLink(self:GetID())
		if not itemLink then return end
		local maxStack = select(8, GetItemInfo(itemLink))
		if ( maxStack and maxStack > 1 ) then
			BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
		end
	end
	savedMerchantItemButton_OnModifiedClick(self, ...)
end;
--[[ 
########################################################## 
CONDITIONAL CHAT BUBBLES
##########################################################
]]--
local function LoadMiscEnhancements()
	local TaintFix = CreateFrame("Frame")
	TaintFix:SetScript("OnUpdate", function(self, elapsed)
		if LFRBrowseFrame.timeToClear then
			LFRBrowseFrame.timeToClear = nil
		end
	end)
	
	if(SuperVillain.db.system.bubbles == true) then
		local ChatBubbleHandler = CreateFrame("Frame", nil, UIParent)
		local total = 0
		local numKids = 0
		local function styleBubble(frame)
			local needsUpdate = true;
			for i = 1, frame:GetNumRegions() do
				local region = select(i, frame:GetRegions())
				if region:GetObjectType() == "Texture" then
					if(region:GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]) then 
						region:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Chat\CHATBUBBLE-BG]])
						needsUpdate = false 
					elseif(region:GetTexture()==[[Interface\Tooltips\ChatBubble-Backdrop]]) then
						region:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Chat\CHATBUBBLE-BACKDROP]])
						needsUpdate = false 
					elseif(region:GetTexture()==[[Interface\Tooltips\ChatBubble-Tail]]) then
						region:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Chat\CHATBUBBLE-TAIL]])
						needsUpdate = false 
					else 
						region:SetTexture(nil)
					end
				elseif(region:GetObjectType() == "FontString" and not frame.text) then
					frame.text = region 
				end
			end
			if needsUpdate then 
				frame:SetBackdrop({
					bgFile = [[Interface\BUTTONS\WHITE8X8]],
					tile = false,
					tileSize = 0,
				});
				frame:SetClampedToScreen(false)
				frame:SetFrameStrata("BACKGROUND")
			end
			if(frame.text) then
				frame.text:SetFont(SuperVillain.Media.font.dialog, 10, "NONE")
				frame.text:SetShadowColor(0,0,0,1)
				frame.text:SetShadowOffset(1,-1)
			end
		end

		ChatBubbleHandler:SetScript("OnUpdate", function(self, elapsed)
			total = total + elapsed
			if total > 0.1 then
				total = 0
				local newNumKids = WorldFrame:GetNumChildren()
				if newNumKids ~= numKids then
					for i = numKids + 1, newNumKids do
						local frame = select(i, WorldFrame:GetChildren())
						local b = frame:GetBackdrop()
						if b and b.bgFile == [[Interface\Tooltips\ChatBubble-Background]] then
							styleBubble(frame)
						end
					end
					numKids = newNumKids
				end
			end
		end)
	end
end

SuperVillain.Registry:NewScript(LoadMiscEnhancements);