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
local function BarStyleHelper(bar)
	bar:Formula409()
	bar:SetStatusBarTexture(SuperVillain.Media.bar.default)
	bar:SetStatusBarColor(4/255, 179/255, 30/255)
	bar:SetPanelTemplate("Default")
	if _G[bar:GetName().."Title"]then 
		_G[bar:GetName().."Title"]:SetPoint("LEFT", 4, 0)
	end;
	if _G[bar:GetName().."Label"]then 
		_G[bar:GetName().."Label"]:SetPoint("LEFT", 4, 0)
	end;
	if _G[bar:GetName().."Text"]then 
		_G[bar:GetName().."Text"]:SetPoint("RIGHT", -4, 0)
	end 
end;
--[[ 
########################################################## 
ACHIEVEMENTFRAME STYLER
##########################################################
]]--
local function AchievementStyle()
	if SuperVillain.db.SVStyle.blizzard.enable  ~= true or SuperVillain.db.SVStyle.blizzard.achievement  ~= true then 
		return 
	end;
	local b = {"AchievementFrame", "AchievementFrameCategories", "AchievementFrameSummary", "AchievementFrameHeader", "AchievementFrameSummaryCategoriesHeader", "AchievementFrameSummaryAchievementsHeader", "AchievementFrameStatsBG", "AchievementFrameAchievements", "AchievementFrameComparison", "AchievementFrameComparisonHeader", "AchievementFrameComparisonSummaryPlayer", "AchievementFrameComparisonSummaryFriend"}
	for c, d in pairs(b)do 
		_G[d]:Formula409(true)
	end;
	local e = {"AchievementFrameStats", "AchievementFrameSummary", "AchievementFrameAchievements", "AchievementFrameComparison"}
	for c, d in pairs(e)do 
		for f = 1, _G[d]:GetNumChildren()do 
			local g = select(f, _G[d]:GetChildren())
			if g and not g:GetName()then 
				g:SetBackdrop(nil)
			end 
		end 
	end;

	AchievementFrame:SetPanelTemplate("Halftone",false,2,2,4)
	AchievementFrameHeaderTitle:ClearAllPoints()
	AchievementFrameHeaderTitle:Point("TOPLEFT", AchievementFrame.Panel, "TOPLEFT", -30, -8)
	AchievementFrameHeaderPoints:ClearAllPoints()
	AchievementFrameHeaderPoints:Point("LEFT", AchievementFrameHeaderTitle, "RIGHT", 2, 0)
	AchievementFrameCategoriesContainer:SetPanelTemplate("Inset", true, 2, -2, 2)
	AchievementFrameAchievementsContainer:SetPanelTemplate("Default")
	AchievementFrameAchievementsContainer.Panel:Point("TOPLEFT", 0, 2)
	AchievementFrameAchievementsContainer.Panel:Point("BOTTOMRIGHT", -3, -3)
	MOD:ApplyCloseButtonStyle(AchievementFrameCloseButton, AchievementFrame.Panel)
	MOD:ApplyDropdownStyle(AchievementFrameFilterDropDown)
	AchievementFrameFilterDropDown:Point("TOPRIGHT", AchievementFrame, "TOPRIGHT", -44, 5)
	MOD:ApplyScrollStyle(AchievementFrameCategoriesContainerScrollBar, 5)
	MOD:ApplyScrollStyle(AchievementFrameAchievementsContainerScrollBar, 5)
	MOD:ApplyScrollStyle(AchievementFrameStatsContainerScrollBar, 5)
	MOD:ApplyScrollStyle(AchievementFrameComparisonContainerScrollBar, 5)
	MOD:ApplyScrollStyle(AchievementFrameComparisonStatsContainerScrollBar, 5)
	for f = 1, 3 do 
		MOD:ApplyTabStyle(_G["AchievementFrameTab"..f])
		_G["AchievementFrameTab"..f]:SetFrameLevel(_G["AchievementFrameTab"..f]:GetFrameLevel()+2)
	end;
	BarStyleHelper(AchievementFrameSummaryCategoriesStatusBar)
	BarStyleHelper(AchievementFrameComparisonSummaryPlayerStatusBar)
	BarStyleHelper(AchievementFrameComparisonSummaryFriendStatusBar)
	AchievementFrameComparisonSummaryFriendStatusBar.text:ClearAllPoints()
	AchievementFrameComparisonSummaryFriendStatusBar.text:SetPoint("CENTER")
	AchievementFrameComparisonHeader:Point("BOTTOMRIGHT", AchievementFrameComparison, "TOPRIGHT", 45, -20)
	for f = 1, 10 do 
		local d = _G["AchievementFrameSummaryCategoriesCategory"..f]
		local i = _G["AchievementFrameSummaryCategoriesCategory"..f.."Button"]
		local j = _G["AchievementFrameSummaryCategoriesCategory"..f.."ButtonHighlight"]
		BarStyleHelper(d)
		i:Formula409()
		j:Formula409()
		_G[j:GetName().."Middle"]:SetTexture(1, 1, 1, 0.3)
		_G[j:GetName().."Middle"]:SetAllPoints(d)
	end;
	AchievementFrame:HookScript("OnShow", function(k)
		if k.containerStyleed then 
			return 
		end;
		for f = 1, 20 do 
			local d = _G["AchievementFrameCategoriesContainerButton"..f]
			MOD:ApplyLinkButtonStyle(d)
		end;
		k.containerStyleed = true 
	end)
	hooksecurefunc("AchievementButton_DisplayAchievement", function(d)
		if d.accountWide and d.bg3 then 
			d.bg3:SetTexture(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
		elseif d.bg3 then 
			d.bg3:SetTexture(0,0,0,1)
		end 
	end)
	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
		for f = 1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do 
			local d = _G["AchievementFrameSummaryAchievement"..f]
			_G["AchievementFrameSummaryAchievement"..f.."Highlight"]:MUNG()
			_G["AchievementFrameSummaryAchievement"..f.."Description"]:SetTextColor(0.6, 0.6, 0.6)
			if not d.Panel then 
				d:Formula409()
				d:SetFixedPanelTemplate("Inset")
				_G["AchievementFrameSummaryAchievement"..f.."IconBling"]:MUNG()
				_G["AchievementFrameSummaryAchievement"..f.."IconOverlay"]:MUNG()
				_G["AchievementFrameSummaryAchievement"..f.."Icon"]:SetFixedPanelTemplate("Default")
				_G["AchievementFrameSummaryAchievement"..f.."Icon"]:Height(_G["AchievementFrameSummaryAchievement"..f.."Icon"]:GetHeight()-14)
				_G["AchievementFrameSummaryAchievement"..f.."Icon"]:Width(_G["AchievementFrameSummaryAchievement"..f.."Icon"]:GetWidth()-14)
				_G["AchievementFrameSummaryAchievement"..f.."Icon"]:ClearAllPoints()
				_G["AchievementFrameSummaryAchievement"..f.."Icon"]:Point("LEFT", 6, 0)
				_G["AchievementFrameSummaryAchievement"..f.."IconTexture"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				_G["AchievementFrameSummaryAchievement"..f.."IconTexture"]:FillInner()
			end;
			if d.accountWide then 
				d:SetBackdropBorderColor(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)else d:SetBackdropBorderColor(0,0,0,1)
			end 
		end 
	end)
	--AchievementFrameAchievementsContainerScrollChild:SetFixedPanelTemplate("Button")
	for f = 1, 7 do 
		local d = _G["AchievementFrameAchievementsContainerButton"..f]
		_G["AchievementFrameAchievementsContainerButton"..f.."Highlight"]:MUNG()
		d:Formula409(true)
		d.bg1 = d:CreateTexture(nil, "BACKGROUND", nil, 4)
		d.bg1:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		d.bg1:SetVertexColor(unpack(SuperVillain.Media.color.default))
		d.bg1:Point("TOPLEFT", 1, -1)
		d.bg1:Point("BOTTOMRIGHT", -1, 1)
		d.bg3 = d:CreateTexture(nil, "BACKGROUND", nil, 2)
		d.bg3:SetTexture(SuperVillain.Media.color.button)
		d.bg3:WrapOuter(1);
		_G["AchievementFrameAchievementsContainerButton"..f.."Description"]:SetTextColor(0.6, 0.6, 0.6)
		hooksecurefunc(_G["AchievementFrameAchievementsContainerButton"..f.."Description"], "SetTextColor", function(k, m, n, o)
			if m  ~= 0.6 or n  ~= 0.6 or o  ~= 0.6 then 
				k:SetTextColor(0.6, 0.6, 0.6)
			end 
		end)
		_G["AchievementFrameAchievementsContainerButton"..f.."HiddenDescription"]:SetTextColor(1, 1, 1)
		hooksecurefunc(_G["AchievementFrameAchievementsContainerButton"..f.."HiddenDescription"], "SetTextColor", function(k, m, n, o)
			if m  ~= 1 or n  ~= 1 or o  ~= 1 then 
				k:SetTextColor(1, 1, 1)
			end 
		end)
		_G["AchievementFrameAchievementsContainerButton"..f.."IconBling"]:MUNG()
		_G["AchievementFrameAchievementsContainerButton"..f.."IconOverlay"]:MUNG()
		_G["AchievementFrameAchievementsContainerButton"..f.."IconTexture"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		_G["AchievementFrameAchievementsContainerButton"..f.."IconTexture"]:FillInner()

		_G["AchievementFrameAchievementsContainerButton"..f.."Icon"]:SetFixedPanelTemplate("Default")
		_G["AchievementFrameAchievementsContainerButton"..f.."Icon"]:Height(_G["AchievementFrameAchievementsContainerButton"..f.."Icon"]:GetHeight()-14)
		_G["AchievementFrameAchievementsContainerButton"..f.."Icon"]:Width(_G["AchievementFrameAchievementsContainerButton"..f.."Icon"]:GetWidth()-14)
		_G["AchievementFrameAchievementsContainerButton"..f.."Icon"]:ClearAllPoints()
		_G["AchievementFrameAchievementsContainerButton"..f.."Icon"]:Point("LEFT", 6, 0)
		
		_G["AchievementFrameAchievementsContainerButton"..f.."Tracked"]:Formula409()
		_G["AchievementFrameAchievementsContainerButton"..f.."Tracked"]:SetCheckboxTemplate(true)
		_G["AchievementFrameAchievementsContainerButton"..f.."Tracked"]:ClearAllPoints()
		_G["AchievementFrameAchievementsContainerButton"..f.."Tracked"]:Point("BOTTOMLEFT", d, "BOTTOMLEFT", -1, -3)
		hooksecurefunc(_G["AchievementFrameAchievementsContainerButton"..f.."Tracked"], "SetPoint", function(k, p, q, r, s, t)
			if p  ~= "BOTTOMLEFT" or q  ~= d or r  ~= "BOTTOMLEFT" or s  ~= 5 or t  ~= 5 then 
				k:ClearAllPoints()
				k:Point("BOTTOMLEFT", d, "BOTTOMLEFT", 5, 5)
			end 
		end)
	end;
	local u = {"Player", "Friend"}
	for c, v in pairs(u)do for f = 1, 9 do local d = "AchievementFrameComparisonContainerButton"..f..v;_G[d]:Formula409()
		_G[d.."Background"]:MUNG()
		if _G[d.."Description"]then 
			_G[d.."Description"]:SetTextColor(0.6, 0.6, 0.6)
			hooksecurefunc(_G[d.."Description"], "SetTextColor", function(k, m, n, o)
				if m  ~= 0.6 or n  ~= 0.6 or o  ~= 0.6 then 
					k:SetTextColor(0.6, 0.6, 0.6)
				end 
			end)
		end;
		_G[d].bg1 = _G[d]:CreateTexture(nil, "BACKGROUND")
		_G[d].bg1:SetDrawLayer("BACKGROUND", 4)
		_G[d].bg1:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		_G[d].bg1:SetVertexColor(unpack(SuperVillain.Media.color.default))
		_G[d].bg1:Point("TOPLEFT", 4, -4)
		_G[d].bg1:Point("BOTTOMRIGHT", -4, 4)
		_G[d].bg2 = _G[d]:CreateTexture(nil, "BACKGROUND")
		_G[d].bg2:SetDrawLayer("BACKGROUND", 3)
		_G[d].bg2:SetTexture(0, 0, 0)
		_G[d].bg2:Point("TOPLEFT", 3, -3)
		_G[d].bg2:Point("BOTTOMRIGHT", -3, 3)
		_G[d].bg3 = _G[d]:CreateTexture(nil, "BACKGROUND")
		_G[d].bg3:SetDrawLayer("BACKGROUND", 2)
		_G[d].bg3:SetTexture(0,0,0,1)
		_G[d].bg3:Point("TOPLEFT", 2, -2)
		_G[d].bg3:Point("BOTTOMRIGHT", -2, 2)
		_G[d].bg4 = _G[d]:CreateTexture(nil, "BACKGROUND")
		_G[d].bg4:SetDrawLayer("BACKGROUND", 1)
		_G[d].bg4:SetTexture(0, 0, 0)
		_G[d].bg4:Point("TOPLEFT", 1, -1)
		_G[d].bg4:Point("BOTTOMRIGHT", -1, 1)
	if v == "Friend"then 
		_G[d.."Shield"]:Point("TOPRIGHT", _G["AchievementFrameComparisonContainerButton"..f.."Friend"], "TOPRIGHT", -20, -3)
	end;
	_G[d.."IconBling"]:MUNG()
		_G[d.."IconOverlay"]:MUNG()
		_G[d.."Icon"]:SetFixedPanelTemplate("Default")
		_G[d.."Icon"]:Height(_G[d.."Icon"]:GetHeight()-14)
		_G[d.."Icon"]:Width(_G[d.."Icon"]:GetWidth()-14)
		_G[d.."Icon"]:ClearAllPoints()
		_G[d.."Icon"]:Point("LEFT", 6, 0)
		_G[d.."IconTexture"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		_G[d.."IconTexture"]:FillInner()
	end 
	end;hooksecurefunc("AchievementFrameComparison_DisplayAchievement", function(i)
		local w = i.player;local x = i.friend;w.titleBar:MUNG()x.titleBar:MUNG()
	if not w.bg3 or not x.bg3 then 
		return 
	end;

	if w.accountWide then 
		w.bg3:SetTexture(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
	else 
		w.bg3:SetTexture(0,0,0,1)
	end;

	if x.accountWide then 
		x.bg3:SetTexture(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
	else 
		x.bg3:SetTexture(0,0,0,1)
	end 
	end)
	for f = 1, 20 do
		local d = _G["AchievementFrameStatsContainerButton"..f]
		_G["AchievementFrameStatsContainerButton"..f.."BG"]:SetTexture(1, 1, 1, 0.2)
		_G["AchievementFrameStatsContainerButton"..f.."HeaderLeft"]:MUNG()
		_G["AchievementFrameStatsContainerButton"..f.."HeaderRight"]:MUNG()
		_G["AchievementFrameStatsContainerButton"..f.."HeaderMiddle"]:MUNG()
		local d = "AchievementFrameComparisonStatsContainerButton"..f;
		_G[d]:Formula409()
		_G[d]:SetPanelTemplate("Default")
		_G[d.."BG"]:SetTexture(1, 1, 1, 0.2)
		_G[d.."HeaderLeft"]:MUNG()
		_G[d.."HeaderRight"]:MUNG()
		_G[d.."HeaderMiddle"]:MUNG()
	end;
	hooksecurefunc("AchievementButton_GetProgressBar", function(y)
		local d = _G["AchievementFrameProgressBar"..y]
		if d then 
			if not d.styled then 
				d:Formula409()
				d:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
				d:SetStatusBarColor(4/255, 179/255, 30/255)
				d:SetFrameLevel(d:GetFrameLevel()+3)
				d:Height(d:GetHeight()-2)
				d.bg1 = d:CreateTexture(nil, "BACKGROUND")
				d.bg1:SetDrawLayer("BACKGROUND", 4)
				d.bg1:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
				d.bg1:SetVertexColor(unpack(SuperVillain.Media.color.default))
				d.bg1:SetAllPoints()
				d.bg3 = d:CreateTexture(nil, "BACKGROUND")
				d.bg3:SetDrawLayer("BACKGROUND", 2)
				d.bg3:SetTexture(0,0,0,1)
				d.bg3:Point("TOPLEFT", -1, 1)
				d.bg3:Point("BOTTOMRIGHT", 1, -1);
				d.text:ClearAllPoints()
				d.text:SetPoint("CENTER", d, "CENTER", 0, -1)
				d.text:SetJustifyH("CENTER")
				if y>1 then 
					d:ClearAllPoints()
					d:Point("TOP", _G["AchievementFrameProgressBar"..y-1], "BOTTOM", 0, -5)
					hooksecurefunc(d, "SetPoint", function(k, p, q, r, s, t, z)
						if not z then 
							k:ClearAllPoints()k:SetPoint("TOP", _G["AchievementFrameProgressBar"..y-1], "BOTTOM", 0, -5, true)
						end 
					end)
				end;
				d.styled = true 
			end 
		end 
	end)
	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(A, B)
		local C = GetAchievementNumCriteria(B)
		local D, E = 0, 0;
		for f = 1, C do 
			local F, G, H, I, J, K, L, M, N = GetAchievementCriteriaInfo(B, f)
			if G == CRITERIA_TYPE_ACHIEVEMENT and M then 
				E = E+1;
				local O = AchievementButton_GetMeta(E)
				if A.completed and H then 
					O.label:SetShadowOffset(0, 0)
					O.label:SetTextColor(1, 1, 1, 1)
				elseif H then 
					O.label:SetShadowOffset(1, -1)
					O.label:SetTextColor(0, 1, 0, 1)
				else 
					O.label:SetShadowOffset(1, -1)
					O.label:SetTextColor(.6, .6, .6, 1)
				end 
			elseif G  ~= 1 then 
				D = D+1;
				local P = AchievementButton_GetCriteria(D)
				if A.completed and H then 
					P.name:SetTextColor(1, 1, 1, 1)
					P.name:SetShadowOffset(0, 0)
				elseif H then 
					P.name:SetTextColor(0, 1, 0, 1)
					P.name:SetShadowOffset(1, -1)
				else 
					P.name:SetTextColor(.6, .6, .6, 1)
					P.name:SetShadowOffset(1, -1)
				end 
			end 
		end 
	end)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_AchievementUI", AchievementStyle)