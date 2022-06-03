--loadstring(game:HttpGet(('https://raw.githubusercontent.com/AureusBp2/GasStation/main/Stock.lua'),true))()

--[[

   Gas Station Simulator Autofarm

   Made by TheSynapseGuy on V3rm ( SomethingElse#0024 on discord )
   Last tested for V1.0.3d

   Default kebyinds
    P - Auto refuel
    L - Auto cashier
    M - Auto clean
    Z - Auto restock

   VV Settings below VV
]]

getgenv().TravelSpeed = 20 -- going too fast might get you kicked

getgenv().ToggleFuelKey = Enum.KeyCode.P
getgenv().ToggleCleanKey = Enum.KeyCode.M
getgenv().ToggleCashierKey = Enum.KeyCode.L
getgenv().ToggleRestockKey = Enum.KeyCode.Z
getgenv().ToggleAntisitKey = Enum.KeyCode.N
getgenv().ToggleNightCleanBreakKey = Enum.KeyCode.J

getgenv().AllowFuelBuy = true -- For auto refuel
getgenv().AllowItemsBuy = true -- For auto restocking
getgenv().SittingEnabled = true -- Allow to sit manually

getgenv().lightsaving = true 
getgenv().acsaving = true
getgenv().AllowAC = false
getgenv().AllowNightCleaning = true --Cleans when shop closes

getgenv().FuelSpeed = 1 -- Default 1
getgenv().ScanSpeed = 2.1 -- Default 3
getgenv().CleanSpeed = 4.5 -- Default 4.5 

getgenv().MoneySource = "Station" -- Choose "Station" or "Client"
getgenv().AllowSecondarySource = false
getgenv().SecondaryMoneySource = "Client" -- If Primary Money source does not have enough it will use this
getgenv().AllowStationSpendingDuringBankruptcy = false -- If enabled it allows the bot to purchase using station money even when near bankruptcy
--[[
   Fuel Choices
   1 - 15L $9
   2 - 25L $14
   3 - 50L $26
   4 - 100L $46
   5 - 240L $100
   6 - 520L $200
   7 - 1000L $350
]]
getgenv().FuelChoice = 2
getgenv().BlacklistedItems = { -- https://pastebin.com/raw/CGH5p6N3 for item list

}







-- Ignore everything below here
getgenv().GasEnabled = false
getgenv().CleaningEnabled = false
getgenv().RestockEnabled = false
getgenv().CashierEnabled = false
local ItemRestockQueue = {}
local CloseSign = game.Workspace.Ceilings.Doors.Left.DoorWithSign:WaitForChild("SurfaceGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage"); local Players = game:GetService("Players"); local LocalPlayer = Players.LocalPlayer; local RunService = game:GetService("RunService")
local ActionRemote = ReplicatedStorage:WaitForChild("Remote")
local PumpsFolder = workspace:WaitForChild("Pumps")
local StorageFolder = workspace:WaitForChild("Storage")
local ShelvesFolder = workspace:WaitForChild("Shelves")
local StatsHolder = require(ReplicatedStorage:WaitForChild("StatHolder"))
local InputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function GetPlayerCharacter() return LocalPlayer.Character or LocalPlayer.CharacterAdded:wait(); end
local function GetStoreGasoline() return PumpsFolder:GetAttribute("Gasoline"); end
local function GetMoneyOfSource(Source : StringValue) if Source == "Station" then return workspace.Station:GetAttribute("Money") elseif Source == "Client" then return LocalPlayer:GetAttribute("Money") end end
local function IsItemBlacklisted(ItemName : StringValue)
   for _,v in pairs(BlacklistedItems) do
       if v == ItemName then
           return true
       end
   end
   return false
end
local function FindItemCatergory(ItemName : StringValue)
   local ShopTable = StatsHolder.Shops
   for FirstName,FirstCatergory in pairs(ShopTable) do
       if FirstCatergory ~= "Syntin Petrol Co" then
           for SecondName,SecondCatergory in pairs(FirstCatergory) do
               if SecondCatergory[ItemName] ~= nil then
                   return {
                       ["Item"] = ItemName,
                       ["ItemProvider"] = FirstName,
                       ["ItemCatergory"] = SecondName,
                       ["ItemPrice"] = SecondCatergory[ItemName][2]
                   }
               end
           end
       end
   end
end
local function DecideSource(MinimumMoneyNeeded : IntValue)
   local PrimarySourceMoney = GetMoneyOfSource(MoneySource)
   if MoneySource == "Client" then
       if PrimarySourceMoney >= MinimumMoneyNeeded then
           return MoneySource
       end
   else
       local StationBankrupt = not (workspace.Station:GetAttribute("Money") > workspace.Station:GetAttribute("EstBills"))
       if (StationBankrupt and AllowStationSpendingDuringBankruptcy) or (not StationBankrupt) then
           if LocalPlayer:GetAttribute("Contributions") >= MinimumMoneyNeeded then
               if #game.Teams.Manager:GetPlayers() > 0 then
                   if LocalPlayer.Team == game.Teams.Manager then
                       return MoneySource
                   end
               else
                   return MoneySource
               end
           end
       end
   end
   if AllowSecondarySource then
       local SecondarySourceMoney = GetMoneyOfSource(SecondaryMoneySource)
       if SecondaryMoneySource == "Client" then
           if SecondarySourceMoney >= MinimumMoneyNeeded then
               return SecondaryMoneySource
           end
       else
           local StationBankrupt = not (workspace.Station:GetAttribute("Money") > workspace.Station:GetAttribute("EstBills"))
           if (StationBankrupt and AllowStationSpendingDuringBankruptcy) or (not StationBankrupt) then
               if LocalPlayer:GetAttribute("Contributions") >= MinimumMoneyNeeded then
                   if #game.Teams.Manager:GetPlayers() > 0 then
                       if LocalPlayer.Team == game.Teams.Manager then
                           return SecondaryMoneySource
                       end
                   else
                       return SecondaryMoneySource
                   end
               end
           end
       end
   end
   return MoneySource
end
local function BuyFuel()
   ActionRemote:FireServer("BuyItem","Syntin Petrol Co","Gasoline 87", FuelChoice,DecideSource(StatsHolder["Shops"]["Syntin Petrol Co"]["Gasoline 87"][FuelChoice][2]));
end
local function GetPlayerStamina() return LocalPlayer:GetAttribute("Stamina"); end

if _G.dAAcG3fvBqVoPzVnAFk == nil then _G.dAAcG3fvBqVoPzVnAFk = "" end function notify(a,b,c)local d=c or function()return end;local e=b or false;if a==_G.dAAcG3fvBqVoPzVnAFk and e==false then return end;spawn(function()for f,g in pairs(game.CoreGui:GetChildren())do spawn(function()if g.Name=="MNotify"then pcall(function()g.ImageButton.ZIndex=58;g.ImageButton.TextLabel.ZIndex=59;g.ImageButton:TweenPosition(UDim2.new(0.01,0,1,0),"Out","Quint",.7,true)game:GetService("TweenService"):Create(g.ImageButton.TextLabel,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),{TextTransparency=1})wait(1)g:Destroy()end)end end)end;_G.dAAcG3fvBqVoPzVnAFk=a;local d=c or function()return end;local function h(i,j)local k=Instance.new(i)for f,g in pairs(j)do k[f]=g end;return k end;local l=h('ScreenGui',{DisplayOrder=0,Enabled=true,ResetOnSpawn=true,Name='MNotify',Parent=game.CoreGui})local m=h('ImageButton',{Image='rbxassetid://1051186612',ImageColor3=Color3.new(0.129412,0.129412,0.129412),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(20,20,20,20),AutoButtonColor=true,Modal=false,Selected=false,Style=Enum.ButtonStyle.Custom,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.105882,0.164706,0.207843),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.00999999978,0,1,0),Rotation=0,Selectable=true,Size=UDim2.new(0,234,0,40),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=60,Name='ImageButton',Parent=l})local n=h('TextLabel',{Font=Enum.Font.SourceSansLight,FontSize=Enum.FontSize.Size24,Text=a,TextColor3=Color3.new(0.807843,0.807843,0.807843),TextScaled=false,TextSize=24,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.105882,0.164706,0.207843),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.132478639,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,174,0,40),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=61,Name='TextLabel',Parent=m})local o=h('UIListLayout',{Padding=UDim.new(0,0),FillDirection=Enum.FillDirection.Vertical,HorizontalAlignment=Enum.HorizontalAlignment.Center,SortOrder=Enum.SortOrder.Name,VerticalAlignment=Enum.VerticalAlignment.Top,Name='UIListLayout',Parent=m})local p=1;if string.len(a)<=49 then m.Size=UDim2.new(0,game:GetService("TextService"):GetTextSize(a,24,Enum.Font.SourceSansLight,Vector2.new(500,900)).X+57,0,40)elseif string.len(a)>49 then p=math.ceil(string.len(string.sub(a,49))/9)m.Size=UDim2.new(0,game:GetService("TextService"):GetTextSize(a,24,Enum.Font.SourceSansLight,Vector2.new(500+p*100,900)).X+57,0,40)end;m:TweenPosition(UDim2.new(0.01,0,1,-60),"Out","Quint",.7,true)spawn(function()wait(6.7)pcall(function()m.ZIndex=58;n.ZIndex=59;m:TweenPosition(UDim2.new(0.01,0,1,0),"Out","Quint",.7,true)_G.dAAcG3fvBqVoPzVnAFk=""wait(1)l:Destroy()end)end)m.MouseButton1Up:Connect(function()if c==nil then return end;spawn(function()pcall(function()m.ZIndex=58;n.ZIndex=59;m:TweenPosition(UDim2.new(0.01,0,1,0),"Out","Quint",.7,true)_G.dAAcG3fvBqVoPzVnAFk=""wait(1)l:Destroy()end)end)d()end)end)end
function roundNumber(num, numDecimalPlaces) -- https://devforum.roblox.com/t/rounding-to-1-decimal-point/673504
 return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function TravelToCFrame(TargetCFrame : CFrame)
   local PlayerCharacter = GetPlayerCharacter()
   if PlayerCharacter then
       local DistanceBetweenPoints = ( PlayerCharacter.HumanoidRootPart.Position - TargetCFrame.Position ).Magnitude
       local TimeNeeded = roundNumber(DistanceBetweenPoints / TravelSpeed, 3)
       local Tween = TweenService:Create(
           PlayerCharacter.HumanoidRootPart,
           TweenInfo.new(
               TimeNeeded,
               Enum.EasingStyle.Linear,
               Enum.EasingDirection.Out
           ),
           {
               CFrame = TargetCFrame
           }
       )
       Tween:Play()
       task.wait(TimeNeeded)
   end
