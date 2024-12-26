-- Updated 26.12.2024 at 19:36pm GMT +3:00.
-- Added Aimbot Function (Press E to active.) / FOV Aimbot Function (Fov Aimbot Doesnt Work Properly.)
-- Added Traces (Doesnt Even Works Sorry.)
-- Moved To A New Gui (Im Willing to change this gui too.)
-- Added Team-Check Function ( Finally A Working Function After Aimbot!)
-- I Accidentally Deleted Teleport To Player Function I will rewrite it.
-- All Of The Features Are: Noclip, Aimbot, Box-ESP, Name-ESP, Team-Check, WalkSpeed Modifier, JumpPower Modifier, Gravity Modifier.

local Material = loadstring(game:HttpGet('https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua'))()

local players = game:GetService("Players")
local player = players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local boxESPObjects = {}
local nameESPObjects = {}
local traceESPObjects = {}
local boxESPEnabled = false
local nameESPEnabled = false
local noclipEnabled = false
local aimbotEnabled = false
local fovAimbotEnabled = false
local fovCircle = Drawing.new("Circle")
local targetPlayer = nil
local teamCheckEnabled = false
local tracesEnabled = false  

fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Thickness = 2
fovCircle.Radius = 100
fovCircle.Position = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y / 2)

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

    local trace = Drawing.new("Line")
    trace.Visible = false
    trace.Color = Color3.fromRGB(0, 255, 0)
    trace.Thickness = 2
    traceESPObjects[plr] = trace

    RunService.RenderStepped:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = plr.Character.HumanoidRootPart
            local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                local scaleFactor = 1 / (screenPos.Z / 10)
                box.Visible = boxESPEnabled and (not teamCheckEnabled or plr.Team ~= player.Team)
                box.Position = Vector2.new(screenPos.X - 50 * scaleFactor, screenPos.Y - 75 * scaleFactor)
                box.Size = Vector2.new(100 * scaleFactor, 150 * scaleFactor)
                nameTag.Visible = nameESPEnabled and (not teamCheckEnabled or plr.Team ~= player.Team)
                nameTag.Position = Vector2.new(screenPos.X, screenPos.Y - 40 * scaleFactor)
                if tracesEnabled then
                    local cameraPos = Workspace.CurrentCamera.CFrame.Position
                    local traceStart = Workspace.CurrentCamera:WorldToViewportPoint(cameraPos)
                    local traceEnd = Vector2.new(screenPos.X, screenPos.Y)
                    trace.Visible = true
                    trace.From = Vector2.new(traceStart.X, traceStart.Y)
                    trace.To = Vector2.new(traceEnd.X, traceEnd.Y)
                else
                    trace.Visible = false
                end
            else
                box.Visible = false
                nameTag.Visible = false
                trace.Visible = false
            end
        else
            box.Visible = false
            nameTag.Visible = false
            trace.Visible = false
        end
    end)
end

for _, plr in pairs(players:GetPlayers()) do
    if plr ~= players.LocalPlayer then
        createESP(plr)
    end
end

players.PlayerAdded:Connect(function(plr)
    if plr ~= players.LocalPlayer then
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
    if traceESPObjects[plr] then
        traceESPObjects[plr]:Remove()
        traceESPObjects[plr] = nil
    end
end)

local function setNoclip(enabled)
    noclipEnabled = enabled
    RunService.Stepped:Connect(function()
        if noclipEnabled then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)
end

local function setAimbot(enabled)
    aimbotEnabled = enabled
    local closestPlayer = nil
    local shortestDistance = math.huge

    RunService.RenderStepped:Connect(function()
        if aimbotEnabled then
            closestPlayer = nil
            shortestDistance = math.huge

            for _, plr in pairs(players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") and (not teamCheckEnabled or plr.Team ~= player.Team) then
                    local headPart = plr.Character.Head
                    local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(headPart.Position)

                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y / 2)).magnitude

                        if distance < shortestDistance then
                            closestPlayer = plr
                            shortestDistance = distance
                        end
                    end
                end
            end

            if closestPlayer then
                local targetPart = closestPlayer.Character.Head
                Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, targetPart.Position)
            end
        end
    end)
