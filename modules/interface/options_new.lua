--=====================================================================================
-- BLU - interface/options_new.lua
-- New options panel with SimpleQuestPlates-inspired design
--=====================================================================================

local addonName, BLU = ...

-- Ensure we have the global BLU if vararg fails
BLU = BLU or _G.BLU

-- Debug output
if BLU and BLU.PrintDebug then
    BLU:PrintDebug("[options_new] Loading options_new module")
else
    print("[BLU] ERROR: BLU not available when loading options_new.lua")
end

-- Create options module
local Options = {}
BLU.Modules = BLU.Modules or {}
BLU.Modules["options_new"] = Options

if BLU and BLU.PrintDebug then
    BLU:PrintDebug("[options_new] Module registered to BLU.Modules")
end

-- Panel dimensions
local PANEL_WIDTH = 700
local PANEL_HEIGHT = 600

-- Initialize options module
function Options:Init()
    BLU:PrintDebug("[Options] Initializing new options module")
    
    -- Make functions available globally
    BLU.CreateOptionsPanel = function()
        return self:CreateOptionsPanel()
    end
    
    BLU.OpenOptions = function()
        return self:OpenOptions()
    end
    
    -- Test SharedMedia availability
    BLU.TestSharedMedia = function()
        return self:TestSharedMedia()
    end
    
    BLU:PrintDebug("[Options] Functions registered")
    
    -- Create the panel if it doesn't exist yet
    if not BLU.OptionsPanel then
        BLU:PrintDebug("[Options] Creating panel in Init")
        self:CreateOptionsPanel()
    end
end

-- Early panel creation function called from ADDON_LOADED
function Options:CreatePanelEarly()
    if not BLU.OptionsPanel then
        BLU:PrintDebug("[Options] Creating panel early for immediate addon settings registration")
        self:CreateOptionsPanel()
        return true
    end
    return false
end

