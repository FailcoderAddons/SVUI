--[[
  /$$$$$$                                      /$$          
 /$$__  $$                                    | $$          
| $$  \__/  /$$$$$$  /$$   /$$ /$$$$$$$   /$$$$$$$  /$$$$$$$
|  $$$$$$  /$$__  $$| $$  | $$| $$__  $$ /$$__  $$ /$$_____/
 \____  $$| $$  \ $$| $$  | $$| $$  \ $$| $$  | $$|  $$$$$$ 
 /$$  \ $$| $$  | $$| $$  | $$| $$  | $$| $$  | $$ \____  $$
|  $$$$$$/|  $$$$$$/|  $$$$$$/| $$  | $$|  $$$$$$$ /$$$$$$$/
 \______/  \______/  \______/ |__/  |__/ \_______/|_______/ 
--]]

--[[ LOCALIZED GLOBALS ]]--
--GLOBAL NAMESPACE
local _G = getfenv(0);
--LUA
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type          = _G.type;
local error         = _G.error;
local pcall         = _G.pcall;
local print         = _G.print;
local ipairs        = _G.ipairs;
local pairs         = _G.pairs;
local next          = _G.next;
local rawset        = _G.rawset;
local rawget        = _G.rawget;
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;
local getmetatable  = _G.getmetatable;
local setmetatable  = _G.setmetatable;
--STRING
local string        = _G.string;
local upper         = string.upper;
local format        = string.format;
local find          = string.find;
local match         = string.match;
local gsub          = string.gsub;
--MATH
local math          = _G.math;
local random        = math.random;
local floor         = math.floor
--TABLE
local table         = _G.table;
local tsort         = table.sort;
local tconcat       = table.concat;
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe         = _G.wipe;

--[[ LIB CONSTRUCT ]]--

local lib = LibSuperVillain:NewLibrary("Sounds")

if not lib then return end -- No upgrade needed

--[[ BUTTON SOUNDS ]]--

local BUTTON_FOLEY = {
    SOUNDS = {
        [[sound\item\weapons\gun\gunload01.ogg]],
        [[sound\item\weapons\gun\gunload02.ogg]],
        [[sound\interface\ui_blizzardstore_buynow.ogg]],
        [[sound\doodad\fx_electricitysparkmedium_02.ogg]],
        [[sound\doodad\g_levermetalcustom0.ogg]],
        [[sound\doodad\g_buttonbigredcustom0.ogg]],
        [[sound\doodad\fx_electrical_zaps01.ogg]],
        [[sound\doodad\fx_electrical_zaps02.ogg]],
        [[sound\doodad\fx_electrical_zaps03.ogg]],
        [[sound\doodad\fx_electrical_zaps04.ogg]],
        [[sound\doodad\fx_electrical_zaps05.ogg]],
    }
};

function BUTTON_FOLEY:Play()
    PlaySoundFile([[sound\interface\uchatscrollbutton.ogg]])
    local list = self.SOUNDS;
    local key = random(1,#list)
    local sound = list[key]
    PlaySoundFile(sound)
end

setmetatable(BUTTON_FOLEY, { __call = BUTTON_FOLEY.Play })

--[[ ERROR SOUNDS ]]--

local ERROR_FOLEY = {
    SOUNDS = {
        [[sound\spells\uni_fx_radiostatic_01.ogg]],
        [[sound\spells\uni_fx_radiostatic_02.ogg]],
        [[sound\spells\uni_fx_radiostatic_03.ogg]],
        [[sound\spells\uni_fx_radiostatic_04.ogg]],
        [[sound\spells\uni_fx_radiostatic_05.ogg]],
        [[sound\spells\uni_fx_radiostatic_06.ogg]],
        [[sound\spells\uni_fx_radiostatic_07.ogg]],
        [[sound\spells\uni_fx_radiostatic_08.ogg]],
        [[sound\doodad\goblin_christmaslight_green_01.ogg]],
        [[sound\doodad\goblin_christmaslight_green_02.ogg]],
        [[sound\doodad\goblin_christmaslight_green_03.ogg]]
    }
};

function ERROR_FOLEY:Play()
    local list = self.SOUNDS;
    local key = random(1,#list)
    local sound = list[key]
    PlaySoundFile(sound)
end

setmetatable(ERROR_FOLEY, { __call = ERROR_FOLEY.Play })

function lib:Foley(category)
    if(category == "Button") then
        return BUTTON_FOLEY
    elseif(category == "Error") then
        return ERROR_FOLEY
    end
end;