-- Script Main với GUI mới từ v (8).txt, giữ nguyên logic cũ

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- XÓA GUI cũ nếu có
pcall(function() if playerGui:FindFirstChild("CustomGUI_93063325506256") then playerGui.CustomGUI_93063325506256:Destroy() end end)

-- Tạo GUI mới (theo mẫu v (8).txt)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = playerGui
ScreenGui.Name = "CustomGUI_93063325506256"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(1, -210, 1, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.166, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.666, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 127)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 102, 0))
}
UIGradient.Rotation = 45
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 3
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke.Parent = MainFrame
UIGradient.Parent = Stroke

local function updateRainbow()
    while true do
        TweenService:Create(UIGradient, TweenInfo.new(3, Enum.EasingStyle.Linear), {Rotation = 360}):Play()
        wait(3)
        UIGradient.Rotation = 0
    end
end
spawn(updateRainbow)

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(1, 0, 1, 0)
Logo.Position = UDim2.new(0, 0, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://93063325506256"
Logo.ImageTransparency = 0.5
Logo.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -10, 1, -10)
ContentFrame.Position = UDim2.new(0, 5, 0, 5)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ContentFrame

local FistLabel = Instance.new("TextLabel")
FistLabel.Size = UDim2.new(1, 0, 0, 25)
FistLabel.BackgroundTransparency = 1
FistLabel.Text = "Fist of Darkness: false"
FistLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
FistLabel.Font = Enum.Font.FredokaOne
FistLabel.TextSize = 16
FistLabel.Parent = ContentFrame

local RaceLabel = Instance.new("TextLabel")
RaceLabel.Size = UDim2.new(1, 0, 0, 25)
RaceLabel.BackgroundTransparency = 1
RaceLabel.Text = "Race: Unknown"
RaceLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
RaceLabel.Font = Enum.Font.FredokaOne
RaceLabel.TextSize = 16
RaceLabel.Parent = ContentFrame

local FragmentsLabel = Instance.new("TextLabel")
FragmentsLabel.Size = UDim2.new(1, 0, 0, 25)
FragmentsLabel.BackgroundTransparency = 1
FragmentsLabel.Text = "Fragments: 0"
FragmentsLabel.TextColor3 = Color3.fromRGB(218, 112, 214)

FragmentsLabel.Font = Enum.Font.FredokaOne
FragmentsLabel.TextSize = 16
FragmentsLabel.Parent = ContentFrame

local ScriptLabel = Instance.new("TextLabel")
ScriptLabel.Size = UDim2.new(1, 0, 0, 25)
ScriptLabel.BackgroundTransparency = 1
ScriptLabel.Text = "Script: Inactive"
ScriptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptLabel.Font = Enum.Font.FredokaOne
ScriptLabel.TextSize = 16
ScriptLabel.Parent = ContentFrame

-- Kéo thả GUI
local dragging, dragInput, dragStart, startPos
local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

-- Biến trạng thái
local hasFist = false
local hasFistChecked = false
local currentRace = "Unknown"
local fragments = 0
local currentRunningScript = "None"
local isRunningAnyScript = false

local function QuestNameByKey(key)
    if key == "A" then return "Auto Fist"
    elseif key == "B" then return "Get Cyborg"
    elseif key == "C" then return "Raid (fragments)"
    elseif key == "D" then return "Up V3"
    else return key or "Inactive" end
end

-- Hàm cập nhật GUI mới
local function UpdateGui()
    FistLabel.Text = "Fist of Darkness: " .. (hasFist and "true" or "false")
    FistLabel.TextColor3 = hasFist and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    RaceLabel.Text = "Race: " .. currentRace
    FragmentsLabel.Text = "Fragments: " .. fragments
    ScriptLabel.Text = "Quest: " .. QuestNameByKey(currentRunningScript)
    isRunningAnyScript = currentRunningScript ~= "None"
end

-- Function check boss Order
local function IsLawSpawned()
    for _, v in pairs(Workspace.Enemies:GetChildren()) do
        if v:IsA("Model") and v.Name:find("Order") then
            return true
        end
    end
    return false
end

-- Function hop server
local function HopServer()
    local countdownGui = Instance.new("ScreenGui")
    countdownGui.Name = "CountdownHopGui"
    countdownGui.ResetOnSpawn = false
    countdownGui.Parent = playerGui

    local countdownFrame = Instance.new("Frame")
    countdownFrame.Size = UDim2.new(0, 180, 0, 60)
    countdownFrame.Position = UDim2.new(0.5, -90, 0.8, -30)
    countdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    countdownFrame.BorderSizePixel = 0
    countdownFrame.Parent = countdownGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = countdownFrame

    local countdownLabel = Instance.new("TextLabel")
    countdownLabel.Size = UDim2.new(1, 0, 1, 0)
    countdownLabel.BackgroundTransparency = 1
    countdownLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    countdownLabel.Font = Enum.Font.GothamBold
    countdownLabel.TextSize = 22
    countdownLabel.Text = "hop..."
    countdownLabel.Parent = countdownFrame

    local countdown = 20
    local paused = false

    while true do
        if IsLawSpawned() then
            if not paused then
                countdownLabel.Text = "[Order]Stop Hop"
                paused = true
            end
            task.wait(1)
        else
            if paused then
                countdown = 20
                paused = false
            end
            countdownLabel.Text = "Hop server sau: " .. countdown .. "s"
            countdown = countdown - 1
            if countdown <= 0 then
                break
            end
            task.wait(1)
        end
    end

    countdownLabel.Text = "Hop Server..."
    task.wait(0.5)

    local teleportSuccess = false
    local teleportConnection
    teleportConnection = player.OnTeleport:Connect(function(teleportState)
        if teleportState == Enum.TeleportState.InProgress then
            teleportSuccess = true
        elseif teleportState == Enum.TeleportState.Failed then
            countdownLabel.Text = "Teleport thất bại!"
        end
    end)

    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    local waitTime = 0
    while not teleportSuccess and waitTime < 10 do
        task.wait(1)
        waitTime = waitTime + 1
    end

    if teleportConnection then
        teleportConnection:Disconnect()
    end

    countdownGui:Destroy()
    return teleportSuccess
