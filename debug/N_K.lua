local CoinFolder = game.workspace:WaitForChild("Coins")
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MARTER4345/bs2/main/library.lua"))()
local api = loadstring(game:HttpGet("https://raw.githubusercontent.com/MARTER4345/bs2/main/api.lua"))()
local player = game.Players.LocalPlayer

function GetClosestPart(path)
    local Closest
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    for _, v in pairs(path:GetDescendants()) do
        if v and (v:IsA("BasePart") or v:IsA("Part") or v:IsA("MeshPart")) then
            if not Closest or (root.Position - v.Position).magnitude < (root.Position - Closest.Position).magnitude then
                Closest = v
            end
        end
    end
    return Closest
end

function GetClosestPartNew(table)
    local Closest
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    for _, v in pairs(table) do
        if v and (v:IsA("BasePart") or v:IsA("Part") or v:IsA("MeshPart")) then
            if not Closest or (root.Position - v.Position).magnitude < (root.Position - Closest.Position).magnitude then
                Closest = v
            end
        end
    end
    return Closest
end

function GetClosestPartFromPart(table, part)
    if not part then return nil end
    local Closest

    for _, v in pairs(table) do
        if v and (v:IsA("MeshPart") or v:IsA("Part")) then
            if not Closest or (part.Position - v.Position).magnitude < (part.Position - Closest.Position).magnitude then
                Closest = v
            end
        end
    end
    return Closest
end

function DecancerCoins()
    local CoinParts = {}
    for _, v in ipairs(CoinFolder:GetDescendants()) do
        if v and (v:IsA("BasePart") or v:IsA("Part") or v:IsA("MeshPart")) then
            if v:FindFirstChild("TouchInterest") then
                if v.Parent and v.Parent.Name == "ROUND SIX" then
                    v.Name = api.generaterandomstring(12)
                end
                table.insert(CoinParts, v)
            end
        end
    end
    return CoinParts
end

function Sort()
    local SortedCoins = {}
    local TableToSort = DecancerCoins()
    
    if #TableToSort > 0 then
        --print("Init : " .. tostring(#TableToSort) .. " c")
        
        local SCoin = GetClosestPartNew(TableToSort)
        if SCoin then
            table.insert(SortedCoins, SCoin)
            local index = table.find(TableToSort, SCoin)
            if index then
                table.remove(TableToSort, index)
            end
        end

        while #TableToSort > 0 do
            task.wait()
            
            local PrevCoin = SCoin
            local Scoin = GetClosestPartFromPart(TableToSort, PrevCoin)

            if Scoin then
                table.insert(SortedCoins, Scoin)
                
                local removeIndex = table.find(TableToSort, Scoin)
                if removeIndex then
                    table.remove(TableToSort, removeIndex)
                end
                
                SCoin = Scoin
            end
        end
    end
    
    print(#SortedCoins.." C$")
    return SortedCoins
end

function GetCoins()
    local playerpart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not playerpart then return end

    local YummerCoins = Sort()
    for _, v in ipairs(YummerCoins) do
        if v and v:FindFirstChild("TouchInterest") then 
            firetouchinterest(playerpart, v, 0)
            task.wait()
            firetouchinterest(playerpart, v, 1)
            task.wait(0.1)
        end
    end
end

player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid", 10)
    local playerpart = char:WaitForChild("HumanoidRootPart", 10)
    if humanoid and playerpart then
        humanoid.Died:Connect(function()
            print("PDeD")
        end)
    end
end)

while task.wait(5) do
    pcall(GetCoins)
end
