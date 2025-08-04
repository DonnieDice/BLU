--=====================================================================================
-- BLU Module Loader System
-- Handles dynamic loading and unloading of modules based on user settings
--=====================================================================================

local addonName, addonTable = ...
BLU = BLU or {}
BLU.Modules = BLU.Modules or {}
BLU.LoadedModules = {}

-- Module loader registration
local Loader = {}
BLU.Modules["loader"] = Loader

-- Initialize
function Loader:Init()
    -- Module loading functions are attached to BLU directly
    BLU:PrintDebug("Loader module initialized")
end

-- Module registry
local moduleRegistry = {
    -- Core modules (always loaded)
    core = {
        "core",
        "config",
        "utils",
        "localization",
        "registry",
        "events"
    },
    
    -- Feature modules (loaded on demand)
    features = {
        levelUp = "LevelUp",
        achievement = "Achievement",
        reputation = "Reputation",
        quest = "Quest",
        battlePet = "BattlePet",
        delveCompanion = "DelveCompanion",
        honorRank = "HonorRank",
        renownRank = "RenownRank",
        tradingPost = "TradingPost"
    },
    
    -- Sound modules (loaded per game selection)
    sounds = {
        wowdefault = "WoWDefault",
        finalfantasy = "FinalFantasy",
        zelda = "Zelda",
        pokemon = "Pokemon",
        mario = "Mario",
        -- Other sound packs will be added as they're created
    }
}

-- Module loader function
function BLU:LoadModule(moduleType, moduleName)
    -- All modules must be pre-loaded via XML files in WoW
    -- This function now just enables/initializes already loaded modules
    
    local moduleKey = moduleRegistry[moduleType] and moduleRegistry[moduleType][moduleName]
    if not moduleKey then
        moduleKey = moduleName -- For core modules
    end
    
    -- Check if module exists in BLU.Modules (pre-loaded via XML)
    local module = self.Modules[moduleKey]
    
    if not module then
        self:PrintDebug("Module not found: " .. tostring(moduleName) .. " (key: " .. tostring(moduleKey) .. ")")
        return false
    end
    
    -- Check if already initialized
    if self.LoadedModules[moduleName] then
        self:PrintDebug("Module already loaded: " .. moduleName)
        return true
    end
    
    -- Mark as loaded
    self.LoadedModules[moduleName] = module
    
    -- Initialize module if it has an Init function
    if type(module.Init) == "function" then
        local success, err = pcall(module.Init, module)
        if success then
            self:PrintDebug("Successfully initialized module: " .. moduleName)
        else
            self:PrintDebug("Failed to initialize module: " .. moduleName .. " - " .. tostring(err))
            self.LoadedModules[moduleName] = nil
            return false
        end
    else
        self:PrintDebug("Module loaded (no Init): " .. moduleName)
    end
    
    return true
end

-- Module unloader function
function BLU:UnloadModule(moduleName)
    if not self.LoadedModules[moduleName] then
        return
    end
    
    local module = self.LoadedModules[moduleName]
    
    -- Call cleanup if available
    if module and type(module.Cleanup) == "function" then
        module:Cleanup()
    end
    
    -- Unregister events if available
    if module and type(module.UnregisterEvents) == "function" then
        module:UnregisterEvents()
    end
    
    self.LoadedModules[moduleName] = nil
    self:PrintDebug("Unloaded module: " .. moduleName)
end

-- Load modules based on saved settings
function BLU:LoadModulesFromSettings()
    local db = self.db.profile
    
    -- Load all feature modules if addon is enabled
    if db.enabled then
        self:LoadModule("features", "levelUp")
        self:LoadModule("features", "achievement")
        self:LoadModule("features", "reputation")
        self:LoadModule("features", "quest")
        self:LoadModule("features", "battlePet")
        self:LoadModule("features", "delveCompanion")
        self:LoadModule("features", "honorRank")
        self:LoadModule("features", "renownRank")
        self:LoadModule("features", "tradingPost")
    end
    
    -- Load sound modules for selected games
    local soundsToLoad = {}
    
    -- Collect all unique sound modules needed from selectedSounds
    if db.selectedSounds then
        for category, game in pairs(db.selectedSounds) do
            if game and game ~= "default" and game ~= "None" then
                soundsToLoad[game:lower()] = true
            end
        end
    end
    
    -- Always load WoW default sounds as fallback
    soundsToLoad["wowdefault"] = true
    
    -- Load Final Fantasy if we have the files
    -- soundsToLoad["finalfantasy"] = true
    
    -- Load required sound modules
    for soundModule in pairs(soundsToLoad) do
        self:LoadModule("sounds", soundModule)
    end
    
    -- Initialize sound browser
    if BLU.SoundBrowser and BLU.SoundBrowser.Init then
        BLU.SoundBrowser:Init()
    end
end

-- Update module loading when settings change
function BLU:UpdateModuleLoading(feature, enabled)
    if enabled then
        self:LoadModule("features", feature)
    else
        self:UnloadModule(feature)
    end
end

-- Debug print function
function BLU:PrintDebug(message)
    if self.debugMode then
        print("|cff05dffaBLU Debug:|r " .. message)
    end
end