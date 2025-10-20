-- Criado para fins educacionais. NÃO afeta o servidor!

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "AutoMoedaEditor"
gui.Enabled = false
gui.ResetOnSpawn = false

-- Tema escuro com sombra
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 300)
frame.Position = UDim2.new(0.5, -175, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 12)

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Editor de Moedas (Client)"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Scroll para múltiplas moedas
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0

local UIListLayout = Instance.new("UIListLayout", scroll)
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Função para buscar moedas no Player
local function encontrarMoedas()
	local moedas = {}

	local function verificar(container)
		for _, obj in pairs(container:GetChildren()) do
			if obj:IsA("NumberValue") or obj:IsA("IntValue") then
				if string.match(obj.Name:lower(), "coin") or string.match(obj.Name:lower(), "cash") or string.match(obj.Name:lower(), "money") then
					table.insert(moedas, obj)
				end
			end
			-- Recursivo
			if #obj:GetChildren() > 0 then
				verificar(obj)
			end
		end
	end

	verificar(lp)
	return moedas
end

-- Gerar UI dinamicamente
local function gerarUI()
	scroll:ClearAllChildren()
	local moedas = encontrarMoedas()

	for _, moeda in ipairs(moedas) do
		local container = Instance.new("Frame", scroll)
		container.Size = UDim2.new(1, 0, 0, 40)
		container.BackgroundTransparency = 1

		local label = Instance.new("TextLabel", container)
		label.Text = moeda.Name
		label.Font = Enum.Font.Gotham
		label.TextSize = 16
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.Size = UDim2.new(0.4, 0, 1, 0)
		label.BackgroundTransparency = 1

		local box = Instance.new("TextBox", container)
		box.PlaceholderText = tostring(moeda.Value)
		box.Text = ""
		box.Font = Enum.Font.Gotham
		box.TextSize = 16
		box.TextColor3 = Color3.fromRGB(255,255,255)
		box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		box.Size = UDim2.new(0.4, 0, 1, 0)
		box.Position = UDim2.new(0.4, 5, 0, 0)

		local uicorner = Instance.new("UICorner", box)
		uicorner.CornerRadius = UDim.new(0, 6)

		local button = Instance.new("TextButton", container)
		button.Text = "Setar"
		button.Font = Enum.Font.GothamBold
		button.TextSize = 14
		button.TextColor3 = Color3.fromRGB(255,255,255)
		button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
		button.Size = UDim2.new(0.2, -5, 1, 0)
		button.Position = UDim2.new(0.8, 5, 0, 0)

		local btnCorner = Instance.new("UICorner", button)
		btnCorner.CornerRadius = UDim.new(0, 6)

		button.MouseButton1Click:Connect(function()
			local val = tonumber(box.Text)
			if val then
				moeda.Value = val
				box.PlaceholderText = tostring(val)
			end
		end)
	end

	wait()
	scroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

-- Toggle com F
UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.F then
		gui.Enabled = not gui.Enabled
		if gui.Enabled then
			gerarUI()
		end
	end
end)
