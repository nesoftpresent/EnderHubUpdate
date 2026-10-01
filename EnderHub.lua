-- EnderHub | Delta Executor
-- Created By @EnderHubRoblox (tg)
-- Version: 3.0

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========== НАСТРОЙКИ ==========
local KEY_CORRECT = "WelcomeToPolitixBrothers"
local LOAD_TIME = 6
local LANG_WAIT = 10
local HUB_NAME = "EnderHub"

local CONFIG = {
    Key = "",
    Lang = "Russia",
    Noclip = false,
    Speed = 60,
    Aimbot = false,
    EspPlayers = false,
    EspPlayersColor = "Green",
    CountryInfo = false,
    CountryInfoColor = "Green",
    AutoCityUpgrade = false,
    AutoCityUpgradeLimit = 2000000000,
}

-- ========== СОХРАНЕНИЕ ==========
local function SaveConfig()
    if writefile then
        pcall(function()
            writefile("EnderHub_Config.json", HttpService:JSONEncode(CONFIG))
        end)
    end
end

local function LoadConfig()
    if isfile and isfile("EnderHub_Config.json") then
        pcall(function()
            local data = HttpService:JSONDecode(readfile("EnderHub_Config.json"))
            for k, v in pairs(data) do
                CONFIG[k] = v
            end
        end)
    end
end

LoadConfig()

-- ========== УДАЛЕНИЕ СТАРОГО UI ==========
local function CleanupOldUI()
    local old = CoreGui:FindFirstChild("EnderHubUI")
    if old then old:Destroy() end
    local oldBtn = CoreGui:FindFirstChild("EnderHubToggle")
    if oldBtn then oldBtn:Destroy() end
    local oldInfo = CoreGui:FindFirstChild("EnderHubCountryInfo")
    if oldInfo then oldInfo:Destroy() end
end

CleanupOldUI()

-- ========== ПЕРЕВОДЫ ==========
local L = {
    English = {
        Loading = "EnderHub are loading...",
        WriteKey = "Write key here",
        Use = "Use",
        Wait = "Loading, please wait",
        General = "General",
        Combat = "Combat",
        Visual = "Visual",
        Farm = "Farm",
        Language = "Language",
        Devs = "Devs",
        Noclip = "Noclip",
        SpeedHack = "SpeedHack",
        Aimbot = "Aimbot (not really needed for the game)",
        EspPlayers = "Esp Players",
        CountryInfo = "Country Info",
        CountryInfoBugs = "Country Info (bugs)",
        AutoCityUpgrade = "Avto City Upgrade",
        AutoCityUpgradeBugs = "Avto City Upgrade (bugs)",
        Limit = "Limit money (stop when left)",
        InWork = "In work",
        Color = "Color",
        CreatedBy = "Created By @EnderHubRoblox (tg)",
        CreatedByShort = "Created By @EnderHubRoblox (tg)",
        Green = "Green", Red = "Red", Yellow = "Yellow", Blue = "Blue",
        Cyan = "Cyan", Orange = "Orange", Lime = "Lime", Scarlet = "Scarlet",
        Demonic = "Demonic", Black = "Black",
        CountryLoading = "Loading country data, please wait...",
    },
    Russia = {
        Loading = "EnderHub загружается...",
        WriteKey = "Введи ключ сюда",
        Use = "Использовать",
        Wait = "Загрузка, подождите",
        General = "Общее",
        Combat = "Бой",
        Visual = "Визуал",
        Farm = "Фарм",
        Language = "Язык",
        Devs = "Создатели",
        Noclip = "Ноклип",
        SpeedHack = "Скорость",
        Aimbot = "Аимбот (не особо нужен для игры)",
        EspPlayers = "Esp Игроки",
        CountryInfo = "Инфо о странах",
        CountryInfoBugs = "Инфо о странах (bugs)",
        AutoCityUpgrade = "Авто прокачка городов",
        AutoCityUpgradeBugs = "Авто прокачка городов (bugs)",
        Limit = "Лимит денег (стоп когда осталось)",
        InWork = "В работе",
        Color = "Цвет",
        CreatedBy = "Создано @EnderHubRoblox (tg)",
        CreatedByShort = "Создано @EnderHubRoblox (tg)",
        Green = "Зелёный", Red = "Красный", Yellow = "Жёлтый", Blue = "Синий",
        Cyan = "Голубой", Orange = "Оранжевый", Lime = "Салатовый", Scarlet = "Алый",
        Demonic = "Демонический", Black = "Чёрный",
        CountryLoading = "Загрузка данных о странах, подождите...",
    }
}

local function T(key)
    return L[CONFIG.Lang][key] or key
end

