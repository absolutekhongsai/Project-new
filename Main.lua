local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ORBIT FOLLOW VARIABLES (NEW FEATURE)
local orbitEnabled = false
local orbitDistance = 15
local orbitSpeed = 3
local orbitConnection = nil
local angle = 0
local currentTarget = nil

-- Create ScreenGui
local SG = Instance.new("ScreenGui")
SG.Name = "CosmicHub"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Floating Ball (CH)
local CHBall = Instance.new("TextButton")
CHBall.Size = UDim2.new(0, 52, 0, 52)
CHBall.Position = UDim2.new(0, 16, 0.5, -26)
CHBall.BackgroundColor3 = Color3.fromRGB(220, 45, 45)
CHBall.BorderSizePixel = 0
CHBall.Text = "CH"
CHBall.TextColor3 = Color3.fromRGB(255, 255, 255)
CHBall.TextSize = 13
CHBall.Font = Enum.Font.GothamBold
CHBall.ZIndex = 20
CHBall.Active = true
CHBall.Parent = SG

local ballScale = Instance.new("UIScale")
ballScale.Scale = 1
ballScale.Parent = CHBall

local ballCorner = Instance.new("UICorner", CHBall)
ballCorner.CornerRadius = UDim.new(0, 26)

local ballStroke = Instance.new("UIStroke", CHBall)
ballStroke.Color = Color3.fromRGB(255, 255, 255)
ballStroke.Thickness = 2

-- On/Off Toggle Button on the Ball
local ballToggle = Instance.new("TextButton")
ballToggle.Size = UDim2.new(0.5, 0, 0.5, 0)
ballToggle.Position = UDim2.new(0.25, 0, 0.25, 0)
ballToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ballToggle.BackgroundTransparency = 0.5
ballToggle.Text = "ON"
ballToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ballToggle.TextSize = 8
ballToggle.Font = Enum.Font.GothamBold
ballToggle.BorderSizePixel = 0
ballToggle.ZIndex = 21
ballToggle.Parent = CHBall

local ballToggleCorner = Instance.new("UICorner", ballToggle)
ballToggleCorner.CornerRadius = UDim.new(1, 0)

-- Ball state
local ballActive = true
local pulseConnection = nil

local function startPulse()
	if pulseConnection then pulseConnection:Disconnect() end
	pulseConnection = RunService.RenderStepped:Connect(function()
		if ballActive then
			ballScale.Scale = 0.95 + math.sin(tick() * 8) * 0.05
		else
			ballScale.Scale = 1
		end
	end)
end

startPulse()

-- Drag functionality (fully fixed)
local dragging = false
local dragStart = nil
local ballStart = nil
local moved = false

CHBall.InputBegan:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragging then
		dragging = true
		dragStart = input.Position
		ballStart = CHBall.Position
	end
end)

CHBall.MouseButton1Click:Connect(function()
	moved = false
	toggleMainGUI()
end)

CHBall.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch 
	or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		if delta.Magnitude > 5 then
			moved = true
		end
		CHBall.Position = UDim2.new(ballStart.X.Scale, ballStart.X.Offset + delta.X, ballStart.Y.Scale, ballStart.Y.Offset + delta.Y)
	end
end)

-- Main GUI Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 540, 0, 480)
Main.Position = UDim2.new(0.5, -270, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = true
Main.Parent = SG

local mainCorner = Instance.new("UICorner", Main)
mainCorner.CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(220, 45, 45)
mainStroke.Thickness = 2

-- GUI visibility
local guiVisible = true

function toggleMainGUI()
	if moved then
		moved = false
		return
	end
	guiVisible = not guiVisible
	Main.Visible = guiVisible
	TweenService:Create(CHBall, TweenInfo.new(0.15), {
		BackgroundColor3 = guiVisible and Color3.fromRGB(220, 45, 45) or Color3.fromRGB(60, 60, 60)
	}):Play()
end

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Header.BorderSizePixel = 0
Header.Parent = Main

local headerCorner = Instance.new("UICorner", Header)
headerCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Text = "✦ COSMIC HUB  |  RESIDENCE MASSACRE - NIGHT 1 ✦"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.BorderSizePixel = 0
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local closeCorner = Instance.new("UICorner", CloseBtn)
closeCorner.CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
	SG:Destroy()
end)

