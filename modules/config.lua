--=====================================================================================
-- BLU Config Module
-- Handles configuration and settings management
--=====================================================================================

local addonName, addonTable = ...
local Config = {}
BLU.Modules["config"] = Config

-- Default configuration
Config.defaults = {
    profile = {
        -- General settings
        showWelcomeMessage = true,
        masterVolume = 0.5,
        debugMode = false,
        
        -- Feature toggles
        enableLevelUp = true,
        enableAchievement = true,
        enableReputation = true,
        enableQuest = true,
        enableBattlePet = true,
        enableDelveCompanion = true,
        enableHonorRank = true,
        enableRenownRank = true,
        enableTradingPost = true,
        
        -- Sound selections (will be populated dynamically)
        levelUpSound = "None",
        achievementSound = "None",
        reputationSound = "None",
        questAcceptSound = "None",
        questTurnInSound = "None",
        battlePetSound = "None",
        delveCompanionSound = "None",
        honorRankSound = "None",
        renownRankSound = "None",
        tradingPostSound = "None",
        
        -- Volume settings
        levelUpVolume = 1.0,
        achievementVolume = 1.0,
        reputationVolume = 1.0,
        questVolume = 1.0,
        battlePetVolume = 1.0,
        delveCompanionVolume = 1.0,
        honorRankVolume = 1.0,
        renownRankVolume = 1.0,
        tradingPostVolume = 1.0,
        
        -- Advanced settings
        soundChannel = "Master",
        interruptMusic = false,
        queueSounds = true,
        maxQueueSize = 3
    }
}

-- Initialize config module
function Config:Init()
    -- Set up saved variables
    self:InitializeDatabase()
    
    -- Apply settings
    self:ApplySettings()
    
    BLU:PrintDebug("Config module initialized")
end

-- Initialize database
function Config:InitializeDatabase()
    -- Use the custom database system instead of AceDB
    if BLU.Database then
        BLU.db = BLU.Database:New("BLUDB", self.defaults)
    else
        -- Fallback to simple saved variables
        BLUDB = BLUDB or {}
        BLU.db = {
            profile = BLUDB.profile or CopyTable(self.defaults.profile)
        }
        BLUDB.profile = BLU.db.profile
    end
end

-- Profile changed handler
function Config:OnProfileChanged()
    BLU:ReloadAllModules()
    self:ApplySettings()
end

-- Apply current settings
function Config:ApplySettings()
    -- Update debug mode
    BLU.debugMode = BLU.db.profile.debugMode
    
    -- Update welcome message setting
    BLU.showWelcomeMessage = BLU.db.profile.showWelcomeMessage
end

-- Get setting value
function Config:Get(key)
    return BLU.db.profile[key]
end

-- Set setting value
function Config:Set(key, value)
    BLU.db.profile[key] = value
    
    -- Handle special cases
    if key == "debugMode" then
        BLU.debugMode = value
    elseif key:match("^enable") then
        -- Feature toggle changed, update module loading
        local feature = key:gsub("^enable", "")
        feature = feature:sub(1,1):lower() .. feature:sub(2)
        BLU:UpdateModuleLoading(feature, value)
    end
end

-- Get all available sounds for a category
function Config:GetAvailableSounds(category)
    local sounds = {
        {value = "None", text = "None"}
    }
    
    -- Add BLU sounds
    for soundId, soundData in pairs(BLU.soundRegistry or {}) do
        if not soundData.category or soundData.category == category or soundData.category == "all" then
            table.insert(sounds, {
                value = soundId,
                text = soundData.name
            })
        end
    end
    
    -- Sort by name
    table.sort(sounds, function(a, b)
        if a.value == "None" then return true end
        if b.value == "None" then return false end
        return a.text < b.text
    end)
    
    return sounds
end

-- Reset to defaults
function Config:ResetToDefaults()
    BLU.db:ResetProfile()
end

-- Export/Import functionality
function Config:ExportSettings()
    -- Simple export without compression for now
    local settings = BLU.db.profile
    -- Convert to string representation
    local str = "BLU_SETTINGS:"
    for k, v in pairs(settings) do
        if type(v) == "string" or type(v) == "number" or type(v) == "boolean" then
            str = str .. k .. "=" .. tostring(v) .. ";"
        end
    end
    return str
end

function Config:ImportSettings(importString)
    -- Simple import for now
    if not importString:match("^BLU_SETTINGS:") then
        return false, "Invalid import string"
    end
    
    -- Parse settings
    local settings = {}
    for k, v in importString:gmatch("(%w+)=([^;]+);") do
        if v == "true" then
            settings[k] = true
        elseif v == "false" then
            settings[k] = false
        elseif tonumber(v) then
            settings[k] = tonumber(v)
        else
            settings[k] = v
        end
    end
    
    -- Apply imported settings
    for key, value in pairs(settings) do
        BLU.db.profile[key] = value
    end
    
    self:ApplySettings()
    if BLU.ReloadAllModules then
        BLU:ReloadAllModules()
    end
    
    return true
end

-- Export module
return Config