end

local function RestoreEnergy(MinimumEnergy : IntValue)
   notify("Resting",true)
   local PlayerCharacter = GetPlayerCharacter()
   local PreviousCFrame = PlayerCharacter.HumanoidRootPart.CFrame
   getgenv().SittingEnabled = true
   TravelToCFrame(workspace.Ceilings.Sofa.Seat.CFrame)
   task.wait(2)
   while true do
       if GetPlayerStamina() >= MinimumEnergy then
           break
       end
       task.wait(0.5)
   end
   spawn(function()
        for i=1,3 do
        PlayerCharacter.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        wait(.5)
        end
   end)
   getgenv().SittingEnabled = false
   TravelToCFrame(PreviousCFrame)
end

local function FindPumpToCar(CarModel : Instance)
   local CarPosition = CarModel.PrimaryPart.Position
   local Pump
   local PumpDistance = 999
   for _,v in pairs(PumpsFolder:GetChildren()) do
       local DistanceBetweenPump = (CarPosition - v.Screen.Position).Magnitude
       if DistanceBetweenPump < PumpDistance then
           Pump = v
           PumpDistance = DistanceBetweenPump
       end
   end
   return Pump
end

local function DoesPumpNeedToBeTakenOut(CarModel : Instance)
   if CarModel:FindFirstChild("Lid") then
       if CarModel.Lid:FindFirstChild("FinishFuel") then
           return true
       end
   end
   return false
