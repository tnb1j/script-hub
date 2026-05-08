-- Services
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TextChatService = game:GetService("TextChatService")
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TextService = game:GetService("TextService")


-- Home
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local WelcomeFrame = Instance.new("Frame")
local EveningText = Instance.new("TextLabel")
local EveningText_2 = Instance.new("TextLabel")
local DiscordFrame = Instance.new("Frame")
local InfoFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UICorner_2 = Instance.new("UICorner")
local DiscordTitle = Instance.new("TextLabel")
local InfoTitle = Instance.new("TextLabel")
local DiscordDescription = Instance.new("TextLabel")
local CopyButton = Instance.new("ImageButton")
local UICorner_3 = Instance.new("UICorner")
local UIGradient = Instance.new("UIGradient")
local UIGradient_2 = Instance.new("UIGradient")

local InfoSubtitle = Instance.new("TextLabel")
local ExecutorLabel = Instance.new("TextLabel")
local VersionLabel = Instance.new("TextLabel")
local TimeLabel = Instance.new("TextLabel")
local PlayersLabel = Instance.new("TextLabel")
local DeviceLabel = Instance.new("TextLabel")
local GameNameLabel = Instance.new("TextLabel")
local JobIdLabel = Instance.new("TextLabel")


local Home = Instance.new("Frame")

Home.Parent = game.CoreGui["Menu-7yd7"]
Home.Visible = false
Home.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Home.BackgroundTransparency = 1.000
Home.BorderColor3 = Color3.fromRGB(0, 0, 0)
Home.BorderSizePixel = 0
Home.Name = "Home"
Home.Size = UDim2.new(1, 0, 1, 0)


WelcomeFrame.Name = "WelcomeFrame"
WelcomeFrame.Parent = Home
WelcomeFrame.BackgroundTransparency = 1.000
WelcomeFrame.Position = UDim2.new(0, 10, 0, 35)
WelcomeFrame.Size = UDim2.new(0, 200, 0, 50)

EveningText.Name = "EveningText"
EveningText.Parent = WelcomeFrame
EveningText.BackgroundTransparency = 1.000
EveningText.Position = UDim2.new(0.170000002, 0, 0, 0)
EveningText.Size = UDim2.new(0, 225, 0, 43)
EveningText.Font = Enum.Font.GothamBold
EveningText.Text = "Evening, " .. Players.LocalPlayer.Name
EveningText.TextColor3 = Color3.fromRGB(255, 255, 255)
EveningText.TextSize = 28.000
EveningText.TextXAlignment = Enum.TextXAlignment.Left


EveningText_2.Name = "EveningText"
EveningText_2.Parent = EveningText
EveningText_2.BackgroundTransparency = 1.000
EveningText_2.Position = UDim2.new(-0.00333333341, 0, 0.837209284, 0)
EveningText_2.Size = UDim2.new(0, 225, 0, 32)
EveningText_2.Font = Enum.Font.GothamBold
EveningText_2.Text = "it's getting late.."
EveningText_2.TextColor3 = Color3.fromRGB(197, 197, 197)
EveningText_2.TextSize = 18.000
EveningText_2.TextXAlignment = Enum.TextXAlignment.Left
EveningText_2.TextYAlignment = Enum.TextYAlignment.Top

DiscordFrame.Name = "DiscordFrame"
DiscordFrame.Parent = Home
DiscordFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DiscordFrame.BorderSizePixel = 0
DiscordFrame.Position = UDim2.new(0, 69, 0, 154)
DiscordFrame.Size = UDim2.new(0, 346, 0, 154)

UICorner.Parent = DiscordFrame

DiscordTitle.Name = "DiscordTitle"
DiscordTitle.Parent = DiscordFrame
DiscordTitle.BackgroundTransparency = 1.000
DiscordTitle.Position = UDim2.new(0, 20, 0, 17)
DiscordTitle.Size = UDim2.new(1, -20, 0, 20)
DiscordTitle.Font = Enum.Font.GothamBold
DiscordTitle.Text = "GitHub"
DiscordTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordTitle.TextSize = 19.000
DiscordTitle.TextXAlignment = Enum.TextXAlignment.Left

