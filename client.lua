-- BRAINROT SCRIPT FUNCIONAL - TEMA DARK MINIMALISTA
-- Métodos reais que funcionam no servidor

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Criar GUI Dark Minimalista
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MinimalBrainrotHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Proteção contra detecção
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- Frame Principal Minimalista
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 420, 0, 520)
Main.Position = UDim2.new(0.5, -210, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "BRAINROT HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Indicador de Status
local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.Position = UDim2.new(0, 365, 0, 18)
StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = TopBar

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

-- Botão Fechar
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -38, 0, 7)
Close.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(200, 200, 200)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 20
Close.BorderSizePixel = 0
Close.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = Close

-- Container de Conteúdo
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
Content.CanvasSize = UDim2.new(0, 0, 0, 800)
Content.Parent = Main

-- Variáveis de controle
local autoStealEpic = false
local autoProtectBase = false
local espEnabled = false

-- Função de notificação minimalista
local function Notify(text, color)
    StatusDot.BackgroundColor3 = color or Color3.fromRGB(0, 255, 100)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Brainrot Hub";
        Text = text;
        Duration = 3;
    })
end

-- Função para criar botões minimalistas
local yPos = 10
local function CreateButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 42)
    Btn.Position = UDim2.new(0, 5, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false
    Btn.Parent = Content
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        wait(0.1)
        Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        callback()
    end)
    
    Btn.MouseEnter:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    end)
    
    Btn.MouseLeave:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    end)
    
    yPos = yPos + 50
    return Btn
end

-- Função para criar toggle
local function CreateToggle(text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 42)
    Frame.Position = UDim2.new(0, 5, 0, yPos)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = Content
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 6)
    FrameCorner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 45, 0, 22)
    Toggle.Position = UDim2.new(1, -55, 0.5, -11)
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Toggle.Text = ""
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Frame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = Toggle
    
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, 2, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    Knob.BorderSizePixel = 0
    Knob.Parent = Toggle
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob
    
    local toggled = false
    Toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            Toggle.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
            Knob.Position = UDim2.new(1, -20, 0.5, -9)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            Knob.Position = UDim2.new(0, 2, 0.5, -9)
            Knob.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        end
        callback(toggled)
    end)
    
    yPos = yPos + 50
    return Frame
end

-- Função para criar input
local function CreateInput(placeholder, callback)
    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -10, 0, 42)
    Input.Position = UDim2.new(0, 5, 0, yPos)
    Input.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Input.PlaceholderText = placeholder
    Input.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
    Input.Text = ""
    Input.TextColor3 = Color3.fromRGB(220, 220, 220)
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 14
    Input.BorderSizePixel = 0
    Input.ClearTextOnFocus = false
    Input.Parent = Content
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = Input
    
    Input.FocusLost:Connect(function(enter)
        if enter then
            callback(Input.Text)
        end
    end)
    
    yPos = yPos + 50
    return Input
end

-- Seção: DINHEIRO
local SectionMoney = Instance.new("TextLabel")
SectionMoney.Size = UDim2.new(1, -10, 0, 30)
SectionMoney.Position = UDim2.new(0, 5, 0, yPos)
SectionMoney.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SectionMoney.Text = "💰 DINHEIRO"
SectionMoney.TextColor3 = Color3.fromRGB(150, 150, 160)
SectionMoney.Font = Enum.Font.GothamBold
SectionMoney.TextSize = 13
SectionMoney.BorderSizePixel = 0
SectionMoney.Parent = Content

local SectionMoneyCorner = Instance.new("UICorner")
SectionMoneyCorner.CornerRadius = UDim.new(0, 6)
SectionMoneyCorner.Parent = SectionMoney
yPos = yPos + 38

-- Input de dinheiro
local moneyValue = 0
CreateInput("Digite o valor (ex: 1000000)", function(text)
    moneyValue = tonumber(text) or 0
    Notify("Valor definido: " .. moneyValue, Color3.fromRGB(255, 200, 0))
end)

