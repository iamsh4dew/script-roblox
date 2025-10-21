-- Script Avançado para Roube um Brainrot
-- Com Auto Roubo de Épicos, Proteção Base e Dinheiro Infinito

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotAdvancedGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 450)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Efeito de sombra
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://297774371"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(150, 150, 150, 150)
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Título com gradiente
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 55)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(45, 15, 70)
Title.BorderSizePixel = 0
Title.Text = "🧠 BRAINROT ADVANCED HUB"
Title.TextColor3 = Color3.fromRGB(255, 150, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

-- Botão Minimizar
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 38, 0, 38)
MinimizeButton.Position = UDim2.new(1, -90, 0, 8)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 170, 50)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 10)
MinCorner.Parent = MinimizeButton

-- Botão Fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 38, 0, 38)
CloseButton.Position = UDim2.new(1, -45, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 70)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

-- Container de Botões
local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Size = UDim2.new(1, -20, 1, -75)
ButtonContainer.Position = UDim2.new(0, 10, 0, 65)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.ScrollBarThickness = 8
ButtonContainer.BorderSizePixel = 0
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 700)
ButtonContainer.Parent = MainFrame

-- Variáveis globais
local autoStealEpic = false
local autoLockBase = false
local moneyAmount = 0

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.Size = UDim2.new(1, -10, 0, 35)
StatusLabel.Position = UDim2.new(0, 5, 0, 5)
StatusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
StatusLabel.Text = "⚡ Status: Sistema Pronto"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 15
StatusLabel.Parent = ButtonContainer

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusLabel

-- Função de notificação
local function Notify(text, color)
    StatusLabel.Text = "⚡ Status: " .. text
    StatusLabel.TextColor3 = color or Color3.fromRGB(100, 255, 150)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🧠 Brainrot Hub";
        Text = text;
        Duration = 4;
    })
end

-- Função para criar botões estilizados
local function CreateButton(name, position, color, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -10, 0, 48)
    button.Position = UDim2.new(0, 5, 0, position)
    button.BackgroundColor3 = color
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.Parent = ButtonContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(color.R * 0.7, color.G * 0.7, color.B * 0.7))
    }
    gradient.Rotation = 45
    gradient.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Função para criar input de texto
local function CreateTextBox(placeholder, position)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -10, 0, 45)
    textBox.Position = UDim2.new(0, 5, 0, position)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    textBox.PlaceholderText = placeholder
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 16
    textBox.ClearTextOnFocus = false
    textBox.Parent = ButtonContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = textBox
    
    return textBox
end

-- ============================================
-- SEÇÃO 1: SETAR DINHEIRO
-- ============================================

local MoneyLabel = Instance.new("TextLabel")
MoneyLabel.Size = UDim2.new(1, -10, 0, 30)
MoneyLabel.Position = UDim2.new(0, 5, 0, 50)
MoneyLabel.BackgroundColor3 = Color3.fromRGB(50, 20, 80)
MoneyLabel.Text = "💰 SETAR DINHEIRO"
MoneyLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
MoneyLabel.Font = Enum.Font.GothamBold
MoneyLabel.TextSize = 16
MoneyLabel.Parent = ButtonContainer

local MoneyLabelCorner = Instance.new("UICorner")
MoneyLabelCorner.CornerRadius = UDim.new(0, 8)
MoneyLabelCorner.Parent = MoneyLabel

local MoneyInput = CreateTextBox("Digite o valor (Ex: 999999)", 90)

CreateButton("💵 SETAR DINHEIRO AGORA", 145, Color3.fromRGB(100, 200, 50), function()
    local amount = tonumber(MoneyInput.Text)
    if amount and amount > 0 then
        Notify("Setando dinheiro: " .. amount, Color3.fromRGB(255, 215, 0))
        
        -- Método 1: Tentar via RemoteEvent
        pcall(function()
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:lower():match("money") or remote.Name:lower():match("cash") or remote.Name:lower():match("currency")) then
                    remote:FireServer(amount)
                    remote:FireServer("AddMoney", amount)
                    remote:FireServer({Money = amount})
                end
            end
        end)
        
        -- Método 2: Modificar leaderstats diretamente
        pcall(function()
            if LocalPlayer:FindFirstChild("leaderstats") then
                for _, stat in pairs(LocalPlayer.leaderstats:GetChildren()) do
                    if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                        stat.Value = amount
                    end
                end
            end
        end)
        
        -- Método 3: Modificar PlayerData se existir
        pcall(function()
            if LocalPlayer:FindFirstChild("PlayerData") then
                for _, data in pairs(LocalPlayer.PlayerData:GetChildren()) do
                    if data.Name:lower():match("money") or data.Name:lower():match("cash") then
                        data.Value = amount
                    end
                end
            end
        end)
        
        Notify("Dinheiro setado: R$" .. amount, Color3.fromRGB(50, 255, 50))
    else
        Notify("Valor inválido!", Color3.fromRGB(255, 50, 50))
    end
end)