DiscordDescription.Name = "DiscordDescription"
DiscordDescription.Parent = DiscordFrame
DiscordDescription.BackgroundTransparency = 1.000
DiscordDescription.Position = UDim2.new(0, 20, 0, 40)
DiscordDescription.Size = UDim2.new(0.787878811, -20, 0.188515976, 40)
DiscordDescription.Font = Enum.Font.Gotham
DiscordDescription.Text = "We'd love to have you explore our projects! Tap the button to copy the link to our GitHub repository."
DiscordDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordDescription.TextSize = 16.000
DiscordDescription.TextWrapped = true
DiscordDescription.TextXAlignment = Enum.TextXAlignment.Left
DiscordDescription.TextYAlignment = Enum.TextYAlignment.Top

CopyButton.Name = "CopyButton"
CopyButton.Parent = DiscordFrame
CopyButton.BackgroundColor3 = Color3.fromRGB(52, 54, 56)
CopyButton.Position = UDim2.new(0, 20, 0, 107)
CopyButton.Size = UDim2.new(0, 30, 0, 30)
CopyButton.Image = "rbxassetid://78907078763695"
CopyButton.AutoButtonColor = false

UICorner_2.Parent = CopyButton

UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(32, 34, 37)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(50, 53, 58)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(32, 34, 37))
}
UIGradient.Parent = DiscordFrame

CopyButton.MouseButton1Click:Connect(setclipboard("https://github.com/7yd7/Menu-7yd7?tab=readme-ov-file"))


local UICornerCopyButton = Instance.new("UICorner")


UICornerCopyButton.Parent = CopyButton

InfoFrame.Name = "InfoFrame"
InfoFrame.Parent = Home
InfoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InfoFrame.BorderSizePixel = 0
InfoFrame.Position = UDim2.new(0, 69, 0, 320)
InfoFrame.Size = UDim2.new(0, 346, 0, 310) 

InfoTitle.Name = "InfoTitle"
InfoTitle.Parent = InfoFrame
InfoTitle.BackgroundTransparency = 1.000
InfoTitle.Position = UDim2.new(0, 20, 0, 17)
InfoTitle.Size = UDim2.new(1, -20, 0, 20)
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.Text = "Information"
InfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoTitle.TextSize = 19.000
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left

InfoSubtitle.Name = "InfoSubtitle"
InfoSubtitle.Parent = InfoFrame
InfoSubtitle.BackgroundTransparency = 1.000
InfoSubtitle.Position = UDim2.new(0, 20, 0, 40)
InfoSubtitle.Size = UDim2.new(1, -40, 0, 20)
InfoSubtitle.Font = Enum.Font.Gotham
InfoSubtitle.Text = "A brief list of useful data"
InfoSubtitle.TextColor3 = Color3.fromRGB(185, 185, 185)
InfoSubtitle.TextSize = 14.000
InfoSubtitle.TextXAlignment = Enum.TextXAlignment.Left

local function CreateInfoLabel(text, yPos)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1.000
	label.Position = UDim2.new(0, 20, 0, yPos)
	label.Size = UDim2.new(1, -40, 0, 20)
	label.Font = Enum.Font.Gotham
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 14.000
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = InfoFrame
	return label
end

ExecutorLabel = CreateInfoLabel("Executor: Test", 70)
VersionLabel = CreateInfoLabel("Version: Test", 90)
TimeLabel = CreateInfoLabel("Time Since Boot: Test", 110)
PlayersLabel = CreateInfoLabel("Players: Test", 130)
DeviceLabel = CreateInfoLabel("Device: Test", 150)
GameNameLabel = CreateInfoLabel("Game Name: Test", 170)
JobIdLabel = CreateInfoLabel("Game Name: Test", 190)


UICorner.Parent = DiscordFrame
UICorner_2.Parent = InfoFrame
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(32, 34, 37)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(50, 53, 58))
}
UIGradient.Parent = DiscordFrame

UIGradient_2.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(32, 34, 37)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(50, 53, 58))
}
UIGradient_2.Parent = InfoFrame


local FriendsFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIGradient = Instance.new("UIGradient")
local TitleLabel = Instance.new("TextLabel")
local SubtitleLabel = Instance.new("TextLabel")

local OnlineFrame = Instance.new("Frame")
local OfflineFrame = Instance.new("Frame")
local InServerFrame = Instance.new("Frame")
local AllFrame = Instance.new("Frame")


FriendsFrame.Name = "FriendsFrame"
FriendsFrame.Parent = Home
FriendsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FriendsFrame.BorderSizePixel = 0
FriendsFrame.Position = UDim2.new(0, 430, 0, 154) 
FriendsFrame.Size = UDim2.new(0, 396, 0, 230)

UICorner.Parent = FriendsFrame
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(32, 34, 37)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(50, 53, 58))
}
UIGradient.Parent = FriendsFrame

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = FriendsFrame
TitleLabel.BackgroundTransparency = 1.000
TitleLabel.Position = UDim2.new(0, 20, 0, 17)
TitleLabel.Size = UDim2.new(1, -20, 0, 20)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Friends"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 19.000
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

SubtitleLabel.Name = "SubtitleLabel"
SubtitleLabel.Parent = FriendsFrame
SubtitleLabel.BackgroundTransparency = 1.000
SubtitleLabel.Position = UDim2.new(0, 20, 0, 40)
SubtitleLabel.Size = UDim2.new(1, -40, 0, 20)
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.Text = "Information on your friends"
SubtitleLabel.TextColor3 = Color3.fromRGB(185, 185, 185)
SubtitleLabel.TextSize = 14.000
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local function CreateStatusFrame(name, icon, position)
	local frame = Instance.new("Frame")
	frame.Name = name .. "Frame"
	frame.Parent = FriendsFrame
	frame.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
	frame.Position = position
	frame.Size = UDim2.new(0, 150, 0, 45)

	local corner = Instance.new("UICorner")
	corner.Parent = frame

	local iconLabel = Instance.new("ImageLabel")
	iconLabel.Name = "Icon"
	iconLabel.Parent = frame
	iconLabel.BackgroundTransparency = 1
	iconLabel.Position = UDim2.new(0, 10, 0.5, -10)
	iconLabel.Size = UDim2.new(0, 20, 0, 20)
	iconLabel.Image = icon

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Label"
	textLabel.Parent = frame
	textLabel.BackgroundTransparency = 1
	textLabel.Position = UDim2.new(0, 40, 0, 5)
	textLabel.Size = UDim2.new(1, -50, 0, 20)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Text = name
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextSize = 14
	textLabel.TextXAlignment = Enum.TextXAlignment.Left

	local countLabel = Instance.new("TextLabel")
	countLabel.Name = "Count"
	countLabel.Parent = frame
	countLabel.BackgroundTransparency = 1
	countLabel.Position = UDim2.new(0, 40, 0, 25)
	countLabel.Size = UDim2.new(1, -50, 0, 15)
	countLabel.Font = Enum.Font.Gotham
	countLabel.Text = "0 users"
	countLabel.TextColor3 = Color3.fromRGB(185, 185, 185)
	countLabel.TextSize = 12
	countLabel.TextXAlignment = Enum.TextXAlignment.Left

	return frame
end

local onlineFrame = CreateStatusFrame("Online", "rbxassetid://89054941934303", UDim2.new(0, 20, 0, 70))
local offlineFrame = CreateStatusFrame("Offline", "rbxassetid://107087932260084", UDim2.new(0, 180, 0, 70))
local inServerFrame = CreateStatusFrame("In Server", "rbxassetid://81592219795402", UDim2.new(0, 20, 0, 125))
local allFrame = CreateStatusFrame("All", "rbxassetid://119939476442643", UDim2.new(0, 180, 0, 125))

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function UpdateCounts(online, offline, inServer, all)
	onlineFrame.Count.Text = online .. " users"
	offlineFrame.Count.Text = offline .. " users"
	inServerFrame.Count.Text = inServer .. " users"
	allFrame.Count.Text = all .. " users"
end

