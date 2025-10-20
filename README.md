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
            resourceData.value =
