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

local isGuiOpen = false
local frames = {}

local tweenInfo = TweenInfo.new(
	0.5, 
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

local function createInfoFrame(position, labelText, iconId)
	local Frame = Instance.new("Frame")
	Frame.Parent = game.CoreGui["Menu-7yd7"]
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BorderSizePixel = 0
	Frame.Position = position
	Frame.Size = UDim2.new(0, 160, 0, 50)
	Frame.AnchorPoint = Vector2.new(1, 0)
	Frame.Active = true
	Frame.Draggable = true
	Frame.BackgroundTransparency = 1 

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Frame

	local UIGradient = Instance.new("UIGradient")
	UIGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(18, 22, 24)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(39, 39, 39))
	}
	UIGradient.Parent = Frame

	local ImageLabel = Instance.new("ImageLabel")
	ImageLabel.Parent = Frame
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Position = UDim2.new(0.05, 0, 0.5, -16)
	ImageLabel.Size = UDim2.new(0, 32, 0, 32)
	ImageLabel.Image = "rbxassetid://" .. iconId
	ImageLabel.ImageTransparency = 1

	local TextLabel = Instance.new("TextLabel")
	TextLabel.Parent = Frame
	TextLabel.BackgroundTransparency = 1
	TextLabel.Position = UDim2.new(0.30, 0, 0.5, -15)
	TextLabel.Size = UDim2.new(0, 100, 0, 30)
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.Text = labelText
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 20.000
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.TextTransparency = 1 

	return Frame, TextLabel, ImageLabel
end

local basePosition = UDim2.new(0.99, 0, 0, 5)
local icons = {"133746622922498", "100696028038981", "96009847305866", "120279682762468", "129874671449175"}
local labels = {"CPU: 0%", "GPU: 0%", "Memory: 0%", "Ping: 0 ms", "FPS: 0"}

for i, labelText in ipairs(labels) do
	local frame, textLabel, imageLabel = createInfoFrame(
		UDim2.new(basePosition.X.Scale, basePosition.X.Offset, basePosition.Y.Scale, basePosition.Y.Offset + ((i-1) * 60)),
		labelText,
		icons[i]
	)
	table.insert(frames, {frame = frame, textLabel = textLabel, imageLabel = imageLabel})
end

local function toggleGuiStatBoard()
	isGuiOpen = not isGuiOpen

	for i, frameData in ipairs(frames) do
		delay(i * 0.1, function()
			local targetTransparency = isGuiOpen and 0 or 1
			local targetPosition = UDim2.new(
				basePosition.X.Scale,
				basePosition.X.Offset,
				basePosition.Y.Scale,
				basePosition.Y.Offset + ((i-1) * 60) + (isGuiOpen and 0 or 20)
			)

			local frameTween = TweenService:Create(frameData.frame, tweenInfo, {
				BackgroundTransparency = targetTransparency
			})
			frameTween:Play()

			local textTween = TweenService:Create(frameData.textLabel, tweenInfo, {
				TextTransparency = targetTransparency
			})
			textTween:Play()

			local imageTween = TweenService:Create(frameData.imageLabel, tweenInfo, {
				ImageTransparency = targetTransparency
			})
			imageTween:Play()

			local positionTween = TweenService:Create(frameData.frame, tweenInfo, {
				Position = targetPosition
			})
			positionTween:Play()
		end)
	end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local fpsValue = 0
local lastUpdateTime = tick()

RunService.RenderStepped:Connect(function()
	fpsValue = fpsValue + 1
end)

local function updateValues()
	local currentTime = tick()
	local deltaTime = currentTime - lastUpdateTime
	local actualFPS = math.floor(fpsValue / deltaTime)
	local cpuUsage = math.random(10, 70)
	local gpuUsage = math.random(10, 70)
	local memoryUsage = math.random(20, 80)

	frames[1].textLabel.Text = "CPU: " .. "N/A" .. "%"
	frames[2].textLabel.Text = "GPU: " .. "N/A" .. "%"
	frames[3].textLabel.Text = "Memory: " .. "N/A" .. "%"
	frames[4].textLabel.Text = "Ping: " .. "N/A" .. " ms"
	frames[5].textLabel.Text = "FPS: " .. actualFPS

	fpsValue = 0
	lastUpdateTime = currentTime
end

task.spawn(function()
	while true do
		updateValues()
		task.wait(1)
	end
end)

for i = 1,2 do
    getgenv().StatBoard = toggleGuiStatBoard
end
