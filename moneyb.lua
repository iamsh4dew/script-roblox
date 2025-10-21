-- PERSISTENT MONEY SETTER v2.0
-- Mantém o dinheiro sincronizado com servidor

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- GUI Minimalista
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PersistentMoneySetter"
ScreenGui.ResetOnSpawn = false

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
Main.Size = UDim2.new(0, 420, 0, 350)
Main.Position = UDim2.new(0.5, -210, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 50)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "💰 PERSISTENT MONEY SETTER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Main

-- Info Label
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -20, 0, 80)
InfoLabel.Position = UDim2.new(0, 10, 0, 70)
InfoLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
InfoLabel.Text = "⚠️ AVISO IMPORTANTE:\nO jogo tem validação server-side.\nVamos tentar múltiplos métodos para\npersistir o valor no servidor."
InfoLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextSize = 13
InfoLabel.TextWrapped = true
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.Parent = Main

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 8)
InfoCorner.Parent = InfoLabel

local InfoPadding = Instance.new("UIPadding")
InfoPadding.PaddingLeft = UDim.new(0, 10)
InfoPadding.PaddingTop = UDim.new(0, 10)
InfoPadding.Parent = InfoLabel

-- Input de Valor
local ValueInput = Instance.new("TextBox")
ValueInput.Size = UDim2.new(1, -20, 0, 45)
ValueInput.Position = UDim2.new(0, 10, 0, 165)
ValueInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
ValueInput.PlaceholderText = "Digite o valor (ex: 100000)"
ValueInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
ValueInput.Text = ""
ValueInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ValueInput.Font = Enum.Font.Gotham
ValueInput.TextSize = 16
ValueInput.ClearTextOnFocus = false
ValueInput.Parent = Main

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = ValueInput

-- Toggle Persistente
local PersistToggle = Instance.new("Frame")
PersistToggle.Size = UDim2.new(1, -20, 0, 45)
PersistToggle.Position = UDim2.new(0, 10, 0, 220)
PersistToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
PersistToggle.BorderSizePixel = 0
PersistToggle.Parent = Main

local PersistCorner = Instance.new("UICorner")
PersistCorner.CornerRadius = UDim.new(0, 8)
PersistCorner.Parent = PersistToggle

local PersistLabel = Instance.new("TextLabel")
PersistLabel.Size = UDim2.new(1, -70, 1, 0)
PersistLabel.Position = UDim2.new(0, 15, 0, 0)
PersistLabel.BackgroundTransparency = 1
PersistLabel.Text = "🔄 Modo Persistente (Auto Reaplica)"
PersistLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
PersistLabel.Font = Enum.Font.Gotham
PersistLabel.TextSize = 14
PersistLabel.TextXAlignment = Enum.TextXAlignment.Left
PersistLabel.Parent = PersistToggle

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 25)
ToggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
ToggleBtn.Text = ""
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Parent = PersistToggle

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

-- Botão Aplicar
local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(1, -20, 0, 50)
ApplyBtn.Position = UDim2.new(0, 10, 0, 280)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
ApplyBtn.Text = "💵 APLICAR DINHEIRO"
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.TextSize = 18
ApplyBtn.BorderSizePixel = 0
ApplyBtn.Parent = Main

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ApplyBtn

-- Botão Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Variáveis
local persistentMode = false
local targetValue = 0
local moneyElements = {}
local persistentConnection = nil

-- Função para detectar elementos
local function DetectMoneyElements()
    moneyElements = {}
    
    -- Leaderstats
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in pairs(leaderstats:GetChildren()) do
            if stat:IsA("NumberValue") or stat:IsA("IntValue") then
                local name = stat.Name:lower()
                if name:find("cash") or name:find("money") or name:find("coin") or name:find("dollar") then
                    table.insert(moneyElements, stat)
                end
            end
        end
    end
    
    -- PlayerData
    for _, folder in pairs(LocalPlayer:GetChildren()) do
        if folder:IsA("Folder") then
            for _, value in pairs(folder:GetChildren()) do
                if value:IsA("NumberValue") or value:IsA("IntValue") then
                    local name = value.Name:lower()
                    if name:find("cash") or name:find("money") or name:find("coin") then
                        table.insert(moneyElements, value)
                    end
                end
            end
        end
    end
end

