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
local unpack 	 =  _G.unpack;
local pairs 	 =  _G.pairs;
local tinsert 	 =  _G.tinsert;
local table 	 =  _G.table;
--[[ TABLE METHODS ]]--
local tsort = table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose('SVBag')
SuperVillain.Options.args.SVBag={
	type='group',
	name=L['Bags'],
	childGroups="tab",
	get=function(a)return SuperVillain.db.SVBag[a[#a]]end,
	set=function(a,b)MOD:ChangeDBVar(b,a[#a]) end,
	args={
		intro = {
			order = 1, 
			type = "description", 
			name = L["BAGS_DESC"]
		},
		enable = {
			order = 2, 
			type = "toggle", 
			name = L["Enable"], 
			desc = L["Enable/Disable the all-in-one bag."],
			get = function(a)return SuperVillain.db.SVBag.enable end,
			set = function(a,b)SuperVillain.db.SVBag.enable = b;SuperVillain:StaticPopup_Show("RL_CLIENT")end
		},
		bagGroups={
			order=3,
			type='group',
			name=L['Bag Options'],
			childGroups="tree",
			args={
				common={
					order = 4, 
						type = "group", 
						name = L["General"], 
						disabled = function()return not SuperVillain.db.SVBag.enable end, 
						args = {
						bagSize = {
							order = 1, 
							type = "range", 
							name = L["Button Size (Bag)"], 
							desc = L["The size of the individual buttons on the bag frame."], 
							min = 15, 
							max = 45, 
							step = 1, 
							set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:Layout()end
						},
						bankSize = {
							order = 2, 
							type = "range", 
							name = L["Button Size (Bank)"], 
							desc = L["The size of the individual buttons on the bank frame."], 
							min = 15, 
							max = 45, 
							step = 1, 
							set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:Layout(true)end
						},
						sortInverted = {
							order = 3, 
							type = "toggle", 
							name = L["Sort Inverted"], 
							desc = L["Direction the bag sorting will use to allocate the items."]
						},
						alignToChat = {
							order = 4, 
							type = "toggle", 
							name = L["Align To Chat"], 
							desc = L["Align the width of the bag frame to fit inside the chat box."], 
							set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:Layout()MOD:Layout(true)end
						},
						bagWidth = {
							order = 5, 
							type = "range", 
							name = L["Panel Width (Bags)"], 
							desc = L["Adjust the width of the bag frame."], 
							min = 150, 
							max = 700, 
							step = 1, 
							set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:Layout()end, 
							disabled = function()return SuperVillain.db.SVBag.alignToChat end
						},
						bankWidth = {
							order = 6, 
							type = "range", 
							name = L["Panel Width (Bank)"], 
							desc = L["Adjust the width of the bank frame."], 
							min = 150, 
							max = 700, 
							step = 1, 
							set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:Layout(true)end, 
							disabled = function()return SuperVillain.db.SVBag.alignToChat end
						},
						xOffset = {
							order = 7, 
							type = "range", 
							name = L["X Offset"], 
							min = -5, 
							max = 600, 
							step = 1, 
							set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:ModifyBags()end
						},
						yOffset = {
							order = 8, 
							type = "range", 
							name = L["Y Offset"], 
							min = 0, 
							max = 600, 
							step = 1, 
							set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:ModifyBags()end
						},
						currencyFormat = {
							order = 9, 
							type = "select", 
							name = L["Currency Format"], 
							desc = L["The display format of the currency icons that get displayed below the main bag. (You have to be watching a currency for this to display)"], 
							values = {
								["ICON"] = L["Icons Only"], 
								["ICON_TEXT"] = L["Icons and Text"]
							},
							set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:RefreshTKN()end
						},
						bagTools = {
							order = 10, 
							type = "toggle", 
							name = L["Profession Tools"], 
							desc = L["Enable/Disable Prospecting, Disenchanting and Milling buttons on the bag frame."], 
							set = function(a,b)MOD:ChangeDBVar(b,a[#a])SuperVillain:StaticPopup_Show("RL_CLIENT")end
						},
						ignoreItems = {
							order = 100, 
							name = L["Ignore Items"], 
							desc = L["List of items to ignore when sorting. If you wish to add multiple items you must seperate the word with a comma."], 
							type = "input", 
							width = "full", 
							multiline = true, 
							set = function(a,b)SuperVillain.db.SVBag[a[#a]] = b end
						}
					}
				},
				bagBar={
					order=5,
					type="group",
					name=L["Bag-Bar"],
					get=function(a)return SuperVillain.db.SVBag.bagBar[a[#a]]end,
					set=function(a,b)SuperVillain.db.SVBag.bagBar[a[#a]]=b;MOD:ModifyBagBar()end,
					args={
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Enable/Disable the Bag-Bar."],
							get = function(a)return SuperVillain.db.SVBag.bagBar end,
							set = function(a,b)SuperVillain.db.SVBag.bagBar = b;SuperVillain:StaticPopup_Show("RL_CLIENT")end
						},
						mouseover = {
							order = 2, 
							name = L["Mouse Over"], 
							desc = L["Hidden unless you mouse over the frame."], 
							type = "toggle"
						},
						size = {
							order = 3, 
							type = "range", 
							name = L["Button Size"], 
							desc = L["Set the size of your bag buttons."], 
							min = 24, 
							max = 60, 
							step = 1
						},
						spacing = {
							order = 4, 
							type = "range", 
							name = L["Button Spacing"], 
							desc = L["The spacing between buttons."], 
							min = 1, 
							max = 10, 
							step = 1
						},
						sortDirection = {
							order = 5, 
							type = "select", 
							name = L["Sort Direction"], 
							desc = L["The direction that the bag frames will grow from the anchor."], 
							values = {
								["ASCENDING"] = L["Ascending"], 
								["DESCENDING"] = L["Descending"]
							}
						},
						showBy = {
							order = 6, 
							type = "select", 
							name = L["Bar Direction"], 
							desc = L["The direction that the bag frames be (Horizontal or Vertical)."], 
							values = {
								["VERTICAL"] = L["Vertical"], 
								["HORIZONTAL"] = L["Horizontal"]
							}
						}
					}
				}
			}
		}
	}
}