local function GetFriendsInServer()
	local inServerCount = 0
	local currentPlayers = Players:GetPlayers()

	for _, player in pairs(currentPlayers) do
		if player ~= LocalPlayer then
			local success, isFriend = pcall(function()
				return LocalPlayer:IsFriendsWith(player.UserId)
			end)

			if success and isFriend then
				inServerCount = inServerCount + 1
			end
		end
	end

	return inServerCount
end

local function FetchFriendCounts()
	local success, friendsOnline = pcall(function()
		return LocalPlayer:GetFriendsOnline()
	end)

	if not success then
		warn("Failed to fetch online friends:", friendsOnline)
		return
	end

	local inServerCount = GetFriendsInServer()

	UpdateCounts(
		#friendsOnline,   
		0,                  
		inServerCount,      
		#friendsOnline    
	)
end

spawn(function()
	while wait(10) do
		pcall(FetchFriendCounts)
	end
end)

Players.PlayerAdded:Connect(function()
	pcall(FetchFriendCounts)
end)

Players.PlayerRemoving:Connect(function()
	pcall(FetchFriendCounts)
end)

FetchFriendCounts()




local PlayerInfoFrame = Instance.new("Frame")
local PlayerImage = Instance.new("ImageLabel")
local PlayerNameDisplay = Instance.new("TextLabel")
local PlayerUsername = Instance.new("TextLabel")
local PlayerInfoCorner = Instance.new("UICorner")
local PlayerInfoGradient = Instance.new("UIGradient")

PlayerInfoFrame.Name = "PlayerInfoFrame"
PlayerInfoFrame.Parent = Home
PlayerInfoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerInfoFrame.BorderSizePixel = 0
PlayerInfoFrame.Position = UDim2.new(0, 430, 0, 397) 
PlayerInfoFrame.Size = UDim2.new(0, 290, 0, 90)   

PlayerInfoCorner.Parent = PlayerInfoFrame
PlayerInfoGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(32, 34, 37)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(50, 53, 58))
}
PlayerInfoGradient.Parent = PlayerInfoFrame

PlayerImage.Name = "PlayerImage"
PlayerImage.Parent = PlayerInfoFrame
PlayerImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerImage.BackgroundTransparency = 1
PlayerImage.Position = UDim2.new(0, 20, 0, 9) 
PlayerImage.Size = UDim2.new(0, 70, 0, 70)    
PlayerImage.Image = "" 

local ImageCorner = Instance.new("UICorner")
ImageCorner.CornerRadius = UDim.new(0.5, 0)
ImageCorner.Parent = PlayerImage

PlayerNameDisplay.Name = "DisplayName"
PlayerNameDisplay.Parent = PlayerInfoFrame
PlayerNameDisplay.BackgroundTransparency = 1
PlayerNameDisplay.Position = UDim2.new(0, 100, 0, 30)
PlayerNameDisplay.Size = UDim2.new(1, -80, 0, 20)
PlayerNameDisplay.Font = Enum.Font.GothamBold
PlayerNameDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameDisplay.TextSize = 16
PlayerNameDisplay.TextXAlignment = Enum.TextXAlignment.Left

PlayerUsername.Name = "Username"
PlayerUsername.Parent = PlayerInfoFrame
PlayerUsername.BackgroundTransparency = 1
PlayerUsername.Position = UDim2.new(0, 100, 0, 50) 
PlayerUsername.Size = UDim2.new(1, -80, 0, 20)
PlayerUsername.Font = Enum.Font.Gotham
PlayerUsername.TextColor3 = Color3.fromRGB(185, 185, 185)
PlayerUsername.TextSize = 14
PlayerUsername.TextXAlignment = Enum.TextXAlignment.Left

local function UpdatePlayerInfo()
	local player = game.Players.LocalPlayer

	PlayerImage.Image = Players:GetUserThumbnailAsync(
		player.UserId,
		Enum.ThumbnailType.HeadShot,
		Enum.ThumbnailSize.Size420x420
	)

	local displayName = player.DisplayName
	local username = player.Name

	if displayName and displayName ~= "" then
		PlayerNameDisplay.Text = displayName
		PlayerUsername.Text = "@" .. username
	else
		PlayerNameDisplay.Text = username
		PlayerUsername.Text = "@" .. username
	end
