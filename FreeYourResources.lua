local _G = _G

local FreeYourResources = LibStub("AceAddon-3.0"):NewAddon("FreeYourResources", "AceHook-3.0")
_G.FreeYourResources = FreeYourResources

-- Local variables holding the Blizzard resource frames.
-- We'll be creating containers for these.
local EclipseBarFrame = _G.EclipseBarFrame --140x38
local PaladinPowerBar = _G.PaladinPowerBar --136x39
local RuneFrame = _G.RuneFrame -- 130x18
local ShardBarFrame = _G.ShardBarFrame -- 110x25
local MultiCastActionBarFrame = _G.MultiCastActionBarFrame
local TotemFrame = _G.TotemFrame -- 128x53
local PlayerPowerBarAlt = _G.PlayerPowerBarAlt -- variable geometry, so I'm not making a container frame.
                                               -- Might not be able to scale the thing easily though.

local __junk, plclass = UnitClass("player")

local MyConsole = LibStub("AceConsole-3.0")
--MyConsole:Print(plclass)

local FYRScripts = {}
local FYRUtils = {}
local FYRJunk = {}

local getOpt, setOpt, setScale
local isNotDruid, isNotPally, isNotWarlock, isNotDK, isNotShaman

local frames = {}

do
   function getOpt(info)
      local key = info[#info]
      return FreeYourResources.db.profile[key]
   end

   function setOpt(info, value)
      local key = info[#info]
      local ppb = FreeYourResources.ppb
      local runes = FreeYourResources.runeFrame
      local tottex = FreeYourResources.totemTexture
      local totbar = FreeYourResources.totemFrame
      local tottim = FreeYourResources.totemTimerFrame
      local tottimtex = FreeYourResources.totemTimerTexture
      --local runesfr = FreeYourResources.runeFrame
      local kiddos = {RuneFrame:GetChildren()}
      local totkids = {TotemFrame:GetChildren()}
      --local mykids = {FreeYourResources.totemFrame:GetChildren()}
      if key == "lockMovement" and value == true then
	 PlayerPowerBarAlt:EnableMouse(true)
	 ppb:EnableMouse(false)
	 EclipseBarFrame:EnableMouse(true)
	 runes:EnableMouse(false)
	 for i, kid in ipairs(kiddos) do
	    kid:EnableMouse(true)
	 end
	 tottim:EnableMouse(false)
	 for i, kid in ipairs(totkids) do
	    kid:EnableMouse(true)
	 end
--	 for i, kid in ipairs(mykids) do
--	    if FreeYourResources.kid.mouseWasEnabled then
--	       kid:EnableMouse(true)
--	       FreeYourResources.kid.mouseWasEnabled = nil
--	    end
--	 end
      
	 tottex:SetTexture(0, 0, 0, 0)
	 tottimtex:SetTexture(0, 0, 0, 0)
      elseif key == "lockMovement" and value == false then
	 PlayerPowerBarAlt:EnableMouse(false)
	 ppb:EnableMouse(true)
	 EclipseBarFrame:EnableMouse(false)
	 runes:EnableMouse(true)
	 for i, kid in ipairs(kiddos) do
	    kid:EnableMouse(false)
	 end
	 tottim:EnableMouse(true)
	 for i, kid in ipairs(totkids) do
	    kid:EnableMouse(false)
	 end
--	 for i, kid in ipairs(mykids) do
--	    if kid:IsMouseEnabled() then
--	       kid:EnableMouse(false)
--	       if not FreeYourResources.kid then
--		  FreeYourResources.kid = {}
--	       end
--	       FreeYourResources.kid.mouseWasEnabled = true
--	    end
--	 end
      
	 tottex:SetTexture(0, 0, 1, 0.5)
	 --tottimtex:SetTexture(0, 0, 1, 0.5)
	 tottimtex:SetTexture(0, 0, 0, 0)
      end
      if key == "showTotem" and value == true then
	 totbar:Show()
      elseif key == "showTotem" and value == false then
	 totbar:Hide()
      end
      if key == "showTotemTimers" and value == true then
	 tottim:Show()
      elseif key == "showTotemTimers" and value == false then
	 tottim:Hide()
      end

      if key == "hideTotemTimerText" and value == true then
	 for ndx = 1, 4 do
	    local fontstr = _G["TotemFrameTotem"..ndx.."Duration"]
	    --print("Hiding", fontstr)
	    --fontstr:Hide()
	    fontstr:ClearAllPoints()
	    -- Yeah, I know, this is really stupid.  Only way I can find to hide this text
	    --   is to simply set the anchor points in a nonsensical way.  :=(
	    fontstr:SetPoint("BOTTOM", _G["TotemFrameTotem"..ndx], "TOP", 0, -4)
	    fontstr:SetPoint("TOP", _G["TotemFrameTotem"..ndx], "BOTTOM", 0, 5)
	 end
      elseif key == "hideTotemTimerText" and value == false then
	 for ndx = 1, 4 do
	    local fontstr = _G["TotemFrameTotem"..ndx.."Duration"]
	    --print("Showing", fontstr)
	    --fontstr:Show()
	    if FreeYourResources.db.profile.invertTotemTimers then
	       fontstr:Show()
	       fontstr:ClearAllPoints()
	       fontstr:SetPoint("BOTTOM", _G["TotemFrameTotem"..ndx], "TOP", 0, -4)
	    else
	       fontstr:Show()
	       fontstr:ClearAllPoints()
	       fontstr:SetPoint("TOP", _G["TotemFrameTotem"..ndx], "BOTTOM", 0, 5)
	    end
	 end
      end
	 
      FreeYourResources.db.profile[key] = value
   end

   function setScale(info, value)
      local key = info[#info]
      FreeYourResources.db.profile[key] = value
      FreeYourResources:Refresh()
   end

   function isNotDruid()
      if plclass == "DRUID" then return nil end
      return true
   end

   function isNotPally()
      if plclass == "PALADIN" then return nil end
      return true
   end

   function isNotShaman()
      if plclass == "SHAMAN" then return nil end
      return true
   end
   
   function isNotWarlock()
      if plclass == "WARLOCK" then return nil end
      return true
   end

   function isNotDK()
      if plclass == "DEATHKNIGHT" then return nil end
      return true
   end

   function invertPallyFrame(info, value)
      local key = info[#info]
      FreeYourResources.db.profile[key] = value
      local frame = FreeYourResources.pallyPowerFrame
      if frame.isFlipped then
	 PaladinPowerBarBG:SetTexture("Interface\\PlayerFrame\\PaladinPowerTextures")
	 PaladinPowerBarBG:SetTexCoord(0.00390625, 0.53515625, 0.32812500, 0.63281250)
	 PaladinPowerBarGlowBGTexture:SetTexture("Interface\\PlayerFrame\\PaladinPowerTextures")
	 frame.isFlipped = nil
      else
	 PaladinPowerBarBG:SetTexture("Interface\\AddOns\\FreeYourResources\\Textures\\PaladinPowerTextures")
	 PaladinPowerBarGlowBGTexture:SetTexture("Interface\\AddOns\\FreeYourResources\\Textures\\PaladinPowerTextures")
	 PaladinPowerBarBG:SetTexCoord(0.00390625, 0.53515625, 0.32812500, 0.63281250)
	 frame.isFlipped = true
      end
   end

   function invertDruidFrame(info, value)
      local key = info[#info]
      FreeYourResources.db.profile[key] = value
      --FYRUtils:InvertTexture(EclipseBarFrameBar)
      for ndx, reg in ipairs(FreeYourResources.EclipseFrame.Regions) do
	 FYRUtils:InvertTexture(reg)
      end
   end

   function invertWarlockFrame(info, value)
      local key = info[#info]
      FreeYourResources.db.profile[key] = value
      for ndx, reg in ipairs(FreeYourResources.shardFrame.Regions) do
	 FYRUtils:InvertTexture(reg)
      end
   end

   function invertTotemFrame(info, value)
      local key = info[#info]
      FreeYourResources.db.profile[key] = value
      if value == true then
	 for ndx = 1, 4 do
	    local fontstr = _G["TotemFrameTotem"..ndx.."Duration"]
	    fontstr:ClearAllPoints()
	    fontstr:SetPoint("BOTTOM", _G["TotemFrameTotem"..ndx], "TOP", 0, -4)
	 end
      elseif value == false then
	 for ndx = 1, 4 do
	    local fontstr = _G["TotemFrameTotem"..ndx.."Duration"]
	    fontstr:ClearAllPoints()
	    fontstr:SetPoint("TOP", _G["TotemFrameTotem"..ndx], "BOTTOM", 0, 5)
	 end
      end
   end

end

FreeYourResources.options = {
   type = "group",
   args = {
      global = {
	 type = "group",
	 name = "Settings",
	 order = 1,
	 args = {
	    __header1 = {
	       type = "header",
	       name = "Global Options",
	       order = 1,
	    },
	    __header1_1 = {
	       type = "description",
	       name = "Unlocking the resource frames will also unlock the special raid power bar.",
	       order = 2,
	    },
	    __header1_2 = {
	       type = "description",
	       name = "These include the Atramides sound bar, the Peacebloom vs. Ghouls progress bar, etc.",
	       order = 3,
	    },
	    lockMovement = {
	       name = "Lock Frames",
	       type = "toggle",
	       desc = "Check this box to make resource frames immobile.",
	       set = setOpt,
	       get = getOpt,
	       order = 4,
	       --width = "half",
	       --disabled = func_,
	    },
	    --__header1_1 = {
	    --   type = "header",
	    --   name = "Raid mechanics",
	    --   order = 3,
	    --},
	    __header2 = {
	       type = "header",
	       name = "Resource Frame Options",
	       order = 12,
	    },
	    __header3 = {
	       type = "description",
	       name = "Note: Only the options for your class are available for configuration.",
	       order = 13,
	    },
	    __header4 = {
	       type = "description",
	       name = "        ",
	       order = 14,
	    },
	    ppbHeader = {
	       type = "description",
	       name = "Alternate Power Bar (Raid boss mechanics, etc.)",
	       order = 16,
	    },
	    ppbScale = {
	       name = "Scale",
	       type = "range",
	       desc = "Scale factor for alternate power frame",
	       min = 0.1, max = 2.0, step = 0.1,
	       get = getOpt,
	       set = setScale,
	       order = 17,
	       disabled = false,
	    },
	    pallyHeader = {
	       type = "description",
	       name = "Paladin Holy Power",
	       order = 20,
	    },
	    invertPally = {
	       name = "Invert",
	       type = "toggle",
	       desc = "Check to invert the Holy Power frame vertically",
	       --set = setOpt,
	       set = invertPallyFrame,
	       get = getOpt,
	       order = 21,
	       width = "half",
	       disabled = isNotPally,
	    },
	    PallyPowerScale = {
	       name = "Scale",
	       type = "range",
	       desc = "Scale factor for Holy Power frame",
	       min = 0.1, max = 2.0, step = 0.1,
	       get = getOpt,
	       set = setScale,
	       order = 22,
	       disabled = isNotPally,
	    },
	    shammyHeader = {
	       type = "description",
	       name = "Shaman Totem Bar",
	       order = 25,
	    },
	    showTotem = {
	       name = "Show",
	       type = "toggle",
	       desc = "Show totem bar",
	       get = getOpt,
	       set = setOpt,
	       order = 26,
	       width = "half",
	       disabled = isNotShaman,
	    },
	    TotemScale = {
	       name = "Scale",
	       type = "range",
	       desc = "Scale factor for totem bar",
	       min = 0.1, max = 2.0, step = 0.1,
	       get = getOpt,
	       set = setScale,
	       order = 27,
	       disabled = isNotShaman,
	    },
	    shammyHeader2 = {
	       type = "description",
	       name = "Shaman Totem Timers",
	       order = 28,
	    },
	    showTotemTimers = {
	       name = "Show",
	       type = "toggle",
	       desc = "Show totem timers",
	       get = getOpt,
	       set = setOpt,
	       order = 29,
	       width = "half",
	       disabled = isNotShaman,
	    },
	    invertTotemTimers = {
	       name = "Invert",
	       type = "toggle",
	       desc = "Invert totem timers",
	       get = getOpt,
	       set = invertTotemFrame,
	       order = 30,
	       width = "half",
	       disabled = isNotShaman,
	    },
	    hideTotemTimerText = {
	       name = "Hide durations",
	       type = "toggle",
	       desc = "Hide totem timer duration text",
	       get = getOpt,
	       set = setOpt,
	       order = 31,
	       disabled = isNotShaman,
	    },
	    TotemTimerScale = {
	       name = "Scale",
	       type = "range",
	       desc = "Scale factor for totem timers",
	       min = 0.1, max = 2.0, step = 0.1,
	       get = getOpt,
	       set = setScale,
	       order = 32,
	       disabled = isNotShaman,
	    },
	    druidHeader = {
	       type = "description",
	       name = "Druid Eclipse Bar",
	       order = 40,
	    },
	    invertDruid = {
	       name = "Invert",
	       type = "toggle",
	       desc = "Check to invert Eclipse frame visibility",
	       --set = setOpt,
	       set = invertDruidFrame,
	       get = getOpt,
	       order = 41,
	       width = "half",
	       disabled = isNotDruid,
	    },
	    EclipseScale = {
	       name = "Scale",
	       type = "range",
	       desc = "Scale factor for Eclipse frame",
	       min = 0.1, max = 2.0, step = 0.1,
	       get = getOpt,
	       set = setScale,
	       order = 42,
	       disabled = isNotDruid,
	    },
	    warlockHeader = {
	       type = "description",
	       name = "Warlock Shards",
	       order = 50,
	    },
	    invertWarlock = {
	       name = "Invert",
	       type = "toggle",
	       desc = "Check to invert shard frame visibility",
	       --set = setOpt,
	       set = invertWarlockFrame,
	       get = getOpt,
	       order = 51,
	       width = "half",
	       disabled = isNotWarlock,
	    },
	    ShardFrameScale = {
	       name = "Scale",
	       type = "range",
	       desc = "Scale factor for shard frame",
	       min = 0.1, max = 2.0, step = 0.1,
	       get = getOpt,
	       set = setScale,
	       order = 52,
	       disabled = isNotWarlock,
	    },
	    dkHeader = {
	       type = "description",
	       name = "Death Knight Runes",
	       order = 60,
	    },
	    RuneFrameScale = {
	       name = "Scale",
	       type = "range",
	       desc = "Scale factor for rune frame",
	       min = 0.1, max = 2.0, step = 0.1,
	       get = getOpt,
	       set = setScale,
	       order = 62,
	       disabled = isNotDK,
	    },
	 },
      },
   },
}

local defaults = {
   profile = {
      lockMovement = true,
      EclipseScale = 1,
      showTotem = true,
      TotemScale = 1,
      showTotemTimers = true,
      TotemTimerScale = 1,
      PallyPowerScale = 1,
      ShardFrameScale = 1,
      RuneFrameScale = 1,
      ppbScale = 1,
   },
}

function FreeYourResources:OnInitialize()
   self.db = LibStub("AceDB-3.0"):New("FreeYourResourcesDB", defaults, true)
   self.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
   self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
   self.db.RegisterCallback(self, "OnProfileReset", "Refresh")
   self.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
   self.options.args.profiles.order = 100
end

function FreeYourResources:Refresh()
   --Refresh stuff here
   for i, frame in ipairs(frames) do
      frame:SetScale(FreeYourResources.db.profile[frame.name.."Scale"])
   end
      
end

function FreeYourResources:OnEnable()
   LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("FreeYourResources",
							 self.options,
							 nil)

   local ACD = LibStub("AceConfigDialog-3.0")
   self.OptionsPanel = ACD:AddToBlizOptions(self.name, self.name, nil, "global")
   self.OptionsPanel.Profiles = ACD:AddToBlizOptions(self.name, "Profiles", 
						     self.name, "profiles")

   self:SecureHook("UnitFrame_SetUnit")
   self:SecureHook("UnitPowerBarAlt_OnEvent")
   --self:SecureHook("UnitPowerBarAlt_OnUpdate")
   --self:SecureHook("MultiCastActionBarFrame_OnUpdate")

   FreeYourResources:CreateFrames()
end

--function FreeYourResources:MultiCastActionBarFrame_OnUpdate()
--   return
--end

-- This overrides a Blizzard function that moves the rune frame around.
function FreeYourResources:UnitFrame_SetUnit(self, unit, healthbar, manabar)
   RuneFrame:ClearAllPoints()
   RuneFrame:SetScale(1)
   RuneFrame:SetAllPoints()
end

function FreeYourResources:UnitPowerBarAlt_OnEvent(self, event, ...)
   --print(event)
   if event == self.updateAllEvent or event == "UNIT_POWER_BAR_SHOW" then
      --print(event)
      PlayerPowerBarAlt:ClearAllPoints()
      --PlayerPowerBarAlt:SetPoint("CENTER", nil, "CENTER", 0, 0)
      --PlayerPowerBarAlt:SetAllPoints()
      PlayerPowerBarAlt:SetPoint("CENTER", FreeYourResources.ppb, "CENTER", 0, 0)
   elseif event == "UNIT_POWER_BAR_HIDE" then
      PlayerPowerBarAlt:ClearAllPoints()
   end
end

function FreeYourResources:CreateFrames()
   local db = FreeYourResources.db.profile

   -- Make the raid power bar (for Cho'gall, Peacebloom vs. Ghouls, etc.) movable
   --  Probably don't need to make a container, but whatever.
   local ppb = CreateFrame("Frame", "ppbFrameFYR", UIParent)
   FreeYourResources.ppb = ppb
   PlayerPowerBarAlt:SetParent(ppb)
   ppb:SetMovable(true)
   -- This would be seriously annoying, making you place this for each toon.  I hate that.
   --  So I'll just jump through lots of hoops to get stuff in the db.
   --PlayerPowerBarAlt:SetUserPlaced(true)
   if not db.lockMovement then
      PlayerPowerBarAlt:EnableMouse(false)
      ppb:EnableMouse(true)
   end
   ppb:RegisterForDrag("LeftButton")
   for key, val in pairs(FYRScripts) do
      ppb:SetScript(key, val)
   end
   for key, val in pairs(FYRJunk) do
      PlayerPowerBarAlt:SetScript(key, val)
   end
   if not PlayerPowerBarAlt.name then
      ppb.name = "ppb"
   end

   -- UIParent.lua takes care of making frames offset when new frames appear.
   --   We don't want that for the power bar frame, so override the defaults.
   UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"] = {baseY = true, yOffset = 40, bottomEither = actionBarOffset, vehicleMenuBar = vehicleMenuBarTop, pet = 1, reputation = 1, tutorialAlert = 1}
   UIPARENT_MANAGED_FRAME_POSITIONS["PlayerPowerBarAlt"] = nil

   local xpos, ypos = db[ppb.name.."Xpos"], db[ppb.name.."Ypos"]
   if xpos and ypos then
      ppb:SetPoint("CENTER", nil, "CENTER", xpos, ypos)
      --print("Setting point on power bar")
      PlayerPowerBarAlt:ClearAllPoints()
      PlayerPowerBarAlt:SetPoint("CENTER", ppb, "CENTER", 0, 0)
   else
      ppb:SetPoint("CENTER", nil, "CENTER", 0, -225)
      PlayerPowerBarAlt:ClearAllPoints()
      PlayerPowerBarAlt:SetPoint("CENTER", ppb, "CENTER", 0, 0)
   end

   -- Make eclipse frame container
   local eclipseFrame = CreateFrame("Frame", "EclipseFrameFYR", UIParent)
   FreeYourResources.EclipseFrame = eclipseFrame

   eclipseFrame.name = "Eclipse"
   eclipseFrame.class = "DRUID"
   eclipseFrame.unit = "player"
   eclipseFrame:SetMovable(true)
   eclipseFrame:EnableMouse(true)
   eclipseFrame:RegisterForDrag("LeftButton")
   eclipseFrame:SetSize(140, 38)
   EclipseBarFrame:SetParent(eclipseFrame)
   EclipseBarFrame:SetAllPoints()
   if not db.lockMovement then
      EclipseBarFrame:EnableMouse(false)
   end
   for key, val in pairs(FYRScripts) do
      eclipseFrame:SetScript(key, val)
   end
   xpos, ypos = db[eclipseFrame.name.."Xpos"], db[eclipseFrame.name.."Ypos"]
   if not xpos and not ypos then
      xpos = -200
      ypos = 30
   end
   eclipseFrame:SetPoint("CENTER", nil, "CENTER", xpos, ypos)
   if plclass ~= eclipseFrame.class then
      eclipseFrame:Hide()
   end
   eclipseFrame.Regions = {EclipseBarFrameBar,
			   --EclipseBarFrameSun, EclipseBarFrameMoon,
			   --EclipseBarFrameDarkSun, EclipseBarFrameDarkMoon,
			   EclipseBarFrameSunBar, EclipseBarFrameMoonBar,
			   EclipseBarFrameMarker, EclipseBarFrameGlow}
   -- Invert if inverted, all regions
   if db.invertDruid then
      for ndx, reg in ipairs(eclipseFrame.Regions) do
        FYRUtils:InvertTexture(reg)
      end
   end
   --local bar, sun, moon, dsun, dmoon, sbar, mbar, marker, glow = EclipseBarFrame:GetRegions()
   --eclipseFrame.Regions = {bar, sun, moon, dsun, dmoon, sbar, mbar, marker, glow}
   -- This only inverts the base texture, which is less than optimal
   --if db.invertDruid then
   --   FYRUtils:InvertTexture(EclipseBarFrameBar)
   --end

   -- Shaman totem bar frame
   local totemFrame = CreateFrame("Frame", "TotemBarFrameFYR", UIParent)
   FreeYourResources.totemFrame = totemFrame
   local totemTexture = totemFrame:CreateTexture("TotemBarTexFYR", "BACKGROUND")
   FreeYourResources.totemTexture = totemTexture
   totemTexture:SetAllPoints()

   totemFrame.name = "Totem"
   totemFrame.class = "SHAMAN"
   totemFrame.unit = "player"
   totemFrame:SetMovable(true)
   totemFrame:EnableMouse(true)
   totemFrame:RegisterForDrag("LeftButton")
   --totemFrame:SetSize(230, 38)
   totemFrame:SetSize(260, 38)
   MultiCastActionBarFrame:SetParent(totemFrame)

   local dummy = function() return end

   MultiCastSummonSpellButton:SetParent(totemFrame)
   MultiCastSummonSpellButton:ClearAllPoints()
   MultiCastSummonSpellButton:SetPoint("BOTTOMLEFT", totemFrame, "BOTTOMLEFT", 20, 3)
   for ndx = 1, 4 do
      _G["MultiCastSlotButton"..ndx]:SetParent(totemFrame)
   end
   MultiCastSlotButton1:ClearAllPoints()
   MultiCastSlotButton1:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", 8, 0)
   for ndx = 2, 4 do
      local buttn = _G["MultiCastSlotButton"..ndx]
      local buttn2 = _G["MultiCastSlotButton"..ndx-1]
      buttn:ClearAllPoints()
      buttn:SetPoint("LEFT", buttn2, "RIGHT", 8, 0)
      buttn.SetParent = dummy
      buttn.SetPoint = dummy
   end

   MultiCastRecallSpellButton:ClearAllPoints()
   MultiCastRecallSpellButton:SetPoint("LEFT", MultiCastSlotButton4, "RIGHT", 8, 0)
   MultiCastRecallSpellButton.SetParent = dummy
   MultiCastRecallSpellButton.SetPoint = dummy

   for ndx = 1, 12 do
      local buttn = _G["MultiCastActionButton"..ndx]
      local buttn2 = _G["MultiCastSlotButton"..(ndx % 4 == 0 and 4 or ndx % 4)]
      buttn:ClearAllPoints()
      buttn:SetPoint("CENTER", buttn2, "CENTER", 0, 0)
   end

   if not db.lockMovement then
      totemTexture:SetTexture(0, 0, 1, 0.5)
   else
      totemTexture:SetTexture(0, 0, 1, 0)
   end

   for key, val in pairs(FYRScripts) do
      totemFrame:SetScript(key, val)
   end
   xpos, ypos = db[totemFrame.name.."Xpos"], db[totemFrame.name.."Ypos"]
   if not xpos and not ypos then
      xpos = -200
      ypos = -30
   end
   totemFrame:SetPoint("CENTER", nil, "CENTER", xpos, ypos)
   if plclass ~= totemFrame.class then
      totemFrame:Hide()
   end
   if not db.showTotem then
      totemFrame:Hide()
   end

   -- Shaman totem timers
   local totemTimerFrame = CreateFrame("Frame", "TotemTimerFrameFYR", UIParent)
   FreeYourResources.totemTimerFrame = totemTimerFrame
   -- Create a texture for moving
   local totemTimerTexture = totemTimerFrame:CreateTexture("TotemTimerTexFYR", "BACKGROUND")
   FreeYourResources.totemTimerTexture = totemTimerTexture
   totemTimerTexture:SetAllPoints()
   
   totemTimerFrame.name = "TotemTimer"
   totemTimerFrame.class = "SHAMAN"
   totemTimerFrame.unit = "player"
   totemTimerFrame:SetMovable(true)
   totemTimerFrame:EnableMouse(true)
   totemTimerFrame:RegisterForDrag("LeftButton")
   totemTimerFrame:SetSize(128,53)
   TotemFrame:SetParent(totemTimerFrame)
   TotemFrame:SetAllPoints()
   TotemFrame:SetFrameStrata(totemTimerFrame:GetFrameStrata())
   TotemFrame:SetFrameLevel(totemTimerFrame:GetFrameLevel()+1)

   if not db.lockMovement then
      local kiddos = {TotemFrame:GetChildren()}
      for i, kid in ipairs(kiddos) do
	 kid:EnableMouse(false)
      end
      --totemTimerTexture:SetTexture(0, 0, 1, 0.5)
   else
      totemTimerTexture:SetTexture(0, 0, 0, 0)
   end

   if db.invertTotemTimers then
      for ndx = 1, 4 do
	 local fontstr = _G["TotemFrameTotem"..ndx.."Duration"]
	 fontstr:ClearAllPoints()
	 fontstr:SetPoint("BOTTOM", _G["TotemFrameTotem"..ndx], "TOP", 0, -4)
      end
   end
   if db.hideTotemTimerText then
      for ndx = 1, 4 do
	 local fontstr = _G["TotemFrameTotem"..ndx.."Duration"]
	 --print(fontstr)
	 --fontstr:Hide()
	 fontstr:ClearAllPoints()
	 -- It ain't pretty, but it works.
	 fontstr:SetPoint("BOTTOM", _G["TotemFrameTotem"..ndx], "TOP", 0, -4)
	 fontstr:SetPoint("TOP", _G["TotemFrameTotem"..ndx], "BOTTOM", 0, 5)
      end
   end

   for key, val in pairs(FYRScripts) do
      totemTimerFrame:SetScript(key, val)
   end
   xpos, ypos = db[totemTimerFrame.name.."Xpos"], db[totemTimerFrame.name.."Ypos"]
   if not xpos and not ypos then
      xpos = -200
      ypos = 80
   end
   totemTimerFrame:SetPoint("CENTER", nil, "CENTER", xpos, ypos)
   if plclass ~= totemTimerFrame.class then
      totemTimerFrame:Hide()
   end
   if not db.showTotemTimers then
      totemTimerFrame:Hide()
   end

   -- Pally Holy Power frame
   local pallyPowerFrame = CreateFrame("Frame", "PallyPowerFrameFYR", UIParent)
   FreeYourResources.pallyPowerFrame = pallyPowerFrame
   --pallyPowerFrame.bg = pallyPowerFrame:CreateTexture("FYRtest", "BACKGROUND")
   --pallyPowerFrame.bg:SetAllPoints()
   --pallyPowerFrame.bg:SetTexture(1, 1, 1, 0.5)

   pallyPowerFrame.name = "PallyPower"
   pallyPowerFrame.class = "PALADIN"
   pallyPowerFrame.unit = "player"
   pallyPowerFrame:SetMovable(true)
   pallyPowerFrame:EnableMouse(true)
   pallyPowerFrame:RegisterForDrag("LeftButton")
   pallyPowerFrame:SetSize(136, 39)
   pallyPowerFrame:SetFrameLevel(6)
   PaladinPowerBar:SetParent(pallyPowerFrame)
   PaladinPowerBar:SetAllPoints()
   if db.invertPally then
      PaladinPowerBarBG:SetTexture("Interface\\AddOns\\FreeYourResources\\Textures\\PaladinPowerTextures")
      PaladinPowerBarBG:SetTexCoord(0.00390625, 0.53515625, 0.32812500, 0.63281250)
      PaladinPowerBarGlowBGTexture:SetTexture("Interface\\AddOns\\FreeYourResources\\Textures\\PaladinPowerTextures")
      pallyPowerFrame.isFlipped = true
   end
   PaladinPowerBar:SetFrameStrata(pallyPowerFrame:GetFrameStrata())
   PaladinPowerBar:SetFrameLevel(pallyPowerFrame:GetFrameLevel()+1)

   for key, val in pairs(FYRScripts) do
      pallyPowerFrame:SetScript(key, val)
   end
   xpos, ypos = db[pallyPowerFrame.name.."Xpos"], db[pallyPowerFrame.name.."Ypos"]
   if not xpos and not ypos then
      xpos = -200
      ypos = 0
   end
   pallyPowerFrame:SetPoint("CENTER", nil, "CENTER", xpos, ypos)
   if plclass ~= pallyPowerFrame.class then
      pallyPowerFrame:Hide()
   end

   -- Warlock shard frame
   local shardFrame = CreateFrame("Frame", "ShardFrameFYR", UIParent)
   FreeYourResources.shardFrame = shardFrame

   shardFrame.name = "ShardFrame"
   shardFrame.class = "WARLOCK"
   shardFrame.unit = "player"
   shardFrame:SetMovable(true)
   shardFrame:EnableMouse(true)
   shardFrame:RegisterForDrag("LeftButton")
   --shardFrame:RegisterForClicks("AnyUp")
   shardFrame:SetSize(110, 25)
   ShardBarFrame:SetParent(shardFrame)
   ShardBarFrame:SetAllPoints()
   for key, val in pairs(FYRScripts) do
      shardFrame:SetScript(key, val)
   end
   xpos, ypos = db[shardFrame.name.."Xpos"], db[shardFrame.name.."Ypos"]
   if not xpos and not ypos then
      xpos = -200
      ypos = -30
   end
   shardFrame:SetPoint("CENTER", nil, "CENTER", xpos, ypos)
   if plclass ~= shardFrame.class then
      shardFrame:Hide()
   end

   local s1t1, s1t2, s1t3, s1t4, s1t5 = ShardBarFrameShard1:GetRegions()
   local s2t1, s2t2, s2t3, s2t4, s2t5 = ShardBarFrameShard2:GetRegions()
   local s3t1, s3t2, s3t3, s3t4, s3t5 = ShardBarFrameShard3:GetRegions()
   shardFrame.Regions = {s1t1, s1t2, s1t3, s1t4, s1t5, 
			 s2t1, s2t2, s2t3, s2t4, s2t5, 
			 s3t1, s3t2, s3t3, s3t4, s3t5}
   if db.invertWarlock then
      for ndx, reg in ipairs(shardFrame.Regions) do
	 FYRUtils:InvertTexture(reg)
      end
   end

   -- Death Knight rune frame
   local runeFrame = CreateFrame("Frame", "RuneFrameFYR", UIParent)
   FreeYourResources.runeFrame = runeFrame

   --runeFrame.bg = runeFrame:CreateTexture("FYRtest", "BACKGROUND")
   --runeFrame.bg:SetAllPoints()
   --if not db.lockMovement then
   --   runeFrame.bg:SetTexture(0, 0, 0, 0.6)
   --end

   runeFrame.name = "RuneFrame"
   runeFrame.class = "DEATHKNIGHT"
   runeFrame.unit = "player"
   runeFrame:SetMovable(true)
   runeFrame:EnableMouse(true)
   runeFrame:RegisterForDrag("LeftButton")
   runeFrame:SetSize(130, 18)
   RuneFrame:SetParent(runeFrame)
   RuneFrame:SetAllPoints()
   for key, val in pairs(FYRScripts) do
      runeFrame:SetScript(key, val)
   end
   xpos, ypos = db[runeFrame.name.."Xpos"], db[runeFrame.name.."Ypos"]
   if not xpos and not ypos then
      xpos = -200
      ypos = -50
   end
   runeFrame:SetPoint("CENTER", nil, "CENTER", xpos, ypos)
   if plclass ~= runeFrame.class then
      --print("hiding runes")
      runeFrame:Hide()
   end

   frames = {eclipseFrame, totemFrame, totemTimerFrame, pallyPowerFrame, shardFrame, runeFrame, ppb}

   for i, frame in ipairs(frames) do
      frame:SetScale(FreeYourResources.db.profile[frame.name.."Scale"])
   end
   if not db.lockMovement then
      local kiddos = {RuneFrame:GetChildren()}
      for i, kid in ipairs(kiddos) do
	 --print('found a kid')
	 kid:EnableMouse(false)
      end
   end
   
end

function FYRJunk:OnShow()
   --print("OnShow")
   local db = FreeYourResources.db.profile
   local ppb = FreeYourResources.ppb
   local xpos, ypos = db[ppb.name.."Xpos"], db[ppb.name.."Ypos"]
   local xsize, ysize = PlayerPowerBarAlt:GetSize()
   ppb:SetSize(xsize, ysize)
   ppb:SetPoint("CENTER", nil, "CENTER", xpos, ypos)
   if xpos and ypos then
      --print(xpos, ypos, xsize, ysize)
      PlayerPowerBarAlt:ClearAllPoints()
      PlayerPowerBarAlt:SetPoint("CENTER", ppb, "CENTER", 0, 0)
   end
end

function FYRJunk:OnHide()
   return nil
   --print("OnHide")
end

local frameInMovement = nil

-- Movement scripts
function FYRScripts:OnDragStart()
   --print('drag start')
   local db = FreeYourResources.db.profile
   if db.lockMovement or InCombatLockdown() then return end
   
   self:StartMoving()
   frameInMovement = self
end

function FYRScripts:OnDragStop()
   if frameInMovement ~= self then return end
   frameInMovement = nil
   self:StopMovingOrSizing()

   local name = self.name
   if not name then return end
   local uiScale = UIParent:GetEffectiveScale()
   local scale = self:GetEffectiveScale() / uiScale
   local x, y = self:GetCenter()
   x, y = x*scale, y*scale
   x = x - GetScreenWidth()/2
   y = y - GetScreenHeight()/2

   FreeYourResources.db.profile[name.."Xpos"] = x/self:GetScale()
   FreeYourResources.db.profile[name.."Ypos"] = y/self:GetScale()

   --print(x/self:GetScale(), y/self:GetScale())

   LibStub("AceConfigRegistry-3.0"):NotifyChange("FreeYourResources")
end

-- This inverts a texture vertically.
function FYRUtils:InvertTexture(texture)
   local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = texture:GetTexCoord()
   texture:SetTexCoord(LLx, LLy, ULx, ULy, LRx, LRy, URx, URy)
end