-- ========== ЦВЕТА ==========
local COLORS = {
    Green = Color3.fromRGB(40, 255, 40),
    Red = Color3.fromRGB(255, 40, 40),
    Yellow = Color3.fromRGB(255, 230, 40),
    Blue = Color3.fromRGB(40, 120, 255),
    Cyan = Color3.fromRGB(40, 230, 255),
    Orange = Color3.fromRGB(255, 140, 20),
    Lime = Color3.fromRGB(160, 255, 40),
    Scarlet = Color3.fromRGB(255, 20, 60),
    Demonic = Color3.fromRGB(140, 0, 200),
    Black = Color3.fromRGB(20, 20, 20),
}

local COLOR_ORDER = {"Green","Red","Yellow","Blue","Cyan","Orange","Lime","Scarlet","Demonic","Black"}

-- ========== GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnderHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

-- ========== ЭКРАН ЗАГРУЗКИ ==========
local LoadFrame = Instance.new("Frame")
LoadFrame.Size = UDim2.new(0, 320, 0, 80)
LoadFrame.Position = UDim2.new(0.5, -160, 0.5, -40)
LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 25)
LoadFrame.BackgroundTransparency = 1
LoadFrame.BorderSizePixel = 0
LoadFrame.Parent = ScreenGui

local LoadCorner = Instance.new("UICorner")
LoadCorner.CornerRadius = UDim.new(0, 12)
LoadCorner.Parent = LoadFrame

local LoadGradient = Instance.new("UIGradient")
LoadGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 60, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 20, 120)),
}
LoadGradient.Rotation = 45
LoadGradient.Parent = LoadFrame

local LoadStroke = Instance.new("UIStroke")
LoadStroke.Color = Color3.fromRGB(180, 100, 255)
LoadStroke.Thickness = 2
LoadStroke.Transparency = 1
LoadStroke.Parent = LoadFrame

local LoadLabel = Instance.new("TextLabel")
LoadLabel.Size = UDim2.new(1, 0, 1, 0)
LoadLabel.BackgroundTransparency = 1
LoadLabel.Text = T("Loading")
LoadLabel.TextColor3 = Color3.fromRGB(240, 220, 255)
LoadLabel.Font = Enum.Font.GothamBold
LoadLabel.TextSize = 20
LoadLabel.TextTransparency = 1
LoadLabel.Parent = LoadFrame

task.spawn(function()
    TweenService:Create(LoadFrame, TweenInfo.new(1.2), {BackgroundTransparency = 0}):Play()
    TweenService:Create(LoadStroke, TweenInfo.new(1.2), {Transparency = 0}):Play()
    TweenService:Create(LoadLabel, TweenInfo.new(1.2), {TextTransparency = 0}):Play()
    task.wait(LOAD_TIME)
    TweenService:Create(LoadFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadStroke, TweenInfo.new(1), {Transparency = 1}):Play()
    TweenService:Create(LoadLabel, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1.2)
    LoadFrame:Destroy()
end)

