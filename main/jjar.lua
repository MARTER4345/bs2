
_G.WaitValue = .2 
_G.TweenSpeed = .3 --Tweening time 4.3
_G.Coins = true --set for yes
_G.Hearts = true
local snowapi = loadstring(game:HttpGet("https://raw.githubusercontent.com/MARTER4345/beeswarm/main/snowflake/snowapi.lua"))()
local api = loadstring(game:HttpGet("https://raw.githubusercontent.com/MARTER4345/beeswarm/main/snowflake/snowapi.lua"))()

function Tween(time,pos)
		pcall(function()
			workspace.Gravity = 0
			game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = pos}):Play() wait(time)
			workspace.Gravity = 196.19999694824
		end)
	end
	wait(0.1)
	function Repeat()
		local cointext = game.Players.LocalPlayer.PlayerGui.GameGui.BottomRightContainer.HudFrame.Coins.Amount.Text
		if _G.Coins then --TOGGLE ADDED, WOOOO!
			if not cointext == "MAX" then
				for i,v in pairs(game.Workspace.Coins:GetChildren()) do
					if v.Name == "CoinPart" then
							local snowflakepos = CFrame.new(v.Position) * CFrame.Angles(0, math.rad(90), 0)
							--local snowflakepos = v.CFrame
								Tween(_G.TweenSpeed,snowflakepos) pcall(function()
								task.wait(_G.WaitValue)
							end)
						if cointext == "MAX" then break end
					end
				end
			end
		else print("Farming  ended.")
			wait(_G.WaitValue)
		end
		if _G.Hearts then
			for i,v in pairs(game.Workspace.Coins:GetChildren()) do
				if v.Name == "HEART TOKEN" then
						local snowflakepos = CFrame.new(v.Main.Position) * CFrame.Angles(0, math.rad(90), 0)
							Tween(_G.TweenSpeed,snowflakepos) pcall(function()
							wait(_G.WaitValue)
						end)
				end
			end
		end
		Repeat()
	end
	wait(_G.WaitValue)
	Repeat()