end

local function RefuelCar(CarModel : Instance)
   local CarPump = FindPumpToCar(CarModel)
   if DoesPumpNeedToBeTakenOut(CarModel) then
       TravelToCFrame(CarModel.Lid.CFrame)
       ActionRemote:FireServer("FinishFuel", CarModel, CarPump)
       return
   end
   if CarModel:GetAttribute("IsRefueld") or CarModel:GetAttribute("IsRefilling") then return end
   local RequiredFuel = CarModel:GetAttribute("RequiredFuel")
   local TotalAttempts = 0
   if AllowFuelBuy then
       while true do
           TotalAttempts += 1
           local StoreFuel = GetStoreGasoline()
           if StoreFuel >= RequiredFuel then
               break
           end
           notify("Attempting to buy "..tostring(StatsHolder["Shops"]["Syntin Petrol Co"]["Gasoline 87"][FuelChoice][1]).."L of fuel",true)
           BuyFuel()
           task.wait(1)
           if TotalAttempts > 10 then
               break
           end
       end
   end
   if GetPlayerStamina() < 5 then
       RestoreEnergy(95)
   end
   local StoreFuel = GetStoreGasoline()
   if StoreFuel >= RequiredFuel then
       if CarModel.Lid:FindFirstChild("Refuel") then
           TravelToCFrame(CarModel.Lid.CFrame)
           notify("Refilling "..CarModel.Name,true)
           ActionRemote:FireServer("FuelCustomer", CarModel, CarPump)
           task.wait(4)
       end
   end