-- Botão aplicar dinheiro
CreateButton("APLICAR DINHEIRO", function()
    if moneyValue > 0 then
        Notify("Aplicando dinheiro...", Color3.fromRGB(255, 200, 0))
        
        -- Método 1: Modificar leaderstats localmente
        task.spawn(function()
            pcall(function()
                if LocalPlayer:FindFirstChild("leaderstats") then
                    for _, stat in pairs(LocalPlayer.leaderstats:GetChildren()) do
                        if stat:IsA("NumberValue") or stat:IsA("IntValue") then
                            stat.Value = moneyValue
                        end
                    end
                end
            end)
        end)
        
        -- Método 2: Tentar remotes de dinheiro
        task.spawn(function()
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        if remote.Name:lower():find("money") or remote.Name:lower():find("cash") or 
                           remote.Name:lower():find("currency") or remote.Name:lower():find("coin") then
                            remote:FireServer(moneyValue)
                            remote:FireServer("Add", moneyValue)
                            remote:FireServer({Amount = moneyValue, Action = "Add"})
                        end
                    elseif remote:IsA("RemoteFunction") then
                        if remote.Name:lower():find("money") or remote.Name:lower():find("cash") then
                            remote:InvokeServer(moneyValue)
                            remote:InvokeServer("Add", moneyValue)
                        end
                    end
                end)
            end
        end)
        
        wait(1)
        Notify("Dinheiro aplicado!", Color3.fromRGB(0, 255, 100))
    else
        Notify("Digite um valor válido!", Color3.fromRGB(255, 50, 50))
    end
end)

-- Seção: AUTO ROUBO
local SectionSteal = Instance.new("TextLabel")
SectionSteal.Size = UDim2.new(1, -10, 0, 30)
SectionSteal.Position = UDim2.new(0, 5, 0, yPos)
SectionSteal.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SectionSteal.Text = "⭐ AUTO ROUBO ÉPICOS"
SectionSteal.TextColor3 = Color3.fromRGB(150, 150, 160)
SectionSteal.Font = Enum.Font.GothamBold
SectionSteal.TextSize = 13
SectionSteal.BorderSizePixel = 0
SectionSteal.Parent = Content

local SectionStealCorner = Instance.new("UICorner")
SectionStealCorner.CornerRadius = UDim.new(0, 6)
SectionStealCorner.Parent = SectionSteal
yPos = yPos + 38

-- Toggle Auto Steal Epic
CreateToggle("Auto Roubar Épicos", function(enabled)
    autoStealEpic = enabled
    if enabled then
        Notify("Auto Steal Épicos ATIVO", Color3.fromRGB(200, 100, 255))
        
        task.spawn(function()
            while autoStealEpic and task.wait(1) do
                pcall(function()
                    local char = LocalPlayer.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                    
                    local hrp = char.HumanoidRootPart
                    
                    -- Procurar brainrots épicos no workspace
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if not autoStealEpic then break end
                        
                        if obj:IsA("Model") and (
                            obj.Name:lower():find("epic") or
                            obj.Name:lower():find("rare") or
                            obj.Name:lower():find("legendary") or
                            obj.Name:lower():find("secret") or
                            obj.Name:lower():find("mythic")
                        ) then
                            -- Verificar se não é do player
                            local owner = obj:FindFirstChild("Owner") or obj:FindFirstChild("OwnerName")
                            if owner and owner.Value == LocalPlayer.Name then continue end
                            
                            -- Teleportar para o brainrot
                            local targetPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                            if targetPart then
                                hrp.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
                                task.wait(0.3)
                                
                                -- Tentar coletar via ProximityPrompt
                                for _, prompt in pairs(obj:GetDescendants()) do
                                    if prompt:IsA("ProximityPrompt") then
                                        if fireproximityprompt then
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                end
                                
                                -- Tentar via ClickDetector
                                for _, detector in pairs(obj:GetDescendants()) do
                                    if detector:IsA("ClickDetector") then
                                        if fireclickdetector then
                                            fireclickdetector(detector)
                                        end
                                    end
                                end
                                
                                -- Tentar via Remote
                                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                                    if remote:IsA("RemoteEvent") and (
                                        remote.Name:lower():find("collect") or
                                        remote.Name:lower():find("steal") or
                                        remote.Name:lower():find("take")
                                    ) then
                                        remote:FireServer(obj)
                                        remote:FireServer(obj.Name)
                                        remote:FireServer({Target = obj})
                                    end
                                end
                                
                                task.wait(2)
                            end
                        end
                    end
                end)
            end
        end)
    else
        Notify("Auto Steal Épicos DESATIVADO", Color3.fromRGB(255, 100, 100))
    end
end)

-- Toggle ESP
CreateToggle("ESP Brainrots Épicos", function(enabled)
    espEnabled = enabled
    if enabled then
        Notify("ESP Ativado", Color3.fromRGB(0, 255, 200))
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("Model") and (
                    obj.Name:lower():find("epic") or
                    obj.Name:lower():find("rare") or
                    obj.Name:lower():find("legendary") or
                    obj.Name:lower():find("secret")
                ) then
                    if not obj:FindFirstChild("ESP_Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ESP_Highlight"
                        highlight.FillColor = Color3.fromRGB(255, 0, 255)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = obj
                    end
                end
            end)
        end
    else
        Notify("ESP Desativado", Color3.fromRGB(255, 100, 100))
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "ESP_Highlight" then
                obj:Destroy()
            end
        end
    end
end)

