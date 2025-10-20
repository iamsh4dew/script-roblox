-- LocalScript: Coloque em StarterPlayer > StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(newChar)
    character = newChar
end)

-- Variáveis
local speedEnabled = false
local currentSpeed = 16
local defaultSpeed = 16
local humanoid

-- Esperar pelo Humanoid
local function getHumanoid()
    if character and character:FindFirstChildOfClass("Humanoid") then
        humanoid = character:FindFirstChildOfClass("Humanoid")
        defaultSpeed = humanoid.WalkSpeed
        currentSpeed = defaultSpeed
    end
end

getHumanoid()
player.CharacterAdded:Connect(getHumanoid)

-- Criar a Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedControlGUI"
screenGui.Parent = player.PlayerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Arredondar cantos
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Barra de título
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Controle de Velocidade"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Botão de toggle
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.8, 0, 0, 40)
toggleButton.Position = UDim2.new(0.1, 0, 0.25, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
toggleButton.Text = "DESATIVADO"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Container da barra deslizante
local sliderContainer = Instance.new("Frame")
sliderContainer.Name = "SliderContainer"
sliderContainer.Size = UDim2.new(0.8, 0, 0, 60)
sliderContainer.Position = UDim2.new(0.1, 0, 0.55, 0)
sliderContainer.BackgroundTransparency = 1
sliderContainer.Parent = mainFrame

-- Label do valor da velocidade
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidade: " .. currentSpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = sliderContainer

-- Barra deslizante
local sliderBackground = Instance.new("Frame")
sliderBackground.Name = "SliderBackground"
sliderBackground.Size = UDim2.new(1, 0, 0, 20)
sliderBackground.Position = UDim2.new(0, 0, 0.5, 0)
sliderBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
sliderBackground.BorderSizePixel = 0
sliderBackground.Parent = sliderContainer

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = sliderBackground

local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBackground

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 10)
fillCorner.Parent = sliderFill

local sliderButton = Instance.new("TextButton")
sliderButton.Name = "SliderButton"
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.Position = UDim2.new(0.5, -10, 0, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderButton.Text = ""
sliderButton.ZIndex = 2
sliderButton.Parent = sliderBackground

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = sliderButton

-- Funções
local function updateSpeed()
    if speedEnabled and humanoid then
        humanoid.WalkSpeed = currentSpeed
    elseif humanoid then
        humanoid.WalkSpeed = defaultSpeed
    end
end

local function toggleSpeed()
    speedEnabled = not speedEnabled
    
    if speedEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 220, 60)
        toggleButton.Text = "ATIVADO"
        updateSpeed()
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        toggleButton.Text = "DESATIVADO"
        if humanoid then
            humanoid.WalkSpeed = defaultSpeed
        end
    end
end

local function updateSlider(value)
    -- Valor entre 16 e 100
    currentSpeed = math.floor(16 + (value * 84))
    speedLabel.Text = "Velocidade: " .. currentSpeed
    
    -- Atualizar visual da barra
    local fillSize = value
    sliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
    sliderButton.Position = UDim2.new(fillSize, -10, 0, 0)
    
    -- Atualizar velocidade se estiver ativada
    if speedEnabled then
        updateSpeed()
    end
end

-- Eventos
toggleButton.MouseButton1Click:Connect(toggleSpeed)

-- Controle da barra deslizante
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

-- Clique direto na barra
sliderBackground.MouseButton1Down:Connect(function(x, y)
    local sliderAbsolutePosition = sliderBackground.AbsolutePosition
    local sliderAbsoluteSize = sliderBackground.AbsoluteSize
    
    local relativeX = x - sliderAbsolutePosition.X
    local value = math.clamp(relativeX / sliderAbsoluteSize.X, 0, 1)
    
    updateSlider(value)
end)

-- Inicializar
updateSlider(0.5) -- Valor inicial 50% (58 de velocidade)

-- Botão para abrir/fechar o painel (tecla F)
local openCloseButton = Instance.new("TextButton")
openCloseButton.Name = "OpenCloseButton"
openCloseButton.Size = UDim2.new(0, 50, 0, 50)
openCloseButton.Position = UDim2.new(0, 10, 0, 10)
openCloseButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
openCloseButton.Text = "F"
openCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openCloseButton.TextScaled = true
openCloseButton.Font = Enum.Font.GothamBold
openCloseButton.Visible = false
openCloseButton.Parent = screenGui

local openCloseCorner = Instance.new("UICorner")
openCloseCorner.CornerRadius = UDim.new(0, 25)
openCloseCorner.Parent = openCloseButton

-- Controle de visibilidade
local guiVisible = true

local function toggleGUI()
    guiVisible = not guiVisible
    if guiVisible then
        mainFrame.Visible = true
        openCloseButton.Visible = false
    else
        mainFrame.Visible = false
        openCloseButton.Visible = true
    end
end

-- Tecla F para abrir/fechar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleGUI()
    end
end)

-- Fechar GUI inicialmente e mostrar botão
mainFrame.Visible = false
openCloseButton.Visible = true

openCloseButton.MouseButton1Click:Connect(toggleGUI)

print("Sistema de controle de velocidade carregado! Pressione F para abrir/fechar o painel.")
