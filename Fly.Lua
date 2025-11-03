-- Roblox Fly GUI Script
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local flying = false
local flySpeed = 50
local bodyVelocity
local bodyGyro
local flyConnection

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 110)
mainFrame.Position = UDim2.new(0.5, -110, 0.3, -55)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.65
mainFrame.BorderSizePixel = 0
mainFrame.Active = false
mainFrame.Draggable = false
mainFrame.Parent = screenGui

-- Add UICorner to main frame
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Create Title Bar (invisible background but draggable)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundTransparency = 1
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.Parent = mainFrame

-- Make titlebar draggable for all devices
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- RScriptSoftware Title (left corner)
local softwareTitle = Instance.new("TextLabel")
softwareTitle.Name = "SoftwareTitle"
softwareTitle.Size = UDim2.new(0, 100, 1, 0)
softwareTitle.Position = UDim2.new(0, 8, 0, 0)
softwareTitle.BackgroundTransparency = 1
softwareTitle.Text = "RScriptSoftware"
softwareTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
softwareTitle.TextSize = 9
softwareTitle.Font = Enum.Font.GothamBold
softwareTitle.TextXAlignment = Enum.TextXAlignment.Left
softwareTitle.TextTransparency = 0.3
softwareTitle.Parent = titleBar

-- Fly Title (center)
local flyTitle = Instance.new("TextLabel")
flyTitle.Name = "FlyTitle"
flyTitle.Size = UDim2.new(1, -100, 1, 0)
flyTitle.Position = UDim2.new(0, 50, 0, 0)
flyTitle.BackgroundTransparency = 1
flyTitle.Text = "Fly"
flyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyTitle.TextSize = 15
flyTitle.Font = Enum.Font.GothamBold
flyTitle.TextXAlignment = Enum.TextXAlignment.Center
flyTitle.Parent = titleBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -28, 0, 3)
closeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closeButton.BackgroundTransparency = 0.4
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 13
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 24, 0, 24)
minimizeButton.Position = UDim2.new(1, -56, 0, 3)
minimizeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
minimizeButton.BackgroundTransparency = 0.4
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 13
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 4)
minimizeCorner.Parent = minimizeButton

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 90, 0, 28)
toggleButton.Position = UDim2.new(0.5, -45, 0, 38)
toggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
toggleButton.BackgroundTransparency = 0.3
toggleButton.BorderSizePixel = 0
toggleButton.Text = "Fly: OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 60, 60)
toggleButton.TextSize = 13
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Speed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, -16, 0, 18)
speedLabel.Position = UDim2.new(0, 8, 0, 71)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 50"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 11
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

-- Speed Slider
local sliderFrame = Instance.new("Frame")
sliderFrame.Name = "SliderFrame"
sliderFrame.Size = UDim2.new(1, -16, 0, 5)
sliderFrame.Position = UDim2.new(0, 8, 0, 94)
sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sliderFrame.BackgroundTransparency = 0.3
sliderFrame.BorderSizePixel = 0
sliderFrame.Parent = mainFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 3)
sliderCorner.Parent = sliderFrame

local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.Size = UDim2.new(0.25, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderFill.BackgroundTransparency = 0.2
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderFrame

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 3)
fillCorner.Parent = sliderFill

-- Fly Functions
local function stopFlying()
    flying = false
    
    -- Re-enable normal humanoid state
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end

local function startFlying()
    if not character or not rootPart or not humanoid then return end
    
    flying = true
    
    -- Enable PlatformStand to prevent falling animation
    humanoid.PlatformStand = true
    
    -- Create BodyVelocity
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = rootPart
    
    -- Create BodyGyro
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e4
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    -- Fly Loop
    local camera = workspace.CurrentCamera
    local userInputService = game:GetService("UserInputService")
    
    flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not flying or not character or not rootPart or not humanoid then
            stopFlying()
            return
        end
        
        -- Ensure PlatformStand stays enabled
        if not humanoid.PlatformStand then
            humanoid.PlatformStand = true
        end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- Get input for flying in all directions
        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (camera.CFrame.LookVector)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (camera.CFrame.LookVector)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - (camera.CFrame.RightVector)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + (camera.CFrame.RightVector)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) or userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        -- Apply velocity
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end
        
        bodyVelocity.Velocity = moveDirection * flySpeed
        bodyGyro.CFrame = camera.CFrame
    end)
end

-- Toggle Button Click
toggleButton.MouseButton1Click:Connect(function()
    if flying then
        stopFlying()
        toggleButton.Text = "Fly: OFF"
        toggleButton.TextColor3 = Color3.fromRGB(255, 60, 60)
    else
        startFlying()
        toggleButton.Text = "Fly: ON"
        toggleButton.TextColor3 = Color3.fromRGB(60, 255, 60)
    end
end)

-- Speed Slider
local draggingSlider = false

sliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

game:GetService("UserInputService").TouchEnded:Connect(function(input)
    draggingSlider = false
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position.X
        local framePos = sliderFrame.AbsolutePosition.X
        local frameSize = sliderFrame.AbsoluteSize.X
        
        local relative = math.clamp((mousePos - framePos) / frameSize, 0, 1)
        flySpeed = math.floor(relative * 200)
        
        sliderFill.Size = UDim2.new(relative, 0, 1, 0)
        speedLabel.Text = "Speed: " .. flySpeed
    end
end)

-- Close Button
closeButton.MouseButton1Click:Connect(function()
    stopFlying()
    screenGui:Destroy()
end)

-- Minimize Button
local minimized = false
local normalSize = UDim2.new(0, 220, 0, 110)
local minimizedSize = UDim2.new(0, 220, 0, 30)

minimizeButton.MouseButton1Click:Connect(function()
    if minimized then
        mainFrame.Size = normalSize
        minimizeButton.Text = "-"
        minimized = false
    else
        mainFrame.Size = minimizedSize
        minimizeButton.Text = "+"
        minimized = true
    end
end)

-- Character Reset Handler
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    stopFlying()
    toggleButton.Text = "Fly: OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 60, 60)
end)

-- Clean up on script removal
screenGui.AncestryChanged:Connect(function()
    if not screenGui.Parent then
        stopFlying()
    end
end)