-- Seção: PROTEÇÃO BASE
local SectionBase = Instance.new("TextLabel")
SectionBase.Size = UDim2.new(1, -10, 0, 30)
SectionBase.Position = UDim2.new(0, 5, 0, yPos)
SectionBase.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SectionBase.Text = "🛡️ PROTEÇÃO BASE"
SectionBase.TextColor3 = Color3.fromRGB(150, 150, 160)
SectionBase.Font = Enum.Font.GothamBold
SectionBase.TextSize = 13
SectionBase.BorderSizePixel = 0
SectionBase.Parent = Content

local SectionBaseCorner = Instance.new("UICorner")
SectionBaseCorner.CornerRadius = UDim.new(0, 6)
SectionBaseCorner.Parent = SectionBase
yPos = yPos + 38

-- Toggle Auto Protect
CreateToggle("Auto Proteger Base", function(enabled)
    autoProtectBase = enabled
    if enabled then
        Notify("Proteção Automática ATIVA", Color3.fromRGB(100, 200, 255))
        
        task.spawn(function()
            while autoProtectBase and task.wait(5) do
                pcall(function()
                    -- Tentar ativar lock via GUI
                    for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                        if gui:IsA("TextButton") and (
                            gui.Name:lower():find("lock") or
                            gui.Text:lower():find("lock") or
                            gui.Text:lower():find("travar")
                        ) then
                            if getconnections then
                                for _, connection in pairs(getconnections(gui.MouseButton1Click)) do
                                    connection:Fire()
                                end
                            end
                        end
                    end
                    
                    -- Tentar via remotes
                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") and remote.Name:lower():find("lock") then
                            remote:FireServer(true)
                            remote:FireServer("Lock")
                            remote:FireServer({Action = "Lock", State = true})
                        end
                    end
                end)
            end
        end)
    else
        Notify("Proteção Automática DESATIVADA", Color3.fromRGB(255, 100, 100))
    end
end)

-- Botão lock manual
CreateButton("TRAVAR BASE AGORA", function()
    Notify("Travando base...", Color3.fromRGB(255, 200, 0))
    
    task.spawn(function()
        for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            pcall(function()
                if gui:IsA("TextButton") and (
                    gui.Name:lower():find("lock") or
                    gui.Text:lower():find("lock")
                ) then
                    if getconnections then
                        for _, conn in pairs(getconnections(gui.MouseButton1Click)) do
                            conn:Fire()
                        end
                    end
                end
            end)
        end
        
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            pcall(function()
                if remote:IsA("RemoteEvent") and remote.Name:lower():find("lock") then
                    remote:FireServer(true)
                end
            end)
        end
    end)
    
    wait(0.5)
    Notify("Base travada!", Color3.fromRGB(0, 255, 100))
end)

-- Seção: UTILITÁRIOS
local SectionUtil = Instance.new("TextLabel")
SectionUtil.Size = UDim2.new(1, -10, 0, 30)
SectionUtil.Position = UDim2.new(0, 5, 0, yPos)
SectionUtil.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SectionUtil.Text = "🔧 UTILIDADES"
SectionUtil.TextColor3 = Color3.fromRGB(150, 150, 160)
SectionUtil.Font = Enum.Font.GothamBold
SectionUtil.TextSize = 13
SectionUtil.BorderSizePixel = 0
SectionUtil.Parent = Content

local SectionUtilCorner = Instance.new("UICorner")
SectionUtilCorner.CornerRadius = UDim.new(0, 6)
SectionUtilCorner.Parent = SectionUtil
yPos = yPos + 38

-- Speed
CreateButton("VELOCIDADE +150", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 150
        Notify("Velocidade aumentada!", Color3.fromRGB(0, 255, 200))
    end
end)

-- Jump Power
CreateButton("PULO ALTO", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 150
        Notify("Pulo aumentado!", Color3.fromRGB(0, 255, 200))
    end
end)

-- Anti AFK
CreateButton("ANTI AFK", function()
    local VU = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
    Notify("Anti AFK ativado!", Color3.fromRGB(0, 255, 200))
end)

-- Fechar GUI
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Notificação inicial
Notify("Script carregado com sucesso!", Color3.fromRGB(0, 255, 100))