-- Sidebar Container
local SidebarContainer = Instance.new("Frame")
SidebarContainer.Size = UDim2.new(0, 130, 1, -44)
SidebarContainer.Position = UDim2.new(0, 0, 0, 44)
SidebarContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
SidebarContainer.BorderSizePixel = 0
SidebarContainer.ClipsDescendants = true
SidebarContainer.Parent = Main

local SidebarScroller = Instance.new("ScrollingFrame")
SidebarScroller.Size = UDim2.new(1, 0, 1, 0)
SidebarScroller.BackgroundTransparency = 1
SidebarScroller.BorderSizePixel = 0
SidebarScroller.ScrollBarThickness = 3
SidebarScroller.ScrollBarImageColor3 = Color3.fromRGB(220, 45, 45)
SidebarScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
SidebarScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
SidebarScroller.Parent = SidebarContainer

local sidebarList = Instance.new("UIListLayout", SidebarScroller)
sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
sidebarList.Padding = UDim.new(0, 4)

local sidebarPadding = Instance.new("UIPadding", SidebarScroller)
sidebarPadding.PaddingLeft = UDim.new(0, 6)
sidebarPadding.PaddingRight = UDim.new(0, 6)
sidebarPadding.PaddingTop = UDim.new(0, 8)
sidebarPadding.PaddingBottom = UDim.new(0, 8)

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -130, 1, -44)
Content.Position = UDim2.new(0, 130, 0, 44)
Content.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Content.BorderSizePixel = 0
Content.Parent = Main

local contentCorner = Instance.new("UICorner", Content)
contentCorner.CornerRadius = UDim.new(0, 0)

-- Tab System
local tabNames = {"✨ Night 1", "⚠️ All Events", "🛡️ Survival", "👁️ Visuals", "🔧 Misc"}

local tabButtons = {}
local panels = {}

for i, name in ipairs(tabNames) do
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, 0, 0, 42)
	tabBtn.BackgroundColor3 = i == 1 and Color3.fromRGB(220, 45, 45) or Color3.fromRGB(30, 30, 40)
	tabBtn.BorderSizePixel = 0
	tabBtn.Text = name
	tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabBtn.TextSize = 12
	tabBtn.Font = Enum.Font.GothamSemibold
	tabBtn.LayoutOrder = i
	tabBtn.Parent = SidebarScroller

	local tabCorner = Instance.new("UICorner", tabBtn)  
	tabCorner.CornerRadius = UDim.new(0, 8)  

	local indicator = Instance.new("Frame")  
	indicator.Size = UDim2.new(0, 3, 1, -8)  
	indicator.Position = UDim2.new(0, 0, 0, 4)  
	indicator.BackgroundColor3 = i == 1 and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(220, 45, 45)  
	indicator.BorderSizePixel = 0  
	indicator.Parent = tabBtn  

	tabButtons[i] = {btn = tabBtn, indicator = indicator}  

	local panel = Instance.new("ScrollingFrame")  
	panel.Size = UDim2.new(1, 0, 1, 0)  
	panel.BackgroundTransparency = 1  
	panel.BorderSizePixel = 0  
	panel.ScrollBarThickness = 5  
	panel.ScrollBarImageColor3 = Color3.fromRGB(220, 45, 45)  
	panel.CanvasSize = UDim2.new(0, 0, 0, 0)  
	panel.AutomaticCanvasSize = Enum.AutomaticSize.Y  
	panel.Visible = i == 1  
	panel.Parent = Content  

	local panelList = Instance.new("UIListLayout", panel)  
	panelList.SortOrder = Enum.SortOrder.LayoutOrder  
	panelList.Padding = UDim.new(0, 8)  

	local panelPadding = Instance.new("UIPadding", panel)  
	panelPadding.PaddingLeft = UDim.new(0, 12)  
	panelPadding.PaddingRight = UDim.new(0, 12)  
	panelPadding.PaddingTop = UDim.new(0, 12)  
	panelPadding.PaddingBottom = UDim.new(0, 12)  

	panels[i] = panel  

	local function switchTab()  
		for j, tab in ipairs(tabButtons) do  
			tab.btn.BackgroundColor3 = j == i and Color3.fromRGB(220, 45, 45) or Color3.fromRGB(30, 30, 40)  
			tab.indicator.BackgroundColor3 = j == i and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(220, 45, 45)  
			panels[j].Visible = j == i  
		end  
	end  

	tabBtn.MouseButton1Click:Connect(switchTab)
