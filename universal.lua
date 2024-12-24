-- Updated 24.12.2024 at 03:12am GMT +3:00.
-- Added Teleport To Player Function.
-- Fixed Name-ESP and Box-ESP.
-- Removed the Anti-Fling feature because it was too buggy.

local player = game:GetService("Players").LocalPlayer
local players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()
local Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/Universal-Scripts/main/Notification%20Function", true))()


local Window = Rayfield:CreateWindow({
    Name = "NotUgur Universal Script",
    LoadingTitle = "Loading Script...",
    LoadingSubtitle = "by NotUgur",
})

local Tab = Window:CreateTab("Main Features")

-- Variables
local noclipEnabled = false
local boxESPEnabled = false
local nameESPEnabled = false
local boxESPObjects = {}
local nameESPObjects = {}

-- WalkSpeed Slider
Tab:CreateSlider({
    Name = "WalkSpeed",
    Info = "Change your WalkSpeed.",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = player.Character.Humanoid.WalkSpeed,
    Callback = function(Value)
        player.Character.Humanoid.WalkSpeed = Value
    end
})

-- JumpPower Slider
Tab:CreateSlider({
    Name = "JumpPower",
    Info = "Change your JumpPower.",
    Range = {50, 500},
    Increment = 1,
    CurrentValue = player.Character.Humanoid.JumpPower,
    Callback = function(Value)
        player.Character.Humanoid.JumpPower = Value
    end
})

-- Gravity Slider
Tab:CreateSlider({
    Name = "Gravity",
    Info = "Change the game's gravity.",
    Range = {0, 500},
    Increment = 1,
    CurrentValue = Workspace.Gravity,
    Callback = function(Value)
        Workspace.Gravity = Value
    end
})

-- Box and Name ESP Functions
local function createESP(plr)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 2
    box.Filled = false
    boxESPObjects[plr] = box

    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.Text = plr.DisplayName
    nameTag.Size = 16
    nameTag.Center = true
    nameTag.Outline = true
    nameESPObjects[plr] = nameTag

    RunService.RenderStepped:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = plr.Character.HumanoidRootPart
            local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)

            if onScreen then
                local scaleFactor = 1 / (screenPos.Z / 10)


                box.Visible = boxESPEnabled
                box.Position = Vector2.new(screenPos.X - 50 * scaleFactor, screenPos.Y - 75 * scaleFactor)
                box.Size = Vector2.new(100 * scaleFactor, 150 * scaleFactor)

           
                nameTag.Visible = nameESPEnabled
                nameTag.Position = Vector2.new(screenPos.X, screenPos.Y - 40 * scaleFactor)
            else
                box.Visible = false
                nameTag.Visible = false
            end
        else
            box.Visible = false
            nameTag.Visible = false
        end
    end)
end

for _, plr in pairs(players:GetPlayers()) do
    if plr ~= player then
        createESP(plr)
    end
end

players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        plr.CharacterAdded:Connect(function()
            createESP(plr)
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

-- Noclip Function
Tab:CreateToggle({
    Name = "Toggle Noclip",
    Info = "Walk through objects.",
    CurrentValue = false,
    Callback = function(state)
        noclipEnabled = state
        RunService.Stepped:Connect(function()
            if noclipEnabled then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            else
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
})

-- Teleport Function
Tab:CreateInput({
    Name = "Teleport",
    Info = "Enter a player name to teleport to them.",
    PlaceholderText = "Player Name",
    NumbersOnly = false,
    Callback = function(Text)
        for _, targetPlayer in pairs(players:GetPlayers()) do
            if string.find(string.lower(targetPlayer.DisplayName), string.lower(Text)) then
                if targetPlayer and targetPlayer.Character then
                    local targetRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRootPart then
                        player.Character.HumanoidRootPart.CFrame = targetRootPart.CFrame
                    end
                end
            end
        end
    end,
})



-- Box-ESP Toggle
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

-- Name-ESP Toggle
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
