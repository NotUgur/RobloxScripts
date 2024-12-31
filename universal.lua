-- Updated at 31.12.2024 20:06 PM
-- Added Silent-Aim (May not work i will fix it)
-- Added Hitbox Expander (Works Fully)
-- Changed GUI To Rayfield
-- Changed Aimbot Technique (May change it back cuz theres no reason)

-- Services
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local Window = Rayfield:CreateWindow({
    Name = "Universal Script By NotUgur",
    LoadingTitle = "Made By NotUgur With Love",
    LoadingSubtitle = "NotUgur",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "UniversalScript",
        FileName = "Config"
    },
    Discord = {
        Enabled = true,
        Invite = "4bKRus6M",
        RememberJoins = true
    }
})

Rayfield:Notify({
    Title = "Join The Discord",
    Content = "",
    Duration = 10,
    Type = "."
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat")

-- Combat Config
local CombatConfig = {
    SilentAim = {
        Enabled = false,
        TargetPart = "Head",
        HitChance = 100
    },
    Aimbot = {
        Enabled = false,
        TeamCheck = false,
        TargetPart = "Head",
        Smoothness = 0.5,
        Prediction = {
            Enabled = false,
            Multiplier = 0.165
        }
    },
    HitboxExpander = {
        Enabled = false,
        Size = 30,
        Transparency = 1,
        Parts = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
    }
}

-- Hitbox Update
local function UpdateHitboxes()
    if not CombatConfig.HitboxExpander.Enabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            pcall(function()
                if player.Character then
                    for _, partName in pairs(CombatConfig.HitboxExpander.Parts) do
                        local part = player.Character:FindFirstChild(partName)
                        if part and part:IsA("BasePart") then
                            part.Size = Vector3.new(30, 30, 30)
                            part.Transparency = 1
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
end

-- Hitbox Reset
local function ResetHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            pcall(function()
                if player.Character then
                    for _, partName in pairs(CombatConfig.HitboxExpander.Parts) do
                        local part = player.Character:FindFirstChild(partName)
                        if part and part:IsA("BasePart") then
                            if partName == "Head" then
                                part.Size = Vector3.new(2, 1, 1)
                            elseif partName == "HumanoidRootPart" then
                                part.Size = Vector3.new(2, 2, 1)
                            elseif partName == "Torso" then
                                part.Size = Vector3.new(2, 2, 1)
                            else
                                part.Size = Vector3.new(1, 2, 1)
                            end
                            part.Transparency = 0
                            part.Material = Enum.Material.Plastic
                            part.BrickColor = player.Character.Torso.BrickColor
                        end
                    end
                end
            end)
        end
    end
end

-- Combat Tab UI Elements
CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "SilentAimToggle",
    Callback = function(Value)
        CombatConfig.SilentAim.Enabled = Value
    end
})

CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        CombatConfig.Aimbot.Enabled = Value
    end
})

CombatTab:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,
    Flag = "HitboxToggle",
    Callback = function(Value)
        CombatConfig.HitboxExpander.Enabled = Value
        if Value then
            UpdateHitboxes()
        else
            ResetHitboxes()
        end
    end
})

-- ESP Ayarları
local ESPConfig = {
    Enabled = false,
    BoxESP = false,
    NameESP = false,
    TracerESP = false,
    TeamCheck = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    TracerColor = Color3.fromRGB(255, 255, 255),
    TextColor = Color3.fromRGB(255, 255, 255)
}

-- ESP Çizimleri
local ESP = {
    Boxes = {},
    Names = {},
    Tracers = {}
}