end

local PreviousItem
local function ScanItem(Item : Instance, CashierModel : Instance)
   if GetPlayerStamina() < 5 then
       RestoreEnergy(95)
   end
   if Item ~= PreviousItem then
       local DistanceFromItem = ( Item.Root.Position - GetPlayerCharacter().HumanoidRootPart.Position ).Magnitude
       if DistanceFromItem > 10 then
           notify("Too far away from cash register",true)
           TravelToCFrame(CFrame.new(1.46752572, 3, -6.53523779, 0.726744831, -4.74023416e-08, 0.68690753, 9.53963948e-08, 1, -3.19205924e-08, -0.68690753, 8.87266296e-08, 0.726744831))
       end
       if Item.Root:FindFirstChild("Scan") then
           if Item.Root:FindFirstChild("Scan").Enabled then
               if not CashierModel:GetAttribute("InUse") then
                   notify("Scanning "..Item.Name,true)
                   ActionRemote:FireServer("ScanItem",Item,CashierModel)
                   Item.Root:FindFirstChild("Scan").Enabled = false
                   PreviousItem = Item
                   task.wait(getgenv().ScanSpeed)
               end
           end
       end
   end
end
InputService.InputBegan:Connect(function(input, gameProcessedEvent)
   if not gameProcessedEvent then
       if input.KeyCode == ToggleFuelKey then
           GasEnabled = not GasEnabled
           notify("Fuel enabled: "..tostring(GasEnabled),true)
       end
       if input.KeyCode == ToggleCashierKey then
           CashierEnabled = not CashierEnabled
           notify("Cashier enabled: "..tostring(CashierEnabled),true)
       end
       if input.KeyCode == ToggleCleanKey then
           CleaningEnabled = not CleaningEnabled
           notify("Cleaning enabled: "..tostring(CleaningEnabled),true)
       end
       if input.KeyCode == ToggleRestockKey then
           RestockEnabled = not RestockEnabled
           notify("Restocking enabled: "..tostring(RestockEnabled),true)
           if not RestockEnabled then
               ItemRestockQueue = {}
           end
       end
       if input.KeyCode == ToggleAntisitKey then
           getgenv().SittingEnabled = not getgenv().SittingEnabled
           notify("Allow Sitting enabled: "..tostring(SittingEnabled),true)
       end
       if input.KeyCode == ToggleNightCleanBreakKey then
            AllowNightCleaning = not AllowNightCleaning
            notify("Breaking Night Cleaning: "..tostring(AllowNightCleaning),true)
            wait(5)
            AllowNightCleaning = not AllowNightCleaning
            notify("Breaking Night Cleaning: "..tostring(AllowNightCleaning),true)
       end
   end
end)

