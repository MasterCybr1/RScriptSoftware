local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local FlyState = {
    Active = false,
    Speed = 50,
    BodyVelocity = nil,
    BodyGyro = nil,
    Connection = nil
}

local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local ScreenGui = CreateInstance("ScreenGui", {
    Name = "FlyGui",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = LocalPlayer:WaitForChild("PlayerGui")
})

local MainFrame = CreateInstance("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 220, 0, 110),
    Position = UDim2.new(0.5, -110, 0.3, -55),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.65,
    BorderSizePixel = 0,
    Active = false,
    Parent = ScreenGui
})

CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 8),
    Parent = MainFrame
})

local TitleBar = CreateInstance("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Active = true,
    Parent = MainFrame
})

local DragData = {
    Dragging = false,
    DragInput = nil,
    DragStart = nil,
    StartPos = nil
}

local function UpdateDrag(input)
    local delta = input.Position - DragData.DragStart
    MainFrame.Position = UDim2.new(
        DragData.StartPos.X.Scale,
        DragData.StartPos.X.Offset + delta.X,
        DragData.StartPos.Y.Scale,
        DragData.StartPos.Y.Offset + delta.Y
    )
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        DragData.Dragging = true
        DragData.DragStart = input.Position
        DragData.StartPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                DragData.Dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        DragData.DragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragData.DragInput and DragData.Dragging then
        UpdateDrag(input)
    end
end)

CreateInstance("TextLabel", {
    Name = "SoftwareTitle",
    Size = UDim2.new(0, 100, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text = "RScriptSoftware",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTransparency = 0.3,
    Parent = TitleBar
})

CreateInstance("TextLabel", {
    Name = "FlyTitle",
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.new(0, 50, 0, 0),
    BackgroundTransparency = 1,
    Text = "Fly",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Center,
    Parent = TitleBar
})

local CloseButton = CreateInstance("TextButton", {
    Name = "CloseButton",
    Size = UDim2.new(0, 24, 0, 24),
    Position = UDim2.new(1, -28, 0, 3),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    Text = "X",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    Parent = TitleBar
})

CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 4),
    Parent = CloseButton
})

local MinimizeButton = CreateInstance("TextButton", {
    Name = "MinimizeButton",
    Size = UDim2.new(0, 24, 0, 24),
    Position = UDim2.new(1, -56, 0, 3),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    Text = "-",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    Parent = TitleBar
})

CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 4),
    Parent = MinimizeButton
})

local ToggleButton = CreateInstance("TextButton", {
    Name = "ToggleButton",
    Size = UDim2.new(0, 90, 0, 28),
    Position = UDim2.new(0.5, -45, 0, 38),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    Text = "Fly: OFF",
    TextColor3 = Color3.fromRGB(255, 60, 60),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    Parent = MainFrame
})

CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = ToggleButton
})

local SpeedLabel = CreateInstance("TextLabel", {
    Name = "SpeedLabel",
    Size = UDim2.new(1, -16, 0, 18),
    Position = UDim2.new(0, 8, 0, 71),
    BackgroundTransparency = 1,
    Text = "Speed: 50",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = MainFrame
})

local SliderFrame = CreateInstance("Frame", {
    Name = "SliderFrame",
    Size = UDim2.new(1, -16, 0, 5),
    Position = UDim2.new(0, 8, 0, 94),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    Parent = MainFrame
})

CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 3),
    Parent = SliderFrame
})

local SliderFill = CreateInstance("Frame", {
    Name = "SliderFill",
    Size = UDim2.new(0.25, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    Parent = SliderFrame
})

CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 3),
    Parent = SliderFill
})

local function DisableFly()
    FlyState.Active = false
    
    if Humanoid then
        Humanoid.PlatformStand = false
    end
    
    if FlyState.BodyVelocity then
        FlyState.BodyVelocity:Destroy()
        FlyState.BodyVelocity = nil
    end
    
    if FlyState.BodyGyro then
        FlyState.BodyGyro:Destroy()
        FlyState.BodyGyro = nil
    end
    
    if FlyState.Connection then
        FlyState.Connection:Disconnect()
        FlyState.Connection = nil
    end
end

local function EnableFly()
    if not Character or not RootPart or not Humanoid then return end
    
    FlyState.Active = true
    Humanoid.PlatformStand = true
    
    FlyState.BodyVelocity = CreateInstance("BodyVelocity", {
        Velocity = Vector3.new(0, 0, 0),
        MaxForce = Vector3.new(9e9, 9e9, 9e9),
        Parent = RootPart
    })
    
    FlyState.BodyGyro = CreateInstance("BodyGyro", {
        MaxTorque = Vector3.new(9e9, 9e9, 9e9),
        P = 9e4,
        CFrame = RootPart.CFrame,
        Parent = RootPart
    })
    
    local Camera = workspace.CurrentCamera
    
    FlyState.Connection = RunService.Heartbeat:Connect(function()
        if not FlyState.Active or not Character or not RootPart or not Humanoid then
            DisableFly()
            return
        end
        
        if not Humanoid.PlatformStand then
            Humanoid.PlatformStand = true
        end
        
        local MoveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            MoveDirection = MoveDirection + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            MoveDirection = MoveDirection - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            MoveDirection = MoveDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            MoveDirection = MoveDirection + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            MoveDirection = MoveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            MoveDirection = MoveDirection - Vector3.new(0, 1, 0)
        end
        
        if MoveDirection.Magnitude > 0 then
            MoveDirection = MoveDirection.Unit
        end
        
        FlyState.BodyVelocity.Velocity = MoveDirection * FlyState.Speed
        FlyState.BodyGyro.CFrame = Camera.CFrame
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    if FlyState.Active then
        DisableFly()
        ToggleButton.Text = "Fly: OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 60, 60)
    else
        EnableFly()
        ToggleButton.Text = "Fly: ON"
        ToggleButton.TextColor3 = Color3.fromRGB(60, 255, 60)
    end
end)

local SliderData = {
    Dragging = false
}

SliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        SliderData.Dragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        SliderData.Dragging = false
    end
end)

UserInputService.TouchEnded:Connect(function()
    SliderData.Dragging = false
end)

UserInputService.InputChanged:Connect(function(input)
    if SliderData.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Relative = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
        FlyState.Speed = math.floor(Relative * 200)
        SliderFill.Size = UDim2.new(Relative, 0, 1, 0)
        SpeedLabel.Text = "Speed: " .. FlyState.Speed
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    DisableFly()
    ScreenGui:Destroy()
end)

local MinimizeState = {
    Minimized = false,
    NormalSize = UDim2.new(0, 220
