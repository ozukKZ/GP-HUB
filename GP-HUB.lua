spawn(function()
game.StarterGui:SetCore("SendNotification", {
Title = "Welcome to Glitch Pack";
Text = "created by KZ",
Icon = "rbxassetid://5472203252";
Duration = 3;
})
wait(3)
game.StarterGui:SetCore("SendNotification", {
Title = "Glitch Pack";
Text = "Here have much thing you need, if you dont know how to use read outside script",
Icon = "rbxassetid://5472203252";
Duration = 5;
})
wait(5)
game.StarterGui:SetCore("SendNotification", {
Title = "Glitch Pack";
Text = "Enjoy X3",
Icon = "rbxassetid://5472203252";
Duration = 3;
})

--[[
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "CAM LOCK ON PLAYER";
        Text = "Press P first then find player you want aim press U to lock press again to turn off.";
        })
]]
local plrs = game:GetService("Players")
local TeamBased = true ; local teambasedswitch = "p"
local presskeytoaim = true; local aimkey = "u"
local raycast = false

local espupdatetime = 5; autoesp = false



local lockaim = true; local lockangle = 5



local Gui = Instance.new("ScreenGui")
local Move = Instance.new("Frame")
local Main = Instance.new("Frame")
local st1 = Instance.new("TextLabel")
local st1_2 = Instance.new("TextLabel")
local st1_3 = Instance.new("TextLabel")
local Name = Instance.new("TextLabel")
--Properties:

-- Scripts:


local plrsforaim = {}

local lplr = game:GetService("Players").LocalPlayer
Move.Draggable = true
Gui.ResetOnSpawn = false
Gui.Name = "Chat"
Gui.DisplayOrder = 999

	Gui.Parent = plrs.LocalPlayer.PlayerGui


f = {}



local cam = game.Workspace.CurrentCamera

local mouse = lplr:GetMouse()
local switch = false
local key = "k"
local aimatpart = nil
mouse.KeyDown:Connect(function(a)
	if a == "t" then
		print("worked1")
		f.addesp()
	elseif a == "u" then
		if raycast == true then
			raycast = false
		else
			raycast = true
		end
	elseif a == "l" then
		if autoesp == false then
			autoesp = true
		else
			autoesp = false
		end
	end
	if a == "" then
		if mouse.Target then
			mouse.Target:Destroy()
		end
	end
	if a == key then
		if switch == false then
			switch = true
		else
			switch = false
			if aimatpart ~= nil then
				aimatpart = nil
			end
		end
	elseif a == teambasedswitch then
		if TeamBased == true then
			TeamBased = false
			teambasedstatus.Text = tostring(TeamBased)
		else
			TeamBased = true
			teambasedstatus.Text = tostring(TeamBased)
		end
	elseif a == aimkey then
		if not aimatpart then
			local maxangle = math.rad(20)
			for i, plr in pairs(plrs:GetChildren()) do
				if plr.Name ~= lplr.Name and plr.Character and plr.Character.Head and plr.Character.Humanoid and plr.Character.Humanoid.Health > 1 then
					if TeamBased == true then
						if plr.Team.Name ~= lplr.Team.Name then
							local an = checkfov(plr.Character.Head)
							if an < maxangle then
								maxangle = an
								aimatpart = plr.Character.Head
							end
						end
					else
						local an = checkfov(plr.Character.Head)
							if an < maxangle then
								maxangle = an
								aimatpart = plr.Character.Head
							end
							print(plr)
					end
					plr.Character.Humanoid.Died:Connect(function()
						if aimatpart.Parent == plr.Character or aimatpart == nil then
							aimatpart = nil
						end
					end)
				end
			end
		else
			aimatpart = nil
		end
	end
end)

function getfovxyz (p0, p1, deg)
	local x1, y1, z1 = p0:ToOrientation()
	local cf = CFrame.new(p0.p, p1.p)
	local x2, y2, z2 = cf:ToOrientation()
	--local d = math.deg
	if deg then
		--return Vector3.new(d(x1-x2), d(y1-y2), d(z1-z2))
	else
		return Vector3.new((x1-x2), (y1-y2), (z1-z2))
	end
end

function getaimbotplrs()
	plrsforaim = {}
	for i, plr in pairs(plrs:GetChildren()) do
		if plr.Character and plr.Character.Humanoid and plr.Character.Humanoid.Health > 0 and plr.Name ~= lplr.Name and plr.Character.Head then
			
			if TeamBased == true then
				if plr.Team.Name ~= lplr.Team.Name then
					local cf = CFrame.new(game.Workspace.CurrentCamera.CFrame.p, plr.Character.Head.CFrame.p)
					local r = Ray.new(cf, cf.LookVector * 10000)
					local ign = {}
					for i, v in pairs(plrs.LocalPlayer.Character:GetChildren()) do
						if v:IsA("BasePart") then
							table.insert(ign , v)
						end
					end
					local obj = game.Workspace:FindPartOnRayWithIgnoreList(r, ign)
					if obj.Parent == plr.Character and obj.Parent ~= lplr.Character then
						table.insert(plrsforaim, obj)
					end
				end
			else
				local cf = CFrame.new(game.Workspace.CurrentCamera.CFrame.p, plr.Character.Head.CFrame.p)
				local r = Ray.new(cf, cf.LookVector * 10000)
				local ign = {}
				for i, v in pairs(plrs.LocalPlayer.Character:GetChildren()) do
					if v:IsA("BasePart") then
						table.insert(ign , v)
					end
				end
				local obj = game.Workspace:FindPartOnRayWithIgnoreList(r, ign)
				if obj.Parent == plr.Character and obj.Parent ~= lplr.Character then
					table.insert(plrsforaim, obj)
				end
			end
			
			
		end
	end
end

function aimat(part)
	cam.CFrame = CFrame.new(cam.CFrame.p, part.CFrame.p)
end
function checkfov (part)
	local fov = getfovxyz(game.Workspace.CurrentCamera.CFrame, part.CFrame)
	local angle = math.abs(fov.X) + math.abs(fov.Y)
	return angle
end

game:GetService("RunService").RenderStepped:Connect(function()
	if aimatpart then
		aimat(aimatpart)
		if aimatpart.Parent == plrs.LocalPlayer.Character then
			aimatpart = nil
		end
	end
	
	

		
		if raycast == true and switch == false and not aimatpart then
			getaimbotplrs()
			aimatpart = nil
			local maxangle = 999
			for i, v in ipairs(plrsforaim) do
				if v.Parent ~= lplr.Character then
					local an = checkfov(v)
					if an < maxangle and v ~= lplr.Character.Head then
						maxangle = an
						aimatpart = v
						print(v:GetFullName())
						v.Parent.Humanoid.Died:connect(function()
							aimatpart = nil
						end)
					end
				end
			end
		
	end
end)
delay(0, function()
	while wait(espupdatetime) do
		if autoesp == true then
			pcall(function()
			f.addesp()
			end)
		end
	end
end)
warn("loaded")
end)

spawn(function()
--NOT A DUMB SCRIPT ANYMORE
--CHANGE FAST RESET AT "]" GONE
--[[
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "GLITCH PACK";
    Text = "Made by kuzo#2434";
})

game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Glitch/faster Script";
        Text = "How to use:";
        })

game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Moves";
        Text = "Bone Crush, Dragon Crush to FUCK.";
        })
]]
local Playe = game:GetService("Players").LocalPlayer
local Mouse = Playe:GetMouse()

Mouse.KeyDown:connect(function(Key)
 Key = Key:lower()
 if Key == ']' then
    Playe.Character.Humanoid.Health = 0
end
end)
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.KeyDown:connect(function(key)
    if key == "l" then
        local plr = game.Players.LocalPlayer
        game.Workspace.Live[plr.Name]["Dragon Throw"].Activator["Throw"]:Destroy()
    end
    end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
        local plr = game.Players.LocalPlayer
        game.Workspace.Live[plr.Name]["Dragon Crush"].Activator["Flip"]:Destroy()
        game.Workspace.Live[plr.Name]["Dragon Crush"].Activator["Throw"]:Destroy()
        game.Workspace.Live[plr.Name]["Dragon Crush"].Activator["Blocked"]:Destroy()
        game.Workspace.Live[plr.Name]["Dragon Crush"].Activator["HitDown"]:Destroy()
        game.Workspace.Live[plr.Name]["Dragon Crush"].Activator["BoneBreak"]:Destroy()
    end
    end)
print("Injected!")
print("Made by kuzo")
wait(0.1)
--[_Glitch_Movepack_]--
--[By: kuzoquest]--
--[[
--turn on skill and press L
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Glitch Movepack";
        Text = "Crack by kuzo enjoy!";
        })
--then use somewho
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Supported Moves:";
        Text = "Dirty Fireworks (x5 also Supported), (Super) Explosive Wave, Burning Blast, Trash???, Planet Crusher, Eraser Cannon, God Hakai, God Wrath, MUCH MORE (Regular not supported) Chain Destructo Disk, Bone Crush, Flash Skewer, Flash Strike, Kaioken Assault.";
        })
]]
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Super Dragon Fist"].Activator.Forward:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Wrathful Charge"].Activator.Forward:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Super Explosive Wave"].Activator.ExplosiveWave.Part2:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Explosive Wave"].Activator.ExplosiveWave.Part2:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Burning Blast"].Activator.Blast.Mesh:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Demon Flash"].Activator.Blast.Mesh:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Burning Attack"].Activator.Blast.Explode:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Trash???"].Activator.Blast.Mesh:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Planet Crusher"].Activator.Blast.Explode:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Super Spirit Bomb"].Activator.Blast.Explode:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Eraser Cannon"].Activator.Blast.Explode:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["GOD Hakai"].Activator.Hakai:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Chain Destructo Disk"].Activator.Blast.Mesh:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Bone Crush"].Activator.Crash:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Flash Skewer"].Activator.Animation:Destroy()
        wait(2.5)
        lplr.Character.HumanoidRootPart.VanishParticle:Destroy()
        lplr.Character.RebirthWings:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Flash Strike"].Activator.Animation:Destroy()
        wait(1)
        lplr.Character.RebirthWings:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Kaioken Assault"].Activator.Forward:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Super Rush"].Activator.Forward:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "l" then
    	local lplr = game.Players.LocalPlayer
        lplr.Character["Rush"].Activator.Forward:Destroy()
    end
end)

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()

Mouse.KeyDown:connect(function(Key)
   Key = Key:lower()
   if Key == ']' then
       Player.Character.Humanoid.Health = 0
end
end)
--[_Un-Glitch_▬_Anti-Kick_]--
--[By: questkuzo]--
--[[
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Un-Glitch";
        Text = "Press ; to enable/disable.";
	})
        
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Anti-Kick";
        Text = "Press ' to enable/disable.";
	})
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Created by: Kuzo#2434";
	Text = "Thank You For Using Script Enjoy!";
})
]]
on = true
off = false
local lplr = game.Players.LocalPlayer
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.KeyDown:connect(function(key)
	if key == ";" then
		if _G.anti == false then
			_G.anti = on
			game:GetService("StarterGui"):SetCore("SendNotification", {
			        Title = "Un-Glitch Enabled";
			        Text = "Press ' to disable.";
			        })
		elseif _G.anti == true then
			_G.anti = off
			game:GetService("StarterGui"):SetCore("SendNotification", {
			    Title = "Un-Glitch Disabled";
			    Text = "Press ; to enable.";
	   		})
   		end
	end
	if key == "'" then
		game:GetService("StarterGui"):SetCore("SendNotification", {
	    Title = "Anti-Kick";
	    Text = "Press ] to disable.";
	   		})
   		lplr.Character.Humanoid.Animator:Destroy()
	end
	if key == "]" then
		lplr.Character.Humanoid.Health = 0
	end
end)

_G.anti = false
_G.anti2 = false

while wait() do
    if _G.anti == true then
    	if lplr.Character:WaitForChild("LowerTorso") then
	        for i, v in pairs(lplr.Character.LowerTorso:GetChildren()) do
	            if v.Name == "Velocity" then
	                v:Destroy()
	            end
	            if v.Name == "KnockBacked" then
	                v:Destroy()
	            end
	            if v.Name == "BodyVelocity" then
	                v:Destroy()
	            end
	        end
    	end
    end
end
end)

spawn(function()
--[_full_No-Slow_]--
--[By: kuzoquestEd]--
--[Version 3.1]--
--[[
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "No-Slow 3.1";
        Text = "Press [ to enable.";
        })

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Thank You For Using This Script!";
	Text = "Created by: kuzo!";
})
]]
noslow = true
slow = false

local mouse = game.Players.LocalPlayer:GetMouse()
mouse.KeyDown:connect(function(key)
if key == "[" then
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "No-Slow Enabled";
        Text = "Press - to disable.";
        })
_G.Skiznillett = noslow
elseif key == "-" then
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "No-Slow Disabled";
        Text = "Press [ to enable.";
        })
_G.Skiznillett = slow
end
end)

_G.Skiznillett = false

while wait() do
	if _G.Skiznillett == true then
		for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
	        if v.Name == "Justice Combination" then
	            local action = game.Players.LocalPlayer.Character:WaitForChild("Action")
	            if action then wait() action:Destroy() end end
	        if v.Name == "Attacking" then
	    		v:Destroy()
	        end
	        if v.Name == "Action" then
	            v:Destroy()
	        end
	        if v.Name == "Killed" then
	            v:Destroy()
	        end
            if v.Name == "ForceField" then
                v:Destroy()
            end
            if v.Name == "Slow" then
                v:Destroy()
            end
            if v.Name == "SuperAction" then
                v:Destroy()
            end
			if v.Name == "Block" and v.Value == true then
				v.Value = false
			end
		end
    end
end
end)
spawn(function()
--[_E_God_Mode_]--
--[NOTE: ONLY WORKS ON EARTH!!!]--
--[By: kuzorn]--
--[Version 2.3]--
--[[
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "God-Mode WORK ONLY EARTH";
    Text = "Press < to enable/disable.";
})
]]
_G.on = false
local touchy = game.Workspace.Touchy.Part
local lplr = game.Players.LocalPlayer
local pos = touchy.CFrame

game:GetService("RunService").RenderStepped:connect(function()
	if earthgodmode == true then
		touchy.Size = Vector3.new(30, 30, 30)
		touchy.CFrame = lplr.Character.HumanoidRootPart.CFrame
		wait()
		touchy.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(50, 50, 50)
	end
	if removegui == true then
		local gui = lplr.PlayerGui
		for i,v in pairs(gui:GetChildren()) do
            if v.Name == "Popup" then
                v.Enabled = false
            end
        end
    end
    if backtopos == true then
    	wait()
    	touchy.Size = Vector3.new(20, 2, 20)
    	touchy.CFrame = pos
	end
end)
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.KeyDown:connect(function(key)
	if key == "," then
	    if _G.on == false then
	        _G.on = true
	        game:GetService("StarterGui"):SetCore("SendNotification", {
	        Title = "God-Mode Enabled";
	        Text = "Press < to disable.";
	        })
	    elseif _G.on == true then
	        touchy.Size = Vector3.new(20, 2, 20)
	        _G.on = false
	        game.Workspace.Touchy.Part.CFrame = CFrame.new(-746.526306, 25.8025646, -6415.6543, 0, 0, 1, 0, 1, -0, -1, 0, 0)
	        game:GetService("StarterGui"):SetCore("SendNotification", {
	        Title = "God-Mode Disabled";
	        Text = "Press < to enable.";
	        })
		end
	end
end)

while wait() do
    while _G.on == true do
    	wait()
        earthgodmode = true
        removegui = true
        backtopos = false
    end
    while _G.on == false do
    	wait()
    	earthgodmode = false
    	removegui = false
    	backtopos = true
	end
end
end)
spawn(function()
local ScreenGui = Instance.new("ScreenGui")
local OpenFrame = Instance.new("Frame")
local Open = Instance.new("TextButton")
local Main = Instance.new("Frame")
local Earth = Instance.new("TextButton")
local Namek = Instance.new("TextButton")
local Space = Instance.new("TextButton")
local Future = Instance.new("TextButton")
local SW = Instance.new("TextButton")
local Queue = Instance.new("TextButton")
local Hpbroly = Instance.new("TextButton")
local BrolyTp = Instance.new("TextButton")
local Heaven = Instance.new("TextButton")
local Zaros = Instance.new("TextButton")
local HTC = Instance.new("TextButton")
local TRespawn = Instance.new("TextButton")
local Slot = Instance.new("TextButton")
local ooooooooo = Instance.new("TextButton")
local BetterSpeed = Instance.new("TextButton")
local RainbowWing = Instance.new("TextButton")
local SpamBeans = Instance.new("TextButton")
local Vanish = Instance.new("TextButton")
local AutobuySenzu = Instance.new("TextButton")
local Pma = Instance.new("TextButton")
local Hidelvlprestige = Instance.new("TextButton")
local Add3moves = Instance.new("TextButton")
local Random = Instance.new("TextButton")
local Punch = Instance.new("TextButton")
local Kzhub = Instance.new("TextButton")
local Fov = Instance.new("TextButton")
local Frame = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local Frame_3 = Instance.new("Frame")
local Frame_4 = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local TextBox_2 = Instance.new("TextBox")

--Properties:

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

OpenFrame.Name = "OpenFrame"
OpenFrame.Parent = ScreenGui
OpenFrame.BackgroundColor3 = Color3.fromRGB(255, 26, 26)
OpenFrame.Position = UDim2.new(0.951515138, 0, 0.967213094, 0)
OpenFrame.Size = UDim2.new(0, 80, 0, 28)

Open.Name = "Open"
Open.Parent = OpenFrame
Open.BackgroundColor3 = Color3.fromRGB(255, 26, 26)
Open.Size = UDim2.new(0, 80, 0, 28)
Open.Text = "Open"
Open.TextColor3 = Color3.fromRGB(0, 0, 0)
Open.TextSize = 18.000
Open.MouseButton1Down:connect(function()
Main.Visible = true
OpenFrame.Visible = false
end)

Main.Name = "Main"
Main.Parent = ScreenGui
Main.Active = true
Main.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
Main.Position = UDim2.new(0.797575712, 0, 0.672131181, 0)
Main.Size = UDim2.new(0, 334, 0, 239)
Main.Visible = false
Main.Draggable = true

Earth.Name = "Earth"
Earth.Parent = Main
Earth.BackgroundColor3 = Color3.fromRGB(0,255,255)
Earth.Position = UDim2.new(0.089820385, 0, 0.1067364001, 0)
Earth.Size = UDim2.new(0, 55, 0, 29)
Earth.Font = Enum.Font.SourceSans
Earth.Text = "Earth"
Earth.TextColor3 = Color3.fromRGB(0, 0, 0)
Earth.TextSize = 14.000
Earth.MouseButton1Down:connect(function()
game:GetService("TeleportService"):Teleport(536102540, game.Players.LocalPlayer)
end)

Namek.Name = "Namek"
Namek.Parent = Main
Namek.BackgroundColor3 = Color3.fromRGB(0,255,255)
Namek.Position = UDim2.new(0.089820385, 0, 0.240000000, 0)
Namek.Size = UDim2.new(0, 55, 0, 29)
Namek.Font = Enum.Font.SourceSans
Namek.Text = "Namek"
Namek.TextColor3 = Color3.fromRGB(0, 0, 0)
Namek.TextSize = 14.000
Namek.MouseButton1Down:connect(function()
game:GetService("TeleportService"):Teleport(882399924, game.Players.LocalPlayer)	
end)

Space.Name = "Space"
Space.Parent = Main
Space.BackgroundColor3 = Color3.fromRGB(0,255,255)
Space.Position = UDim2.new(0.089820385, 0, 0.3756903744, 0)
Space.Size = UDim2.new(0, 55, 0, 29)
Space.Font = Enum.Font.SourceSans
Space.Text = "Space"
Space.TextColor3 = Color3.fromRGB(0, 0, 0)
Space.TextSize = 14.000
Space.MouseButton1Down:connect(function()
game:GetService("TeleportService"):Teleport(478132461, game.Players.LocalPlayer)
end)

Future.Name = "Future"
Future.Parent = Main
Future.BackgroundColor3 = Color3.fromRGB(0,255,255)
Future.Position = UDim2.new(0.089820385, 0, 0.5100000000, 0)
Future.Size = UDim2.new(0, 55, 0, 29)
Future.Font = Enum.Font.SourceSans
Future.Text = "Future"
Future.TextColor3 = Color3.fromRGB(0, 0, 0)
Future.TextSize = 14.000
Future.MouseButton1Down:connect(function()
game:GetService("TeleportService"):Teleport(569994010, game.Players.LocalPlayer)
end)

SW.Name = "Secret World"
SW.Parent = Main
SW.BackgroundColor3 = Color3.fromRGB(0,255,255)
SW.Position = UDim2.new(0.089820385, 0, 0.6514225936, 0)
SW.Size = UDim2.new(0, 55, 0, 29)
SW.Font = Enum.Font.SourceSans
SW.Text = "Secret World"
SW.TextColor3 = Color3.fromRGB(0, 0, 0)
SW.TextSize = 12.000
SW.MouseButton1Down:connect(function()
game:GetService("TeleportService"):Teleport(2046990924, game.Players.LocalPlayer)
end)

Queue.Name = "Queue"
Queue.Parent = Main
Queue.BackgroundColor3 = Color3.fromRGB(0,255,255)
Queue.Position = UDim2.new(0.089820385, 0, 0.7895003744, 0)
Queue.Size = UDim2.new(0, 55, 0, 29)
Queue.Font = Enum.Font.SourceSans
Queue.Text = "Queue"
Queue.TextColor3 = Color3.fromRGB(0, 0, 0)
Queue.TextSize = 14.000
Queue.MouseButton1Down:connect(function()
game:GetService("TeleportService"):Teleport(3565304751, game.Players.LocalPlayer)
end)

Hpbroly.Name = "Dmg Player Broly"
Hpbroly.Parent = Main
Hpbroly.BackgroundColor3 = Color3.fromRGB(0,255,255)
Hpbroly.Position = UDim2.new(0.350658678, 0, 0.1000000000, 0)
Hpbroly.Size = UDim2.new(0, 62, 0, 29)
Hpbroly.Font = Enum.Font.SourceSans
Hpbroly.Text = "Dmg Player Broly"
Hpbroly.TextColor3 = Color3.fromRGB(0, 0, 0)
Hpbroly.TextSize = 10.000
Hpbroly.MouseButton1Down:connect(function()
game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Dmg ppl in broly";
		Text = "Loaded..";
	})
	wait()
	local plr = game.Players.LocalPlayer
	game.Workspace.Live[plr.Name]["team damage"]:Destroy()
end)

BrolyTp.Name = "BrolyTP"
BrolyTp.Parent = Main
BrolyTp.BackgroundColor3 = Color3.fromRGB(0,255,255)
BrolyTp.Position = UDim2.new(0.350658678, 0, 0.2399999999, 0)
BrolyTp.Size = UDim2.new(0, 62, 0, 29)
BrolyTp.Font = Enum.Font.SourceSans
BrolyTp.Text = "BrolyTP"
BrolyTp.TextColor3 = Color3.fromRGB(0, 0, 0)
BrolyTp.TextSize = 14.000
BrolyTp.MouseButton1Down:connect(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Broly Tp";
			Text = "YOU CAN'T turn OFF X3";
		})
		wait()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Keybind";
			Text = "Press . To Use";
		})
		wait()
		local plr = game:GetService("Players").LocalPlayer
		local mouse = plr:GetMouse()
		
		mouse.KeyDown:connect(function(key)
			if key == "." then
				wait(0.1)
				game.TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(2),{CFrame = CFrame.new(2751.67725, 3944.85986, -2272.62622, 0.0375976935, 0, 0.99929297, -0, 1, -0, -0.99929297, 0, 0.0375976935)}):Play()
			end
		end)
	end)

Heaven.Name = "Heaven"
Heaven.Parent = Main
Heaven.BackgroundColor3 = Color3.fromRGB(0,255,255)
Heaven.Position = UDim2.new(0.350658678, 0, 0.7895003744, 0)
Heaven.Size = UDim2.new(0, 55, 0, 29)
Heaven.Font = Enum.Font.SourceSans
Heaven.Text = "Heaven"
Heaven.TextColor3 = Color3.fromRGB(0, 0, 0)
Heaven.TextSize = 14.000
Heaven.MouseButton1Down:connect(function()
wait()
game:GetService("TeleportService"):Teleport(3552157537, game.Players.LocalPlayer)
end)

Zaros.Name = "Zaros"
Zaros.Parent = Main
Zaros.BackgroundColor3 = Color3.fromRGB(0,255,255)
Zaros.Position = UDim2.new(0.350658678, 0, 0.6514225936, 0)
Zaros.Size = UDim2.new(0, 55, 0, 29)
Zaros.Font = Enum.Font.SourceSans
Zaros.Text = "Zaros"
Zaros.TextColor3 = Color3.fromRGB(0, 0, 0)
Zaros.TextSize = 12.000
Zaros.MouseButton1Down:connect(function()
wait()
	game:GetService("TeleportService"):Teleport(2651456105, game.Players.LocalPlayer)
end)

HTC.Name = "HTC"
HTC.Parent = Main
HTC.BackgroundColor3 = Color3.fromRGB(0,255,255)
HTC.Position = UDim2.new(0.350658678, 0, 0.5100000000, 0)
HTC.Size = UDim2.new(0, 55, 0, 29)
HTC.Font = Enum.Font.SourceSans
HTC.Text = "HTC"
HTC.TextColor3 = Color3.fromRGB(0, 0, 0)
HTC.TextSize = 14.000
HTC.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "HTC Teleport";
		Text = "Make sure you have buy it";
	})
	
	wait(1.3)
	game:GetService("TeleportService"):Teleport(882375367, game.Players.LocalPlayer)
end)

TRespawn.Name = "TOP RESET"
TRespawn.Parent = Main
TRespawn.BackgroundColor3 = Color3.fromRGB(0,255,255)
TRespawn.Position = UDim2.new(0.350658678, 0, 0.3756903744, 0)
TRespawn.Size = UDim2.new(0, 55, 0, 29)
TRespawn.Font = Enum.Font.SourceSans
TRespawn.Text = "TOP RESET"
TRespawn.TextColor3 = Color3.fromRGB(0, 0, 0)
TRespawn.TextSize = 14.000
TRespawn.MouseButton1Down:connect(function()
game.StarterGui:SetCore("SendNotification", {
Title = "Top Respawn";
Text = "Press P to respawn",
Icon = "rbxassetid://5472203252";
Duration = 9;
})
local lplr = game:GetService("Players").LocalPlayer
local mouse = lplr:GetMouse()

mouse.KeyDown:connect(function(key)
    if key == "p" then
        game:GetService("TweenService"):Create(lplr.Character.HumanoidRootPart, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = CFrame.new(100, 100, 100)}):Play()
    end
    end)
	
	while wait() do
		pcall(function()
			game.Players.LocalPlayer.Character.SuperAction:Destroy()
		end)
	end

end)

Slot.Name = "Change Slot"
Slot.Parent = Main
Slot.BackgroundColor3 = Color3.fromRGB(255,0,0)
Slot.Position = UDim2.new(0.550658678, 0, 0.1000000000, 0)
Slot.Size = UDim2.new(0, 62, 0, 29)
Slot.Font = Enum.Font.SourceSans
Slot.Text = "Changer Slot"
Slot.TextColor3 = Color3.fromRGB(0, 0, 0)
Slot.TextSize = 14.000
Slot.MouseButton1Down:connect(function()
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Slot Changer";
        Text = "Work Earth - Heaven";
        })
wait()
local A_1 = game:GetService("Workspace").FriendlyNPCs["Character Slot Changer"]
local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatStart
Event:FireServer(A_1)
end)

ooooooooo.Name = "Animations"
ooooooooo.Parent = Main
ooooooooo.BackgroundColor3 = Color3.fromRGB(255,0,0)
ooooooooo.Position = UDim2.new(0.550658678, 0, 0.2399999999, 0)
ooooooooo.Size = UDim2.new(0, 62, 0, 29)
ooooooooo.Font = Enum.Font.SourceSans
ooooooooo.Text = "Animations UwU"
ooooooooo.TextColor3 = Color3.fromRGB(0, 0, 0)
ooooooooo.TextSize = 10.000
ooooooooo.MouseButton1Down:connect(function()
game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Friend Girl Tsuni-chan";
		Text = "Wel cum to Animation dance scripts";
	})
	wait()
_G.ToggleColor = Color3.fromRGB(0,255,255)
_G.ButtonColor = Color3.fromRGB(0,255,255)
_G.SliderColor = Color3.fromRGB(0,255,255)
loadstring(game:HttpGet(('https://pastebin.com/raw/ypqGquf3'),true))()
end)

BetterSpeed.Name = "Super Speed"
BetterSpeed.Parent = Main
BetterSpeed.BackgroundColor3 = Color3.fromRGB(255,0,0)
BetterSpeed.Position = UDim2.new(0.75000000, 0, 0.1000000000, 0)
BetterSpeed.Size = UDim2.new(0, 62, 0, 29)
BetterSpeed.Font = Enum.Font.SourceSans
BetterSpeed.Text = "Super Speed"
BetterSpeed.TextColor3 = Color3.fromRGB(0, 0, 0)
BetterSpeed.TextSize = 12.000
BetterSpeed.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Super Speed";
		Text = "Hold Q then move if hard reset press SuperSpeed again other fun PRESS V";
	})
	function setSpeed(walkspeedSet) ---- change set speed to whatever speed
		
		
		local plr = game:GetService"Players".LocalPlayer
		local serverTraits = plr.Backpack:WaitForChild'ServerTraits'
		
		for i,v in next, getconnections(serverTraits.Input.OnClientEvent) do
			local speed = (350*(walkspeedSet/44))-350
			v:Fire({speed})
			break
		end
	end
	setSpeed(2000)
	wait()
	plr = game.Players.LocalPlayer
	hum = plr.Character.HumanoidRootPart
	mouse = plr:GetMouse()
	
	mouse.KeyDown:connect(function(key)
		if key == "v" then
			if mouse.Target then
				game.Players.LocalPlayer.Backpack.ServerTraits.Vanish:FireServer()
				wait(.25)
				hum.CFrame = CFrame.new(mouse.Hit.x, mouse.Hit.y + 5, mouse.Hit.z)
				wait(.25)
			end
		end
	end)
	wait()
	down = false
	velocity = Instance.new("BodyVelocity")
	velocity.maxForce = Vector3.new(10000000, 0, 10000000)
	---vv Use that to change the speed v
	local speed    = 2500
	gyro           = Instance.new("BodyGyro")
	gyro.maxTorque = Vector3.new(10000000, 0, 10000000)
	
	local hum = game.Players.LocalPlayer.Character.Humanoid
	
	function onButton1Down(mouse)
		down = true
		velocity.Parent = game.Players.LocalPlayer.Character.UpperTorso
		velocity.velocity = (hum.MoveDirection) * speed
		gyro.Parent = game.Players.LocalPlayer.Character.UpperTorso
		while down do
			if not down then break end
			velocity.velocity = (hum.MoveDirection) * speed
			local refpos = gyro.Parent.Position + (gyro.Parent.Position - workspace.CurrentCamera.CoordinateFrame.p).unit * 5
			gyro.cframe = CFrame.new(gyro.Parent.Position, Vector3.new(refpos.x, gyro.Parent.Position.y, refpos.z))
			wait(0.1)
		end
	end
	
	function onButton1Up(mouse)
		velocity.Parent = nil
		gyro.Parent = nil
		down = false
	end
	--To Change the key in those 2 lines, replace the "v" with your desired key
	function onSelected(mouse)
		mouse.KeyDown:connect(function(k) if k:lower()=="q"then onButton1Down(mouse)end end)
		mouse.KeyUp:connect(function(k) if k:lower()=="q"then onButton1Up(mouse)end end)
	end
	
	onSelected(game.Players.LocalPlayer:GetMouse())
end)

RainbowWing.Name = "Rainbow Wing"
RainbowWing.Parent = Main
RainbowWing.BackgroundColor3 = Color3.fromRGB(255,0,0)
RainbowWing.Position = UDim2.new(0.75000000, 0, 0.2399999999, 0)
RainbowWing.Size = UDim2.new(0, 62, 0, 29)
RainbowWing.Font = Enum.Font.SourceSans
RainbowWing.Text = "Rainbow Wing"
RainbowWing.TextColor3 = Color3.fromRGB(0, 0, 0)
RainbowWing.TextSize = 11.000
RainbowWing.MouseButton1Down:connect(function()
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Rainbow wings";
        Text = "for fun only you can see it";
        })
local speed = 20 --Change speed here

local plr = game.Players.LocalPlayer
local wings = game.Workspace.Live[plr.Name].RebirthWings["Handle"]

while true do
    for i = 0,1,0.001*speed do
        wings.Color = Color3.fromHSV(i,1,1)
        wait()
    end
end
end)


Vanish.Name = "Tele Vanish AIM"
Vanish.Parent = Main
Vanish.BackgroundColor3 = Color3.fromRGB(255,0,0)
Vanish.Position = UDim2.new(0.550658678, 0, 0.3756903744, 0)
Vanish.Size = UDim2.new(0, 62, 0, 29)
Vanish.Font = Enum.Font.SourceSans
Vanish.Text = "Tele Vanish AIM"
Vanish.TextColor3 = Color3.fromRGB(0, 0, 0)
Vanish.TextSize = 10.000
Vanish.MouseButton1Down:connect(function()
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Tele Vanish AIM";
        Text = "Press V to TP aim on you mouse";
        })
plr = game.Players.LocalPlayer
hum = plr.Character.HumanoidRootPart
mouse = plr:GetMouse()

mouse.KeyDown:connect(function(key)
if key == "v" then
if mouse.Target then
game.Players.LocalPlayer.Backpack.ServerTraits.Vanish:FireServer()
wait(.25)
hum.CFrame = CFrame.new(mouse.Hit.x, mouse.Hit.y + 5, mouse.Hit.z)
wait(.25)
end
end
end)
end)

SpamBeans.Name = "Auto Beans"
SpamBeans.Parent = Main
SpamBeans.BackgroundColor3 = Color3.fromRGB(255,0,0)
SpamBeans.Position = UDim2.new(0.750658678, 0, 0.3756903744, 0)
SpamBeans.Size = UDim2.new(0, 62, 0, 29)
SpamBeans.Font = Enum.Font.SourceSans
SpamBeans.Text = "Auto Beans"
SpamBeans.TextColor3 = Color3.fromRGB(0, 0, 0)
SpamBeans.TextSize = 13.000
SpamBeans.MouseButton1Down:connect(function()
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "AutoBean Spam by KZ";
        Text = "Press J-ON Press K-OFF";
        })
--[Press J to toggle]--
--[Press K to untoggle]--
Raziq = true
lolers = false

local mouse = game.Players.LocalPlayer:GetMouse()
mouse.KeyDown:connect(function(key)
if key == "j" then 
_G.Noslow = Raziq
elseif key == "k" then
_G.Noslow = lolers
end
end)

while wait(0.5) do 
if _G.Noslow == true then
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.EatSenzu:FireServer(true) 
end 
end
end)

AutobuySenzu.Name = "Buy Senzu"
AutobuySenzu.Parent = Main
AutobuySenzu.BackgroundColor3 = Color3.fromRGB(255,0,0)
AutobuySenzu.Position = UDim2.new(0.550658678, 0, 0.5100000000, 0)
AutobuySenzu.Size = UDim2.new(0, 62, 0, 29)
AutobuySenzu.Font = Enum.Font.SourceSans
AutobuySenzu.Text = "BUY Senzu"
AutobuySenzu.TextColor3 = Color3.fromRGB(0, 0, 0)
AutobuySenzu.TextSize = 12.000
AutobuySenzu.MouseButton1Down:connect(function()
loadstring(game:HttpGet("https://gitlab.com/ozukKZ/op-pack-senzukz.lua/-/raw/master/buy%20senzu%20pack%20kz.lua", true))()
end)

Pma.Name = "Power MA"
Pma.Parent = Main
Pma.BackgroundColor3 = Color3.fromRGB(255,0,0)
Pma.Position = UDim2.new(0.750658678, 0, 0.5100000000, 0)
Pma.Size = UDim2.new(0, 62, 0, 29)
Pma.Font = Enum.Font.SourceSans
Pma.Text = "Power MA"
Pma.TextColor3 = Color3.fromRGB(0, 0, 0)
Pma.TextSize = 12.000
Pma.MouseButton1Down:connect(function()
game.StarterGui:SetCore("SendNotification", {
Title = "Power Meter Adjuster";
Text = "Support BlackWolfJR",
Icon = "rbxassetid://5472203252";
Duration = 6;
})
script=loadstring(game:HttpGet("https://gitlab.com/ozukKZ/power-ma/-/raw/master/PowerMA.lua", true))()
end)

Hidelvlprestige.Name = "HideLVL"
Hidelvlprestige.Parent = Main
Hidelvlprestige.BackgroundColor3 = Color3.fromRGB(222, 49, 99)
Hidelvlprestige.Position = UDim2.new(0.245990385, 0, 0.1967364001, 0)
Hidelvlprestige.Size = UDim2.new(0, 36, 0, 20)
Hidelvlprestige.Font = Enum.Font.SourceSans
Hidelvlprestige.Text = "HideLVL"
Hidelvlprestige.TextColor3 = Color3.fromRGB(0, 0, 0)
Hidelvlprestige.TextSize = 11.000
Hidelvlprestige.MouseButton1Down:connect(function()
--Hide Level-prestige
wait(0,5)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "HIDE lvl-prestige";
    Text = "Hard reset to turn off";
})
for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do 
if v.Name:find("Lvl. ") or v.Name:find("Prestige:") then 
v:Destroy() 
end end
end)

Add3moves.Name = "ADD 3 MOVES"
Add3moves.Parent = Main
Add3moves.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
Add3moves.Position = UDim2.new(0.550658678, 0, 0.6514225936, 0)
Add3moves.Size = UDim2.new(0, 61, 0, 29)
Add3moves.Font = Enum.Font.SourceSans
Add3moves.Text = "ADD 3 MOVES"
Add3moves.TextColor3 = Color3.fromRGB(0, 0, 0)
Add3moves.TextSize = 12.000
Add3moves.MouseButton1Down:connect(function()
spawn(function()
game.StarterGui:SetCore("SendNotification", {
Title = "Add 3 moves skill slot";
Text = "By KZ",
Icon = "rbxassetid://5472203252";
Duration = 3;
})
wait(3)
game.StarterGui:SetCore("SendNotification", {
Title = "Warning";
Text = "Don't changes slot or Hard reset, don't not change Hair for respawn too! X3",
Icon = "rbxassetid://5472203252";
Duration = 7;
})
wait(7)
game.StarterGui:SetCore("SendNotification", {
Title = "ask what you can do?";
Text = "You need rejoin that all X3",
Icon = "rbxassetid://5472203252";
Duration = 5;
})
end)

loadstring(game:HttpGet("https://gitlab.com/ozukKZ/add-3-slot-main/-/raw/master/add%203%20move%20slot.lua"))()
end)

Random.Name = "Server Random"
Random.Parent = Main
Random.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
Random.Position = UDim2.new(0.750658678, 0, 0.6514225936, 0)
Random.Size = UDim2.new(0, 61, 0, 29)
Random.Font = Enum.Font.SourceSans
Random.Text = "Server Random"
Random.TextColor3 = Color3.fromRGB(0, 0, 0)
Random.TextSize = 12.000
Random.MouseButton1Down:connect(function()
spawn(function()
game.StarterGui:SetCore("SendNotification", {
Title = "Change Server Random";
Text = "Do not use this much!. loading... X3",
Icon = "rbxassetid://5472203252";
Duration = 3;
})
wait(3)
local sl = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/".. game.PlaceId.. "/servers/Public?sortOrder=Asc&limit=100"))
for i,v in pairs(sl.data) do
  if v.playing ~= v.maxPlayers then
      game:service'TeleportService':TeleportToPlaceInstance(game.PlaceId, v.id)
  end
end
end)
end)

Punch.Name = "Auto Punch"
Punch.Parent = Main
Punch.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
Punch.Position = UDim2.new(0.550658678, 0, 0.7895003744, 0)
Punch.Size = UDim2.new(0, 61, 0, 29)
Punch.Font = Enum.Font.SourceSans
Punch.Text = "Auto Punch"
Punch.TextColor3 = Color3.fromRGB(0, 0, 0)
Punch.TextSize = 12.000
Punch.MouseButton1Down:connect(function()
game.StarterGui:SetCore("SendNotification", {
Title = "For you question";
Text = "GRAP some kid then N and you can afk, go to watching hentai",
Icon = "rbxassetid://5472203252";
Duration = 8;
})
local Exec_Key = 'n' -- key to enable / disable auto punch ()...
local Type = "Right" --[[ 'Right' for Right click ()...
                         'Left' for Left Click        --]]
check = true
local plr = game:getService("Players").LocalPlayer
local Mouse = plr:GetMouse()
x = 0 
-- starter gui
game.StarterGui:SetCore("SendNotification", {
Title = "Auto Punch";
Text = "Press N to enable/disable, dont use in queue",
Icon = "rbxassetid://5472203252";
Duration = 3;
})
Mouse.KeyDown:connect(function(Key)
 Key = Key:lower()
if Key == Exec_Key then
	
	-- to swap on / off
    if check == false then
        check = true
    end
    if x == 1 then
		game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Auto Punch";
				Text = "OFF";
				})     
        check = false
        x = 0
    end
 

	if check == true then	
		x = 1
		game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Auto Punch";
				Text = "ON";
				})     
		 -- auto punch code 
			if Type == "Right" then
				while ( check == true ) do
					local x = {	[1] = "m2" }
					local frames = CFrame.new(-189.383453, 59.6394577, -73.3549271, 0.159321189, -0.327645749, 0.931270778, -0, 0.943320036, 0.33188498, -0.987226844, -0.0528763086, 0.150290847)
					local Punch = plr.Backpack.ServerTraits.Input
					Punch:FireServer(x, frames, nil, false)
					wait(0,1)
				end
			end
			if Type == "Left" then
				while ( check == true ) do
						local A_1 =  { [1] = "mx" }
						local A_2 = CFrame.new(-457.372772, 27.8608284, -6446.6377, 0.991751373, -0.0145149687, 0.127352476, 9.31322575e-10, 0.993567526, 0.11324162, -0.128176972, -0.112307534, 0.985371888)
						local Event = plr.Backpack.ServerTraits.Input
						Event:FireServer(A_1, A_2, nil,false)
					wait(0.8)
				end
			end
	end		

end
end)
end)

Kzhub.Name = "KZHUB"
Kzhub.Parent = Main
Kzhub.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Kzhub.Position = UDim2.new(0.245990385, 0, 0.7417364001, 0)
Kzhub.Size = UDim2.new(0, 36, 0, 20)
Kzhub.Font = Enum.Font.SourceSans
Kzhub.Text = "KZHUB"
Kzhub.TextColor3 = Color3.fromRGB(0, 0, 0)
Kzhub.TextSize = 11.000
Kzhub.MouseButton1Down:connect(function()
--sell severson
-- make this not change web banned
if not game:IsLoaded() then
	local loadedcheck = Instance.new("Message",workspace)
	loadedcheck.Text = 'Loading...'
	game.Loaded:Wait()
	loadedcheck:Destroy()
end
wait(2)
local SkidHub = Instance.new("ScreenGui")
local SkidHub_Home = Instance.new("ImageLabel")
local UIGradient = Instance.new("UIGradient")
local OpenTab = Instance.new("ImageButton")
local Skid_Hub_Home = Instance.new("ImageLabel")
local NoSlowdown = Instance.new("TextButton")
local BetterSpeed = Instance.new("TextButton")
local Skid = Instance.new("ImageLabel")
local Skid_Hub_Home_Text = Instance.new("TextLabel")
local Line = Instance.new("Frame")
local AutoBlock = Instance.new("TextButton")
local Discord = Instance.new("TextBox")
local Frame_1 = Instance.new("ImageLabel")
local AntiQueue = Instance.new("ImageButton")
local AntiQueue_2 = Instance.new("TextLabel")
local PlrStats = Instance.new("ImageButton")
local TextLabel = Instance.new("TextLabel")
local NoFace = Instance.new("ImageButton")
local NoFace_2 = Instance.new("TextLabel")
local NoAura = Instance.new("ImageButton")
local NoAura_2 = Instance.new("TextLabel")
local FastHTC = Instance.new("ImageButton")
local TextLabel_2 = Instance.new("TextLabel")
local FlyPlus = Instance.new("ImageButton")
local TextLabel_3 = Instance.new("TextLabel")
local Glitch = Instance.new("ImageButton")
local TextLabel_4 = Instance.new("TextLabel")
local Kick = Instance.new("ImageButton")
local TextLabel_5 = Instance.new("TextLabel")
local NoGlitch = Instance.new("ImageButton")
local TextLabel_6 = Instance.new("TextLabel")
local Noclip = Instance.new("ImageButton")
local TextLabel_7 = Instance.new("TextLabel")
local RankGod = Instance.new("ImageButton")
local TextLabel_8 = Instance.new("TextLabel")
local RunPlus = Instance.new("ImageButton")
local TextLabel_9 = Instance.new("TextLabel")
local Smoke = Instance.new("ImageButton")
local TextLabel_10 = Instance.new("TextLabel")
local Vanish = Instance.new("ImageButton")
local TextLabel_11 = Instance.new("TextLabel")
local Close = Instance.new("ImageButton")
local Label = Instance.new("TextLabel")
local Next = Instance.new("ImageButton")
local TextLabel_12 = Instance.new("TextLabel")
local Line_2 = Instance.new("Frame")
local Label_2 = Instance.new("TextLabel")
local Frame_2 = Instance.new("ImageLabel")
local Earth_God = Instance.new("ImageButton")
local Earth_God_2 = Instance.new("TextLabel")
local Soon = Instance.new("ImageButton")
local TextLabel_13 = Instance.new("TextLabel")
local Slots = Instance.new("ImageButton")
local TextLabel_14 = Instance.new("TextLabel")
local Close_2 = Instance.new("ImageButton")
local Label_3 = Instance.new("TextLabel")
local Button = Instance.new("ImageButton")
local TextLabel_15 = Instance.new("TextLabel")
local Kai = Instance.new("ImageButton")
local TextLabel_16 = Instance.new("TextLabel")
local BeanSpam = Instance.new("ImageButton")
local TextLabel_17 = Instance.new("TextLabel")
local Fusion_S = Instance.new("ImageButton")
local TextLabel_18 = Instance.new("TextLabel")
local TRespawn = Instance.new("ImageButton")
local TextLabel_19 = Instance.new("TextLabel")
local GodHTC = Instance.new("ImageButton")
local TextLabel_20 = Instance.new("TextLabel")
local NoPowerLvl = Instance.new("ImageButton")
local TextLabel_21 = Instance.new("TextLabel")
local NoLvl = Instance.new("ImageButton")
local TextLabel_22 = Instance.new("TextLabel")
local NoWings = Instance.new("ImageButton")
local TextLabel_23 = Instance.new("TextLabel")
local NoHalo = Instance.new("ImageButton")
local TextLabel_24 = Instance.new("TextLabel")
local NoLegs = Instance.new("ImageButton")
local TextLabel_25 = Instance.new("TextLabel")
local TC = Instance.new("ImageButton")
local TextLabel_26 = Instance.new("TextLabel")
local Label_4 = Instance.new("TextLabel")
local Line_3 = Instance.new("Frame")
local Frame_3 = Instance.new("ImageLabel")
local Button_2 = Instance.new("ImageButton")
local TextLabel_27 = Instance.new("TextLabel")
local Close_3 = Instance.new("ImageButton")
local Label_5 = Instance.new("TextLabel")
local HTC = Instance.new("ImageButton")
local TextLabel_28 = Instance.new("TextLabel")
local Zaros = Instance.new("ImageButton")
local TextLabel_29 = Instance.new("TextLabel")
local Heaven = Instance.new("ImageButton")
local TextLabel_30 = Instance.new("TextLabel")
local Secreat = Instance.new("ImageButton")
local TextLabel_31 = Instance.new("TextLabel")
local Future = Instance.new("ImageButton")
local TextLabel_32 = Instance.new("TextLabel")
local Space = Instance.new("ImageButton")
local TextLabel_33 = Instance.new("TextLabel")
local Namek = Instance.new("ImageButton")
local TextLabel_34 = Instance.new("TextLabel")
local Earth = Instance.new("ImageButton")
local TextLabel_35 = Instance.new("TextLabel")
local Label_6 = Instance.new("TextLabel")
local Line_4 = Instance.new("Frame")
local Top_Tp = Instance.new("ImageButton")
local Top_Tp_2 = Instance.new("TextLabel")
local Broly_Tp = Instance.new("ImageButton")
local Broly_Tp_2 = Instance.new("TextLabel")
local Queue = Instance.new("ImageButton")
local Queue_2 = Instance.new("TextLabel")
local Frame_4 = Instance.new("ImageLabel")
local Beans = Instance.new("ImageButton")
local TextLabel_36 = Instance.new("TextLabel")
local Close_4 = Instance.new("ImageButton")
local Label_7 = Instance.new("TextLabel")
local Jars = Instance.new("ImageButton")
local TextLabel_37 = Instance.new("TextLabel")
local Label_8 = Instance.new("TextLabel")
local Line_5 = Instance.new("Frame")
local Frame_5 = Instance.new("ImageLabel")
local Yellow_J = Instance.new("ImageButton")
local TextLabel_38 = Instance.new("TextLabel")
local Blue_J = Instance.new("ImageButton")
local TextLabel_39 = Instance.new("TextLabel")
local Green_J = Instance.new("ImageButton")
local TextLabel_40 = Instance.new("TextLabel")
local Close_5 = Instance.new("ImageButton")
local Label_9 = Instance.new("TextLabel")
local Red_J = Instance.new("ImageButton")
local TextLabel_41 = Instance.new("TextLabel")
local Label_10 = Instance.new("TextLabel")
local Line_6 = Instance.new("Frame")
local Frame_6 = Instance.new("ImageLabel")
local Yellow_B = Instance.new("ImageButton")
local TextLabel_42 = Instance.new("TextLabel")
local Blue_B = Instance.new("ImageButton")
local TextLabel_43 = Instance.new("TextLabel")
local Green_B = Instance.new("ImageButton")
local TextLabel_44 = Instance.new("TextLabel")
local Close_6 = Instance.new("ImageButton")
local Label_11 = Instance.new("TextLabel")
local Red_B = Instance.new("ImageButton")
local TextLabel_45 = Instance.new("TextLabel")
local Label_12 = Instance.new("TextLabel")
local Line_7 = Instance.new("Frame")
local Frame = Instance.new("Frame")

-- Gui to Lua
-- Version: 3.2

-- Instances:

local LoadingScreen = Instance.new("ScreenGui")
local Background = Instance.new("ImageLabel")
local BackGround = Instance.new("Frame")
local Loading = Instance.new("Frame")
local Line = Instance.new("Frame")
local Skid_Hub_Home_Text = Instance.new("TextLabel")

--Properties:

LoadingScreen.Name = "LoadingScreen"
LoadingScreen.Parent = game.CoreGui
LoadingScreen.Enabled = false

Background.Name = "Background"
Background.Parent = LoadingScreen
Background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Background.BackgroundTransparency = 1.000
Background.Position = UDim2.new(0.409999996, 0, 0.409999996, 0)
Background.Size = UDim2.new(0.170000002, 0, 0.136878863, 0)
Background.Image = "rbxassetid://3570695787"
Background.ImageColor3 = Color3.fromRGB(31, 31, 31)
Background.ScaleType = Enum.ScaleType.Slice
Background.SliceCenter = Rect.new(100, 100, 100, 100)
Background.SliceScale = 0.040

BackGround.Name = "BackGround"
BackGround.Parent = Background
BackGround.AnchorPoint = Vector2.new(0.5, 0.800000012)
BackGround.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
BackGround.BorderColor3 = Color3.fromRGB(0, 0, 0)
BackGround.BorderSizePixel = 2
BackGround.Position = UDim2.new(0.495636344, 0, 0.567983806, 0)
BackGround.Size = UDim2.new(0.922908902, 0, 0.169134587, 0)

Loading.Name = "Loading"
Loading.Parent = BackGround
Loading.BackgroundColor3 = Color3.fromRGB(0,255,255)
Loading.BorderSizePixel = 0
Loading.Position = UDim2.new(0.00668030046, 0, 0, 0)
Loading.Size = UDim2.new(0.00387643534, 0, 0.977765739, 0)

Line.Name = "Line"
Line.Parent = Background
Line.BackgroundColor3 = Color3.fromRGB(0,255,255)
Line.Position = UDim2.new(0.0179640707, 0, 0.284130841, 0)
Line.Size = UDim2.new(0.949101806, 0, 0.00606060587, 0)

Skid_Hub_Home_Text.Name = "Kz - Safe (booster)"
Skid_Hub_Home_Text.Parent = Background
Skid_Hub_Home_Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Skid_Hub_Home_Text.BackgroundTransparency = 1.000
Skid_Hub_Home_Text.BorderSizePixel = 0
Skid_Hub_Home_Text.Position = UDim2.new(0.0179639626, 0, 0.0542453825, 0)
Skid_Hub_Home_Text.Size = UDim2.new(0.622522593, 0, 0.175757602, 0)
Skid_Hub_Home_Text.Font = Enum.Font.ArialBold
Skid_Hub_Home_Text.Text = "Kz - Safe (booster)"
Skid_Hub_Home_Text.TextColor3 = Color3.fromRGB(255, 255, 255)
Skid_Hub_Home_Text.TextScaled = true
Skid_Hub_Home_Text.TextSize = 14.000
Skid_Hub_Home_Text.TextStrokeTransparency = 0.100
Skid_Hub_Home_Text.TextWrapped = true
Skid_Hub_Home_Text.TextXAlignment = Enum.TextXAlignment.Left

-- Scripts:

local function RNIZMSG_fake_script() -- Loading.LocalScript 
	local script = Instance.new('LocalScript', Loading)
	
	--([Scripted by CiAxe
	--([Discord: CiAxe#4286
	--([Twitter: @axe_ci
	--([Roblox Profile: CiAxe
	--([Thank you!])
	
	
	local screen = math.random(1)
	
	if screen == 1 then
		print '1'
		script.Parent.Parent.Parent.Parent.Enabled = true
		wait()
		
		script.Parent:TweenSize(UDim2.new(.3, 1, 1), "Out", "Linear", 2, true)
		wait()
		script.Parent:TweenSize(UDim2.new(.5, 1, 1), "Out", "Linear", 1, true)
		wait()
		script.Parent:TweenSize(UDim2.new(1, 1, 1), "Out", "Linear", 1, true)
		
		
		wait(1)
		script.Parent.Parent.Parent.Parent.Enabled = false
		wait(1)
		script.Parent:TweenSize(UDim2.new(0, 0, 0), "Out", "Linear", 1, true)
		
	end
	
	if screen == 2 then
		print '2'
		script.Parent.Parent.Parent.Parent.Enabled = true
		wait(1)
		
		script.Parent:TweenSize(UDim2.new(.1, 1, 1), "Out", "Linear", 3, true)
		wait(1)
		script.Parent:TweenSize(UDim2.new(.4, 1, 1), "Out", "Linear", 2, true)
		wait(1)
		script.Parent:TweenSize(UDim2.new(.7, 1, 1), "Out", "Linear", 3, true)
		wait(1)
		script.Parent:TweenSize(UDim2.new(1, 1, 1), "Out", "Linear", 1, true)
		
		
		wait(1)
		script.Parent.Parent.Parent.Parent.Enabled = false
		wait(1)
		script.Parent:TweenSize(UDim2.new(0, 0, 0), "Out", "Linear", 1, true)
	end
	if screen == 3 then
		print '3'
		script.Parent.Parent.Parent.Parent.Enabled = true
		wait(1)
		
		script.Parent:TweenSize(UDim2.new(.6, 1, 1), "Out", "Linear", 2, true)
		wait(1)
		script.Parent:TweenSize(UDim2.new(.8, 1, 1), "Out", "Linear", 3, true)
		wait(1)
		script.Parent:TweenSize(UDim2.new(1, 1, 1), "Out", "Linear", 1, true)
		
		
		wait(1)
		script.Parent.Parent.Parent.Parent.Enabled = false
		wait(1)
		script.Parent:TweenSize(UDim2.new(0, 0, 0), "Out", "Linear", 1, true)
	end
	
	script.Parent.Parent.Parent.Visible = false
end
coroutine.wrap(RNIZMSG_fake_script)()
wait(1,5)

SkidHub.Name = "KZ Home"
SkidHub.Parent = game.CoreGui
game.StarterGui:SetCore("SendNotification", {
Title = "By Kuzo And Kuze";
Text = "Press Right (ctrl) To Toggle",
Icon = "rbxassetid://5472203252";
Duration = 4;
})
game.StarterGui:SetCore("SendNotification", {
Title = "KZ Hub";
Text = "Enjoy X3",
Icon = "rbxassetid://5472203252";
Duration = 3;
})
SkidHub_Home.Name = "KuzoHub"
SkidHub_Home.Parent = SkidHub
SkidHub_Home.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SkidHub_Home.BackgroundTransparency = 1.000
SkidHub_Home.Position = UDim2.new(0.409999996, 0, 0.409999996, 0)
SkidHub_Home.Size = UDim2.new(0.169555798, 0, 0.179671451, 0)
SkidHub_Home.Image = "rbxassetid://3570695787"
SkidHub_Home.ScaleType = Enum.ScaleType.Slice
SkidHub_Home.SliceCenter = Rect.new(100, 100, 100, 100)
SkidHub_Home.SliceScale = 0.080
SkidHub_Home.Active = true
SkidHub_Home.Draggable = true

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(137, 0, 254)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(223, 0, 255))}
UIGradient.Parent = SkidHub_Home

OpenTab.Name = "OpenTab"
OpenTab.Parent = SkidHub_Home
OpenTab.BackgroundTransparency = 1.000
OpenTab.Position = UDim2.new(0.90139848, 0, 0.104242474, 0)
OpenTab.Size = UDim2.new(0.0688622817, 0, 0.112700336, 0)
OpenTab.ZIndex = 2
OpenTab.Image = "rbxassetid://3926305904"
OpenTab.ImageRectOffset = Vector2.new(484, 964)
OpenTab.ImageRectSize = Vector2.new(36, 36)

Skid_Hub_Home.Name = "KuzoHub"
Skid_Hub_Home.Parent = SkidHub_Home
Skid_Hub_Home.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Skid_Hub_Home.BackgroundTransparency = 1.000
Skid_Hub_Home.Position = UDim2.new(0, 0, 0.0799999982, 0)
Skid_Hub_Home.Size = UDim2.new(1, 0, 0.942857206, 0)
Skid_Hub_Home.Image = "rbxassetid://3570695787"
Skid_Hub_Home.ImageColor3 = Color3.fromRGB(35, 35, 35)
Skid_Hub_Home.ScaleType = Enum.ScaleType.Slice
Skid_Hub_Home.SliceCenter = Rect.new(100, 100, 100, 100)
Skid_Hub_Home.SliceScale = 0.080

NoSlowdown.Name = "NoSlowdown"
NoSlowdown.Parent = Skid_Hub_Home
NoSlowdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoSlowdown.Position = UDim2.new(0.412140578, 0, 0.393752187, 0)
NoSlowdown.Size = UDim2.new(0.55138582, 0, 0.182126835, 0)
NoSlowdown.Style = Enum.ButtonStyle.RobloxButtonDefault
NoSlowdown.Font = Enum.Font.ArialBold
NoSlowdown.Text = " NoSlowdown"
NoSlowdown.TextColor3 = Color3.fromRGB(255, 255, 255)
NoSlowdown.TextSize = 14.000
NoSlowdown.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "No Slowdown";
		Text = "UPDATE NOSLOW 3.1";
	})
	
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "No-Slow";
        Text = "Press [ to enable.";
        })

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Thank You For Using This Script!";
	Text = "Created by: kuzo!";
})

noslow = true
slow = false

local mouse = game.Players.LocalPlayer:GetMouse()
mouse.KeyDown:connect(function(key)
if key == "[" then
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "No-Slow Enabled";
        Text = "Press - to disable.";
        })
_G.Skiznillett = noslow
elseif key == "-" then
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "No-Slow Disabled";
        Text = "Press [ to enable.";
        })
_G.Skiznillett = slow
end
end)

_G.Skiznillett = false

while wait() do
	if _G.Skiznillett == true then
		for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
	        if v.Name == "Justice Combination" then
	            local action = game.Players.LocalPlayer.Character:WaitForChild("Action")
	            if action then wait() action:Destroy() end end
	        if v.Name == "Attacking" then
	    		v:Destroy()
	        end
	        if v.Name == "Action" then
	            v:Destroy()
	        end
	        if v.Name == "Killed" then
	            v:Destroy()
	        end
            if v.Name == "ForceField" then --d
                v:Destroy()
            end
            if v.Name == "Slow" then  --d
                v:Destroy()
            end
            if v.Name == "Dodging" then --d
                v:Destroy()
            end
            if v.Name == "SuperAction" then --d
                v:Destroy()
            end
			if v.Name == "Block" and v.Value == true then
				v.Value = false
			end
		end
    end
end
end)
BetterSpeed.Name = "BetterSpeed"
BetterSpeed.Parent = Skid_Hub_Home
BetterSpeed.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BetterSpeed.Position = UDim2.new(0.412140578, 0, 0.206060588, 0)
BetterSpeed.Size = UDim2.new(0.551730514, 0, 0.181675434, 0)
BetterSpeed.Style = Enum.ButtonStyle.RobloxButtonDefault
BetterSpeed.Font = Enum.Font.ArialBold
BetterSpeed.Text = "BetterSpeed"
BetterSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
BetterSpeed.TextSize = 14.000
BetterSpeed.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Better Speed";
		Text = "Q move, V to tp";
	})
	function setSpeed(walkspeedSet) ---- change set speed to whatever speed
		
		
		local plr = game:GetService"Players".LocalPlayer
		local serverTraits = plr.Backpack:WaitForChild'ServerTraits'
		
		for i,v in next, getconnections(serverTraits.Input.OnClientEvent) do
			local speed = (350*(walkspeedSet/44))-350
			v:Fire({speed})
			break
		end
	end
	setSpeed(2000)
	wait()
	plr = game.Players.LocalPlayer
	hum = plr.Character.HumanoidRootPart
	mouse = plr:GetMouse()
	
	mouse.KeyDown:connect(function(key)
		if key == "v" then
			if mouse.Target then
				game.Players.LocalPlayer.Backpack.ServerTraits.Vanish:FireServer()
				wait(.25)
				hum.CFrame = CFrame.new(mouse.Hit.x, mouse.Hit.y + 5, mouse.Hit.z)
				wait(.25)
			end
		end
	end)
	wait()
	down = false
	velocity = Instance.new("BodyVelocity")
	velocity.maxForce = Vector3.new(10000000, 0, 10000000)
	---vv Use that to change the speed v
	local speed    = 2500
	gyro           = Instance.new("BodyGyro")
	gyro.maxTorque = Vector3.new(10000000, 0, 10000000)
	
	local hum = game.Players.LocalPlayer.Character.Humanoid
	
	function onButton1Down(mouse)
		down = true
		velocity.Parent = game.Players.LocalPlayer.Character.UpperTorso
		velocity.velocity = (hum.MoveDirection) * speed
		gyro.Parent = game.Players.LocalPlayer.Character.UpperTorso
		while down do
			if not down then break end
			velocity.velocity = (hum.MoveDirection) * speed
			local refpos = gyro.Parent.Position + (gyro.Parent.Position - workspace.CurrentCamera.CoordinateFrame.p).unit * 5
			gyro.cframe = CFrame.new(gyro.Parent.Position, Vector3.new(refpos.x, gyro.Parent.Position.y, refpos.z))
			wait(0.1)
		end
	end
	
	function onButton1Up(mouse)
		velocity.Parent = nil
		gyro.Parent = nil
		down = false
	end
	--To Change the key in those 2 lines, replace the "v" with your desired key
	function onSelected(mouse)
		mouse.KeyDown:connect(function(k) if k:lower()=="q"then onButton1Down(mouse)end end)
		mouse.KeyUp:connect(function(k) if k:lower()=="q"then onButton1Up(mouse)end end)
	end
	
	onSelected(game.Players.LocalPlayer:GetMouse())
end)

Skid.Name = "Skid"
Skid.Parent = Skid_Hub_Home
Skid.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Skid.BackgroundTransparency = 1.000
Skid.BorderSizePixel = 0
Skid.Position = UDim2.new(-0.0607028753, 0, 0.205848441, 0)
Skid.Size = UDim2.new(0.5419541, 0, 0.551848888, 0)
Skid.Image = "rbxassetid://8433509"
Skid.ImageColor3 = Color3.fromRGB(91, 91, 91)

Skid_Hub_Home_Text.Name = "Skid_Hub_Home_Text"
Skid_Hub_Home_Text.Parent = Skid_Hub_Home
Skid_Hub_Home_Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Skid_Hub_Home_Text.BackgroundTransparency = 1.000
Skid_Hub_Home_Text.BorderSizePixel = 0
Skid_Hub_Home_Text.Position = UDim2.new(0.0179640725, 0, 0.0242424235, 0)
Skid_Hub_Home_Text.Size = UDim2.new(0.42814368, 0, 0.175757602, 0)
Skid_Hub_Home_Text.Font = Enum.Font.ArialBold
Skid_Hub_Home_Text.Text = "KZ"
Skid_Hub_Home_Text.TextColor3 = Color3.fromRGB(255, 255, 255)
Skid_Hub_Home_Text.TextScaled = true
Skid_Hub_Home_Text.TextSize = 14.000
Skid_Hub_Home_Text.TextStrokeTransparency = 0.100
Skid_Hub_Home_Text.TextWrapped = true
Skid_Hub_Home_Text.TextXAlignment = Enum.TextXAlignment.Left

Line.Name = "Line"
Line.Parent = Skid_Hub_Home
Line.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Line.Position = UDim2.new(0.0179640707, 0, 0.175757587, 0)
Line.Size = UDim2.new(0.949000001, 0, 0.00700000022, 0)

AutoBlock.Name = "AutoBlock"
AutoBlock.Parent = Skid_Hub_Home
AutoBlock.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AutoBlock.Position = UDim2.new(0.412140578, 0, 0.575570345, 0)
AutoBlock.Size = UDim2.new(0.55138582, 0, 0.182126835, 0)
AutoBlock.Style = Enum.ButtonStyle.RobloxButtonDefault
AutoBlock.Font = Enum.Font.ArialBold
AutoBlock.Text = "AutoBlock"
AutoBlock.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBlock.TextSize = 14.000
AutoBlock.MouseButton1Down:connect(function()
	if not game:IsLoaded() then
		local loadedcheck = Instance.new("Message",workspace)
		loadedcheck.Text = 'Loading..'
		game.Loaded:Wait()
		loadedcheck:Destroy()
	end
	wait(2)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Auto Block";
		Text = "Loaded..";
	})
	local A_1 = 
	{
		[1] = "blockon"
	}
	local A_2 = CFrame.new(-641.294189, 19.4875412, -2931.65332, -0.943309546, -0.221865401, 0.246866077, -0, 0.74376446, 0.668441772, -0.331914335, 0.630547523, -0.701600075)
	local A_3 = nil -- Path contained invalid instance
	local Event = game:GetService("Players")["LocalPlayer"].Backpack.ServerTraits.Input
	Event:FireServer(A_1, A_2, A_3)
	local lplr = game.Players.LocalPlayer
	local mouse = lplr:GetMouse()
	_G.on = false
	on = true
	off = false
	
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Auto Block";
		Text = "Press N To Enable And Disable.";
	})
	
	mouse.KeyDown:connect(function(key)
		if key == "n" then
			if _G.on == false then
				_G.on = on
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "Block Enabled";
					Text = "Press N To Disable.";
				})
				while _G.on == true do
					wait()
					Event:FireServer(A_1, A_2, A_3)
				end
			elseif _G.on == true then
				_G.on = off
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "Block Disabled";
					Text = "Press N To Enable.";
				})
			end
		end
	end)
	while wait() do
		for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
			if v.Name == "Justice Combination" then
				local action = game.Players.LocalPlayer.Character:WaitForChild("Action")
				if action then wait() action:Destroy() end end
			if v.Name == "Attacking" then
				v:Destroy()
			end
			if v.Name == "Action" then
				v:Destroy()
			end
			if v.Name == "Block" and v.Value == true then
				v.Value = false
			end
		end
	end
end)

Discord.Name = "Discord"
Discord.Parent = Skid_Hub_Home
Discord.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Discord.BorderColor3 = Color3.fromRGB(0, 255, 0)
Discord.Position = UDim2.new(0.0415335447, 0, 0.799999714, 0)
Discord.Size = UDim2.new(0.921992779, 0, 0.133333325, 0)
Discord.ClearTextOnFocus = false
Discord.Font = Enum.Font.SourceSans
Discord.Text = "Kuzo#2434 - Discord"
Discord.TextColor3 = Color3.fromRGB(0, 255, 0)
Discord.TextSize = 14.000

Frame_1.Name = "Frame_1"
Frame_1.Parent = SkidHub_Home
Frame_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_1.BackgroundTransparency = 1.000
Frame_1.Position = UDim2.new(0, 0, 0.0799999982, 0)
Frame_1.Size = UDim2.new(1, 0, 0.942857206, 0)
Frame_1.Visible = false
Frame_1.Image = "rbxassetid://3570695787"
Frame_1.ImageColor3 = Color3.fromRGB(35, 35, 35)
Frame_1.ScaleType = Enum.ScaleType.Slice
Frame_1.SliceCenter = Rect.new(100, 100, 100, 100)
Frame_1.SliceScale = 0.080

AntiQueue.Name = "AntiQueue"
AntiQueue.Parent = Frame_1
AntiQueue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AntiQueue.BackgroundTransparency = 1.000
AntiQueue.Position = UDim2.new(0.517204225, 0, 0.818181813, 0)
AntiQueue.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
AntiQueue.Image = "rbxassetid://2790382281"
AntiQueue.ImageColor3 = Color3.fromRGB(53, 53, 53)
AntiQueue.ScaleType = Enum.ScaleType.Slice
AntiQueue.SliceCenter = Rect.new(4, 4, 252, 252)
AntiQueue.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Anti Wormhole kick";
		Text = "Loaded..";
	})
	wait(1)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Anti Wormhole kick";
		Text = "Press ; To Use";
	})
	
	local plr = game:GetService("Players").LocalPlayer
	local mouse = plr:GetMouse()
	
	mouse.KeyDown:connect(function(key)
		if key == ";" then
			local plr = game.Players.LocalPlayer
			game.Workspace["Wormhole"].TouchInterest:Destroy()
		end
	end)
end)

AntiQueue_2.Name = "AntiQueue"
AntiQueue_2.Parent = AntiQueue
AntiQueue_2.AnchorPoint = Vector2.new(0.5, 0.5)
AntiQueue_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AntiQueue_2.BackgroundTransparency = 1.000
AntiQueue_2.BorderSizePixel = 0
AntiQueue_2.Position = UDim2.new(0.494866937, 0, 0.468793243, 0)
AntiQueue_2.Size = UDim2.new(1.0662359, -5, 1.1874187, -5)
AntiQueue_2.Font = Enum.Font.GothamSemibold
AntiQueue_2.Text = "Anti Queue"
AntiQueue_2.TextColor3 = Color3.fromRGB(0, 0, 0)
AntiQueue_2.TextScaled = true
AntiQueue_2.TextSize = 14.000
AntiQueue_2.TextWrapped = true

PlrStats.Name = "PlrStats"
PlrStats.Parent = Frame_1
PlrStats.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlrStats.BackgroundTransparency = 1.000
PlrStats.Position = UDim2.new(0.264808059, 0, 0.818181813, 0)
PlrStats.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
PlrStats.Image = "rbxassetid://2790382281"
PlrStats.ImageColor3 = Color3.fromRGB(53, 53, 53)
PlrStats.ScaleType = Enum.ScaleType.Slice
PlrStats.SliceCenter = Rect.new(4, 4, 252, 252)
PlrStats.MouseButton1Down:connect(function()
	--[_Stat_Checker_]--
	--[Version 2.4]--
	--[By: helpguestslikeme]--
	--{NOTE: You don't have to type the full user, and it isn't case sensitive.}--
	
	_G.stats = "" --Type the username of the player you want to check stats of in here.
	
	for i,v in pairs(game.Players:GetChildren()) do
		if v and v.Name ~= game.Players.LocalPlayer.Name and not game.Players:GetPlayerFromCharacter(v) and string.match(string.lower(v.Name), string.lower(_G.stats)) then
			local lvl = v.Character.Stats
			warn(v.Name)
			for i,f in pairs(v.Character:GetChildren()) do
				if string.find(tostring(f.Name):lower(), 'lvl.') then
					warn(f.Name)
				end
			end
			warn("Race:", lvl.Parent["Race"].Value)
			warn("Health Max:", lvl["Health-Max"].Value)
			warn("Ki Max:", lvl["Ki-Max"].Value)
			warn("Melee Damage:", lvl["Phys-Damage"].Value)
			warn("Ki-Damage:", lvl["Ki-Damage"].Value)
			warn("Melee Resistance:", lvl["Phys-Resist"].Value)
			warn("Ki Resistance:", lvl["Ki-Resist"].Value)
			warn("Speed:", lvl["Speed"].Value)
			warn("End of Stats.")
			warn("--------------------------------------------------")
		end
	end
	
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Stat Checker";
		Text = "Please press ctrl + f9 and scroll all the way down to view stats.";
	})
	
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Thank You For Using This Script!";
		Text = "Created by: Kuzo#2434 ";
	})
end)

TextLabel.Parent = PlrStats
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.518988848, 0, 0.46875, 0)
TextLabel.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel.Font = Enum.Font.GothamSemibold
TextLabel.Text = "Plr Stats"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

NoFace.Name = "No Face"
NoFace.Parent = Frame_1
NoFace.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoFace.BackgroundTransparency = 1.000
NoFace.Position = UDim2.new(0.0213598367, 0, 0.818181813, 0)
NoFace.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
NoFace.Image = "rbxassetid://2790382281"
NoFace.ImageColor3 = Color3.fromRGB(53, 53, 53)
NoFace.ScaleType = Enum.ScaleType.Slice
NoFace.SliceCenter = Rect.new(4, 4, 252, 252)
NoFace.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "No Face";
		Text = "Loaded..";
	})
	wait()
	local plr = game.Players.LocalPlayer
	game.Workspace.Live[plr.Name].Head["face"]:Destroy()
end)

NoFace_2.Name = "No Face"
NoFace_2.Parent = NoFace
NoFace_2.AnchorPoint = Vector2.new(0.5, 0.5)
NoFace_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoFace_2.BackgroundTransparency = 1.000
NoFace_2.BorderSizePixel = 0
NoFace_2.Position = UDim2.new(0.518813789, 0, 0.46875, 0)
NoFace_2.Size = UDim2.new(1.079, -5, 0.853999972, -5)
NoFace_2.Font = Enum.Font.GothamSemibold
NoFace_2.Text = "No Face"
NoFace_2.TextColor3 = Color3.fromRGB(0, 0, 0)
NoFace_2.TextScaled = true
NoFace_2.TextSize = 14.000
NoFace_2.TextWrapped = true

NoAura.Name = "No Aura"
NoAura.Parent = Frame_1
NoAura.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoAura.BackgroundTransparency = 1.000
NoAura.Position = UDim2.new(0.510814428, 0, 0.630303025, 0)
NoAura.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
NoAura.Image = "rbxassetid://2790382281"
NoAura.ImageColor3 = Color3.fromRGB(53, 53, 53)
NoAura.ScaleType = Enum.ScaleType.Slice
NoAura.SliceCenter = Rect.new(4, 4, 252, 252)
NoAura.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "No Aura";
		Text = "Loaded..";
	})
	wait()
	local plr = game.Players.LocalPlayer
	game.Workspace.Live[plr.Name].HumanoidRootPart["TempAura"]:Destroy()
	wait()
	local plr = game.Players.LocalPlayer
	game.Workspace.Live[plr.Name].HumanoidRootPart["Lightning"]:Destroy()
end)

NoAura_2.Name = "No Aura"
NoAura_2.Parent = NoAura
NoAura_2.AnchorPoint = Vector2.new(0.5, 0.5)
NoAura_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoAura_2.BackgroundTransparency = 1.000
NoAura_2.BorderSizePixel = 0
NoAura_2.Position = UDim2.new(0.518988848, 0, 0.46875, 0)
NoAura_2.Size = UDim2.new(1.079, -5, 0.853999972, -5)
NoAura_2.Font = Enum.Font.GothamSemibold
NoAura_2.Text = "No Aura"
NoAura_2.TextColor3 = Color3.fromRGB(0, 0, 0)
NoAura_2.TextScaled = true
NoAura_2.TextSize = 14.000
NoAura_2.TextWrapped = true

FastHTC.Name = "FastHTC"
FastHTC.Parent = Frame_1
FastHTC.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FastHTC.BackgroundTransparency = 1.000
FastHTC.Position = UDim2.new(0.258418292, 0, 0.630303025, 0)
FastHTC.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
FastHTC.Image = "rbxassetid://2790382281"
FastHTC.ImageColor3 = Color3.fromRGB(53, 53, 53)
FastHTC.ScaleType = Enum.ScaleType.Slice
FastHTC.SliceCenter = Rect.new(4, 4, 252, 252)
FastHTC.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Fast HTC";
		Text = "Loaded..";
	})
	
	_G.Beans = false
	
	local SynapseXen_IlIlii=select;local SynapseXen_iIiiliiIIl=string.byte;local SynapseXen_liiliiIIiIIIIiliIll=string.sub;local SynapseXen_illlIl=string.char;local SynapseXen_ilIII=type;local SynapseXen_iilil=table.concat;local unpack=unpack;local setmetatable=setmetatable;local pcall=pcall;local SynapseXen_lIliililllIlillIliI,SynapseXen_IlIIiI,SynapseXen_iIllili,SynapseXen_liliilIl;if bit and bit.bxor then SynapseXen_lIliililllIlillIliI=bit.bxor;SynapseXen_IlIIiI=function(SynapseXen_iillIiIli,SynapseXen_iIIlIIIlIilI)local SynapseXen_iliIllIlI=SynapseXen_lIliililllIlillIliI(SynapseXen_iillIiIli,SynapseXen_iIIlIIIlIilI)if SynapseXen_iliIllIlI<0 then SynapseXen_iliIllIlI=4294967296+SynapseXen_iliIllIlI end;return SynapseXen_iliIllIlI end else SynapseXen_lIliililllIlillIliI=function(SynapseXen_iillIiIli,SynapseXen_iIIlIIIlIilI)local SynapseXen_IiiillIIlililllIillI=function(SynapseXen_iiilIilIillilIlIi,SynapseXen_IiiiiIIllliiI)return SynapseXen_iiilIilIillilIlIi%(SynapseXen_IiiiiIIllliiI*2)>=SynapseXen_IiiiiIIllliiI end;local SynapseXen_iiIllilIlIlIliiIIili=0;for SynapseXen_lllliiiiiilIiIi=0,31 do SynapseXen_iiIllilIlIlIliiIIili=SynapseXen_iiIllilIlIlIliiIIili+(SynapseXen_IiiillIIlililllIillI(SynapseXen_iillIiIli,2^SynapseXen_lllliiiiiilIiIi)~=SynapseXen_IiiillIIlililllIillI(SynapseXen_iIIlIIIlIilI,2^SynapseXen_lllliiiiiilIiIi)and 2^SynapseXen_lllliiiiiilIiIi or 0)end;return SynapseXen_iiIllilIlIlIliiIIili end;SynapseXen_IlIIiI=SynapseXen_lIliililllIlillIliI end;SynapseXen_iIllili=function(SynapseXen_liIllIlIiiIIiI,SynapseXen_IiiililIiiililIi,SynapseXen_IlIIlIIIliIIiillliil)return(SynapseXen_liIllIlIiiIIiI+SynapseXen_IiiililIiiililIi)%SynapseXen_IlIIlIIIliIIiillliil end;SynapseXen_liliilIl=function(SynapseXen_liIllIlIiiIIiI,SynapseXen_IiiililIiiililIi,SynapseXen_IlIIlIIIliIIiillliil)return(SynapseXen_liIllIlIiiIIiI-SynapseXen_IiiililIiiililIi)%SynapseXen_IlIIlIIIliIIiillliil end;local function SynapseXen_lIiIIilIl(SynapseXen_iliIllIlI)if SynapseXen_iliIllIlI<0 then SynapseXen_iliIllIlI=4294967296+SynapseXen_iliIllIlI end;return SynapseXen_iliIllIlI end;local getfenv=getfenv;if not getfenv then getfenv=function()return _ENV end end;local SynapseXen_ilIliIIliIlI={}local SynapseXen_ilIilIiIlIiIIillIi={}local SynapseXen_lIIIlIIIiIiIIIiillII;local SynapseXen_lliilli;local SynapseXen_IlIii={}local SynapseXen_lllIIllIiIllI={}for SynapseXen_lllliiiiiilIiIi=0,255 do local SynapseXen_lIIIIliiiiiI,SynapseXen_iiiIIIII=SynapseXen_illlIl(SynapseXen_lllliiiiiilIiIi),SynapseXen_illlIl(SynapseXen_lllliiiiiilIiIi,0)SynapseXen_IlIii[SynapseXen_lIIIIliiiiiI]=SynapseXen_iiiIIIII;SynapseXen_lllIIllIiIllI[SynapseXen_iiiIIIII]=SynapseXen_lIIIIliiiiiI end;local function SynapseXen_iIIiIliiI(SynapseXen_llIiIIiilIll,SynapseXen_IlilI,SynapseXen_iiliiliIliiiilillI,SynapseXen_iiiiiiIlIl)if SynapseXen_iiliiliIliiiilillI>=256 then SynapseXen_iiliiliIliiiilillI,SynapseXen_iiiiiiIlIl=0,SynapseXen_iiiiiiIlIl+1;if SynapseXen_iiiiiiIlIl>=256 then SynapseXen_IlilI={}SynapseXen_iiiiiiIlIl=1 end end;SynapseXen_IlilI[SynapseXen_illlIl(SynapseXen_iiliiliIliiiilillI,SynapseXen_iiiiiiIlIl)]=SynapseXen_llIiIIiilIll;SynapseXen_iiliiliIliiiilillI=SynapseXen_iiliiliIliiiilillI+1;return SynapseXen_IlilI,SynapseXen_iiliiliIliiiilillI,SynapseXen_iiiiiiIlIl end;local function SynapseXen_lIiiIIliIi(SynapseXen_IilIiiliIllii)local function SynapseXen_iillii(SynapseXen_IIliIlIll)local SynapseXen_iiiiiiIlIl='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'SynapseXen_IIliIlIll=string.gsub(SynapseXen_IIliIlIll,'[^'..SynapseXen_iiiiiiIlIl..'=]','')return SynapseXen_IIliIlIll:gsub('.',function(SynapseXen_liIllIlIiiIIiI)if SynapseXen_liIllIlIiiIIiI=='='then return''end;local SynapseXen_IlliIIiii,SynapseXen_IIilliilIIi='',SynapseXen_iiiiiiIlIl:find(SynapseXen_liIllIlIiiIIiI)-1;for SynapseXen_lllliiiiiilIiIi=6,1,-1 do SynapseXen_IlliIIiii=SynapseXen_IlliIIiii..(SynapseXen_IIilliilIIi%2^SynapseXen_lllliiiiiilIiIi-SynapseXen_IIilliilIIi%2^(SynapseXen_lllliiiiiilIiIi-1)>0 and'1'or'0')end;return SynapseXen_IlliIIiii end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(SynapseXen_liIllIlIiiIIiI)if#SynapseXen_liIllIlIiiIIiI~=8 then return''end;local SynapseXen_liiIIli=0;for SynapseXen_lllliiiiiilIiIi=1,8 do SynapseXen_liiIIli=SynapseXen_liiIIli+(SynapseXen_liIllIlIiiIIiI:sub(SynapseXen_lllliiiiiilIiIi,SynapseXen_lllliiiiiilIiIi)=='1'and 2^(8-SynapseXen_lllliiiiiilIiIi)or 0)end;return string.char(SynapseXen_liiIIli)end)end;SynapseXen_IilIiiliIllii=SynapseXen_iillii(SynapseXen_IilIiiliIllii)local SynapseXen_IlIIlI=SynapseXen_liiliiIIiIIIIiliIll(SynapseXen_IilIiiliIllii,1,1)if SynapseXen_IlIIlI=="u"then return SynapseXen_liiliiIIiIIIIiliIll(SynapseXen_IilIiiliIllii,2)elseif SynapseXen_IlIIlI~="c"then error("Synapse Xen - Failed to verify bytecode. Please make sure your Lua implementation supports non-null terminated strings.")end;SynapseXen_IilIiiliIllii=SynapseXen_liiliiIIiIIIIiliIll(SynapseXen_IilIiiliIllii,2)local SynapseXen_IIlIlilIIIIlIili=#SynapseXen_IilIiiliIllii;local SynapseXen_IlilI={}local SynapseXen_iiliiliIliiiilillI,SynapseXen_iiiiiiIlIl=0,1;local SynapseXen_lilil={}local SynapseXen_iliIllIlI=1;local SynapseXen_lIIlI=SynapseXen_liiliiIIiIIIIiliIll(SynapseXen_IilIiiliIllii,1,2)SynapseXen_lilil[SynapseXen_iliIllIlI]=SynapseXen_lllIIllIiIllI[SynapseXen_lIIlI]or SynapseXen_IlilI[SynapseXen_lIIlI]SynapseXen_iliIllIlI=SynapseXen_iliIllIlI+1;for SynapseXen_lllliiiiiilIiIi=3,SynapseXen_IIlIlilIIIIlIili,2 do local SynapseXen_IIiilIlIllI=SynapseXen_liiliiIIiIIIIiliIll(SynapseXen_IilIiiliIllii,SynapseXen_lllliiiiiilIiIi,SynapseXen_lllliiiiiilIiIi+1)local SynapseXen_lIilIiilIIIliIliIiIi=SynapseXen_lllIIllIiIllI[SynapseXen_lIIlI]or SynapseXen_IlilI[SynapseXen_lIIlI]if not SynapseXen_lIilIiilIIIliIliIiIi then error("Synapse Xen - Failed to verify bytecode. Please make sure your Lua implementation supports non-null terminated strings.")end;local SynapseXen_IilIliIIillIliI=SynapseXen_lllIIllIiIllI[SynapseXen_IIiilIlIllI]or SynapseXen_IlilI[SynapseXen_IIiilIlIllI]if SynapseXen_IilIliIIillIliI then SynapseXen_lilil[SynapseXen_iliIllIlI]=SynapseXen_IilIliIIillIliI;SynapseXen_iliIllIlI=SynapseXen_iliIllIlI+1;SynapseXen_IlilI,SynapseXen_iiliiliIliiiilillI,SynapseXen_iiiiiiIlIl=SynapseXen_iIIiIliiI(SynapseXen_lIilIiilIIIliIliIiIi..SynapseXen_liiliiIIiIIIIiliIll(SynapseXen_IilIliIIillIliI,1,1),SynapseXen_IlilI,SynapseXen_iiliiliIliiiilillI,SynapseXen_iiiiiiIlIl)else local SynapseXen_lIiIiIl=SynapseXen_lIilIiilIIIliIliIiIi..SynapseXen_liiliiIIiIIIIiliIll(SynapseXen_lIilIiilIIIliIliIiIi,1,1)SynapseXen_lilil[SynapseXen_iliIllIlI]=SynapseXen_lIiIiIl;SynapseXen_iliIllIlI=SynapseXen_iliIllIlI+1;SynapseXen_IlilI,SynapseXen_iiliiliIliiiilillI,SynapseXen_iiiiiiIlIl=SynapseXen_iIIiIliiI(SynapseXen_lIiIiIl,SynapseXen_IlilI,SynapseXen_iiliiliIliiiilillI,SynapseXen_iiiiiiIlIl)end;SynapseXen_lIIlI=SynapseXen_IIiilIlIllI end;return SynapseXen_iilil(SynapseXen_lilil)end;local function SynapseXen_IliiIiIlIIII(SynapseXen_iiiIl,SynapseXen_IiliIl,SynapseXen_iIliliiiIIiliiil)if SynapseXen_iIliliiiIIiliiil then local SynapseXen_IIliiIllIilIii=SynapseXen_iiiIl/2^(SynapseXen_IiliIl-1)%2^(SynapseXen_iIliliiiIIiliiil-1-(SynapseXen_IiliIl-1)+1)return SynapseXen_IIliiIllIilIii-SynapseXen_IIliiIllIilIii%1 else local SynapseXen_IIill=2^(SynapseXen_IiliIl-1)if SynapseXen_iiiIl%(SynapseXen_IIill+SynapseXen_IIill)>=SynapseXen_IIill then return 1 else return 0 end end end;local function SynapseXen_IlIilIIillliliii()local SynapseXen_lIiIiiIliilil=SynapseXen_lIliililllIlillIliI(2822842491,SynapseXen_ilIilIiIlIiIIillIi[5])while true do if SynapseXen_lIiIiiIliilil==SynapseXen_lIliililllIlillIliI(310499694,SynapseXen_ilIilIiIlIiIIillIi[2])then SynapseXen_lIIIlIIIiIiIIIiillII=function(SynapseXen_iilllilIiIl,SynapseXen_IlIlI)return SynapseXen_lIliililllIlillIliI(SynapseXen_iilllilIiIl+2261,SynapseXen_IlIlI+29574)-SynapseXen_lIliililllIlillIliI(2802584148,SynapseXen_ilIilIiIlIiIIillIi[6])end;SynapseXen_lIiIiiIliilil=SynapseXen_lIiIiiIliilil+SynapseXen_lIliililllIlillIliI(3102268582,SynapseXen_ilIilIiIlIiIIillIi[4])elseif SynapseXen_lIiIiiIliilil==SynapseXen_lIliililllIlillIliI(655955599,SynapseXen_lliilli)then SynapseXen_lIIIlIIIiIiIIIiillII=function(SynapseXen_iilllilIiIl,SynapseXen_IlIlI)return SynapseXen_lIliililllIlillIliI(SynapseXen_iilllilIiIl+41895,SynapseXen_IlIlI-31994)+SynapseXen_lIliililllIlillIliI(2319653578,SynapseXen_ilIilIiIlIiIIillIi[5])end;SynapseXen_lIiIiiIliilil=SynapseXen_lIiIiiIliilil+SynapseXen_lIliililllIlillIliI(2802605328,SynapseXen_ilIilIiIlIiIIillIi[6])elseif SynapseXen_lIiIiiIliilil==SynapseXen_lIliililllIlillIliI(655977203,SynapseXen_lliilli)then return elseif SynapseXen_lIiIiiIliilil==SynapseXen_lIliililllIlillIliI(2599068014,SynapseXen_ilIilIiIlIiIIillIi[4])then SynapseXen_lIIIlIIIiIiIIIiillII=function(SynapseXen_iilllilIiIl,SynapseXen_IlIlI)return SynapseXen_lIliililllIlillIliI(SynapseXen_iilllilIiIl+157,SynapseXen_IlIlI-39982)-SynapseXen_lIliililllIlillIliI(3736170173,SynapseXen_lliilli)end;SynapseXen_lIiIiiIliilil=SynapseXen_lIliililllIlillIliI(SynapseXen_lIiIiiIliilil,SynapseXen_lIliililllIlillIliI(3734046441,SynapseXen_ilIilIiIlIiIIillIi[3]))elseif SynapseXen_lIiIiiIliilil==SynapseXen_lIliililllIlillIliI(655801249,SynapseXen_lliilli)then SynapseXen_lIIIlIIIiIiIIIiillII=function(SynapseXen_iilllilIiIl,SynapseXen_IlIlI)return SynapseXen_lIliililllIlillIliI(SynapseXen_iilllilIiIl+10531,SynapseXen_IlIlI-22017)+SynapseXen_lIliililllIlillIliI(3104570302,SynapseXen_ilIilIiIlIiIIillIi[1])end;SynapseXen_lIiIiiIliilil=SynapseXen_lIiIiiIliilil+SynapseXen_lIliililllIlillIliI(3102257029,SynapseXen_ilIilIiIlIiIIillIi[4])elseif SynapseXen_lIiIiiIliilil==SynapseXen_lIliililllIlillIliI(1944853361,SynapseXen_lliilli)then SynapseXen_lIIIlIIIiIiIIIiillII=function(SynapseXen_iilllilIiIl,SynapseXen_IlIlI)return SynapseXen_lIliililllIlillIliI(SynapseXen_iilllilIiIl-24185,SynapseXen_IlIlI+27099)-SynapseXen_lIliililllIlillIliI(3736145493,SynapseXen_lliilli)end;SynapseXen_lIiIiiIliilil=SynapseXen_lIliililllIlillIliI(SynapseXen_lIiIiiIliilil,SynapseXen_lIliililllIlillIliI(2320187684,SynapseXen_lliilli))elseif SynapseXen_lIiIiiIliilil==SynapseXen_lIliililllIlillIliI(1944896337,SynapseXen_lliilli)then SynapseXen_lIIIlIIIiIiIIIiillII=function(SynapseXen_iilllilIiIl,SynapseXen_IlIlI)return SynapseXen_lIliililllIlillIliI(SynapseXen_iilllilIiIl+7696,SynapseXen_IlIlI+36159)+SynapseXen_lIliililllIlillIliI(1372472636,SynapseXen_ilIilIiIlIiIIillIi[3])end;SynapseXen_lIiIiiIliilil=SynapseXen_lIiIiiIliilil-SynapseXen_lIliililllIlillIliI(3736162603,SynapseXen_lliilli)elseif SynapseXen_lIiIiiIliilil==SynapseXen_lIliililllIlillIliI(1944903213,SynapseXen_lliilli)then SynapseXen_lIIIlIIIiIiIIIiillII=function(SynapseXen_iilllilIiIl,SynapseXen_IlIlI)return SynapseXen_lIliililllIlillIliI(SynapseXen_iilllilIiIl-2853,SynapseXen_IlIlI+6916)-SynapseXen_lIliililllIlillIliI(2319710036,SynapseXen_ilIilIiIlIiIIillIi[5])end;SynapseXen_lIiIiiIliilil=SynapseXen_lIiIiiIliilil-SynapseXen_lIliililllIlillIliI(3736146859,SynapseXen_lliilli)elseif SynapseXen_lIiIiiIliilil==SynapseXen_lIliililllIlillIliI(655777146,SynapseXen_lliilli)then SynapseXen_lIIIlIIIiIiIIIiillII=function(SynapseXen_iilllilIiIl,SynapseXen_IlIlI)return SynapseXen_lIliililllIlillIliI(SynapseXen_iilllilIiIl-26167,SynapseXen_IlIlI-20776)-SynapseXen_lIliililllIlillIliI(2802582250,SynapseXen_ilIilIiIlIiIIillIi[6])end;SynapseXen_lIiIiiIliilil=SynapseXen_lIiIiiIliilil+SynapseXen_lIliililllIlillIliI(3736156967,SynapseXen_lliilli)elseif SynapseXen_lIiIiiIliilil==SynapseXen_lIliililllIlillIliI(1944886157,SynapseXen_lliilli)then SynapseXen_lIIIlIIIiIiIIIiillII=function(SynapseXen_iilllilIiIl,SynapseXen_IlIlI)return SynapseXen_lIliililllIlillIliI(SynapseXen_iilllilIiIl-5846,SynapseXen_IlIlI+42802)+SynapseXen_lIliililllIlillIliI(3736170597,SynapseXen_lliilli)end;SynapseXen_lIiIiiIliilil=SynapseXen_lIiIiiIliilil+SynapseXen_lIliililllIlillIliI(3945165651,SynapseXen_ilIilIiIlIiIIillIi[2])elseif SynapseXen_lIiIiiIliilil==SynapseXen_lIliililllIlillIliI(1944873301,SynapseXen_lliilli)then SynapseXen_lIIIlIIIiIiIIIiillII=function(SynapseXen_iilllilIiIl,SynapseXen_IlIlI)return SynapseXen_lIliililllIlillIliI(SynapseXen_iilllilIiIl+8530,SynapseXen_IlIlI-45904)+SynapseXen_lIliililllIlillIliI(3736180237,SynapseXen_lliilli)end;SynapseXen_lIiIiiIliilil=SynapseXen_lIiIiiIliilil-SynapseXen_lIliililllIlillIliI(3736163635,SynapseXen_lliilli)end end end;local function SynapseXen_iIIili(SynapseXen_ilIlIlilIIIil)local SynapseXen_IllliIliiIlIliIllll=1;local SynapseXen_IiIiIlllIiiIlliiIli;local SynapseXen_IIIIi;local function SynapseXen_iiIiI()local SynapseXen_lIIlliIiliiIIliilii=SynapseXen_iIiiliiIIl(SynapseXen_ilIlIlilIIIil,SynapseXen_IllliIliiIlIliIllll,SynapseXen_IllliIliiIlIliIllll)SynapseXen_IllliIliiIlIliIllll=SynapseXen_IllliIliiIlIliIllll+1;return SynapseXen_lIIlliIiliiIIliilii end;local function SynapseXen_iIiIIi()local SynapseXen_liIlliIiIlilliIliil,SynapseXen_iilllilIiIl,SynapseXen_IlIlI,SynapseXen_IilliIi=SynapseXen_iIiiliiIIl(SynapseXen_ilIlIlilIIIil,SynapseXen_IllliIliiIlIliIllll,SynapseXen_IllliIliiIlIliIllll+3)SynapseXen_IllliIliiIlIliIllll=SynapseXen_IllliIliiIlIliIllll+4;return SynapseXen_IilliIi*16777216+SynapseXen_IlIlI*65536+SynapseXen_iilllilIiIl*256+SynapseXen_liIlliIiIlilliIliil end;local function SynapseXen_liilIiili()return SynapseXen_iIiIIi()*4294967296+SynapseXen_iIiIIi()end;local function SynapseXen_IiiIIllililiil()local SynapseXen_IlIIllIiI=SynapseXen_IlIIiI(SynapseXen_iIiIIi(),SynapseXen_ilIliIIliIlI[2605870570]or(function()local SynapseXen_liIllIlIiiIIiI="level 1 crook = luraph, level 100 boss = xen"SynapseXen_ilIliIIliIlI[2605870570]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2809306397,1863434755),SynapseXen_lIliililllIlillIliI(2866207826,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{896469870,3676167197,3613993654,1380661340,3098023518,3922638148}return SynapseXen_ilIliIIliIlI[2605870570]end)())local SynapseXen_IiiIIliIlIiIIli=SynapseXen_IlIIiI(SynapseXen_iIiIIi(),SynapseXen_ilIliIIliIlI[909916017]or(function()local SynapseXen_liIllIlIiiIIiI="hi devforum"SynapseXen_ilIliIIliIlI[909916017]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2317766518,1415284027),SynapseXen_lIliililllIlillIliI(990579143,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1912876543,1920519101,867594302,2932513958,199504591,1761364979,1205512943,485822688}return SynapseXen_ilIliIIliIlI[909916017]end)())local SynapseXen_iIlIiI=1;local SynapseXen_iIillIllIlIlII=SynapseXen_IliiIiIlIIII(SynapseXen_IiiIIliIlIiIIli,1,20)*2^32+SynapseXen_IlIIllIiI;local SynapseXen_liiliilllliIIilIiil=SynapseXen_IliiIiIlIIII(SynapseXen_IiiIIliIlIiIIli,21,31)local SynapseXen_iiiIiIliliiI=(-1)^SynapseXen_IliiIiIlIIII(SynapseXen_IiiIIliIlIiIIli,32)if SynapseXen_liiliilllliIIilIiil==0 then if SynapseXen_iIillIllIlIlII==0 then return SynapseXen_iiiIiIliliiI*0 else SynapseXen_liiliilllliIIilIiil=1;SynapseXen_iIlIiI=0 end elseif SynapseXen_liiliilllliIIilIiil==2047 then if SynapseXen_iIillIllIlIlII==0 then return SynapseXen_iiiIiIliliiI*1/0 else return SynapseXen_iiiIiIliliiI*0/0 end end;return math.ldexp(SynapseXen_iiiIiIliliiI,SynapseXen_liiliilllliIIilIiil-1023)*(SynapseXen_iIlIiI+SynapseXen_iIillIllIlIlII/2^52)end;local function SynapseXen_IiIiIl(SynapseXen_IlIilI)local SynapseXen_iIllliiliIii;if SynapseXen_IlIilI then SynapseXen_iIllliiliIii=SynapseXen_liiliiIIiIIIIiliIll(SynapseXen_ilIlIlilIIIil,SynapseXen_IllliIliiIlIliIllll,SynapseXen_IllliIliiIlIliIllll+SynapseXen_IlIilI-1)SynapseXen_IllliIliiIlIliIllll=SynapseXen_IllliIliiIlIliIllll+SynapseXen_IlIilI else SynapseXen_IlIilI=SynapseXen_IiIiIlllIiiIlliiIli()if SynapseXen_IlIilI==0 then return""end;SynapseXen_iIllliiliIii=SynapseXen_liiliiIIiIIIIiliIll(SynapseXen_ilIlIlilIIIil,SynapseXen_IllliIliiIlIliIllll,SynapseXen_IllliIliiIlIliIllll+SynapseXen_IlIilI-1)SynapseXen_IllliIliiIlIliIllll=SynapseXen_IllliIliiIlIliIllll+SynapseXen_IlIilI end;return SynapseXen_iIllliiliIii end;local function SynapseXen_IIlIllIiIlIlliIIlii(SynapseXen_iIllliiliIii)local SynapseXen_IIliiIllIilIii={}for SynapseXen_lllliiiiiilIiIi=1,#SynapseXen_iIllliiliIii do local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iIllliiliIii:sub(SynapseXen_lllliiiiiilIiIi,SynapseXen_lllliiiiiilIiIi)SynapseXen_IIliiIllIilIii[#SynapseXen_IIliiIllIilIii+1]=string.char(SynapseXen_lIliililllIlillIliI(string.byte(SynapseXen_iiliIiiiiIlIIiIiIlli),SynapseXen_ilIliIIliIlI[2607236912]or(function(...)local SynapseXen_liIllIlIiiIIiI="this is a christian obfuscator, no cursing allowed in our scripts"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3716512147,3489423565)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(903247147,3391696875)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2607236912]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3838094912,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(671831198,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{29919685,2650853166,2453204905,2915555890,152969735,499358715,848339935,1781878802,604523963}return SynapseXen_ilIliIIliIlI[2607236912]end)("iiilliii",6402,{},"lilIiliiiIliiIIl","IiiliIiiiillI",7063,"ilIilIiIiiIIIIil",{},14718)))end;return table.concat(SynapseXen_IIliiIllIilIii)end;local function SynapseXen_IIilIil()local SynapseXen_liIIiIiIlllIil={}local SynapseXen_iiIIIIliiI={}local SynapseXen_IlIiIlllllIliil={}local SynapseXen_IlliIllll={[SynapseXen_ilIliIIliIlI[1462546893]or(function(...)local SynapseXen_liIllIlIiiIIiI="can we have an f in chat for ripull"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2919163053,1435547314)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2001320581,2293655067)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1462546893]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(236605065,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(15570317,SynapseXen_ilIilIiIlIiIIillIi[1]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2264639732,317755800,1446073688,3481842811,229935147,1221643587,2118723162,2754452925,3453857863}return SynapseXen_ilIliIIliIlI[1462546893]end)(1864,{},{},"lIlIiIl","IiI")]=SynapseXen_IlIiIlllllIliil,[SynapseXen_ilIliIIliIlI[3548391233]or(function()local SynapseXen_liIllIlIiiIIiI="now comes with a free n word pass"SynapseXen_ilIliIIliIlI[3548391233]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2788933513,671476974),SynapseXen_lIliililllIlillIliI(493659865,SynapseXen_ilIilIiIlIiIIillIi[6]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{857071196,2384762982,2314582996,1044285425,3990714315}return SynapseXen_ilIliIIliIlI[3548391233]end)()]=SynapseXen_iiIIIIliiI,[SynapseXen_ilIliIIliIlI[3103792106]or(function(...)local SynapseXen_liIllIlIiiIIiI="double-header fair! this rationalization has a overenthusiastically anticheat! you will get nonpermissible for exploiting!"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2879469140,825572157)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(3899339315,395632399)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[3103792106]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3562214666,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2270907697,SynapseXen_ilIilIiIlIiIIillIi[7]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{4202984741,2484292256}return SynapseXen_ilIliIIliIlI[3103792106]end)(6817,{})]=SynapseXen_liIIiIiIlllIil}SynapseXen_iiIiI()for SynapseXen_IiiIi=1,SynapseXen_lIliililllIlillIliI(SynapseXen_IIIIi(),SynapseXen_ilIliIIliIlI[812313326]or(function(...)local SynapseXen_liIllIlIiiIIiI="now with shitty xor string obfuscation"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3160789161,1867049402)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(927605391,3367366686)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[812313326]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3668369487,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(819163056,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{622794954,114464845}return SynapseXen_ilIliIIliIlI[812313326]end)("iIiiiliI","lliiiiililiIiIllI","ll",{},"llIiliIiIiliiili",{},5267,{}))do local SynapseXen_ilIII=SynapseXen_iiIiI()SynapseXen_iIiIIi()local SynapseXen_IIiilIiIilliIiil;if SynapseXen_ilIII==(SynapseXen_ilIliIIliIlI[3522495478]or(function(...)local SynapseXen_liIllIlIiiIIiI="what are you trying to say? that fucking one dot + dot + dot + many dots is not adding adding 1 dot + dot and then adding all the dots together????"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(703563583,727097001)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(3356730854,938237891)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[3522495478]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2943082064,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(348502796,SynapseXen_ilIilIiIlIiIIillIi[1]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2333038560,2117921788,2408092608,404085380,1941406524,3568317737,1275768020,1127812991,27607839,164072614}return SynapseXen_ilIliIIliIlI[3522495478]end)("IIllilllIiIlIlIl",9953,"IiiliIIlIiIlIIlIII",{},"iiIll",1610,9269,"iilllIlIllllillllil",8079))then SynapseXen_IIiilIiIilliIiil=SynapseXen_iiIiI()~=0 elseif SynapseXen_ilIII==(SynapseXen_ilIliIIliIlI[4053511342]or(function(...)local SynapseXen_liIllIlIiiIIiI="i'm intercommunication about the most nonecclesiastical dll exploits for esp. they only characterization objects with a antepatriarchal in the geistesgeschichte for the esp."local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(4243721172,1230482355)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(4105853631,189117002)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[4053511342]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(184368003,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1642752316,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2410415574,2992089790,12363988,3316038052,1915129008,2615082035,2499891202,2016190348,2739984907}return SynapseXen_ilIliIIliIlI[4053511342]end)({},"iliiiliiiiIiiIi",{}))then SynapseXen_IIiilIiIilliIiil=SynapseXen_IiiIIllililiil()elseif SynapseXen_ilIII==(SynapseXen_ilIliIIliIlI[819023317]or(function()local SynapseXen_liIllIlIiiIIiI="aspect network better obfuscator"SynapseXen_ilIliIIliIlI[819023317]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2744443604,85942482),SynapseXen_lIliililllIlillIliI(2017118617,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2241842041,4039343929,3998037756,3226492470,3343972413,2244618177}return SynapseXen_ilIliIIliIlI[819023317]end)())then SynapseXen_IIiilIiIilliIiil=SynapseXen_liiliiIIiIIIIiliIll(SynapseXen_IIlIllIiIlIlliIIlii(SynapseXen_IiIiIl()),1,-2)end;SynapseXen_iiIIIIliiI[SynapseXen_IiiIi-1]=SynapseXen_IIiilIiIilliIiil end;SynapseXen_iiIiI()for SynapseXen_IiiIi=1,SynapseXen_lIliililllIlillIliI(SynapseXen_IIIIi(),SynapseXen_ilIliIIliIlI[2190917578]or(function()local SynapseXen_liIllIlIiiIIiI="this is so sad, alexa play ripull.mp4"SynapseXen_ilIliIIliIlI[2190917578]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3686194925,598937467),SynapseXen_lIliililllIlillIliI(2713216647,SynapseXen_ilIilIiIlIiIIillIi[5]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1278401879,3313664907,2694613989,306717688,2171940510}return SynapseXen_ilIliIIliIlI[2190917578]end)())do local SynapseXen_llIiI=SynapseXen_lIliililllIlillIliI(SynapseXen_iIiIIi(),SynapseXen_ilIliIIliIlI[1241659845]or(function(...)local SynapseXen_liIllIlIiiIIiI="xen best rerubi paste"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2723753480,1205808758)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2801728876,1493211637)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1241659845]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2279744384,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3465921894,SynapseXen_ilIilIiIlIiIIillIi[1]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{465306279,773864875,1242538343,3480597422,3602462008,2830231005}return SynapseXen_ilIliIIliIlI[1241659845]end)("IiiiIIilIi",{},"IlIIIiliIilI",{},10704,"lIiiiliIllillliiii",7631,6377,{}))local SynapseXen_IilillIlliIiilIli=SynapseXen_iiIiI()SynapseXen_iIiIIi()local SynapseXen_ilIII=SynapseXen_iiIiI()local SynapseXen_iIIIllIiIIiIlil={[195082471]=SynapseXen_llIiI,[66818102]=SynapseXen_IilillIlliIiilIli,[43960044]=SynapseXen_IliiIiIlIIII(SynapseXen_llIiI,1,6),[1370203552]=SynapseXen_IliiIiIlIIII(SynapseXen_llIiI,7,14)}if SynapseXen_ilIII==(SynapseXen_ilIliIIliIlI[1441571564]or(function()local SynapseXen_liIllIlIiiIIiI="xen doesn't come with instance caching, sorry superskater"SynapseXen_ilIliIIliIlI[1441571564]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3532913884,4116966726),SynapseXen_lIliililllIlillIliI(4182326616,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2534694277,1170255066,1829614294,1721931068}return SynapseXen_ilIliIIliIlI[1441571564]end)())then SynapseXen_iIIIllIiIIiIlil[1924739042]=SynapseXen_IliiIiIlIIII(SynapseXen_llIiI,24,32)SynapseXen_iIIIllIiIIiIlil[1931430686]=SynapseXen_IliiIiIlIIII(SynapseXen_llIiI,15,23)elseif SynapseXen_ilIII==(SynapseXen_ilIliIIliIlI[2469470415]or(function(...)local SynapseXen_liIllIlIiiIIiI="baby i just fell for uwu,,,,,, i wanna be with uwu!11!!"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(1487688464,598189536)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1382418758,2912524150)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2469470415]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1235237496,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3961167016,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{96834995,3527746814,3850150641,1446708414,4211571087,2909075841,515602910}return SynapseXen_ilIliIIliIlI[2469470415]end)("iIIl",{},11275,10605,12419,"IIlIIl","IIIlIIIi","lllliIl",75))then SynapseXen_iIIIllIiIIiIlil[1831871741]=SynapseXen_IliiIiIlIIII(SynapseXen_llIiI,15,32)elseif SynapseXen_ilIII==(SynapseXen_ilIliIIliIlI[3199560820]or(function(...)local SynapseXen_liIllIlIiiIIiI="hi xen doesn't work on sk8r please help"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(4132066710,3580806912)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(779367979,3515612032)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[3199560820]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(586617610,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3747826957,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2723234196}return SynapseXen_ilIliIIliIlI[3199560820]end)({},7203,"IiliII",{}))then SynapseXen_iIIIllIiIIiIlil[1571690726]=SynapseXen_IliiIiIlIIII(SynapseXen_llIiI,15,32)-131071 end;SynapseXen_IlIiIlllllIliil[SynapseXen_IiiIi]=SynapseXen_iIIIllIiIIiIlil end;SynapseXen_iiIiI()SynapseXen_iiIiI()SynapseXen_IlliIllll[710427381]=SynapseXen_lIliililllIlillIliI(SynapseXen_iiIiI(),SynapseXen_ilIliIIliIlI[1251989777]or(function(...)local SynapseXen_liIllIlIiiIIiI="hi my 2.5mb script doesn't work with xen please help"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(1922624764,241092739)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2695992865,1598950004)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1251989777]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3339999373,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1701691702,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3045909767}return SynapseXen_ilIliIIliIlI[1251989777]end)({},"IllIiillilii",{},{}))SynapseXen_iIiIIi()SynapseXen_iiIiI()SynapseXen_IlliIllll[907555918]=SynapseXen_lIliililllIlillIliI(SynapseXen_iiIiI(),SynapseXen_ilIliIIliIlI[692780149]or(function()local SynapseXen_liIllIlIiiIIiI="HELP ME PEOPLE ARE CRASHING MY GAME PLZ HELP"SynapseXen_ilIliIIliIlI[692780149]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1127098424,2293337814),SynapseXen_lIliililllIlillIliI(353453272,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1372922669,3726743627}return SynapseXen_ilIliIIliIlI[692780149]end)())SynapseXen_iIiIIi()SynapseXen_iiIiI()for SynapseXen_IiiIi=1,SynapseXen_lIliililllIlillIliI(SynapseXen_IIIIi(),SynapseXen_ilIliIIliIlI[2101734799]or(function()local SynapseXen_liIllIlIiiIIiI="wait for someone on devforum to say they are gonna deobfuscate this"SynapseXen_ilIliIIliIlI[2101734799]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1142195963,1707682054),SynapseXen_lIliililllIlillIliI(2598300752,SynapseXen_ilIilIiIlIiIIillIi[2]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{692664987,2713573380,2770775451,1351770638,3080198485,4010135218,1223817247,3442637432,4046631832}return SynapseXen_ilIliIIliIlI[2101734799]end)())do SynapseXen_liIIiIiIlllIil[SynapseXen_IiiIi-1]=SynapseXen_IIilIil()end;return SynapseXen_IlliIllll end;do assert(SynapseXen_IiIiIl(4)=="\27Xen","Synapse Xen - Failed to verify bytecode. Please make sure your Lua implementation supports non-null terminated strings.")SynapseXen_IIIIi=SynapseXen_iIiIIi;SynapseXen_IiIiIlllIiiIlliiIli=SynapseXen_iIiIIi;local SynapseXen_IlIIilllIiII=SynapseXen_IiIiIl()SynapseXen_iIiIIi()SynapseXen_iiIiI()SynapseXen_lliilli=SynapseXen_lIiIIilIl(SynapseXen_IIIIi())SynapseXen_iiIiI()local SynapseXen_lIiIllIllIiliiIIlIli=0;for SynapseXen_lllliiiiiilIiIi=1,#SynapseXen_IlIIilllIiII do local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_IlIIilllIiII:sub(SynapseXen_lllliiiiiilIiIi,SynapseXen_lllliiiiiilIiIi)SynapseXen_lIiIllIllIiliiIIlIli=SynapseXen_lIiIllIllIiliiIIlIli+string.byte(SynapseXen_iiliIiiiiIlIIiIiIlli)end;SynapseXen_lIiIllIllIiliiIIlIli=SynapseXen_lIliililllIlillIliI(SynapseXen_lIiIllIllIiliiIIlIli,SynapseXen_lliilli)for SynapseXen_IiiIi=1,SynapseXen_iiIiI()do SynapseXen_ilIilIiIlIiIIillIi[SynapseXen_IiiIi]=SynapseXen_IlIIiI(SynapseXen_IIIIi(),SynapseXen_lIiIllIllIiliiIIlIli)end;SynapseXen_IlIilIIillliliii()end;return SynapseXen_IIilIil()end;local function SynapseXen_iIIlIliIIliIiiIil(...)return SynapseXen_IlIlii('#',...),{...}end;local function SynapseXen_llIIlIIlllillIili(SynapseXen_IlliIllll,SynapseXen_iIilI,SynapseXen_lIilIiiillIilliii)local SynapseXen_IlIiIlllllIliil=SynapseXen_IlliIllll[SynapseXen_ilIliIIliIlI[1462546893]or(function(...)local SynapseXen_liIllIlIiiIIiI="can we have an f in chat for ripull"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2919163053,1435547314)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2001320581,2293655067)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1462546893]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(236605065,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(15570317,SynapseXen_ilIilIiIlIiIIillIi[1]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2264639732,317755800,1446073688,3481842811,229935147,1221643587,2118723162,2754452925,3453857863}return SynapseXen_ilIliIIliIlI[1462546893]end)(1864,{},{},"lIlIiIl","IiI")]local SynapseXen_iiIIIIliiI=SynapseXen_IlliIllll[SynapseXen_ilIliIIliIlI[3548391233]or(function()local SynapseXen_liIllIlIiiIIiI="now comes with a free n word pass"SynapseXen_ilIliIIliIlI[3548391233]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2788933513,671476974),SynapseXen_lIliililllIlillIliI(493659865,SynapseXen_ilIilIiIlIiIIillIi[6]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{857071196,2384762982,2314582996,1044285425,3990714315}return SynapseXen_ilIliIIliIlI[3548391233]end)()]local SynapseXen_liIIiIiIlllIil=SynapseXen_IlliIllll[SynapseXen_ilIliIIliIlI[3103792106]or(function(...)local SynapseXen_liIllIlIiiIIiI="double-header fair! this rationalization has a overenthusiastically anticheat! you will get nonpermissible for exploiting!"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2879469140,825572157)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(3899339315,395632399)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[3103792106]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3562214666,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2270907697,SynapseXen_ilIilIiIlIiIIillIi[7]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{4202984741,2484292256}return SynapseXen_ilIliIIliIlI[3103792106]end)(6817,{})]return function(...)local SynapseXen_IlIIliIIliI,SynapseXen_IllllilIIiilIlI=1,-1;local SynapseXen_iIlIIlliIllil,SynapseXen_IiiIiiiiIIIilIllil={},SynapseXen_IlIlii('#',...)-1;local SynapseXen_IIIIliiiiiI=0;local SynapseXen_ilIiillIIIiIlIIl={}local SynapseXen_ilIillilIIIIlilII={}local SynapseXen_liliIi=setmetatable({},{__index=SynapseXen_ilIiillIIIiIlIIl,__newindex=function(SynapseXen_iIlIilliliIillIiilil,SynapseXen_iiIiIIiIi,SynapseXen_iIIlIlIiIiiilI)if SynapseXen_iiIiIIiIi>SynapseXen_IllllilIIiilIlI then SynapseXen_IllllilIIiilIlI=SynapseXen_iiIiIIiIi end;SynapseXen_ilIiillIIIiIlIIl[SynapseXen_iiIiIIiIi]=SynapseXen_iIIlIlIiIiiilI end})local function SynapseXen_iiiIlill()local SynapseXen_iIIIllIiIIiIlil,SynapseXen_iIiIliIIilIii;while true do SynapseXen_iIIIllIiIIiIlil=SynapseXen_IlIiIlllllIliil[SynapseXen_IlIIliIIliI]SynapseXen_iIiIliIIilIii=SynapseXen_iIIIllIiIIiIlil[66818102]SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+1;if SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[1589750929]or(function(...)local SynapseXen_liIllIlIiiIIiI="inb4 posted on exploit reports section"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2087516207,161190673)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2201194692,2093747414)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1589750929]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3390705988,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(417378330,SynapseXen_ilIilIiIlIiIIillIi[6]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2280349283,2551376045,3163633294,1293150243,2833544599,2095999801,2618226198,3805348396}return SynapseXen_ilIliIIliIlI[1589750929]end)(8980,"iIi","lII",3657,"IIIliIIIIIliiilIi",{}))then local SynapseXen_IIIiil=SynapseXen_iIllili(SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[386777088]or(function()local SynapseXen_liIllIlIiiIIiI="print(bytecode)"SynapseXen_ilIliIIliIlI[386777088]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(475028493,3318338586),SynapseXen_lIliililllIlillIliI(1406755545,SynapseXen_ilIilIiIlIiIIillIi[5]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1623515994,2974151545,871644273}return SynapseXen_ilIliIIliIlI[386777088]end)(),256),SynapseXen_IIIIliiiiiI,256)~=0;local SynapseXen_iIIiI=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[200123138]or(function()local SynapseXen_liIllIlIiiIIiI="pain is gonna use the backspace method on xen"SynapseXen_ilIliIIliIlI[200123138]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(151266466,1204899128),SynapseXen_lIliililllIlillIliI(2422572983,SynapseXen_lliilli))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{3592413527,76631823,1591412793,3093568253,715949197}return SynapseXen_ilIliIIliIlI[200123138]end)()),SynapseXen_IIIIliiiiiI)local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[1063134566]or(function(...)local SynapseXen_liIllIlIiiIIiI="https://twitter.com/Ripull_RBLX/status/1059334518581145603"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3572729294,3454402274)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(702163730,3592803556)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1063134566]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(51852165,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(4045451093,SynapseXen_ilIilIiIlIiIIillIi[2]))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{2753363719,3667320814,2436197315,726444795,1873398144,768262552,1988120318}return SynapseXen_ilIliIIliIlI[1063134566]end)({},2911,"iiiIlIliliiII",12557))local SynapseXen_iliiIllIiill=SynapseXen_liliIi;if SynapseXen_iIIiI>255 then SynapseXen_iIIiI=SynapseXen_iiIIIIliiI[SynapseXen_iIIiI-256]else SynapseXen_iIIiI=SynapseXen_iliiIllIiill[SynapseXen_iIIiI]end;if SynapseXen_iiliIiiiiIlIIiIiIlli>255 then SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iiIIIIliiI[SynapseXen_iiliIiiiiIlIIiIiIlli-256]else SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iliiIllIiill[SynapseXen_iiliIiiiiIlIIiIiIlli]end;if SynapseXen_iIIiI==SynapseXen_iiliIiiiiIlIIiIiIlli~=SynapseXen_IIIiil then SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+1 end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[1889388715]or(function()local SynapseXen_liIllIlIiiIIiI="so if you'we nyot awawe of expwoiting by this point, you've pwobabwy been wiving undew a wock that the pionyeews used to wide fow miwes. wobwox is often seen as an expwoit-infested gwound by most fwom the suwface, awthough this isn't the case."SynapseXen_ilIliIIliIlI[1889388715]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1067963556,2898652403),SynapseXen_lIliililllIlillIliI(1306297908,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1508379748}return SynapseXen_ilIliIIliIlI[1889388715]end)())then local SynapseXen_IIIiil=SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[328492222]or(function()local SynapseXen_liIllIlIiiIIiI="thats how mafia works"SynapseXen_ilIliIIliIlI[328492222]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3124540733,3402159860),SynapseXen_lIliililllIlillIliI(2368327746,SynapseXen_ilIilIiIlIiIIillIi[7]))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{3346640308,2314724247,344717468,537288987,1793551820,2502840853}return SynapseXen_ilIliIIliIlI[328492222]end)(),256)local SynapseXen_iIIiI=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[1342998878]or(function()local SynapseXen_liIllIlIiiIIiI="SYNAPSE XEN [FE BYPASS] [BETTER THEN LURAPH] [AMAZING] OMG OMG OMG !!!!!!"SynapseXen_ilIliIIliIlI[1342998878]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2166421934,4135900610),SynapseXen_lIliililllIlillIliI(2625659316,SynapseXen_ilIilIiIlIiIIillIi[2]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1477720136,1624533459,1734570161,316086030,547621745,3834655052,4289278953,299791108,3540934563}return SynapseXen_ilIliIIliIlI[1342998878]end)()),SynapseXen_IIIIliiiiiI)local SynapseXen_iliiIllIiill=SynapseXen_liliIi;local SynapseXen_IilIiiIIiii,SynapseXen_liIlilliiIllIII;local SynapseXen_IIIiliIll;local SynapseXen_IlllIIlilIiillI=0;SynapseXen_IilIiiIIiii={}if SynapseXen_iIIiI~=1 then if SynapseXen_iIIiI~=0 then SynapseXen_IIIiliIll=SynapseXen_IIIiil+SynapseXen_iIIiI-1 else SynapseXen_IIIiliIll=SynapseXen_IllllilIIiilIlI end;for SynapseXen_IiiIi=SynapseXen_IIIiil+1,SynapseXen_IIIiliIll do SynapseXen_IilIiiIIiii[#SynapseXen_IilIiiIIiii+1]=SynapseXen_iliiIllIiill[SynapseXen_IiiIi]end;SynapseXen_liIlilliiIllIII={SynapseXen_iliiIllIiill[SynapseXen_IIIiil](unpack(SynapseXen_IilIiiIIiii,1,SynapseXen_IIIiliIll-SynapseXen_IIIiil))}else SynapseXen_liIlilliiIllIII={SynapseXen_iliiIllIiill[SynapseXen_IIIiil]()}end;for SynapseXen_iilllI in next,SynapseXen_liIlilliiIllIII do if SynapseXen_iilllI>SynapseXen_IlllIIlilIiillI then SynapseXen_IlllIIlilIiillI=SynapseXen_iilllI end end;return SynapseXen_liIlilliiIllIII,SynapseXen_IlllIIlilIiillI elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[3713224210]or(function()local SynapseXen_liIllIlIiiIIiI="yed"SynapseXen_ilIliIIliIlI[3713224210]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(327212991,278230809),SynapseXen_lIliililllIlillIliI(3718571454,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2432036699,2522035150,3807820782,3448509256,3302093351,2892288267}return SynapseXen_ilIliIIliIlI[3713224210]end)())then local SynapseXen_IIIiil=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[794128281]or(function()local SynapseXen_liIllIlIiiIIiI="hi xen crashes on my axon paste plz help"SynapseXen_ilIliIIliIlI[794128281]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(793068188,2891671039),SynapseXen_lIliililllIlillIliI(1006076454,SynapseXen_ilIilIiIlIiIIillIi[4]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3642326822,3950705115,2696404133,3958802966,4189284027,3253837588,2168665909,1310477118}return SynapseXen_ilIliIIliIlI[794128281]end)())local SynapseXen_iIIiI=SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[434504272]or(function(...)local SynapseXen_liIllIlIiiIIiI="this is so sad, alexa play ripull.mp4"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(4241089493,3317003380)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1902889562,2392082073)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[434504272]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2680701592,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1301339845,SynapseXen_ilIilIiIlIiIIillIi[2]))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{433895172,1504203937,4018041842,1606638342}return SynapseXen_ilIliIIliIlI[434504272]end)(55,1351),512)local SynapseXen_iliiIllIiill,SynapseXen_iiIIlliililiiI=SynapseXen_liliIi,SynapseXen_iIlIIlliIllil;SynapseXen_IllllilIIiilIlI=SynapseXen_IIIiil-1;for SynapseXen_IiiIi=SynapseXen_IIIiil,SynapseXen_IIIiil+(SynapseXen_iIIiI>0 and SynapseXen_iIIiI-1 or SynapseXen_IiiIiiiiIIIilIllil)do SynapseXen_iliiIllIiill[SynapseXen_IiiIi]=SynapseXen_iiIIlliililiiI[SynapseXen_IiiIi-SynapseXen_IIIiil]end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[3258796664]or(function()local SynapseXen_liIllIlIiiIIiI="what are you trying to say? that fucking one dot + dot + dot + many dots is not adding adding 1 dot + dot and then adding all the dots together????"SynapseXen_ilIliIIliIlI[3258796664]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3607760320,2344382751),SynapseXen_lIliililllIlillIliI(4223512323,SynapseXen_ilIilIiIlIiIIillIi[6]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{43005473,2567247059,2769969632,3296364470,2839370803,417024741,290798812,4009503267,3658798057}return SynapseXen_ilIliIIliIlI[3258796664]end)())then SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+SynapseXen_iIIIllIiIIiIlil[1571690726]elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[2434617305]or(function()local SynapseXen_liIllIlIiiIIiI="aspect network better obfuscator"SynapseXen_ilIliIIliIlI[2434617305]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3145564702,3248646862),SynapseXen_lIliililllIlillIliI(3723243890,SynapseXen_ilIilIiIlIiIIillIi[6]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{359860470,2350972424,281125093,2352357608,1133062260}return SynapseXen_ilIliIIliIlI[2434617305]end)())then local SynapseXen_iIIiI,SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[3113069384]or(function()local SynapseXen_liIllIlIiiIIiI="hi my 2.5mb script doesn't work with xen please help"SynapseXen_ilIliIIliIlI[3113069384]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2590738063,655474545),SynapseXen_lIliililllIlillIliI(1674368528,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1859366277,368256964,4193715507,3501668514,2820630712,3028923548,3875155185,1316536853,2431202038}return SynapseXen_ilIliIIliIlI[3113069384]end)()),SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[4149899619]or(function()local SynapseXen_liIllIlIiiIIiI="epic gamer vision"SynapseXen_ilIliIIliIlI[4149899619]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3530856697,1959467103),SynapseXen_lIliililllIlillIliI(746807809,SynapseXen_ilIilIiIlIiIIillIi[5]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{78528925,328301537,657093544,1808146123,2549559436,4127620977,3957929101,3613041741,2762305121,3473486459}return SynapseXen_ilIliIIliIlI[4149899619]end)())local SynapseXen_iliiIllIiill=SynapseXen_liliIi;if SynapseXen_iIIiI>255 then SynapseXen_iIIiI=SynapseXen_iiIIIIliiI[SynapseXen_iIIiI-256]else SynapseXen_iIIiI=SynapseXen_iliiIllIiill[SynapseXen_iIIiI]end;if SynapseXen_iiliIiiiiIlIIiIiIlli>255 then SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iiIIIIliiI[SynapseXen_iiliIiiiiIlIIiIiIlli-256]else SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iliiIllIiill[SynapseXen_iiliIiiiiIlIIiIiIlli]end;SynapseXen_iliiIllIiill[SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[2041905253]or(function(...)local SynapseXen_liIllIlIiiIIiI="hi xen doesn't work on sk8r please help"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(789353711,3895345629)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2140928508,2154013829)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2041905253]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(332904164,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(172439881,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{1992746987,3023821423,53235589,1022782564,3915814064,1415958928,1822518224}return SynapseXen_ilIliIIliIlI[2041905253]end)(9276),256)][SynapseXen_iIIiI]=SynapseXen_iiliIiiiiIlIIiIiIlli elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[2237972305]or(function(...)local SynapseXen_liIllIlIiiIIiI="sponsored by ironbrew, jk xen is better"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2581834392,1598240097)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1793590900,2501348474)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2237972305]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3717568409,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1258062912,SynapseXen_ilIilIiIlIiIIillIi[3]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1825306482,2234200843,371310065,3149077560,2425034708,285554857}return SynapseXen_ilIliIIliIlI[2237972305]end)("IIIlilllll",6110,{},1278,"lliliillIiiiii",{},"illliIIiIliIl",4377,9869))then local SynapseXen_IIIiil=SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[4023152674]or(function(...)local SynapseXen_liIllIlIiiIIiI="hi xen crashes on my axon paste plz help"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(1136660532,2142844139)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(4127295268,167640758)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[4023152674]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2987974516,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1355876860,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{1419254973,466543248,3051048251,885284272}return SynapseXen_ilIliIIliIlI[4023152674]end)("iiIIllIIl",14871,{},{}),256)local SynapseXen_IiiIIIIiiiIilIlilIIi={}for SynapseXen_IiiIi=1,#SynapseXen_ilIillilIIIIlilII do local SynapseXen_IliliilIIllillil=SynapseXen_ilIillilIIIIlilII[SynapseXen_IiiIi]for SynapseXen_ilillllIIlliiiil=0,#SynapseXen_IliliilIIllillil do local SynapseXen_IlliiIlIiiiIiI=SynapseXen_IliliilIIllillil[SynapseXen_ilillllIIlliiiil]local SynapseXen_iliiIllIiill=SynapseXen_IlliiIlIiiiIiI[1]local SynapseXen_IllliIliiIlIliIllll=SynapseXen_IlliiIlIiiiIiI[2]if SynapseXen_iliiIllIiill==SynapseXen_liliIi and SynapseXen_IllliIliiIlIliIllll>=SynapseXen_IIIiil then SynapseXen_IiiIIIIiiiIilIlilIIi[SynapseXen_IllliIliiIlIliIllll]=SynapseXen_iliiIllIiill[SynapseXen_IllliIliiIlIliIllll]SynapseXen_IlliiIlIiiiIiI[1]=SynapseXen_IiiIIIIiiiIilIlilIIi end end end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[3154145249]or(function()local SynapseXen_liIllIlIiiIIiI="my way to go against expwoiting is to have safety measuwes. i 1 wocawscwipt and onwy moduwes. hewe's how it wowks: this scwipt bewow stowes the moduwes in a tabwe fow each moduwe we send the wist with the moduwes and moduwe infowmation and use inyit a function in my moduwe that wiww stowe the info and aftew it has send to aww the moduwes it wiww dewete them. so whenyevew the cwient twies to hack they cant get the moduwes. onwy this peace of wocawscwipt."SynapseXen_ilIliIIliIlI[3154145249]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3844363503,377541865),SynapseXen_lIliililllIlillIliI(756293031,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{4207201154,3050022794,3790236787,3636045941,3198420653,2156826162,3600461840,1773992049,684225058,2626048206}return SynapseXen_ilIliIIliIlI[3154145249]end)())then SynapseXen_lIilIiiillIilliii[SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[2268158337]or(function(...)local SynapseXen_liIllIlIiiIIiI="double-header fair! this rationalization has a overenthusiastically anticheat! you will get nonpermissible for exploiting!"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3584117848,3955927944)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1040357764,3254593374)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2268158337]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2177529992,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1628918927,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{1589487216,4226201626,1578732051,492064276,515892359,2432873028,468912357}return SynapseXen_ilIliIIliIlI[2268158337]end)("iIiIIIIillIIIlllIlI","iI",{},"iIlilIIIiiIII"),512)]=SynapseXen_liliIi[SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[198084930]or(function()local SynapseXen_liIllIlIiiIIiI="pain exist is gonna connect the dots of xen"SynapseXen_ilIliIIliIlI[198084930]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2419980615,1491585094),SynapseXen_lIliililllIlillIliI(376129469,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2372218835,155056623,2963164272,1505192979}return SynapseXen_ilIliIIliIlI[198084930]end)()),SynapseXen_IIIIliiiiiI)]elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[3471969229]or(function(...)local SynapseXen_liIllIlIiiIIiI="SECURE API, IMPOSSIBLE TO BYPASS!"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3996884221,1387221410)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(3978709175,316254089)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[3471969229]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(332035832,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1911088063,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3024472631,999203444,1632152202,2024778861,3142406454,3740502975,1980195620,2585304819,3692248966,3534052769}return SynapseXen_ilIliIIliIlI[3471969229]end)({},"iilllIiIliIilI","IiiliIiiliIl",{},12892,548))then SynapseXen_liliIi[SynapseXen_iIllili(SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[2762067748]or(function()local SynapseXen_liIllIlIiiIIiI="i'm intercommunication about the most nonecclesiastical dll exploits for esp. they only characterization objects with a antepatriarchal in the geistesgeschichte for the esp."SynapseXen_ilIliIIliIlI[2762067748]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3384497326,3862410753),SynapseXen_lIliililllIlillIliI(4047252827,SynapseXen_lliilli))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{4218472892,1847446761,168843013,4032140166,3729805714}return SynapseXen_ilIliIIliIlI[2762067748]end)()),SynapseXen_IIIIliiiiiI,256)]=not SynapseXen_liliIi[SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[2236731247]or(function()local SynapseXen_liIllIlIiiIIiI="hi devforum"SynapseXen_ilIliIIliIlI[2236731247]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3824777127,2352196122),SynapseXen_lIliililllIlillIliI(2977470663,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2713341905}return SynapseXen_ilIliIIliIlI[2236731247]end)(),512)]elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[547288401]or(function(...)local SynapseXen_liIllIlIiiIIiI="HELP ME PEOPLE ARE CRASHING MY GAME PLZ HELP"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(4093598409,3003746824)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(4020238520,274705251)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[547288401]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(110346703,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3781746474,SynapseXen_ilIilIiIlIiIIillIi[6]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3744207393,2576493080,2135782806,2650761413,537778740,263809265,2123922300,3557375981,238842124}return SynapseXen_ilIliIIliIlI[547288401]end)("IIiIIillllllilliIil","iIllIilIIlili",267,"iilIiIillIlil","iliilIlIliIllIIII",1674,{},"llllliiiliiiIl",6575))then local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[527180074]or(function()local SynapseXen_liIllIlIiiIIiI="yed"SynapseXen_ilIliIIliIlI[527180074]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2790034904,4154199894),SynapseXen_lIliililllIlillIliI(2405829574,SynapseXen_lliilli))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{1348395600,2771912164,579699561,1759559572,2312469548,226819950,3524540653,3745327929}return SynapseXen_ilIliIIliIlI[527180074]end)())local SynapseXen_iliiIllIiill=SynapseXen_liliIi;if SynapseXen_iiliIiiiiIlIIiIiIlli>255 then SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iiIIIIliiI[SynapseXen_iiliIiiiiIlIIiIiIlli-256]else SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iliiIllIiill[SynapseXen_iiliIiiiiIlIIiIiIlli]end;SynapseXen_iliiIllIiill[SynapseXen_liliilIl(SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[4091159030]or(function(...)local SynapseXen_liIllIlIiiIIiI="pain exist is gonna connect the dots of xen"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(4003212506,529706995)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1088441873,3206540357)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[4091159030]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3310124309,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2471445480,SynapseXen_ilIilIiIlIiIIillIi[6]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3873196861,361394656,1599883708,2316845878,2731124620,3649958033,3449900934}return SynapseXen_ilIliIIliIlI[4091159030]end)(1005,{},"IIliliiIlilI")),SynapseXen_IIIIliiiiiI,256)]=SynapseXen_iliiIllIiill[SynapseXen_lIliililllIlillIliI(SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[2095688955]or(function(...)local SynapseXen_liIllIlIiiIIiI="SYNAPSE XEN [FE BYPASS] [BETTER THEN LURAPH] [AMAZING] OMG OMG OMG !!!!!!"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2479294188,3690900373)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1747051286,2547886723)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2095688955]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2426475766,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1390098230,SynapseXen_ilIilIiIlIiIIillIi[5]))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{1757942098,843348334,3253063026,3046484578,2620008962,2286512077,2926993644}return SynapseXen_ilIliIIliIlI[2095688955]end)(7818,4814,{},{},"iliIlillIIIillIiI",{},11670),512),SynapseXen_IIIIliiiiiI)][SynapseXen_iiliIiiiiIlIIiIiIlli]elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[2332784354]or(function()local SynapseXen_liIllIlIiiIIiI="wow xen is shit buy luraph ok"SynapseXen_ilIliIIliIlI[2332784354]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(63028692,7542406),SynapseXen_lIliililllIlillIliI(3707790645,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2446007453,1988318886}return SynapseXen_ilIliIIliIlI[2332784354]end)())then local SynapseXen_iIIiI=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[563553720]or(function(...)local SynapseXen_liIllIlIiiIIiI="hi xen doesn't work on sk8r please help"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3699563507,3311498529)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1138342110,3156635684)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[563553720]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(449849723,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1392334757,SynapseXen_ilIilIiIlIiIIillIi[3]))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{353876220,2185199168,734052307,1762909219,2741391791,858309604}return SynapseXen_ilIliIIliIlI[563553720]end)({},{}))local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[123454864]or(function(...)local SynapseXen_liIllIlIiiIIiI="my way to go against expwoiting is to have safety measuwes. i 1 wocawscwipt and onwy moduwes. hewe's how it wowks: this scwipt bewow stowes the moduwes in a tabwe fow each moduwe we send the wist with the moduwes and moduwe infowmation and use inyit a function in my moduwe that wiww stowe the info and aftew it has send to aww the moduwes it wiww dewete them. so whenyevew the cwient twies to hack they cant get the moduwes. onwy this peace of wocawscwipt."local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(1908085253,1234307752)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(524853322,3770114834)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[123454864]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1368538717,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2191426073,SynapseXen_ilIilIiIlIiIIillIi[2]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3950391629,2420483293,2523149911}return SynapseXen_ilIliIIliIlI[123454864]end)(5221,{},"lIIIlliIIIIIlIiIli","liIllIliIIilili","iIiI",{},{},{}))local SynapseXen_iliiIllIiill=SynapseXen_liliIi;if SynapseXen_iIIiI>255 then SynapseXen_iIIiI=SynapseXen_iiIIIIliiI[SynapseXen_iIIiI-256]else SynapseXen_iIIiI=SynapseXen_iliiIllIiill[SynapseXen_iIIiI]end;if SynapseXen_iiliIiiiiIlIIiIiIlli>255 then SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iiIIIIliiI[SynapseXen_iiliIiiiiIlIIiIiIlli-256]else SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iliiIllIiill[SynapseXen_iiliIiiiiIlIIiIiIlli]end;SynapseXen_iliiIllIiill[SynapseXen_lIliililllIlillIliI(SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[992715359]or(function(...)local SynapseXen_liIllIlIiiIIiI="imagine using some lua minifier tool and thinking you are a badass"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(354926095,1641819931)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2045788526,2249193501)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[992715359]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1529972498,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(4050863977,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{1990909280,2274972921,2447838104,1939084777,952508025,980101311,4058088950,1566222317,2301925960,3690266122}return SynapseXen_ilIliIIliIlI[992715359]end)("liIlllIl",13732,"IliIliIIliiIIi",12502,"IllililiilllIillll","Ililll",{},{}),256),SynapseXen_IIIIliiiiiI)]=SynapseXen_iIIiI^SynapseXen_iiliIiiiiIlIIiIiIlli elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[2633434747]or(function()local SynapseXen_liIllIlIiiIIiI="hi my 2.5mb script doesn't work with xen please help"SynapseXen_ilIliIIliIlI[2633434747]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(756055803,3435097577),SynapseXen_lIliililllIlillIliI(1057045580,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{121700013,2339764432,670468143,2026460649,212627983,4262449190}return SynapseXen_ilIliIIliIlI[2633434747]end)())then local SynapseXen_IIIiil=SynapseXen_liliilIl(SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[1607513769]or(function(...)local SynapseXen_liIllIlIiiIIiI="sponsored by ironbrew, jk xen is better"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(103791731,1053771073)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(4119485591,175445176)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1607513769]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1693463033,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2193499574,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{3508658275,2553174737,2802027139,1101384610}return SynapseXen_ilIliIIliIlI[1607513769]end)({})),SynapseXen_IIIIliiiiiI,256)local SynapseXen_iliiIllIiill=SynapseXen_liliIi;local SynapseXen_iiiIliiilllII=SynapseXen_iliiIllIiill[SynapseXen_IIIiil+2]local SynapseXen_iilllI=SynapseXen_iliiIllIiill[SynapseXen_IIIiil]+SynapseXen_iiiIliiilllII;SynapseXen_iliiIllIiill[SynapseXen_IIIiil]=SynapseXen_iilllI;if SynapseXen_iiiIliiilllII>0 then if SynapseXen_iilllI<=SynapseXen_iliiIllIiill[SynapseXen_IIIiil+1]then SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+SynapseXen_iIIIllIiIIiIlil[1571690726]SynapseXen_iliiIllIiill[SynapseXen_IIIiil+3]=SynapseXen_iilllI end else if SynapseXen_iilllI>=SynapseXen_iliiIllIiill[SynapseXen_IIIiil+1]then SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+SynapseXen_iIIIllIiIIiIlil[1571690726]SynapseXen_iliiIllIiill[SynapseXen_IIIiil+3]=SynapseXen_iilllI end end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[1647901982]or(function(...)local SynapseXen_liIllIlIiiIIiI="wally bad bird"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3447696346,1686654303)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(306935731,3988005567)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1647901982]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2797469621,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3507186021,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3785180095,3822499859,2511234429,4174711166,103776988}return SynapseXen_ilIliIIliIlI[1647901982]end)({},{},"lIIlIIIl",{}))then local SynapseXen_iIiiiiIIiliI=SynapseXen_liIIiIiIlllIil[SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1831871741],SynapseXen_ilIliIIliIlI[1849122804]or(function(...)local SynapseXen_liIllIlIiiIIiI="sometimes it be like that"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(4176874082,2515590235)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(3523372703,771570929)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1849122804]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(433135920,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2858690043,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3123577171,3713656454}return SynapseXen_ilIliIIliIlI[1849122804]end)("il","lllllIliIll","lIilliilIl","li",{},12723)),SynapseXen_IIIIliiiiiI)]local SynapseXen_iliiIllIiill=SynapseXen_liliIi;local SynapseXen_IliIiII;local SynapseXen_lIllIIllIIliiIiIi;if SynapseXen_iIiiiiIIiliI[710427381]~=0 then SynapseXen_IliIiII={}SynapseXen_lIllIIllIIliiIiIi=setmetatable({},{__index=function(SynapseXen_iIlIilliliIillIiilil,SynapseXen_iiIiIIiIi)local SynapseXen_liiIiiiiiiIiiiiIIII=SynapseXen_IliIiII[SynapseXen_iiIiIIiIi]return SynapseXen_liiIiiiiiiIiiiiIIII[1][SynapseXen_liiIiiiiiiIiiiiIIII[2]]end,__newindex=function(SynapseXen_iIlIilliliIillIiilil,SynapseXen_iiIiIIiIi,SynapseXen_iIIlIlIiIiiilI)local SynapseXen_liiIiiiiiiIiiiiIIII=SynapseXen_IliIiII[SynapseXen_iiIiIIiIi]SynapseXen_liiIiiiiiiIiiiiIIII[1][SynapseXen_liiIiiiiiiIiiiiIIII[2]]=SynapseXen_iIIlIlIiIiiilI end})for SynapseXen_IiiIi=1,SynapseXen_iIiiiiIIiliI[710427381]do local SynapseXen_lIlIIlIIliill=SynapseXen_IlIiIlllllIliil[SynapseXen_IlIIliIIliI]if SynapseXen_lIlIIlIIliill[66818102]==(SynapseXen_ilIliIIliIlI[3878166295]or(function(...)local SynapseXen_liIllIlIiiIIiI="skisploit is the superior obfuscator, clearly."local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2397132857,1589748950)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(210963213,4083980023)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[3878166295]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2484320944,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(4242163052,SynapseXen_ilIilIiIlIiIIillIi[4]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2318486910,1958355584,3552650986,3500731011,2526177920,3131672089}return SynapseXen_ilIliIIliIlI[3878166295]end)({},{}))then SynapseXen_IliIiII[SynapseXen_IiiIi-1]={SynapseXen_iliiIllIiill,SynapseXen_lIliililllIlillIliI(SynapseXen_lIlIIlIIliill[1924739042],SynapseXen_ilIliIIliIlI[3709961033]or(function()local SynapseXen_liIllIlIiiIIiI="xen best rerubi paste"SynapseXen_ilIliIIliIlI[3709961033]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3483301992,3292644544),SynapseXen_lIliililllIlillIliI(3000291180,SynapseXen_ilIilIiIlIiIIillIi[1]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{925139207,2910019391,380068142,2952613673}return SynapseXen_ilIliIIliIlI[3709961033]end)())}elseif SynapseXen_lIlIIlIIliill[66818102]==(SynapseXen_ilIliIIliIlI[738738267]or(function()local SynapseXen_liIllIlIiiIIiI="can we have an f in chat for ripull"SynapseXen_ilIliIIliIlI[738738267]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3106884955,2897063450),SynapseXen_lIliililllIlillIliI(3409063548,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3998730253,1474653700,3372967226,4280407668,1018665804}return SynapseXen_ilIliIIliIlI[738738267]end)())then SynapseXen_IliIiII[SynapseXen_IiiIi-1]={SynapseXen_lIilIiiillIilliii,SynapseXen_lIliililllIlillIliI(SynapseXen_lIlIIlIIliill[1924739042],SynapseXen_ilIliIIliIlI[1050932703]or(function()local SynapseXen_liIllIlIiiIIiI="inb4 posted on exploit reports section"SynapseXen_ilIliIIliIlI[1050932703]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2083906469,2617002988),SynapseXen_lIliililllIlillIliI(964474034,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3005537300,3759223872,2961986059,2439150536,401978238}return SynapseXen_ilIliIIliIlI[1050932703]end)())}end;SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+1 end;SynapseXen_ilIillilIIIIlilII[#SynapseXen_ilIillilIIIIlilII+1]=SynapseXen_IliIiII end;SynapseXen_iliiIllIiill[SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[2885064726]or(function()local SynapseXen_liIllIlIiiIIiI="this is a christian obfuscator, no cursing allowed in our scripts"SynapseXen_ilIliIIliIlI[2885064726]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2582007313,3777799311),SynapseXen_lIliililllIlillIliI(3754376837,SynapseXen_ilIilIiIlIiIIillIi[6]))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{133461082,2147665498,4047120620,4235801418,1648935678,69885843,4093757864,3694067315,2601628348}return SynapseXen_ilIliIIliIlI[2885064726]end)(),256)]=SynapseXen_llIIlIIlllillIili(SynapseXen_iIiiiiIIiliI,SynapseXen_iIilI,SynapseXen_lIllIIllIIliiIiIi)elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[1355791822]or(function()local SynapseXen_liIllIlIiiIIiI="aspect network better obfuscator"SynapseXen_ilIliIIliIlI[1355791822]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1298074041,999155378),SynapseXen_lIliililllIlillIliI(2825005500,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1955768971,4196466928,4087023739,1164558469,3900936623,3396942217,1820945736}return SynapseXen_ilIliIIliIlI[1355791822]end)())then local SynapseXen_IIIiil=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[75824397]or(function()local SynapseXen_liIllIlIiiIIiI="https://twitter.com/Ripull_RBLX/status/1059334518581145603"SynapseXen_ilIliIIliIlI[75824397]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3040029833,2591580440),SynapseXen_lIliililllIlillIliI(2544658308,SynapseXen_ilIilIiIlIiIIillIi[4]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2929595833,3879157350,371034486,1928037258}return SynapseXen_ilIliIIliIlI[75824397]end)())local SynapseXen_iIIiI=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[3261136891]or(function()local SynapseXen_liIllIlIiiIIiI="double-header fair! this rationalization has a overenthusiastically anticheat! you will get nonpermissible for exploiting!"SynapseXen_ilIliIIliIlI[3261136891]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1429595236,4288014989),SynapseXen_lIliililllIlillIliI(552025177,SynapseXen_ilIilIiIlIiIIillIi[5]))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{103051268,3313844136,2522428039,4185257943}return SynapseXen_ilIliIIliIlI[3261136891]end)())local SynapseXen_iliiIllIiill=SynapseXen_liliIi;local SynapseXen_IlilIiIiIiIIlllIIIi,SynapseXen_IlIlIllllliIiIIi;local SynapseXen_IIIiliIll;if SynapseXen_iIIiI==1 then return elseif SynapseXen_iIIiI==0 then SynapseXen_IIIiliIll=SynapseXen_IllllilIIiilIlI else SynapseXen_IIIiliIll=SynapseXen_IIIiil+SynapseXen_iIIiI-2 end;SynapseXen_IlIlIllllliIiIIi={}SynapseXen_IlilIiIiIiIIlllIIIi=0;for SynapseXen_IiiIi=SynapseXen_IIIiil,SynapseXen_IIIiliIll do SynapseXen_IlilIiIiIiIIlllIIIi=SynapseXen_IlilIiIiIiIIlllIIIi+1;SynapseXen_IlIlIllllliIiIIi[SynapseXen_IlilIiIiIiIIlllIIIi]=SynapseXen_iliiIllIiill[SynapseXen_IiiIi]end;return SynapseXen_IlIlIllllliIiIIi,SynapseXen_IlilIiIiIiIIlllIIIi elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[1471120964]or(function()local SynapseXen_liIllIlIiiIIiI="baby i just fell for uwu,,,,,, i wanna be with uwu!11!!"SynapseXen_ilIliIIliIlI[1471120964]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(986832272,3802521695),SynapseXen_lIliililllIlillIliI(1379612959,SynapseXen_ilIilIiIlIiIIillIi[5]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3574174859,3668165773}return SynapseXen_ilIliIIliIlI[1471120964]end)())then local SynapseXen_iIIiI=SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[907546298]or(function()local SynapseXen_liIllIlIiiIIiI="inb4 posted on exploit reports section"SynapseXen_ilIliIIliIlI[907546298]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2285408247,605480859),SynapseXen_lIliililllIlillIliI(348600613,SynapseXen_ilIilIiIlIiIIillIi[4]))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{2136664070,820457824}return SynapseXen_ilIliIIliIlI[907546298]end)(),512)local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_liliilIl(SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[1782486315]or(function()local SynapseXen_liIllIlIiiIIiI="pain is gonna use the backspace method on xen"SynapseXen_ilIliIIliIlI[1782486315]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(604383823,2035133171),SynapseXen_lIliililllIlillIliI(2214415951,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3614669133,3624754251,3045311947,4020721917,1087046245,3415064432,3607765344}return SynapseXen_ilIliIIliIlI[1782486315]end)()),SynapseXen_IIIIliiiiiI,512)local SynapseXen_iliiIllIiill=SynapseXen_liliIi;if SynapseXen_iIIiI>255 then SynapseXen_iIIiI=SynapseXen_iiIIIIliiI[SynapseXen_iIIiI-256]else SynapseXen_iIIiI=SynapseXen_iliiIllIiill[SynapseXen_iIIiI]end;if SynapseXen_iiliIiiiiIlIIiIiIlli>255 then SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iiIIIIliiI[SynapseXen_iiliIiiiiIlIIiIiIlli-256]else SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iliiIllIiill[SynapseXen_iiliIiiiiIlIIiIiIlli]end;SynapseXen_iliiIllIiill[SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[3692163025]or(function()local SynapseXen_liIllIlIiiIIiI="i put more time into this shitty list of dead memes then i did into the obfuscator itself"SynapseXen_ilIliIIliIlI[3692163025]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(247578679,2499048255),SynapseXen_lIliililllIlillIliI(3422502791,SynapseXen_ilIilIiIlIiIIillIi[3]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3872796100,1874939561,3796492002,1602444443,986350013,2982920152,2755586924,4222840158,3566951655}return SynapseXen_ilIliIIliIlI[3692163025]end)(),256)]=SynapseXen_iIIiI*SynapseXen_iiliIiiiiIlIIiIiIlli elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[1580978528]or(function(...)local SynapseXen_liIllIlIiiIIiI="sometimes it be like that"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3943118885,3368899233)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(3232181112,1062789263)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1580978528]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1951108544,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2302063176,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1689895970,1265337043,2848676014,267287497,909792444}return SynapseXen_ilIliIIliIlI[1580978528]end)("IlillliIlIIlI",8569,{},13128,{},{},"Il","Iil",{},{}))then SynapseXen_iIilI[SynapseXen_iiIIIIliiI[SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1831871741],SynapseXen_ilIliIIliIlI[624869852]or(function()local SynapseXen_liIllIlIiiIIiI="now with shitty xor string obfuscation"SynapseXen_ilIliIIliIlI[624869852]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3065521525,832320000),SynapseXen_lIliililllIlillIliI(2063393279,SynapseXen_ilIilIiIlIiIIillIi[7]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{631069153,2312341482,2338619485,2600573404}return SynapseXen_ilIliIIliIlI[624869852]end)())]]=SynapseXen_liliIi[SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[1898708482]or(function()local SynapseXen_liIllIlIiiIIiI="imagine using some lua minifier tool and thinking you are a badass"SynapseXen_ilIliIIliIlI[1898708482]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3802856081,2145909406),SynapseXen_lIliililllIlillIliI(1140607576,SynapseXen_lliilli))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{3533783122,3470060331,1886468636,1585460533,1270555821}return SynapseXen_ilIliIIliIlI[1898708482]end)(),256)]elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[2090155115]or(function(...)local SynapseXen_liIllIlIiiIIiI="pain exist is gonna connect the dots of xen"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(502086308,1635380392)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(175682593,4119283281)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2090155115]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(516610097,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3669411634,SynapseXen_ilIilIiIlIiIIillIi[4]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1237165167,1643528186,2669249330,2059268103,2833727987,715667737}return SynapseXen_ilIliIIliIlI[2090155115]end)({},7528,4244))then local SynapseXen_IIIiil=SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[3224037237]or(function(...)local SynapseXen_liIllIlIiiIIiI="hi xen crashes on my axon paste plz help"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(1270612604,80491380)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(925159987,3369819304)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[3224037237]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(4199651823,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1805074214,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2200958709,156687962,2649100244,1886743860,768099646,3644556582,2001616401,2587302721}return SynapseXen_ilIliIIliIlI[3224037237]end)({},5184,"iIiIliliIllIillI","lIliilIIlli"),256)~=0;local SynapseXen_iIIiI=SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[3899043265]or(function(...)local SynapseXen_liIllIlIiiIIiI="now comes with a free n word pass"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(1318955200,1315247180)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1579000609,2715945436)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[3899043265]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(67238396,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3155514271,SynapseXen_ilIilIiIlIiIIillIi[4]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{851594608,689977805,3731307104,838704655,3105885778,3765978411,2408961333,1241688627,2594071185,2420803943}return SynapseXen_ilIliIIliIlI[3899043265]end)("IilIiliIilIII",2295,13809,"iiliIiillIiIlllIill",10412,7213,8494,{},"lliiliIliiIlii",{}),512)local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[2666519298]or(function(...)local SynapseXen_liIllIlIiiIIiI="sponsored by ironbrew, jk xen is better"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(667997362,1971128882)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(3530558313,764403807)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2666519298]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2429310162,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2070497806,SynapseXen_ilIilIiIlIiIIillIi[1]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3870711108,986387160,243894840}return SynapseXen_ilIliIIliIlI[2666519298]end)("I",{}),512)local SynapseXen_iliiIllIiill=SynapseXen_liliIi;if SynapseXen_iIIiI>255 then SynapseXen_iIIiI=SynapseXen_iiIIIIliiI[SynapseXen_iIIiI-256]else SynapseXen_iIIiI=SynapseXen_iliiIllIiill[SynapseXen_iIIiI]end;if SynapseXen_iiliIiiiiIlIIiIiIlli>255 then SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iiIIIIliiI[SynapseXen_iiliIiiiiIlIIiIiIlli-256]else SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iliiIllIiill[SynapseXen_iiliIiiiiIlIIiIiIlli]end;if SynapseXen_iIIiI<SynapseXen_iiliIiiiiIlIIiIiIlli~=SynapseXen_IIIiil then SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+1 end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[3662937590]or(function()local SynapseXen_liIllIlIiiIIiI="wow xen is shit buy luraph ok"SynapseXen_ilIliIIliIlI[3662937590]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(26530541,4090557048),SynapseXen_lIliililllIlillIliI(261740059,SynapseXen_ilIilIiIlIiIIillIi[7]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3236395400,4237718373,2163503676,1751936646,2403227906}return SynapseXen_ilIliIIliIlI[3662937590]end)())then SynapseXen_liliIi[SynapseXen_liliilIl(SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[1458223423]or(function(...)local SynapseXen_liIllIlIiiIIiI="thats how mafia works"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2256109883,2301770571)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1699040528,2595926846)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1458223423]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2097635382,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2902159401,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{819371208,2363529111,2945979192,862096109,1821330093,258878999,1539726595}return SynapseXen_ilIliIIliIlI[1458223423]end)("liliiIiI",{},{},11418,{},9684,{}),256),SynapseXen_IIIIliiiiiI,256)]=#SynapseXen_liliIi[SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[1705979093]or(function()local SynapseXen_liIllIlIiiIIiI="level 1 crook = luraph, level 100 boss = xen"SynapseXen_ilIliIIliIlI[1705979093]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3362765158,96433152),SynapseXen_lIliililllIlillIliI(1791169092,SynapseXen_ilIilIiIlIiIIillIi[6]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{4043178282,3644424845,1510660855,1692792066}return SynapseXen_ilIliIIliIlI[1705979093]end)())]elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[3791533502]or(function()local SynapseXen_liIllIlIiiIIiI="print(bytecode)"SynapseXen_ilIliIIliIlI[3791533502]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2843931199,2901009604),SynapseXen_lIliililllIlillIliI(2401773725,SynapseXen_ilIilIiIlIiIIillIi[5]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{4145127412,3003994949,371106021,1310375092,2525084242,2890527990}return SynapseXen_ilIliIIliIlI[3791533502]end)())then SynapseXen_IIIIliiiiiI=SynapseXen_liliIi[SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[2268053108]or(function()local SynapseXen_liIllIlIiiIIiI="this is so sad, alexa play ripull.mp4"SynapseXen_ilIliIIliIlI[2268053108]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3300454384,429498482),SynapseXen_lIliililllIlillIliI(59776446,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3259706596,3182202275,477966630,304193369,710456194}return SynapseXen_ilIliIIliIlI[2268053108]end)(),256)]elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[1045218855]or(function()local SynapseXen_liIllIlIiiIIiI="skisploit is the superior obfuscator, clearly."SynapseXen_ilIliIIliIlI[1045218855]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3991777247,4130174118),SynapseXen_lIliililllIlillIliI(3312585348,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{158274514,2145778601,823040983}return SynapseXen_ilIliIIliIlI[1045218855]end)())then local SynapseXen_iIIiI=SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[1545454742]or(function()local SynapseXen_liIllIlIiiIIiI="wally bad bird"SynapseXen_ilIliIIliIlI[1545454742]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(661509511,3935703592),SynapseXen_lIliililllIlillIliI(2620560603,SynapseXen_ilIilIiIlIiIIillIi[3]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{365723501,2954874540,4150777742,437815842,3259415001,784786712,4001042405,3346444550}return SynapseXen_ilIliIIliIlI[1545454742]end)(),512)local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[3742946275]or(function()local SynapseXen_liIllIlIiiIIiI="https://twitter.com/Ripull_RBLX/status/1059334518581145603"SynapseXen_ilIliIIliIlI[3742946275]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1058511502,1756885918),SynapseXen_lIliililllIlillIliI(4014426918,SynapseXen_ilIilIiIlIiIIillIi[4]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{788807955,1496985252,3831484238,2794083896,1929990997}return SynapseXen_ilIliIIliIlI[3742946275]end)(),512)local SynapseXen_iliiIllIiill=SynapseXen_liliIi;if SynapseXen_iIIiI>255 then SynapseXen_iIIiI=SynapseXen_iiIIIIliiI[SynapseXen_iIIiI-256]else SynapseXen_iIIiI=SynapseXen_iliiIllIiill[SynapseXen_iIIiI]end;if SynapseXen_iiliIiiiiIlIIiIiIlli>255 then SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iiIIIIliiI[SynapseXen_iiliIiiiiIlIIiIiIlli-256]else SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iliiIllIiill[SynapseXen_iiliIiiiiIlIIiIiIlli]end;SynapseXen_iliiIllIiill[SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[433354917]or(function(...)local SynapseXen_liIllIlIiiIIiI="so if you'we nyot awawe of expwoiting by this point, you've pwobabwy been wiving undew a wock that the pionyeews used to wide fow miwes. wobwox is often seen as an expwoit-infested gwound by most fwom the suwface, awthough this isn't the case."local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2521279614,530175261)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(301900927,3993073657)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[433354917]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1857669458,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(970525549,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{1007891390,3945497540,18558918}return SynapseXen_ilIliIIliIlI[433354917]end)("Il",14162,"IiliiilIIillIlIi",{},"iIIIIiIiIiiIlll"),256)]=SynapseXen_iIIiI-SynapseXen_iiliIiiiiIlIIiIiIlli elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[353022679]or(function(...)local SynapseXen_liIllIlIiiIIiI="sometimes it be like that"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2321072349,4164129144)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2532934267,1762000435)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[353022679]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1999735709,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2400832178,SynapseXen_ilIilIiIlIiIIillIi[5]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1457840743,284950877,3126801898,3648412662,1124502861,1390415251,1516061934}return SynapseXen_ilIliIIliIlI[353022679]end)(12296,335,5352,{},439))then local SynapseXen_IIIiil=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[1759155261]or(function(...)local SynapseXen_liIllIlIiiIIiI="imagine using some lua minifier tool and thinking you are a badass"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2204623484,117391047)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(611464165,3683513839)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1759155261]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1737682218,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(534308646,SynapseXen_ilIilIiIlIiIIillIi[7]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3415878166,2880164678,1289771896,609121387,2993005493,1765604946,521402527,3412961992,1536996743}return SynapseXen_ilIliIIliIlI[1759155261]end)("I"))local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[867765472]or(function()local SynapseXen_liIllIlIiiIIiI="now with shitty xor string obfuscation"SynapseXen_ilIliIIliIlI[867765472]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(4229181342,354970486),SynapseXen_lIliililllIlillIliI(931307814,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1893791070,3898624374,1621825768,2345391160,2613813237,2410535899,1058896967,3704368062,1603811294}return SynapseXen_ilIliIIliIlI[867765472]end)(),512)local SynapseXen_iliiIllIiill=SynapseXen_liliIi;local SynapseXen_iiIiIiIlIiliIlIi=SynapseXen_IIIiil+2;local SynapseXen_IIlIiiillIl={SynapseXen_iliiIllIiill[SynapseXen_IIIiil](SynapseXen_iliiIllIiill[SynapseXen_IIIiil+1],SynapseXen_iliiIllIiill[SynapseXen_IIIiil+2])}for SynapseXen_IiiIi=1,SynapseXen_iiliIiiiiIlIIiIiIlli do SynapseXen_liliIi[SynapseXen_iiIiIiIlIiliIlIi+SynapseXen_IiiIi]=SynapseXen_IIlIiiillIl[SynapseXen_IiiIi]end;if SynapseXen_iliiIllIiill[SynapseXen_IIIiil+3]~=nil then SynapseXen_iliiIllIiill[SynapseXen_IIIiil+2]=SynapseXen_iliiIllIiill[SynapseXen_IIIiil+3]else SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+1 end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[2833416934]or(function()local SynapseXen_liIllIlIiiIIiI="aspect network better obfuscator"SynapseXen_ilIliIIliIlI[2833416934]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3980605134,1325377384),SynapseXen_lIliililllIlillIliI(704522968,SynapseXen_ilIilIiIlIiIIillIi[5]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2048103891,4280462440,765725923,3913154779,530299842,3259747713,846748300,3732410467}return SynapseXen_ilIliIIliIlI[2833416934]end)())then SynapseXen_liliIi[SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[4058920788]or(function(...)local SynapseXen_liIllIlIiiIIiI="what are you trying to say? that fucking one dot + dot + dot + many dots is not adding adding 1 dot + dot and then adding all the dots together????"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3692564786,1605160512)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2657717645,1637226470)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[4058920788]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2127639537,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1516797148,SynapseXen_ilIilIiIlIiIIillIi[6]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3458062813,3662512807,3176659705,3138789595,423898080,66131389,821182960,1404678772,2711454688,1635100696}return SynapseXen_ilIliIIliIlI[4058920788]end)("llIiiliIIl","iilllllliiiIlIlilli"))]=SynapseXen_lIilIiiillIilliii[SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[3711804492]or(function()local SynapseXen_liIllIlIiiIIiI="hi devforum"SynapseXen_ilIliIIliIlI[3711804492]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(794317428,2109769338),SynapseXen_lIliililllIlillIliI(2351460186,SynapseXen_lliilli))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{1664972746,2833932306,2982128121,2055648728,1371990505,2966442372,1034617601,776396914,1811037184,273316748}return SynapseXen_ilIliIIliIlI[3711804492]end)())]elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[206176264]or(function()local SynapseXen_liIllIlIiiIIiI="sponsored by ironbrew, jk xen is better"SynapseXen_ilIliIIliIlI[206176264]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3307414777,91699771),SynapseXen_lIliililllIlillIliI(1733943046,SynapseXen_ilIilIiIlIiIIillIi[6]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1844699398,2522834700,4122153226,3729318780}return SynapseXen_ilIliIIliIlI[206176264]end)())then if not not SynapseXen_liliIi[SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[2575454988]or(function(...)local SynapseXen_liIllIlIiiIIiI="xen doesn't come with instance caching, sorry superskater"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2433569592,442132528)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2500086673,1794875561)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2575454988]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2515189916,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2790662590,SynapseXen_ilIilIiIlIiIIillIi[4]))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{1570661422,175775387,3551199785,4201900453,2346432987,366461177,732438412}return SynapseXen_ilIliIIliIlI[2575454988]end)("iiIiIl",12325,13449,"IililIilIllIllI","iiliIiiIilIii",2005),256)]==(SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[1245453742]or(function(...)local SynapseXen_liIllIlIiiIIiI="level 1 crook = luraph, level 100 boss = xen"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(293145789,427777156)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1239874225,3055081050)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1245453742]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3501071655,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2141510090,SynapseXen_ilIilIiIlIiIIillIi[6]))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{3403722076,1751655817,4216794737,649372441,3402349334,1478630319,4122027765,1874820523,2606267087,836326647}return SynapseXen_ilIliIIliIlI[1245453742]end)("iIiIiIII",6018,{},"iii",{},2720,{},{},{},"iI"),512)==0)then SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+1 end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[1257622822]or(function()local SynapseXen_liIllIlIiiIIiI="skisploit is the superior obfuscator, clearly."SynapseXen_ilIliIIliIlI[1257622822]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1404673750,349688956),SynapseXen_lIliililllIlillIliI(2581362746,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1229940003,1096445340,997984493,2642866774,3663287765,2902724260}return SynapseXen_ilIliIIliIlI[1257622822]end)())then local SynapseXen_IIIiil=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[1348216260]or(function(...)local SynapseXen_liIllIlIiiIIiI="wow xen is shit buy luraph ok"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2579657207,180070200)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(491101834,3803867698)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1348216260]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2009617785,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3044985707,SynapseXen_ilIilIiIlIiIIillIi[3]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3571629954,550004313,1539888101,2943000038,225254709}return SynapseXen_ilIliIIliIlI[1348216260]end)("Illl",{},{},{},"IliliilllIlIIi"))~=0;local SynapseXen_iIIiI=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[402630330]or(function(...)local SynapseXen_liIllIlIiiIIiI="now comes with a free n word pass"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3490716438,626867823)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(3298196311,996737804)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[402630330]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2985167897,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2584999270,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1007622676,4224229517,2574504344,1747984238,1236013617,3332691957,3630965931,3497168689}return SynapseXen_ilIliIIliIlI[402630330]end)("lIiIIII",5397))local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[1734589326]or(function()local SynapseXen_liIllIlIiiIIiI="xen detects custom getfenv"SynapseXen_ilIliIIliIlI[1734589326]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1475818921,2071843613),SynapseXen_lIliililllIlillIliI(4064018198,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3976656399,2547832809,1332714519,1297487064,3586178220,490289426}return SynapseXen_ilIliIIliIlI[1734589326]end)()),SynapseXen_IIIIliiiiiI)local SynapseXen_iliiIllIiill=SynapseXen_liliIi;if SynapseXen_iIIiI>255 then SynapseXen_iIIiI=SynapseXen_iiIIIIliiI[SynapseXen_iIIiI-256]else SynapseXen_iIIiI=SynapseXen_iliiIllIiill[SynapseXen_iIIiI]end;if SynapseXen_iiliIiiiiIlIIiIiIlli>255 then SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iiIIIIliiI[SynapseXen_iiliIiiiiIlIIiIiIlli-256]else SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iliiIllIiill[SynapseXen_iiliIiiiiIlIIiIiIlli]end;if SynapseXen_iIIiI<=SynapseXen_iiliIiiiiIlIIiIiIlli~=SynapseXen_IIIiil then SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+1 end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[4148779147]or(function()local SynapseXen_liIllIlIiiIIiI="luraph better then xen bros :pensive:"SynapseXen_ilIliIIliIlI[4148779147]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3741879374,3461906965),SynapseXen_lIliililllIlillIliI(1084183694,SynapseXen_ilIilIiIlIiIIillIi[3]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1660509894}return SynapseXen_ilIliIIliIlI[4148779147]end)())then SynapseXen_liliIi[SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[4142007080]or(function()local SynapseXen_liIllIlIiiIIiI="now with shitty xor string obfuscation"SynapseXen_ilIliIIliIlI[4142007080]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(537874314,3966731768),SynapseXen_lIliililllIlillIliI(315646839,SynapseXen_lliilli))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{2793436972,3115449825,3660613463,1399045601,95068738,2392789551,3887006600,3320205886,3552648804,2352390135}return SynapseXen_ilIliIIliIlI[4142007080]end)(),256)]=SynapseXen_iIllili(SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[4086093011]or(function()local SynapseXen_liIllIlIiiIIiI="this is a christian obfuscator, no cursing allowed in our scripts"SynapseXen_ilIliIIliIlI[4086093011]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3110171335,239026452),SynapseXen_lIliililllIlillIliI(263569850,SynapseXen_ilIilIiIlIiIIillIi[4]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3538027642,1443677012,65503102,1062052853,1287779469}return SynapseXen_ilIliIIliIlI[4086093011]end)(),512),SynapseXen_IIIIliiiiiI,512)~=0;if SynapseXen_iIllili(SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[3583794972]or(function()local SynapseXen_liIllIlIiiIIiI="xen doesn't come with instance caching, sorry superskater"SynapseXen_ilIliIIliIlI[3583794972]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3020947325,1901834539),SynapseXen_lIliililllIlillIliI(778718730,SynapseXen_ilIilIiIlIiIIillIi[2]))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{2037342485,3018977858,3343461014,4205500098}return SynapseXen_ilIliIIliIlI[3583794972]end)(),512),SynapseXen_IIIIliiiiiI,512)~=0 then SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+1 end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[2126126127]or(function(...)local SynapseXen_liIllIlIiiIIiI="epic gamer vision"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(1347477971,4200244298)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(561582567,3733386025)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2126126127]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3869901765,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2450563947,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{732420972,3473920525,1325899579,1191061526,901527855,3305346511,369780788,449370358}return SynapseXen_ilIliIIliIlI[2126126127]end)("l","iIiIIiIIIlillIiIII",{},{},"ilIIIIiIIIilIII",2507,"IlIliiIlIiililI"))then SynapseXen_liliIi[SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[217022154]or(function(...)local SynapseXen_liIllIlIiiIIiI="xen detects custom getfenv"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3316780555,2766343600)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(464119858,3830820775)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[217022154]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(553125060,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2669172522,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{4004484757,3540875874,4064718558,3243523780,1939138832,407668242,2438118764,1421670808}return SynapseXen_ilIliIIliIlI[217022154]end)(11127,"iIIillIliiiIl","lIi",5676,"iilIlIiili",{},{},10193,7007),256)]=SynapseXen_iIilI[SynapseXen_iiIIIIliiI[SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1831871741],SynapseXen_ilIliIIliIlI[316586071]or(function()local SynapseXen_liIllIlIiiIIiI="baby i just fell for uwu,,,,,, i wanna be with uwu!11!!"SynapseXen_ilIliIIliIlI[316586071]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(695911372,2156039664),SynapseXen_lIliililllIlillIliI(2001461052,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{135439890,2454742169,2746723237,2146883675,3733704246,2975145822,1964337030}return SynapseXen_ilIliIIliIlI[316586071]end)(),262144)]]elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[397344719]or(function(...)local SynapseXen_liIllIlIiiIIiI="thats how mafia works"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3848100518,1106687150)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1421646458,2873301474)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[397344719]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2893840366,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3596738947,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2639033653,1162281491,3708482715,71044814}return SynapseXen_ilIliIIliIlI[397344719]end)({},{},{},"liIIIlilIliiiiIlllI",{},"lIlilillilIiiiI","lIiIIIIiIllilll",13455))then local SynapseXen_iliiIllIiill=SynapseXen_liliIi;local SynapseXen_iIIiI=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[677850325]or(function(...)local SynapseXen_liIllIlIiiIIiI="SYNAPSE XEN [FE BYPASS] [BETTER THEN LURAPH] [AMAZING] OMG OMG OMG !!!!!!"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3501187382,1906810511)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(598533520,3696402327)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[677850325]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3718779663,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2717985647,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{3919363680,3322916936,534088508,483315168,3551120435}return SynapseXen_ilIliIIliIlI[677850325]end)("illilIlIllIlliiliIl",{},1635,{}))local SynapseXen_liiIilllilllIii=SynapseXen_iliiIllIiill[SynapseXen_iIIiI]for SynapseXen_IiiIi=SynapseXen_iIIiI+1,SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[2643774473]or(function(...)local SynapseXen_liIllIlIiiIIiI="my way to go against expwoiting is to have safety measuwes. i 1 wocawscwipt and onwy moduwes. hewe's how it wowks: this scwipt bewow stowes the moduwes in a tabwe fow each moduwe we send the wist with the moduwes and moduwe infowmation and use inyit a function in my moduwe that wiww stowe the info and aftew it has send to aww the moduwes it wiww dewete them. so whenyevew the cwient twies to hack they cant get the moduwes. onwy this peace of wocawscwipt."local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(1339325041,2215151596)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2313745808,1981209154)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2643774473]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(4257127427,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3906099377,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{3817132211,1705322625,4196453569,848065442,2918829032,693991310,1414761937,2801192726,2973079704,3827333498}return SynapseXen_ilIliIIliIlI[2643774473]end)("IiIIIIiiiilliiIili",{},5486),512)do SynapseXen_liiIilllilllIii=SynapseXen_liiIilllilllIii..SynapseXen_iliiIllIiill[SynapseXen_IiiIi]end;SynapseXen_liliIi[SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[2065273788]or(function(...)local SynapseXen_liIllIlIiiIIiI="pain exist is gonna connect the dots of xen"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2587642350,1674064753)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(996078461,3298864207)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2065273788]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2230901074,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2746358755,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3545128976,1880854222}return SynapseXen_ilIliIIliIlI[2065273788]end)("lIIiIlliIlIiI","IiIiillliliii","iiliIIllIiII"))]=SynapseXen_liiIilllilllIii elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[1365033632]or(function()local SynapseXen_liIllIlIiiIIiI="sponsored by ironbrew, jk xen is better"SynapseXen_ilIliIIliIlI[1365033632]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(812304451,1092172979),SynapseXen_lIliililllIlillIliI(3598204123,SynapseXen_ilIilIiIlIiIIillIi[6]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{148540428,2977422065,763796737,1736246421,1201585606,1711711180,1935615584,816597875,2082721517,2816582654}return SynapseXen_ilIliIIliIlI[1365033632]end)())then local SynapseXen_IIIiil=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[2609071610]or(function(...)local SynapseXen_liIllIlIiiIIiI="hi xen doesn't work on sk8r please help"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2907597863,1200120069)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(3151424703,1143524805)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2609071610]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2011797320,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1133681841,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{297153821,4006047562,2578238062,1836813562,2288208672,4099657773,766545602,1082012831}return SynapseXen_ilIliIIliIlI[2609071610]end)(2106,11842,7058,13823,"IIiIl",1357,"IlIIiiIIIliii",{})),SynapseXen_IIIIliiiiiI)local SynapseXen_iliiIllIiill=SynapseXen_liliIi;SynapseXen_iliiIllIiill[SynapseXen_IIIiil]=assert(tonumber(SynapseXen_iliiIllIiill[SynapseXen_IIIiil]),'`for` initial value must be a number')SynapseXen_iliiIllIiill[SynapseXen_IIIiil+1]=assert(tonumber(SynapseXen_iliiIllIiill[SynapseXen_IIIiil+1]),'`for` limit must be a number')SynapseXen_iliiIllIiill[SynapseXen_IIIiil+2]=assert(tonumber(SynapseXen_iliiIllIiill[SynapseXen_IIIiil+2]),'`for` step must be a number')SynapseXen_iliiIllIiill[SynapseXen_IIIiil]=SynapseXen_iliiIllIiill[SynapseXen_IIIiil]-SynapseXen_iliiIllIiill[SynapseXen_IIIiil+2]SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+SynapseXen_iIIIllIiIIiIlil[1571690726]elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[513281142]or(function(...)local SynapseXen_liIllIlIiiIIiI="wow xen is shit buy luraph ok"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2448554476,759063793)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(3739215230,555730179)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[513281142]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3004773664,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3067975939,SynapseXen_ilIilIiIlIiIIillIi[1]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3703226031}return SynapseXen_ilIliIIliIlI[513281142]end)(2058,{},{},{},"IlIiilI","IIIIIIiI",12944,852))then SynapseXen_liliIi[SynapseXen_lIliililllIlillIliI(SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[1708560649]or(function(...)local SynapseXen_liIllIlIiiIIiI="pain is gonna use the backspace method on xen"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(4071530698,1523297737)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1226862783,3068091209)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1708560649]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(414787294,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1852659205,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{4117398984,2520157631,2580415619,2337000615,2972284984}return SynapseXen_ilIliIIliIlI[1708560649]end)({},3140,9698,{},"illiiiIil"),256),SynapseXen_IIIIliiiiiI)]=SynapseXen_iiIIIIliiI[SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1831871741],SynapseXen_ilIliIIliIlI[2824469488]or(function(...)local SynapseXen_liIllIlIiiIIiI="hi xen crashes on my axon paste plz help"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2928084900,1720441715)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2669131204,1625834198)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2824469488]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1278428059,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1519304029,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{3594686968,1032830217,2197231064,2509142644,2250687515}return SynapseXen_ilIliIIliIlI[2824469488]end)({},10626,4202,2704,5453,{}),262144)]elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[2211939518]or(function()local SynapseXen_liIllIlIiiIIiI="aspect network better obfuscator"SynapseXen_ilIliIIliIlI[2211939518]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1150799212,3217366320),SynapseXen_lIliililllIlillIliI(109150591,SynapseXen_ilIilIiIlIiIIillIi[7]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2641900142,3920941145,2354780055,928505989,236537033,2829707019}return SynapseXen_ilIliIIliIlI[2211939518]end)())then SynapseXen_liliIi[SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[2926280306]or(function(...)local SynapseXen_liIllIlIiiIIiI="SECURE API, IMPOSSIBLE TO BYPASS!"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3626119185,489960031)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(4031815186,263155036)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2926280306]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1021750510,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(658949563,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{1435431073,2315416731,2578225394,3669670546,554815489,4177405728,3469939776,3955115819}return SynapseXen_ilIliIIliIlI[2926280306]end)("liIIlIlillliI",{},"ilIIIII","lIIIlilliiiIiiilIi",13226,4898,"IIllIiIlI"))]={}elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[1182479351]or(function()local SynapseXen_liIllIlIiiIIiI="hi xen doesn't work on sk8r please help"SynapseXen_ilIliIIliIlI[1182479351]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(389344964,78100821),SynapseXen_lIliililllIlillIliI(3441561841,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{4029295721,2724923347,3861788386,2598194259,634130509,2989811388,1615553443}return SynapseXen_ilIliIIliIlI[1182479351]end)())then local SynapseXen_IIIiil=SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[3060335667]or(function()local SynapseXen_liIllIlIiiIIiI="pain exist is gonna connect the dots of xen"SynapseXen_ilIliIIliIlI[3060335667]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1107958920,1746464534),SynapseXen_lIliililllIlillIliI(4104265054,SynapseXen_lliilli))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{22864587,2258820673,3162743539,525111357,1693568524,3941492343,1772391381,1344778795}return SynapseXen_ilIliIIliIlI[3060335667]end)(),256)local SynapseXen_iIIiI=SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[2619883537]or(function(...)local SynapseXen_liIllIlIiiIIiI="my way to go against expwoiting is to have safety measuwes. i 1 wocawscwipt and onwy moduwes. hewe's how it wowks: this scwipt bewow stowes the moduwes in a tabwe fow each moduwe we send the wist with the moduwes and moduwe infowmation and use inyit a function in my moduwe that wiww stowe the info and aftew it has send to aww the moduwes it wiww dewete them. so whenyevew the cwient twies to hack they cant get the moduwes. onwy this peace of wocawscwipt."local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2598221307,3479588518)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(254016987,4040917703)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2619883537]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3356773498,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1126086720,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{3811657437}return SynapseXen_ilIliIIliIlI[2619883537]end)("lIlIillIiil"),512)local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iIllili(SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[2027816744]or(function()local SynapseXen_liIllIlIiiIIiI="thats how mafia works"SynapseXen_ilIliIIliIlI[2027816744]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1251295904,2458505179),SynapseXen_lIliililllIlillIliI(1381920499,SynapseXen_ilIilIiIlIiIIillIi[5]))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{2822220762,1053916558,3242302172,4062375730,3264418595,2146715911,2563689227}return SynapseXen_ilIliIIliIlI[2027816744]end)()),SynapseXen_IIIIliiiiiI,512)local SynapseXen_iliiIllIiill=SynapseXen_liliIi;local SynapseXen_IilIiiIIiii,SynapseXen_liIlilliiIllIII;local SynapseXen_IIIiliIll,SynapseXen_IlilIiIiIiIIlllIIIi;SynapseXen_IilIiiIIiii={}if SynapseXen_iIIiI~=1 then if SynapseXen_iIIiI~=0 then SynapseXen_IIIiliIll=SynapseXen_IIIiil+SynapseXen_iIIiI-1 else SynapseXen_IIIiliIll=SynapseXen_IllllilIIiilIlI end;SynapseXen_IlilIiIiIiIIlllIIIi=0;for SynapseXen_IiiIi=SynapseXen_IIIiil+1,SynapseXen_IIIiliIll do SynapseXen_IlilIiIiIiIIlllIIIi=SynapseXen_IlilIiIiIiIIlllIIIi+1;SynapseXen_IilIiiIIiii[SynapseXen_IlilIiIiIiIIlllIIIi]=SynapseXen_iliiIllIiill[SynapseXen_IiiIi]end;SynapseXen_IIIiliIll,SynapseXen_liIlilliiIllIII=SynapseXen_iIIlIliIIliIiiIil(SynapseXen_iliiIllIiill[SynapseXen_IIIiil](unpack(SynapseXen_IilIiiIIiii,1,SynapseXen_IIIiliIll-SynapseXen_IIIiil)))else SynapseXen_IIIiliIll,SynapseXen_liIlilliiIllIII=SynapseXen_iIIlIliIIliIiiIil(SynapseXen_iliiIllIiill[SynapseXen_IIIiil]())end;SynapseXen_IllllilIIiilIlI=SynapseXen_IIIiil-1;if SynapseXen_iiliIiiiiIlIIiIiIlli~=1 then if SynapseXen_iiliIiiiiIlIIiIiIlli~=0 then SynapseXen_IIIiliIll=SynapseXen_IIIiil+SynapseXen_iiliIiiiiIlIIiIiIlli-2 else SynapseXen_IIIiliIll=SynapseXen_IIIiliIll+SynapseXen_IIIiil-1 end;SynapseXen_IlilIiIiIiIIlllIIIi=0;for SynapseXen_IiiIi=SynapseXen_IIIiil,SynapseXen_IIIiliIll do SynapseXen_IlilIiIiIiIIlllIIIi=SynapseXen_IlilIiIiIiIIlllIIIi+1;SynapseXen_iliiIllIiill[SynapseXen_IiiIi]=SynapseXen_liIlilliiIllIII[SynapseXen_IlilIiIiIiIIlllIIIi]end end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[1066583581]or(function()local SynapseXen_liIllIlIiiIIiI="yed"SynapseXen_ilIliIIliIlI[1066583581]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2051532702,1433803388),SynapseXen_lIliililllIlillIliI(4052518771,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3843347550}return SynapseXen_ilIliIIliIlI[1066583581]end)())then if SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1831871741],SynapseXen_ilIliIIliIlI[3215805118]or(function()local SynapseXen_liIllIlIiiIIiI="inb4 posted on exploit reports section"SynapseXen_ilIliIIliIlI[3215805118]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1366245455,2609364720),SynapseXen_lIliililllIlillIliI(1912660215,SynapseXen_ilIilIiIlIiIIillIi[4]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1637086808,3455329210,3998998975,3500319426,4257029723,4256935555}return SynapseXen_ilIliIIliIlI[3215805118]end)(),262144)==(SynapseXen_ilIliIIliIlI[194677144]or(function()local SynapseXen_liIllIlIiiIIiI="my way to go against expwoiting is to have safety measuwes. i 1 wocawscwipt and onwy moduwes. hewe's how it wowks: this scwipt bewow stowes the moduwes in a tabwe fow each moduwe we send the wist with the moduwes and moduwe infowmation and use inyit a function in my moduwe that wiww stowe the info and aftew it has send to aww the moduwes it wiww dewete them. so whenyevew the cwient twies to hack they cant get the moduwes. onwy this peace of wocawscwipt."SynapseXen_ilIliIIliIlI[194677144]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(822157878,4018845153),SynapseXen_lIliililllIlillIliI(1736963440,SynapseXen_ilIilIiIlIiIIillIi[1]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2423910060,4088407508,505381089,2912241262,4138221864,692638840}return SynapseXen_ilIliIIliIlI[194677144]end)())then SynapseXen_liliIi[SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[383611076]or(function()local SynapseXen_liIllIlIiiIIiI="https://twitter.com/Ripull_RBLX/status/1059334518581145603"SynapseXen_ilIliIIliIlI[383611076]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(910494356,2249125909),SynapseXen_lIliililllIlillIliI(1301347667,SynapseXen_ilIilIiIlIiIIillIi[7]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1366309002,3882803247}return SynapseXen_ilIliIIliIlI[383611076]end)(),256)]=SynapseXen_lliilli else SynapseXen_liliIi[SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[383611076]or(function()local SynapseXen_liIllIlIiiIIiI="https://twitter.com/Ripull_RBLX/status/1059334518581145603"SynapseXen_ilIliIIliIlI[383611076]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(910494356,2249125909),SynapseXen_lIliililllIlillIliI(1301347667,SynapseXen_ilIilIiIlIiIIillIi[7]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1366309002,3882803247}return SynapseXen_ilIliIIliIlI[383611076]end)(),256)]=SynapseXen_ilIilIiIlIiIIillIi[SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1831871741],SynapseXen_ilIliIIliIlI[3215805118]or(function()local SynapseXen_liIllIlIiiIIiI="inb4 posted on exploit reports section"SynapseXen_ilIliIIliIlI[3215805118]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1366245455,2609364720),SynapseXen_lIliililllIlillIliI(1912660215,SynapseXen_ilIilIiIlIiIIillIi[4]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1637086808,3455329210,3998998975,3500319426,4257029723,4256935555}return SynapseXen_ilIliIIliIlI[3215805118]end)(),262144)]end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[2424586073]or(function()local SynapseXen_liIllIlIiiIIiI="hi devforum"SynapseXen_ilIliIIliIlI[2424586073]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(889922105,3928100670),SynapseXen_lIliililllIlillIliI(873238346,SynapseXen_ilIilIiIlIiIIillIi[2]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3740965388,1041325678,3020088198,132465179,1788441998,2484474754,3908122406}return SynapseXen_ilIliIIliIlI[2424586073]end)())then local SynapseXen_IIIiil=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[4194990463]or(function()local SynapseXen_liIllIlIiiIIiI="so if you'we nyot awawe of expwoiting by this point, you've pwobabwy been wiving undew a wock that the pionyeews used to wide fow miwes. wobwox is often seen as an expwoit-infested gwound by most fwom the suwface, awthough this isn't the case."SynapseXen_ilIliIIliIlI[4194990463]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2726721311,55790881),SynapseXen_lIliililllIlillIliI(417185612,SynapseXen_ilIilIiIlIiIIillIi[1]))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{2433843629,65933390,2395981040,768070192,1125556066,2735048159}return SynapseXen_ilIliIIliIlI[4194990463]end)())local SynapseXen_iIIiI=SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[39336467]or(function()local SynapseXen_liIllIlIiiIIiI="wally bad bird"SynapseXen_ilIliIIliIlI[39336467]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3881252513,1277238726),SynapseXen_lIliililllIlillIliI(1975968941,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2993421867,3288468207,2632956066}return SynapseXen_ilIliIIliIlI[39336467]end)(),512)local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[2354896726]or(function(...)local SynapseXen_liIllIlIiiIIiI="print(bytecode)"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3457443519,1222678272)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2925097632,1369843824)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2354896726]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(4113504967,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(4187581996,SynapseXen_ilIilIiIlIiIIillIi[5]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{298444198,1880823262,1709634509,4245566438,2649702136,1920583336,881596119}return SynapseXen_ilIliIIliIlI[2354896726]end)(3416,1593,4518,{},{}),512)local SynapseXen_iliiIllIiill=SynapseXen_liliIi;SynapseXen_iIIiI=SynapseXen_iliiIllIiill[SynapseXen_iIIiI]if SynapseXen_iiliIiiiiIlIIiIiIlli>255 then SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iiIIIIliiI[SynapseXen_iiliIiiiiIlIIiIiIlli-256]else SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iliiIllIiill[SynapseXen_iiliIiiiiIlIIiIiIlli]end;SynapseXen_iliiIllIiill[SynapseXen_IIIiil+1]=SynapseXen_iIIiI;SynapseXen_iliiIllIiill[SynapseXen_IIIiil]=SynapseXen_iIIiI[SynapseXen_iiliIiiiiIlIIiIiIlli]elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[760984967]or(function()local SynapseXen_liIllIlIiiIIiI="i'm intercommunication about the most nonecclesiastical dll exploits for esp. they only characterization objects with a antepatriarchal in the geistesgeschichte for the esp."SynapseXen_ilIliIIliIlI[760984967]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1923808069,3392871708),SynapseXen_lIliililllIlillIliI(26878473,SynapseXen_ilIilIiIlIiIIillIi[1]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{788671289,1885259707,1171628989,1684580065,1958439186,1236499981,1182272028,401931271}return SynapseXen_ilIliIIliIlI[760984967]end)())then local SynapseXen_iIIiI=SynapseXen_liliIi[SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[2222640118]or(function()local SynapseXen_liIllIlIiiIIiI="can we have an f in chat for ripull"SynapseXen_ilIliIIliIlI[2222640118]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3613301837,2607579841),SynapseXen_lIliililllIlillIliI(2458035442,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2426365934,3211070863,206050227,2695196211,118915400,1420027478,2871934576}return SynapseXen_ilIliIIliIlI[2222640118]end)(),512)]if not not SynapseXen_iIIiI==(SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[711430351]or(function(...)local SynapseXen_liIllIlIiiIIiI="xen best rerubi paste"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2891643872,2655477274)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(3619512105,675425804)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[711430351]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(798859547,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2546145300,SynapseXen_ilIilIiIlIiIIillIi[5]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{441666512,1762138132}return SynapseXen_ilIliIIliIlI[711430351]end)({},"llliIllIiilIIi"),512)==0)then SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+1 else SynapseXen_liliIi[SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[4221114781]or(function(...)local SynapseXen_liIllIlIiiIIiI="SYNAPSE XEN [FE BYPASS] [BETTER THEN LURAPH] [AMAZING] OMG OMG OMG !!!!!!"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3498124501,1016487419)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1983850947,2311121341)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[4221114781]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(4291285012,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2866289379,SynapseXen_ilIilIiIlIiIIillIi[1]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1708385144}return SynapseXen_ilIliIIliIlI[4221114781]end)(1476,4145,12665,{}))]=SynapseXen_iIIiI end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[1050414598]or(function(...)local SynapseXen_liIllIlIiiIIiI="hi xen crashes on my axon paste plz help"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(1563908331,1344495438)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1968219333,2326753407)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1050414598]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1700760611,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2204983760,SynapseXen_ilIilIiIlIiIIillIi[2]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3273792676}return SynapseXen_ilIliIIliIlI[1050414598]end)({},6425,{},{},14138,"iIiliililliIli",{}))then local SynapseXen_IIIiil=SynapseXen_lIliililllIlillIliI(SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[1695490892]or(function()local SynapseXen_liIllIlIiiIIiI="wow xen is shit buy luraph ok"SynapseXen_ilIliIIliIlI[1695490892]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2578573684,2456486944),SynapseXen_lIliililllIlillIliI(3774758018,SynapseXen_ilIilIiIlIiIIillIi[2]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3656265115,1803625901,2016027738,834277024,2515116913,561421700,1051718695}return SynapseXen_ilIliIIliIlI[1695490892]end)(),256),SynapseXen_IIIIliiiiiI)local SynapseXen_iIIiI=SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[1303525267]or(function(...)local SynapseXen_liIllIlIiiIIiI="level 1 crook = luraph, level 100 boss = xen"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(296498977,221301058)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(4124345666,170595200)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1303525267]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1331433073,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3939197681,SynapseXen_ilIilIiIlIiIIillIi[1]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{203835370,636007386,4058538308,2586197364,171468702}return SynapseXen_ilIliIIliIlI[1303525267]end)(6584),512)local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[242474351]or(function(...)local SynapseXen_liIllIlIiiIIiI="baby i just fell for uwu,,,,,, i wanna be with uwu!11!!"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3253868785,2886583563)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1161651449,3133292693)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[242474351]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(53627919,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3011743160,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2936001167,767984597,2023099273}return SynapseXen_ilIliIIliIlI[242474351]end)({},"ii",{}))local SynapseXen_iliiIllIiill=SynapseXen_liliIi;if SynapseXen_iiliIiiiiIlIIiIiIlli==0 then SynapseXen_IlIIliIIliI=SynapseXen_IlIIliIIliI+1;SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_IlIiIlllllIliil[SynapseXen_IlIIliIIliI][195082471]end;local SynapseXen_iiIiIiIlIiliIlIi=(SynapseXen_iiliIiiiiIlIIiIiIlli-1)*50;local SynapseXen_lililiiI=SynapseXen_iliiIllIiill[SynapseXen_IIIiil]if SynapseXen_iIIiI==0 then SynapseXen_iIIiI=SynapseXen_IllllilIIiilIlI-SynapseXen_IIIiil end;for SynapseXen_IiiIi=1,SynapseXen_iIIiI do SynapseXen_lililiiI[SynapseXen_iiIiIiIlIiliIlIi+SynapseXen_IiiIi]=SynapseXen_iliiIllIiill[SynapseXen_IIIiil+SynapseXen_IiiIi]end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[2138671648]or(function()local SynapseXen_liIllIlIiiIIiI="sometimes it be like that"SynapseXen_ilIliIIliIlI[2138671648]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(2986533865,839386503),SynapseXen_lIliililllIlillIliI(1588953036,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{824702126,2623370066,738475347,799455652,3197353153,2397111001,3118495624}return SynapseXen_ilIliIIliIlI[2138671648]end)())then local SynapseXen_iIIiI=SynapseXen_lIliililllIlillIliI(SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[742857064]or(function(...)local SynapseXen_liIllIlIiiIIiI="sometimes it be like that"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3549467815,57781572)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(519130570,3775836175)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[742857064]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1581119271,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1347657559,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{1554735464,3113172588,96310725,2057418217}return SynapseXen_ilIliIIliIlI[742857064]end)({},{},9718,3497,"iIlliill",6044,"liillIliIlIl",{},1951,{}),512),SynapseXen_IIIIliiiiiI)local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[349407318]or(function(...)local SynapseXen_liIllIlIiiIIiI="pain exist is gonna connect the dots of xen"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(832652689,1926957451)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2123360800,2171574180)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[349407318]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(4110302383,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1765063678,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{4104663829,1776039772,920423177}return SynapseXen_ilIliIIliIlI[349407318]end)({},{},{},7537,"lllllIlIiIiliiIIliI","illlIIIIlIIIllil",11660,{}))local SynapseXen_iliiIllIiill=SynapseXen_liliIi;if SynapseXen_iIIiI>255 then SynapseXen_iIIiI=SynapseXen_iiIIIIliiI[SynapseXen_iIIiI-256]else SynapseXen_iIIiI=SynapseXen_iliiIllIiill[SynapseXen_iIIiI]end;if SynapseXen_iiliIiiiiIlIIiIiIlli>255 then SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iiIIIIliiI[SynapseXen_iiliIiiiiIlIIiIiIlli-256]else SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iliiIllIiill[SynapseXen_iiliIiiiiIlIIiIiIlli]end;SynapseXen_iliiIllIiill[SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[3442435765]or(function(...)local SynapseXen_liIllIlIiiIIiI="now with shitty xor string obfuscation"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(220263686,2301084790)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1147751474,3147211222)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[3442435765]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3413442163,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2445482482,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{958992265,3610073086,612834089,2677979498,1299326423,3677171170,3316567355}return SynapseXen_ilIliIIliIlI[3442435765]end)({},"illIIl","IllIIil",{},"ilIIlIiill","llIIIlllliiiIIilIil"),256)]=SynapseXen_iIIiI%SynapseXen_iiliIiiiiIlIIiIiIlli elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[4162673414]or(function(...)local SynapseXen_liIllIlIiiIIiI="inb4 posted on exploit reports section"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2915869308,1259192772)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2778048260,1516927469)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[4162673414]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1689999950,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(990864047,SynapseXen_ilIilIiIlIiIIillIi[1]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1115306399,3769398089,1101777462,2611618173,1196307275,1070936925,1278262264,3794082364}return SynapseXen_ilIliIIliIlI[4162673414]end)({},4247,{},{},"i",10805,"lilIIIlIiiIIlIi","IIIiil",{},"iiIiilliiiiIIl"))then local SynapseXen_iIIiI=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[3155474351]or(function()local SynapseXen_liIllIlIiiIIiI="baby i just fell for uwu,,,,,, i wanna be with uwu!11!!"SynapseXen_ilIliIIliIlI[3155474351]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(4243635304,2392299330),SynapseXen_lIliililllIlillIliI(2899830177,SynapseXen_lliilli))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{3928334742,1091357024,3406938229,1949753773,487396250,1378565614,4264886937,1550936070,2854801157,1322147800}return SynapseXen_ilIliIIliIlI[3155474351]end)()),SynapseXen_IIIIliiiiiI)local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[3865555431]or(function()local SynapseXen_liIllIlIiiIIiI="SYNAPSE XEN [FE BYPASS] [BETTER THEN LURAPH] [AMAZING] OMG OMG OMG !!!!!!"SynapseXen_ilIliIIliIlI[3865555431]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3676153309,3723992669),SynapseXen_lIliililllIlillIliI(2359992783,SynapseXen_ilIilIiIlIiIIillIi[5]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{908940149,4130024647,3656688069,3192123225,3270538400,2816095431,18055891,3270462167,1093657618}return SynapseXen_ilIliIIliIlI[3865555431]end)(),512)local SynapseXen_iliiIllIiill=SynapseXen_liliIi;if SynapseXen_iIIiI>255 then SynapseXen_iIIiI=SynapseXen_iiIIIIliiI[SynapseXen_iIIiI-256]else SynapseXen_iIIiI=SynapseXen_iliiIllIiill[SynapseXen_iIIiI]end;if SynapseXen_iiliIiiiiIlIIiIiIlli>255 then SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iiIIIIliiI[SynapseXen_iiliIiiiiIlIIiIiIlli-256]else SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iliiIllIiill[SynapseXen_iiliIiiiiIlIIiIiIlli]end;SynapseXen_iliiIllIiill[SynapseXen_iIllili(SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[3078892207]or(function(...)local SynapseXen_liIllIlIiiIIiI="level 1 crook = luraph, level 100 boss = xen"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(519521558,1722646899)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(1170471156,3124472372)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[3078892207]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2059087034,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3696263632,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{1406198124,2978274109,1445297377,1827750005,4279374337,1111365688,960836401}return SynapseXen_ilIliIIliIlI[3078892207]end)({},{},8499,"iIIIIllliiIl",{},"lii",6292,"iIilIi",8184),256),SynapseXen_IIIIliiiiiI,256)]=SynapseXen_iIIiI/SynapseXen_iiliIiiiiIlIIiIiIlli elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[3808371084]or(function(...)local SynapseXen_liIllIlIiiIIiI="can we have an f in chat for ripull"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3882675616,2152083552)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(4087917599,207057027)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[3808371084]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3063761758,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(251931077,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{1973517106}return SynapseXen_ilIliIIliIlI[3808371084]end)({}))then local SynapseXen_iIIiI=SynapseXen_liliilIl(SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[2501090194]or(function()local SynapseXen_liIllIlIiiIIiI="HELP ME PEOPLE ARE CRASHING MY GAME PLZ HELP"SynapseXen_ilIliIIliIlI[2501090194]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(755469238,3028357757),SynapseXen_lIliililllIlillIliI(1683333030,SynapseXen_ilIilIiIlIiIIillIi[7]))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{3719643584,1920056760,111768769,1380920138,3433575772,3324406457,2313894113,2529985730}return SynapseXen_ilIliIIliIlI[2501090194]end)(),512),SynapseXen_IIIIliiiiiI,512)local SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_liliilIl(SynapseXen_iIIIllIiIIiIlil[1931430686],SynapseXen_ilIliIIliIlI[1274562390]or(function(...)local SynapseXen_liIllIlIiiIIiI="hi xen doesn't work on sk8r please help"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(3175934001,877363948)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2729191279,1565777984)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1274562390]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(2657631773,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(2925833749,SynapseXen_ilIilIiIlIiIIillIi[1]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{986246849,3336318628}return SynapseXen_ilIliIIliIlI[1274562390]end)("IIIiIiiiIIiIii",{},{},"lIIIIIlIIilii"),512)local SynapseXen_iliiIllIiill=SynapseXen_liliIi;if SynapseXen_iIIiI>255 then SynapseXen_iIIiI=SynapseXen_iiIIIIliiI[SynapseXen_iIIiI-256]else SynapseXen_iIIiI=SynapseXen_iliiIllIiill[SynapseXen_iIIiI]end;if SynapseXen_iiliIiiiiIlIIiIiIlli>255 then SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iiIIIIliiI[SynapseXen_iiliIiiiiIlIIiIiIlli-256]else SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iliiIllIiill[SynapseXen_iiliIiiiiIlIIiIiIlli]end;SynapseXen_iliiIllIiill[SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[4021273589]or(function()local SynapseXen_liIllIlIiiIIiI="hi devforum"SynapseXen_ilIliIIliIlI[4021273589]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(973854831,2680898903),SynapseXen_lIliililllIlillIliI(1478207167,SynapseXen_ilIilIiIlIiIIillIi[7]))-SynapseXen_iIiIliIIilIii-string.len(SynapseXen_liIllIlIiiIIiI)-#{2985512725,3444106495,3794784746}return SynapseXen_ilIliIIliIlI[4021273589]end)())]=SynapseXen_iIIiI+SynapseXen_iiliIiiiiIlIIiIiIlli elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[3606493758]or(function()local SynapseXen_liIllIlIiiIIiI="hi my 2.5mb script doesn't work with xen please help"SynapseXen_ilIliIIliIlI[3606493758]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(3652670357,1744406156),SynapseXen_lIliililllIlillIliI(1133763812,SynapseXen_ilIilIiIlIiIIillIi[7]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2603847226,2668422177,2317221881,4207453900,3813828487,2655124099,1605420472,2936747962,1035537995,919559099}return SynapseXen_ilIliIIliIlI[3606493758]end)())then local SynapseXen_iliiIllIiill=SynapseXen_liliIi;for SynapseXen_IiiIi=SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[1716842899]or(function()local SynapseXen_liIllIlIiiIIiI="wow xen is shit buy luraph ok"SynapseXen_ilIliIIliIlI[1716842899]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1676856120,1245401834),SynapseXen_lIliililllIlillIliI(4152042253,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{885167896,3259352300,2632274319,3570171161,4288978165,3333050318,2563838547,1787802235,3508404851,209748734}return SynapseXen_ilIliIIliIlI[1716842899]end)(),256),SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[3021816868]or(function(...)local SynapseXen_liIllIlIiiIIiI="wally bad bird"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(91764993,1054644522)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(3002569423,1292379476)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[3021816868]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(874847331,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3509672149,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{4096921896,4102338303,2008647134,2658459905,1155551706}return SynapseXen_ilIliIIliIlI[3021816868]end)({},"IIIIlilIiii",{},2852),512)do SynapseXen_iliiIllIiill[SynapseXen_IiiIi]=nil end elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[3524444774]or(function(...)local SynapseXen_liIllIlIiiIIiI="pain is gonna use the backspace method on xen"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(73923833,1894114787)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2412416370,1882552704)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[3524444774]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3361037938,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1651087670,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3166754600,3488122198,3364007194,3068780961,3317921029}return SynapseXen_ilIliIIliIlI[3524444774]end)(14459,4298,"lililillil",6380,3581,"lliillllIiIii"))then SynapseXen_liliIi[SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[1110976327]or(function(...)local SynapseXen_liIllIlIiiIIiI="xen detects custom getfenv"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2116384049,2291429175)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(446943225,3848030914)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[1110976327]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1968031575,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(1565078373,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2989116051,1990326733,2052814354,1751803935,4092289302,2742766850,3977113572,1797765641,2584717521,2622722702}return SynapseXen_ilIliIIliIlI[1110976327]end)(14600,{},"IliiIlillIiliiI"))]=SynapseXen_liliIi[SynapseXen_lIliililllIlillIliI(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[1377406122]or(function()local SynapseXen_liIllIlIiiIIiI="hi xen crashes on my axon paste plz help"SynapseXen_ilIliIIliIlI[1377406122]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIIIlIIIiIiIIIiillII(1528174381,343120379),SynapseXen_lIliililllIlillIliI(4153338653,SynapseXen_ilIilIiIlIiIIillIi[4]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2264682788}return SynapseXen_ilIliIIliIlI[1377406122]end)())]elseif SynapseXen_iIiIliIIilIii==(SynapseXen_ilIliIIliIlI[2048409283]or(function(...)local SynapseXen_liIllIlIiiIIiI="xen doesn't come with instance caching, sorry superskater"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(179070271,2908048424)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2347409259,1947533547)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2048409283]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(1766093377,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(269470851,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-#{2602987923,3717498501,3389038223,2269224027,1008263887,437825767,3203316196,2542499053,4262353293,325227595}return SynapseXen_ilIliIIliIlI[2048409283]end)({},2376,{},{}))then SynapseXen_liliIi[SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1370203552],SynapseXen_ilIliIIliIlI[2364502915]or(function(...)local SynapseXen_liIllIlIiiIIiI="now comes with a free n word pass"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2289415705,1378345589)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(2069227913,2225710763)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII+SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2364502915]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3179432451,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(907881953,SynapseXen_ilIilIiIlIiIIillIi[3]))-string.len(SynapseXen_liIllIlIiiIIiI)-#{3802826309,4013663547}return SynapseXen_ilIliIIliIlI[2364502915]end)("llIIlIli"),256)]=-SynapseXen_liliIi[SynapseXen_iIllili(SynapseXen_iIIIllIiIIiIlil[1924739042],SynapseXen_ilIliIIliIlI[2371423222]or(function(...)local SynapseXen_liIllIlIiiIIiI="luraph better then xen bros :pensive:"local SynapseXen_liiiilIlilIiIliiIII=SynapseXen_lIIIlIIIiIiIIIiillII(2133493204,2744798342)local SynapseXen_IIiIlIiiliiI={...}for SynapseXen_lllliiiiiilIiIi,SynapseXen_lIlllII in pairs(SynapseXen_IIiIlIiiliiI)do local SynapseXen_IiIIlIilIiliIiIiI;local SynapseXen_IiIllIiil=type(SynapseXen_lIlllII)if SynapseXen_IiIllIiil=="number"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII elseif SynapseXen_IiIllIiil=="string"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIlllII:len()elseif SynapseXen_IiIllIiil=="table"then SynapseXen_IiIIlIilIiliIiIiI=SynapseXen_lIIIlIIIiIiIIIiillII(4173002747,121949844)end;SynapseXen_liiiilIlilIiIliiIII=SynapseXen_liiiilIlilIiIliiIII-SynapseXen_IiIIlIilIiliIiIiI end;SynapseXen_ilIliIIliIlI[2371423222]=SynapseXen_lIliililllIlillIliI(SynapseXen_lIliililllIlillIliI(3661014211,SynapseXen_liiiilIlilIiIliiIII),SynapseXen_lIliililllIlillIliI(3627335522,SynapseXen_lliilli))-string.len(SynapseXen_liIllIlIiiIIiI)-SynapseXen_iIiIliIIilIii-#{2090482141,3055233499,2180695751,246701054,2484451311,2284486642}return SynapseXen_ilIliIIliIlI[2371423222]end)(2277,1982,8857),512)]end end end;local SynapseXen_IilIiiIIiii={...}for SynapseXen_IiiIi=0,SynapseXen_IiiIiiiiIIIilIllil do if SynapseXen_IiiIi>=SynapseXen_IlliIllll[907555918]then SynapseXen_iIlIIlliIllil[SynapseXen_IiiIi-SynapseXen_IlliIllll[907555918]]=SynapseXen_IilIiiIIiii[SynapseXen_IiiIi+1]else SynapseXen_liliIi[SynapseXen_IiiIi]=SynapseXen_IilIiiIIiii[SynapseXen_IiiIi+1]end end;local SynapseXen_iIIiI,SynapseXen_iiliIiiiiIlIIiIiIlli=SynapseXen_iiiIlill()if SynapseXen_iIIiI and SynapseXen_iiliIiiiiIlIIiIiIlli>0 then return unpack(SynapseXen_iIIiI,1,SynapseXen_iiliIiiiiIlIIiIiIlli)end;return end end;local function SynapseXen_liIIlIIIiIi(SynapseXen_ilIlIlIililiIliiIl,SynapseXen_iIilI)local SynapseXen_IIilIllIiiiIlliliiII=SynapseXen_iIIili(SynapseXen_ilIlIlIililiIliiIl)return SynapseXen_llIIlIIlllillIili(SynapseXen_IIilIllIiiiIlliliiII,SynapseXen_iIilI or getfenv(0)),SynapseXen_IIilIllIiiiIlliliiII end;return SynapseXen_liIIlIIIiIi(SynapseXen_lIiiIIliIi("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"),getfenv())()
end)

TextLabel_2.Parent = FastHTC
TextLabel_2.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0.518988848, 0, 0.46875, 0)
TextLabel_2.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_2.Font = Enum.Font.GothamSemibold
TextLabel_2.Text = "Fast HTC"
TextLabel_2.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.TextScaled = true
TextLabel_2.TextSize = 14.000
TextLabel_2.TextWrapped = true

FlyPlus.Name = "FlyPlus"
FlyPlus.Parent = Frame_1
FlyPlus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FlyPlus.BackgroundTransparency = 1.000
FlyPlus.Position = UDim2.new(0.0186007917, 0, 0.224242419, 0)
FlyPlus.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
FlyPlus.Image = "rbxassetid://2790382281"
FlyPlus.ImageColor3 = Color3.fromRGB(53, 53, 53)
FlyPlus.ScaleType = Enum.ScaleType.Slice
FlyPlus.SliceCenter = Rect.new(4, 4, 252, 252)
FlyPlus.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Fly Plus";
		Text = "Q, then ASDW";
	})
	
	down = false
	velocity = Instance.new("BodyVelocity")
	velocity.maxForce = Vector3.new(10000000, 0, 10000000)
	---vv Use that to change the speed v
	local speed    = 1000
	gyro           = Instance.new("BodyGyro")
	gyro.maxTorque = Vector3.new(10000000, 0, 10000000)
	
	local hum = game.Players.LocalPlayer.Character.Humanoid
	
	function onButton1Down(mouse)
		down = true
		velocity.Parent = game.Players.LocalPlayer.Character.UpperTorso
		velocity.velocity = (hum.MoveDirection) * speed
		gyro.Parent = game.Players.LocalPlayer.Character.UpperTorso
		while down do
			if not down then break end
			velocity.velocity = (hum.MoveDirection) * speed
			local refpos = gyro.Parent.Position + (gyro.Parent.Position - workspace.CurrentCamera.CoordinateFrame.p).unit * 5
			gyro.cframe = CFrame.new(gyro.Parent.Position, Vector3.new(refpos.x, gyro.Parent.Position.y, refpos.z))
			wait(0.1)
		end
	end
	
	function onButton1Up(mouse)
		velocity.Parent = nil
		gyro.Parent = nil
		down = false
	end
	--To Change the key in those 2 lines, replace the "v" with your desired key
	function onSelected(mouse)
		mouse.KeyDown:connect(function(k) if k:lower()=="q"then onButton1Down(mouse)end end)
		mouse.KeyUp:connect(function(k) if k:lower()=="q"then onButton1Up(mouse)end end)
	end
	
	onSelected(game.Players.LocalPlayer:GetMouse())
	
	----
end)

TextLabel_3.Parent = FlyPlus
TextLabel_3.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.BackgroundTransparency = 1.000
TextLabel_3.BorderSizePixel = 0
TextLabel_3.Position = UDim2.new(0.518988848, 0, 0.46875, 0)
TextLabel_3.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_3.Font = Enum.Font.GothamSemibold
TextLabel_3.Text = "Fly Plus"
TextLabel_3.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_3.TextScaled = true
TextLabel_3.TextSize = 14.000
TextLabel_3.TextWrapped = true

Glitch.Name = "Glitch"
Glitch.Parent = Frame_1
Glitch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Glitch.BackgroundTransparency = 1.000
Glitch.Position = UDim2.new(0.0149700604, 0, 0.630303025, 0)
Glitch.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
Glitch.Image = "rbxassetid://2790382281"
Glitch.ImageColor3 = Color3.fromRGB(53, 53, 53)
Glitch.ScaleType = Enum.ScaleType.Slice
Glitch.SliceCenter = Rect.new(4, 4, 252, 252)
Glitch.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Glitch Players";
		Text = "Got patch sr you can use Glitch Pack";
	})
	wait(1)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Placements";
		Text = "Dragon Crush On R";
	})
	
	spawn(function()
		--put dragon crush or dragon throw on R.
		local Player = game:GetService("Players").LocalPlayer
		local Mouse = Player:GetMouse()
		
		Mouse.KeyDown:connect(function(Key)
			Key = Key:lower()
			if Key == 'r' then
				local plr = game.Players.LocalPlayer
				keypress(0x52)
				wait(0.5)
				keyrelease(0x52)
				plr.Character:FindFirstChild'Dragon Crush'.Activator.Throw:Destroy();
				wait(1)
				Player.Character.Humanoid.Health = 0
			end
		end)
	end)
	
	spawn(function()
		--hard reset incase it fails.
		local Player = game:GetService("Players").LocalPlayer
		local Mouse = Player:GetMouse()
		
		Mouse.KeyDown:connect(function(Key)
			Key = Key:lower()
			if Key == '.' then
				Player.Character.Humanoid.Health = 0
			end
		end)
	end)
end)

TextLabel_4.Parent = Glitch
TextLabel_4.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_4.BackgroundTransparency = 1.000
TextLabel_4.BorderSizePixel = 0
TextLabel_4.Position = UDim2.new(0.518813789, 0, 0.46875, 0)
TextLabel_4.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_4.Font = Enum.Font.GothamSemibold
TextLabel_4.Text = "Glitch"
TextLabel_4.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_4.TextScaled = true
TextLabel_4.TextSize = 14.000
TextLabel_4.TextWrapped = true

Kick.Name = "Kick"
Kick.Parent = Frame_1
Kick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Kick.BackgroundTransparency = 1.000
Kick.Position = UDim2.new(0.508234978, 0, 0.424242437, 0)
Kick.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
Kick.Image = "rbxassetid://2790382281"
Kick.ImageColor3 = Color3.fromRGB(53, 53, 53)
Kick.ScaleType = Enum.ScaleType.Slice
Kick.SliceCenter = Rect.new(4, 4, 252, 252)
Kick.MouseButton1Down:connect(function()
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Kick";
	Text = "Enabled";
})

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Credit";
	Text = "Made By Kuzo";
})
wait(2)
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Placements";
	Text = "Dragon Throw On Y";
})
wait(2)
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Move Trash to queue";
	Text = "Any thing on T to move that shit on queue";
})
wait(2)
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "FAST reset";
	Text = "Hard reset press ]";
})

if not game:IsLoaded() then
	local loadedcheck = Instance.new("Message",workspace)
	loadedcheck.Text = 'Loading...'
	game.Loaded:Wait()
	loadedcheck:Destroy()
end
wait(1)
local plr = game:GetService("Players").LocalPlayer
local mouse = plr:GetMouse()

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()

Mouse.KeyDown:connect(function(Key)
   Key = Key:lower()
   if Key == "t" then
       wait(10)
       local plr = game.Players.LocalPlayer
game.ReplicatedStorage.ResetChar:FireServer()
wait()
plr.Character.Head:Remove()
    end
    end)

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()

Mouse.KeyDown:connect(function(Key)
   Key = Key:lower()
   if Key == ']' then
       Player.Character.Humanoid.Health = 0
    end
    end)
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.KeyDown:connect(function(key)
if key == 't' then
    wait(2.8)
    mouse.KeyDown:connect(function(key)
    if key == "t" then
        wait(1)
        local plr = game.Players.LocalPlayer
        game.Workspace.Live[plr.Name]["Dragon Crush"].Activator["Flip"]:Destroy()
        game.Workspace.Live[plr.Name]["Dragon Crush"].Activator["Throw"]:Destroy()
        game.Workspace.Live[plr.Name]["Dragon Crush"].Activator["Blocked"]:Destroy()
        game.Workspace.Live[plr.Name]["Dragon Crush"].Activator["HitDown"]:Destroy()
        game.Workspace.Live[plr.Name]["Dragon Crush"].Activator["BoneBreak"]:Destroy()
    end
end)
game.TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(1.8),{CFrame = CFrame.new(2656.72, 3945.04, -2516.38)}):Play()
wait(0)
    local Event = game:GetService("ReplicatedStorage").ResetChar
    Event:FireServer()
    wait()
local Playe = game:GetService("Players").LocalPlayer
local Mouse = Playe:GetMouse()
end
end)
mouse.KeyDown:connect(function(key)
    if key == "y" then
        wait(0.1)
        local plr = game.Players.LocalPlayer
        game.Workspace.Live[plr.Name]["Dragon Throw"].Activator["Flip"]:Destroy()
        game.Workspace.Live[plr.Name]["Dragon Throw"].Activator["Throw"]:Destroy()
        game.Workspace.Live[plr.Name]["Dragon Throw"].Activator["Blocked"]:Destroy()
        game.Workspace.Live[plr.Name]["Dragon Throw"].Activator["HitDown"]:Destroy()
        game.Workspace.Live[plr.Name]["Dragon Throw"].Activator["BoneBreak"]:Destroy()
    end
end)
local plr = game:GetService("Players").LocalPlayer
local mouse = plr:GetMouse()

local plr = game:GetService("Players").LocalPlayer
local mouse = plr:GetMouse()

mouse.KeyDown:connect(function(key)
    if key == "y" then
        local plr = game.Players.LocalPlayer
        game.Workspace["Wormhole"].TouchInterest:Destroy()
    end
end)
mouse.KeyDown:connect(function(key)
    if key == "y" then
        local plr = game.Players.LocalPlayer
        game.Workspace["Wormhole"].Script:Destroy()
    end
end)
while wait() do
for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
if v.Name == "Justice Combination" then
local action = game.Players.LocalPlayer.Character:WaitForChild("Action")
if action then wait() action:Destroy() end end
if v.Name == "Attacking" then
v:Destroy()
end
if v.Name == "Action" then
v:Destroy()
end
if v.Name == "Block" and v.Value == true then
v.Value = false
end
end
end
end)

TextLabel_5.Parent = Kick
TextLabel_5.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_5.BackgroundTransparency = 1.000
TextLabel_5.BorderSizePixel = 0
TextLabel_5.Position = UDim2.new(0.518861294, 0, 0.46875, 0)
TextLabel_5.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_5.Font = Enum.Font.GothamSemibold
TextLabel_5.Text = "Kick"
TextLabel_5.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_5.TextScaled = true
TextLabel_5.TextSize = 14.000
TextLabel_5.TextWrapped = true

NoGlitch.Name = "NoGlitch"
NoGlitch.Parent = Frame_1
NoGlitch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoGlitch.BackgroundTransparency = 1.000
NoGlitch.Position = UDim2.new(0.517044902, 0, 0.224242419, 0)
NoGlitch.Size = UDim2.new(0.212750033, 0, 0.145454541, 0)
NoGlitch.Image = "rbxassetid://2790382281"
NoGlitch.ImageColor3 = Color3.fromRGB(53, 53, 53)
NoGlitch.ScaleType = Enum.ScaleType.Slice
NoGlitch.SliceCenter = Rect.new(4, 4, 252, 252)
NoGlitch.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "No Glitch";
		Text = "Loaded..";
	})
	
	while wait() do
		local action = game.Players.LocalPlayer.Character.LowerTorso:WaitForChild("KnockBacked")
		if action then action:Destroy()
		end
	end
end)

TextLabel_6.Parent = NoGlitch
TextLabel_6.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_6.BackgroundTransparency = 1.000
TextLabel_6.BorderSizePixel = 0
TextLabel_6.Position = UDim2.new(0.497142881, 0, 0.46875, 0)
TextLabel_6.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_6.Font = Enum.Font.GothamSemibold
TextLabel_6.Text = "No Glitch"
TextLabel_6.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_6.TextScaled = true
TextLabel_6.TextSize = 14.000
TextLabel_6.TextWrapped = true

Noclip.Name = "Noclip"
Noclip.Parent = Frame_1
Noclip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Noclip.BackgroundTransparency = 1.000
Noclip.Position = UDim2.new(0.753466606, 0, 0.424242437, 0)
Noclip.Size = UDim2.new(0.212750033, 0, 0.145454541, 0)
Noclip.Image = "rbxassetid://2790382281"
Noclip.ImageColor3 = Color3.fromRGB(53, 53, 53)
Noclip.ScaleType = Enum.ScaleType.Slice
Noclip.SliceCenter = Rect.new(4, 4, 252, 252)
Noclip.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Noclip";
		Text = "Loaded..";
	})
	wait(1)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Toggle";
		Text = "Press N press again to Off";
	})
	
noclip = false
game:GetService('RunService').Stepped:connect(function()
if noclip then
game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
end
end)
plr = game.Players.LocalPlayer
mouse = plr:GetMouse()
mouse.KeyDown:connect(function(key)

if key == "n" then
noclip = not noclip
game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
end
end)
end)

TextLabel_7.Parent = Noclip
TextLabel_7.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_7.BackgroundTransparency = 1.000
TextLabel_7.BorderSizePixel = 0
TextLabel_7.Position = UDim2.new(0.479820251, 0, 0.46875, 0)
TextLabel_7.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_7.Font = Enum.Font.GothamSemibold
TextLabel_7.Text = "Noclip"
TextLabel_7.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_7.TextScaled = true
TextLabel_7.TextSize = 14.000
TextLabel_7.TextWrapped = true

RankGod.Name = "RankGod"
RankGod.Parent = Frame_1
RankGod.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RankGod.BackgroundTransparency = 1.000
RankGod.Position = UDim2.new(0.754442275, 0, 0.224242419, 0)
RankGod.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
RankGod.Image = "rbxassetid://2790382281"
RankGod.ImageColor3 = Color3.fromRGB(53, 53, 53)
RankGod.ScaleType = Enum.ScaleType.Slice
RankGod.SliceCenter = Rect.new(4, 4, 252, 252)
RankGod.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "RankGodmode";
		Text = "Loaded..";
	})
	
	local plr = game.Players.LocalPlayer
	game.Workspace.Live[plr.Name].Stats["Ki-Resist"]:Destroy()
	game.Workspace.Live[plr.Name].Stats["Phys-Resist"]:Destroy()
end)

TextLabel_8.Parent = RankGod
TextLabel_8.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_8.BackgroundTransparency = 1.000
TextLabel_8.BorderSizePixel = 0
TextLabel_8.Position = UDim2.new(0.514692485, 0, 0.46875, 0)
TextLabel_8.Size = UDim2.new(1.07066202, -5, 0.853999913, -5)
TextLabel_8.Font = Enum.Font.GothamSemibold
TextLabel_8.Text = "Rank-God"
TextLabel_8.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_8.TextScaled = true
TextLabel_8.TextSize = 14.000
TextLabel_8.TextWrapped = true

RunPlus.Name = "RunPlus"
RunPlus.Parent = Frame_1
RunPlus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RunPlus.BackgroundTransparency = 1.000
RunPlus.Position = UDim2.new(0.265423477, 0, 0.224242419, 0)
RunPlus.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
RunPlus.Image = "rbxassetid://2790382281"
RunPlus.ImageColor3 = Color3.fromRGB(53, 53, 53)
RunPlus.ScaleType = Enum.ScaleType.Slice
RunPlus.SliceCenter = Rect.new(4, 4, 252, 252)
RunPlus.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Run Plus";
		Text = "Loaded..";
	})
	wait(1)
	function setSpeed(walkspeedSet) ---- change set speed to whatever speed
		
		
		local plr = game:GetService"Players".LocalPlayer
		local serverTraits = plr.Backpack:WaitForChild'ServerTraits'
		
		for i,v in next, getconnections(serverTraits.Input.OnClientEvent) do
			local speed = (350*(walkspeedSet/44))-350
			v:Fire({speed})
			break
		end
	end
	setSpeed(650)
	wait()
	plr = game.Players.LocalPlayer
	hum = plr.Character.HumanoidRootPart
	mouse = plr:GetMouse()
	
	mouse.KeyDown:connect(function(key)
		if key == "u" then
			if mouse.Target then
				game.Players.LocalPlayer.Backpack.ServerTraits.Vanish:FireServer()
				wait(.25)
				hum.CFrame = CFrame.new(mouse.Hit.x, mouse.Hit.y + 5, mouse.Hit.z)
				wait(.25)
			end
		end
	end)
end)

TextLabel_9.Parent = RunPlus
TextLabel_9.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_9.BackgroundTransparency = 1.000
TextLabel_9.BorderSizePixel = 0
TextLabel_9.Position = UDim2.new(0.518861294, 0, 0.46875, 0)
TextLabel_9.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_9.Font = Enum.Font.GothamSemibold
TextLabel_9.Text = "Run Plus"
TextLabel_9.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_9.TextScaled = true
TextLabel_9.TextSize = 14.000
TextLabel_9.TextWrapped = true

Smoke.Name = "Smoke"
Smoke.Parent = Frame_1
Smoke.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Smoke.BackgroundTransparency = 1.000
Smoke.Position = UDim2.new(0.261412293, 0, 0.424242437, 0)
Smoke.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
Smoke.Image = "rbxassetid://2790382281"
Smoke.ImageColor3 = Color3.fromRGB(53, 53, 53)
Smoke.ScaleType = Enum.ScaleType.Slice
Smoke.SliceCenter = Rect.new(4, 4, 252, 252)
Smoke.MouseButton1Down:connect(function()
	--[_Dust_Cloud_]--
	--[By: Kuckoon]--
	--[[Special Thanks To helpguestslikeme for keybinding, and debugging script.]]--
	
	local A_1 = "average"
	local A_2 = CFrame.new(-5866.24512, 17.9874992, -4334.48682, -0.0332060792, 0.44201088, -0.896394908, -0, 0.896889567, 0.442254752, 0.999448538, 0.014685546, -0.0297821835)
	local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.Vanish
	local lplr = game.Players.LocalPlayer
	local mouse = lplr:GetMouse()
	_G.on = false
	on = true
	off = false
	
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Dust Cloud";
		Text = "Press P to enable/disable.";
	})
	
	mouse.KeyDown:connect(function(key)
		if key == "p" then
			if _G.on == false then
				_G.on = on
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "Dust Cloud Enabled";
					Text = "Press P to disable.";
				})
				while _G.on == true do
					wait()
					Event:FireServer(A_1, A_2)
				end
			elseif _G.on == true then
				_G.on = off
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "Dust Cloud Disabled";
					Text = "Press P to enable.";
				})
			end
		end
	end)
end)

TextLabel_10.Parent = Smoke
TextLabel_10.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_10.BackgroundTransparency = 1.000
TextLabel_10.BorderSizePixel = 0
TextLabel_10.Position = UDim2.new(0.518988848, 0, 0.46875, 0)
TextLabel_10.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_10.Font = Enum.Font.GothamSemibold
TextLabel_10.Text = "Smoke"
TextLabel_10.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_10.TextScaled = true
TextLabel_10.TextSize = 14.000
TextLabel_10.TextWrapped = true

Vanish.Name = "Vanish"
Vanish.Parent = Frame_1
Vanish.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Vanish.BackgroundTransparency = 1.000
Vanish.Position = UDim2.new(0.0179640725, 0, 0.424242437, 0)
Vanish.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
Vanish.Image = "rbxassetid://2790382281"
Vanish.ImageColor3 = Color3.fromRGB(53, 53, 53)
Vanish.ScaleType = Enum.ScaleType.Slice
Vanish.SliceCenter = Rect.new(4, 4, 252, 252)
Vanish.MouseButton1Down:connect(function()
	--[_Vanish]--
	--[By: Kuckoon]--
	--[[Special Thanks To helpguestslikeme for keybinding, and debugging script.]]--
	local A_1 = "Easy"
	local A_2 = CFrame.new(-5866.24512, 17.9874992, -4334.48682, -0.0332060792, 0.44201088, -0.896394908, -0, 0.896889567, 0.442254752, 0.999448538, 0.014685546, -0.0297821835)
	local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.Vanish
	local lplr = game.Players.LocalPlayer
	local mouse = lplr:GetMouse()
	_G.on = false
	on = true
	off = false
	
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Vanish";
		Text = "Press V to enable/disable.";
	})
	
	mouse.KeyDown:connect(function(key)
		if key == "v" then
			if _G.on == false then
				_G.on = on
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "Vanish Enabled";
					Text = "Press v to disable.";
				})
				while _G.on == true do
					wait()
					Event:FireServer(A_1, A_2)
				end
			elseif _G.on == true then
				_G.on = off
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "Vanish Disabled";
					Text = "Press v to enable.";
				})
			end
		end
	end)
end)

TextLabel_11.Parent = Vanish
TextLabel_11.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_11.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_11.BackgroundTransparency = 1.000
TextLabel_11.BorderSizePixel = 0
TextLabel_11.Position = UDim2.new(0.518813789, 0, 0.46875, 0)
TextLabel_11.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_11.Font = Enum.Font.GothamSemibold
TextLabel_11.Text = "Vanish"
TextLabel_11.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_11.TextScaled = true
TextLabel_11.TextSize = 14.000
TextLabel_11.TextWrapped = true

Close.Name = "Close"
Close.Parent = Frame_1
Close.BackgroundTransparency = 1.000
Close.Position = UDim2.new(0.835952401, 0, 0.0242424235, 0)
Close.Size = UDim2.new(0.0630119815, 0, 0.120999999, 0)
Close.ZIndex = 2
Close.Image = "rbxassetid://3926305904"
Close.ImageRectOffset = Vector2.new(404, 364)
Close.ImageRectSize = Vector2.new(36, 36)

Label.Name = "Label"
Label.Parent = Frame_1
Label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Label.BorderColor3 = Color3.fromRGB(0, 255, 0)
Label.Position = UDim2.new(0.75, 0, 0.842000008, 0)
Label.Size = UDim2.new(0.209999993, 0, 0.103, 0)
Label.Font = Enum.Font.SourceSans
Label.Text = "Page - 1"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextSize = 14.000
Label.TextStrokeTransparency = 0.100

Next.Name = "Next"
Next.Parent = Frame_1
Next.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Next.BackgroundTransparency = 1.000
Next.Position = UDim2.new(0.750472605, 0, 0.630303025, 0)
Next.Size = UDim2.new(0.212750033, 0, 0.145454541, 0)
Next.Image = "rbxassetid://2790382281"
Next.ImageColor3 = Color3.fromRGB(53, 53, 53)
Next.ScaleType = Enum.ScaleType.Slice
Next.SliceCenter = Rect.new(4, 4, 252, 252)

TextLabel_12.Parent = Next
TextLabel_12.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_12.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_12.BackgroundTransparency = 1.000
TextLabel_12.BorderSizePixel = 0
TextLabel_12.Position = UDim2.new(0.507965565, 0, 0.46875, 0)
TextLabel_12.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_12.Font = Enum.Font.GothamSemibold
TextLabel_12.Text = "Next - "
TextLabel_12.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_12.TextScaled = true
TextLabel_12.TextSize = 14.000
TextLabel_12.TextWrapped = true

Line_2.Name = "Line"
Line_2.Parent = Frame_1
Line_2.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Line_2.Position = UDim2.new(0.0179640707, 0, 0.175757587, 0)
Line_2.Size = UDim2.new(0.949000001, 0, 0.00700000022, 0)

Label_2.Name = "Label"
Label_2.Parent = Frame_1
Label_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Label_2.BackgroundTransparency = 1.000
Label_2.BorderSizePixel = 0
Label_2.Position = UDim2.new(0.0179640725, 0, 0, 0)
Label_2.Size = UDim2.new(0.257485032, 0, 0.175757602, 0)
Label_2.Font = Enum.Font.ArialBold
Label_2.Text = "Kz Page1"
Label_2.TextColor3 = Color3.fromRGB(255, 255, 255)
Label_2.TextScaled = true
Label_2.TextSize = 14.000
Label_2.TextStrokeTransparency = 0.100
Label_2.TextWrapped = true
Label_2.TextXAlignment = Enum.TextXAlignment.Left

Frame_2.Name = "Frame_2"
Frame_2.Parent = SkidHub_Home
Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_2.BackgroundTransparency = 1.000
Frame_2.Position = UDim2.new(0, 0, 0.0799999982, 0)
Frame_2.Size = UDim2.new(1, 0, 0.942857206, 0)
Frame_2.Visible = false
Frame_2.Image = "rbxassetid://3570695787"
Frame_2.ImageColor3 = Color3.fromRGB(35, 35, 35)
Frame_2.ScaleType = Enum.ScaleType.Slice
Frame_2.SliceCenter = Rect.new(100, 100, 100, 100)
Frame_2.SliceScale = 0.080

Earth_God.Name = "Earth_God"
Earth_God.Parent = Frame_2
Earth_God.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Earth_God.BackgroundTransparency = 1.000
Earth_God.Position = UDim2.new(0.503787994, 0, 0.818181813, 0)
Earth_God.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
Earth_God.Image = "rbxassetid://2790382281"
Earth_God.ImageColor3 = Color3.fromRGB(53, 53, 53)
Earth_God.ScaleType = Enum.ScaleType.Slice
Earth_God.SliceCenter = Rect.new(4, 4, 252, 252)
Earth_God.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Earth Godmode";
		Text = "By Kz";
	})
	wait(2)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "only work on earth";
		Text = "Press < to enable/disable";
	})
	
_G.on = false
local touchy = game.Workspace.Touchy.Part
local lplr = game.Players.LocalPlayer
local pos = touchy.CFrame

game:GetService("RunService").RenderStepped:connect(function()
	if earthgodmode == true then
		touchy.Size = Vector3.new(30, 30, 30)
		touchy.CFrame = lplr.Character.HumanoidRootPart.CFrame
		wait()
		touchy.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(50, 50, 50)
	end
	if removegui == true then
		local gui = lplr.PlayerGui
		for i,v in pairs(gui:GetChildren()) do
            if v.Name == "Popup" then
                v.Enabled = false
            end
        end
    end
    if backtopos == true then
    	wait()
    	touchy.Size = Vector3.new(20, 2, 20)
    	touchy.CFrame = pos
	end
end)
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.KeyDown:connect(function(key)
	if key == "," then
	    if _G.on == false then
	        _G.on = true
	        game:GetService("StarterGui"):SetCore("SendNotification", {
	        Title = "Better God-Mode Enabled";
	        Text = "Press < to disable.";
	        })
	    elseif _G.on == true then
	        touchy.Size = Vector3.new(20, 2, 20)
	        _G.on = false
	        game.Workspace.Touchy.Part.CFrame = CFrame.new(-746.526306, 25.8025646, -6415.6543, 0, 0, 1, 0, 1, -0, -1, 0, 0)
	        game:GetService("StarterGui"):SetCore("SendNotification", {
	        Title = "Better God-Mode Disabled";
	        Text = "Press < to enable.";
	        })
		end
	end
end)

while wait() do
    while _G.on == true do
    	wait()
        earthgodmode = true
        removegui = true
        backtopos = false
    end
    while _G.on == false do
    	wait()
    	earthgodmode = false
    	removegui = false
    	backtopos = true
	end
end
end)

Earth_God_2.Name = "Earth_God"
Earth_God_2.Parent = Earth_God
Earth_God_2.AnchorPoint = Vector2.new(0.5, 0.5)
Earth_God_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Earth_God_2.BackgroundTransparency = 1.000
Earth_God_2.BorderSizePixel = 0
Earth_God_2.Position = UDim2.new(0.518813789, 0, 0.46875, 0)
Earth_God_2.Size = UDim2.new(1.079, -5, 0.853999972, -5)
Earth_God_2.Font = Enum.Font.GothamSemibold
Earth_God_2.Text = "God Earth"
Earth_God_2.TextColor3 = Color3.fromRGB(0, 0, 0)
Earth_God_2.TextScaled = true
Earth_God_2.TextSize = 14.000
Earth_God_2.TextWrapped = true

Soon.Name = "Soon"
Soon.Parent = Frame_2
Soon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Soon.BackgroundTransparency = 1.000
Soon.Position = UDim2.new(0.257781565, 0, 0.812121212, 0)
Soon.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
Soon.Image = "rbxassetid://2790382281"
Soon.ImageColor3 = Color3.fromRGB(53, 53, 53)
Soon.ScaleType = Enum.ScaleType.Slice
Soon.SliceCenter = Rect.new(4, 4, 252, 252)
Soon.MouseButton1Down:connect(function()
game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Hair Style";
		Text = "just work with race can change hair not all X3";
	})
	wait()
local A_1 = game:GetService("Workspace").FriendlyNPCs["Hair Stylist"]
local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatStart
Event:FireServer(A_1)
wait(0.3)
local A_1 = 
{
	[1] = "Yes"
}
local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance
Event:FireServer(A_1)

end)

TextLabel_13.Parent = Soon
TextLabel_13.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_13.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_13.BackgroundTransparency = 1.000
TextLabel_13.BorderSizePixel = 0
TextLabel_13.Position = UDim2.new(0.518813789, 0, 0.46875, 0)
TextLabel_13.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_13.Font = Enum.Font.GothamSemibold
TextLabel_13.Text = "Hair Style"
TextLabel_13.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_13.TextScaled = true
TextLabel_13.TextSize = 14.000
TextLabel_13.TextWrapped = true

Slots.Name = "Slots"
Slots.Parent = Frame_2
Slots.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Slots.BackgroundTransparency = 1.000
Slots.Position = UDim2.new(0.0149700604, 0, 0.818181813, 0)
Slots.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
Slots.Image = "rbxassetid://2790382281"
Slots.ImageColor3 = Color3.fromRGB(53, 53, 53)
Slots.ScaleType = Enum.ScaleType.Slice
Slots.SliceCenter = Rect.new(4, 4, 252, 252)
Slots.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Char Slots";
		Text = "Loaded..";
	})
	
	local A_1 = game:GetService("Workspace").FriendlyNPCs["Character Slot Changer"]
	local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatStart
	Event:FireServer(A_1)
end)

TextLabel_14.Parent = Slots
TextLabel_14.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_14.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_14.BackgroundTransparency = 1.000
TextLabel_14.BorderSizePixel = 0
TextLabel_14.Position = UDim2.new(0.518813789, 0, 0.46875, 0)
TextLabel_14.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_14.Font = Enum.Font.GothamSemibold
TextLabel_14.Text = "Slots"
TextLabel_14.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_14.TextScaled = true
TextLabel_14.TextSize = 14.000
TextLabel_14.TextWrapped = true

Close_2.Name = "Close"
Close_2.Parent = Frame_2
Close_2.BackgroundTransparency = 1.000
Close_2.Position = UDim2.new(0.835952401, 0, 0.0242424235, 0)
Close_2.Size = UDim2.new(0.0630119815, 0, 0.120999999, 0)
Close_2.ZIndex = 2
Close_2.Image = "rbxassetid://3926305904"
Close_2.ImageRectOffset = Vector2.new(404, 364)
Close_2.ImageRectSize = Vector2.new(36, 36)

Label_3.Name = "Label"
Label_3.Parent = Frame_2
Label_3.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Label_3.BorderColor3 = Color3.fromRGB(0, 255, 0)
Label_3.Position = UDim2.new(0.750472665, 0, 0.842424214, 0)
Label_3.Size = UDim2.new(0.210043639, 0, 0.103030302, 0)
Label_3.Font = Enum.Font.SourceSans
Label_3.Text = "Page - 2"
Label_3.TextColor3 = Color3.fromRGB(255, 255, 255)
Label_3.TextSize = 14.000
Label_3.TextStrokeTransparency = 0.100

Button.Name = "Button"
Button.Parent = Frame_2
Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Button.BackgroundTransparency = 1.000
Button.Position = UDim2.new(0.750472605, 0, 0.630303025, 0)
Button.Size = UDim2.new(0.212750033, 0, 0.145454541, 0)
Button.Image = "rbxassetid://2790382281"
Button.ImageColor3 = Color3.fromRGB(53, 53, 53)
Button.ScaleType = Enum.ScaleType.Slice
Button.SliceCenter = Rect.new(4, 4, 252, 252)

TextLabel_15.Parent = Button
TextLabel_15.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_15.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_15.BackgroundTransparency = 1.000
TextLabel_15.BorderSizePixel = 0
TextLabel_15.Position = UDim2.new(0.507965565, 0, 0.46875, 0)
TextLabel_15.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_15.Font = Enum.Font.GothamSemibold
TextLabel_15.Text = "Next - "
TextLabel_15.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_15.TextScaled = true
TextLabel_15.TextSize = 14.000
TextLabel_15.TextWrapped = true

Kai.Name = "Kai"
Kai.Parent = Frame_2
Kai.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Kai.BackgroundTransparency = 1.000
Kai.Position = UDim2.new(0.505240977, 0, 0.630303025, 0)
Kai.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
Kai.Image = "rbxassetid://2790382281"
Kai.ImageColor3 = Color3.fromRGB(53, 53, 53)
Kai.ScaleType = Enum.ScaleType.Slice
Kai.SliceCenter = Rect.new(4, 4, 252, 252)
Kai.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Elder Kai Auto Buy";
		Text = "Loaded..";
	})
	
	local A_1 = game:GetService("Workspace").FriendlyNPCs["Elder Kai"]
	local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatStart
	Event:FireServer(A_1)
	wait(1)
	local A_1 = 
	{
		[1] = "k"
	}
	local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance
	Event:FireServer(A_1)
	wait(1)
	local A_1 = 
	{
		[1] = "Yes"
	}
	local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance
	Event:FireServer(A_1)
	wait(1)
	local A_1 = 
	{
		[1] = "k"
	}
	local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance
	Event:FireServer(A_1)
	wait(1)
	local A_1 = 
	{
		[1] = "k"
	}
	local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance
	Event:FireServer(A_1)
	wait(1)
end)

TextLabel_16.Parent = Kai
TextLabel_16.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_16.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_16.BackgroundTransparency = 1.000
TextLabel_16.BorderSizePixel = 0
TextLabel_16.Position = UDim2.new(0.518861294, 0, 0.46875, 0)
TextLabel_16.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_16.Font = Enum.Font.GothamSemibold
TextLabel_16.Text = "Elder Kai"
TextLabel_16.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_16.TextScaled = true
TextLabel_16.TextSize = 14.000
TextLabel_16.TextWrapped = true

BeanSpam.Name = "BeanSpam"
BeanSpam.Parent = Frame_2
BeanSpam.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BeanSpam.BackgroundTransparency = 1.000
BeanSpam.Position = UDim2.new(0.258418292, 0, 0.630303025, 0)
BeanSpam.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
BeanSpam.Image = "rbxassetid://2790382281"
BeanSpam.ImageColor3 = Color3.fromRGB(53, 53, 53)
BeanSpam.ScaleType = Enum.ScaleType.Slice
BeanSpam.SliceCenter = Rect.new(4, 4, 252, 252)
BeanSpam.MouseButton1Down:connect(function()
game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "AutoBean Spam by KZ";
        Text = "Press J-ON Press K-OFF";
        })
--[Press J to toggle]--
--[Press K to untoggle]--
Raziq = true
lolers = false

local mouse = game.Players.LocalPlayer:GetMouse()
mouse.KeyDown:connect(function(key)
if key == "j" then 
_G.Noslow = Raziq
elseif key == "k" then
_G.Noslow = lolers
end
end)

while wait(0.5) do 
if _G.Noslow == true then
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.EatSenzu:FireServer(true) 
end 
end
end)
TextLabel_17.Parent = BeanSpam
TextLabel_17.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_17.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_17.BackgroundTransparency = 1.000
TextLabel_17.BorderSizePixel = 0
TextLabel_17.Position = UDim2.new(0.49708572, 0, 0.510457337, 0)
TextLabel_17.Size = UDim2.new(1.06563544, -5, 1.18741477, -5)
TextLabel_17.Font = Enum.Font.GothamSemibold
TextLabel_17.Text = "Bean Spam"
TextLabel_17.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_17.TextScaled = true
TextLabel_17.TextSize = 14.000
TextLabel_17.TextWrapped = true

Fusion_S.Name = "Fusion_S"
Fusion_S.Parent = Frame_2
Fusion_S.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Fusion_S.BackgroundTransparency = 1.000
Fusion_S.Position = UDim2.new(0.0149700604, 0, 0.630303025, 0)
Fusion_S.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
Fusion_S.Image = "rbxassetid://2790382281"
Fusion_S.ImageColor3 = Color3.fromRGB(53, 53, 53)
Fusion_S.ScaleType = Enum.ScaleType.Slice
Fusion_S.SliceCenter = Rect.new(4, 4, 252, 252)
Fusion_S.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Fusion Stack";
		Text = "Loaded..";
	})
	
	local plr = game.Players.LocalPlayer
	game.Workspace.Live[plr.Name]["FUSED"]:Destroy()
end)

TextLabel_18.Parent = Fusion_S
TextLabel_18.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_18.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_18.BackgroundTransparency = 1.000
TextLabel_18.BorderSizePixel = 0
TextLabel_18.Position = UDim2.new(0.518813789, 0, 0.46875, 0)
TextLabel_18.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_18.Font = Enum.Font.GothamSemibold
TextLabel_18.Text = "Fusion-S"
TextLabel_18.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_18.TextScaled = true
TextLabel_18.TextSize = 14.000
TextLabel_18.TextWrapped = true

TRespawn.Name = "TRespawn"
TRespawn.Parent = Frame_2
TRespawn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TRespawn.BackgroundTransparency = 1.000
TRespawn.Position = UDim2.new(0.753466606, 0, 0.424242437, 0)
TRespawn.Size = UDim2.new(0.212750033, 0, 0.145454541, 0)
TRespawn.Image = "rbxassetid://2790382281"
TRespawn.ImageColor3 = Color3.fromRGB(53, 53, 53)
TRespawn.ScaleType = Enum.ScaleType.Slice
TRespawn.SliceCenter = Rect.new(4, 4, 252, 252)
TRespawn.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Top Respawn";
		Text = "Loaded..";
	})
	
	while wait() do
		pcall(function()
			game.Players.LocalPlayer.Character.SuperAction:Destroy()
		end)
	end
end)

TextLabel_19.Parent = TRespawn
TextLabel_19.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_19.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_19.BackgroundTransparency = 1.000
TextLabel_19.BorderSizePixel = 0
TextLabel_19.Position = UDim2.new(0.493693382, 0, 0.489625305, 0)
TextLabel_19.Size = UDim2.new(1.05775154, -5, 1.06241584, -5)
TextLabel_19.Font = Enum.Font.GothamSemibold
TextLabel_19.Text = "T-Respawn"
TextLabel_19.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_19.TextScaled = true
TextLabel_19.TextSize = 14.000
TextLabel_19.TextWrapped = true

GodHTC.Name = "GodHTC"
GodHTC.Parent = Frame_2
GodHTC.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GodHTC.BackgroundTransparency = 1.000
GodHTC.Position = UDim2.new(0.508234978, 0, 0.424242437, 0)
GodHTC.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
GodHTC.Image = "rbxassetid://2790382281"
GodHTC.ImageColor3 = Color3.fromRGB(53, 53, 53)
GodHTC.ScaleType = Enum.ScaleType.Slice
GodHTC.SliceCenter = Rect.new(4, 4, 252, 252)
GodHTC.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "God HTC";
		Text = "Loaded..";
	})
	
	local plr = game.Players.LocalPlayer
	game.Workspace.Live[plr.Name].Stats["Ki-Resist"]:Destroy()
	game.Workspace.Live[plr.Name].Stats["Phys-Resist"]:Destroy()
end)

TextLabel_20.Parent = GodHTC
TextLabel_20.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_20.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_20.BackgroundTransparency = 1.000
TextLabel_20.BorderSizePixel = 0
TextLabel_20.Position = UDim2.new(0.518861294, 0, 0.46875, 0)
TextLabel_20.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_20.Font = Enum.Font.GothamSemibold
TextLabel_20.Text = "God-HTC"
TextLabel_20.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_20.TextScaled = true
TextLabel_20.TextSize = 14.000
TextLabel_20.TextWrapped = true

NoPowerLvl.Name = "NoPowerLvl"
NoPowerLvl.Parent = Frame_2
NoPowerLvl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoPowerLvl.BackgroundTransparency = 1.000
NoPowerLvl.Position = UDim2.new(0.261412293, 0, 0.424242437, 0)
NoPowerLvl.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
NoPowerLvl.Image = "rbxassetid://2790382281"
NoPowerLvl.ImageColor3 = Color3.fromRGB(53, 53, 53)
NoPowerLvl.ScaleType = Enum.ScaleType.Slice
NoPowerLvl.SliceCenter = Rect.new(4, 4, 252, 252)
NoPowerLvl.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "No Power Level";
		Text = "Loaded..";
	})
	
	local plr = game.Players.LocalPlayer
	game.Workspace.Live[plr.Name].HumanoidRootPart["PowerLevel"]:Destroy()
end)

TextLabel_21.Parent = NoPowerLvl
TextLabel_21.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_21.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_21.BackgroundTransparency = 1.000
TextLabel_21.BorderSizePixel = 0
TextLabel_21.Position = UDim2.new(0.494983822, 0, 0.489625305, 0)
TextLabel_21.Size = UDim2.new(1.03098965, -5, 1.06241584, -5)
TextLabel_21.Font = Enum.Font.GothamSemibold
TextLabel_21.Text = "No Power Lvl."
TextLabel_21.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_21.TextScaled = true
TextLabel_21.TextSize = 14.000
TextLabel_21.TextWrapped = true

NoLvl.Name = "NoLvl"
NoLvl.Parent = Frame_2
NoLvl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoLvl.BackgroundTransparency = 1.000
NoLvl.Position = UDim2.new(0.0179640725, 0, 0.424242437, 0)
NoLvl.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
NoLvl.Image = "rbxassetid://2790382281"
NoLvl.ImageColor3 = Color3.fromRGB(53, 53, 53)
NoLvl.ScaleType = Enum.ScaleType.Slice
NoLvl.SliceCenter = Rect.new(4, 4, 252, 252)
NoLvl.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "No Level";
		Text = "Loaded..";
	})
	
	game.Players.LocalPlayer.Character:FindFirstChildOfClass("Model"):Destroy()
end)

TextLabel_22.Parent = NoLvl
TextLabel_22.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_22.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_22.BackgroundTransparency = 1.000
TextLabel_22.BorderSizePixel = 0
TextLabel_22.Position = UDim2.new(0.518813789, 0, 0.46875, 0)
TextLabel_22.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_22.Font = Enum.Font.GothamSemibold
TextLabel_22.Text = "No Lvl."
TextLabel_22.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_22.TextScaled = true
TextLabel_22.TextSize = 14.000
TextLabel_22.TextWrapped = true

NoWings.Name = "NoWings"
NoWings.Parent = Frame_2
NoWings.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoWings.BackgroundTransparency = 1.000
NoWings.Position = UDim2.new(0.753466606, 0, 0.218181819, 0)
NoWings.Size = UDim2.new(0.212750033, 0, 0.145454541, 0)
NoWings.Image = "rbxassetid://2790382281"
NoWings.ImageColor3 = Color3.fromRGB(53, 53, 53)
NoWings.ScaleType = Enum.ScaleType.Slice
NoWings.SliceCenter = Rect.new(4, 4, 252, 252)
NoWings.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "No Wings";
		Text = "Loaded..";
	})
	
	local plr = game.Players.LocalPlayer
	game.Workspace.Live[plr.Name]["RebirthWings"]:Destroy()
end)

TextLabel_23.Parent = NoWings
TextLabel_23.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_23.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_23.BackgroundTransparency = 1.000
TextLabel_23.BorderSizePixel = 0
TextLabel_23.Position = UDim2.new(0.490106434, 0, 0.46875, 0)
TextLabel_23.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_23.Font = Enum.Font.GothamSemibold
TextLabel_23.Text = "No Wings"
TextLabel_23.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_23.TextScaled = true
TextLabel_23.TextSize = 14.000
TextLabel_23.TextWrapped = true

NoHalo.Name = "NoHalo"
NoHalo.Parent = Frame_2
NoHalo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoHalo.BackgroundTransparency = 1.000
NoHalo.Position = UDim2.new(0.508234978, 0, 0.218181819, 0)
NoHalo.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
NoHalo.Image = "rbxassetid://2790382281"
NoHalo.ImageColor3 = Color3.fromRGB(53, 53, 53)
NoHalo.ScaleType = Enum.ScaleType.Slice
NoHalo.SliceCenter = Rect.new(4, 4, 252, 252)
NoHalo.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "No Halo";
		Text = "Loaded..";
	})
	
	local plr = game.Players.LocalPlayer
	game.Workspace.Live[plr.Name]["RealHalo"]:Destroy()
end)

TextLabel_24.Parent = NoHalo
TextLabel_24.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_24.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_24.BackgroundTransparency = 1.000
TextLabel_24.BorderSizePixel = 0
TextLabel_24.Position = UDim2.new(0.518861294, 0, 0.46875, 0)
TextLabel_24.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_24.Font = Enum.Font.GothamSemibold
TextLabel_24.Text = "No Halo"
TextLabel_24.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_24.TextScaled = true
TextLabel_24.TextSize = 14.000
TextLabel_24.TextWrapped = true

NoLegs.Name = "NoLegs"
NoLegs.Parent = Frame_2
NoLegs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoLegs.BackgroundTransparency = 1.000
NoLegs.Position = UDim2.new(0.261412293, 0, 0.218181819, 0)
NoLegs.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
NoLegs.Image = "rbxassetid://2790382281"
NoLegs.ImageColor3 = Color3.fromRGB(53, 53, 53)
NoLegs.ScaleType = Enum.ScaleType.Slice
NoLegs.SliceCenter = Rect.new(4, 4, 252, 252)
NoLegs.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "No Legs";
		Text = "Loaded..";
	})
	
	local plr = game.Players.LocalPlayer
	game.Workspace.Live[plr.Name]["LeftUpperLeg"]:Destroy()
	wait(3)
	local plr = game.Players.LocalPlayer
	game.Workspace.Live[plr.Name]["RightUpperLeg"]:Destroy()
end)

TextLabel_25.Parent = NoLegs
TextLabel_25.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_25.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_25.BackgroundTransparency = 1.000
TextLabel_25.BorderSizePixel = 0
TextLabel_25.Position = UDim2.new(0.518988848, 0, 0.46875, 0)
TextLabel_25.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_25.Font = Enum.Font.GothamSemibold
TextLabel_25.Text = "No Legs"
TextLabel_25.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_25.TextScaled = true
TextLabel_25.TextSize = 14.000
TextLabel_25.TextWrapped = true

TC.Name = "TC"
TC.Parent = Frame_2
TC.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TC.BackgroundTransparency = 1.000
TC.Position = UDim2.new(0.0179640725, 0, 0.218181819, 0)
TC.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
TC.Image = "rbxassetid://2790382281"
TC.ImageColor3 = Color3.fromRGB(53, 53, 53)
TC.ScaleType = Enum.ScaleType.Slice
TC.SliceCenter = Rect.new(4, 4, 252, 252)
TC.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "TC Armor Clothing";
		Text = "Loaded..";
	})
	
	local A_1 = game:GetService("Workspace").FriendlyNPCs["TC Armor"]
	local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatStart
	Event:FireServer(A_1)
	wait(1)
	local A_1 = 
	{
		[1] = "k"
	}
	local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance
	Event:FireServer(A_1)
	wait(1)
	local A_1 = 
	{
		[1] = "Purchase"
	}
	local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance
	Event:FireServer(A_1)
	wait(1)
	local A_1 = 
	{
		[1] = "k"
	}
	local Event = game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance
	Event:FireServer(A_1)
	wait(1)
end)

TextLabel_26.Parent = TC
TextLabel_26.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_26.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_26.BackgroundTransparency = 1.000
TextLabel_26.BorderSizePixel = 0
TextLabel_26.Position = UDim2.new(0.518813491, 0, 0.46875, 0)
TextLabel_26.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_26.Font = Enum.Font.GothamSemibold
TextLabel_26.Text = "TC Armor"
TextLabel_26.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_26.TextScaled = true
TextLabel_26.TextSize = 14.000
TextLabel_26.TextWrapped = true

Label_4.Name = "Label"
Label_4.Parent = Frame_2
Label_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Label_4.BackgroundTransparency = 1.000
Label_4.BorderSizePixel = 0
Label_4.Position = UDim2.new(0.0179640725, 0, 0, 0)
Label_4.Size = UDim2.new(0.257485032, 0, 0.175757602, 0)
Label_4.Font = Enum.Font.ArialBold
Label_4.Text = "Kz Page2"
Label_4.TextColor3 = Color3.fromRGB(255, 255, 255)
Label_4.TextScaled = true
Label_4.TextSize = 14.000
Label_4.TextStrokeTransparency = 0.100
Label_4.TextWrapped = true
Label_4.TextXAlignment = Enum.TextXAlignment.Left

Line_3.Name = "Line"
Line_3.Parent = Frame_2
Line_3.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Line_3.Position = UDim2.new(0.0179640707, 0, 0.175757587, 0)
Line_3.Size = UDim2.new(0.949000001, 0, 0.00700000022, 0)

Frame_3.Name = "Frame_3"
Frame_3.Parent = SkidHub_Home
Frame_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_3.BackgroundTransparency = 1.000
Frame_3.Position = UDim2.new(0, 0, 0.0799999982, 0)
Frame_3.Size = UDim2.new(1, 0, 0.942857206, 0)
Frame_3.Visible = false
Frame_3.Image = "rbxassetid://3570695787"
Frame_3.ImageColor3 = Color3.fromRGB(35, 35, 35)
Frame_3.ScaleType = Enum.ScaleType.Slice
Frame_3.SliceCenter = Rect.new(100, 100, 100, 100)
Frame_3.SliceScale = 0.080

Button_2.Name = "Button"
Button_2.Parent = Frame_3
Button_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Button_2.BackgroundTransparency = 1.000
Button_2.Position = UDim2.new(0.0211157892, 0, 0.618181825, 0)
Button_2.Size = UDim2.new(0.945100784, 0, 0.145454541, 0)
Button_2.Image = "rbxassetid://2790382281"
Button_2.ImageColor3 = Color3.fromRGB(53, 53, 53)
Button_2.ScaleType = Enum.ScaleType.Slice
Button_2.SliceCenter = Rect.new(4, 4, 252, 252)

TextLabel_27.Parent = Button_2
TextLabel_27.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_27.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_27.BackgroundTransparency = 1.000
TextLabel_27.BorderSizePixel = 0
TextLabel_27.Position = UDim2.new(0.495132923, 0, 0.46875, 0)
TextLabel_27.Size = UDim2.new(1.00610566, -5, 0.853999913, -5)
TextLabel_27.Font = Enum.Font.GothamSemibold
TextLabel_27.Text = "Open Auto Buyer Service"
TextLabel_27.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_27.TextScaled = true
TextLabel_27.TextSize = 14.000
TextLabel_27.TextWrapped = true

Close_3.Name = "Close"
Close_3.Parent = Frame_3
Close_3.BackgroundTransparency = 1.000
Close_3.Position = UDim2.new(0.835952401, 0, 0.0242424235, 0)
Close_3.Size = UDim2.new(0.0630119815, 0, 0.120999999, 0)
Close_3.ZIndex = 2
Close_3.Image = "rbxassetid://3926305904"
Close_3.ImageRectOffset = Vector2.new(404, 364)
Close_3.ImageRectSize = Vector2.new(36, 36)

Label_5.Name = "Label"
Label_5.Parent = Frame_3
Label_5.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Label_5.BorderColor3 = Color3.fromRGB(0, 255, 0)
Label_5.Position = UDim2.new(0.75, 0, 0.842000008, 0)
Label_5.Size = UDim2.new(0.209999993, 0, 0.103, 0)
Label_5.Font = Enum.Font.SourceSans
Label_5.Text = "Page - 3"
Label_5.TextColor3 = Color3.fromRGB(255, 255, 255)
Label_5.TextSize = 14.000
Label_5.TextStrokeTransparency = 0.100

HTC.Name = "HTC"
HTC.Parent = Frame_3
HTC.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HTC.BackgroundTransparency = 1.000
HTC.Position = UDim2.new(0.753466606, 0, 0.424242437, 0)
HTC.Size = UDim2.new(0.212750033, 0, 0.145454541, 0)
HTC.Image = "rbxassetid://2790382281"
HTC.ImageColor3 = Color3.fromRGB(53, 53, 53)
HTC.ScaleType = Enum.ScaleType.Slice
HTC.SliceCenter = Rect.new(4, 4, 252, 252)
HTC.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "HTC Teleport";
		Text = "Loaded..";
	})
	
	wait(1.3)
	game:GetService("TeleportService"):Teleport(882375367, game.Players.LocalPlayer)
end)

TextLabel_28.Parent = HTC
TextLabel_28.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_28.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_28.BackgroundTransparency = 1.000
TextLabel_28.BorderSizePixel = 0
TextLabel_28.Position = UDim2.new(0.479820251, 0, 0.46875, 0)
TextLabel_28.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_28.Font = Enum.Font.GothamSemibold
TextLabel_28.Text = "HTC"
TextLabel_28.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_28.TextScaled = true
TextLabel_28.TextSize = 14.000
TextLabel_28.TextWrapped = true

Zaros.Name = "Zaros"
Zaros.Parent = Frame_3
Zaros.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Zaros.BackgroundTransparency = 1.000
Zaros.Position = UDim2.new(0.508234978, 0, 0.424242437, 0)
Zaros.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
Zaros.Image = "rbxassetid://2790382281"
Zaros.ImageColor3 = Color3.fromRGB(53, 53, 53)
Zaros.ScaleType = Enum.ScaleType.Slice
Zaros.SliceCenter = Rect.new(4, 4, 252, 252)
Zaros.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Zaros Teleport";
		Text = "Loaded..";
	})
	
	wait(1.3)
	game:GetService("TeleportService"):Teleport(2651456105, game.Players.LocalPlayer) --buyer
end)

TextLabel_29.Parent = Zaros
TextLabel_29.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_29.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_29.BackgroundTransparency = 1.000
TextLabel_29.BorderSizePixel = 0
TextLabel_29.Position = UDim2.new(0.518861294, 0, 0.46875, 0)
TextLabel_29.Size = UDim2.new(1.079, -5, 0.853999972, -5)
TextLabel_29.Font = Enum.Font.GothamSemibold
TextLabel_29.Text = "Zaros"
TextLabel_29.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_29.TextScaled = true
TextLabel_29.TextSize = 14.000
TextLabel_29.TextWrapped = true

Heaven.Name = "Heaven"
Heaven.Parent = Frame_3
Heaven.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Heaven.BackgroundTransparency = 1.000
Heaven.Position = UDim2.new(0.261412293, 0, 0.424242437, 0)
Heaven.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
Heaven.Image = "rbxassetid://2790382281"
Heaven.ImageColor3 = Color3.fromRGB(53, 53, 53)
Heaven.ScaleType = Enum.ScaleType.Slice
Heaven.SliceCenter = Rect.new(4, 4, 252, 252)
Heaven.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Heaven Teleport";
		Text = "Loaded..";
	})
	
	wait(1.3)
	game:GetService("TeleportService"):Teleport(3552157537, game.Players.LocalPlayer)
	end)
	
	TextLabel_30.Parent = Heaven
	TextLabel_30.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_30.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_30.BackgroundTransparency = 1.000
	TextLabel_30.BorderSizePixel = 0
	TextLabel_30.Position = UDim2.new(0.518988848, 0, 0.46875, 0)
	TextLabel_30.Size = UDim2.new(1.079, -5, 0.853999972, -5)
	TextLabel_30.Font = Enum.Font.GothamSemibold
	TextLabel_30.Text = "Heaven"
	TextLabel_30.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_30.TextScaled = true
	TextLabel_30.TextSize = 14.000
	TextLabel_30.TextWrapped = true
	
	Secreat.Name = "Secreat"
	Secreat.Parent = Frame_3
	Secreat.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Secreat.BackgroundTransparency = 1.000
	Secreat.Position = UDim2.new(0.0179640725, 0, 0.424242437, 0)
	Secreat.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
	Secreat.Image = "rbxassetid://2790382281"
	Secreat.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Secreat.ScaleType = Enum.ScaleType.Slice
	Secreat.SliceCenter = Rect.new(4, 4, 252, 252)
	Secreat.MouseButton1Down:connect(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Secret Teleport";
			Text = "Loaded..";
		})
		
		wait(1.3)
		game:GetService("TeleportService"):Teleport(2046990924, game.Players.LocalPlayer)
	end)
	
	TextLabel_31.Parent = Secreat
	TextLabel_31.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_31.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_31.BackgroundTransparency = 1.000
	TextLabel_31.BorderSizePixel = 0
	TextLabel_31.Position = UDim2.new(0.518813789, 0, 0.46875, 0)
	TextLabel_31.Size = UDim2.new(1.079, -5, 0.853999972, -5)
	TextLabel_31.Font = Enum.Font.GothamSemibold
	TextLabel_31.Text = "Secreat"
	TextLabel_31.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_31.TextScaled = true
	TextLabel_31.TextSize = 14.000
	TextLabel_31.TextWrapped = true
	
	Future.Name = "Future"
	Future.Parent = Frame_3
	Future.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Future.BackgroundTransparency = 1.000
	Future.Position = UDim2.new(0.753466606, 0, 0.218181819, 0)
	Future.Size = UDim2.new(0.212750033, 0, 0.145454541, 0)
	Future.Image = "rbxassetid://2790382281"
	Future.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Future.ScaleType = Enum.ScaleType.Slice
	Future.SliceCenter = Rect.new(4, 4, 252, 252)
	Future.MouseButton1Down:connect(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Future Teleport";
			Text = "Loaded..";
		})
		
		wait(1.3)
		game:GetService("TeleportService"):Teleport(569994010, game.Players.LocalPlayer)
	end)
	
	TextLabel_32.Parent = Future
	TextLabel_32.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_32.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_32.BackgroundTransparency = 1.000
	TextLabel_32.BorderSizePixel = 0
	TextLabel_32.Position = UDim2.new(0.479820251, 0, 0.46875, 0)
	TextLabel_32.Size = UDim2.new(1.079, -5, 0.853999972, -5)
	TextLabel_32.Font = Enum.Font.GothamSemibold
	TextLabel_32.Text = "Future"
	TextLabel_32.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_32.TextScaled = true
	TextLabel_32.TextSize = 14.000
	TextLabel_32.TextWrapped = true
	
	Space.Name = "Space"
	Space.Parent = Frame_3
	Space.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Space.BackgroundTransparency = 1.000
	Space.Position = UDim2.new(0.508234978, 0, 0.218181819, 0)
	Space.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
	Space.Image = "rbxassetid://2790382281"
	Space.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Space.ScaleType = Enum.ScaleType.Slice
	Space.SliceCenter = Rect.new(4, 4, 252, 252)
	Space.MouseButton1Down:connect(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Space Teleport";
			Text = "Loaded..";
		})
		
		wait(1.3)
		game:GetService("TeleportService"):Teleport(478132461, game.Players.LocalPlayer)
	end)
	
	TextLabel_33.Parent = Space
	TextLabel_33.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_33.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_33.BackgroundTransparency = 1.000
	TextLabel_33.BorderSizePixel = 0
	TextLabel_33.Position = UDim2.new(0.518861294, 0, 0.46875, 0)
	TextLabel_33.Size = UDim2.new(1.079, -5, 0.853999972, -5)
	TextLabel_33.Font = Enum.Font.GothamSemibold
	TextLabel_33.Text = "Space"
	TextLabel_33.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_33.TextScaled = true
	TextLabel_33.TextSize = 14.000
	TextLabel_33.TextWrapped = true
	
	Namek.Name = "Namek"
	Namek.Parent = Frame_3
	Namek.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Namek.BackgroundTransparency = 1.000
	Namek.Position = UDim2.new(0.261412293, 0, 0.218181819, 0)
	Namek.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
	Namek.Image = "rbxassetid://2790382281"
	Namek.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Namek.ScaleType = Enum.ScaleType.Slice
	Namek.SliceCenter = Rect.new(4, 4, 252, 252)
	Namek.MouseButton1Down:connect(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Namek Teleport";
			Text = "Loaded..";
		})
		
		wait(1.3)
		game:GetService("TeleportService"):Teleport(882399924, game.Players.LocalPlayer)
	end)
	
	TextLabel_34.Parent = Namek
	TextLabel_34.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_34.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_34.BackgroundTransparency = 1.000
	TextLabel_34.BorderSizePixel = 0
	TextLabel_34.Position = UDim2.new(0.518988848, 0, 0.46875, 0)
	TextLabel_34.Size = UDim2.new(1.079, -5, 0.853999972, -5)
	TextLabel_34.Font = Enum.Font.GothamSemibold
	TextLabel_34.Text = "Namek"
	TextLabel_34.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_34.TextScaled = true
	TextLabel_34.TextSize = 14.000
	TextLabel_34.TextWrapped = true
	
	Earth.Name = "Earth"
	Earth.Parent = Frame_3
	Earth.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Earth.BackgroundTransparency = 1.000
	Earth.Position = UDim2.new(0.0179640725, 0, 0.218181819, 0)
	Earth.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
	Earth.Image = "rbxassetid://2790382281"
	Earth.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Earth.ScaleType = Enum.ScaleType.Slice
	Earth.SliceCenter = Rect.new(4, 4, 252, 252)
	Earth.MouseButton1Down:connect(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Earth Teleport";
			Text = "Loaded..";
		})
		wait(1.3)
		game:GetService("TeleportService"):Teleport(536102540, game.Players.LocalPlayer)
	end)
	
	TextLabel_35.Parent = Earth
	TextLabel_35.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_35.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_35.BackgroundTransparency = 1.000
	TextLabel_35.BorderSizePixel = 0
	TextLabel_35.Position = UDim2.new(0.518813789, 0, 0.46875, 0)
	TextLabel_35.Size = UDim2.new(1.079, -5, 0.853999972, -5)
	TextLabel_35.Font = Enum.Font.GothamSemibold
	TextLabel_35.Text = "Earth"
	TextLabel_35.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_35.TextScaled = true
	TextLabel_35.TextSize = 14.000
	TextLabel_35.TextWrapped = true
	
	Label_6.Name = "Label"
	Label_6.Parent = Frame_3
	Label_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label_6.BackgroundTransparency = 1.000
	Label_6.BorderSizePixel = 0
	Label_6.Position = UDim2.new(0.0179640725, 0, 0, 0)
	Label_6.Size = UDim2.new(0.389221549, 0, 0.175757602, 0)
	Label_6.Font = Enum.Font.ArialBold
	Label_6.Text = "Kz Tp Page3"
	Label_6.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label_6.TextScaled = true
	Label_6.TextSize = 14.000
	Label_6.TextStrokeTransparency = 0.100
	Label_6.TextWrapped = true
	Label_6.TextXAlignment = Enum.TextXAlignment.Left
	
	Line_4.Name = "Line"
	Line_4.Parent = Frame_3
	Line_4.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
	Line_4.Position = UDim2.new(0.0179640707, 0, 0.175757587, 0)
	Line_4.Size = UDim2.new(0.949000001, 0, 0.00700000022, 0)
	
	Top_Tp.Name = "Top_Tp"
	Top_Tp.Parent = Frame_3
	Top_Tp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Top_Tp.BackgroundTransparency = 1.000
	Top_Tp.Position = UDim2.new(0.0211691987, 0, 0.812121272, 0)
	Top_Tp.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
	Top_Tp.Image = "rbxassetid://2790382281"
	Top_Tp.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Top_Tp.ScaleType = Enum.ScaleType.Slice
	Top_Tp.SliceCenter = Rect.new(4, 4, 252, 252)
	Top_Tp.MouseButton1Down:connect(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Top Tp";
			Text = "Loaded..";
		})
		wait()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Keybind";
			Text = "Press . To Use";
		})
		wait(2)
		local plr = game:GetService("Players").LocalPlayer
		local mouse = plr:GetMouse()
		
		mouse.KeyDown:connect(function(key)
			if key == "." then
				wait(0.1)
				game.TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(2),{CFrame = CFrame.new(2507.77, 3944.81, -2034.65)}):Play()
			end
		end)
	end)
	
	Top_Tp_2.Name = "Top_Tp"
	Top_Tp_2.Parent = Top_Tp
	Top_Tp_2.AnchorPoint = Vector2.new(0.5, 0.5)
	Top_Tp_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Top_Tp_2.BackgroundTransparency = 1.000
	Top_Tp_2.BorderSizePixel = 0
	Top_Tp_2.Position = UDim2.new(0.518813789, 0, 0.46875, 0)
	Top_Tp_2.Size = UDim2.new(1.079, -5, 0.853999972, -5)
	Top_Tp_2.Font = Enum.Font.GothamSemibold
	Top_Tp_2.Text = "Top"
	Top_Tp_2.TextColor3 = Color3.fromRGB(0, 0, 0)
	Top_Tp_2.TextScaled = true
	Top_Tp_2.TextSize = 14.000
	Top_Tp_2.TextWrapped = true
	
	Broly_Tp.Name = "Broly_Tp"
	Broly_Tp.Parent = Frame_3
	Broly_Tp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Broly_Tp.BackgroundTransparency = 1.000
	Broly_Tp.Position = UDim2.new(0.264617443, 0, 0.812121272, 0)
	Broly_Tp.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
	Broly_Tp.Image = "rbxassetid://2790382281"
	Broly_Tp.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Broly_Tp.ScaleType = Enum.ScaleType.Slice
	Broly_Tp.SliceCenter = Rect.new(4, 4, 252, 252)
	Broly_Tp.MouseButton1Down:connect(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Broly Tp";
			Text = "Loaded..";
		})
		wait()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Keybind";
			Text = "Press , To Use";
		})
		wait(2)
		local plr = game:GetService("Players").LocalPlayer
		local mouse = plr:GetMouse()
		
		mouse.KeyDown:connect(function(key)
			if key == "," then
				wait(0.1)
				game.TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(2),{CFrame = CFrame.new(2751.67725, 3944.85986, -2272.62622, 0.0375976935, 0, 0.99929297, -0, 1, -0, -0.99929297, 0, 0.0375976935)}):Play()
			end
		end)
	end)
	
	
	Broly_Tp_2.Name = "Broly_Tp"
	Broly_Tp_2.Parent = Broly_Tp
	Broly_Tp_2.AnchorPoint = Vector2.new(0.5, 0.5)
	Broly_Tp_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Broly_Tp_2.BackgroundTransparency = 1.000
	Broly_Tp_2.BorderSizePixel = 0
	Broly_Tp_2.Position = UDim2.new(0.518988848, 0, 0.46875, 0)
	Broly_Tp_2.Size = UDim2.new(1.079, -5, 0.853999972, -5)
	Broly_Tp_2.Font = Enum.Font.GothamSemibold
	Broly_Tp_2.Text = "Broly"
	Broly_Tp_2.TextColor3 = Color3.fromRGB(0, 0, 0)
	Broly_Tp_2.TextScaled = true
	Broly_Tp_2.TextSize = 14.000
	Broly_Tp_2.TextWrapped = true
	
	Queue.Name = "Queue"
	Queue.Parent = Frame_3
	Queue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Queue.BackgroundTransparency = 1.000
	Queue.Position = UDim2.new(0.508207202, 0, 0.812121272, 0)
	Queue.Size = UDim2.new(0.209478751, 0, 0.145454541, 0)
	Queue.Image = "rbxassetid://2790382281"
	Queue.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Queue.ScaleType = Enum.ScaleType.Slice
	Queue.SliceCenter = Rect.new(4, 4, 252, 252)
        Queue.MouseButton1Down:connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Queue Teleport";
	Text = "Loaded..";
	})
	wait(1.3)
	game:GetService("TeleportService"):Teleport(3565304751, game.Players.LocalPlayer)
	end)
		
	Queue_2.Name = "Queue"
	Queue_2.Parent = Queue
	Queue_2.AnchorPoint = Vector2.new(0.5, 0.5)
	Queue_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Queue_2.BackgroundTransparency = 1.000
	Queue_2.BorderSizePixel = 0
	Queue_2.Position = UDim2.new(0.518988848, 0, 0.46875, 0)
	Queue_2.Size = UDim2.new(1.079, -5, 0.853999972, -5)
	Queue_2.Font = Enum.Font.GothamSemibold
	Queue_2.Text = "Queue"
	Queue_2.TextColor3 = Color3.fromRGB(0, 0, 0)
	Queue_2.TextScaled = true
	Queue_2.TextSize = 14.000
	Queue_2.TextWrapped = true
	
	Frame_4.Name = "Frame_4"
	Frame_4.Parent = SkidHub_Home
	Frame_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame_4.BackgroundTransparency = 1.000
	Frame_4.Position = UDim2.new(0, 0, 0.0799999982, 0)
	Frame_4.Size = UDim2.new(1, 0, 0.942857206, 0)
	Frame_4.Visible = false
	Frame_4.Image = "rbxassetid://3570695787"
	Frame_4.ImageColor3 = Color3.fromRGB(35, 35, 35)
	Frame_4.ScaleType = Enum.ScaleType.Slice
	Frame_4.SliceCenter = Rect.new(100, 100, 100, 100)
	Frame_4.SliceScale = 0.080
	
	Beans.Name = "Beans"
	Beans.Parent = Frame_4
	Beans.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Beans.BackgroundTransparency = 1.000
	Beans.Position = UDim2.new(0.0179640725, 0, 0.515151501, 0)
	Beans.Size = UDim2.new(0.960349381, 0, 0.145454541, 0)
	Beans.Image = "rbxassetid://2790382281"
	Beans.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Beans.ScaleType = Enum.ScaleType.Slice
	Beans.SliceCenter = Rect.new(4, 4, 252, 252)
	
	TextLabel_36.Parent = Beans
	TextLabel_36.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_36.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_36.BackgroundTransparency = 1.000
	TextLabel_36.BorderSizePixel = 0
	TextLabel_36.Position = UDim2.new(0.541903615, 0, 0.46875, 0)
	TextLabel_36.Size = UDim2.new(0.894717336, -5, 0.853999913, -5)
	TextLabel_36.Font = Enum.Font.GothamSemibold
	TextLabel_36.Text = "Auto Buy Beans"
	TextLabel_36.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_36.TextScaled = true
	TextLabel_36.TextSize = 14.000
	TextLabel_36.TextWrapped = true
	
	Close_4.Name = "Close"
	Close_4.Parent = Frame_4
	Close_4.BackgroundTransparency = 1.000
	Close_4.Position = UDim2.new(0.835952401, 0, 0.0242424235, 0)
	Close_4.Size = UDim2.new(0.0630119815, 0, 0.120999999, 0)
	Close_4.ZIndex = 2
	Close_4.Image = "rbxassetid://3926305904"
	Close_4.ImageRectOffset = Vector2.new(404, 364)
	Close_4.ImageRectSize = Vector2.new(36, 36)
	
	Label_7.Name = "Label"
	Label_7.Parent = Frame_4
	Label_7.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Label_7.BorderColor3 = Color3.fromRGB(0, 255, 0)
	Label_7.Position = UDim2.new(0.75, 0, 0.842000008, 0)
	Label_7.Size = UDim2.new(0.209999993, 0, 0.103, 0)
	Label_7.Font = Enum.Font.SourceSans
	Label_7.Text = "Page - 4"
	Label_7.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label_7.TextSize = 14.000
	Label_7.TextStrokeTransparency = 0.100
	
	Jars.Name = "Jars"
	Jars.Parent = Frame_4
	Jars.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Jars.BackgroundTransparency = 1.000
	Jars.Position = UDim2.new(0.0179640725, 0, 0.333333343, 0)
	Jars.Size = UDim2.new(0.960349381, 0, 0.145454541, 0)
	Jars.Image = "rbxassetid://2790382281"
	Jars.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Jars.ScaleType = Enum.ScaleType.Slice
	Jars.SliceCenter = Rect.new(4, 4, 252, 252)
	
	TextLabel_37.Parent = Jars
	TextLabel_37.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_37.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_37.BackgroundTransparency = 1.000
	TextLabel_37.BorderSizePixel = 0
	TextLabel_37.Position = UDim2.new(0.518813729, 0, 0.46875, 0)
	TextLabel_37.Size = UDim2.new(1.02312469, -5, 0.853999913, -5)
	TextLabel_37.Font = Enum.Font.GothamSemibold
	TextLabel_37.Text = "Auto Buy Jars"
	TextLabel_37.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_37.TextScaled = true
	TextLabel_37.TextSize = 14.000
	TextLabel_37.TextWrapped = true
	
	Label_8.Name = "Label"
	Label_8.Parent = Frame_4
	Label_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label_8.BackgroundTransparency = 1.000
	Label_8.BorderSizePixel = 0
	Label_8.Position = UDim2.new(0.0179640725, 0, 0, 0)
	Label_8.Size = UDim2.new(0.42814371, 0, 0.175757602, 0)
	Label_8.Font = Enum.Font.ArialBold
	Label_8.Text = "Auto Buyer Service"
	Label_8.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label_8.TextScaled = true
	Label_8.TextSize = 14.000
	Label_8.TextStrokeTransparency = 0.100
	Label_8.TextWrapped = true
	Label_8.TextXAlignment = Enum.TextXAlignment.Left
	
	Line_5.Name = "Line"
	Line_5.Parent = Frame_4
	Line_5.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
	Line_5.Position = UDim2.new(0.0179640707, 0, 0.175757587, 0)
	Line_5.Size = UDim2.new(0.949000001, 0, 0.00700000022, 0)
	
	Frame_5.Name = "Frame_5"
	Frame_5.Parent = SkidHub_Home
	Frame_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame_5.BackgroundTransparency = 1.000
	Frame_5.Position = UDim2.new(0, 0, 0.0799999982, 0)
	Frame_5.Size = UDim2.new(1, 0, 0.942857206, 0)
	Frame_5.Visible = false
	Frame_5.Image = "rbxassetid://3570695787"
	Frame_5.ImageColor3 = Color3.fromRGB(35, 35, 35)
	Frame_5.ScaleType = Enum.ScaleType.Slice
	Frame_5.SliceCenter = Rect.new(100, 100, 100, 100)
	Frame_5.SliceScale = 0.080
	
	Yellow_J.Name = "Yellow_J"
	Yellow_J.Parent = Frame_5
	Yellow_J.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Yellow_J.BackgroundTransparency = 1.000
	Yellow_J.Position = UDim2.new(0.0270000007, 0, 0.699000001, 0)
	Yellow_J.Size = UDim2.new(0.960349381, 0, 0.119480528, 0)
	Yellow_J.Image = "rbxassetid://2790382281"
	Yellow_J.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Yellow_J.ScaleType = Enum.ScaleType.Slice
	Yellow_J.SliceCenter = Rect.new(4, 4, 252, 252)
	Yellow_J.MouseButton1Down:connect(function()
	--F8 to enable/disable
--Yellow Jars
game.StarterGui:SetCore("SendNotification", {
Title = "Yellow Jars";
Text = "Press F8 to enable/disable",
Icon = "rbxassetid://5472203252";
Duration = 4;
})
local a = false --do not touch here
game:GetService("UserInputService").InputBegan:connect(function(input, gameProcessedEvent)
if input.KeyCode == Enum.KeyCode.F8 then
   a = not a
end
end)
   
local args = {

     [1] = "k"
}
local args1 = {

     [1] = "Jars"
}
local args3 = {

     [1] = "80"
}
local args4 = {

     [1] = "Yellow"
}
local args5 = {

     [1] = "Yes"
}

while true do
if a then
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatStart:FireServer(Workspace.FriendlyNPCs["Korin BEANS"])
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args1)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args3)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args4)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args5)
else
game:GetService("RunService").RenderStepped:wait()
end
end
end)
	
	TextLabel_38.Parent = Yellow_J
	TextLabel_38.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_38.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_38.BackgroundTransparency = 1.000
	TextLabel_38.BorderSizePixel = 0
	TextLabel_38.Position = UDim2.new(0.492411494, 0, 0.476342231, 0)
	TextLabel_38.Size = UDim2.new(0.988522708, -5, 0.873957574, -5)
	TextLabel_38.Font = Enum.Font.GothamSemibold
	TextLabel_38.Text = "Yellow Jars"
	TextLabel_38.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_38.TextScaled = true
	TextLabel_38.TextSize = 14.000
	TextLabel_38.TextWrapped = true
	
	Blue_J.Name = "Blue_J"
	Blue_J.Parent = Frame_5
	Blue_J.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Blue_J.BackgroundTransparency = 1.000
	Blue_J.Position = UDim2.new(0.0239520967, 0, 0.541125476, 0)
	Blue_J.Size = UDim2.new(0.960349381, 0, 0.119480528, 0)
	Blue_J.Image = "rbxassetid://2790382281"
	Blue_J.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Blue_J.ScaleType = Enum.ScaleType.Slice
	Blue_J.SliceCenter = Rect.new(4, 4, 252, 252)
	Blue_J.MouseButton1Down:connect(function()
	--F7 to enable/disable
--Blue Jars
game.StarterGui:SetCore("SendNotification", {
Title = "Blue Jars";
Text = "Press F7 to enable/disable",
Icon = "rbxassetid://5472203252";
Duration = 4;
})
local a = false --do not touch here
game:GetService("UserInputService").InputBegan:connect(function(input, gameProcessedEvent)
if input.KeyCode == Enum.KeyCode.F7 then
   a = not a
end
end)
   
local args = {

     [1] = "k"
}
local args1 = {

     [1] = "Jars"
}
local args3 = {

     [1] = "80"
}
local args4 = {

     [1] = "Blue"
}
local args5 = {

     [1] = "Yes"
}

while true do
if a then
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatStart:FireServer(Workspace.FriendlyNPCs["Korin BEANS"])
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args1)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args3)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args4)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args5)
else
game:GetService("RunService").RenderStepped:wait()
end
end
end)
	
	TextLabel_39.Parent = Blue_J
	TextLabel_39.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_39.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_39.BackgroundTransparency = 1.000
	TextLabel_39.BorderSizePixel = 0
	TextLabel_39.Position = UDim2.new(0.479969323, 0, 0.476342231, 0)
	TextLabel_39.Size = UDim2.new(0.93869698, -5, 0.873957694, -5)
	TextLabel_39.Font = Enum.Font.GothamSemibold
	TextLabel_39.Text = "Blue Jars"
	TextLabel_39.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_39.TextScaled = true
	TextLabel_39.TextSize = 14.000
	TextLabel_39.TextWrapped = true
	
	Green_J.Name = "Green_J"
	Green_J.Parent = Frame_5
	Green_J.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Green_J.BackgroundTransparency = 1.000
	Green_J.Position = UDim2.new(0.0179640725, 0, 0.391774863, 0)
	Green_J.Size = UDim2.new(0.960349381, 0, 0.119480528, 0)
	Green_J.Image = "rbxassetid://2790382281"
	Green_J.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Green_J.ScaleType = Enum.ScaleType.Slice
	Green_J.SliceCenter = Rect.new(4, 4, 252, 252)
	Green_J.MouseButton1Down:connect(function()
	--F5 to enable/disable
--Green Jars
game.StarterGui:SetCore("SendNotification", {
Title = "Green Jars";
Text = "Press F5 to enable/disable",
Icon = "rbxassetid://5472203252";
Duration = 4;
})
local a = false --do not touch here
game:GetService("UserInputService").InputBegan:connect(function(input, gameProcessedEvent)
if input.KeyCode == Enum.KeyCode.F5 then
   a = not a
end
end)
   
local args = {

     [1] = "k"
}
local args1 = {

     [1] = "Jars"
}
local args3 = {

     [1] = "80"
}
local args4 = {

     [1] = "Green"
}
local args5 = {

     [1] = "Yes"
}

while true do
if a then
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatStart:FireServer(Workspace.FriendlyNPCs["Korin BEANS"])
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args1)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args3)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args4)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args5)
else
game:GetService("RunService").RenderStepped:wait()
end
end
end)
	
	TextLabel_40.Parent = Green_J
	TextLabel_40.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_40.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_40.BackgroundTransparency = 1.000
	TextLabel_40.BorderSizePixel = 0
	TextLabel_40.Position = UDim2.new(0.501792729, 0, 0.460828513, 0)
	TextLabel_40.Size = UDim2.new(0.988578975, -5, 0.873957634, -5)
	TextLabel_40.Font = Enum.Font.GothamSemibold
	TextLabel_40.Text = "Green Jars"
	TextLabel_40.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_40.TextScaled = true
	TextLabel_40.TextSize = 14.000
	TextLabel_40.TextWrapped = true
	
	Close_5.Name = "Close"
	Close_5.Parent = Frame_5
	Close_5.BackgroundTransparency = 1.000
	Close_5.Position = UDim2.new(0.835952401, 0, 0.0242424235, 0)
	Close_5.Size = UDim2.new(0.0630119815, 0, 0.120999999, 0)
	Close_5.ZIndex = 2
	Close_5.Image = "rbxassetid://3926305904"
	Close_5.ImageRectOffset = Vector2.new(404, 364)
	Close_5.ImageRectSize = Vector2.new(36, 36)
	
	Label_9.Name = "Label"
	Label_9.Parent = Frame_5
	Label_9.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Label_9.BorderColor3 = Color3.fromRGB(0, 255, 0)
	Label_9.Position = UDim2.new(0.756389797, 0, 0.854121208, 0)
	Label_9.Size = UDim2.new(0.209999993, 0, 0.103, 0)
	Label_9.Font = Enum.Font.SourceSans
	Label_9.Text = "Page -"
	Label_9.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label_9.TextSize = 14.000
	Label_9.TextStrokeTransparency = 0.100
	
	Red_J.Name = "Red_J"
	Red_J.Parent = Frame_5
	Red_J.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Red_J.BackgroundTransparency = 1.000
	Red_J.Position = UDim2.new(0.0179640725, 0, 0.24242425, 0)
	Red_J.Size = UDim2.new(0.960349381, 0, 0.119480528, 0)
	Red_J.Image = "rbxassetid://2790382281"
	Red_J.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Red_J.ScaleType = Enum.ScaleType.Slice
	Red_J.SliceCenter = Rect.new(4, 4, 252, 252)
	Red_J.MouseButton1Down:connect(function()
	--F6 to enable/disable
--Red Jars
game.StarterGui:SetCore("SendNotification", {
Title = "Red Jars";
Text = "Press F6 to enable/disable",
Icon = "rbxassetid://5472203252";
Duration = 4;
})
local a = false --do not touch here
game:GetService("UserInputService").InputBegan:connect(function(input, gameProcessedEvent)
if input.KeyCode == Enum.KeyCode.F6 then
   a = not a
end
end)
   
local args = {

     [1] = "k"
}
local args1 = {

     [1] = "Jars"
}
local args3 = {

     [1] = "80"
}
local args4 = {

     [1] = "Red"
}
local args5 = {

     [1] = "Yes"
}

while true do
if a then
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatStart:FireServer(Workspace.FriendlyNPCs["Korin BEANS"])
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args1)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args3)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args4)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args5)
else
game:GetService("RunService").RenderStepped:wait()
end
end
end)
	
	TextLabel_41.Parent = Red_J
	TextLabel_41.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_41.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_41.BackgroundTransparency = 1.000
	TextLabel_41.BorderSizePixel = 0
	TextLabel_41.Position = UDim2.new(0.479969114, 0, 0.455546468, 0)
	TextLabel_41.Size = UDim2.new(0.951167345, -5, 0.873957694, -5)
	TextLabel_41.Font = Enum.Font.GothamSemibold
	TextLabel_41.Text = "Red Jars"
	TextLabel_41.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_41.TextScaled = true
	TextLabel_41.TextSize = 14.000
	TextLabel_41.TextWrapped = true
	
	Label_10.Name = "Label"
	Label_10.Parent = Frame_5
	Label_10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label_10.BackgroundTransparency = 1.000
	Label_10.BorderSizePixel = 0
	Label_10.Position = UDim2.new(0.0179640725, 0, 0, 0)
	Label_10.Size = UDim2.new(0.350299388, 0, 0.175757602, 0)
	Label_10.Font = Enum.Font.ArialBold
	Label_10.Text = "Auto Buy Jars"
	Label_10.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label_10.TextScaled = true
	Label_10.TextSize = 14.000
	Label_10.TextStrokeTransparency = 0.100
	Label_10.TextWrapped = true
	Label_10.TextXAlignment = Enum.TextXAlignment.Left
	
	Line_6.Name = "Line"
	Line_6.Parent = Frame_5
	Line_6.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
	Line_6.Position = UDim2.new(0.0179640707, 0, 0.175757587, 0)
	Line_6.Size = UDim2.new(0.949000001, 0, 0.00700000022, 0)
	
	Frame_6.Name = "Frame_6"
	Frame_6.Parent = SkidHub_Home
	Frame_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame_6.BackgroundTransparency = 1.000
	Frame_6.Position = UDim2.new(0, 0, 0.0799999982, 0)
	Frame_6.Size = UDim2.new(1, 0, 0.942857206, 0)
	Frame_6.Visible = false
	Frame_6.Image = "rbxassetid://3570695787"
	Frame_6.ImageColor3 = Color3.fromRGB(35, 35, 35)
	Frame_6.ScaleType = Enum.ScaleType.Slice
	Frame_6.SliceCenter = Rect.new(100, 100, 100, 100)
	Frame_6.SliceScale = 0.080
	
	Yellow_B.Name = "Yellow_B"
	Yellow_B.Parent = Frame_6
	Yellow_B.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Yellow_B.BackgroundTransparency = 1.000
	Yellow_B.Position = UDim2.new(0.0270000007, 0, 0.699000001, 0)
	Yellow_B.Size = UDim2.new(0.960349381, 0, 0.119480528, 0)
	Yellow_B.Image = "rbxassetid://2790382281"
	Yellow_B.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Yellow_B.ScaleType = Enum.ScaleType.Slice
	Yellow_B.SliceCenter = Rect.new(4, 4, 252, 252)
	Yellow_B.MouseButton1Down:connect(function()
	--F4 to enable/disable
--Yellow Beans
game.StarterGui:SetCore("SendNotification", {
Title = "Blue Yellow";
Text = "Press F4 to enable/disable",
Icon = "rbxassetid://5472203252";
Duration = 4;
})
local a = false --do not touch here
game:GetService("UserInputService").InputBegan:connect(function(input, gameProcessedEvent)
if input.KeyCode == Enum.KeyCode.F4 then
   a = not a
end
end)
   
local args = {

     [1] = "k"
}
local args1 = {

     [1] = "Beans"
}
local args3 = {

     [1] = "80"
}
local args4 = {

     [1] = "Yellow"
}
local args5 = {

     [1] = "Yes"
}

while true do
if a then
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatStart:FireServer(Workspace.FriendlyNPCs["Korin BEANS"])
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args1)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args3)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args4)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args5)
else
game:GetService("RunService").RenderStepped:wait()
end
end
end)
	
	TextLabel_42.Parent = Yellow_B
	TextLabel_42.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_42.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_42.BackgroundTransparency = 1.000
	TextLabel_42.BorderSizePixel = 0
	TextLabel_42.Position = UDim2.new(0.492411494, 0, 0.476342231, 0)
	TextLabel_42.Size = UDim2.new(0.988522708, -5, 0.873957574, -5)
	TextLabel_42.Font = Enum.Font.GothamSemibold
	TextLabel_42.Text = "Yellow Beans"
	TextLabel_42.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_42.TextScaled = true
	TextLabel_42.TextSize = 14.000
	TextLabel_42.TextWrapped = true
	
	Blue_B.Name = "Blue_B"
	Blue_B.Parent = Frame_6
	Blue_B.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Blue_B.BackgroundTransparency = 1.000
	Blue_B.Position = UDim2.new(0.0239520967, 0, 0.541125476, 0)
	Blue_B.Size = UDim2.new(0.960349381, 0, 0.119480528, 0)
	Blue_B.Image = "rbxassetid://2790382281"
	Blue_B.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Blue_B.ScaleType = Enum.ScaleType.Slice
	Blue_B.SliceCenter = Rect.new(4, 4, 252, 252)
	Blue_B.MouseButton1Down:connect(function()
	--F3 to enable/disable
--Blue Beans
game.StarterGui:SetCore("SendNotification", {
Title = "Blue Beans";
Text = "Press F3 to enable/disable",
Icon = "rbxassetid://5472203252";
Duration = 4;
})
local a = false --do not touch here
game:GetService("UserInputService").InputBegan:connect(function(input, gameProcessedEvent)
if input.KeyCode == Enum.KeyCode.F3 then
   a = not a
end
end)
   
local args = {

     [1] = "k"
}
local args1 = {

     [1] = "Beans"
}
local args3 = {

     [1] = "80"
}
local args4 = {

     [1] = "Blue"
}
local args5 = {

     [1] = "Yes"
}

while true do
if a then
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatStart:FireServer(Workspace.FriendlyNPCs["Korin BEANS"])
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args1)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args3)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args4)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args5)
else
game:GetService("RunService").RenderStepped:wait()
end
end
end)
	TextLabel_43.Parent = Blue_B
	TextLabel_43.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_43.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_43.BackgroundTransparency = 1.000
	TextLabel_43.BorderSizePixel = 0
	TextLabel_43.Position = UDim2.new(0.479969323, 0, 0.476342231, 0)
	TextLabel_43.Size = UDim2.new(0.93869698, -5, 0.873957694, -5)
	TextLabel_43.Font = Enum.Font.GothamSemibold
	TextLabel_43.Text = "Blue Beans"
	TextLabel_43.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_43.TextScaled = true
	TextLabel_43.TextSize = 14.000
	TextLabel_43.TextWrapped = true
	
	Green_B.Name = "Green_B"
	Green_B.Parent = Frame_6
	Green_B.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Green_B.BackgroundTransparency = 1.000
	Green_B.Position = UDim2.new(0.0179640725, 0, 0.391774863, 0)
	Green_B.Size = UDim2.new(0.960349381, 0, 0.119480528, 0)
	Green_B.Image = "rbxassetid://2790382281"
	Green_B.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Green_B.ScaleType = Enum.ScaleType.Slice
	Green_B.SliceCenter = Rect.new(4, 4, 252, 252)
	Green_B.MouseButton1Down:connect(function()
	--F1 to enable/disable
--Green Beans
game.StarterGui:SetCore("SendNotification", {
Title = "Green Beans";
Text = "Press F1 to enable/disable",
Icon = "rbxassetid://5472203252";
Duration = 4;
})
local a = false --do not touch here
game:GetService("UserInputService").InputBegan:connect(function(input, gameProcessedEvent)
if input.KeyCode == Enum.KeyCode.F1 then
   a = not a
end
end)
   
local args = {

     [1] = "k"
}
local args1 = {

     [1] = "Beans"
}
local args3 = {

     [1] = "80"
}
local args4 = {

     [1] = "Green"
}
local args5 = {

     [1] = "Yes"
}

while true do
if a then
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatStart:FireServer(Workspace.FriendlyNPCs["Korin BEANS"])
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args1)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args3)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args4)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args5)
else
game:GetService("RunService").RenderStepped:wait()
end
end
end)
	
	TextLabel_44.Parent = Green_B
	TextLabel_44.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_44.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_44.BackgroundTransparency = 1.000
	TextLabel_44.BorderSizePixel = 0
	TextLabel_44.Position = UDim2.new(0.501792729, 0, 0.460828513, 0)
	TextLabel_44.Size = UDim2.new(0.988578975, -5, 0.873957634, -5)
	TextLabel_44.Font = Enum.Font.GothamSemibold
	TextLabel_44.Text = "Green Beans"
	TextLabel_44.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_44.TextScaled = true
	TextLabel_44.TextSize = 14.000
	TextLabel_44.TextWrapped = true
	
	Close_6.Name = "Close"
	Close_6.Parent = Frame_6
	Close_6.BackgroundTransparency = 1.000
	Close_6.Position = UDim2.new(0.835952401, 0, 0.0242424235, 0)
	Close_6.Size = UDim2.new(0.0630119815, 0, 0.120999999, 0)
	Close_6.ZIndex = 2
	Close_6.Image = "rbxassetid://3926305904"
	Close_6.ImageRectOffset = Vector2.new(404, 364)
	Close_6.ImageRectSize = Vector2.new(36, 36)
	
	Label_11.Name = "Label"
	Label_11.Parent = Frame_6
	Label_11.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Label_11.BorderColor3 = Color3.fromRGB(0, 255, 0)
	Label_11.Position = UDim2.new(0.756389797, 0, 0.854121208, 0)
	Label_11.Size = UDim2.new(0.209999993, 0, 0.103, 0)
	Label_11.Font = Enum.Font.SourceSans
	Label_11.Text = "Page -"
	Label_11.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label_11.TextSize = 14.000
	Label_11.TextStrokeTransparency = 0.100
	
	Red_B.Name = "Red_B"
	Red_B.Parent = Frame_6
	Red_B.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Red_B.BackgroundTransparency = 1.000
	Red_B.Position = UDim2.new(0.0179640725, 0, 0.24242425, 0)
	Red_B.Size = UDim2.new(0.960349381, 0, 0.119480528, 0)
	Red_B.Image = "rbxassetid://2790382281"
	Red_B.ImageColor3 = Color3.fromRGB(53, 53, 53)
	Red_B.ScaleType = Enum.ScaleType.Slice
	Red_B.SliceCenter = Rect.new(4, 4, 252, 252)
	Red_B.MouseButton1Down:connect(function()
	--F2 to enable/disable
--Red Beans
game.StarterGui:SetCore("SendNotification", {
Title = "Red Beans";
Text = "Press F2 to enable/disable",
Icon = "rbxassetid://5472203252";
Duration = 4;
})
local a = false --do not touch here
game:GetService("UserInputService").InputBegan:connect(function(input, gameProcessedEvent)
if input.KeyCode == Enum.KeyCode.F2 then
   a = not a
end
end)
   
local args = {

     [1] = "k"
}
local args1 = {

     [1] = "Beans"
}
local args3 = {

     [1] = "80"
}
local args4 = {

     [1] = "Red"
}
local args5 = {

     [1] = "Yes"
}

while true do
if a then
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatStart:FireServer(Workspace.FriendlyNPCs["Korin BEANS"])
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args1)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args3)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args4)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args)
wait(.4)
game:GetService("Players").LocalPlayer.Backpack.ServerTraits.ChatAdvance:FireServer(args5)
else
game:GetService("RunService").RenderStepped:wait()
end
end
end)
	
	TextLabel_45.Parent = Red_B
	TextLabel_45.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel_45.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_45.BackgroundTransparency = 1.000
	TextLabel_45.BorderSizePixel = 0
	TextLabel_45.Position = UDim2.new(0.479969114, 0, 0.455546468, 0)
	TextLabel_45.Size = UDim2.new(0.951167345, -5, 0.873957694, -5)
	TextLabel_45.Font = Enum.Font.GothamSemibold
	TextLabel_45.Text = "Red Beans"
	TextLabel_45.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_45.TextScaled = true
	TextLabel_45.TextSize = 14.000
	TextLabel_45.TextWrapped = true
	
	Label_12.Name = "Label"
	Label_12.Parent = Frame_6
	Label_12.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label_12.BackgroundTransparency = 1.000
	Label_12.BorderSizePixel = 0
	Label_12.Position = UDim2.new(0.0179640725, 0, 0, 0)
	Label_12.Size = UDim2.new(0.350299388, 0, 0.175757602, 0)
	Label_12.Font = Enum.Font.ArialBold
	Label_12.Text = "Auto Buy Beans"
	Label_12.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label_12.TextScaled = true
	Label_12.TextSize = 14.000
	Label_12.TextStrokeTransparency = 0.100
	Label_12.TextWrapped = true
	Label_12.TextXAlignment = Enum.TextXAlignment.Left
	
	Line_7.Name = "Line"
	Line_7.Parent = Frame_6
	Line_7.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
	Line_7.Position = UDim2.new(0.0179640707, 0, 0.175757587, 0)
	Line_7.Size = UDim2.new(0.949000001, 0, 0.00700000022, 0)
	
	Frame.Parent = SkidHub_Home
	Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0, 0, 0.0799999982, 0)
	Frame.Size = UDim2.new(1, 0, 0.0228571426, 0)
	
	-- Scripts:
	
	local function BATCJ_fake_script() -- OpenTab.LocalScript 
		local script = Instance.new('LocalScript', OpenTab)
		
		local frame = script.Parent.Parent["Frame_1"]
		local open = false
		
		script.Parent.MouseButton1Click:Connect(function()
			if frame.Visible == false then
				frame.Visible = true
			else
				frame.Visible = false
			end
		end)
		
	end
	coroutine.wrap(BATCJ_fake_script)()
	local function HORO_fake_script() -- kuzo.KeyBind 
		local script = Instance.new('LocalScript', SkidHub_Home)
		
		function PopupGui()
			if script.Parent.Visible == true then script.Parent.Visible = false
			else script.Parent.Visible = true
			end
		end
		
		game:GetService("UserInputService").InputBegan:Connect(function(key)
			if key.KeyCode == Enum.KeyCode.RightControl then
				PopupGui()
			end
		end)
	end
	coroutine.wrap(HORO_fake_script)()
	local function XFBPT_fake_script() -- Close.LocalScript 
		local script = Instance.new('LocalScript', Close)
		
		local frame = script.Parent.Parent.Parent["Frame_1"]
		local open = false
		
		script.Parent.MouseButton1Click:Connect(function()
			if frame.Visible == true then
				frame.Visible = false
			end
		end)
		
	end
	coroutine.wrap(XFBPT_fake_script)()
	local function XTTSH_fake_script() -- Next.LocalScript 
		local script = Instance.new('LocalScript', Next)
		
		local frame = script.Parent.Parent.Parent["Frame_2"]
		local open = false
		
		script.Parent.MouseButton1Click:Connect(function()
			if frame.Visible == false then
				frame.Visible = true
			end
		end)
		
	end
	coroutine.wrap(XTTSH_fake_script)()
	local function QTNZEE_fake_script() -- Close_2.LocalScript 
		local script = Instance.new('LocalScript', Close_2)
		
		local frame = script.Parent.Parent.Parent["Frame_2"]
		local open = false
		
		script.Parent.MouseButton1Click:Connect(function()
			if frame.Visible == true then
				frame.Visible = false
			end
		end)
		
	end
	coroutine.wrap(QTNZEE_fake_script)()
	local function PAAVKY_fake_script() -- Button.LocalScript 
		local script = Instance.new('LocalScript', Button)
		
		local frame = script.Parent.Parent.Parent["Frame_3"]
		local open = false
		
		script.Parent.MouseButton1Click:Connect(function()
			if frame.Visible == false then
				frame.Visible = true
			end
		end)
		
	end
	coroutine.wrap(PAAVKY_fake_script)()
	local function BYUXCW_fake_script() -- Button_2.LocalScript 
		local script = Instance.new('LocalScript', Button_2)
		
		local frame = script.Parent.Parent.Parent["Frame_4"]
		local open = false
		
		script.Parent.MouseButton1Click:Connect(function()
			if frame.Visible == false then
				frame.Visible = true
			end
		end)
		
	end
	coroutine.wrap(BYUXCW_fake_script)()
	local function SXBJBY_fake_script() -- Close_3.LocalScript 
		local script = Instance.new('LocalScript', Close_3)
		
		local frame = script.Parent.Parent.Parent["Frame_3"]
		local open = false
		
		script.Parent.MouseButton1Click:Connect(function()
			if frame.Visible == true then
				frame.Visible = false
			end
		end)
		
	end
	coroutine.wrap(SXBJBY_fake_script)()
	local function QVGBG_fake_script() -- Beans.LocalScript 
		local script = Instance.new('LocalScript', Beans)
		
		local frame = script.Parent.Parent.Parent["Frame_6"]
		local open = false
		
		script.Parent.MouseButton1Click:Connect(function()
			if frame.Visible == false then
				frame.Visible = true
			end
		end)
		
	end
	coroutine.wrap(QVGBG_fake_script)()
	local function KUGI_fake_script() -- Close_4.LocalScript 
		local script = Instance.new('LocalScript', Close_4)
		
		local frame = script.Parent.Parent.Parent["Frame_4"]
		local open = false
		
		script.Parent.MouseButton1Click:Connect(function()
			if frame.Visible == true then
				frame.Visible = false
			end
		end)
		
	end
	coroutine.wrap(KUGI_fake_script)()
	local function NRSAXT_fake_script() -- Jars.LocalScript 
		local script = Instance.new('LocalScript', Jars)
		
		local frame = script.Parent.Parent.Parent["Frame_5"]
		local open = false
		
		script.Parent.MouseButton1Click:Connect(function()
			if frame.Visible == false then
				frame.Visible = true
			end
		end)
		
	end
	coroutine.wrap(NRSAXT_fake_script)()
	local function YJIOAP_fake_script() -- Close_5.LocalScript 
		local script = Instance.new('LocalScript', Close_5)
		
		local frame = script.Parent.Parent.Parent["Frame_5"]
		local open = false
		
		script.Parent.MouseButton1Click:Connect(function()
			if frame.Visible == true then
				frame.Visible = false
			end
		end)
		
	end
	coroutine.wrap(YJIOAP_fake_script)()
	local function ZQSIODC_fake_script() -- Close_6.LocalScript 
		local script = Instance.new('LocalScript', Close_6)
		
		local frame = script.Parent.Parent.Parent["Frame_6"]
		local open = false
		
		script.Parent.MouseButton1Click:Connect(function()
			if frame.Visible == true then
				frame.Visible = false
			end
		end)
		
	end
	coroutine.wrap(ZQSIODC_fake_script)()
game:GetService("RunService").RenderStepped:Connect(function()
for i,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do 
if v.Name:find("Critz") then
v:Destroy()
end end
end)
wait()
game:GetService("RunService").RenderStepped:Connect(function()
for i,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do 
if v.Name:find("Inf") then
v:Destroy()
end end
end)
wait()
game:GetService("RunService").RenderStepped:Connect(function()
for i,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do 
if v.Name:find("Eva") then
v:Destroy()
end end
end)

end)

Fov.Name = "Fov"
Fov.Parent = Main
Fov.BackgroundColor3 = Color3.fromRGB(204, 51, 0)
Fov.Position = UDim2.new(0.245990385, 0, 0.3217364001, 0)
Fov.Size = UDim2.new(0, 36, 0, 20)
Fov.Font = Enum.Font.SourceSans
Fov.Text = "FOV"
Fov.TextColor3 = Color3.fromRGB(0, 0, 0)
Fov.TextSize = 19.000
Fov.MouseButton1Down:connect(function()
loadstring(game:HttpGet("https://gitlab.com/ozukKZ/fov/-/raw/master/FOV.lua", true))()
end)

Frame.Parent = Main
Frame.BackgroundColor3 = Color3.fromRGB(0,255,255)
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new(0, 334, 0, 21)

Frame_2.Parent = Main
Frame_2.BackgroundColor3 = Color3.fromRGB(255,0,0)
Frame_2.BorderSizePixel = 0
Frame_2.Size = UDim2.new(0, 19, 0, 239)

Frame_3.Parent = Main
Frame_3.BackgroundColor3 = Color3.fromRGB(0,255,255)
Frame_3.BorderSizePixel = 0
Frame_3.Position = UDim2.new(0.943113744, 0, 0, 0)
Frame_3.Size = UDim2.new(0, 19, 0, 239)

Frame_4.Parent = Main
Frame_4.BackgroundColor3 = Color3.fromRGB(255,0,0)
Frame_4.BorderSizePixel = 0
Frame_4.Position = UDim2.new(0, 0, 0.912133873, 0)
Frame_4.Size = UDim2.new(0, 334, 0, 21)



TextButton.Parent = Main
TextButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.940119743, 0, 0.00418412685, 0)
TextButton.Size = UDim2.new(0, 21, 0, 20)
TextButton.Text = "X"
TextButton.TextColor3 = Color3.fromRGB(255,105,180)
TextButton.TextSize = 14.000
TextButton.MouseButton1Down:connect(function()
OpenFrame.Visible = true
Main.Visible = false
end)

TextBox_2.Parent = Main
TextBox_2.BackgroundColor3 = Color3.fromRGB(0,255,255)
TextBox_2.BorderSizePixel = 0
TextBox_2.Position = UDim2.new(0.19760479, 0, 0.912133873, 0)
TextBox_2.Size = UDim2.new(0, 200, 0, 21)
TextBox_2.Text = "Utilities TP Create by KZ"
TextBox_2.TextColor3 = Color3.fromRGB(0, 0, 0)
TextBox_2.TextSize = 12.000
end)