local function ItemRemoved(Item : Instance, Shelf : Instance)
   if RestockEnabled then
       table.insert(ItemRestockQueue,{
           ["ItemShelf"] = Shelf,
           ["ItemType"] = Item.Name,
           ["ItemCFrame"] = Item.PrimaryPart.CFrame - Vector3.new(0,Item.PrimaryPart.Size.Y/2,0)
       })
   end
end
local function NewShelfAdded(shelf : Instance)
   if shelf:FindFirstChild("Content") then
       shelf.Content.ChildRemoved:connect(function(Item)
           ItemRemoved(Item,shelf)
       end)
   end
end

for _,v in pairs(ShelvesFolder:GetChildren()) do
   NewShelfAdded(v)
end
ShelvesFolder.ChildAdded:Connect(NewShelfAdded)

--notify("Script made by TheSynapseGuy on V3rm")
function fireproxprompt(Obj, Amount, Skip)
    if Obj.ClassName == "ProximityPrompt" then 
        Amount = Amount or 1
        local PromptTime = Obj.HoldDuration
        if Skip then 
            Obj.HoldDuration = 0
        end
        for i = 1, Amount do 
            Obj:InputHoldBegin()
            if not Skip then 
                wait(Obj.HoldDuration+2)
            end
            Obj:InputHoldEnd()
        end
        Obj.HoldDuration = PromptTime
    else 
        error("userdata<ProximityPrompt> expected")
    end
end


function getswitch(Name)
    --Name = Name or "Lights" or "A/C"
    pcall(function()
    print("trying to get switch name "..Name)
        for _,v in pairs(game.Workspace.Ceilings.This:GetDescendants()) do
            if v:IsA("TextLabel") and string.find(v.Text, Name) then
                local switchthing = v.Parent.Parent.Parent
                for _,z in pairs(switchthing:GetDescendants()) do
                    if z.Name == "Power" then
                        print(z.Parent.Name.. " ok test 382")
                        local returnstuff = z.Parent
                        print(returnstuff)
                        return returnstuff
                    end
                end
            end
        end
    end)
end


function getswitchpower(Name)
    Name = Name or "Lights"
    if Name == "Lights" then
        local oncount = 0
        local offcount = 0
        for i,v in pairs(game.Workspace.ShopLights:GetDescendants()) do
            if v:IsA("PointLight") and v.Brightness >= 0.5 then
                oncount = oncount + 1
                --print("Light is on, count: "..oncount)
                if oncount >= 12 then
                    print("lights on")
                    oncount = 0
                    local lightstateon = "ON"
                    return lightstateon
                end
            elseif v:IsA("PointLight") and v.Brightness <= 0.5 then
                offcount = offcount + 1
                --print("Light is off, count: "..offcount)
                if offcount >= 12 then
                    print("lights off")
                    offcount = 0
                    local lightstateoff = "OFF"
                    return lightstateoff
                end
            end
        end
    elseif Name == "A/C" then
        local acstate
        for i,v in pairs(game.Workspace.ShopAC:GetDescendants()) do
            if v:IsA("ParticleEmitter") then
                if v.Enabled then
                    acstate = "ON"
                    print("AC is ON")
                    return acstate
                else
                    acstate = "OFF"
                    print("AC is OFF")
                    return acstate
                end
            end
        end

    end
