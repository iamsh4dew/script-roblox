-- LocalScript: Coloque em StarterPlayer > StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variáveis para recursos
local resources = {
    money = {value = 0, object = nil, name = "Money"},
    cash = {value = 0, object = nil, name = "Cash"},
    coins = {value = 0, object = nil, name = "Coins"},
    gems = {value = 0, object = nil, name = "Gems"},
    points = {value = 0, object = nil, name = "Points"}
}

-- Configuração de velocidade
local speedEnabled = false
local currentSpeed = 16
local defaultSpeed = 16
local humanoid

-- Função para buscar recursos automaticamente
local function findResources()
    print("Procurando recursos no jogo...")
    
    -- Procurar no Player
    for _, resourceName in pairs({"Money", "Cash", "Coins", "Gems", "Points", "Dollars", "Gold"}) do
        local resource = player:FindFirstChild(resourceName)
        if resource and (resource:IsA("IntValue") or resource:IsA("NumberValue") or resource:IsA("Folder")) then
            print("Encontrado: " .. resourceName)
            resources[string.lower(resourceName)] = {
                value = resource.Value or 0,
                object = resource,
                name = resourceName
            }
        end
    end
    
    -- Procurar no Backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, resource in pairs(backpack:GetChildren()) do
            if resource:IsA("IntValue") or resource:IsA("NumberValue") then
                local nameLower = string.lower(resource.Name)
                if resources[nameLower] == nil then
                    resources[nameLower] = {
                        value = resource.Value,
                        object = resource,
                        name = resource.Name
                    }
                    print("Encontrado no Backpack: " .. resource.Name)
                end
            end
        end
    end
    
    -- Procurar no Leaderstats
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in pairs(leaderstats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") or stat:IsA("StringValue") then
                local nameLower = string.lower(stat.Name)
                resources[nameLower] = {
                    value = stat.Value,
                    object = stat,
                    name = stat.Name
                }
                print("Encontrado no Leaderstats: " .. stat.Name)
            end
        end
    end
    
    -- Procurar valores na pasta do player
    for _, child in pairs(player:GetChildren()) do
        if (child:IsA("IntValue") or child:IsA("NumberValue")) and string.match(string.lower(child.Name), "money|cash|coin|gem|point") then
            local nameLower = string.lower(child.Name)
            if resources[nameLower] == nil then
                resources[nameLower] = {
                    value = child.Value,
                    object = child,
                    name = child.Name
                }
                print("Encontrado: " .. child.Name)
            end
        end
    end
end

-- Função para atualizar display dos recursos
local function updateResourceDisplays()
    for resourceName, resourceData in pairs(resources) do
        if resourceData.object and resourceData.displayLabel then
            local value = resourceData.object.Value or 0
            resourceData.displayLabel.Text = resourceData.name .. ": " .. tostring(value)
            resourceData.value = value
        end
    end
end

-- Sistema de Humanoid
local function getHumanoid()
    local character = player.Character
    if character then
        humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            defaultSpeed = humanoid.WalkSpeed
            currentSpeed = defaultSpeed
        end
    end
end

-- Conectar eventos de character
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    getHumanoid()
end)
getHumanoid()

-- Criar a Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedControlGUI"
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Arredondar cantos
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Sombra
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5554236805"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(23,23,277,277)
shadow.Parent = mainFrame

-- Barra de título
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Painel de Controle - Brutins"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Botão fechar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Área de recursos
local resourcesFrame = Instance.new("Frame")
resourcesFrame.Name = "ResourcesFrame"
resourcesFrame.Size = UDim2.new(0.9, 0, 0, 150)
resourcesFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
resourcesFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
resourcesFrame.BorderSizePixel = 0
resourcesFrame.Parent = mainFrame

local resourcesCorner = Instance.new("UICorner")
resourcesCorner.CornerRadius = UDim.new(0, 8)
resourcesCorner.Parent = resourcesFrame

local resourcesTitle = Instance.new("TextLabel")
resourcesTitle.Name = "ResourcesTitle"
resourcesTitle.Size = UDim2.new(1, 0, 0, 30)
resourcesTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
resourcesTitle.Text = "RECURSOS DO JOGO"
resourcesTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
resourcesTitle.TextScaled = true
resourcesTitle.Font = Enum.Font.GothamBold
resourcesTitle.Parent = resourcesFrame

local resourcesTitleCorner = Instance.new("UICorner")
resourcesTitleCorner.CornerRadius = UDim.new(0, 8)
resourcesTitleCorner.Parent = resourcesTitle

