-- BRAINROT HUB PROFESSIONAL v2.0
-- Script otimizado e funcional para Steal a Brainrot

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Proteção GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotHubPro"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- Frame Principal
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 450, 0, 550)
Main.Position = UDim2.new(0.5, -225, 0.5, -275)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ BRAINROT HUB PRO"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local StatusIndicator = Instance.new("Frame")
StatusIndicator.Size = UDim2.new(0, 10, 0, 10)
StatusIndicator.Position = UDim2.new(1, -85, 0.5, -5)
StatusIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
StatusIndicator.BorderSizePixel = 0
StatusIndicator.Parent = TopBar

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(1, 0)
StatusCorner.Parent = StatusIndicator

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -17.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

-- Scroll Container
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -65)
Scroll.Position = UDim2.new(0, 10, 0, 55)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 5
Scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Main

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Scroll

-- Variáveis globais
local settings = {
    autoSteal = false,
    autoLock = false,
    esp = false,
    walkSpeed = 16,
    jumpPower = 50
}

-- Sistema de notificação
local function Notify(text, color)
    StatusIndicator.BackgroundColor3 = color or Color3.fromRGB(0, 255, 150)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ Brainrot Hub Pro";
        Text = text;
        Duration = 3;
    })
    
    task.delay(2, function()
        StatusIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    end)
end

-- Função criar seção
local function CreateSection(text)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, -10, 0, 35)
    Section.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Section.BorderSizePixel = 0
    Section.Parent = Scroll
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(1, -15, 1, 0)
    SectionLabel.Position = UDim2.new(0, 15, 0, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = text
    SectionLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextSize = 14
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    SectionLabel.Parent = Section
    
    return Section
end

-- Função criar botão
local function CreateButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 45)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 15
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false
    Btn.Parent = Scroll
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn
    
    Btn.MouseEnter:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    end)
    
    Btn.MouseLeave:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    end)
    
    Btn.MouseButton1Click:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
        task.wait(0.1)
        Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
        callback()
    end)
    
    return Btn
end

-- Função criar toggle
local function CreateToggle(text, defaultState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 45)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = Scroll
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 15
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 50, 0, 25)
    ToggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ToggleBtn.Text = ""
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleBtn
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 19, 0, 19)
    Indicator.Position = UDim2.new(0, 3, 0.5, -9.5)
    Indicator.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
    Indicator.BorderSizePixel = 0
    Indicator.Parent = ToggleBtn
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator
    
    local toggled = defaultState or false
    
    local function UpdateToggle()
        if toggled then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
            Indicator.Position = UDim2.new(1, -22, 0.5, -9.5)
            Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            Indicator.Position = UDim2.new(0, 3, 0.5, -9.5)
            Indicator.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
        end
    end
    
    UpdateToggle()
    
    ToggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        UpdateToggle()
        callback(toggled)
    end)
    
    return ToggleFrame
end

-- Função criar input
local function CreateInput(placeholder, callback)
    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(1, -10, 0, 45)
    InputFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    InputFrame.BorderSizePixel = 0
    InputFrame.Parent = Scroll
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 8)
    InputCorner.Parent = InputFrame
    
    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -20, 1, 0)
    Input.Position = UDim2.new(0, 10, 0, 0)
    Input.BackgroundTransparency = 1
    Input.PlaceholderText = placeholder
    Input.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    Input.Text = ""
    Input.TextColor3 = Color3.fromRGB(230, 230, 230)
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 15
    Input.ClearTextOnFocus = false
    Input.Parent = InputFrame
    
    Input.FocusLost:Connect(function(enter)
        if enter and Input.Text ~= "" then
            callback(Input.Text)
        end
    end)
    
    return InputFrame
end

-- ============================================
-- SEÇÃO: DINHEIRO
-- ============================================
CreateSection("💰 DINHEIRO")

local moneyInput
moneyInput = CreateInput("Digite o valor (ex: 100000)", function(text)
    local value = tonumber(text)
    if value and value > 0 then
        Notify("Valor configurado: $" .. value, Color3.fromRGB(255, 200, 0))
    else
        Notify("Valor inválido! Use apenas números", Color3.fromRGB(255, 50, 50))
    end
end)

