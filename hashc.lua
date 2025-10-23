-- Brainrot Mythic & God Selector V3 - Lista Fixa + Bypass

local mythics = {
    "Frigo Camelo", "Rhino Toasterino", "Bombardiro Crocodilo", "Spioniro Golubiro", "Tigrilini Watermelini",
    "Bombombini Gusini", "Zibra Zubra Zibralini", "Cavallo Virtuoso", "Pandaccini Bananini", "Ganganzelli Trulala",
    "Tob Tobi Tobi", "Gorillo Watermelondrillo", "Avocadorilla"
}

local gods = {
    "Cocofanta Elefanto", "Girafa Celestre", "Gattatino Nyanino", "Tralalero Tralala", "Trenostruzzo Turbo 3000",
    "Espresso Signora", "Odin Din Din Dun", "Statutino Libertino", "Ballerino Lololo", "Trigoligre Frutonni",
    "Orcalero Orcala", "Los Crocodilitos", "Piccione Macchina", "Matteo", "Tukanno Banana", "Tipi Topi Taco",
    "Te Te Te Sahur", "Unclito Samito"
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local function Notify(text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Brainrot Stealer",
        Text = text,
        Duration = 3
    })
end

-- Procurar brainrot específico no Workspace
local function findBrainrot(name)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == name then
            return obj
        end
    end
    return nil
end

-- Tentar setar brainrot para base (bypass money)
local function stealBrainrot(brainrotName)
    local brainrot = findBrainrot(brainrotName)
    
    if not brainrot then
        Notify(brainrotName .. " não encontrado no mapa!")
        return
    end
    
    Notify("Tentando roubar " .. brainrotName .. "...")
    
    -- Método 1: Tentar todos os RemoteEvents possíveis
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if name:find("claim") or name:find("purchase") or name:find("buy") or 
                   name:find("steal") or name:find("get") or name:find("collect") or
                   name:find("obtain") or name:find("add") or name:find("give") then
                    remote:FireServer(brainrot)
                    remote:FireServer(brainrotName)
                    remote:FireServer({Brainrot = brainrot})
                    remote:FireServer({Name = brainrotName})
                    remote:FireServer({Action = "Claim", Target = brainrot})
                    remote:FireServer({Action = "Steal", Target = brainrot})
                    remote:FireServer("Claim", brainrot)
                    remote:FireServer("Steal", brainrot)
                    remote:FireServer("Purchase", brainrot, 0)
                    remote:FireServer("Buy", brainrotName, 0)
                end
            elseif remote:IsA("RemoteFunction") then
                local name = remote.Name:lower()
                if name:find("claim") or name:find("purchase") or name:find("steal") then
                    pcall(function() remote:InvokeServer(brainrot) end)
                    pcall(function() remote:InvokeServer(brainrotName) end)
                    pcall(function() remote:InvokeServer("Claim", brainrot) end)
                end
            end
        end)
    end
    
    -- Método 2: ProximityPrompts
    for _, descendant in pairs(brainrot:GetDescendants()) do
        pcall(function()
            if descendant:IsA("ProximityPrompt") then
                if fireproximityprompt then
                    fireproximityprompt(descendant, 0)
                end
            end
        end)
    end
    
    -- Método 3: Teleportar e interagir
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local targetPart = brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart")
        
        if targetPart then
            local originalPos = hrp.CFrame
            hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.4)
            
            -- ClickDetectors
            for _, cd in pairs(brainrot:GetDescendants()) do
                pcall(function()
                    if cd:IsA("ClickDetector") then
                        if fireclickdetector then
                            fireclickdetector(cd)
                        end
                    end
                end)
            end
            
            task.wait(0.4)
            hrp.CFrame = originalPos
        end
    end
    
    -- Método 4: Modificar ownership
    pcall(function()
        if brainrot:FindFirstChild("Owner") then
            brainrot.Owner.Value = LocalPlayer
        end
        if brainrot:FindFirstChild("OwnerName") then
            brainrot.OwnerName.Value = LocalPlayer.Name
        end
    end)
    
    task.wait(0.5)
    Notify("Tentativas finalizadas! Verifique sua base")
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "BrainrotStealer"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 540)
Main.Position = UDim2.new(0.5, -225, 0.5, -270)
Main.BackgroundColor3 = Color3.fromRGB(17,17,26)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundColor3 = Color3.fromRGB(22,22,32)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Brainrot Stealer Pro"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 21
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 38, 0, 38)
CloseBtn.Position = UDim2.new(1, -50, 0.5, -19)
CloseBtn.BackgroundColor3 = Color3.fromRGB(44,44,54)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(220,220,220)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 23
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 9)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -22, 1, -65)
Scroll.Position = UDim2.new(0, 11, 0, 54)
Scroll.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 7
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local UIListLayout = Instance.new("UIListLayout", Scroll)
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function CreateButton(text, callback, cor)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundColor3 = cor or Color3.fromRGB(57,60,80)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(240, 240, 255)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 18
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 9)

    Btn.MouseEnter:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(80,130,180)
    end)
    Btn.MouseLeave:Connect(function()
        Btn.BackgroundColor3 = cor or Color3.fromRGB(57,60,80)
    end)
    Btn.MouseButton1Click:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(160,160,200)
        task.wait(0.12)
        Btn.BackgroundColor3 = cor or Color3.fromRGB(57,60,80)
        callback()
    end)
end

-- Criar botões para TODOS os brainrots da lista
for _, name in ipairs(gods) do
    CreateButton("🔴 " .. name, function()
        stealBrainrot(name)
    end, Color3.fromRGB(209,40,90))
end

for _, name in ipairs(mythics) do
    CreateButton("🔵 " .. name, function()
        stealBrainrot(name)
    end, Color3.fromRGB(80,180,255))
end

-- Ajustar canvas size
Scroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)

Notify("Script carregado! Total: " .. (#gods + #mythics) .. " brainrots")