end

function turnswitch(Name, State)
    pcall(function ()
            --local switchtoturn = getswitchstate(getswitch(Name))
            local switchtoturn = getswitchpower(Name)
            --local switchblock = getswitch(Name)
            --send help
            for _,v in pairs(game.Workspace.Ceilings.This:GetDescendants()) do
                if v:IsA("TextLabel") and string.find(v.Text, Name) then
                    local switchthing = v.Parent.Parent.Parent
                    for _,z in pairs(switchthing:GetDescendants()) do
                        if z.Name == "Power" then
                            local switchblock = z.Parent
            --end help
                            if State == "ON" and switchtoturn == "OFF" then
                                TravelToCFrame(switchblock.CFrame)
                                for i,v in pairs(switchblock:GetDescendants()) do
                                    if v.ClassName == "ProximityPrompt" then
                                        wait(1)
                                        fireproxprompt(v)
                                        notify("Turned "..tostring(Name).." to "..tostring(State),true)
                                    end
                                end
                            elseif State == "OFF" and switchtoturn == "ON" then
                                TravelToCFrame(switchblock.CFrame)
                                for i,v in pairs(switchblock:GetDescendants()) do
                                    if v.ClassName == "ProximityPrompt" then
                                        wait(1)
                                        fireproxprompt(v)
                                        notify("Turned "..tostring(Name).." to "..tostring(State),true)
                                    end
                                end
                            elseif State == switchtoturn then
                                print("Correct Switch State")
                            else 
                            print("ERROR")
                            --turnswitch(Name, State)
                            end
                        end
                    end
                end
            end
        wait(2)
        switchtoturncheck = getswitchpower(Name)
        if State ~= switchtoturncheck then
            notify("Switch failed. Retrying",true)
            turnswitch(Name, State)
        end
    end)
end

function checkcustomers()
    for _,v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "Customer" then
            return true
        end
    end
end

function disableall()
    if getgenv().GasEnabled then
        getgenv().GasEnabled = false
        getgenv().GasEnabledCache = true
        notify("Gas Cache: "..GasEnabledCache,true)
    end
    if getgenv().CleaningEnabled then
        getgenv().CleaningEnabled = false
        getgenv().CleaningEnabledCache = true
        notify("Cleaning Cache: "..CleaningEnabledCache,true)
    end
    if getgenv().CashierEnabled then
        getgenv().CashierEnabled = false
        getgenv().CashierEnabledCache = true
        notify("Cashier Cache: "..CashierEnabledCache,true)
    end
    wait(.1)
end

function enableall()
    if getgenv().CashierEnabledCache then
        getgenv().CashierEnabled = true
        getgenv().CashierEnabledCache = false
        notify("Re-enabled Cashier",true)
    end
    if getgenv().GasEnabledCache then
        getgenv().GasEnabled = true
        getgenv().GasEnabledCache = false
        notify("Re-enabled Gas",true)
    end
    if getgenv().CleaningEnabledCache then
        getgenv().CleaningEnabled = true
        getgenv().CleaningEnabledCache = false
        notify("Re-enabled Cleaning",true)
    end
    wait(.1)
