local player = game.Players.LocalPlayer
local players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()
local notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/Universal-Scripts/main/Notification%20Function", true))()
Notify("This Script Is Fully Open-Source. Feel Free To Use It!")

local Window = Rayfield:CreateWindow({
    Name = "NotUgur Universal Script",
    LoadingTitle = "An Universal Script I made because I'm bored and it's easy to make.",
    LoadingSubtitle = "NotUgur",
})

local Tab = Window:CreateTab("Universal", 4483362458)

-- Variables
local boxESPObjects = {}
local nameESPObjects = {}
local noclipEnabled = false
local antiFlingEnabled = false
local boxESPEnabled = false
local nameESPEnabled = false

-- Box ESP 
local function createBoxESP(plr)
    local char = plr.Character or plr.CharacterAdded:Wait()
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 2
    box.Transparency = 1
    boxESPObjects[plr] = box
    
    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.Text = plr.Name
    nameTag.Size = 16
    nameTag.Center = true
    nameTag.Outline = true
    nameESPObjects[plr] = nameTag
    

    RunService.RenderStepped:Connect(function()
        if not plr or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            box.Visible = false
            nameTag.Visible = false
            return
        end
        
        local rootPart = plr.Character.HumanoidRootPart
        local screenPos, onScreen = Workspace.CurrentCamera:WorldToScreenPoint(rootPart.Position)
        
        if onScreen then
            box.Visible = boxESPEnabled
            nameTag.Visible = nameESPEnabled


            local size = Vector2.new(50, 100)  
            box.Position = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
            box.Size = size
            

            nameTag.Position = Vector2.new(screenPos.X, screenPos.Y - size.Y / 2 - 20)
        else
            box.Visible = false
            nameTag.Visible = false
        end
    end)
end


for _, plr in pairs(players:GetPlayers()) do
    if plr ~= player then
        createBoxESP(plr)
    end
end


players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        plr.CharacterAdded:Connect(function()
            createBoxESP(plr)
        end)
    end
end)


players.PlayerRemoving:Connect(function(plr)
    if boxESPObjects[plr] then
        boxESPObjects[plr]:Remove()
        boxESPObjects[plr] = nil
    end
    if nameESPObjects[plr] then
        nameESPObjects[plr]:Remove()
        nameESPObjects[plr] = nil
    end
end)


-- Walkspeed slider
local WalkspeedModifier = Tab:CreateSlider({
    Name = "WalkSpeed",
    Info = "Changes WalkSpeed",
    Range = {1, 1000},
    Increment = 1,
    Suffix = "WalkSpeed",
    Flag = "Slider",
    CurrentValue = player.Character.Humanoid.WalkSpeed,
    Callback = function(Value)
        player.Character.Humanoid.WalkSpeed = Value
    end
})

-- JumpPower slider
local JumpPowerModifier = Tab:CreateSlider({
    Name = "JumpPower",
    Info = "Changes JumpPower",
    Range = {1, 1000},
    Increment = 1,
    Suffix = "JumpPower",
    Flag = "Slider2",
    CurrentValue = player.Character.Humanoid.JumpPower,
    Callback = function(Value)
        player.Character.Humanoid.JumpPower = Value
    end
})

-- Gravity slider
local GravityModifier = Tab:CreateSlider({
    Name = "Gravity",
    Info = "Changes the gravity",
    Range = {0, 1000},
    Increment = 1,
    Suffix = "Gravity",
    CurrentValue = Workspace.Gravity,
    Flag = "Slider3",
    Callback = function(Value)
        Workspace.Gravity = Value
    end
})

-- Noclip Function
local function toggleNoclip()
    RunService.Stepped:Connect(function()
        if noclipEnabled then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        else
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and not part.CanCollide then
                    part.CanCollide = true
                end
            end
        end
    end)
end

-- Noclip Toggle
Tab:CreateToggle({
    Name = "Toggle Noclip",
    Info = "Toggles Noclip",
    CurrentValue = false,
    Callback = function(state)
        noclipEnabled = state
        toggleNoclip()
    end
})

-- Anti-Fling
local function AntiFling()
    local HeartbeatLoop
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    local function applyAntiFling(part)
        if part and part:IsA("BasePart") then
            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)  
            part.Velocity = Vector3.new(0, 0, 0)  
            part.RotVelocity = Vector3.new(0, 0, 0)  
            part.CanCollide = false  
        end
    end


    local function startAntiFling()
        if humanoidRootPart then
            HeartbeatLoop = RunService.Heartbeat:Connect(function()
                applyAntiFling(humanoidRootPart)
            end)
        end
    end


    local function stopAntiFling()
        if HeartbeatLoop then
            HeartbeatLoop:Disconnect()
            HeartbeatLoop = nil
        end
    end


    player.CharacterAdded:Connect(function()
        stopAntiFling()
        startAntiFling()
    end)


    if humanoidRootPart then
        startAntiFling()
    end

    workspace.DescendantAdded:Connect(function(part)
        if part and part:IsA("BasePart") and part.Name == "HumanoidRootPart" and part.Parent ~= player.Character then
            wait(2)
            applyAntiFling(part)
        end
    end)
end

-- Anti-Fling Toggle
Tab:CreateToggle({
    Name = "Toggle Anti-Fling",
    Info = "Toggles Anti-Fling",
    CurrentValue = false,
    Callback = function(state)
        antiFlingEnabled = state
        if antiFlingEnabled then
            AntiFling() 
        else
            local player = game.Players.LocalPlayer
            local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CanCollide = true  
            end
        end
    end
})

-- Box ESP Toggle
Tab:CreateToggle({
    Name = "Toggle Box ESP",
    Info = "Toggles Box ESP",
    CurrentValue = false,
    Callback = function(state)
        boxESPEnabled = state
        for _, box in pairs(boxESPObjects) do
            box.Visible = boxESPEnabled
        end
    end
})

-- Name ESP Toggle
Tab:CreateToggle({
    Name = "Toggle Name ESP",
    Info = "Toggles Name ESP",
    CurrentValue = false,
    Callback = function(state)
        nameESPEnabled = state
        for _, nameTag in pairs(nameESPObjects) do
            nameTag.Visible = nameESPEnabled
        end
    end
})