-- Container dos recursos
local resourcesContainer = Instance.new("ScrollingFrame")
resourcesContainer.Name = "ResourcesContainer"
resourcesContainer.Size = UDim2.new(1, 0, 1, -30)
resourcesContainer.Position = UDim2.new(0, 0, 0, 30)
resourcesContainer.BackgroundTransparency = 1
resourcesContainer.BorderSizePixel = 0
resourcesContainer.ScrollBarThickness = 4
resourcesContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
resourcesContainer.Parent = resourcesFrame

local resourcesLayout = Instance.new("UIListLayout")
resourcesLayout.Parent = resourcesContainer
resourcesLayout.Padding = UDim.new(0, 5)

-- Botão de atualizar recursos
local refreshButton = Instance.new("TextButton")
refreshButton.Name = "RefreshButton"
refreshButton.Size = UDim2.new(0.9, 0, 0, 30)
refreshButton.Position = UDim2.new(0.05, 0, 0.55, 0)
refreshButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
refreshButton.Text = "🔄 Atualizar Recursos"
refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshButton.TextScaled = true
refreshButton.Font = Enum.Font.Gotham
refreshButton.Parent = mainFrame

local refreshCorner = Instance.new("UICorner")
refreshCorner.CornerRadius = UDim.new(0, 6)
refreshCorner.Parent = refreshButton

-- Controle de velocidade
local speedFrame = Instance.new("Frame")
speedFrame.Name = "SpeedFrame"
speedFrame.Size = UDim2.new(0.9, 0, 0, 120)
speedFrame.Position = UDim2.new(0.05, 0, 0.65, 0)
speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
speedFrame.BorderSizePixel = 0
speedFrame.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedFrame

local speedTitle = Instance.new("TextLabel")
speedTitle.Name = "SpeedTitle"
speedTitle.Size = UDim2.new(1, 0, 0, 25)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "CONTROLE DE VELOCIDADE"
speedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedTitle.TextScaled = true
speedTitle.Font = Enum.Font.GothamBold
speedTitle.Parent = speedFrame

-- Botão toggle velocidade
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.8, 0, 0, 30)
toggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
toggleButton.Text = "VELOCIDADE: DESATIVADO"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.Gotham
toggleButton.Parent = speedFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Barra deslizante de velocidade
local sliderContainer = Instance.new("Frame")
sliderContainer.Name = "SliderContainer"
sliderContainer.Size = UDim2.new(0.8, 0, 0, 40)
sliderContainer.Position = UDim2.new(0.1, 0, 0.7, 0)
sliderContainer.BackgroundTransparency = 1
sliderContainer.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, 0, 0, 15)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidade: 16"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = sliderContainer

local sliderBackground = Instance.new("Frame")
sliderBackground.Name = "SliderBackground"
sliderBackground.Size = UDim2.new(1, 0, 0, 15)
sliderBackground.Position = UDim2.new(0, 0, 0.5, 0)
sliderBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
sliderBackground.BorderSizePixel = 0
sliderBackground.Parent = sliderContainer

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 8)
sliderCorner.Parent = sliderBackground

local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.Size = UDim2.new(0.3, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBackground

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 8)
fillCorner.Parent = sliderFill

local sliderButton = Instance.new("TextButton")
sliderButton.Name = "SliderButton"
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.Position = UDim2.new(0.3, -10, 0, -2)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderButton.Text = ""
sliderButton.ZIndex = 2
sliderButton.Parent = sliderBackground

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = sliderButton

-- Botão flutuante para abrir
local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 60, 0, 60)
openButton.Position = UDim2.new(0, 20, 0, 20)
openButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
openButton.Text = "📊"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextScaled = true
openButton.Font = Enum.Font.GothamBold
openButton.Visible = true
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 30)
openCorner.Parent = openButton

-- Funções
local function createResourceDisplay(resourceName, resourceData)
    local resourceFrame = Instance.new("Frame")
    resourceFrame.Name = resourceName .. "Frame"
    resourceFrame.Size = UDim2.new(1, -10, 0, 25)
    resourceFrame.Position = UDim2.new(0, 5, 0, 0)
    resourceFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    resourceFrame.BorderSizePixel = 0
    resourceFrame.Parent = resourcesContainer
    
    local resourceCorner = Instance.new("UICorner")
    resourceCorner.CornerRadius = UDim.new(0, 4)
    resourceCorner.Parent = resourceFrame
    
    local resourceLabel = Instance.new("TextLabel")
    resourceLabel.Name = resourceName .. "Label"
    resourceLabel.Size = UDim2.new(1, 0, 1, 0)
    resourceLabel.BackgroundTransparency = 1
    resourceLabel.Text = resourceData.name .. ": " .. tostring(resourceData.value)
    resourceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    resourceLabel.TextScaled = true
    resourceLabel.Font = Enum.Font.Gotham
    resourceLabel.TextXAlignment = Enum.TextXAlignment.Left
    resourceLabel.Parent = resourceFrame
    
    -- Adicionar padding
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = resourceLabel
    
    resourceData.displayLabel = resourceLabel
    return resourceFrame