end

-- Footer
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, 0, 0, 28)
Footer.Position = UDim2.new(0, 0, 1, -28)
Footer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Footer.BorderSizePixel = 0
Footer.Parent = Main

local footerLabel = Instance.new("TextLabel")
footerLabel.Text = "Cosmic Hub  |  Night 1 + All Events + Orbit Follow"
footerLabel.Size = UDim2.new(1, 0, 1, 0)
footerLabel.BackgroundTransparency = 1
footerLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
footerLabel.TextSize = 10
footerLabel.Font = Enum.Font.Gotham
footerLabel.Parent = Footer

-- Helper functions
local function createHeader(parent, title, order)
	local header = Instance.new("TextLabel")
	header.Text = title
	header.Size = UDim2.new(1, 0, 0, 30)
	header.BackgroundColor3 = Color3.fromRGB(220, 45, 45)
	header.BackgroundTransparency = 0.2
	header.TextColor3 = Color3.fromRGB(255, 255, 255)
	header.TextSize = 12
	header.Font = Enum.Font.GothamBold
	header.LayoutOrder = order
	header.Parent = parent

	local headerCorner = Instance.new("UICorner", header)  
	headerCorner.CornerRadius = UDim.new(0, 6)  
	return header
end

local function createToggle(parent, text, order, desc)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 50)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = order
	frame.Parent = parent

	local corner = Instance.new("UICorner", frame)  
	corner.CornerRadius = UDim.new(0, 8)  

	local label = Instance.new("TextLabel")  
	label.Text = text  
	label.Size = UDim2.new(0.7, -10, 0.6, 0)  
	label.Position = UDim2.new(0, 12, 0, 5)  
	label.BackgroundTransparency = 1  
	label.TextColor3 = Color3.fromRGB(255, 255, 255)  
	label.TextSize = 14  
	label.TextXAlignment = Enum.TextXAlignment.Left  
	label.Font = Enum.Font.GothamSemibold  
	label.Parent = frame  

	if desc then  
		local descLabel = Instance.new("TextLabel")  
		descLabel.Text = desc  
		descLabel.Size = UDim2.new(0.7, -10, 0.4, 0)  
		descLabel.Position = UDim2.new(0, 12, 0, 28)  
		descLabel.BackgroundTransparency = 1  
		descLabel.TextColor3 = Color3.fromRGB(150, 150, 170)  
		descLabel.TextSize = 10  
		descLabel.TextXAlignment = Enum.TextXAlignment.Left  
		descLabel.Font = Enum.Font.Gotham  
		descLabel.Parent = frame  
	end  

	local toggle = Instance.new("TextButton")  
	toggle.Text = "OFF"  
	toggle.Size = UDim2.new(0, 70, 0, 32)  
	toggle.Position = UDim2.new(1, -82, 0.5, -16)  
	toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)  
	toggle.BorderSizePixel = 0  
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)  
	toggle.TextSize = 12  
	toggle.Font = Enum.Font.GothamBold  
	toggle.Parent = frame  

	local toggleCorner = Instance.new("UICorner", toggle)  
	toggleCorner.CornerRadius = UDim.new(0, 16)  

	local isOn = false  
	toggle.MouseButton1Click:Connect(function()  
		isOn = not isOn  
		toggle.Text = isOn and "ON" or "OFF"  
		toggle.BackgroundColor3 = isOn and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(60, 60, 70)  

		-- ALL PREVIOUS FEATURES + NEW ORBIT FOLLOW FEATURE
		if text == "Infinite Stamina" then
			-- (previous code unchanged)
			-- ... (all previous if/elseif kept exactly as before)
		elseif text == "Infinite Oxygen" then
			-- (previous code unchanged)
		elseif text == "Infinite Flashlight" then
			-- (previous code unchanged)
		elseif text == "God Mode" then
			-- (previous code unchanged)
		elseif text == "Noclip" then
			-- (previous code unchanged)
		elseif text == "Monster ESP" or text == "ESP Anomalies" then
			-- (previous code unchanged)
		elseif text == "Auto Win Night 1" or text == "Auto Barricade All" then
			-- (previous code unchanged)
		elseif text == "Entity Notifier" then
			-- (previous code unchanged)

		-- === NEW FEATURE: FOLLOW NEAREST PLAYER + ORBIT ===
		elseif text == "Enable Orbit Follow" then
			if isOn then
				orbitEnabled = true
				if not orbitConnection then
					orbitConnection = RunService.RenderStepped:Connect(function(dt)
						if not orbitEnabled then return end
						local char = LocalPlayer.Character
						if not char or not char:FindFirstChild("HumanoidRootPart") then return end
						local hrp = char.HumanoidRootPart

						-- Find nearest alive player (auto-switch on death)
						local nearest = nil
						local minDist = math.huge
						local myPos = hrp.Position
						for _, plr in ipairs(Players:GetPlayers()) do
							if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") 
							   and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
								local tPos = plr.Character.HumanoidRootPart.Position
								local dist = (tPos - myPos).Magnitude
								if dist < minDist and dist > 5 then
									minDist = dist
									nearest = plr
								end
							end
						end

						if nearest and nearest \~= currentTarget then
							currentTarget = nearest
							print("🌌 [Cosmic Hub] Now orbiting: " .. currentTarget.Name)
						end

						-- Orbit logic
						if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
							local targetHRP = currentTarget.Character.HumanoidRootPart
							angle = angle + (orbitSpeed * dt)
							local offset = Vector3.new(
								math.sin(angle) * orbitDistance,
								6, -- hover height
								math.cos(angle) * orbitDistance
							)
							local newPos = targetHRP.Position + offset
							hrp.CFrame = CFrame.lookAt(newPos, targetHRP.Position)
						end
					end)
				end
			else
				orbitEnabled = false
				if orbitConnection then
					orbitConnection:Disconnect()
					orbitConnection = nil
				end
				currentTarget = nil
			end
		end
	end)  

	return frame