end

spawn(function()
	pcall(UpdatePlayerInfo)
end)

game.Players.LocalPlayer:GetPropertyChangedSignal("DisplayName"):Connect(function()
	pcall(UpdatePlayerInfo)
end)


local KeybindFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local DescriptionLabel = Instance.new("TextLabel")
local KeyLabel = Instance.new("TextLabel")
local KeybindCorner = Instance.new("UICorner")
local KeybindGradient = Instance.new("UIGradient")
local KeyFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")

KeybindFrame.Name = "KeybindFrame"
KeybindFrame.Parent = Home
KeybindFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeybindFrame.BorderSizePixel = 0
KeybindFrame.Position = UDim2.new(0, 430, 0, 497)
KeybindFrame.Size = UDim2.new(0, 260, 0, 100) 

KeybindCorner.Parent = KeybindFrame
KeybindGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(32, 34, 37)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(50, 53, 58))
}
KeybindGradient.Parent = KeybindFrame

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = KeybindFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 15) 
TitleLabel.Size = UDim2.new(1, -30, 0, 20)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Keybind"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

DescriptionLabel.Name = "DescriptionLabel"
DescriptionLabel.Parent = KeybindFrame
DescriptionLabel.BackgroundTransparency = 1
DescriptionLabel.Position = UDim2.new(0, 15, 0, 35) 
DescriptionLabel.Size = UDim2.new(1, -30, 0, 20)
DescriptionLabel.Font = Enum.Font.Gotham
DescriptionLabel.Text = "Change the UI keybind"
DescriptionLabel.TextColor3 = Color3.fromRGB(145, 145, 145)
DescriptionLabel.TextSize = 15
DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left

KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = KeybindFrame
KeyFrame.BackgroundColor3 = Color3.fromRGB(54, 54, 53)
KeyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
KeyFrame.BorderSizePixel = 0
KeyFrame.Position = UDim2.new(0, 15, 0, 60)
KeyFrame.Size = UDim2.new(1, -200, 0, 25)

KeyLabel.Name = "KeyLabel"
KeyLabel.Parent = KeyFrame
KeyLabel.BackgroundColor3 = Color3.fromRGB(54, 54, 53)
KeyLabel.BackgroundTransparency = 1.000
KeyLabel.Position = UDim2.new(0, 150, 0, 0)
KeyLabel.Size = UDim2.new(1, -200, 0, 25)
KeyLabel.Font = Enum.Font.GothamBold
task.delay(1, function()
	KeyLabel.Text = getgenv().MyScriptConfig.OPEN_KEY.Name
end)
KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyLabel.TextSize = 17.000
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left

UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = KeyFrame

local Home = Home
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local blur = Instance.new("BlurEffect")
blur.Parent = Lighting
blur.Size = 0 

local animatedElements = {}
local isAnimating = false
local isGuiOpen = false
local originalFOV = Camera.FieldOfView

local function findElementsForAnimation(parent)
	for _, element in ipairs(parent:GetDescendants()) do
		if element:IsA("Frame") or element:IsA("TextLabel") or element:IsA("ImageLabel") or element:IsA("TextButton") or element:IsA("ImageButton") then
			if element.BackgroundTransparency == 0 then
				table.insert(animatedElements, {
					element = element,
					originalTransparency = element.BackgroundTransparency
				})
			end
			if (element:IsA("TextLabel") or element:IsA("TextButton")) and element.TextTransparency == 0 then
				table.insert(animatedElements, {
					element = element,
					isText = true,
					originalTransparency = element.TextTransparency
				})
			end
			if (element:IsA("ImageLabel") or element:IsA("ImageButton")) and element.ImageTransparency == 0 then
				table.insert(animatedElements, {
					element = element,
					isImage = true,
					originalTransparency = element.ImageTransparency
				})
			end
		end
	end
end

local function setupAnimation()
	findElementsForAnimation(Home)
	for _, item in ipairs(animatedElements) do
		if item.isText then
			item.element.TextTransparency = 1
		elseif item.isImage then
			item.element.ImageTransparency = 1
		else
			item.element.BackgroundTransparency = 1
		end
	end
