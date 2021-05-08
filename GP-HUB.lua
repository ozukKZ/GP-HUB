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
loadstring(game:HttpGet("https://gitlab.com/ozukKZ/punch/-/raw/master/Punch%20raw.lua"))()
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
loadstring(game:HttpGet("https://gitlab.com/ozukKZ/hk.z/-/raw/master/UIKZ.lua"))()
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
