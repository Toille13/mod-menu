--[[
    Roblox Mod Menu Script (Educational Purpose)
    
    Features:
    - Jump enhancement
    - Flying capability
    - Aimbot with target locking
    - ESP (player boxes)
    - Wall hack/transparency
    - Player teleportation
    
    Keyboard Controls:
    - F: Toggle flight
    - L: Lock/unlock target for aimbot
    - T: Teleport to target
    - INSERT: Toggle menu visibility
]]

-- Configuration
local Config = {
    -- Jump settings
    Jump = {
        Enabled = false,
        Height = 3, -- Multiplier
    },
    
    -- Flight settings
    Flight = {
        Enabled = false,
        Speed = 5, -- Multiplier
    },
    
    -- Aimbot settings
    Aimbot = {
        Enabled = false,
        Smoothness = 5, -- 1-10
        Target = "Head", -- "Head" or "HumanoidRootPart"
        VisibleOnly = false,
        LockTarget = false,
        CurrentTarget = nil,
    },
    
    -- ESP settings
    ESP = {
        Enabled = false,
        Color = Color3.fromRGB(255, 85, 85), -- Red default
        ShowHealth = true,
        ShowDistance = true,
        ShowName = true,
    },
    
    -- Wall Hack settings
    WallHack = {
        Enabled = false,
        Transparency = 0.3, -- 0.1-0.9
    },
    
    -- Teleport settings
    Teleport = {
        Enabled = false,
        Type = "Player", -- "Player" or "Location"
    },
    
    -- Menu visibility
    MenuVisible = true,
}

-- Local player reference
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Create base GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local ModMenu = Instance.new("Frame")
ModMenu.Name = "ModMenu"
ModMenu.Size = UDim2.new(0, 300, 0, 400)
ModMenu.Position = UDim2.new(0, 10, 0.5, -200)
ModMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ModMenu.BorderSizePixel = 0
ModMenu.Active = true
ModMenu.Draggable = true
ModMenu.Visible = Config.MenuVisible
ModMenu.Parent = ScreenGui

-- Menu Header
local MenuHeader = Instance.new("Frame")
MenuHeader.Name = "Header"
MenuHeader.Size = UDim2.new(1, 0, 0, 40)
MenuHeader.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
MenuHeader.BorderSizePixel = 0
MenuHeader.Parent = ModMenu

local MenuTitle = Instance.new("TextLabel")
MenuTitle.Name = "Title"
MenuTitle.Size = UDim2.new(1, -40, 1, 0)
MenuTitle.Position = UDim2.new(0, 10, 0, 0)
MenuTitle.BackgroundTransparency = 1
MenuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuTitle.TextSize = 18
MenuTitle.Font = Enum.Font.SourceSansBold
MenuTitle.Text = "Roblox Mod Menu"
MenuTitle.TextXAlignment = Enum.TextXAlignment.Left
MenuTitle.Parent = MenuHeader

-- Functions for feature implementation
local function CreateToggleButton(parent, position, text, configTable, configKey)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text.."Toggle"
    ToggleFrame.Size = UDim2.new(1, -20, 0, 30)
    ToggleFrame.Position = position
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = Enum.Font.SourceSans
    ToggleLabel.Text = text
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Button"
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
    ToggleButton.BackgroundColor3 = configTable[configKey] and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(200, 200, 200)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = configTable[configKey] and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 12
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.Parent = ToggleFrame
    
    ToggleButton.MouseButton1Click:Connect(function()
        configTable[configKey] = not configTable[configKey]
        ToggleButton.BackgroundColor3 = configTable[configKey] and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(200, 200, 200)
        ToggleButton.Text = configTable[configKey] and "ON" or "OFF"
    end)
    
    return ToggleFrame
end