-- Test SharedMedia functionality
function Options:TestSharedMedia()
    BLU:Print("=== SharedMedia Debug Test ===")
    
    -- Test LibStub
    local hasLibStub = LibStub ~= nil
    BLU:Print(string.format("LibStub available: %s", tostring(hasLibStub)))
    
    if hasLibStub then
        local LSM = LibStub("LibSharedMedia-3.0", true)
        local hasLSM = LSM ~= nil
        BLU:Print(string.format("LibSharedMedia-3.0 available: %s", tostring(hasLSM)))
        
        if hasLSM then
            local soundList = LSM:List("sound")
            BLU:Print(string.format("LSM sound count: %d", soundList and #soundList or 0))
            
            if soundList and #soundList > 0 then
                BLU:Print("First 5 LSM sounds:")
                for i = 1, math.min(5, #soundList) do
                    BLU:Print(string.format("  %d. %s", i, soundList[i]))
                end
            end
        end
    end
    
    -- Test BLU SharedMedia module
    local hasBLUSharedMedia = BLU.Modules.sharedmedia ~= nil
    BLU:Print(string.format("BLU SharedMedia module exists: %s", tostring(hasBLUSharedMedia)))
    
    if hasBLUSharedMedia then
        local hasGetSoundCategories = BLU.Modules.sharedmedia.GetSoundCategories ~= nil
        BLU:Print(string.format("GetSoundCategories function exists: %s", tostring(hasGetSoundCategories)))
        
        if hasGetSoundCategories then
            local categories = BLU.Modules.sharedmedia:GetSoundCategories()
            local categoriesType = type(categories)
            BLU:Print(string.format("Categories type: %s", categoriesType))
            
            if categoriesType == "table" then
                local count = 0
                for category, sounds in pairs(categories) do
                    count = count + 1
                    BLU:Print(string.format("  Category '%s': %d sounds", category, sounds and #sounds or 0))
                end
                BLU:Print(string.format("Total categories: %d", count))
            end
        end
    end
    
    BLU:Print("=== End SharedMedia Test ===")
end

-- Create tab button with SimpleQuestPlates style
local function CreateTabButton(parent, text, index, row, col, panel)
    local button = CreateFrame("Button", "BLUTab" .. text:gsub(" ", ""), parent)
    button:SetSize(BLU.Design.Layout.TabWidth, BLU.Design.Layout.TabHeight)
    
    -- Position based on row and column with proper spacing from design constants
    local xOffset = 8 + (col - 1) * (BLU.Design.Layout.TabWidth + BLU.Design.Layout.TabSpacing)
    local yOffset = -5 - (row - 1) * BLU.Design.Layout.TabRowHeight
    button:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, yOffset)
    parent[index] = button
    
    -- Background
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.1, 0.1, 0.1, 0.8)
    button.bg = bg
    
    -- Border frame (Updated for Dragonflight)
    local border = CreateFrame("Frame", nil, button, "BackdropTemplate")
    border:SetAllPoints()
    border:SetBackdrop({
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    border:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
    button.border = border
    
    -- Text (no icons)
    local buttonText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    buttonText:SetPoint("CENTER", 0, 0)
    buttonText:SetText(text)
    button.text = buttonText
    
    -- Scripts
    button:SetScript("OnClick", function(self)
        panel:SelectTab(self.tabIndex)
    end)
    
    button:SetScript("OnEnter", function(self)
        if not self.isActive then
            self.border:SetBackdropBorderColor(unpack(BLU.Design.Colors.Primary))
            self.text:SetTextColor(unpack(BLU.Design.Colors.Primary))
        end
    end)
    
    button:SetScript("OnLeave", function(self)
        if not self.isActive then
            self.border:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
            self.text:SetTextColor(0.7, 0.7, 0.7, 1)
        end
    end)
    
    button.tabIndex = index
    
    function button:SetActive(active)
        self.isActive = active
        if active then
            self.bg:SetColorTexture(0.08, 0.08, 0.08, 1)
            self.text:SetTextColor(unpack(BLU.Design.Colors.Primary))
            self.border:SetBackdropBorderColor(unpack(BLU.Design.Colors.Primary))
        else
            self.bg:SetColorTexture(0.1, 0.1, 0.1, 0.8)
            self.text:SetTextColor(0.7, 0.7, 0.7, 1)
            self.border:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
        end
    end
    
    return button
end

-- Create dropdown helper
local function CreateDropdown(parent, label, width)
    local container = CreateFrame("Frame", nil, parent)
    container:SetHeight(45)
    
    local labelText = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    labelText:SetPoint("TOPLEFT", 0, 0)
    labelText:SetText(label)
    
    local dropdown = CreateFrame("Frame", nil, container, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", labelText, "BOTTOMLEFT", -20, -5)
    UIDropDownMenu_SetWidth(dropdown, width or 200)
    
    container.label = labelText
    container.dropdown = dropdown
    
    return container
end

-- Create main options panel
function Options:CreateOptionsPanel()
    BLU:PrintDebug("Creating new options panel...")
    
    -- Check if Design module is loaded
    if not BLU.Design then
        BLU:PrintError("[Options] BLU.Design not available! Cannot create panel.")
        return nil
    end
    
    -- Create main frame
    local panel = CreateFrame("Frame", "BLUOptionsPanel", UIParent)
    panel.name = "|cff05dffaB|retter |cff05dffaL|revel-|cff05dffaU|rp!"
    
    -- Custom icon for the settings menu
    panel.OnCommit = function() end
    panel.OnDefault = function() end
    panel.OnRefresh = function() end
    
    -- Store reference
    BLU.OptionsPanel = panel
    
    -- Main container with custom background (SQP style)
    local container = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    container:SetPoint("TOPLEFT", 10, -10)
    container:SetPoint("BOTTOMRIGHT", -10, 10)
    container:SetBackdrop(BLU.Design.Backdrops.Dark)
    container:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
    container:SetBackdropBorderColor(unpack(BLU.Design.Colors.Primary))
    
    -- Create header
    local header = CreateFrame("Frame", nil, container, "BackdropTemplate")
    header:SetHeight(70)  -- Reduced header height
    header:SetPoint("TOPLEFT", 10, -10)
    header:SetPoint("TOPRIGHT", -10, -10)
    header:SetBackdrop(BLU.Design.Backdrops.Dark)
    header:SetBackdropColor(0.08, 0.08, 0.08, 0.8)
    header:SetBackdropBorderColor(unpack(BLU.Design.Colors.Primary))
    
    -- Logo/Icon
    local logo = header:CreateTexture(nil, "ARTWORK")
    logo:SetSize(48, 48)
    logo:SetPoint("LEFT", 15, 0)
    -- Set icon with .tga extension
    logo:SetTexture("Interface\\AddOns\\BLU\\media\\images\\icon.tga")
    
    -- Title with proper BLU branding (B, L, U letters in color)
    local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    title:SetPoint("LEFT", logo, "RIGHT", 15, 10)
    title:SetText("|cff05dffaB|retter |cff05dffaL|revel-|cff05dffaU|rp!")
    local font, size = title:GetFont()
    title:SetFont(font, 22)
    
    -- Subtitle
    local subtitle = header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -5)
    subtitle:SetText("Iconic game sounds for World of Warcraft events")
    subtitle:SetTextColor(0.7, 0.7, 0.7)
    
    -- Version & Author
    local version = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    version:SetPoint("TOPRIGHT", -15, -15)
    version:SetText("|cff05dffav6.0.0-alpha|r |cffff0000[ALPHA]|r")
    
    local author = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    author:SetPoint("TOP", version, "BOTTOM", 0, -2)
    author:SetText("by |cffffd700donniedice|r")
    
    -- RGX Mods branding
    local branding = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    branding:SetPoint("BOTTOMRIGHT", -15, 10)
    branding:SetText("|cffffd700RGX |r|cff05dffaMods|r")
    local brandFont, _ = branding:GetFont()
    branding:SetFont(brandFont, 11)
    
    -- Tab container (SQP style tabs) - multiple rows with better spacing
    local tabContainer = CreateFrame("Frame", nil, container)
    tabContainer:SetHeight(70)  -- 2 rows * 27 height + extra spacing
    tabContainer:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -5)
    tabContainer:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", 0, -5)
    
    -- Add background for tab container
    local tabBg = tabContainer:CreateTexture(nil, "BACKGROUND")
    tabBg:SetAllPoints()
    tabBg:SetColorTexture(0.03, 0.03, 0.03, 0.6)
    
    -- Debug: Check if panel creation functions exist
    BLU:PrintDebug("[Options] Checking panel functions...")
    BLU:PrintDebug("  CreateGeneralPanel: " .. tostring(BLU.CreateGeneralPanel))
    BLU:PrintDebug("  CreateSoundsPanel: " .. tostring(BLU.CreateSoundsPanel))
    BLU:PrintDebug("  CreateModulesPanel: " .. tostring(BLU.CreateModulesPanel))
    BLU:PrintDebug("  CreateAboutPanel: " .. tostring(BLU.CreateAboutPanel))
    BLU:PrintDebug("  CreateEventSoundPanel: " .. tostring(BLU.CreateEventSoundPanel))
    
    -- Create tabs for each sound event type (organized layout)
    local tabs = {
        -- Row 1 - Core management
        {text = "General", create = BLU.CreateGeneralPanel, row = 1, col = 1},
        {text = "Sounds", create = BLU.CreateSoundsPanel, row = 1, col = 2},
        {text = "Modules", create = BLU.CreateModulesPanel, row = 1, col = 3},
        {text = "Level Up", eventType = "levelup", row = 1, col = 4},
        {text = "Achievement", eventType = "achievement", row = 1, col = 5},
        {text = "Quest", create = BLU.CreateQuestPanel, row = 1, col = 6},
        -- Row 2 - Additional events
        {text = "Reputation", eventType = "reputation", row = 2, col = 1},
        {text = "Battle Pets", eventType = "battlepet", row = 2, col = 2},
        {text = "Honor/PvP", eventType = "honorrank", row = 2, col = 3},
        {text = "Renown", eventType = "renownrank", row = 2, col = 4},
        {text = "Trading Post", eventType = "tradingpost", row = 2, col = 5},
        {text = "About", create = BLU.CreateAboutPanel, row = 2, col = 6}
    }
    
    panel.tabs = {}
    panel.contents = {}
    
    BLU:PrintDebug("[Options] Creating " .. #tabs .. " tabs...")
    
    for i, tabInfo in ipairs(tabs) do
        BLU:PrintDebug("[Options] Creating tab " .. i .. ": " .. tabInfo.text)
        local tab = CreateTabButton(tabContainer, tabInfo.text, i, tabInfo.row, tabInfo.col, panel)
        panel.tabs[i] = tab
        
        -- Create content frame with proper positioning using design constants
        local content = CreateFrame("Frame", nil, container, "BackdropTemplate")
        content:SetPoint("TOPLEFT", tabContainer, "BOTTOMLEFT", 8, -8)
        content:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -8, 8)
        content:SetBackdrop(BLU.Design.Backdrops.Dark)
        content:SetBackdropColor(0.08, 0.08, 0.08, 0.95)
        content:SetBackdropBorderColor(0.15, 0.15, 0.15, 1)
        content:Hide()
        
        -- Create tab content
        if tabInfo.create then
            BLU:PrintDebug("Creating content with function: " .. tostring(tabInfo.create))
            local success, err = pcall(tabInfo.create, content)
            if not success then
                BLU:PrintError("Failed to create tab content for " .. tabInfo.text .. ": " .. tostring(err))
                -- Create error display
                local errorText = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
                errorText:SetPoint("CENTER")
                errorText:SetText("|cffff0000Error loading " .. tabInfo.text .. " panel|r")
                local errorDetail = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                errorDetail:SetPoint("TOP", errorText, "BOTTOM", 0, -10)
                errorDetail:SetText(tostring(err))
                errorDetail:SetWidth(400)
            else
                BLU:PrintDebug("Successfully created content for " .. tabInfo.text)
            end
        elseif tabInfo.eventType then
            -- Create simplified sound selection panel for this event type
            BLU:PrintDebug("Creating simple event panel for: " .. tabInfo.eventType)
            local success, err = pcall(BLU.CreateSimpleEventPanel, content, tabInfo.eventType, tabInfo.text)
            if not success then
                BLU:PrintError("Failed to create event panel for " .. tabInfo.text .. ": " .. tostring(err))
                -- Create error display
                local errorText = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
                errorText:SetPoint("CENTER")
                errorText:SetText("|cffff0000Error loading " .. tabInfo.text .. " panel|r")
                local errorDetail = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                errorDetail:SetPoint("TOP", errorText, "BOTTOM", 0, -10)
                errorDetail:SetText(tostring(err))
                errorDetail:SetWidth(400)
            else
                BLU:PrintDebug("Successfully created event content for " .. tabInfo.text)
            end
        end
        
        panel.contents[i] = content
    end
    
    -- Tab selection function
    function panel:SelectTab(index)
        BLU:PrintDebug("Selecting tab: " .. tostring(index))
        for i, tab in ipairs(self.tabs) do
            local isActive = (i == index)
            tab:SetActive(isActive)
            if self.contents[i] then
                self.contents[i]:SetShown(isActive)
                if isActive then
                    BLU:PrintDebug("Showing content for tab " .. i)
                end
            else
                BLU:PrintError("No content for tab " .. i)
            end
        end
    end
    
    -- Select first tab
    panel:SelectTab(1)
    
    -- Add a custom icon check
    BLU.HasCustomIcon = select(3, C_AddOns.GetAddOnInfo(addonName)) ~= nil
    
    -- Register the panel
    local category
    if Settings and Settings.RegisterCanvasLayoutCategory then
        -- Dragonflight+ (10.0+)
        category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
        Settings.RegisterAddOnCategory(category)
        BLU.OptionsCategory = category
        BLU:PrintDebug("Options panel registered with new Settings API")
    else
        -- Pre-Dragonflight
        InterfaceOptions_AddCategory(panel)
        BLU.OptionsCategory = panel
        BLU:PrintDebug("Options panel registered with legacy API")
    end
    
    return panel
end

-- Open options
function Options:OpenOptions()
    -- Create panel if it doesn't exist
    if not BLU.OptionsPanel then
        self:CreateOptionsPanel()
    end
    
    if not BLU.OptionsCategory then
        BLU:Print("Options panel not properly registered.")
        return
    end
    
    if Settings and Settings.OpenToCategory and BLU.OptionsCategory and BLU.OptionsCategory.ID then
        Settings.OpenToCategory(BLU.OptionsCategory.ID)
        C_Timer.After(0.1, function()
            Settings.OpenToCategory(BLU.OptionsCategory.ID)
        end)
    elseif InterfaceOptionsFrame_OpenToCategory and BLU.OptionsCategory then
        InterfaceOptionsFrame_OpenToCategory(BLU.OptionsCategory)
        InterfaceOptionsFrame_OpenToCategory(BLU.OptionsCategory)
    else
        BLU:Print("Unable to open options panel")
    end
end

-- Create event sound panel for each tab
function BLU.CreateEventSoundPanel(panel, eventType, eventName)
    -- Create scrollable content with standardized positioning
    local scrollFrame, content = BLU.Design:CreatePanelScrollFrame(panel, 850)
    
    -- Event header
    local header = CreateFrame("Frame", nil, content)
    header:SetHeight(50)
    header:SetPoint("TOPLEFT", BLU.Design.Layout.ContentMargin, -BLU.Design.Layout.ContentMargin)
    header:SetPoint("RIGHT", -BLU.Design.Layout.ContentMargin, 0)
    
    local icon = header:CreateTexture(nil, "ARTWORK")
    icon:SetSize(32, 32)
    icon:SetPoint("LEFT", 0, 0)
    -- Set appropriate icon based on event type
    local icons = {
        levelup = "Interface\\Icons\\Achievement_Level_100",
        achievement = "Interface\\Icons\\Achievement_GuildPerk_MobileMailbox",
        quest = "Interface\\Icons\\INV_Misc_Note_01",
        reputation = "Interface\\Icons\\Achievement_Reputation_01",
        battlepet = "Interface\\Icons\\INV_Pet_BattlePetTraining",
        honorrank = "Interface\\Icons\\PVPCurrency-Honor-Horde",
        renownrank = "Interface\\Icons\\UI_MajorFaction_Renown",
        tradingpost = "Interface\\Icons\\INV_TradingPostCurrency",
        delvecompanion = "Interface\\Icons\\UI_MajorFaction_Delve"
    }
    icon:SetTexture(icons[eventType] or "Interface\\Icons\\INV_Misc_QuestionMark")
    
    local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", icon, "RIGHT", 10, 0)
    title:SetText("|cff05dffaB|retter |cff05dffaL|revel-|cff05dffaU|rp! " .. eventName .. " Events")
    
    -- Module enable/disable section with better styling
    local moduleSection = BLU.Design:CreateSection(content, "Module Control", "Interface\\Icons\\INV_Misc_Gear_08")
    moduleSection:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -BLU.Design.Layout.SectionSpacing)
    moduleSection:SetPoint("RIGHT", -BLU.Design.Layout.ContentMargin, 0)
    moduleSection:SetHeight(120) -- Increased height for better spacing
    
    -- Enable toggle with description
    local toggleFrame = CreateFrame("Frame", nil, moduleSection.content)
    toggleFrame:SetPoint("TOPLEFT", 10, -10)
    toggleFrame:SetSize(500, 60)
    
    -- Toggle switch (styled like the modules panel)
    local switchFrame = CreateFrame("Frame", nil, toggleFrame)
    switchFrame:SetSize(60, 24)
    switchFrame:SetPoint("LEFT", 0, 0)
    
    -- Switch background
    local switchBg = switchFrame:CreateTexture(nil, "BACKGROUND")
    switchBg:SetAllPoints()
    switchBg:SetTexture("Interface\\Buttons\\WHITE8x8")
    
    -- Switch toggle
    local toggle = CreateFrame("Button", nil, switchFrame)
    toggle:SetSize(28, 28)
    toggle:EnableMouse(true)
    
    local toggleBg = toggle:CreateTexture(nil, "ARTWORK")
    toggleBg:SetAllPoints()
    toggleBg:SetTexture("Interface\\Buttons\\WHITE8x8")
    toggleBg:SetVertexColor(1, 1, 1, 1)
    
    -- Module text
    local moduleText = toggleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    moduleText:SetPoint("LEFT", switchFrame, "RIGHT", 15, 5)
    moduleText:SetText("Enable " .. eventName .. " Module")
    
    local moduleDesc = toggleFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    moduleDesc:SetPoint("TOPLEFT", moduleText, "BOTTOMLEFT", 0, -3)
    moduleDesc:SetText("When enabled, Better Level-Up|cff05dffa!|r will respond to " .. eventName:lower() .. " events and play custom sounds")
    moduleDesc:SetTextColor(0.7, 0.7, 0.7)
    
    -- Status text
    local status = toggleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    status:SetPoint("RIGHT", toggleFrame, "RIGHT", -10, 0)
    
    -- Initialize state and update function
    local function UpdateToggleState(enabled)
        if enabled then
            toggle:SetPoint("RIGHT", switchFrame, "RIGHT", -2, 0)
            switchBg:SetVertexColor(unpack(BLU.Design.Colors.Primary))
            status:SetText("|cff00ff00ENABLED|r")
        else
            toggle:SetPoint("LEFT", switchFrame, "LEFT", 2, 0)
            switchBg:SetVertexColor(0.3, 0.3, 0.3, 1)
            status:SetText("|cffff0000DISABLED|r")
        end
    end
    
    -- Set initial state
    local enabled = true
    if BLU.db and BLU.db.profile and BLU.db.profile.modules then
        enabled = BLU.db.profile.modules[eventType] ~= false
    end
    UpdateToggleState(enabled)
    
    -- Click handler with module loading/unloading
    toggle:SetScript("OnClick", function(self)
        BLU.db.profile.modules = BLU.db.profile.modules or {}
        local currentlyEnabled = BLU.db.profile.modules[eventType] ~= false
        local newState = not currentlyEnabled
        
        BLU.db.profile.modules[eventType] = newState
        UpdateToggleState(newState)
        
        -- Load/unload module
        if newState then
            if BLU.LoadModule then
                BLU:LoadModule("features", eventType)
            end
        else
            if BLU.UnloadModule then
                BLU:UnloadModule(eventType)
            end
        end
    end)
    
    -- Sound selection section
    local soundSection = BLU.Design:CreateSection(content, "Sound Selection", "Interface\\Icons\\INV_Misc_Bell_01")
    soundSection:SetPoint("TOPLEFT", moduleSection, "BOTTOMLEFT", 0, -BLU.Design.Layout.SectionSpacing)
    soundSection:SetPoint("RIGHT", -BLU.Design.Layout.ContentMargin, 0)
    soundSection:SetHeight(500) -- Increased height for all content
    
    -- Current sound display
    local currentLabel = soundSection.content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    currentLabel:SetPoint("TOPLEFT", BLU.Design.Layout.Spacing, -BLU.Design.Layout.Spacing)
    currentLabel:SetText("Current Sound:")
    
    local currentSound = soundSection.content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    currentSound:SetPoint("LEFT", currentLabel, "RIGHT", BLU.Design.Layout.Spacing, 0)
    
    -- Test button
    local testBtn = BLU.Design:CreateButton(soundSection.content, "Test", 80, 25)
    testBtn:SetPoint("LEFT", currentSound, "RIGHT", BLU.Design.Layout.Padding, 0)
    testBtn:SetScript("OnClick", function(self)
        -- Visual feedback
        self:SetText("Playing...")
        self:Disable()
        
        -- Play sound
        if BLU.PlayCategorySound then
            BLU:PlayCategorySound(eventType)
        elseif BLU.Modules.registry and BLU.Modules.registry.PlayCategorySound then
            BLU.Modules.registry:PlayCategorySound(eventType)
        end
        
        -- Reset button after delay
        C_Timer.After(2, function()
            self:SetText("Test")
            self:Enable()
        end)
    end)
    
    -- Sound dropdown with submenus using new design system
    local dropdownContainer = BLU.Design:CreateDropdown(soundSection.content, "Select Sound:", 280)
    dropdownContainer:SetPoint("TOPLEFT", currentLabel, "BOTTOMLEFT", 0, -(BLU.Design.Layout.Spacing + 10))
    local dropdown = dropdownContainer.dropdown
    
    -- Initialize dropdown with sounds
    dropdown.eventId = eventType
    UIDropDownMenu_Initialize(dropdown, function(self, level, menuList)
        level = level or 1
        
        -- Debug SharedMedia state
        if level == 1 then
            BLU:PrintDebug(string.format("[Options] Initializing dropdown for %s", eventType))
            BLU:PrintDebug(string.format("[Options] SharedMedia module exists: %s", tostring(BLU.Modules.sharedmedia ~= nil)))
            if BLU.Modules.sharedmedia then
                BLU:PrintDebug(string.format("[Options] GetSoundCategories function exists: %s", 
                    tostring(BLU.Modules.sharedmedia.GetSoundCategories ~= nil)))
                if BLU.Modules.sharedmedia.GetSoundCategories then
                    local categories = BLU.Modules.sharedmedia:GetSoundCategories()
                    BLU:PrintDebug(string.format("[Options] Categories type: %s", type(categories)))
                    if type(categories) == "table" then
                        local count = 0
                        for k, v in pairs(categories) do
                            count = count + 1
                            BLU:PrintDebug(string.format("[Options] Category '%s' has %d sounds", k, v and #v or 0))
                        end
                        BLU:PrintDebug(string.format("[Options] Total categories: %d", count))
                    end
                end
            end
        end
        
        -- Ensure database exists
        if not BLU.db or not BLU.db.profile then
            return
        end
        BLU.db.profile.selectedSounds = BLU.db.profile.selectedSounds or {}
        
        if level == 1 then
            -- Default option
            local info = UIDropDownMenu_CreateInfo()
            info.text = "Default WoW Sound"
            info.value = "default"
            info.func = function()
                BLU.db.profile.selectedSounds[self.eventId] = "default"
                UIDropDownMenu_SetText(self, "Default WoW Sound")
                currentSound:SetText("Default WoW Sound")
                CloseDropDownMenus()
                if dropdown.UpdateVolumeVisibility then
                    dropdown.UpdateVolumeVisibility()
                end
            end
            info.checked = BLU.db.profile.selectedSounds[self.eventId] == "default"
            UIDropDownMenu_AddButton(info, level)
            
            -- WoW's built-in sounds
            info = UIDropDownMenu_CreateInfo()
            info.text = "|cffffff00WoW Game Sounds|r"
            info.value = "wow_sounds"
            info.hasArrow = true
            info.menuList = "wow_sounds"
            UIDropDownMenu_AddButton(info, level)
            
            -- BLU built-in sounds
            info = UIDropDownMenu_CreateInfo()
            info.text = "|cff05dffaBLU Sound Packs|r"
            info.value = "blu_builtin"
            info.hasArrow = true
            info.menuList = "blu_builtin"
            UIDropDownMenu_AddButton(info, level)
            
            -- External sounds by category
            if BLU.Modules.sharedmedia and BLU.Modules.sharedmedia.GetSoundCategories then
                local success, categories = pcall(function() return BLU.Modules.sharedmedia:GetSoundCategories() end)
                if success and categories and type(categories) == "table" then
                    local categoryCount = 0
                    for category, sounds in pairs(categories) do
                        if sounds and type(sounds) == "table" and #sounds > 0 then
                            categoryCount = categoryCount + 1
                            info = UIDropDownMenu_CreateInfo()
                            info.text = category .. " (" .. #sounds .. ")"
                            info.value = category
                            info.hasArrow = true
                            info.menuList = category
                            UIDropDownMenu_AddButton(info, level)
                        end
                    end
                    if categoryCount == 0 then
                        BLU:PrintDebug("[Options] SharedMedia has no valid sound categories")
                    end
                else
                    BLU:PrintDebug("[Options] SharedMedia GetSoundCategories failed or returned invalid data")
                end
            else
                BLU:PrintDebug("[Options] SharedMedia module not available or missing GetSoundCategories function")
            end
        elseif level == 2 then
            if menuList == "blu_builtin" then
                -- BLU's built-in sounds
                local builtinSounds = {
                    {value = "finalfantasy_" .. dropdown.eventId, text = "Final Fantasy"},
                    {value = "zelda_" .. dropdown.eventId, text = "Legend of Zelda"},
                    {value = "pokemon_" .. dropdown.eventId, text = "Pokemon"},
                    {value = "mario_" .. dropdown.eventId, text = "Super Mario"},
                    {value = "sonic_" .. dropdown.eventId, text = "Sonic the Hedgehog"},
                    {value = "metalgear_" .. dropdown.eventId, text = "Metal Gear Solid"},
                    {value = "elderscrolls_" .. dropdown.eventId, text = "Elder Scrolls"},
                    {value = "warcraft_" .. dropdown.eventId, text = "Warcraft"},
                    {value = "eldenring_" .. dropdown.eventId, text = "Elden Ring"},
                    {value = "castlevania_" .. dropdown.eventId, text = "Castlevania"},
                    {value = "diablo_" .. dropdown.eventId, text = "Diablo"},
                    {value = "fallout_" .. dropdown.eventId, text = "Fallout"},
                    {value = "blu_default_" .. dropdown.eventId, text = "BLU Defaults"}
                }
                
                for _, sound in ipairs(builtinSounds) do
                    local info = UIDropDownMenu_CreateInfo()
                    info.text = sound.text
                    info.value = sound.value
                    info.func = function()
                        BLU.db.profile.selectedSounds[dropdown.eventId] = sound.value
                        UIDropDownMenu_SetText(dropdown, sound.text)
                        currentSound:SetText(sound.text)
                        CloseDropDownMenus()
                        if dropdown.UpdateVolumeVisibility then
                            dropdown.UpdateVolumeVisibility()
                        end
                    end
                    info.checked = BLU.db.profile.selectedSounds[dropdown.eventId] == sound.value
                    UIDropDownMenu_AddButton(info, level)
                end
            elseif menuList == "wow_sounds" then
                -- WoW's built-in sounds for this event type
                local wowSounds = {
                    levelup = {
                        {value = "wowsounds_levelup_fanfare", text = "Level Up Fanfare"},
                        {value = "wowsounds_levelup_ding", text = "Level Ding"},
                        {value = "wowsounds_levelup_gong", text = "Gong"},
                        {value = "wowsounds_levelup_epic", text = "Epic Victory"},
                        {value = "wowsounds_levelup_power", text = "Power Up"},
                        {value = "wowsounds_classic_ding", text = "Classic Level Ding"}
                    },
                    achievement = {
                        {value = "wowsounds_achievement_default", text = "Achievement Earned"},
                        {value = "wowsounds_achievement_guild", text = "Guild Achievement"},
                        {value = "wowsounds_achievement_criteria", text = "Achievement Progress"},
                        {value = "wowsounds_achievement_legendary", text = "Legendary Alert"},
                        {value = "wowsounds_achievement_epic", text = "Epic Loot"},
                        {value = "wowsounds_achievement_rare", text = "Rare Item"},
                        {value = "wowsounds_ready_check", text = "Ready Check"},
                        {value = "wowsounds_raid_warning", text = "Raid Warning"}
                    },
                    quest = {
                        {value = "wowsounds_quest_complete", text = "Quest Complete"},
                        {value = "wowsounds_quest_objective", text = "Quest Objective"},
                        {value = "wowsounds_quest_turnin", text = "Quest Turn In"},
                        {value = "wowsounds_quest_special", text = "Special Quest Complete"},
                        {value = "wowsounds_quest_world", text = "World Quest Complete"},
                        {value = "wowsounds_quest_bonus", text = "Bonus Objective"},
                        {value = "wowsounds_quest_daily", text = "Daily Quest Complete"},
                        {value = "wowsounds_garrison_complete", text = "Garrison Mission Complete"},
                        {value = "wowsounds_island_complete", text = "Island Expedition Complete"},
                        {value = "wowsounds_warfront_complete", text = "Warfront Complete"},
                        {value = "wowsounds_classic_complete", text = "Classic Quest Complete"}
                    },
                    reputation = {
                        {value = "wowsounds_reputation_levelup", text = "Reputation Level Up"},
                        {value = "wowsounds_reputation_paragon", text = "Paragon Reputation"}
                    },
                    honorrank = {
                        {value = "wowsounds_honor_rankup", text = "Honor Rank Up"},
                        {value = "wowsounds_honor_prestige", text = "Prestige Level Up"},
                        {value = "wowsounds_honor_battleground", text = "Battleground Victory"},
                        {value = "wowsounds_honor_arena", text = "Arena Victory"},
                        {value = "wowsounds_honor_rbg", text = "RBG Victory"}
                    },
                    renownrank = {
                        {value = "wowsounds_renown_levelup", text = "Renown Level Up"},
                        {value = "wowsounds_renown_milestone", text = "Renown Milestone"}
                    },
                    tradingpost = {
                        {value = "wowsounds_tradingpost_complete", text = "Trading Post Complete"},
                        {value = "wowsounds_tradingpost_progress", text = "Trading Post Progress"},
                        {value = "wowsounds_tradingpost_unlock", text = "Trading Post Unlock"},
                        {value = "wowsounds_tradingpost_purchase", text = "Trading Post Purchase"}
                    },
                    battlepet = {
                        {value = "wowsounds_battlepet_victory", text = "Pet Battle Victory"},
                        {value = "wowsounds_battlepet_capture", text = "Pet Captured"},
                        {value = "wowsounds_battlepet_levelup", text = "Battle Pet Level Up"},
                        {value = "wowsounds_battlepet_rare", text = "Rare Pet Captured"},
                        {value = "wowsounds_battlepet_achievement", text = "Pet Achievement"}
                    },
                    delvecompanion = {
                        {value = "wowsounds_delve_complete", text = "Delve Complete"},
                        {value = "wowsounds_delve_bonus", text = "Bonus Objective Complete"}
                    }
                }
                
                local eventSounds = wowSounds[dropdown.eventId] or {}
                for _, sound in ipairs(eventSounds) do
                    local info = UIDropDownMenu_CreateInfo()
                    info.text = sound.text
                    info.value = sound.value
                    info.func = function()
                        BLU.db.profile.selectedSounds[dropdown.eventId] = sound.value
                        UIDropDownMenu_SetText(dropdown, sound.text)
                        currentSound:SetText(sound.text)
                        CloseDropDownMenus()
                        if dropdown.UpdateVolumeVisibility then
                            dropdown.UpdateVolumeVisibility()
                        end
                    end
                    info.checked = BLU.db.profile.selectedSounds[dropdown.eventId] == sound.value
                    UIDropDownMenu_AddButton(info, level)
                end
            else
                -- External sounds from category
                if BLU.Modules.sharedmedia and BLU.Modules.sharedmedia.GetSoundCategories then
                    local categories = BLU.Modules.sharedmedia:GetSoundCategories()
                    local sounds = categories and categories[menuList]
                    if sounds and type(sounds) == "table" then
                        for _, soundName in ipairs(sounds) do
                            local info = UIDropDownMenu_CreateInfo()
                            info.text = soundName
                            info.value = "external:" .. soundName
                            info.func = function()
                                BLU.db.profile.selectedSounds[dropdown.eventId] = "external:" .. soundName
                                UIDropDownMenu_SetText(dropdown, soundName .. " (External)")
                                currentSound:SetText(soundName .. " (External)")
                                CloseDropDownMenus()
                                if dropdown.UpdateVolumeVisibility then
                                    dropdown.UpdateVolumeVisibility()
                                end
                            end
                            info.checked = BLU.db.profile.selectedSounds[dropdown.eventId] == "external:" .. soundName
                            UIDropDownMenu_AddButton(info, level)
                        end
                    else
                        BLU:PrintDebug("[Options] No sounds found for category: " .. (menuList or "unknown"))
                    end
                else
                    BLU:PrintDebug("[Options] SharedMedia module not available for external sounds")
                end
            end
        end
    end)
    
    -- Set current value
    local currentValue = "default"
    if BLU.db and BLU.db.profile and BLU.db.profile.selectedSounds then
        currentValue = BLU.db.profile.selectedSounds[eventType] or "default"
    end
    if currentValue == "default" then
        UIDropDownMenu_SetText(dropdown, "Default WoW Sound")
        currentSound:SetText("Default WoW Sound")
    elseif currentValue:match("^external:") then
        local soundName = currentValue:gsub("^external:", "")
        UIDropDownMenu_SetText(dropdown, soundName .. " (External)")
        currentSound:SetText(soundName .. " (External)")
    elseif currentValue:match("^wowsounds_") then
        -- Find the text for WoW sounds
        local wowSounds = {
            levelup = {
                {value = "wowsounds_levelup_fanfare", text = "Level Up Fanfare"},
                {value = "wowsounds_levelup_ding", text = "Level Ding"},
                {value = "wowsounds_levelup_gong", text = "Gong"},
                {value = "wowsounds_levelup_epic", text = "Epic Victory"},
                {value = "wowsounds_levelup_power", text = "Power Up"},
                {value = "wowsounds_classic_ding", text = "Classic Level Ding"}
            },
            achievement = {
                {value = "wowsounds_achievement_default", text = "Achievement Earned"},
                {value = "wowsounds_achievement_guild", text = "Guild Achievement"},
                {value = "wowsounds_achievement_criteria", text = "Achievement Progress"},
                {value = "wowsounds_achievement_legendary", text = "Legendary Alert"},
                {value = "wowsounds_achievement_epic", text = "Epic Loot"},
                {value = "wowsounds_achievement_rare", text = "Rare Item"},
                {value = "wowsounds_ready_check", text = "Ready Check"},
                {value = "wowsounds_raid_warning", text = "Raid Warning"}
            }
        }
        local eventSounds = wowSounds[eventType] or {}
        for _, sound in ipairs(eventSounds) do
            if sound.value == currentValue then
                UIDropDownMenu_SetText(dropdown, sound.text)
                currentSound:SetText(sound.text)
                break
            end
        end
    else
        -- BLU internal sounds - extract pack name
        local packName = currentValue:match("^(.+)_" .. eventType .. "$")
        if packName then
            local packNames = {
                finalfantasy = "Final Fantasy",
                zelda = "Legend of Zelda",
                pokemon = "Pokemon",
                mario = "Super Mario",
                sonic = "Sonic the Hedgehog",
                metalgear = "Metal Gear Solid",
                elderscrolls = "Elder Scrolls",
                warcraft = "Warcraft",
                eldenring = "Elden Ring",
                castlevania = "Castlevania",
                diablo = "Diablo",
                fallout = "Fallout",
                blu_default = "BLU Defaults"
            }
            local displayName = packNames[packName] or packName
            UIDropDownMenu_SetText(dropdown, displayName)
            currentSound:SetText(displayName)
        else
            UIDropDownMenu_SetText(dropdown, currentValue)
            currentSound:SetText(currentValue)
        end
    end
    
    -- BLU Volume Control Section (dynamic visibility)
    local volumeContainer = CreateFrame("Frame", nil, soundSection.content)
    volumeContainer:SetPoint("TOPLEFT", dropdownContainer, "BOTTOMLEFT", 0, -(BLU.Design.Layout.Spacing + 5))
    volumeContainer:SetPoint("RIGHT", -BLU.Design.Layout.Padding, 0)
    volumeContainer:SetHeight(90)
    volumeContainer:Hide() -- Hidden by default
    
    -- Volume label
    local volumeLabel = volumeContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    volumeLabel:SetPoint("TOPLEFT", BLU.Design.Layout.Spacing, -BLU.Design.Layout.Spacing)
    volumeLabel:SetText("|cff05dffaB|retter |cff05dffaL|revel-|cff05dffaU|rp! Volume:")
    
    -- Volume percentage display
    local volumePercent = volumeContainer:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    volumePercent:SetPoint("LEFT", volumeLabel, "RIGHT", BLU.Design.Layout.Spacing, 0)
    
    -- Volume slider
    local volumeSlider = CreateFrame("Slider", nil, volumeContainer, "OptionsSliderTemplate")
    volumeSlider:SetPoint("TOPLEFT", volumeLabel, "BOTTOMLEFT", 0, -BLU.Design.Layout.Spacing)
    volumeSlider:SetSize(250, 20)
    volumeSlider:SetMinMaxValues(0, 100)
    volumeSlider:SetValueStep(1)
    volumeSlider:SetObeyStepOnDrag(true)
    
    -- Style the slider
    local sliderBg = volumeSlider:CreateTexture(nil, "BACKGROUND")
    sliderBg:SetAllPoints()
    sliderBg:SetColorTexture(0.1, 0.1, 0.1, 0.8)
    
    -- Update volume display function
    local function UpdateVolumeDisplay()
        local volume = BLU.db and BLU.db.profile and BLU.db.profile.soundVolume or 50
        volumeSlider:SetValue(volume)
        volumePercent:SetText(volume .. "%")
    end
    
    -- Volume slider change handler
    volumeSlider:SetScript("OnValueChanged", function(self, value)
        if not BLU.db or not BLU.db.profile then return end
        
        local roundedValue = math.floor(value + 0.5)
        BLU.db.profile.soundVolume = roundedValue
        volumePercent:SetText(roundedValue .. "%")
    end)
    
    -- Function to check if current sound is a BLU internal sound
    local function IsBLUInternalSound(soundValue)
        if not soundValue or soundValue == "default" then return false end
        if soundValue:match("^external:") then return false end
        if soundValue:match("^wowsounds_") then return false end
        
        -- Check for BLU internal sound patterns
        local bluPrefixes = {
            "finalfantasy_", "zelda_", "pokemon_", "mario_", "sonic_", 
            "metalgear_", "elderscrolls_", "warcraft_", "eldenring_", 
            "castlevania_", "diablo_", "fallout_", "blu_default_"
        }
        
        for _, prefix in ipairs(bluPrefixes) do
            if soundValue:match("^" .. prefix) then
                return true
            end
        end
        
        return false
    end
    
    -- Function to update volume control visibility
    local function UpdateVolumeVisibility()
        local currentValue = "default"
        if BLU.db and BLU.db.profile and BLU.db.profile.selectedSounds then
            currentValue = BLU.db.profile.selectedSounds[eventType] or "default"
        end
        
        if IsBLUInternalSound(currentValue) then
            volumeContainer:Show()
            UpdateVolumeDisplay()
            -- Adjust sound section height
            soundSection:SetHeight(580) -- Increased to show volume control
        else
            volumeContainer:Hide()
            -- Reset sound section height
            soundSection:SetHeight(500)
        end
    end
    
    -- Store references for dropdown callback
    dropdown.volumeContainer = volumeContainer
    dropdown.UpdateVolumeVisibility = UpdateVolumeVisibility
    
    -- Initial volume visibility check
    C_Timer.After(0.1, UpdateVolumeVisibility)
    
    -- Info text
    local infoText = soundSection.content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    infoText:SetPoint("TOPLEFT", volumeContainer, "BOTTOMLEFT", BLU.Design.Layout.Spacing, -(BLU.Design.Layout.Spacing + 5))
    infoText:SetPoint("RIGHT", -BLU.Design.Layout.Padding, 0)
    infoText:SetText("|cff888888Note: Better Level-Up|cff05dffa!|r internal sounds respect the volume slider. External and default sounds use game audio settings.|r")
    infoText:SetJustifyH("LEFT")
    
    -- Content height already set by CreatePanelScrollFrame
end

-- Cleanup module
function Options:Cleanup()
    -- Nothing to cleanup
end

-- Register module
if BLU.RegisterModule then
    BLU:RegisterModule(Options, "options_new", "Options Interface")
end

-- Panel will be created during PLAYER_LOGIN event in core/events.lua
-- This ensures proper initialization order and immediate addon settings registration

-- Note: CreateRGXModsPanel function removed - RGX Mods tab no longer exists