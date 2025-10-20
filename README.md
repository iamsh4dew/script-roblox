-- Criado para fins educacionais e visuais

-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Criar ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "CoinMenu"
gui.ResetOnSpawn = false
gui.Enabled = false
gui.Parent = playerGui

-- Criar Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Visible = true
frame.Parent = gui

-- UICorner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Definir Moedas"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Caixa de Texto
local input = Instance.new("TextBox")
input.PlaceholderText = "Quantidade de moedas"
input.Size = UDim2.new(0.8, 0, 0, 40)
input.Position = UDim2.new(0.1, 0, 0.4, 0)
input.Font = Enum.Font.Gotham
input.TextSize = 18
input.TextColor3 = Color3.fromRGB(255, 255, 255)
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.ClearTextOnFocus = false
input.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = input

-- Botão Confirmar
local button = Instance.new("TextButton")
button.Text = "Confirmar"
button.Size = UDim2.new(0.5, 0, 0, 35)
button.Position = UDim2.new(0.25, 0, 0.75, 0)
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

-- Valor de moedas local
local coinValue = 0

-- Função do botão
button.MouseButton1Click:Connect(function()
	local text = input.Text
	local number = tonumber(text)
	if number then
		coinValue = number
		print("Moedas definidas para:", coinValue)

		-- Simular no Client (exemplo: alterar um TextLabel fictício)
		local coinLabel = player:FindFirstChild("PlayerGui"):FindFirstChild("CoinDisplay")
		if coinLabel and coinLabel:IsA("TextLabel") then
			coinLabel.Text = "Moedas: " .. coinValue
		end

		gui.Enabled = false
	end
end)

-- Atalhos de teclado (F para abrir/fechar)
UserInputService.InputBegan:Connect(function(inputObj, processed)
	if processed then return end
	if inputObj.KeyCode == Enum.KeyCode.F then
		gui.Enabled = not gui.Enabled
	end
end)