local function CreateSlider(parent, position, text, min, max, current, configTable, configKey, suffix)
    suffix = suffix or ""
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = text.."Slider"
    SliderFrame.Size = UDim2.new(1, -20, 0, 50)
    SliderFrame.Position = position
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "Label"
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 14
    SliderLabel.Font = Enum.Font.SourceSans
    SliderLabel.Text = text .. ": " .. current .. suffix
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderBG = Instance.new("Frame")
    SliderBG.Name = "Background"
    SliderBG.Size = UDim2.new(1, 0, 0, 10)
    SliderBG.Position = UDim2.new(0, 0, 0.6, 0)
    SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBG.BorderSizePixel = 0
    SliderBG.Parent = SliderFrame
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    local fillRatio = (current - min) / (max - min)
    SliderFill.Size = UDim2.new(fillRatio, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBG
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Name = "Button"
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.Parent = SliderBG
    
    local isDragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    SliderButton.MouseButton1Up:Connect(function()
        isDragging = false
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    SliderButton.MouseMoved:Connect(function(x)
        if isDragging then
            local absoluteX = x - SliderBG.AbsolutePosition.X
            local sliderRatio = math.clamp(absoluteX / SliderBG.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + sliderRatio * (max - min))
            
            configTable[configKey] = value
            SliderFill.Size = UDim2.new(sliderRatio, 0, 1, 0)
            SliderLabel.Text = text .. ": " .. value .. suffix
        end
    end)
    
    return SliderFrame
end

-- Function to create the content sections
local function CreateModMenuContent()
    -- Content container
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.CanvasSize = UDim2.new(0, 0, 2, 0) -- Will be resized based on content
    ContentFrame.Parent = ModMenu
    
    -- Movement Section
    local MovementSection = Instance.new("Frame")
    MovementSection.Name = "MovementSection"
    MovementSection.Size = UDim2.new(1, -20, 0, 180)
    MovementSection.Position = UDim2.new(0, 10, 0, 10)
    MovementSection.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MovementSection.BorderSizePixel = 0
    MovementSection.Parent = ContentFrame
    
    local MovementTitle = Instance.new("TextLabel")
    MovementTitle.Name = "Title"
    MovementTitle.Size = UDim2.new(1, 0, 0, 30)
    MovementTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    MovementTitle.BorderSizePixel = 0
    MovementTitle.TextColor3 = Color3.fromRGB(255, 85, 85)
    MovementTitle.TextSize = 16
    MovementTitle.Font = Enum.Font.SourceSansBold
    MovementTitle.Text = "Movement Mods"
    MovementTitle.Parent = MovementSection
    
    local jumpToggle = CreateToggleButton(MovementSection, UDim2.new(0, 10, 0, 40), "Enhanced Jump", Config.Jump, "Enabled")
    local jumpSlider = CreateSlider(MovementSection, UDim2.new(0, 10, 0, 80), "Jump Height", 1, 10, Config.Jump.Height, Config.Jump, "Height", "x")
    
    local flyToggle = CreateToggleButton(MovementSection, UDim2.new(0, 10, 0, 130), "Fly Mode", Config.Flight, "Enabled")
    
    -- Combat Section
    local CombatSection = Instance.new("Frame")
    CombatSection.Name = "CombatSection"
    CombatSection.Size = UDim2.new(1, -20, 0, 230)
    CombatSection.Position = UDim2.new(0, 10, 0, 200)
    CombatSection.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    CombatSection.BorderSizePixel = 0
    CombatSection.Parent = ContentFrame
    
    local CombatTitle = Instance.new("TextLabel")
    CombatTitle.Name = "Title"
    CombatTitle.Size = UDim2.new(1, 0, 0, 30)
    CombatTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CombatTitle.BorderSizePixel = 0
    CombatTitle.TextColor3 = Color3.fromRGB(255, 85, 85)
    CombatTitle.TextSize = 16
    CombatTitle.Font = Enum.Font.SourceSansBold
    CombatTitle.Text = "Combat Mods"
    CombatTitle.Parent = CombatSection
    
    local aimbotToggle = CreateToggleButton(CombatSection, UDim2.new(0, 10, 0, 40), "Aimbot", Config.Aimbot, "Enabled")
    local lockToggle = CreateToggleButton(CombatSection, UDim2.new(0, 10, 0, 80), "Lock Target (L key)", Config.Aimbot, "LockTarget")
    local teleportToggle = CreateToggleButton(CombatSection, UDim2.new(0, 10, 0, 120), "Teleport", Config.Teleport, "Enabled")
    
    -- Visual Section
    local VisualSection = Instance.new("Frame")
    VisualSection.Name = "VisualSection"
    VisualSection.Size = UDim2.new(1, -20, 0, 230)
    VisualSection.Position = UDim2.new(0, 10, 0, 440)
    VisualSection.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    VisualSection.BorderSizePixel = 0
    VisualSection.Parent = ContentFrame
    
    local VisualTitle = Instance.new("TextLabel")
    VisualTitle.Name = "Title"
    VisualTitle.Size = UDim2.new(1, 0, 0, 30)
    VisualTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    VisualTitle.BorderSizePixel = 0
    VisualTitle.TextColor3 = Color3.fromRGB(255, 85, 85)
    VisualTitle.TextSize = 16
    VisualTitle.Font = Enum.Font.SourceSansBold
    VisualTitle.Text = "Visual Mods"
    VisualTitle.Parent = VisualSection
    
    local espToggle = CreateToggleButton(VisualSection, UDim2.new(0, 10, 0, 40), "ESP (Player Boxes)", Config.ESP, "Enabled")
    local wallHackToggle = CreateToggleButton(VisualSection, UDim2.new(0, 10, 0, 80), "Wall Hack", Config.WallHack, "Enabled")
    local transparencySlider = CreateSlider(VisualSection, UDim2.new(0, 10, 0, 120), "Wall Transparency", 10, 90, Config.WallHack.Transparency * 100, Config.WallHack, "Transparency", "%")
    
    -- Update canvas size based on content
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 680)
end

-- Function to apply wall hack effect
local function ApplyWallHack()
    if Config.WallHack.Enabled then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(Player.Character) and not part.Name == "HumanoidRootPart" then
                if not part:FindFirstChild("OriginalTransparency") then
                    local originalValue = Instance.new("NumberValue")
                    originalValue.Name = "OriginalTransparency"
                    originalValue.Value = part.Transparency
                    originalValue.Parent = part
                end
                part.Transparency = Config.WallHack.Transparency
            end
        end
    else
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part:FindFirstChild("OriginalTransparency") then
                part.Transparency = part.OriginalTransparency.Value
            end
        end
    end
end

-- Function to apply ESP (player boxes)
local function ApplyESP()
    -- Clear existing ESP
    for _, gui in pairs(Player.PlayerGui:GetChildren()) do
        if gui.Name == "ESPGui" then
            gui:Destroy()
        end
    end
    
    if not Config.ESP.Enabled then return end
    
    local ESPGui = Instance.new("ScreenGui")
    ESPGui.Name = "ESPGui"
    ESPGui.ResetOnSpawn = false
    ESPGui.Parent = Player.PlayerGui
    
    local function CreateESPBox(character)
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        local playerName = "Unknown"
        local targetPlayer = game:GetService("Players"):GetPlayerFromCharacter(character)
        if targetPlayer then playerName = targetPlayer.Name end
        
        local espBox = Instance.new("Frame")
        espBox.Name = "ESPBox_" .. playerName
        espBox.BackgroundTransparency = 1
        espBox.BorderSizePixel = 0
        espBox.BackgroundColor3 = Config.ESP.Color
        espBox.Parent = ESPGui
        
        local outline = Instance.new("Frame")
        outline.Name = "Outline"
        outline.BackgroundTransparency = 0.5
        outline.BorderSizePixel = 0
        outline.BackgroundColor3 = Config.ESP.Color
        outline.Size = UDim2.new(1, 0, 1, 0)
        outline.Parent = espBox
        
        local infoText = Instance.new("TextLabel")
        infoText.Name = "Info"
        infoText.Size = UDim2.new(1, 0, 0, 20)
        infoText.Position = UDim2.new(0, 0, 0, -25)
        infoText.BackgroundTransparency = 0.5
        infoText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        infoText.TextColor3 = Config.ESP.Color
        infoText.TextSize = 12
        infoText.Font = Enum.Font.SourceSansBold
        infoText.Parent = espBox
        
        local function UpdateESP()
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            
            -- Calculate 3D box corners
            local hrpCFrame = rootPart.CFrame
            local size = character:GetExtentsSize()
            
            -- Get corners in world space
            local corners = {
                hrpCFrame * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2),
                hrpCFrame * CFrame.new(-size.X/2, -size.Y/2, size.Z/2),
                hrpCFrame * CFrame.new(-size.X/2, size.Y/2, -size.Z/2),
                hrpCFrame * CFrame.new(-size.X/2, size.Y/2, size.Z/2),
                hrpCFrame * CFrame.new(size.X/2, -size.Y/2, -size.Z/2),
                hrpCFrame * CFrame.new(size.X/2, -size.Y/2, size.Z/2),
                hrpCFrame * CFrame.new(size.X/2, size.Y/2, -size.Z/2),
                hrpCFrame * CFrame.new(size.X/2, size.Y/2, size.Z/2),
            }
            
            -- Convert to 2D screen space
            local minX, minY = math.huge, math.huge
            local maxX, maxY = -math.huge, -math.huge
            
            for _, corner in pairs(corners) do
                local screenPoint = Camera:WorldToScreenPoint(corner.Position)
                if screenPoint.Z > 0 then
                    minX = math.min(minX, screenPoint.X)
                    minY = math.min(minY, screenPoint.Y)
                    maxX = math.max(maxX, screenPoint.X)
                    maxY = math.max(maxY, screenPoint.Y)
                end
            end
            
            -- Check if behind camera
            if minX ~= math.huge and maxX ~= -math.huge then
                -- Update ESP box position and size
                espBox.Position = UDim2.new(0, minX, 0, minY)
                espBox.Size = UDim2.new(0, maxX - minX, 0, maxY - minY)
                
                -- Update info text
                local info = ""
                
                if Config.ESP.ShowName then
                    info = info .. playerName .. "\n"
                end
                
                if Config.ESP.ShowHealth and humanoid then
                    info = info .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) .. " HP\n"
                end
                
                if Config.ESP.ShowDistance then
                    local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
                    info = info .. math.floor(distance) .. " studs"
                end
                
                infoText.Text = info
                espBox.Visible = true
            else
                espBox.Visible = false
            end
        end
        
        RunService:BindToRenderStep("ESP_" .. playerName, 201, UpdateESP)
        
        return espBox
    end
    
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= Player and player.Character then
            CreateESPBox(player.Character)
        end
    end
    
    game:GetService("Players").PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            CreateESPBox(character)
        end)
    end)