end

local function updateResourcesDisplay()
    -- Limpar displays antigos
    for _, child in pairs(resourcesContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Criar novos displays
    local resourceCount = 0
    for resourceName, resourceData in pairs(resources) do
        if resourceData.object then
            createResourceDisplay(resourceName, resourceData)
            resourceCount = resourceCount + 1
        end
    end
    
    -- Ajustar tamanho do canvas
    resourcesContainer.CanvasSize = UDim2.new(0, 0, 0, resourceCount * 30)
    
    if resourceCount == 0 then
        local noResources = Instance.new("TextLabel")
        noResources.Size = UDim2.new(1, 0, 0, 50)
        noResources.BackgroundTransparency = 1
        noResources.Text = "Nenhum recurso encontrado\nClique em Atualizar Recursos"
        noResources.TextColor3 = Color3.fromRGB(150, 150, 150)
        noResources.TextScaled = true
        noResources.Font = Enum.Font.Gotham
        noResources.Parent = resourcesContainer
    end
end

local function updateSpeed()
    if speedEnabled and humanoid then
        humanoid.WalkSpeed = currentSpeed
        toggleButton.Text = "VELOCIDADE: " .. currentSpeed
    elseif humanoid then
        humanoid.WalkSpeed = defaultSpeed
        toggleButton.Text = "VELOCIDADE: DESATIVADO"
    end
end

local function toggleSpeed()
    speedEnabled = not speedEnabled
    
    if speedEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 220, 60)
        updateSpeed()
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        if humanoid then
            humanoid.WalkSpeed = defaultSpeed
        end
    end
end

local function updateSlider(value)
    currentSpeed = math.floor(16 + (value * 84))
    speedLabel.Text = "Velocidade: " .. currentSpeed
    
    local fillSize = value
    sliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
    sliderButton.Position = UDim2.new(fillSize, -10, 0, -2)
    
    if speedEnabled then
        updateSpeed()
    end
end

-- Sistema de arrastar barra
local dragging = false

sliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local sliderAbsolutePosition = sliderBackground.AbsolutePosition
        local sliderAbsoluteSize = sliderBackground.AbsoluteSize
        
        local mouseX = input.Position.X
        local relativeX = mouseX - sliderAbsolutePosition.X
        local value = math.clamp(relativeX / sliderAbsoluteSize.X, 0, 1)
        
        updateSlider(value)
    end
end)

sliderBackground.MouseButton1Down:Connect(function(x, y)
    local sliderAbsolutePosition = sliderBackground.AbsolutePosition
    local sliderAbsoluteSize = sliderBackground.AbsoluteSize
    
    local relativeX = x - sliderAbsolutePosition.X
    local value = math.clamp(relativeX / sliderAbsoluteSize.X, 0, 1)
    
    updateSlider(value)
end)

-- Controle de visibilidade da GUI
local guiVisible = false
mainFrame.Visible = false

local function toggleGUI()
    guiVisible = not guiVisible
    mainFrame.Visible = guiVisible
    openButton.Visible = not guiVisible
    
    if guiVisible then
        -- Atualizar recursos quando abrir
        findResources()
        updateResourcesDisplay()
    end
end

-- Eventos
toggleButton.MouseButton1Click:Connect(toggleSpeed)
refreshButton.MouseButton1Click:Connect(function()
    findResources()
    updateResourcesDisplay()
end)
openButton.MouseButton1Click:Connect(toggleGUI)
closeButton.MouseButton1Click:Connect(toggleGUI)

-- Tecla F para abrir/fechar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleGUI()
    end
end)

-- Atualizar recursos automaticamente
spawn(function()
    while true do
        wait(2) -- Atualizar a cada 2 segundos
        if guiVisible then
            updateResourceDisplays()
        end
    end
end)

-- Inicializar
updateSlider(0.3) -- Velocidade inicial 40

print("Painel Brutins carregado! Pressione F ou clique no botão para abrir.")
print("Recursos detectados automaticamente: Money, Cash, Coins, Gems, Points, etc.")