end
--MODDED
function CleanOvernight()
    if getgenv().AllowNightCleaning then
        pcall(function()
            if GetPlayerStamina() < 5 then
                RestoreEnergy(95)
            end
                for _,v in pairs(workspace.Windows:GetChildren()) do
                if v:FindFirstChild("Attachment") then
                    if v.Attachment.Clean.Enabled then
                        if GetPlayerStamina() < 5 then
                            RestoreEnergy(95)
                        end
                        if getgenv().AllowNightCleaning == false then break end
                        TravelToCFrame(v.CFrame)
                        ActionRemote:FireServer("Clean",v.Attachment.Clean)
                        task.wait(getgenv().CleaningSpeed)
                    end
                end
            end
            for _,v in pairs(workspace:GetChildren()) do
                if v.Name == "Spot" then
                    if GetPlayerStamina() < 5 then
                        RestoreEnergy(95)
                    end
                    if getgenv().AllowNightCleaning == false then break end
                    notify("Cleaning spot")
                    TravelToCFrame(v.CFrame + Vector3.new(0,3,0))
                    ActionRemote:FireServer("Clean",v.Clean)
                    task.wait(getgenv().CleanSpeed)
                end
            end
            for _,v in pairs(workspace.Solar.Panels:GetChildren()) do
                local CleanPrompt = v.Stand.CleanPosition:FindFirstChild("Clean")
                if CleanPrompt then
                    if CleanPrompt.Enabled then
                        if GetPlayerStamina() < 5 then
                            RestoreEnergy(95)
                        end
                        if getgenv().AllowNightCleaning == false then break end
                        notify("Cleaning Solar Panels")
                        TravelToCFrame(v.Stand.CleanPosition.WorldCFrame)
                        ActionRemote:FireServer("Clean",CleanPrompt)
                        task.wait(getgenv().CleaningSpeed)
                    end
                end
            end
        end)
    end
end

--so real ikr

task.spawn(function()
   while true do
       if not getgenv().SittingEnabled then
           if LocalPlayer.Character:FindFirstChild("Humanoid") then
               if LocalPlayer.Character.Humanoid.Sit then
                   LocalPlayer.Character.Humanoid:ChangeState(3)
               end
           end
       end
       task.wait(0.1)
   end
end)

function GasEnabledFunction()
    pcall(function()
    for _,v in pairs(workspace:GetChildren()) do
    if GasEnabled == false then break end
        if v.Name:sub(1,4) == "Car_" then
            RefuelCar(v)
            task.wait(getgenv().FuelSpeed)
        end
    end
    end)
end

function CashierEnabledFunction()
    pcall(function()
        for _,v in pairs(workspace.Checkouts:GetChildren()) do
            for _,h in pairs(v.Items:GetChildren()) do
                if CashierEnabled == false then break end
                ScanItem(h,v)
           end
        end
    end)
end

function CleaningEnabledFunction()
    pcall(function()
        if GetPlayerStamina() < 5 then
            RestoreEnergy(95)
        end
            for _,v in pairs(workspace.Windows:GetChildren()) do
               if v:FindFirstChild("Attachment") then
                   if v.Attachment.Clean.Enabled then
                       if GetPlayerStamina() < 5 then
                           RestoreEnergy(95)
                       end
                       if CleaningEnabled == false then break end
                       notify("Cleaning window",true)
                       TravelToCFrame(v.CFrame)
                       ActionRemote:FireServer("Clean",v.Attachment.Clean)
                       task.wait(4.2)
                   end
               end
           end
           for _,v in pairs(workspace:GetChildren()) do
               if v.Name == "Spot" then
                   if GetPlayerStamina() < 5 then
                       RestoreEnergy(95)
                   end
                   if CleaningEnabled == false then break end
                   notify("Cleaning spot")
                   TravelToCFrame(v.CFrame + Vector3.new(0,3,0))
                   ActionRemote:FireServer("Clean",v.Clean)
                   task.wait(getgenv().CleanSpeed)
               end
           end
           for _,v in pairs(workspace.Solar.Panels:GetChildren()) do
               local CleanPrompt = v.Stand.CleanPosition:FindFirstChild("Clean")
               if CleanPrompt then
                   if CleanPrompt.Enabled then
                       if GetPlayerStamina() < 5 then
                           RestoreEnergy(95)
                       end
                       if CleaningEnabled == false then break end
                       notify("Cleaning Solar Panels")
                       TravelToCFrame(v.Stand.CleanPosition.WorldCFrame)
                       ActionRemote:FireServer("Clean",CleanPrompt)
                       task.wait(getgenv().CleanSpeed)
                   end
               end
            end
    end)