end

-- Function to apply aimbot functionality
local function ApplyAimbot()
    if Config.Aimbot.CurrentTarget and Config.Aimbot.LockTarget then
        return -- Keep current locked target
    end

    if not Config.Aimbot.Enabled then
        Config.Aimbot.CurrentTarget = nil
        return
    end
    
    -- Find closest player to aim at
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local targetPart = player.Character:FindFirstChild(Config.Aimbot.Target) or player.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                -- Check visibility if needed
                local visible = true
                if Config.Aimbot.VisibleOnly then
                    local ray = Ray.new(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position)
                    local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {Player.Character})
                    visible = (not hit or hit:IsDescendantOf(player.Character))
                end
                
                if visible then
                    local screenPoint = Camera:WorldToScreenPoint(targetPart.Position)
                    if screenPoint.Z > 0 then -- In front of camera
                        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude
                        
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = {
                                Character = player.Character,
                                Part = targetPart
                            }
                        end
                    end
                end
            end
        end
    end
    
    Config.Aimbot.CurrentTarget = closestPlayer
end

-- Function to apply teleport
local function ApplyTeleport()
    if not Config.Teleport.Enabled or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local target = nil
    
    if Config.Teleport.Type == "Player" then
        -- Try to use locked target first
        if Config.Aimbot.LockTarget and Config.Aimbot.CurrentTarget then
            target = Config.Aimbot.CurrentTarget.Part.Position
        elseif Config.Aimbot.CurrentTarget then
            target = Config.Aimbot.CurrentTarget.Part.Position
        end
    elseif Config.Teleport.Type == "Location" then
        -- Get mouse hit position
        local hit = Mouse.Hit
        target = hit.Position
    end
    
    if target then
        Player.Character.HumanoidRootPart.CFrame = CFrame.new(target)
    end