end

local function hasVisibleElements()
	for _, item in ipairs(animatedElements) do
		if item.isText and item.element.TextTransparency == 0 then
			return true
		elseif item.isImage and item.element.ImageTransparency == 0 then
			return true
		elseif not item.isText and not item.isImage and item.element.BackgroundTransparency == 0 then
			return true
		end
	end
	return false
end

local function animateBlur(targetSize)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(blur, tweenInfo, {Size = targetSize})
	tween:Play()
end

local function animateFOV(targetFOV)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(Camera, tweenInfo, {FieldOfView = targetFOV})
	tween:Play()
end


local function animateOpen()
	isAnimating = true
	animateBlur(20) 
	animateFOV(40)
	for i, item in ipairs(animatedElements) do
		delay(i  * 0.05, function()
			if not isGuiOpen then return end
			local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local goal = {}
			if item.isText then
				goal.TextTransparency = item.originalTransparency
			elseif item.isImage then
				goal.ImageTransparency = item.originalTransparency
			else
				goal.BackgroundTransparency = item.originalTransparency
			end
			local tween = TweenService:Create(item.element, tweenInfo, goal)
			tween:Play()
		end)
	end
	isAnimating = false
end
local function animateClose()
	isAnimating = true
	animateBlur(0)
	animateFOV(originalFOV)

	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	for _, item in ipairs(animatedElements) do
		if isGuiOpen then return end

		local goal = {}
		if item.isText then
			goal.TextTransparency = 1
		elseif item.isImage then
			goal.ImageTransparency = 1
		else
			goal.BackgroundTransparency = 1
		end

		local tween = TweenService:Create(item.element, tweenInfo, goal)
		tween:Play()
	end

	isAnimating = false
end

local function toggleGuiHome()

	if hasVisibleElements() then
		isGuiOpen = false
		animateClose()
	else
		isGuiOpen = true
		animateOpen()
	end
end


setupAnimation()

local function UpdateInfo(executor, version, time, players, Device, GameName, JobId)
	ExecutorLabel.Text = "Executor: " .. executor 
	VersionLabel.Text = "Version: " .. version 
	TimeLabel.Text = "Time Since Boot: " .. time
	PlayersLabel.Text = "Players: " .. players 
	DeviceLabel.Text = "Device: " .. Device 
	GameNameLabel.Text = "Game Name: " .. GameName 
	JobIdLabel.Text = "JobId: " .. JobId 
end

local Players = game:GetService("Players")
local startTime = os.time()

local function formatTime(seconds)
	if seconds < 60 then
		return seconds .. "s"
	elseif seconds < 3600 then
		return math.floor(seconds/60) .. "m"
	else
		return math.floor(seconds/3600) .. "h"
	end
end

local function getPlayerCount()
	local maxPlayers = game.Players.MaxPlayers
	local currentPlayers = #game.Players:GetPlayers()
	return currentPlayers .. "/" .. maxPlayers
end

local identifyexecutor = (pcall(identifyexecutor) and identifyexecutor()) or "Roblox Default"

local GuiService = game:GetService("GuiService")


local function getDeviceType()
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		if GuiService:IsTenFootInterface() then
			return "Tablet"
		else
			return "Mobile"
		end
	elseif UserInputService.KeyboardEnabled then
		return "Pc"
	else
		return "Unknown Device"
	end
end

local deviceType = getDeviceType()

local function updateInfo()
	local timeSinceBoot = formatTime(os.time() - startTime)
	local playerCount = getPlayerCount()
	

	local GamePlaceId = game.PlaceId
	UpdateInfo(identifyexecutor, "v1.2", timeSinceBoot, playerCount, deviceType, game:GetService("MarketplaceService"):GetProductInfo(GamePlaceId).Name, game.JobId)
end

spawn(function()
	while wait(1) do
		updateInfo()
	end
end)

Players.PlayerAdded:Connect(updateInfo)
Players.PlayerRemoving:Connect(updateInfo)

Home.Visible = true

updateInfo()

for i = 1,2 do
    getgenv().toggleGuiHome = toggleGuiHome
end