end

-- Cập nhật fragments và race liên tục
spawn(function()
    while task.wait(5) do
        pcall(function()
            fragments = player.Data.Fragments.Value or 0
            currentRace = player.Data.Race.Value or "Unknown"
            UpdateGui()
        end)
    end
end)

-- Script check Fist of Darkness
local function CheckFistOfDarkness()
    local raidGui = Instance.new("ScreenGui")
    raidGui.Name = "LawRaidMessage"
    raidGui.ResetOnSpawn = false
    raidGui.Parent = playerGui

    local msgLabel = Instance.new("TextLabel", raidGui)
    msgLabel.Size = UDim2.new(0.5, 0, 0, 40)
    msgLabel.Position = UDim2.new(0.25, 0, 0.85, 0)
    msgLabel.BackgroundTransparency = 0.3
    msgLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    msgLabel.TextColor3 = Color3.new(1, 1, 1)
    msgLabel.TextScaled = true
    msgLabel.Text = "⏳ check Fist of Darkness..."

    pcall(function()
        local btn = Workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector
        if btn then
            fireclickdetector(btn)
        end
    end)

    local connection
    connection = playerGui.DescendantAdded:Connect(function(obj)
        task.wait(0.05)
        if obj:IsA("TextLabel") and obj.Text and obj.Text ~= "" then
            local cleanText = obj.Text:gsub("<[^>]->", ""):gsub("{.-}", ""):gsub("^%s*(.-)%s*$", "%1")
            if string.find(cleanText, "Please supply") then
                hasFist = true
                hasFistChecked = true
                msgLabel.Text = cleanText
                connection:Disconnect()
                raidGui:Destroy()
                UpdateGui()
            elseif string.find(cleanText, "Microchip") then
                hasFist = false
                hasFistChecked = true
                msgLabel.Text = cleanText
                connection:Disconnect()
                raidGui:Destroy()
                UpdateGui()
            end
        end
    end)

    task.wait(15)
    if not hasFistChecked then
        hasFist = false
        hasFistChecked = true
        raidGui:Destroy()
        UpdateGui()
    end
end

-- Function chạy script
local function RunScript(scriptName, scriptCode)
    if isRunningAnyScript and currentRunningScript ~= scriptName then
        if HopServer() then
            return false
        end
    end
    currentRunningScript = scriptName
    UpdateGui()
    local success, err = pcall(function()
        loadstring(scriptCode)()
    end)
    if not success then
        currentRunningScript = "None"
        UpdateGui()
    end
    return true
end

-- Logic chính để chọn và chạy script
local function RunMainLogic()
    if not hasFistChecked then
        return
    end

    if currentRace == "Cyborg" then
        if currentRunningScript ~= "D" then
            RunScript("D", [[
                getgenv().Config = {
                    ["Auto Upgrade Race V2-V3"] = true,
                }
                repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer 
                getgenv().Key = "1fac947ad1d37c7fc21830fd" 
                loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))()
            ]])
        end
    elseif fragments < 3500 then
        if currentRunningScript ~= "C" then
            RunScript("C", [[
                getgenv().Config = {
                    ["Auto Raid"] = true,
                    ["Hop Sever Raid"] = true,
                    ["Attack No Animation"] = true
                }
                repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer 
                getgenv().Key = "1fac947ad1d37c7fc21830fd" 
                loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))()
            ]])
        end
    elseif not hasFist then
        if currentRunningScript ~= "A" then
            RunScript("A", [[
               spawn(function()
    while task.wait(3) do
        pcall(function()
            local backpack = game.Players.LocalPlayer.Backpack
            local hasFist = backpack:FindFirstChild("Fist of Darkness")
            if hasFist then
                local btn = game:GetService("Workspace").Map.CircleIsland.RaidSummon.Button.Main.ClickDetector
                if btn then
                    fireclickdetector(btn)
                end
            end
        end)
    end
end)     getgenv().Team = "Marines"
                loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua"))()
            ]])
        end
    else
        if currentRunningScript ~= "B" then
            RunScript("B", [[
                getgenv().Config = {
                    ["Attack No Animation"] = true,
                    ["Teleport Y"] = true,
                    ["Auto Get Cyborg"] = true,
                }
                repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer 
                getgenv().Key = "1fac947ad1d37c7fc21830fd" 
                loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))()
            ]])
        end
    end
end

-- Chạy check Fist một lần
spawn(function()
    CheckFistOfDarkness()
end)

-- Vòng lặp chính để kiểm tra và chạy script
spawn(function()
    while task.wait(5) do
        pcall(function()
            RunMainLogic()
        end)
    end
end)
