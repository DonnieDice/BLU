--=====================================================================================
-- BLU - interface/design.lua
-- Design constants and styling following SimpleQuestPlates pattern
--=====================================================================================

local addonName, BLU = ...

BLU.Design = {
    -- Brand colors (matching SimpleQuestPlates style)
    Colors = {
        Primary = {0.02, 0.87, 0.98, 1},        -- BLU blue: #05dffa
        PrimaryHex = "|cff05dffa",
        Background = {0.05, 0.05, 0.05, 0.95},  -- SQP dark background
        Panel = {0.08, 0.08, 0.08, 0.8},        -- SQP panel background
        Border = {0.02, 0.87, 0.98, 1},         -- BLU blue for borders
        Text = {1, 1, 1, 1},                    -- White
        TextMuted = {0.7, 0.7, 0.7, 1},        -- Gray
        Success = {0.34, 0.74, 0.36, 1},       -- Green
        Warning = {1, 0.82, 0, 1},              -- Yellow
        Error = {1, 0.2, 0.2, 1},               -- Red
    },
    
    -- Backdrop templates (SimpleQuestPlates style)
    Backdrops = {
        Dark = {
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = false,
            tileSize = 0,
            edgeSize = 1,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        },
        Panel = {
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = false,
            tileSize = 0,
            edgeSize = 1,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        },
        Tooltip = {
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 4, right = 4, top = 4, bottom = 4}
        }
    },
    
    -- Layout constants
    Layout = {
        PanelWidth = 700,
        PanelHeight = 600,
        HeaderHeight = 100,
        TabWidth = 85,
        TabHeight = 24,
        TabSpacing = 3,
        TabRowHeight = 27, -- 24 height + 3 spacing
        Padding = 20,
        Spacing = 10,
        ColumnGap = 20,
        -- Alignment constants for consistent positioning
        ContentMargin = 10,      -- Standard margin from panel edges
        ScrollMargin = 30,       -- Extra margin for scroll bar
        SectionSpacing = 10,     -- Space between sections
        ElementSpacing = 8,      -- Space between elements in sections
        ContentPadding = 15,     -- Inner padding for section content
    },
    
    -- Font styles
    Fonts = {
        Large = "GameFontNormalLarge",
        Normal = "GameFontNormal",
        Small = "GameFontNormalSmall",
        Highlight = "GameFontHighlight",
        Huge = "GameFontNormalHuge",
    }
}

-- Helper function to apply backdrop with color
function BLU.Design:ApplyBackdrop(frame, backdropType, bgColor, borderColor)
    if not frame.SetBackdrop then
        Mixin(frame, BackdropTemplateMixin)
    end
    
    frame:SetBackdrop(self.Backdrops[backdropType] or self.Backdrops.Dark)
    
    if bgColor then
        frame:SetBackdropColor(unpack(bgColor))
    else
        frame:SetBackdropColor(unpack(self.Colors.Background))
    end
    
    if borderColor then
        frame:SetBackdropBorderColor(unpack(borderColor))
    else
        frame:SetBackdropBorderColor(unpack(self.Colors.Border))
    end
end

-- Create styled header
function BLU.Design:CreateHeader(parent, text, icon)
    local header = CreateFrame("Frame", nil, parent)
    header:SetHeight(20)
    
    if icon then
        local iconTex = header:CreateTexture(nil, "ARTWORK")
        iconTex:SetSize(16, 16)
        iconTex:SetPoint("LEFT", 0, 0)
        iconTex:SetTexture(icon)
        
        local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("LEFT", iconTex, "RIGHT", 5, 0)
        title:SetText(self.Colors.PrimaryHex .. text .. "|r")
        header.title = title
    else
        local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("LEFT", 0, 0)
        title:SetText(self.Colors.PrimaryHex .. text .. "|r")
        header.title = title
    end
    
    -- Divider line
    local divider = header:CreateTexture(nil, "BACKGROUND")
    divider:SetHeight(1)
    divider:SetPoint("TOPLEFT", 0, -18)
    divider:SetPoint("TOPRIGHT", 0, -18)
    divider:SetColorTexture(0.2, 0.2, 0.2, 1)
    
    return header
end

-- Create styled button
function BLU.Design:CreateButton(parent, text, width, height)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(width or 100, height or 22)
    
    -- Button texture
    button:SetNormalTexture("Interface\\Buttons\\UI-DialogBox-Button-Up")
    button:SetPushedTexture("Interface\\Buttons\\UI-DialogBox-Button-Down")
    button:SetHighlightTexture("Interface\\Buttons\\UI-DialogBox-Button-Highlight")
    
    local normal = button:GetNormalTexture()
    normal:SetTexCoord(0, 1, 0, 0.71875)
    normal:SetVertexColor(0.2, 0.2, 0.2, 1)
    
    local pushed = button:GetPushedTexture()
    pushed:SetTexCoord(0, 1, 0, 0.71875)
    
    local highlight = button:GetHighlightTexture()
    highlight:SetTexCoord(0, 1, 0, 0.71875)
    highlight:SetVertexColor(0.02, 0.37, 1, 0.3)
    
    local textStr = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    textStr:SetPoint("CENTER")
    textStr:SetText(text)
    button.Text = textStr
    
    button:SetScript("OnEnter", function(self)
        local normal = self:GetNormalTexture()
        normal:SetVertexColor(0.3, 0.3, 0.3, 1)
    end)
    
    button:SetScript("OnLeave", function(self)
        local normal = self:GetNormalTexture()
        normal:SetVertexColor(0.2, 0.2, 0.2, 1)
    end)
    
    return button
