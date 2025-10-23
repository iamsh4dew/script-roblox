-- Selector Mythic & Brainrot God, com SET para BASE

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
local UserInputService = game:GetService("UserInputService")

-- Detectar nome da sua base
local function getBase()
    local name = LocalPlayer.Name
    local base = Workspace:FindFirstChild(name .. "'s Base") or Workspace:FindFirstChild(name)
    return base
end

-- Verificar se tem espaço disponível: cada jogo é diferente,
-- mas normalmente tem um limite de objetos, ou partes para colocar brainrots
local function baseHasSpace()
    local base = getBase()
    if not base then return false end
    local slots = 0
    local ocupados = 0
    for _, slot in pairs(base:GetDescendants()) do
        if slot.Name:lower():find("slot") and slot:IsA("BasePart") then
            slots = slots + 1
            if #slot:GetChildren() > 0 then
                ocupados = ocupados + 1
            end
        end
    end
    if slots == 0 then return true end -- Falha ao detectar slots: tenta mesmo assim
    return ocupados < slots
end

local function contains(tab, str)
    for _, v in ipairs(tab) do
        if v:lower() == str:lower() then
            return true
        end
    end
    return false
end

-- Sistema de tentativas para manipular brainrot mesmo com possível server side
local function setBrainrotToBase(brainrot)
    local base = getBase()
    if not base then
        Notify("Sua base não foi encontrada!", Color3.fromRGB(255,80,80))
        return
    end

    if not baseHasSpace() then
        Notify("Sem espaço disponível na sua base!", Color3.fromRGB(255,120,40))
        return
    end

    -- 1) Tenta parentear diretamente
    pcall(function()
        brainrot.Parent = base
        brainrot:SetPrimaryPartCFrame(base.PrimaryPart.CFrame + Vector3.new(0, 8, 0))
    end)

    task.wait(0.4)

    -- 2) Tenta teletransportar via partes (se existir)
    if brainrot.PrimaryPart then
        brainrot.PrimaryPart.CFrame = base.PrimaryPart.CFrame + Vector3.new(math.random(-3,3), 8, math.random(-3,3))
    else
        local bp = brainrot:FindFirstChildWhichIsA("BasePart")
        if bp then
            bp.CFrame = base.PrimaryPart.CFrame + Vector3.new(math.random(-5,5), 8, math.random(-5,5))
        end
    end

    -- 3) Tenta via Remote que algum desenvolvedor deixou aberto
    for _,remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        pcall(function()
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                local name = remote.Name:lower()
                if name:find("claim") or name:find("give") or name:find("add") or name:find("set") then
                    remote:FireServer(brainrot)
                    remote:FireServer("SetBrainrot", brainrot)
                    remote:FireServer({Type="Brainrot", Obj=brainrot})
                end
            end
        end)
    end

    -- Feedback visual
    Notify("Tentado setar brainrot para sua base!", Color3.fromRGB(60,200,255))
end

-- Sistema visual (GUI)
local function Notify(text, cor)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Mythic/God Selector",
        Text = text,
        Duration = 3
    })
end

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "BrainrotSetter"
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
Title.Text = "⚡ Mythic & God Brainrot Setter"
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

local function Populate()
    -- Limpar
    for _, child in ipairs(Scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    local count = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local name = tostring(obj.Name)
            local col = nil
            if contains(mythics, name) then
                col = Color3.fromRGB(80,180,255)
            elseif contains(gods, name) then
                col = Color3.fromRGB(209,40,90)
            end
            if col then
                count = count + 1
                CreateButton(name, function()
                    setBrainrotToBase(obj)
                end, col)
            end
        end
    end
    if count == 0 then
        Notify("Nenhum Mythic ou God encontrado!", Color3.fromRGB(255,80,80))
    end
end

Populate()

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.F5 then
        Populate() Notify("Lista atualizada.")
    end
end)