-- ========== KEY-МЕНЮ ==========
local function BuildKeyMenu()
    local KeyGui = Instance.new("Frame")
    KeyGui.Size = UDim2.new(0, 380, 0, 220)
    KeyGui.Position = UDim2.new(0.5, -190, 0.5, -110)
    KeyGui.BackgroundColor3 = Color3.fromRGB(20, 8, 35)
    KeyGui.BackgroundTransparency = 1
    KeyGui.BorderSizePixel = 0
    KeyGui.Parent = ScreenGui

    local KC = Instance.new("UICorner")
    KC.CornerRadius = UDim.new(0, 16)
    KC.Parent = KeyGui

    local KStroke = Instance.new("UIStroke")
    KStroke.Color = Color3.fromRGB(180, 100, 255)
    KStroke.Thickness = 2
    KStroke.Transparency = 1
    KStroke.Parent = KeyGui

    local KTitle = Instance.new("TextLabel")
    KTitle.Size = UDim2.new(1, 0, 0, 50)
    KTitle.Position = UDim2.new(0, 0, 0, 15)
    KTitle.BackgroundTransparency = 1
    KTitle.Text = HUB_NAME
    KTitle.TextColor3 = Color3.fromRGB(210, 150, 255)
    KTitle.Font = Enum.Font.GothamBold
    KTitle.TextSize = 26
    KTitle.TextTransparency = 1
    KTitle.Parent = KeyGui

    local KHint = Instance.new("TextLabel")
    KHint.Size = UDim2.new(1, -40, 0, 20)
    KHint.Position = UDim2.new(0, 20, 0, 70)
    KHint.BackgroundTransparency = 1
    KHint.Text = T("WriteKey")
    KHint.TextColor3 = Color3.fromRGB(180, 140, 220)
    KHint.Font = Enum.Font.Gotham
    KHint.TextSize = 14
    KHint.TextTransparency = 1
    KHint.TextXAlignment = Enum.TextXAlignment.Left
    KHint.Parent = KeyGui

    local KBox = Instance.new("TextBox")
    KBox.Size = UDim2.new(1, -40, 0, 36)
    KBox.Position = UDim2.new(0, 20, 0, 95)
    KBox.BackgroundColor3 = Color3.fromRGB(30, 12, 50)
    KBox.BackgroundTransparency = 1
    KBox.BorderSizePixel = 0
    KBox.Text = ""
    KBox.PlaceholderText = "..."
    KBox.TextColor3 = Color3.fromRGB(230, 210, 255)
    KBox.PlaceholderColor3 = Color3.fromRGB(120, 80, 160)
    KBox.Font = Enum.Font.Gotham
    KBox.TextSize = 15
    KBox.ClearTextOnFocus = false
    KBox.TextTransparency = 1
    KBox.Parent = KeyGui

    local KBC = Instance.new("UICorner")
    KBC.CornerRadius = UDim.new(0, 8)
    KBC.Parent = KBox

    local KBStroke = Instance.new("UIStroke")
    KBStroke.Color = Color3.fromRGB(120, 50, 190)
    KBStroke.Thickness = 1.5
    KBStroke.Transparency = 1
    KBStroke.Parent = KBox

    local KUse = Instance.new("TextButton")
    KUse.Size = UDim2.new(1, -40, 0, 38)
    KUse.Position = UDim2.new(0, 20, 0, 150)
    KUse.BackgroundColor3 = Color3.fromRGB(90, 30, 160)
    KUse.BackgroundTransparency = 1
    KUse.BorderSizePixel = 0
    KUse.Text = T("Use")
    KUse.TextColor3 = Color3.fromRGB(240, 220, 255)
    KUse.Font = Enum.Font.GothamBold
    KUse.TextSize = 16
    KUse.TextTransparency = 1
    KUse.Parent = KeyGui

    local KUC = Instance.new("UICorner")
    KUC.CornerRadius = UDim.new(0, 8)
    KUC.Parent = KUse

    TweenService:Create(KeyGui, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
    TweenService:Create(KStroke, TweenInfo.new(1), {Transparency = 0}):Play()
    TweenService:Create(KTitle, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(KHint, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(KBox, TweenInfo.new(1), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    TweenService:Create(KBStroke, TweenInfo.new(1), {Transparency = 0}):Play()
    TweenService:Create(KUse, TweenInfo.new(1), {BackgroundTransparency = 0, TextTransparency = 0}):Play()

    KUse.MouseButton1Click:Connect(function()
        if KBox.Text == KEY_CORRECT then
            CONFIG.Key = KBox.Text
            SaveConfig()
            TweenService:Create(KeyGui, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
            TweenService:Create(KTitle, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
            TweenService:Create(KHint, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
            TweenService:Create(KBox, TweenInfo.new(0.6), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(KUse, TweenInfo.new(0.6), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(KStroke, TweenInfo.new(0.6), {Transparency = 1}):Play()
            task.wait(0.7)
            KeyGui:Destroy()
            task.wait(3)
            BuildMainMenu()
        else
            KBStroke.Color = Color3.fromRGB(220, 30, 30)
            task.wait(0.4)
            KBStroke.Color = Color3.fromRGB(120, 50, 190)
        end
    end)
end

-- ========== ОВЕРЛЕЙ WAIT ==========
local function ShowWaitOverlay(text, duration, callback)
    local WaitGui = Instance.new("Frame")
    WaitGui.Size = UDim2.new(1, 0, 1, 0)
    WaitGui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    WaitGui.BackgroundTransparency = 1
    WaitGui.BorderSizePixel = 0
    WaitGui.ZIndex = 100
    WaitGui.Parent = ScreenGui

    local WLabel = Instance.new("TextLabel")
    WLabel.Size = UDim2.new(1, 0, 1, 0)
    WLabel.BackgroundTransparency = 1
    WLabel.Text = text
    WLabel.TextColor3 = Color3.fromRGB(200, 130, 255)
    WLabel.Font = Enum.Font.GothamBold
    WLabel.TextSize = 28
    WLabel.TextTransparency = 1
    WLabel.ZIndex = 101
    WLabel.Parent = WaitGui

    TweenService:Create(WaitGui, TweenInfo.new(0.5), {BackgroundTransparency = 0.4}):Play()
    TweenService:Create(WLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    task.wait(duration)
    TweenService:Create(WaitGui, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(WLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.6)
    WaitGui:Destroy()
    if callback then callback() end
end

-- ========== NOCLIP ==========
local noclipConn
local function ToggleNoclip(state)
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if not state then return end
    noclipConn = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    p.CanCollide = false
                end
            end
        end
    end)
end

-- ========== SPEED ==========
local function ApplySpeed(val)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = val
    end
end

-- ========== ESP PLAYERS ==========
local espPlayersFolder = Instance.new("Folder")
espPlayersFolder.Name = "EnderHubEspPlayers"
espPlayersFolder.Parent = CoreGui

local function CreateHighlight(folder, instance, colorName)
    if not instance then return end
    local name = instance.Name
    if folder:FindFirstChild(name) then return end
    local hl = Instance.new("Highlight")
    hl.Name = name
    hl.FillColor = COLORS[colorName] or COLORS.Green
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.Adornee = instance
    hl.Parent = folder
end

local function RefreshPlayersESP()
    espPlayersFolder:ClearAllChildren()
    if not CONFIG.EspPlayers then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            CreateHighlight(espPlayersFolder, p.Character, CONFIG.EspPlayersColor)
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        task.wait(0.5)
        if CONFIG.EspPlayers then
            CreateHighlight(espPlayersFolder, c, CONFIG.EspPlayersColor)
        end
    end)
end)

-- ========== COUNTRY INFO ==========
local countryInfoFrame = nil

local function BuildCountryInfoFrame(data)
    if countryInfoFrame then countryInfoFrame:Destroy() end
    countryInfoFrame = Instance.new("Frame")
    countryInfoFrame.Name = "EnderHubCountryInfo"
    countryInfoFrame.Size = UDim2.new(0, 280, 0, 300)
    countryInfoFrame.Position = UDim2.new(0, 20, 0.3, 0)
    countryInfoFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 30)
    countryInfoFrame.BackgroundTransparency = 0.1
    countryInfoFrame.BorderSizePixel = 0
    countryInfoFrame.Active = true
    countryInfoFrame.Draggable = true
    countryInfoFrame.Parent = ScreenGui

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 12)
    c.Parent = countryInfoFrame

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(150, 80, 220)
    s.Thickness = 2
    s.Parent = countryInfoFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 32)
    title.BackgroundTransparency = 1
    title.Text = T("CountryInfo")
    title.TextColor3 = Color3.fromRGB(210, 150, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = countryInfoFrame

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, -20, 1, -45)
    list.Position = UDim2.new(0, 10, 0, 38)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 4
    list.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 220)
    list.CanvasSize = UDim2.new(0, 0, 0, #data * 30)
    list.Parent = countryInfoFrame

    local ll = Instance.new("UIListLayout")
    ll.Padding = UDim.new(0, 4)
    ll.Parent = list

    for _, row in ipairs(data) do
        local r = Instance.new("Frame")
        r.Size = UDim2.new(1, 0, 0, 26)
        r.BackgroundColor3 = Color3.fromRGB(30, 12, 50)
        r.BorderSizePixel = 0
        r.Parent = list
        local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 5) rc.Parent = r

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -10, 1, 0)
        lbl.Position = UDim2.new(0, 5, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = row
        lbl.TextColor3 = COLORS[CONFIG.CountryInfoColor] or COLORS.Green
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = r
    end
end

local function RefreshCountryInfo()
    if not CONFIG.CountryInfo then
        if countryInfoFrame then countryInfoFrame:Destroy() countryInfoFrame = nil end
        return
    end
    ShowWaitOverlay(T("CountryLoading"), 3, function()
        local data = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                local money = p:GetAttribute("Money") or p.Character:GetAttribute("Money") or "?"
                local power = p:GetAttribute("MilitaryPower") or p.Character:GetAttribute("MilitaryPower") or "?"
                local pol = p:GetAttribute("PoliticalPower") or p.Character:GetAttribute("PoliticalPower") or "?"
                table.insert(data, p.Name .. " | $" .. tostring(money) .. " | Mil: " .. tostring(power) .. " | Pol: " .. tostring(pol))
            end
        end
        if #data == 0 then
            table.insert(data, "No data available")
        end
        BuildCountryInfoFrame(data)
    end)
end

-- ========== AUTO CITY UPGRADE ==========
local autoUpgradeConn = nil

local function ToggleAutoCityUpgrade(state)
    if autoUpgradeConn then autoUpgradeConn:Disconnect() autoUpgradeConn = nil end
    if not state then return end
    autoUpgradeConn = RunService.Heartbeat:Connect(function()
        pcall(function()
            local myCountry = nil
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:GetAttribute("Owner") == LocalPlayer.Name then
                    myCountry = obj
                    break
                end
            end
            if not myCountry then return end
            local money = LocalPlayer:GetAttribute("Money") or 0
            if money <= CONFIG.AutoCityUpgradeLimit then return end
            for _, city in ipairs(myCountry:GetChildren()) do
                if city:IsA("Model") and city:GetAttribute("Level") then
                    local lvl = city:GetAttribute("Level")
                    if lvl and lvl < 10 then
                        local upgradeEvent = game:GetService("ReplicatedStorage"):FindFirstChild("UpgradeCity")
                        if upgradeEvent and upgradeEvent:IsA("RemoteEvent") then
                            upgradeEvent:FireServer(city)
                        end
                    end
                end
            end
        end)
    end)
end

-- ========== ГЛАВНОЕ МЕНЮ ==========
function BuildMainMenu()
    local Main = Instance.new("Frame")
    Main.Name = "MainMenu"
    Main.Size = UDim2.new(0, 600, 0, 420)
    Main.Position = UDim2.new(0.5, -300, 0.5, -210)
    Main.BackgroundColor3 = Color3.fromRGB(15, 5, 28)
    Main.BackgroundTransparency = 1
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui

    local MC = Instance.new("UICorner")
    MC.CornerRadius = UDim.new(0, 16)
    MC.Parent = Main

    local MGradient = Instance.new("UIGradient")
    MGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 10, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 4, 22)),
    }
    MGradient.Rotation = 135
    MGradient.Parent = Main

    local MS = Instance.new("UIStroke")
    MS.Color = Color3.fromRGB(150, 80, 220)
    MS.Thickness = 2
    MS.Transparency = 1
    MS.Parent = Main

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 64)
    Header.BackgroundColor3 = Color3.fromRGB(20, 8, 35)
    Header.BackgroundTransparency = 1
    Header.BorderSizePixel = 0
    Header.Parent = Main

    local HC = Instance.new("UICorner")
    HC.CornerRadius = UDim.new(0, 16)
    HC.Parent = Header

    local HLogo = Instance.new("TextLabel")
    HLogo.Size = UDim2.new(1, -20, 0, 30)
    HLogo.Position = UDim2.new(0, 20, 0, 6)
    HLogo.BackgroundTransparency = 1
    HLogo.Text = HUB_NAME
    HLogo.TextColor3 = Color3.fromRGB(210, 150, 255)
    HLogo.Font = Enum.Font.GothamBold
    HLogo.TextSize = 24
    HLogo.TextXAlignment = Enum.TextXAlignment.Left
    HLogo.TextTransparency = 1
    HLogo.Parent = Header

    local HSub = Instance.new("TextLabel")
    HSub.Size = UDim2.new(1, -20, 0, 16)
    HSub.Position = UDim2.new(0, 20, 0, 38)
    HSub.BackgroundTransparency = 1
    HSub.Text = T("CreatedBy")
    HSub.TextColor3 = Color3.fromRGB(150, 110, 190)
    HSub.Font = Enum.Font.Gotham
    HSub.TextSize = 11
    HSub.TextXAlignment = Enum.TextXAlignment.Left
    HSub.TextTransparency = 1
    HSub.Parent = Header

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, -84)
    Sidebar.Position = UDim2.new(0, 10, 0, 74)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 10, 38)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local SC = Instance.new("UICorner")
    SC.CornerRadius = UDim.new(0, 12)
    SC.Parent = Sidebar

    local SList = Instance.new("UIListLayout")
    SList.Padding = UDim.new(0, 6)
    SList.SortOrder = Enum.SortOrder.LayoutOrder
    SList.Parent = Sidebar

    local SPad = Instance.new("UIPadding")
    SPad.PaddingTop = UDim.new(0, 10)
    SPad.PaddingLeft = UDim.new(0, 8)
    SPad.PaddingRight = UDim.new(0, 8)
    SPad.Parent = Sidebar

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -190, 1, -84)
    Content.Position = UDim2.new(0, 180, 0, 74)
    Content.BackgroundColor3 = Color3.fromRGB(22, 10, 38)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ClipsDescendants = true
    Content.Parent = Main

    local CC = Instance.new("UICorner")
    CC.CornerRadius = UDim.new(0, 12)
    CC.Parent = Content

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, 0, 1, 0)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 5
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 220)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.Parent = Content

    local SLayout = Instance.new("UIListLayout")
    SLayout.Padding = UDim.new(0, 10)
    SLayout.Parent = Scroll

    local SPad2 = Instance.new("UIPadding")
    SPad2.PaddingTop = UDim.new(0, 14)
    SPad2.PaddingLeft = UDim.new(0, 14)
    SPad2.PaddingRight = UDim.new(0, 14)
    SPad2.PaddingBottom = UDim.new(0, 14)
    SPad2.Parent = Scroll

    TweenService:Create(Main, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(MS, TweenInfo.new(0.8), {Transparency = 0}):Play()
    TweenService:Create(Header, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Sidebar, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Content, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(HLogo, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    TweenService:Create(HSub, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

    local tabButtons = {}

    local function ClearContent()
        for _, c in ipairs(Scroll:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
                c:Destroy()
            end
        end
    end

    local function MakeToggle(parent, labelText, state, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 56)
        row.BackgroundColor3 = Color3.fromRGB(35, 15, 60)
        row.BorderSizePixel = 0
        row.Parent = parent
        local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 10) rc.Parent = row

        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(1, -80, 0, 22)
        name.Position = UDim2.new(0, 12, 0, 8)
        name.BackgroundTransparency = 1
        name.Text = labelText
        name.TextColor3 = Color3.fromRGB(225, 200, 255)
        name.Font = Enum.Font.GothamBold
        name.TextSize = 14
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.Parent = row

        local stateLbl = Instance.new("TextLabel")
        stateLbl.Size = UDim2.new(1, -80, 0, 14)
        stateLbl.Position = UDim2.new(0, 12, 0, 32)
        stateLbl.BackgroundTransparency = 1
        stateLbl.Text = state and "ON" or "OFF"
        stateLbl.TextColor3 = state and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
        stateLbl.Font = Enum.Font.Gotham
        stateLbl.TextSize = 11
        stateLbl.TextXAlignment = Enum.TextXAlignment.Left
        stateLbl.Parent = row

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 50, 0, 26)
        btn.Position = UDim2.new(1, -62, 0.5, -13)
        btn.BackgroundColor3 = state and Color3.fromRGB(100, 35, 180) or Color3.fromRGB(45, 18, 80)
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.Parent = row
        local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 13) bc.Parent = btn

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 20, 0, 20)
        dot.Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        dot.BackgroundColor3 = Color3.fromRGB(230, 210, 255)
        dot.BorderSizePixel = 0
        dot.Parent = btn
        local dc = Instance.new("UICorner") dc.CornerRadius = UDim.new(1, 0) dc.Parent = dot

        btn.MouseButton1Click:Connect(function()
            state = not state
            stateLbl.Text = state and "ON" or "OFF"
            stateLbl.TextColor3 = state and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
            btn.BackgroundColor3 = state and Color3.fromRGB(100, 35, 180) or Color3.fromRGB(45, 18, 80)
            TweenService:Create(dot, TweenInfo.new(0.15), {
                Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
            }):Play()
            callback(state)
            SaveConfig()
        end)
    end

    local function MakeInput(parent, labelText, value, minV, maxV, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 64)
        row.BackgroundColor3 = Color3.fromRGB(35, 15, 60)
        row.BorderSizePixel = 0
        row.Parent = parent
        local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 10) rc.Parent = row

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -24, 0, 20)
        lbl.Position = UDim2.new(0, 12, 0, 6)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(225, 200, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -24, 0, 28)
        box.Position = UDim2.new(0, 12, 0, 30)
        box.BackgroundColor3 = Color3.fromRGB(22, 8, 45)
        box.BorderSizePixel = 0
        box.Text = tostring(value)
        box.TextColor3 = Color3.fromRGB(230, 210, 255)
        box.Font = Enum.Font.Gotham
        box.TextSize = 14
        box.Parent = row
        local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = box

        box.FocusLost:Connect(function()
            local n = tonumber(box.Text)
            if n then
                if minV then n = math.clamp(n, minV, maxV) end
                box.Text = tostring(n)
                callback(n)
                SaveConfig()
            else
                box.Text = tostring(value)
            end
        end)
    end

    local function MakeColorRow(parent, labelText, currentColorKey, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 80)
        row.BackgroundColor3 = Color3.fromRGB(35, 15, 60)
        row.BorderSizePixel = 0
        row.Parent = parent
        local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 10) rc.Parent = row

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -24, 0, 20)
        lbl.Position = UDim2.new(0, 12, 0, 6)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(225, 200, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local grid = Instance.new("Frame")
        grid.Size = UDim2.new(1, -24, 0, 44)
        grid.Position = UDim2.new(0, 12, 0, 28)
        grid.BackgroundTransparency = 1
        grid.Parent = row

        local gl = Instance.new("UIGridLayout")
        gl.CellSize = UDim2.new(0, 22, 0, 22)
        gl.CellPadding = UDim2.new(0, 4, 0, 4)
        gl.SortOrder = Enum.SortOrder.LayoutOrder
        gl.Parent = grid

        for i, cname in ipairs(COLOR_ORDER) do
            local sq = Instance.new("TextButton")
            sq.Size = UDim2.new(0, 22, 0, 22)
            sq.BackgroundColor3 = COLORS[cname]
            sq.BorderSizePixel = 0
            sq.Text = ""
            sq.LayoutOrder = i
            sq.Parent = grid
            local sc = Instance.new("UICorner") sc.CornerRadius = UDim.new(0, 5) sc.Parent = sq

            if cname == currentColorKey then
                local sel = Instance.new("UIStroke")
                sel.Color = Color3.fromRGB(255, 255, 255)
                sel.Thickness = 2
                sel.Parent = sq
            end

            sq.MouseButton1Click:Connect(function()
                for _, other in ipairs(grid:GetChildren()) do
                    if other:IsA("TextButton") then
                        local s = other:FindFirstChildOfClass("UIStroke")
                        if s then s:Destroy() end
                    end
                end
                local sel = Instance.new("UIStroke")
                sel.Color = Color3.fromRGB(255, 255, 255)
                sel.Thickness = 2
                sel.Parent = sq
                callback(cname)
                SaveConfig()
            end)
        end
    end

    local function BuildGeneral()
        ClearContent()
        MakeToggle(Scroll, T("Noclip"), CONFIG.Noclip, function(s) CONFIG.Noclip = s ToggleNoclip(s) end)
        MakeInput(Scroll, T("SpeedHack") .. " (60-400)", CONFIG.Speed, 60, 400, function(v) CONFIG.Speed = v ApplySpeed(v) end)
    end

    local function BuildCombat()
        ClearContent()
        MakeToggle(Scroll, T("Aimbot"), CONFIG.Aimbot, function(s) CONFIG.Aimbot = s end)
    end

    local function BuildVisual()
        ClearContent()
        MakeToggle(Scroll, T("EspPlayers"), CONFIG.EspPlayers, function(s) CONFIG.EspPlayers = s RefreshPlayersESP() end)
        MakeColorRow(Scroll, T("EspPlayers"), CONFIG.EspPlayersColor, function(c) CONFIG.EspPlayersColor = c RefreshPlayersESP() end)
        MakeToggle(Scroll, T("CountryInfoBugs"), CONFIG.CountryInfo, function(s) CONFIG.CountryInfo = s RefreshCountryInfo() end)
        MakeColorRow(Scroll, T("CountryInfo"), CONFIG.CountryInfoColor, function(c) CONFIG.CountryInfoColor = c RefreshCountryInfo() end)
    end

    local function BuildFarm()
        ClearContent()
        MakeToggle(Scroll, T("AutoCityUpgradeBugs"), CONFIG.AutoCityUpgrade, function(s) CONFIG.AutoCityUpgrade = s ToggleAutoCityUpgrade(s) end)
        MakeInput(Scroll, T("Limit"), CONFIG.AutoCityUpgradeLimit, nil, nil, function(v) CONFIG.AutoCityUpgradeLimit = v end)
    end

    local function BuildLanguage()
        ClearContent()
        local function LangBtn(name, code)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 44)
            b.BackgroundColor3 = CONFIG.Lang == code and Color3.fromRGB(100, 35, 180) or Color3.fromRGB(45, 18, 80)
            b.BorderSizePixel = 0
            b.Text = name
            b.TextColor3 = Color3.fromRGB(230, 210, 255)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 15
            b.Parent = Scroll
            local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 9) bc.Parent = b
            b.MouseButton1Click:Connect(function()
                if CONFIG.Lang == code then return end
                CONFIG.Lang = code
                SaveConfig()
                ShowWaitOverlay(T("Wait") .. "...", LANG_WAIT, function()
                    Main:Destroy()
                    BuildMainMenu()
                end)
            end)
        end

        LangBtn("English", "English")
        LangBtn("Russia / Русский", "Russia")
    end

    local function BuildDevs()
        ClearContent()
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
        frame.BorderSizePixel = 0
        frame.Parent = Scroll
        local fc = Instance.new("UICorner") fc.CornerRadius = UDim.new(0, 10) fc.Parent = frame

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(8, 4, 15)
        bg.BorderSizePixel = 0
        bg.Parent = frame
        local bgc = Instance.new("UICorner") bgc.CornerRadius = UDim.new(0, 10) bgc.Parent = bg

        local enderman = Instance.new("Frame")
        enderman.Size = UDim2.new(0, 120, 0, 200)
        enderman.Position = UDim2.new(1, -130, 0.5, -100)
        enderman.BackgroundTransparency = 1
        enderman.Parent = bg

        local torso = Instance.new("Frame")
        torso.Size = UDim2.new(0, 30, 0, 60)
        torso.Position = UDim2.new(0.5, -15, 0, 30)
        torso.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        torso.BorderSizePixel = 0
        torso.Parent = enderman
        local tc = Instance.new("UICorner") tc.CornerRadius = UDim.new(0, 4) tc.Parent = torso

        local head = Instance.new("Frame")
        head.Size = UDim2.new(0, 34, 0, 30)
        head.Position = UDim2.new(0.5, -17, 0, 0)
        head.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        head.BorderSizePixel = 0
        head.Parent = enderman
        local hc = Instance.new("UICorner") hc.CornerRadius = UDim.new(0, 6) hc.Parent = head

        local eyeL = Instance.new("Frame")
        eyeL.Size = UDim2.new(0, 8, 0, 3)
        eyeL.Position = UDim2.new(0, 6, 0.5, -2)
        eyeL.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
        eyeL.BorderSizePixel = 0
        eyeL.Parent = head
        local elc = Instance.new("UICorner") elc.CornerRadius = UDim.new(1, 0) elc.Parent = eyeL

        local eyeR = Instance.new("Frame")
        eyeR.Size = UDim2.new(0, 8, 0, 3)
        eyeR.Position = UDim2.new(1, -14, 0.5, -2)
        eyeR.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
        eyeR.BorderSizePixel = 0
        eyeR.Parent = head
        local erc = Instance.new("UICorner") erc.CornerRadius = UDim.new(1, 0) erc.Parent = eyeR

        local armL = Instance.new("Frame")
        armL.Size = UDim2.new(0, 8, 0, 70)
        armL.Position = UDim2.new(0.5, -25, 0, 30)
        armL.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        armL.BorderSizePixel = 0
        armL.Parent = enderman
        local alc = Instance.new("UICorner") alc.CornerRadius = UDim.new(0, 3) alc.Parent = armL

        local armR = Instance.new("Frame")
        armR.Size = UDim2.new(0, 8, 0, 70)
        armR.Position = UDim2.new(0.5, 17, 0, 30)
        armR.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        armR.BorderSizePixel = 0
        armR.Parent = enderman
        local arc = Instance.new("UICorner") arc.CornerRadius = UDim.new(0, 3) arc.Parent = armR

        local legL = Instance.new("Frame")
        legL.Size = UDim2.new(0, 10, 0, 70)
        legL.Position = UDim2.new(0.5, -15, 0, 90)
        legL.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        legL.BorderSizePixel = 0
        legL.Parent = enderman
        local llc = Instance.new("UICorner") llc.CornerRadius = UDim.new(0, 3) llc.Parent = legL

        local legR = Instance.new("Frame")
        legR.Size = UDim2.new(0, 10, 0, 70)
        legR.Position = UDim2.new(0.5, 5, 0, 90)
        legR.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        legR.BorderSizePixel = 0
        legR.Parent = enderman
        local lrc = Instance.new("UICorner") lrc.CornerRadius = UDim.new(0, 3) lrc.Parent = legR

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -140, 1, 0)
        lbl.Position = UDim2.new(0, 20, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = T("CreatedByShort")
        lbl.TextColor3 = Color3.fromRGB(210, 150, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 16
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.Parent = bg
    end

    local function SwitchTab(tabName)
        for name, btn in pairs(tabButtons) do
            if name == tabName then
                btn.BackgroundColor3 = Color3.fromRGB(100, 35, 180)
            else
                btn.BackgroundColor3 = Color3.fromRGB(35, 15, 60)
            end
        end
        if tabName == "General" then BuildGeneral()
        elseif tabName == "Combat" then BuildCombat()
        elseif tabName == "Visual" then BuildVisual()
        elseif tabName == "Farm" then BuildFarm()
        elseif tabName == "Language" then BuildLanguage()
        elseif tabName == "Devs" then BuildDevs()
        end
        Scroll.CanvasPosition = Vector2.new(0, 0)
    end

    local function MakeTab(labelText, tabName)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(35, 15, 60)
        btn.BorderSizePixel = 0
        btn.Text = labelText
        btn.TextColor3 = Color3.fromRGB(225, 200, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.Parent = Sidebar
        local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 8) bc.Parent = btn
        tabButtons[tabName] = btn
        btn.MouseButton1Click:Connect(function() SwitchTab(tabName) end)
    end

    MakeTab(T("General"), "General")
    MakeTab(T("Combat"), "Combat")
    MakeTab(T("Visual"), "Visual")
    MakeTab(T("Farm"), "Farm")
    MakeTab(T("Language"), "Language")
    MakeTab(T("Devs"), "Devs")

    SwitchTab("General")

    -- ========== КНОПКА ЗАКРЫТИЯ ==========
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Name = "EnderHubToggle"
    toggleBtn.Size = UDim2.new(0, 60, 0, 60)
    toggleBtn.Position = UDim2.new(0, 20, 0.5, -30)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(15, 5, 25)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Image = "https://i.postimg.cc/jjK8WrRv/diting-result-d5d4d45cbaa511f1b5fa420a27eb69d1-1.jpg"
    toggleBtn.Active = true
    toggleBtn.Draggable = true
    toggleBtn.Parent = ScreenGui

    local tc2 = Instance.new("UICorner") tc2.CornerRadius = UDim.new(0, 10) tc2.Parent = toggleBtn
    local ts2 = Instance.new("UIStroke") ts2.Color = Color3.fromRGB(220, 30, 40) ts2.Thickness = 2 ts2.Parent = toggleBtn

    local menuVisible = true
    toggleBtn.MouseButton1Click:Connect(function()
        menuVisible = not menuVisible
        if menuVisible then
            Main.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        else
            TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.32)
            Main.Visible = false
        end
    end)

    task.spawn(function()
        if CONFIG.Noclip then ToggleNoclip(true) end
        ApplySpeed(CONFIG.Speed)
        RefreshPlayersESP()
    end)
end

-- ========== СТАРТ ==========
task.spawn(function()
    task.wait(LOAD_TIME + 3)
    if CONFIG.Key == KEY_CORRECT then
        BuildMainMenu()
    else
        BuildKeyMenu()
    end
end)
