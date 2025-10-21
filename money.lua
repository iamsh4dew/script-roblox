-- MONEY SETTER AUTO-DETECT v1.0
-- Detecta automaticamente elementos de dinheiro do jogo

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GUI Minimalista
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoneySetterPro"
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
Main.Size = UDim2.new(0, 400, 0, 280)
Main.Position = UDim2.new(0.5, -200, 0.5, -140)
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
Title.Text = "💰 AUTO MONEY SETTER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Main

-- Info Label
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -20, 0, 60)
InfoLabel.Position = UDim2.new(0, 10, 0, 70)
InfoLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
InfoLabel.Text = "🔍 Detectando elementos...\nAguarde..."
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextSize = 14
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
ValueInput.Position = UDim2.new(0, 10, 0, 145)
ValueInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
ValueInput.PlaceholderText = "Digite o valor (ex: 1000000)"
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

-- Botão Aplicar
local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(1, -20, 0, 50)
ApplyBtn.Position = UDim2.new(0, 10, 0, 205)
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

-- Sistema de detecção automática
local detectedElements = {}

local function ScanForMoneyElements()
    detectedElements = {}
    local elementCount = 0
    
    -- 1. Procurar em leaderstats
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in pairs(leaderstats:GetChildren()) do
            if stat:IsA("NumberValue") or stat:IsA("IntValue") then
                local name = stat.Name:lower()
                if name:find("cash") or name:find("money") or name:find("coin") or name:find("dollar") or name:find("currency") or name:find("gold") then
                    table.insert(detectedElements, {
                        Type = "Leaderstats",
                        Object = stat,
                        Name = stat.Name,
                        Path = "Player.leaderstats." .. stat.Name
                    })
                    elementCount = elementCount + 1
                end
            end
        end
    end
    
    -- 2. Procurar em PlayerData/Data
    for _, folder in pairs(LocalPlayer:GetChildren()) do
        if folder:IsA("Folder") and (folder.Name == "PlayerData" or folder.Name == "Data" or folder.Name == "Stats") then
            for _, value in pairs(folder:GetChildren()) do
                if value:IsA("NumberValue") or value:IsA("IntValue") then
                    local name = value.Name:lower()
                    if name:find("cash") or name:find("money") or name:find("coin") or name:find("dollar") or name:find("currency") or name:find("gold") then
                        table.insert(detectedElements, {
                            Type = "PlayerData",
                            Object = value,
                            Name = value.Name,
                            Path = "Player." .. folder.Name .. "." .. value.Name
                        })
                        elementCount = elementCount + 1
                    end
                end
            end
        end
    end
    
    -- 3. Procurar em PlayerGui
    for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if gui:IsA("TextLabel") or gui:IsA("TextBox") then
            local text = gui.Text:lower()
            local name = gui.Name:lower()
            if (text:find("$") or text:find("cash") or text:find("money") or name:find("cash") or name:find("money")) and gui.Text ~= "" then
                table.insert(detectedElements, {
                    Type = "GUI",
                    Object = gui,
                    Name = gui.Name,
                    Path = "PlayerGui." .. gui:GetFullName():gsub("Players%." .. LocalPlayer.Name .. "%.PlayerGui%.", "")
                })
                elementCount = elementCount + 1
            end
        end
    end
    
    -- 4. Atualizar info
    if elementCount > 0 then
        local infoText = "✅ Detectados " .. elementCount .. " elemento(s):\n"
        for i, elem in ipairs(detectedElements) do
            if i <= 3 then -- Mostrar apenas os 3 primeiros
                infoText = infoText .. "• " .. elem.Type .. ": " .. elem.Name .. "\n"
            end
        end
        if elementCount > 3 then
            infoText = infoText .. "... e " .. (elementCount - 3) .. " mais"
        end
        InfoLabel.Text = infoText
        InfoLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
    else
        InfoLabel.Text = "⚠️ Nenhum elemento encontrado!\nVerifique se está no jogo correto."
        InfoLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
    end
end

-- Função para aplicar o valor
local function ApplyMoney(value)
    if not value or value <= 0 then
        InfoLabel.Text = "❌ Valor inválido!\nDigite apenas números positivos."
        InfoLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    InfoLabel.Text = "⏳ Aplicando $" .. value .. "...\nAguarde..."
    InfoLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    ApplyBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    ApplyBtn.Text = "APLICANDO..."
    
    local successCount = 0
    
    task.spawn(function()
        -- Aplicar em todos os elementos detectados
        for _, elem in ipairs(detectedElements) do
            pcall(function()
                if elem.Type == "Leaderstats" or elem.Type == "PlayerData" then
                    elem.Object.Value = value
                    successCount = successCount + 1
                elseif elem.Type == "GUI" then
                    -- Tentar atualizar GUI (pode não funcionar em todos os casos)
                    if elem.Object:IsA("TextLabel") or elem.Object:IsA("TextBox") then
                        local currentText = elem.Object.Text
                        -- Detectar formato ($1000, 1000$, etc)
                        if currentText:find("%$") then
                            elem.Object.Text = "$" .. value
                        else
                            elem.Object.Text = tostring(value)
                        end
                        successCount = successCount + 1
                    end
                end
            end)
        end
        
        -- Tentar via RemoteEvents
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            pcall(function()
                if remote:IsA("RemoteEvent") then
                    local name = remote.Name:lower()
                    if name:find("money") or name:find("cash") or name:find("currency") or name:find("coin") or name:find("add") or name:find("set") then
                        remote:FireServer(value)
                        remote:FireServer("SetMoney", value)
                        remote:FireServer("AddMoney", value)
                        remote:FireServer({Type = "Money", Amount = value})
                        remote:FireServer({money = value, cash = value})
                    end
                end
            end)
        end
        
        task.wait(1)
        
        -- Resultado
        if successCount > 0 then
            InfoLabel.Text = "✅ SUCESSO!\n" .. successCount .. " elemento(s) modificado(s)\nValor: $" .. value
            InfoLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
        else
            InfoLabel.Text = "⚠️ Aplicado via remotes\nVerifique sua conta no jogo"
            InfoLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        end
        
        ApplyBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        ApplyBtn.Text = "💵 APLICAR DINHEIRO"
        
        -- Re-escanear após 2 segundos
        task.wait(2)
        ScanForMoneyElements()
    end)
end

-- Eventos
ApplyBtn.MouseButton1Click:Connect(function()
    local value = tonumber(ValueInput.Text)
    ApplyMoney(value)
end)

ValueInput.FocusLost:Connect(function(enter)
    if enter then
        local value = tonumber(ValueInput.Text)
        if value and value > 0 then
            ApplyMoney(value)
        end
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Hover effects
ApplyBtn.MouseEnter:Connect(function()
    ApplyBtn.BackgroundColor3 = Color3.fromRGB(120, 220, 120)
end)

ApplyBtn.MouseLeave:Connect(function()
    ApplyBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
end)

-- Escanear ao iniciar
task.wait(1)
ScanForMoneyElements()

-- Re-escanear a cada 10 segundos
task.spawn(function()
    while task.wait(10) do
        if ScreenGui.Parent then
            ScanForMoneyElements()
        end
    end
end)

-- Notificação inicial
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "💰 Money Setter";
    Text = "Sistema de detecção automática ativado!";
    Duration = 3;
})