-- Função para aplicar dinheiro
local function ApplyMoney(value, silent)
    if not value or value <= 0 then
        if not silent then
            InfoLabel.Text = "❌ Valor inválido!"
            InfoLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
        return
    end
    
    if not silent then
        InfoLabel.Text = "⏳ Aplicando $" .. value .. "...\nTentando múltiplos métodos..."
        InfoLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    end
    
    -- Método 1: Modificar elementos detectados
    for _, elem in ipairs(moneyElements) do
        pcall(function()
            elem.Value = value
        end)
    end
    
    -- Método 2: Enviar via RemoteEvents (múltiplas tentativas)
    task.spawn(function()
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            pcall(function()
                if remote:IsA("RemoteEvent") then
                    local name = remote.Name:lower()
                    -- Tentar diferentes formatos de requisição
                    if name:find("money") or name:find("cash") or name:find("currency") or name:find("update") or name:find("set") or name:find("add") then
                        -- Formato 1: Valor direto
                        remote:FireServer(value)
                        -- Formato 2: Com ação
                        remote:FireServer("SetMoney", value)
                        remote:FireServer("AddMoney", value)
                        remote:FireServer("UpdateMoney", value)
                        -- Formato 3: Tabela
                        remote:FireServer({Type = "Money", Amount = value, Value = value})
                        remote:FireServer({Action = "SetCash", Cash = value, Money = value})
                        remote:FireServer({money = value, cash = value, amount = value})
                        -- Formato 4: Com player
                        remote:FireServer(LocalPlayer, value)
                        remote:FireServer(LocalPlayer, "SetMoney", value)
                    end
                end
            end)
        end
    end)
    
    -- Método 3: Tentar RemoteFunctions
    task.spawn(function()
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            pcall(function()
                if remote:IsA("RemoteFunction") then
                    local name = remote.Name:lower()
                    if name:find("money") or name:find("cash") or name:find("get") or name:find("update") then
                        remote:InvokeServer(value)
                        remote:InvokeServer("SetMoney", value)
                        remote:InvokeServer({money = value})
                    end
                end
            end)
        end
    end)
    
    if not silent then
        task.wait(1)
        InfoLabel.Text = "✅ Aplicado! Valor: $" .. value .. "\n\n⚠️ Se resetar ao comprar, o jogo\ntem proteção server-side forte."
        InfoLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
    end
end

-- Sistema persistente
local function EnablePersistentMode(value)
    if persistentConnection then
        persistentConnection:Disconnect()
        persistentConnection = nil
    end
    
    if value > 0 then
        persistentConnection = RunService.Heartbeat:Connect(function()
            -- Reaplicar continuamente
            for _, elem in ipairs(moneyElements) do
                pcall(function()
                    if elem.Value ~= value then
                        elem.Value = value
                    end
                end)
            end
        end)
        
        -- Também reaplicar via remotes a cada segundo
        task.spawn(function()
            while persistentMode do
                ApplyMoney(value, true)
                task.wait(1)
            end
        end)
    end
end

-- Toggle
local toggled = false
ToggleBtn.MouseButton1Click:Connect(function()
    toggled = not toggled
    persistentMode = toggled
    
    if toggled then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        Indicator.Position = UDim2.new(1, -22, 0.5, -9.5)
        Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        
        if targetValue > 0 then
            EnablePersistentMode(targetValue)
            InfoLabel.Text = "🔄 MODO PERSISTENTE ATIVO\nReaplicando valor a cada segundo..."
            InfoLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        end
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        Indicator.Position = UDim2.new(0, 3, 0.5, -9.5)
        Indicator.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
        
        if persistentConnection then
            persistentConnection:Disconnect()
            persistentConnection = nil
        end
        
        InfoLabel.Text = "✅ Modo persistente desativado"
        InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- Aplicar
ApplyBtn.MouseButton1Click:Connect(function()
    local value = tonumber(ValueInput.Text)
    if value and value > 0 then
        targetValue = value
        DetectMoneyElements()
        ApplyMoney(value, false)
        
        if persistentMode then
            EnablePersistentMode(value)
        end
    else
        InfoLabel.Text = "❌ Digite um valor válido!"
        InfoLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- Fechar
CloseBtn.MouseButton1Click:Connect(function()
    if persistentConnection then
        persistentConnection:Disconnect()
    end
    ScreenGui:Destroy()
end)

-- Detectar ao iniciar
task.wait(1)
DetectMoneyElements()

InfoLabel.Text = "✅ Pronto para usar!\nDetectados " .. #moneyElements .. " elemento(s)"
InfoLabel.TextColor3 = Color3.fromRGB(100, 255, 150)

-- Notificação
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "💰 Persistent Money Setter";
    Text = "Pronto! Use o modo persistente.";
    Duration = 3;
})