end

local function setFOVAimbot(enabled)
    fovAimbotEnabled = enabled
    fovCircle.Visible = enabled
    RunService.RenderStepped:Connect(function()
        if fovAimbotEnabled then
            local closestPlayer = nil
            local shortestDistance = fovCircle.Radius
            for _, plr in pairs(players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") and (not teamCheckEnabled or plr.Team ~= player.Team) then
                    local headPart = plr.Character.Head
                    local screenPos = Workspace.CurrentCamera:WorldToViewportPoint(headPart.Position)
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - fovCircle.Position).magnitude
                    if distance < shortestDistance then
                        closestPlayer = plr
                        shortestDistance = distance
                    end
                end
            end
            if closestPlayer then
                targetPlayer = closestPlayer
                local targetPart = targetPlayer.Character.Head
                local aimPos = Workspace.CurrentCamera:WorldToViewportPoint(targetPart.Position)
                mousemoverel((aimPos.X - Workspace.CurrentCamera.ViewportSize.X / 2) / 8, (aimPos.Y - Workspace.CurrentCamera.ViewportSize.Y / 2) / 8)
            end
        end
    end)
end

local UI = Material.Load({
    Title = "NotUgur Universal Script",
    Style = 1,
    SizeX = 300,
    SizeY = 400,
    Theme = "Light"
})

local Page = UI.New({
    Title = "Settings"
})

Page.Toggle({
    Text = "Enable Noclip",
    Callback = function(v)
        setNoclip(v)
    end,
    Enabled = false
})

Page.Toggle({
    Text = "Enable Team Check",
    Callback = function(v)
        teamCheckEnabled = v
    end,
    Enabled = false
})

Page.Toggle({
    Text = "Enable Box ESP",
    Callback = function(v)
        boxESPEnabled = v
        for _, box in pairs(boxESPObjects) do
            box.Visible = boxESPEnabled
        end
    end,
    Enabled = false
})

Page.Toggle({
    Text = "Enable Name ESP",
    Callback = function(v)
        nameESPEnabled = v
        for _, nameTag in pairs(nameESPObjects) do
            nameTag.Visible = nameESPEnabled
        end
    end,
    Enabled = false
})

Page.Toggle({
    Text = "Enable Traces",
    Callback = function(v)
        tracesEnabled = v
        for _, trace in pairs(traceESPObjects) do
            trace.Visible = tracesEnabled
        end
    end,
    Enabled = false
})

Page.Toggle({
    Text = "Enable Aimbot",
    Callback = function(v)
        setAimbot(v)
    end,
    Enabled = false
})

Page.Toggle({
    Text = "Enable FOV Aimbot",
    Callback = function(v)
        setFOVAimbot(v)
    end,
    Enabled = false
})

Page.Slider({
    Text = "Walk Speed",
    Min = 0,
    Max = 500,
    Def = hum.WalkSpeed,
    Callback = function(value)
        hum.WalkSpeed = value
    end
})

Page.Slider({
    Text = "Jump Power",
    Min = 0,
    Max = 500,
    Def = hum.JumpPower,
    Callback = function(value)
        hum.JumpPower = value
    end
})

Page.Slider({
    Text = "Gravity",
    Min = 0,
    Max = 500,
    Def = workspace.Gravity,
    Callback = function(value)
        workspace.Gravity = value
    end
})

Page.Slider({
    Text = "FOV Radius",
    Min = 50,
    Max = 300,
    Def = fovCircle.Radius,
    Callback = function(value)
        fovCircle.Radius = value
    end
})

local aimbotKey = Enum.KeyCode.E 
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == aimbotKey then
        aimbotEnabled = not aimbotEnabled
    end
end)