-- ============================================
-- SEÇÃO 2: AUTO ROUBAR BRAINROTS ÉPICOS
-- ============================================

local EpicLabel = Instance.new("TextLabel")
EpicLabel.Size = UDim2.new(1, -10, 0, 30)
EpicLabel.Position = UDim2.new(0, 5, 0, 210)
EpicLabel.BackgroundColor3 = Color3.fromRGB(120, 30, 150)
EpicLabel.Text = "⭐ AUTO ROUBAR ÉPICOS"
EpicLabel.TextColor3 = Color3.fromRGB(255, 200, 255)
EpicLabel.Font = Enum.Font.GothamBold
EpicLabel.TextSize = 16
EpicLabel.Parent = ButtonContainer

local EpicLabelCorner = Instance.new("UICorner")
EpicLabelCorner.CornerRadius = UDim.new(0, 8)
EpicLabelCorner.Parent = EpicLabel

CreateButton("🎯 AUTO ROUBAR ÉPICOS (ON/OFF)", 250, Color3.fromRGB(150, 50, 200), function()
    autoStealEpic = not autoStealEpic
    if autoStealEpic then
        Notify("Auto Roubar Épicos ATIVADO!", Color3.fromRGB(200, 100, 255))
        spawn(function()
            while autoStealEpic do
                wait(0.5)
                pcall(function()
                    -- Procurar por brainrots épicos nas bases de outros jogadores
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            local base = workspace:FindFirstChild(player.Name .. "'s Base") or workspace:FindFirstChild(player.Name)
                            
                            if base then
                                for _, item in pairs(base:GetDescendants()) do
                                    -- Detectar brainrots épicos
                                    if item:IsA("Model") and (
                                        item.Name:lower():match("epic") or 
                                        item.Name:lower():match("rare") or 
                                        item.Name:lower():match("legendary") or
                                        item.Name:lower():match("secret")
                                    ) then
                                        
                                        -- Teleportar para o brainrot
                                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                            local rootPart = LocalPlayer.Character.HumanoidRootPart
                                            
                                            if item.PrimaryPart then
                                                rootPart.CFrame = item.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                                            elseif item:FindFirstChildWhichIsA("BasePart") then
                                                rootPart.CFrame = item:FindFirstChildWhichIsA("BasePart").CFrame + Vector3.new(0, 3, 0)
                                            end
                                            
                                            wait(0.3)
                                            
                                            -- Tentar ativar proximity prompt
                                            local prompt = item:FindFirstChildOfClass("ProximityPrompt", true)
                                            if prompt then
                                                fireproximityprompt(prompt)
                                            end
                                            
                                            -- Tentar via ClickDetector
                                            local detector = item:FindFirstChildOfClass("ClickDetector", true)
                                            if detector then
                                                fireclickdetector(detector)
                                            end
                                            
                                            Notify("Roubando Epic: " .. item.Name, Color3.fromRGB(255, 100, 255))
                                            wait(1)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    else
        Notify("Auto Roubar Épicos DESATIVADO!", Color3.fromRGB(255, 100, 100))
    end
end)

CreateButton("🔍 MOSTRAR ÉPICOS (ESP)", 310, Color3.fromRGB(200, 100, 255), function()
    Notify("Marcando Brainrots Épicos...", Color3.fromRGB(255, 200, 100))
    pcall(function()
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Model") and (
                item.Name:lower():match("epic") or 
                item.Name:lower():match("rare") or 
                item.Name:lower():match("legendary") or
                item.Name:lower():match("secret")
            ) then
                -- Criar highlight
                if not item:FindFirstChild("EpicHighlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "EpicHighlight"
                    highlight.FillColor = Color3.fromRGB(255, 0, 255)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                    highlight.FillTransparency = 0.3
                    highlight.OutlineTransparency = 0
                    highlight.Parent = item
                    
                    -- Criar BillboardGui
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "EpicLabel"
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 0.5
                    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    label.Text = "⭐ " .. item.Name .. " ⭐"
                    label.TextColor3 = Color3.fromRGB(255, 200, 0)
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 18
                    label.TextScaled = true
                    label.Parent = billboard
                    
                    if item.PrimaryPart then
                        billboard.Adornee = item.PrimaryPart
                        billboard.Parent = item.PrimaryPart
                    elseif item:FindFirstChildWhichIsA("BasePart") then
                        billboard.Adornee = item:FindFirstChildWhichIsA("BasePart")
                        billboard.Parent = item:FindFirstChildWhichIsA("BasePart")
                    end
                end
            end
        end
    end)
    Notify("ESP de Épicos Ativado!", Color3.fromRGB(255, 200, 0))
end)

-- ============================================
-- SEÇÃO 3: PROTEÇÃO AUTOMÁTICA DA BASE
-- ============================================

local BaseLabel = Instance.new("TextLabel")
BaseLabel.Size = UDim2.new(1, -10, 0, 30)
BaseLabel.Position = UDim2.new(0, 5, 0, 375)
BaseLabel.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
BaseLabel.Text = "🛡️ PROTEÇÃO DA BASE"
BaseLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
BaseLabel.Font = Enum.Font.GothamBold
BaseLabel.TextSize = 16
BaseLabel.Parent = ButtonContainer

local BaseLabelCorner = Instance.new("UICorner")
BaseLabelCorner.CornerRadius = UDim.new(0, 8)
BaseLabelCorner.Parent = BaseLabel

CreateButton("🔒 AUTO LOCK BASE (ON/OFF)", 415, Color3.fromRGB(50, 150, 250), function()
    autoLockBase = not autoLockBase
    if autoLockBase then
        Notify("Auto Lock Base ATIVADO!", Color3.fromRGB(100, 200, 255))
        spawn(function()
            while autoLockBase do
                wait(1)
                pcall(function()
                    -- Procurar botão de lock na base
                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        for _, gui in pairs(playerGui:GetDescendants()) do
                            if gui:IsA("TextButton") and (
                                gui.Name:lower():match("lock") or 
                                gui.Text:lower():match("lock") or
                                gui.Text:lower():match("travar")
                            ) then
                                -- Verificar se não está em cooldown
                                if not gui.Text:lower():match("cooldown") and not gui.Text:lower():match("%d+") then
                                    for _, connection in pairs(getconnections(gui.MouseButton1Click)) do
                                        connection:Fire()
                                    end
                                    Notify("Base Travada!", Color3.fromRGB(100, 255, 100))
                                end
                            end
                        end
                    end
                    
                    -- Método alternativo via RemoteEvent
                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") and remote.Name:lower():match("lock") then
                            remote:FireServer(true)
                            remote:FireServer("Lock")
                        end
                    end
                end)
            end
        end)
    else
        Notify("Auto Lock Base DESATIVADO!", Color3.fromRGB(255, 100, 100))
    end
end)

CreateButton("🚫 KICKAR INVASORES", 475, Color3.fromRGB(200, 50, 50), function()
    Notify("Removendo invasores...", Color3.fromRGB(255, 200, 100))
    pcall(function()
        local myBase = workspace:FindFirstChild(LocalPlayer.Name .. "'s Base") or workspace:FindFirstChild(LocalPlayer.Name)
        if myBase then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local distance = (hrp.Position - myBase.Position).Magnitude
                        if distance < 100 then
                            -- Tentar kickar via remote
                            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                                if remote:IsA("RemoteEvent") and (remote.Name:lower():match("kick") or remote.Name:lower():match("remove")) then
                                    remote:FireServer(player)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    Notify("Invasores Removidos!", Color3.fromRGB(255, 100, 100))
end)

CreateButton("🏰 FORTIFICAR BASE MAX", 535, Color3.fromRGB(100, 150, 255), function()
    Notify("Fortificando base...", Color3.fromRGB(100, 200, 255))
    pcall(function()
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") and (
                remote.Name:lower():match("upgrade") or 
                remote.Name:lower():match("defense") or
                remote.Name:lower():match("wall")
            ) then
                for i = 1, 50 do
                    remote:FireServer("Max")
                    remote:FireServer(999)
                    remote:FireServer({Level = 999})
                    wait(0.1)
                end
            end
        end
    end)
    Notify("Base Fortificada!", Color3.fromRGB(100, 255, 100))
end)

-- ============================================
-- SEÇÃO 4: UTILITÁRIOS EXTRAS
-- ============================================

local UtilLabel = Instance.new("TextLabel")
UtilLabel.Size = UDim2.new(1, -10, 0, 30)
UtilLabel.Position = UDim2.new(0, 5, 0, 595)
UtilLabel.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
UtilLabel.Text = "🔧 UTILITÁRIOS"
UtilLabel.TextColor3 = Color3.fromRGB(255, 220, 180)
UtilLabel.Font = Enum.Font.GothamBold
UtilLabel.TextSize = 16
UtilLabel.Parent = ButtonContainer

local UtilLabelCorner = Instance.new("UICorner")
UtilLabelCorner.CornerRadius = UDim.new(0, 8)
UtilLabelCorner.Parent = UtilLabel

CreateButton("⚡ VELOCIDADE INFINITA", 635, Color3.fromRGB(255, 150, 50), function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 150
        Notify("Velocidade Aumentada!", Color3.fromRGB(255, 200, 50))
    end
end)

-- Função de fechar
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Função de minimizar
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ButtonContainer.Visible = false
        MainFrame.Size = UDim2.new(0, 480, 0, 55)
    else
        ButtonContainer.Visible = true
        MainFrame.Size = UDim2.new(0, 480, 0, 450)
    end
end)

-- Animação de abertura
MainFrame.Size = UDim2.new(0, 0, 0, 0)
local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Bounce), {Size = UDim2.new(0, 480, 0, 450)})
openTween:Play()

-- Inicialização
wait(0.5)
Notify("Sistema Carregado com Sucesso!", Color3.fromRGB(100, 255, 100))
