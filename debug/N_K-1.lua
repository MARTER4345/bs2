-- G_T__Y --
local COREGUI = game:GetService("CoreGui")
if not game:IsLoaded() then
    local notLoaded = Instance.new("Message")
    notLoaded.Parent = COREGUI
    notLoaded.Text = "Waiting for the game to load..."
    game.Loaded:Wait()
    notLoaded:Destroy()
end

--WHITELIST BEFORE LOADING
if not getgenv().whitelistUserIDs then print("No whitelist data found") return end

for _,player in pairs(game.Players:GetPlayers()) do
    if not table.find(getgenv().whitelistUserIDs,player.UserId) then 
        game.Players.LocalPlayer:Kick("\nUnWhitelisted detected...")
    end
end

game.Players.PlayedAdded:Connect(function(player)
    if not table.find(getgenv().whitelistUserIDs,player.UserId) then --
        game.Players.LocalPlayer:Kick("\nUnWhitelisted joined...")
    end
end)


--MAIN

local CoinFolder = game.workspace:WaitForChild("Coins")
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MARTER4345/bs2/main/library.lua"))()
local api = loadstring(game:HttpGet("https://raw.githubusercontent.com/MARTER4345/bs2/main/api.lua"))()
local player = game.Players.LocalPlayer
local temptabledead = false

-- # FUNCS
function GetClosestPart(folder)
    local Closest
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    for _, v in pairs(folder:GetDescendants()) do
        if v and v:IsA("BasePart") then
            if not Closest or (root.Position - v.Position).magnitude < (root.Position - Closest.Position).magnitude then
                Closest = v
            end
        end
    end
    return Closest
end

function GetClosestPartNew(list)
    local Closest
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    for _, v in pairs(list) do
        if v and v:IsA("BasePart") then
            if not Closest or (root.Position - v.Position).magnitude < (root.Position - Closest.Position).magnitude then
                Closest = v
            end
        end
    end
    return Closest
end

function GetClosestPartFromPart(list, part)
    if not part then return nil end
    local Closest

    for _, v in pairs(list) do
        if v and v:IsA("BasePart") then
            if not Closest or (part.Position - v.Position).magnitude < (part.Position - Closest.Position).magnitude then
                Closest = v
            end
        end
    end
    return Closest
end

function DecancerCoins()
    local CoinParts = {}
    
    pcall(function()
        for _, v in ipairs(CoinFolder:GetDescendants()) do
            if v and v:IsA("BasePart") then
                if v:FindFirstChild("TouchInterest") then
                    --[[if v.Parent and v.Parent.Name == "ROUND SIX" then
                        v.Name = api.generaterandomstring(12)
                        REMOVED DUE TO BUILT UP MEMORY LEAKS
                    end]]
                    --[[if v.Parent and v.Parent.Name == "HEARTTOKEN" then
                        v.Name = api.generaterandomstring(12)
                    end]]
                    table.insert(CoinParts, v)
                end
            end
        end
    end)
    
    return CoinParts
end

function Sort()
    local SortedCoins = {}
    local TableToSort = DecancerCoins()

    if #TableToSort > 0 then
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

    return SortedCoins
end

function GetCoins()
    local playerpart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not playerpart or temptabledead then return end

    local YummerCoins = Sort()
    for _, v in ipairs(YummerCoins) do
        task.wait()
            local coinAmount = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.BottomRightContainer.HudFrame.Coins.Amount
            if coinAmount and coinAmount.Text == "MAX" then
                local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                    return 
                end
            end
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
            temptabledead = true
            print("PDeD.")
            task.wait(11)
            temptabledead = false
        end)
    end
end)

local LPlrId = tostring(game.Players.LocalPlayer.UserId)
local cutframe = game:GetService("Players").LocalPlayer.PlayerGui.DialogueGui.Frame

local diacheck = false

function isondia()
    task.wait(.2)
    if cutframe.Visible == true then 
        diacheck = true
    else
        diacheck = false
    end
    return diacheck
end

cutframe:GetPropertyChangedSignal("Visible"):Connect(isondia)

game:GetService("Players").LocalPlayer.PlayerGui.GameGui.BottomRightContainer.SkipFrame.NameHolder.ChildAdded:Connect(function(child)
  if child and child.Name == LPlrId then
    while diacheck == false do task.wait(.1) end
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("SkipScene"):FireServer()
    end
end)


task.spawn(function()
    task.wait(10)
    local skipFrame = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.BottomRightContainer.SkipFrame.NameHolder
    if skipFrame:FindFirstChild(LPlrId) then
        if game:GetService("Players").LocalPlayer.PlayerGui.DialogueGui.Frame.Visible == true then
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("SkipScene"):FireServer()
        end
    end
    
    task.wait(40)
    game:GetService("ReplicatedStorage"):WaitForChild("VIPCommands"):WaitForChild("SetMap"):InvokeServer("Chapter 4")
    
    task.wait(3)
    game:GetService("ReplicatedStorage"):WaitForChild("VIPCommands"):WaitForChild("SetMode"):InvokeServer("Bot")
end)

while task.wait(5) do
    if not temptabledead then
        local coinAmount = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.BottomRightContainer.HudFrame.Coins.Amount
        if coinAmount and coinAmount.Text == "MAX" then
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Dead)
            end
        else
            pcall(function()
                if temptabledead ~= true and api.humanoidrootpart() then
                    api.teleport(CFrame.new(-116.023346, -112.200012, 123.903557))
                end
            end)
            pcall(GetCoins)
        end
    end
end