end

-- Function to apply enhanced jump
local function ApplyJump()
    if not Config.Jump.Enabled or not Player.Character or not Player.Character:FindFirstChild("Humanoid") then
        return
    end
    
    Player.Character.Humanoid.JumpPower = 50 * Config.Jump.Height
end

-- Function to apply flying
local function ApplyFlying()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") or not Player.Character:FindFirstChild("Humanoid") then
        return
    end
    
    local flyPart = Player.Character:FindFirstChild("FlyPart")
    
    if Config.Flight.Enabled then
        if not flyPart then
            flyPart = Instance.new("BodyVelocity")
            flyPart.Name = "FlyPart"
            flyPart.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyPart.Velocity = Vector3.new(0, 0, 0)
            flyPart.Parent = Player.Character.HumanoidRootPart
            
            Player.Character.Humanoid.PlatformStand = true
        end
        
        local speed = Config.Flight.Speed * 10
        
        -- Calculate movement direction based on camera orientation
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        -- Normalize and scale by speed
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * speed
        end
        
        flyPart.Velocity = moveDirection
    else
        if flyPart then
            flyPart:Destroy()
            Player.Character.Humanoid.PlatformStand = false
        end
    end
end

-- Keyboard input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        -- Toggle menu visibility
        Config.MenuVisible = not Config.MenuVisible
        ModMenu.Visible = Config.MenuVisible
    elseif input.KeyCode == Enum.KeyCode.F then
        -- Toggle flight
        Config.Flight.Enabled = not Config.Flight.Enabled
    elseif input.KeyCode == Enum.KeyCode.L then
        -- Lock/unlock target
        if Config.Aimbot.Enabled and Config.Aimbot.CurrentTarget then
            Config.Aimbot.LockTarget = not Config.Aimbot.LockTarget
        end
    elseif input.KeyCode == Enum.KeyCode.T then
        -- Teleport to target
        if Config.Teleport.Enabled then
            ApplyTeleport()
        end
    end
end)

-- Main loop to apply features
RunService.RenderStepped:Connect(function()
    ApplyJump()
    ApplyFlying()
    ApplyAimbot()
    ApplyWallHack()
end)

-- Create the GUI
CreateModMenuContent()
ApplyESP() -- Initialize ESP

print("Roblox Mod Menu loaded successfully")