-- ESP Fonksiyonları
local function CreateESPBox(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = ESPConfig.BoxColor
    box.Thickness = 1
    box.Transparency = 1
    box.Filled = false
    ESP.Boxes[player] = box
    
    local name = Drawing.new("Text")
    name.Visible = false
    name.Color = ESPConfig.TextColor
    name.Size = 14
    name.Center = true
    name.Outline = true
    ESP.Names[player] = name
    
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = ESPConfig.TracerColor
    tracer.Thickness = 1
    tracer.Transparency = 1
    ESP.Tracers[player] = tracer
end

-- ESP Temizleme
local function CleanupESP(player)
    if ESP.Boxes[player] then
        ESP.Boxes[player]:Remove()
        ESP.Boxes[player] = nil
    end
    if ESP.Names[player] then
        ESP.Names[player]:Remove()
        ESP.Names[player] = nil
    end
    if ESP.Tracers[player] then
        ESP.Tracers[player]:Remove()
        ESP.Tracers[player] = nil
    end
end

-- ESP Update
local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if ESPConfig.TeamCheck and player.Team == LocalPlayer.Team then
                if ESP.Boxes[player] then ESP.Boxes[player].Visible = false end
                if ESP.Names[player] then ESP.Names[player].Visible = false end
                if ESP.Tracers[player] then ESP.Tracers[player].Visible = false end
                continue
            end
            
            if not ESP.Boxes[player] then
                CreateESPBox(player)
            end
            
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                local head = player.Character:FindFirstChild("Head")
                if not head then continue end
                
                local Vector, OnScreen = Camera:WorldToViewportPoint(hrp.Position)
                if OnScreen then
                    -- Box ESP
                    if ESPConfig.BoxESP then
                        local box = ESP.Boxes[player]
                        box.Size = Vector2.new(1000 / Vector.Z, 2000 / Vector.Z)
                        box.Position = Vector2.new(Vector.X - box.Size.X / 2, Vector.Y - box.Size.Y / 2)
                        box.Visible = true
                    else
                        ESP.Boxes[player].Visible = false
                    end
                    
                    -- Name ESP
                    if ESPConfig.NameESP then
                        local name = ESP.Names[player]
                        name.Position = Vector2.new(Vector.X, Vector.Y - 40)
                        name.Text = player.Name
                        name.Visible = true
                    else
                        ESP.Names[player].Visible = false
                    end
                    
                    -- Tracer ESP
                    if ESPConfig.TracerESP then
                        local tracer = ESP.Tracers[player]
                        tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        tracer.To = Vector2.new(Vector.X, Vector.Y)
                        tracer.Visible = true
                    else
                        ESP.Tracers[player].Visible = false
                    end
                else
                    ESP.Boxes[player].Visible = false
                    ESP.Names[player].Visible = false
                    ESP.Tracers[player].Visible = false
                end
            end
        end
    end
end

-- ESP Tab
local VisualsTab = Window:CreateTab("Visuals")

VisualsTab:CreateToggle({
    Name = "ESP Enabled",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(Value)
        ESPConfig.Enabled = Value
    end
})

VisualsTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "BoxESP",
    Callback = function(Value)
        ESPConfig.BoxESP = Value
    end
})

VisualsTab:CreateToggle({
    Name = "Name ESP",
    CurrentValue = false,
    Flag = "NameESP",
    Callback = function(Value)
        ESPConfig.NameESP = Value
    end
})

VisualsTab:CreateToggle({
    Name = "Tracer ESP",
    CurrentValue = false,
    Flag = "TracerESP",
    Callback = function(Value)
        ESPConfig.TracerESP = Value
    end
})

VisualsTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Flag = "ESPTeamCheck",
    Callback = function(Value)
        ESPConfig.TeamCheck = Value
    end
})

-- ESP Update Loop
RunService.RenderStepped:Connect(function()
    if ESPConfig.Enabled then
        UpdateESP()
    end
end)