end

-- Create styled checkbox
function BLU.Design:CreateCheckbox(parent, label, tooltip)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetHeight(24)
    
    local check = CreateFrame("CheckButton", nil, frame, "InterfaceOptionsCheckButtonTemplate")
    check:SetPoint("LEFT", 0, 0)
    
    local text = frame:CreateFontString(nil, "OVERLAY", self.Fonts.Normal)
    text:SetPoint("LEFT", check, "RIGHT", 5, 0)
    text:SetText(label)
    
    frame.check = check
    frame.text = text
    
    if tooltip then
        check:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(label, 1, 1, 1)
            GameTooltip:AddLine(tooltip, nil, nil, nil, true)
            GameTooltip:Show()
        end)
        check:SetScript("OnLeave", GameTooltip_Hide)
    end
    
    -- Auto-size frame
    frame:SetWidth(check:GetWidth() + 5 + text:GetStringWidth())
    
    return frame
end

-- Create styled dropdown
function BLU.Design:CreateDropdown(parent, label, width)
    local container = CreateFrame("Frame", nil, parent)
    container:SetHeight(45)
    
    -- Label
    local labelText = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    labelText:SetPoint("TOPLEFT", 0, 0)
    labelText:SetText(label)
    labelText:SetTextColor(unpack(self.Colors.Text))
    
    -- Dropdown with better styling (needs a unique name for the template)
    local dropdownName = "BLUDropdown" .. math.random(100000, 999999)
    local dropdown = CreateFrame("Frame", dropdownName, container, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", labelText, "BOTTOMLEFT", -16, -5)
    UIDropDownMenu_SetWidth(dropdown, width or 200)
    
    -- Store reference to self for the delayed function
    local design = self
    
    -- Style the dropdown after it's created (needs to be delayed)
    C_Timer.After(0.01, function()
        -- We already have dropdownName from above
        if dropdownName then
            local button = _G[dropdownName .. "Button"]
            if button then
                -- Update button texture for better visibility
                button:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
                button:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
                button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
                
                -- Resize and position
                button:SetSize(16, 16)
                button:ClearAllPoints()
                button:SetPoint("RIGHT", dropdown, "RIGHT", -10, 0)
            end
            
            -- Style the dropdown background parts
            local middle = _G[dropdownName .. "Middle"]
            local left = _G[dropdownName .. "Left"]  
            local right = _G[dropdownName .. "Right"]
            
            if middle then middle:SetVertexColor(0.15, 0.15, 0.15, 1) end
            if left then left:SetVertexColor(0.15, 0.15, 0.15, 1) end
            if right then right:SetVertexColor(0.15, 0.15, 0.15, 1) end
            
            -- Style the dropdown text
            local text = _G[dropdownName .. "Text"]
            if text then
                text:SetTextColor(unpack(design.Colors.Text))
            end
        end
    end)
    
    container.label = labelText
    container.dropdown = dropdown
    
    return container
end

-- Create section container
function BLU.Design:CreateSection(parent, title, icon)
    local section = CreateFrame("Frame", nil, parent)
    
    -- Compact background
    local bg = section:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.03, 0.03, 0.03, 0.6)
    
    -- Border
    local border = CreateFrame("Frame", nil, section, "BackdropTemplate")
    border:SetAllPoints()
    border:SetBackdrop({
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    border:SetBackdropBorderColor(0.1, 0.1, 0.1, 1)
    
    if title then
        local header = self:CreateHeader(section, title, icon)
        header:SetPoint("TOPLEFT", 8, -8)
        header:SetPoint("TOPRIGHT", -8, -8)
        section.header = header
        section.content = CreateFrame("Frame", nil, section)
        section.content:SetPoint("TOPLEFT", 15, -32)
        section.content:SetPoint("BOTTOMRIGHT", -15, 8)
    else
        section.content = CreateFrame("Frame", nil, section)
        section.content:SetPoint("TOPLEFT", 15, -8)
        section.content:SetPoint("BOTTOMRIGHT", -15, 8)
    end
    
    return section
end

-- Create standardized scroll frame for panels
function BLU.Design:CreatePanelScrollFrame(panel, contentHeight)
    contentHeight = contentHeight or 800
    
    -- Create scroll frame with consistent positioning
    local scrollFrame = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", self.Layout.ContentMargin, -self.Layout.ContentMargin)
    scrollFrame:SetPoint("BOTTOMRIGHT", -self.Layout.ScrollMargin, self.Layout.ContentMargin)
    
    -- Add background for better visibility
    local scrollBg = scrollFrame:CreateTexture(nil, "BACKGROUND")
    scrollBg:SetAllPoints()
    scrollBg:SetColorTexture(0.05, 0.05, 0.05, 0.3)
    
    -- Create content frame with proper width calculation
    local content = CreateFrame("Frame", nil, scrollFrame)
    local scrollWidth = scrollFrame:GetWidth()
    if scrollWidth <= 0 then
        -- Fallback calculation if width not available yet
        scrollWidth = panel:GetWidth() - self.Layout.ContentMargin - self.Layout.ScrollMargin - 20
    else
        scrollWidth = scrollWidth - 20 -- Account for potential scroll bar
    end
    content:SetSize(scrollWidth, contentHeight)
    scrollFrame:SetScrollChild(content)
    
    return scrollFrame, content
end