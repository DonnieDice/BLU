--=====================================================================================
-- BLU - interface/panels/about_new.lua
-- About panel with new design
--=====================================================================================

local addonName, BLU = ...

function BLU.CreateAboutPanel(panel)
    -- Create scrollable content with proper sizing aligned to parent content frame
    local scrollFrame = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", BLU.Design.Layout.Spacing, -BLU.Design.Layout.Spacing)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, BLU.Design.Layout.Spacing)
    
    -- Add scroll frame background
    local scrollBg = scrollFrame:CreateTexture(nil, "BACKGROUND")
    scrollBg:SetAllPoints()
    scrollBg:SetColorTexture(0.05, 0.05, 0.05, 0.3)
    
    local content = CreateFrame("Frame", nil, scrollFrame)
    -- Calculate proper content width based on scroll frame
    C_Timer.After(0.01, function()
        if scrollFrame:GetWidth() then
            content:SetSize(scrollFrame:GetWidth() - 25, 900)
        else
            content:SetSize(600, 900)
        end
    end)
    scrollFrame:SetScrollChild(content)
    
    -- BLU Logo/Header
    local logoFrame = CreateFrame("Frame", nil, content)
    logoFrame:SetPoint("TOPLEFT", BLU.Design.Layout.Spacing, -BLU.Design.Layout.Spacing)
    logoFrame:SetPoint("RIGHT", -BLU.Design.Layout.Spacing, 0)
    logoFrame:SetHeight(120)
    
    -- Logo background
    local logoBg = logoFrame:CreateTexture(nil, "BACKGROUND")
    logoBg:SetAllPoints()
    logoBg:SetColorTexture(0.02, 0.37, 1, 0.1)
    
    -- Logo icon
    local logoIcon = logoFrame:CreateTexture(nil, "ARTWORK")
    logoIcon:SetSize(80, 80)
    logoIcon:SetPoint("LEFT", 20, 0)
    logoIcon:SetTexture("Interface\\Icons\\Achievement_Level_100")
    
    -- Title
    local title = logoFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    title:SetPoint("LEFT", logoIcon, "RIGHT", 20, 15)
    title:SetText("Better Level-Up|cff05dffa!|r")
    title:SetFont(title:GetFont(), 24)
    
    -- Version and tagline
    local version = logoFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    version:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -5)
    version:SetText("Version 6.0.0-alpha |cffff0000[ALPHA]|r - |cffffd700RGX |r|cff05dffaMods|r")
    version:SetTextColor(0.8, 0.8, 0.8)
    
    local tagline = logoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    tagline:SetPoint("TOPLEFT", version, "BOTTOMLEFT", 0, -5)
    tagline:SetText("Replace default sounds with iconic audio from 50+ games")
    
    -- Info Section
    local infoSection = BLU.Design:CreateSection(content, "Information", "Interface\\Icons\\INV_Misc_Book_09")
    infoSection:SetPoint("TOPLEFT", logoFrame, "BOTTOMLEFT", 0, -BLU.Design.Layout.Spacing)
    infoSection:SetPoint("RIGHT", -BLU.Design.Layout.Spacing, 0)
    infoSection:SetHeight(180)
    
    -- Create info grid
    local infoGrid = CreateFrame("Frame", nil, infoSection.content)
    infoGrid:SetPoint("TOPLEFT", 0, -10)
    infoGrid:SetPoint("RIGHT", 0, 0)
    
    local function CreateInfoRow(parent, icon, label, value, yOffset)
        local row = CreateFrame("Frame", nil, parent)
        row:SetPoint("TOPLEFT", 0, yOffset)
        row:SetPoint("RIGHT", 0, 0)
        row:SetHeight(24)
        
        local iconTex = row:CreateTexture(nil, "ARTWORK")
        iconTex:SetSize(20, 20)
        iconTex:SetPoint("LEFT", 10, 0)
        iconTex:SetTexture(icon)
        
        local labelText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        labelText:SetPoint("LEFT", iconTex, "RIGHT", 10, 0)
        labelText:SetText(label .. ":")
        labelText:SetWidth(100)
        labelText:SetJustifyH("LEFT")
        
        local valueText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        valueText:SetPoint("LEFT", labelText, "RIGHT", 10, 0)
        valueText:SetText(value)
        
        return row
    end
    
    CreateInfoRow(infoGrid, "Interface\\Icons\\INV_Misc_Note_05", "Author", "|cffffd700donniedice|r", 0)
    CreateInfoRow(infoGrid, "Interface\\Icons\\ACHIEVEMENT_GUILDPERK_EVERYONES A HERO_RANK2", "Discord", "|cffffd700discord.gg/rgxmods|r", -30)
    CreateInfoRow(infoGrid, "Interface\\Icons\\INV_Misc_Web_01", "Website", "|cffffd700rgxmods.com|r", -60)
    CreateInfoRow(infoGrid, "Interface\\Icons\\Trade_Engineering", "GitHub", "|cffffd700github.com/donniedice/BLU|r", -90)
    CreateInfoRow(infoGrid, "Interface\\Icons\\INV_Misc_GroupLooking", "Support", "|cff00ff00/help|r for assistance", -120)
    
    -- Features Section
    local featuresSection = BLU.Design:CreateSection(content, "Features", "Interface\\Icons\\Achievement_General")
    featuresSection:SetPoint("TOPLEFT", infoSection, "BOTTOMLEFT", 0, -BLU.Design.Layout.Spacing)
    featuresSection:SetPoint("RIGHT", -BLU.Design.Layout.Spacing, 0)
    featuresSection:SetHeight(200)
    
    local features = {
        "|cff05dffa50+ Game Sound Packs|r - Iconic sounds from your favorite games",
        "|cff05dffaSharedMedia Support|r - Use sounds from other addons",
        "|cff05dffaVolume Control|r - Adjust sound levels to your preference",
        "|cff05dffaPer-Event Customization|r - Different sounds for each event type",
        "|cff05dffaLightweight Design|r - No external library dependencies",
        "|cff05dffaModular Architecture|r - Load only what you need",
        "|cff05dffaFull Retail Support|r - Optimized for War Within (11.0.5)"
    }
    
    local yOffset = -10
    for _, feature in ipairs(features) do
        local featureText = featuresSection.content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        featureText:SetPoint("TOPLEFT", 20, yOffset)
        featureText:SetPoint("RIGHT", -20, 0)
        featureText:SetText("• " .. feature)
        featureText:SetJustifyH("LEFT")
        yOffset = yOffset - 25
    end
    
    -- Statistics Section
    local statsSection = BLU.Design:CreateSection(content, "Statistics", "Interface\\Icons\\Achievement_GuildPerk_CashFlow_Rank2")
    statsSection:SetPoint("TOPLEFT", featuresSection, "BOTTOMLEFT", 0, -BLU.Design.Layout.Spacing)
    statsSection:SetPoint("RIGHT", -BLU.Design.Layout.Spacing, 0)
    statsSection:SetHeight(120)
    
    -- Create stats display
    local function CreateStatDisplay(parent, x, y, label, value, color)
        local frame = CreateFrame("Frame", nil, parent)
        frame:SetPoint("TOPLEFT", x, y)
        frame:SetSize(150, 60)
        
        local bg = frame:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)
        
        local valueText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
        valueText:SetPoint("TOP", 0, -10)
        valueText:SetText(value)
        valueText:SetTextColor(color.r, color.g, color.b)
        
        local labelText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        labelText:SetPoint("TOP", valueText, "BOTTOM", 0, -5)
        labelText:SetText(label)
        labelText:SetTextColor(0.7, 0.7, 0.7)
        
        return frame
    end
    
    -- Calculate some stats
    local enabledModules = 0
    if BLU.db and BLU.db.profile and BLU.db.profile.modules then
        for _, enabled in pairs(BLU.db.profile.modules) do
            if enabled then enabledModules = enabledModules + 1 end
        end
    end
    
    CreateStatDisplay(statsSection.content, 20, -10, "Modules Active", tostring(enabledModules), {r=0.02, g=0.87, b=0.98})
    CreateStatDisplay(statsSection.content, 180, -10, "Sound Packs", "50+", {r=0.02, g=0.87, b=0.98})
    CreateStatDisplay(statsSection.content, 340, -10, "Version", "6.0.0-alpha", {r=0.02, g=0.87, b=0.98})
    
    -- Credits Section
    local creditsSection = BLU.Design:CreateSection(content, "Credits & Thanks", "Interface\\Icons\\Achievement_GuildPerk_Honorable Mention")
    creditsSection:SetPoint("TOPLEFT", statsSection, "BOTTOMLEFT", 0, -BLU.Design.Layout.Spacing)
    creditsSection:SetPoint("RIGHT", -BLU.Design.Layout.Spacing, 0)
    creditsSection:SetHeight(100)
    
    local creditsText = creditsSection.content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    creditsText:SetPoint("TOPLEFT", 20, -10)
    creditsText:SetPoint("RIGHT", -20, 0)
    creditsText:SetJustifyH("LEFT")
    creditsText:SetText(
        "All game sounds are property of their respective owners and are used under fair use.\n" ..
        "Special thanks to the RGX Mods community for their support and feedback.\n" ..
        "Thanks to the WoW addon development community for inspiration and guidance."
    )
    
    content:SetHeight(850)
end