CreateButton("💵 APLICAR DINHEIRO", function()
    local textBox = moneyInput:FindFirstChildOfClass("TextBox")
    local value = tonumber(textBox.Text)
    
    if not value or value <= 0 then
        Notify("Digite um valor válido primeiro!", Color3.fromRGB(255, 50, 50))
        return
    end
    
    Notify("Aplicando $" .. value .. "...", Color3.fromRGB(255, 200, 0))
    
    -- Método 1: Modificar leaderstats
    task.spawn(function()
        pcall(function()
            local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
            if leaderstats then
                for _, stat in pairs(leaderstats:GetChildren()) do
                    if stat:IsA("NumberValue") or stat:IsA("IntValue") then
                        if stat.Name:lower():find("cash") or stat.Name:lower():find("money") or stat.Name:lower():find("coin") then
                            stat.Value = value
                        end
                    end
                end
            end
        end)
    end)
    
    -- Método 2: Buscar remotes específicos
    task.spawn(function()
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            pcall(function()
                if remote:IsA("RemoteEvent") then
                    local name = remote.Name:lower()
                    if name:find("money") or name:find("cash") or name:find("currency") or name:find("coin") or name:find("add") then
                        remote:FireServer(value)
                        remote:FireServer("SetMoney", value)
                        remote:FireServer({Type = "Money", Amount = value})
                        remote:FireServer({money = value})
                    end
                end
            end)
        end
    end)
    
    task.wait(1)
    Notify("Aplicado! Verifique sua conta", Color3.fromRGB(0, 255, 150))
end)

-- ============================================
-- SEÇÃO: AUTO ROUBO
-- ============================================
CreateSection("⭐ AUTO ROUBO DE BRAINROTS")

CreateToggle("Auto Roubar Brainrots Raros", false, function(enabled)
    settings.autoSteal = enabled
    
    if enabled then
        Notify("Auto Roubo ATIVADO", Color3.fromRGB(200, 100, 255))
        
        task.spawn(function()
            while settings.autoSteal and task.wait(2) do
                pcall(function()
                    local char = LocalPlayer.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                    
                    local hrp = char.HumanoidRootPart
                    local humanoid = char:FindFirstChild("Humanoid")
                    if not humanoid or humanoid.Health <= 0 then return end
                    
                    -- Procurar brainrots de outros jogadores
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            -- Procurar base do player
                            local baseName = player.Name .. "'s Base"
                            local playerBase = Workspace:FindFirstChild(baseName) or Workspace:FindFirstChild(player.Name)
                            
                            if playerBase then
                                -- Procurar brainrots na base
                                for _, obj in pairs(playerBase:GetDescendants()) do
                                    if not settings.autoSteal then break end
                                    
                                    if obj:IsA("Model") then
                                        local objName = obj.Name:lower()
                                        
                                        -- Verificar se é um brainrot raro
                                        if objName:find("epic") or objName:find("rare") or objName:find("legendary") or 
                                           objName:find("secret") or objName:find("mythic") or objName:find("special") then
                                            
                                            -- Teleportar
                                            local targetPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                                            if targetPart then
                                                hrp.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0)
                                                task.wait(0.5)
                                                
                                                -- Coletar
                                                for _, child in pairs(obj:GetDescendants()) do
                                                    if child:IsA("ProximityPrompt") then
                                                        if fireproximityprompt then
                                                            fireproximityprompt(child, 0)
                                                        end
                                                    elseif child:IsA("ClickDetector") then
                                                        if fireclickdetector then
                                                            fireclickdetector(child)
                                                        end
                                                    end
                                                end
                                                
                                                task.wait(1)
                                            end
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
        Notify("Auto Roubo DESATIVADO", Color3.fromRGB(255, 100, 100))
    end
end)

CreateToggle("ESP Brainrots Raros", false, function(enabled)
    settings.esp = enabled
    
    if enabled then
        Notify("ESP ATIVADO", Color3.fromRGB(0, 255, 200))
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("Model") then
                    local name = obj.Name:lower()
                    if name:find("epic") or name:find("rare") or name:find("legendary") or name:find("secret") then
                        if not obj:FindFirstChild("ESP_HL") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "ESP_HL"
                            hl.FillColor = Color3.fromRGB(255, 100, 255)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                            hl.FillTransparency = 0.4
                            hl.OutlineTransparency = 0
                            hl.Parent = obj
                        end
                    end
                end
            end)
        end
    else
        Notify("ESP DESATIVADO", Color3.fromRGB(255, 100, 100))
        
        for _, hl in pairs(Workspace:GetDescendants()) do
            if hl.Name == "ESP_HL" and hl:IsA("Highlight") then
                hl:Destroy()
            end
        end
    end
end)

