local _G = _G

local FreeYourResources = LibStub("AceAddon-3.0"):NewAddon("FreeYourResources", "AceEvent-3.0")
_G.FreeYourResources = FreeYourResources

-- Local variables holding the Blizzard resource frames, we'll be creating containers for these
local EclipseBarFrame = _G.EclipseBarFrame --140x38
local PaladinPowerBar = _G.PaladinPowerBar --136x39
local RuneFrame = _G.RuneFrame -- 130x18
local ShardBarFrame = _G.ShardBarFrame -- 110x25

local __junk, plclass = UnitClass("player")

local MyConsole = LibStub("AceConsole-3.0")
--MyConsole:Print(plclass)

local FYRScripts = {}
local FYRUtils = {}

local getOpt, setOpt, setScale
local isNotDruid, isNotPally, isNotWarlock, isNotDK
local invertPallyFrame, invertWarlockFrame, invertDruidFrame

local frames = {}

do
   function getOpt(info)
      local key = info[#info]
      return FreeYourResources.db.profile[key]
   end

   function setOpt(info, value)
      local key = info[#info]
      if key == "lockMovement" and value == true then
	 EclipseBarFrame:EnableMouse(true)
	 --FreeYourResources.runeFrame.titleReg:Hide()
      elseif key == "lockMovement" and value == false then
	 EclipseBarFrame:EnableMouse(false)
	 --FreeYourResources.runeFrame.titleReg:Show()
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
      FYRUtils:InvertTexture(EclipseBarFrameBar)
   end

   function invertWarlockFrame(info, value)
      local key = info[#info]
      FreeYourResources.db.profile[key] = value
      for ndx, reg in ipairs(FreeYourResources.shardFrame.Regions) do
	 FYRUtils:InvertTexture(reg)
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
	       type = "description",
	       name = "Global Options",
	       order = 1,
	    },
	    lockMovement = {
	       name = "Lock Frames",
	       type = "toggle",
	       desc = "Check this box to make resource frames immobile.",
	       set = setOpt,
	       get = getOpt,
	       order = 11,
	       --width = "half",
	       --disabled = func_,
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
	    druidHeader = {
	       type = "description",
	       name = "Druid Eclipse Bar",
	       order = 30,
	    },
	    invertDruid = {
	       name = "Invert",
	       type = "toggle",
	       desc = "Check to invert Eclipse frame visibility",
	       --set = setOpt,
	       set = invertDruidFrame,
	       get = getOpt,
	       order = 31,
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
	       order = 32,
	       disabled = isNotDruid,
	    },
	    warlockHeader = {
	       type = "description",
	       name = "Warlock Shards",
	       order = 40,
	    },
	    invertWarlock = {
	       name = "Invert",
	       type = "toggle",
	       desc = "Check to invert shard frame visibility",
	       --set = setOpt,
	       set = invertWarlockFrame,
	       get = getOpt,
	       order = 41,
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
	       order = 42,
	       disabled = isNotWarlock,
	    },
	    dkHeader = {
	       type = "description",
	       name = "Death Knight Runes",
	       order = 50,
	    },
	    RuneFrameScale = {
	       name = "Scale",
	       type = "range",
	       desc = "Scale factor for rune frame",
	       min = 0.1, max = 2.0, step = 0.1,
	       get = getOpt,
	       set = setScale,
	       order = 52,
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
      PallyPowerScale = 1,
      ShardFrameScale = 1,
      RuneFrameScale = 1,
   },
}

--local frames = {}

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

   -- Register events

   -- No events needed for this addon!
   --FreeYourResources:RegisterEvent("UNIT_AURA")

   FreeYourResources:CreateFrames()

end

function FreeYourResources:CreateFrames()
   local db = FreeYourResources.db.profile

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
   if db.invertDruid then
      FYRUtils:InvertTexture(EclipseBarFrameBar)
   end
   if not db.lockMovement then
      EclipseBarFrame:EnableMouse(false)
   end
   for key, val in pairs(FYRScripts) do
      eclipseFrame:SetScript(key, val)
   end
   local xpos, ypos = db[eclipseFrame.name.."Xpos"], db[eclipseFrame.name.."Ypos"]
   if not xpos and not ypos then
      xpos = -200
      ypos = 30
   end
   eclipseFrame:SetPoint("CENTER", nil, "CENTER", xpos, ypos)
   if plclass ~= eclipseFrame.class then
      eclipseFrame:Hide()
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
   --runeFrame.bg:SetTexture(1, 1, 1, 0.5)

   runeFrame.name = "RuneFrame"
   runeFrame.class = "DEATHKNIGHT"
   runeFrame.unit = "player"
   runeFrame:SetMovable(true)
   runeFrame:EnableMouse(true)
   runeFrame:RegisterForDrag("LeftButton")
   runeFrame:SetSize(130, 18)
   RuneFrame:SetParent(runeFrame)
   --RuneFrame:SetAllPoints()
   RuneFrame:SetPoint("TOP", runeFrame, "BOTTOM", 0, 0)
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
      print("hiding runes")
      runeFrame:Hide()
   end

   frames = {eclipseFrame, pallyPowerFrame, shardFrame, runeFrame}

   for i, frame in ipairs(frames) do
      --print(frame.name.."Scale")
      frame:SetScale(FreeYourResources.db.profile[frame.name.."Scale"])
   end
   
end

local frameInMovement = nil

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
   local uiScale = UIParent:GetEffectiveScale()
   local scale = self:GetEffectiveScale() / uiScale
   local x, y = self:GetCenter()
   x, y = x*scale, y*scale
   x = x - GetScreenWidth()/2
   y = y - GetScreenHeight()/2

   FreeYourResources.db.profile[name.."Xpos"] = x/self:GetScale()
   FreeYourResources.db.profile[name.."Ypos"] = y/self:GetScale()

   LibStub("AceConfigRegistry-3.0"):NotifyChange("FreeYourResources")
end

function FYRUtils:InvertTexture(texture)
   local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = texture:GetTexCoord()
   texture:SetTexCoord(LLx, LLy, ULx, ULy, LRx, LRy, URx, URy)
end