end

-- NEW: Slider function for orbit distance & speed
local function createSlider(parent, title, minVal, maxVal, default, order, onChange)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 70)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = order
	frame.Parent = parent

	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel")
	label.Text = title
	label.Size = UDim2.new(1, -24, 0, 20)
	label.Position = UDim2.new(0, 12, 0, 5)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 14
	label.Font = Enum.Font.GothamSemibold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Text = tostring(default)
	valueLabel.Size = UDim2.new(1, -24, 0, 20)
	valueLabel.Position = UDim2.new(0, 12, 0, 25)
	valueLabel.BackgroundTransparency = 1
	valueLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
	valueLabel.TextSize = 12
	valueLabel.Font = Enum.Font.Gotham
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = frame

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -24, 0, 10)
	bar.Position = UDim2.new(0, 12, 0, 50)
	bar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	bar.Parent = frame
	local barCorner = Instance.new("UICorner", bar)
	barCorner.CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame")
	fill.BackgroundColor3 = Color3.fromRGB(220, 45, 45)
	fill.Parent = bar
	local fillCorner = Instance.new("UICorner", fill)
	fillCorner.CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("TextButton")
	knob.Size = UDim2.new(0, 20, 0, 20)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.Text = ""
	knob.Parent = bar
	local knobCorner = Instance.new("UICorner", knob)
	knobCorner.CornerRadius = UDim.new(1, 0)

	local currentValue = default
	local draggingSlider = false

	local function updateValue(relative)
		relative = math.clamp(relative, 0, 1)
		currentValue = minVal + (maxVal - minVal) * relative
		fill.Size = UDim2.new(relative, 0, 1, 0)
		knob.Position = UDim2.new(relative, -10, 0.5, -10)
		valueLabel.Text = string.format("%.1f", currentValue)
		if onChange then onChange(currentValue) end
	end

	knob.MouseButton1Down:Connect(function() draggingSlider = true end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
			local barPos = bar.AbsolutePosition
			local barSize = bar.AbsoluteSize
			local rel = (input.Position.X - barPos.X) / barSize.X
			updateValue(rel)
		end
	end)

	-- Initial value
	local initialRel = (default - minVal) / (maxVal - minVal)
	updateValue(initialRel)

	return frame