-- Player Events for ESP
Players.PlayerAdded:Connect(function(player)
    if ESPConfig.Enabled then
        CreateESPBox(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    CleanupESP(player)
end)

-- Movement Config ekle
local MovementConfig = {
    WalkSpeed = {
        Enabled = false,
        Speed = 16
    },
    JumpPower = {
        Enabled = false,
        Power = 50
    },
    Gravity = {
        Enabled = false,
        Value = 196.2
    },
    Fly = {
        Enabled = false,
        Speed = 50
    },
    Noclip = {
        Enabled = false
    }
}

-- Silent Aim function
local function GetClosestPlayer()
    local MaxDistance = math.huge
    local Target = nil
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
            
            if magnitude < MaxDistance then
                MaxDistance = magnitude
                Target = player.Character.HumanoidRootPart
            end
        end
    end
    
    return Target
end

-- Silent Aim Hook
local oldNameCall = nil
oldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if CombatConfig.SilentAim.Enabled and (Method == "FindPartOnRayWithIgnoreList" or Method == "Raycast") then
        local Target = GetClosestPlayer()
        if Target then
            Args[1] = Ray.new(Camera.CFrame.Position, (Target.Position - Camera.CFrame.Position).Unit * 1000)
            return oldNameCall(self, unpack(Args))
        end
    end
    
    return oldNameCall(self, ...)
end))

-- Aimbot Update
RunService.RenderStepped:Connect(function()
    if CombatConfig.Aimbot.Enabled then
        local Target = GetClosestPlayer()
        if Target then
            local TargetPos = Target.Position
            if CombatConfig.Aimbot.Prediction.Enabled then
                TargetPos = TargetPos + (Target.Velocity * CombatConfig.Aimbot.Prediction.Multiplier)
            end
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, TargetPos), CombatConfig.Aimbot.Smoothness)
        end
    end
end)

-- Movement Tab
local MovementTab = Window:CreateTab("Movement")

MovementTab:CreateToggle({
    Name = "WalkSpeed",
    CurrentValue = false,
    Flag = "WalkSpeedToggle",
    Callback = function(Value)
        MovementConfig.WalkSpeed.Enabled = Value
    end
})

MovementTab:CreateSlider({
    Name = "WalkSpeed Value",
    Range = {16, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        MovementConfig.WalkSpeed.Speed = Value
    end
})

MovementTab:CreateToggle({
    Name = "JumpPower",
    CurrentValue = false,
    Flag = "JumpPowerToggle",
    Callback = function(Value)
        MovementConfig.JumpPower.Enabled = Value
    end
})

MovementTab:CreateSlider({
    Name = "JumpPower Value",
    Range = {50, 500},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        MovementConfig.JumpPower.Power = Value
    end
})

MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        MovementConfig.Fly.Enabled = Value
    end
})

MovementTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(Value)
        MovementConfig.Fly.Speed = Value
    end
})

MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        MovementConfig.Noclip.Enabled = Value
    end
})

-- Movement Update
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Humanoid = LocalPlayer.Character.Humanoid
        
        -- WalkSpeed
        if MovementConfig.WalkSpeed.Enabled then
            Humanoid.WalkSpeed = MovementConfig.WalkSpeed.Speed
        end
        
        -- JumpPower
        if MovementConfig.JumpPower.Enabled then
            Humanoid.JumpPower = MovementConfig.JumpPower.Power
        end
        
        -- Fly
        if MovementConfig.Fly.Enabled then
            local RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if RootPart then
                local Direction = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    Direction = Direction + Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    Direction = Direction - Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    Direction = Direction - Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    Direction = Direction + Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    Direction = Direction + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    Direction = Direction - Vector3.new(0, 1, 0)
                end
                RootPart.Velocity = Direction.Unit * MovementConfig.Fly.Speed
            end
        end
        
        -- Noclip
        if MovementConfig.Noclip.Enabled then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Hitbox Update Loop
RunService.Heartbeat:Connect(function()
    if CombatConfig.HitboxExpander.Enabled then
        UpdateHitboxes()
    end
end)

-- Player Added Event için Hitbox kontrolü
Players.PlayerAdded:Connect(function(player)
    if CombatConfig.HitboxExpander.Enabled then
        player.CharacterAdded:Connect(function(character)
            task.wait(1)
            UpdateHitboxes()
        end)
    end
end)

