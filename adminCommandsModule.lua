local module = {}

local notifcation = require(game.ReplicatedStorage[".modules"].MainModule)
local permanentDeath = game.ServerStorage:WaitForChild(".values").permanentDeath
local tweenTimes = 2

local ts = game:GetService("TweenService")

function module.adminJoined(player)
	--Variables
	local groupID = 33988954
	local onjoinNotification = true
	
	if player:GetRankInGroup(groupID) >=2 then
		module.adminCommands(player)
		
		--Notification on Join
		if onjoinNotification ~= false then
			task.wait(1)
			local title = "Administrative Access"
			local desc = "Welcome back, " .. player.Name .. ", to Sizen. If you'd like to take a look at the commands, run the ';cmds' command inside the chat."
			local notiName = "moderatorEntered"
			local cd = 1
			notifcation.adminNotifications(player,title,desc,notiName,cd)
		end
		
		
	end
	
end

function module.adminCommands(player)
	--Variables
	local prefix = ';'

	local commands = {
		--Permanent Death Enabled: Used to start PD's in servers.
		["pdon"] = function()
			if permanentDeath.Value ~= true then
				
				game.ReplicatedStorage[".events"][".cmds"].pdEvent:FireAllClients()
				
				permanentDeath.Value = true
				print("Permanent Death has been enabled.")
				
				local Lighting = game:GetService("Lighting")

				local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
				local tween = ts:Create(Lighting, tweenInfo, {ClockTime = 0})

				tween:Play()
				
				player.PlayerGui:FindFirstChild(".mainUI").permaDeath.Visible = true
				--Tweening
				for i,v in pairs(player.PlayerGui:FindFirstChild(".mainUI").permaDeath:GetChildren()) do
					if v.ClassName == "TextLabel" then
						local prop1 = {
							TextTransparency = 0
						}
						local ts1 = TweenInfo.new(tweenTimes,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
						local tween1 = ts:Create(v,ts1,prop1)
						tween1:Play()
						
					elseif v.ClassName == "ImageLabel" then
						local prop2 = {
							ImageTransparency = 0
						}
						local ts2 = TweenInfo.new(tweenTimes,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
						local tween2 = ts:Create(v,ts2,prop2)
						tween2:Play()
					end
				end
				
				local title = "Permanent Death Enabled"
				local desc = player.Name .. " has enabled the permanent death feature."
				local notiName = "pdEnabled"
				local cd = 7
				notifcation.adminNotifications(player, title, desc, notiName, cd)
				
			
			else
				local title = "Permanent Death Already Enabled"
				local desc = "The permanent death feature has already been enabled."
				local notiName = "pdEnabledAlready"
				local cd = 7
				notifcation.adminNotifications(player, title, desc, notiName, cd)
				print("Permanent Death is already enabled.")
			end
		end,

		--Permanent Death Disabled: Used to stop PD's in servers.
		["pdoff"] = function()
			if permanentDeath.Value ~= false then
				
				--Tweening
				for i,v in pairs(player.PlayerGui:FindFirstChild(".mainUI").permaDeath:GetChildren()) do
					if v.ClassName == "TextLabel" then
						local prop1 = {
							TextTransparency = 1
						}
						local ts1 = TweenInfo.new(tweenTimes,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
						local tween1 = ts:Create(v,ts1,prop1)
						tween1:Play()

					elseif v.ClassName == "ImageLabel" then
						local prop2 = {
							ImageTransparency = 1
						}
						local ts2 = TweenInfo.new(tweenTimes,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
						local tween2 = ts:Create(v,ts2,prop2)
						tween2:Play()
					end
				end
				
				local Lighting = game:GetService("Lighting")

				local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
				local tween = ts:Create(Lighting, tweenInfo, {ClockTime = 14.5})

				tween:Play()
				
				permanentDeath.Value = false
				print("Permanent Death has been disabled.")
				
				local title = "Permanent Death Disabled"
				local desc = player.Name .. " has disabled the permanent death feature."
				local notiName = "pdDisabled"
				local cd = 7
				notifcation.adminNotifications(player, title, desc, notiName, cd)
			else
				local title = "Permanent Death Already Disabled"
				local desc = "The permanent death feature has already been disabled."
				local notiName = "pdDisabledAlready"
				local cd = 7
				notifcation.adminNotifications(player, title, desc, notiName, cd)
				print("Permanent Death is already disabled.")
			end
		end,
		
		--Set Ryo: Used to set a player's Ryo to a specific amount.
		["setryo"] = function(targetUsername, ryoAmount)
			print("Executing setryo command")

			-- Check if both username and Ryo amount are provided
			if targetUsername and ryoAmount then
				print("Username and Ryo amount provided")
				-- Find the player based on the partial username
				local targetPlayer = nil
				for _, player in ipairs(game.Players:GetPlayers()) do
					if player.Name:lower():sub(1, #targetUsername) == targetUsername:lower() then
						targetPlayer = player
						break
					end
				end

				-- Check if the target player is found
				if targetPlayer then
					print("Target player found:", targetPlayer.Name)
					-- Update the Ryo of the target player
					local plrRyo = targetPlayer:WaitForChild(".playerData").ryo
					plrRyo.Value = tonumber(ryoAmount)
					local title = "Successfully Set Ryo"
					local desc = targetPlayer.Name .. "'s ryo has been set to " .. ryoAmount
					local notiName = "successfullySetRyo"
					local cd = 7
					notifcation.adminNotifications(player, title, desc, notiName, cd)
					print("Ryo of player " .. targetPlayer.Name .. " has been set to " .. ryoAmount)
				else
					print("Player not found with username starting with:", targetUsername)
					local title = "Invalid Username"
					local desc = "Player with username starting with '" .. targetUsername .. "' not found."
					local notiName = "wrongUsername"
					local cd = 7
					notifcation.adminNotifications(player, title, desc, notiName, cd)
				end
			else
				print("Invalid syntax. Please use: ;setryo (partial player username) (amount of Ryo)")
				local title = "Invalid Syntax"
				local desc = "Invalid syntax. Please use: ;setryo (partial player username) (amount of Ryo)"
				local notiName = "wrongSyntax"
				local cd = 7
				notifcation.adminNotifications(player, title, desc, notiName, cd)
			end
		end,
		
		--Setsp: Used to set a player's skill points to a specific amount.
		["setsp"] = function(targetUsername, skillPointsAmt)
			print("Executing setsp command")

			-- Check if both username and skill points  are provided
			if targetUsername and skillPointsAmt then
				print("Username and Skill Points amount provided")
				-- Find the player based on the partial username
				local targetPlayer = nil
				for _, player in ipairs(game.Players:GetPlayers()) do
					if player.Name:lower():sub(1, #targetUsername) == targetUsername:lower() then
						targetPlayer = player
						break
					end
				end

				-- Check if the target player is found
				if targetPlayer then
					print("Target player found:", targetPlayer.Name)
					-- Update the Skill points of the target player
					local plrsp = targetPlayer:WaitForChild(".playerData").skillPoints
					plrsp.Value = tonumber(skillPointsAmt)
					local title = "Successfully Set Skill Points"
					local desc = targetPlayer.Name .. "'s skill points has been set to " .. skillPointsAmt
					local notiName = "successfullysetSP"
					local cd = 7
					notifcation.adminNotifications(player, title, desc, notiName, cd)
					print("Skill points of player " .. targetPlayer.Name .. " has been set to " .. skillPointsAmt)
				else
					print("Player not found with username starting with:", targetUsername)
					local title = "Invalid Username"
					local desc = "Player with username starting with '" .. targetUsername .. "' not found."
					local notiName = "wrongUsername"
					local cd = 7
					notifcation.adminNotifications(player, title, desc, notiName, cd)
				end
			else
				print("Invalid syntax. Please use: ;setsp (partial player username) (amount of skill points)")
				local title = "Invalid Syntax"
				local desc = "Invalid syntax. Please use: ;setsp (partial player username) (amount of skill points)"
				local notiName = "wrongSyntax"
				local cd = 7
				notifcation.adminNotifications(player, title, desc, notiName, cd)
			end
		end,
		
		--SetGender: Used to set a player's gender.
		["setgender"] = function(username, gender)
			print("Executing setgender command")

			-- Check if both username and gender are provided
			if username and gender then
				print("Username and gender provided")
				-- Normalize gender input
				gender = gender:lower()
				
				if gender == "male" or gender == "female" then
					gender = gender:sub(1,1):upper() .. gender:sub(2)
					-- Find the player based on the partial username
					local targetPlayer = nil
					for _, player in ipairs(game.Players:GetPlayers()) do
						if player.Name:lower():sub(1, #username) == username:lower() then
							targetPlayer = player
							break
						end
					end

					-- Check if the target player is found
					if targetPlayer then
						print("Target player found:", targetPlayer.Name)
						-- Update the gender of the target player
						local playerGender = targetPlayer:WaitForChild(".playerData").gender
						playerGender.Value = gender
						local title = "Successfully Set Gender"
						local desc = targetPlayer.Name .. "'s gender has been set to " .. gender
						local notiName = "successfullySetGender"
						local cd = 7
						notifcation.adminNotifications(player, title, desc, notiName, cd)
						print("Gender of player " .. targetPlayer.Name .. " has been set to " .. gender)
					else
						print("Player not found with username starting with:", username)
						local title = "Invalid Username"
						local desc = "Player with username starting with '" .. username .. "' not found."
						local notiName = "wrongUsername"
						local cd = 7
						notifcation.adminNotifications(player, title, desc, notiName, cd)
					end
				else
					print("Invalid gender. Gender must be 'Male' or 'Female'")
					local title = "Invalid Gender"
					local desc = "Invalid gender. Gender must be 'Male' or 'Female'"
					local notiName = "invalidGender"
					local cd = 7
					notifcation.adminNotifications(player, title, desc, notiName, cd)
				end
			else
				print("Invalid syntax. Please use: ;setgender (partial player username) (gender)")
				local title = "Invalid Syntax"
				local desc = "Invalid syntax. Please use: ;setgender (partial player username) (gender)"
				local notiName = "wrongSyntax"
				local cd = 7
				notifcation.adminNotifications(player, title, desc, notiName, cd)
			end
		end,
		
		--SetVillage: Used to set a player's village.
		["setvillage"] = function(username, village)
			print("Executing setvillage command")

			-- Define valid village names
			local validVillages = {
				"Leaf",
				"Mist",
				"Cloud",
				"Sand",
				"Stone",
				"Sound",
				"Rain",
				"Rogue"
			}

			-- Check if both username and village are provided
			if username and village then
				print("Username and village provided")
				-- Normalize village input
				village = village:lower():gsub("^%l", string.upper)
				-- Check if the village is valid
				if table.find(validVillages, village) then
					-- Find the player based on the partial username
					local targetPlayer = nil
					for _, player in ipairs(game.Players:GetPlayers()) do
						if player.Name:lower():sub(1, #username) == username:lower() then
							targetPlayer = player
							break
						end
					end

					-- Check if the target player is found
					if targetPlayer then
						print("Target player found:", targetPlayer.Name)
						-- Update the village of the target player
						local playerVillage = targetPlayer:WaitForChild(".playerData").village
						playerVillage.Value = village
						local title = "Successfully Set Village"
						local desc = targetPlayer.Name .. "'s village has been set to " .. village
						local notiName = "successfullySetVillage"
						local cd = 7
						notifcation.adminNotifications(player, title, desc, notiName, cd)
						print("Village of player " .. targetPlayer.Name .. " has been set to " .. village)
					else
						print("Player not found with username starting with:", username)
						local title = "Invalid Username"
						local desc = "Player with username starting with '" .. username .. "' not found."
						local notiName = "wrongUsername"
						local cd = 7
						notifcation.adminNotifications(player, title, desc, notiName, cd)
					end
				else
					print("Invalid village. Village must be one of: Leaf, Mist, Cloud, Sand, Stone, Sound, Rain, Rogue")
					local title = "Invalid Village"
					local desc = "Invalid village. Village must be one of: Leaf, Mist, Cloud, Sand, Stone, Sound, Rain, Rogue"
					local notiName = "invalidVillage"
					local cd = 7
					notifcation.adminNotifications(player, title, desc, notiName, cd)
				end
			else
				print("Invalid syntax. Please use: ;setvillage (partial player username) (village)")
				local title = "Invalid Syntax"
				local desc = "Invalid syntax. Please use: ;setvillage (partial player username) (village)"
				local notiName = "wrongSyntax"
				local cd = 7
				notifcation.adminNotifications(player, title, desc, notiName, cd)
			end
		end,
		
		--SetRank: Used to set a player's rank.
		["setrank"] = function(targetUsername, rankNumber)
			print("Executing setrank command")

			-- Define the rank names corresponding to each number
			local rankNames = {
				[0] = "F-",
				[1] = "F",
				[2] = "F+",
				[3] = "E-",
				[4] = "E",
				[5] = "E+",
				[6] = "D-",
				[7] = "D",
				[8] = "D+",
				[9] = "C-",
				[10] = "C",
				[11] = "C+",
				[12] = "B-",
				[13] = "B",
				[14] = "B+",
				[15] = "A-",
				[16] = "A",
				[17] = "A+",
				[18] = "S-",
				[19] = "S",
				[20] = "S+",
				[21] = "SS-",
				[22] = "SS",
				[23] = "SS+",
				[24] = "SS++"
			}

			-- Check if both username and rank number are provided
			if targetUsername and rankNumber then
				print("Username and rank number provided")
				-- Convert rankNumber to integer
				rankNumber = tonumber(rankNumber)

				-- Check if rankNumber is within the valid range
				if rankNumber and rankNumber >= 0 and rankNumber <= 24 then
					print("Valid rank number:", rankNumber)
					-- Find the player based on the partial username
					local targetPlayer = nil
					for _, player in ipairs(game.Players:GetPlayers()) do
						if player.Name:lower():sub(1, #targetUsername) == targetUsername:lower() then
							targetPlayer = player
							break
						end
					end

					-- Check if the target player is found
					if targetPlayer then
						print("Target player found:", targetPlayer.Name)
						local playerRank = targetPlayer:WaitForChild(".playerData").playerRank
						playerRank.Value = rankNames[rankNumber]
						local title = "Successfully Set Rank"
						local desc = targetPlayer.Name .. "'s rank has been set to " .. rankNames[rankNumber]
						local notiName = "successfullySetRank"
						local cd = 7
						notifcation.adminNotifications(player, title, desc, notiName, cd)
						print("Rank of player " .. targetPlayer.Name .. " has been set to " .. rankNames[rankNumber])
					else
						print("Player not found with username starting with:", targetUsername)
						local title = "Invalid Username"
						local desc = "Player with username starting with '" .. targetUsername .. "' not found."
						local notiName = "wrongUsername"
						local cd = 7
						notifcation.adminNotifications(player, title, desc, notiName, cd)
					end
				else
					print("Rank number must be between 0 and 24.")
					local title = "Invalid Rank Number"
					local desc = "Rank number must be between 0 and 24."
					local notiName = "invalidRankNumber"
					local cd = 7
					notifcation.adminNotifications(player, title, desc, notiName, cd)
				end
			else
				print("Invalid syntax. Please use: ;setrank (partial player username) (rank number)")
				local title = "Invalid Syntax"
				local desc = "Invalid syntax. Please use: ;setrank (partial player username) (rank number)"
				local notiName = "wrongSyntax"
				local cd = 7
				notifcation.adminNotifications(player, title, desc, notiName, cd)
			end
		end,
		
		--SetTitle: Used to set a player's title.
		["settitle"] = function(username, title)
			print("Executing settitle command")

			-- Define rank number to title mapping
			local rankNames = {
				[0] = "Academy Student",
				[1] = "Genin",
				[2] = "Chūnin",
				[3] = "Jōnin",
				[4] = "Spec. Jōnin",
				[5] = "Anbu Black Ops",
				[6] = "Anbu Commander",
				[7] = "Council",
				[8] = "Advisor",
				[9] = "Sannin",
				[10] = "Kage"
			}

			-- Check if both username and title are provided
			if username and title then
				print("Username and title provided")
				-- Check if title is a number
				local rankNum = tonumber(title)
				if rankNum and rankNames[rankNum] then
					-- Find the player based on the partial username
					local targetPlayer = nil
					for _, player in ipairs(game.Players:GetPlayers()) do
						if player.Name:lower():sub(1, #username) == username:lower() then
							targetPlayer = player
							break
						end
					end

					-- Check if the target player is found
					if targetPlayer then
						print("Target player found:", targetPlayer.Name)
						-- Update the title of the target player
						local playerTitle = targetPlayer:WaitForChild(".playerData").playerTitle
						playerTitle.Value = rankNames[rankNum]
						local title = "Successfully Set Title"
						local desc = targetPlayer.Name .. "'s title has been set to " .. rankNames[rankNum]
						local notiName = "successfullySetTitle"
						local cd = 7
						notifcation.adminNotifications(player, title, desc, notiName, cd)
						print("Title of player " .. targetPlayer.Name .. " has been set to " .. rankNames[rankNum])
					else
						print("Player not found with username starting with:", username)
						local title = "Invalid Username"
						local desc = "Player with username starting with '" .. username .. "' not found."
						local notiName = "wrongUsername"
						local cd = 7
						notifcation.adminNotifications(player, title, desc, notiName, cd)
					end
				else
					print("Invalid title. Title must be a number between 0 and 9.")
					local title = "Invalid Title"
					local desc = "Invalid title. Title must be a number between 0 and 9."
					local notiName = "invalidTitle"
					local cd = 7
					notifcation.adminNotifications(player, title, desc, notiName, cd)
				end
			else
				print("Invalid syntax. Please use: ;settitle (partial player username) (title)")
				local title = "Invalid Syntax"
				local desc = "Invalid syntax. Please use: ;settitle (partial player username) (title)"
				local notiName = "wrongSyntax"
				local cd = 7
				notifcation.adminNotifications(player, title, desc, notiName, cd)
			end
		end,
		
	}

	-- Player Chat Commands: Check What Command The Player Is Running
	player.Chatted:Connect(function(message)
		if message:sub(1, #prefix) == prefix then
			local cmd, args = message:match("^"..prefix.."(%S+)%s*(.*)")
			-- Check if the command exists in the table
			if commands[cmd] then
				-- Execute the corresponding function for the command, passing the message
				commands[cmd](args:match("(%S+)%s+(.*)"))
			else
				print("Command not recognized:", cmd)
			end
		end
	end)
	
end

return module