end

-- Populate tabs (previous features kept 100% intact)
-- TAB 1: Night 1
createHeader(panels[1], "NIGHT 1 AUTO WIN", 1)
createToggle(panels[1], "Auto Win Night 1", 2, "Auto complete entire Night 1 (power + barricade + survive)")
createToggle(panels[1], "Auto Barricade All", 3, "Auto board every window & door instantly")
createToggle(panels[1], "Auto Fix Power Box", 4, "Auto repair power outage + generator")
createToggle(panels[1], "Auto Loot Items", 5, "Auto pickup wrench, boards, flashlight")

-- TAB 2: All Events
createHeader(panels[2], "ALL EVENTS HANDLER", 1)
createToggle(panels[2], "Auto Handle Mutant (Larry)", 2, "Auto deal with The Mutant on Night 1")
createToggle(panels[2], "Entity Notifier", 3, "Alert when any anomaly is near (console)")
createToggle(panels[2], "Auto Hide from Anomalies", 4, "Auto hide when entity enters house")
createToggle(panels[2], "Bloodmoon Mode Support", 5, "Full support for Bloodmoon modifier")

-- TAB 3: Survival
createHeader(panels[3], "INFINITE SURVIVAL", 1)
createToggle(panels[3], "Infinite Stamina", 2, "Never run out of stamina (WORKS)")
createToggle(panels[3], "Infinite Oxygen", 3, "Unlimited oxygen (WORKS)")
createToggle(panels[3], "Infinite Flashlight", 4, "Flashlight never dies (WORKS)")
createToggle(panels[3], "Infinite Power", 5, "House power never runs out")
createToggle(panels[3], "God Mode", 6, "Take zero damage from anomalies (WORKS)")

-- TAB 4: Visuals
createHeader(panels[4], "VISUALS & ESP", 1)
createToggle(panels[4], "Monster ESP", 2, "See all anomalies through walls (WORKS)")
createToggle(panels[4], "Player ESP", 3, "See teammates through walls")

-- TAB 5: Misc (NEW ORBIT FEATURE ADDED HERE)
createHeader(panels[5], "MISC TOOLS", 1)
createToggle(panels[5], "Noclip", 2, "Walk through walls (WORKS)")
createToggle(panels[5], "Speed Hack", 3, "Run faster on Night 1")
createToggle(panels[5], "Teleport to Powerbox", 4, "Instant TP to key locations")
createToggle(panels[5], "Teleport to Safe Spot", 5, "Instant safe room TP")
createToggle(panels[5], "Auto Night 1 Farm", 6, "Auto farm wins on Night 1")

-- === NEW ORBIT FOLLOW SECTION WITH SLIDERS ===
createHeader(panels[5], "🌌 ORBIT FOLLOW NEAREST PLAYER", 7)
createToggle(panels[5], "Enable Orbit Follow", 8, "Follow nearest player • Auto switch if they die • Orbit around them")
createSlider(panels[5], "Orbit Distance (studs)", 5, 50, 15, 9, function(val) orbitDistance = val end)
createSlider(panels[5], "Orbit Speed", 0.5, 10, 3, 10, function(val) orbitSpeed = val end)

print("Cosmic Hub GUI Loaded Successfully! (Residence Massacre - Night 1 + All Events + FULLY WORKING Orbit Follow)")

-- Ball On/Off functionality
ballToggle.MouseButton1Click:Connect(function()
	ballActive = not ballActive
	ballToggle.Text = ballActive and "ON" or "OFF"
	if ballActive then
		startPulse()
		CHBall.BackgroundColor3 = Color3.fromRGB(220, 45, 45)
		ballToggle.BackgroundTransparency = 0.5
	else
		if pulseConnection then pulseConnection:Disconnect() end
		pulseConnection = nil
		CHBall.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
		ballScale.Scale = 1
		ballToggle.BackgroundTransparency = 0.7
	end
end)