-- ============================================
-- SEÇÃO: PROTEÇÃO DE BASE
-- ============================================
CreateSection("🛡️ PROTEÇÃO DE BASE")

CreateToggle("Auto Lock Base (60s)", false, function(enabled)
    settings.autoLock = enabled
    
    if enabled then
        Notify("Auto Lock ATIVADO", Color3.fromRGB(100, 200, 255))
        
        task.spawn(function()
            while settings.autoLock and task.wait(61) do
                pcall(function()
                    -- Método 1: Procurar botão de lock na GUI
                    for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                        if gui:IsA("TextButton") then
                            local text = gui.Text:lower()
                            local name = gui.Name:lower()
                            
                            if text:find("lock") or name:find("lock") or text:find("travar") then
                                -- Simular clique
                                if getconnections then
                                    for _, conn in pairs(getconnections(gui.MouseButton1Click)) do
                                        conn:Fire()
                                    end
                                end
                                
                                Notify("Base travada automaticamente", Color3.fromRGB(0, 255, 150))
                                break
                            end
                        end
                    end
                    
                    -- Método 2: Tentar via remote
                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") and remote.Name:lower():find("lock") then
                            remote:FireServer(true)
                            remote:FireServer("Lock", true)
                            remote:FireServer({Action = "LockBase"})
                        end
                    end
                end)
            end
        end)
    else
        Notify("Auto Lock DESATIVADO", Color3.fromRGB(255, 100, 100))
    end
end)

CreateButton("🔒 TRAVAR BASE AGORA", function()
    Notify("Travando base...", Color3.fromRGB(255, 200, 0))
    
    local locked = false
    
    for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        pcall(function()
            if gui:IsA("TextButton") then
                local text = gui.Text:lower()
                if text:find("lock") or text:find("travar") then
                    if getconnections then
                        for _, conn in pairs(getconnections(gui.MouseButton1Click)) do
                            conn:Fire()
                            locked = true
                        end
                    end
                end
            end
        end)
    end
    
    if locked then
        Notify("Base travada com sucesso!", Color3.fromRGB(0, 255, 150))
    else
        Notify("Botão de lock não encontrado", Color3.fromRGB(255, 150, 50))
    end
end)

-- ============================================
-- SEÇÃO: UTILIDADES
-- ============================================
CreateSection("🔧 UTILIDADES")

CreateButton("⚡ Velocidade +100", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
        settings.walkSpeed = 100
        Notify("Velocidade: 100", Color3.fromRGB(0, 255, 200))
    end
end)

CreateButton("🦘 Pulo Alto", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 120
        settings.jumpPower = 120
        Notify("Pulo aumentado!", Color3.fromRGB(0, 255, 200))
    end
end)

CreateButton("💤 Anti AFK", function()
    local VU = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
    Notify("Anti AFK ativado!", Color3.fromRGB(0, 255, 200))
end)

CreateButton("🔄 Reset Velocidade/Pulo", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
        Notify("Valores resetados", Color3.fromRGB(200, 200, 200))
    end
end)

-- Fechar GUI
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Notificação inicial
Notify("Script carregado com sucesso!", Color3.fromRGB(0, 255, 150))