end
spawn(function()
    while true do
        task.wait(0.1)
        if GasEnabled then
            GasEnabledFunction()
        end
        if CashierEnabled then
            CashierEnabledFunction()
        end
        if CleaningEnabled then
            CleaningEnabledFunction()
        end
        if RestockEnabled then
            pcall(function()
            if #ItemRestockQueue >= 1 then
                local ItemRestockQueueCache = ItemRestockQueue
                ItemRestockQueue = {}
                for _, iteminfo in pairs(ItemRestockQueueCache) do
                    if GetPlayerStamina() < 5 then
                        RestoreEnergy(95)
                    end
                    if StorageFolder:FindFirstChild(iteminfo["ItemType"]) and not IsItemBlacklisted(iteminfo["ItemType"]) then
                        local RemainingItems = StorageFolder:FindFirstChild(iteminfo["ItemType"]):GetAttribute("Storage")
                        if RemainingItems <= 0 then
                            if AllowItemsBuy then
                                ItemShopInfo = FindItemCatergory(iteminfo["ItemType"])
                                local Attempts = 0
                                while true do
                                    Attempts += 1
                                    RemainingItems = StorageFolder:FindFirstChild(iteminfo["ItemType"]):GetAttribute("Storage")
                                    if RemainingItems > 0 then
                                        break
                                    end
                                    if Attempts > 5 then
                                        break
                                    end
                                    notify("Attempting to buy "..iteminfo["ItemType"],true)
                                    ActionRemote:FireServer("BuyItem",ItemShopInfo["ItemProvider"],ItemShopInfo["ItemCatergory"], iteminfo["ItemType"],DecideSource(ItemShopInfo["ItemPrice"]));
                                    task.wait(1.5)
                                end
                            end
                        end
                        RemainingItems = StorageFolder:FindFirstChild(iteminfo["ItemType"]):GetAttribute("Storage")
                        if RemainingItems > 0 then
                            --TravelToCFrame(iteminfo["ItemShelf"].PrimaryPart.CFrame) not really needed
                            ActionRemote:FireServer("PlaceProduct",iteminfo["ItemType"],iteminfo["ItemCFrame"])
                            notify("Restocked "..iteminfo["ItemType"],true)
                        else
                            notify("Failed to restock "..iteminfo["ItemType"]..", not enough stock",true)
                        end
                    end
                end
            end
            end)
        end
     end
end)

spawn(function ()
    --turnswitch("Lights", "OFF")
    if not getgenv().AllowAC then
        disableall()
        notify("Turning A/C off, please wait", true)
        wait(3)
        turnswitch("A/C", "OFF")
        enableall()
        notify("Done Disabling A/C", true)
    end
end)

CloseSign.Changed:Connect(function()
    pcall(function()
        if CloseSign.Enabled == true then
            if getgenv().lightsaving == true then
                local waitcustomer = checkcustomers() 
                repeat wait(1) until not waitcustomer
                disableall()
                wait(3)
                notify("Turning lights off", true)
                turnswitch("Lights", "OFF")
                enableall()
            end
            if getgenv().acsaving == true then
                local waitcustomer = checkcustomers() 
                repeat wait(1) until not waitcustomer
                disableall()
                wait(3)
                notify("Turning AC off")
                turnswitch("A/C", "OFF")
                enableall()
            end
            if not getgenv().CleaningEnabled then
                CleanOvernight()
            end
        elseif CloseSign.Enabled == false then
                disableall()
                wait(5)
                notify("Turning lights on", true)
                turnswitch("Lights", "ON") --no one will buy if lights off duh
                enableall()
            if getgenv().allowAC == true then
                disableall()
                wait(3)
                notify("Turning AC on", true)
                turnswitch("A/C", "ON")
                enableall()
            end
        end
    end)
end)

