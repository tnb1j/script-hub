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

local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.Name = "Menu-7yd7"
gui.Parent = game.CoreGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.DisplayOrder = 9999

local function maximizePriority(gui)
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	gui.DisplayOrder = 9999

	for _, child in ipairs(gui:GetDescendants()) do
		if child:IsA("GuiObject") then
			child.ZIndex = 9999
		end
	end
end

maximizePriority(gui)

gui.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("GuiObject") then
		descendant.ZIndex = 9999
	end
end)

local CONFIG = {
	OPEN_KEY = Enum.KeyCode.F8,
	Height = 60,
	BackgroundColor = Color3.fromRGB(27, 27, 27),
	HeaderColor = Color3.fromRGB(35, 35, 35),
	ButtonHeight = 40,
	ButtonSpacing = 5,
	TitleColor = Color3.fromRGB(255, 255, 255),
	SubtitleColor = Color3.fromRGB(180, 180, 180),
	ExecuteColor = Color3.fromRGB(70, 70, 70),
	IconColor = Color3.fromRGB(255, 255, 255),
	IconHoverColor = Color3.fromRGB(255, 255, 255),
	IconTint = Color3.fromRGB(255, 255, 255),
	CornerRadius = 8,  
	TimeTextSize = 20,
	IconSize = 35,      
	IconPadding = 8,   
	FadeTime = 0.5,
	TooltipTextSize = 16,
	backButtonHoverColors = Color3.fromRGB(255, 255, 255),

	ShadowColor = Color3.fromRGB(0, 0, 0),
	ShadowTransparency = 0.7,
	HoverAnimationTime = 0.2,

	DefaultFOV = 70,
	MinFOV = 50,
	MaxFOV = 120,
	FOVChangeSpeed = 0.5,

	ButtonHoverColor = Color3.fromRGB(163, 163, 163),
	ButtonPressColor = Color3.fromRGB(163, 163, 163),
	ButtonTransitionSpeed = 0.4
}

getgenv().MyScriptConfig = CONFIG

function updateConfig(newSettings)
	for key, value in pairs(newSettings) do
		if CONFIG[key] ~= nil then
			CONFIG[key] = value
		end
	end
end

getgenv().updateConfig = updateConfig

local FOVController = {
	DefaultFOV = Camera.FieldOfView,
	CurrentFOV = Camera.FieldOfView,
	TargetFOV = Camera.FieldOfView
}

function FOVController:ChangeFOV(newFOV, instant)
	newFOV = math.clamp(newFOV, CONFIG.MinFOV, CONFIG.MaxFOV)
	self.TargetFOV = newFOV

	if instant then
		Camera.FieldOfView = newFOV
		self.CurrentFOV = newFOV
	else
		TS:Create(Camera, 
			TweenInfo.new(CONFIG.FOVChangeSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
			{FieldOfView = newFOV}
		):Play()
		self.CurrentFOV = newFOV
	end
end

function FOVController:ResetFOV(instant)
	self:ChangeFOV(self.DefaultFOV, instant)
end

function FOVController:IncreaseFOV(amount, instant)
	self:ChangeFOV(self.CurrentFOV + (amount or 10), instant)
end

function FOVController:DecreaseFOV(amount, instant)
	self:ChangeFOV(self.CurrentFOV - (amount or 10), instant)
end



-- Taskbar
local function createTaskbar()

	local taskbar = Instance.new("Frame")
	taskbar.Name = "Taskbar"
	taskbar.AnchorPoint = Vector2.new(0.5, 1)
	taskbar.Position = UDim2.new(0.5, 0, 1, 10)
	taskbar.Size = UDim2.new(0, 400, 0, CONFIG.Height)
	taskbar.BackgroundColor3 = CONFIG.BackgroundColor
	taskbar.BorderSizePixel = 0
	taskbar.BackgroundTransparency = 1
	taskbar.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, CONFIG.CornerRadius)
	corner.Parent = taskbar

	local timeLabel = Instance.new("TextLabel")
	timeLabel.Name = "TimeLabel"
	timeLabel.Size = UDim2.new(0, 60, 1, 0)
	timeLabel.Position = UDim2.new(0, 10, 0, 0)
	timeLabel.BackgroundTransparency = 1
	timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	timeLabel.Font = Enum.Font.GothamBold
	timeLabel.TextSize = CONFIG.TimeTextSize
	timeLabel.TextTransparency = 1
	timeLabel.Text = os.date("%H:%M")
	timeLabel.Parent = taskbar

	local iconContainer = Instance.new("Frame")
	iconContainer.Name = "IconContainer"
	iconContainer.Position = UDim2.new(0, 80, 0, 0)
	iconContainer.Size = UDim2.new(1, -90, 1, 0)
	iconContainer.BackgroundTransparency = 1
	iconContainer.Parent = taskbar

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Horizontal
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	listLayout.Padding = UDim.new(0, CONFIG.IconPadding)
	listLayout.Parent = iconContainer

	return taskbar, iconContainer, timeLabel
end

local function createTooltip()
	local tooltip = Instance.new("TextLabel")
	tooltip.BackgroundTransparency = 1
	tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
	tooltip.TextSize = CONFIG.TooltipTextSize
	tooltip.Font = Enum.Font.Gotham
	tooltip.Text = ""
	tooltip.Visible = false
	tooltip.ZIndex = 2
	tooltip.Parent = game.CoreGui
	return tooltip
end


local function toggleTaskbar(taskbar, timeLabel, icons, isVisible)
	local tweenInfo = TweenInfo.new(
		CONFIG.FadeTime, 
		Enum.EasingStyle.Quad, 
		Enum.EasingDirection.Out
	)

	local startPosition = UDim2.new(0.5, 0, 1, 60)
	local endPosition = UDim2.new(0.5, 0, 1, -10)

	local originalTaskbarSize = taskbar.Size
	local originalIconSizes = {}
	for _, icon in ipairs(icons) do
		originalIconSizes[icon] = icon.Size
	end

	local function checkMouseInactivity(taskbar, icons, originalTaskbarSize, originalIconSizes)
		local isMouseOverGUI = false
		local isGUIOpen = false
		local connection1, connection2
		local inactivityTimer = nil
		local INACTIVITY_DURATION = 10 

		local function checkGUIState()
			wait(1.5)
			isGUIOpen = taskbar.BackgroundTransparency == 0
			return isGUIOpen
		end

		local function updateSizes(reduced)
			local targetSize = reduced and 
				UDim2.new(originalTaskbarSize.X.Scale, originalTaskbarSize.X.Offset * 0.9, 
					originalTaskbarSize.Y.Scale, originalTaskbarSize.Y.Offset * 0.9) or 
				originalTaskbarSize

			local targetTransparency = reduced and 0.5 or 0

			local sizeTween = TS:Create(taskbar, TweenInfo.new(0.3), {
				Size = targetSize,
				BackgroundTransparency = targetTransparency
			})
			sizeTween:Play()

			for _, icon in ipairs(icons) do
				local originalSize = originalIconSizes[icon]
				local targetIconSize = reduced and 
					UDim2.new(originalSize.X.Scale, originalSize.X.Offset * 0.9,
						originalSize.Y.Scale, originalSize.Y.Offset * 0.9) or
					originalSize

				local iconTween = TS:Create(icon, TweenInfo.new(0.3), {
					Size = targetIconSize,
					BackgroundTransparency = targetTransparency
				})
				iconTween:Play()
			end
		end

		local function resetInactivityTimer()
			if inactivityTimer then
				task.cancel(inactivityTimer)
				inactivityTimer = nil
			end

			inactivityTimer = task.delay(INACTIVITY_DURATION, function()
				if not isMouseOverGUI and checkGUIState() then
					updateSizes(true) 
				end
			end)
		end



		local function cleanupConnections()
			if connection1 then 
				connection1:Disconnect() 
				connection1 = nil
			end
			if connection2 then 
				connection2:Disconnect() 
				connection2 = nil
			end
			if inactivityTimer then 
				task.cancel(inactivityTimer)
				inactivityTimer = nil
			end
		end

		spawn(function()
			while not checkGUIState() do
				wait(0.1) 
			end

			connection1 = taskbar.MouseEnter:Connect(function()
				isMouseOverGUI = true
				updateSizes(false) 

				if inactivityTimer then
					task.cancel(inactivityTimer)
					inactivityTimer = nil
				end
			end)

			connection2 = taskbar.MouseLeave:Connect(function()
				isMouseOverGUI = false

				resetInactivityTimer()
			end)
			spawn(function()
				if checkGUIState() then
					local mouse = game:GetService("Players").LocalPlayer:GetMouse()
					local mousePosition = Vector2.new(mouse.X, mouse.Y)
					local taskbarPosition = taskbar.AbsolutePosition
					local taskbarSize = taskbar.AbsoluteSize

					isMouseOverGUI = mousePosition.X >= taskbarPosition.X and
						mousePosition.X <= taskbarPosition.X + taskbarSize.X and
						mousePosition.Y >= taskbarPosition.Y and
						mousePosition.Y <= taskbarPosition.Y + taskbarSize.Y

					updateSizes(not isMouseOverGUI)

					if not isMouseOverGUI then
						resetInactivityTimer()
					end
				end

				connection1 = taskbar.MouseEnter:Connect(function()
					isMouseOverGUI = true
					updateSizes(false) 

					if inactivityTimer then
						task.cancel(inactivityTimer)
						inactivityTimer = nil
					end
				end)

				connection2 = taskbar.MouseLeave:Connect(function()
					isMouseOverGUI = false

					resetInactivityTimer()
				end)
			end)
		end)

		return cleanupConnections
	end


	if isVisible then
		taskbar.Position = startPosition
		taskbar.BackgroundTransparency = 1
		timeLabel.TextTransparency = 1

		local positionTween = TS:Create(taskbar, tweenInfo, {
			Position = endPosition,
			BackgroundTransparency = 0
		})

		local timeLabelTween = TS:Create(timeLabel, tweenInfo, {
			TextTransparency = 0
		})

		positionTween:Play()
		timeLabelTween:Play()

		local cleanupFunction = checkMouseInactivity(taskbar, icons, originalTaskbarSize, originalIconSizes)



		spawn(function()
			positionTween.Completed:Wait()

			for i, icon in ipairs(icons) do
				local delay = (i - 1) * 0.1

				spawn(function()
					wait(delay)

					icon.BackgroundTransparency = 1
					icon.Size = UDim2.new(0, CONFIG.IconSize * 0.7, 0, CONFIG.IconSize * 0.7)

					local iconTween = TS:Create(icon, TweenInfo.new(
						0.3, 
						Enum.EasingStyle.Back, 
						Enum.EasingDirection.Out
						), {
							BackgroundTransparency = 0,
							Size = UDim2.new(0, CONFIG.IconSize, 0, CONFIG.IconSize)
						})

					iconTween:Play()
				end)
			end
		end)
	else

		local positionTween = TS:Create(taskbar, tweenInfo, {
			Position = startPosition,
			BackgroundTransparency = 1
		})

		local timeLabelTween = TS:Create(timeLabel, tweenInfo, {
			TextTransparency = 1
		})

		for i = #icons, 1, -1 do
			local icon = icons[i]
			local delay = (#icons - i) * 0.1

			spawn(function()
				wait(delay)

				local iconTween = TS:Create(icon, TweenInfo.new(
					0.3, 
					Enum.EasingStyle.Back, 
					Enum.EasingDirection.In
					), {
						BackgroundTransparency = 1,
						Size = UDim2.new(0, CONFIG.IconSize * 0.7, 0, CONFIG.IconSize * 0.7)
					})

				iconTween:Play()
			end)
		end

		positionTween:Play()
		timeLabelTween:Play()
	end

	spawn(function()
		wait(CONFIG.FadeTime / 2)
		if isVisible then
			FOVController:ChangeFOV(CONFIG.DefaultFOV * 1.2)
		else
			FOVController:ResetFOV()
		end
	end)
end


local taskbar, iconContainer, timeLabel = createTaskbar()
local tooltip = createTooltip()


local icons = {}
local buttonDataList = {}
local dropShadowHolder = {}
local dropShadow = {}



local function closeGUI()
	if taskbar and timeLabel and icons then
		toggleTaskbar(taskbar, timeLabel, icons, false)
	end
end


local function createButton(container, config)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, CONFIG.IconSize, 0, CONFIG.IconSize)
	frame.BackgroundColor3 = config.backButtonHoverColors or Color3.fromRGB(38, 38, 38)
	frame.BackgroundTransparency = config.backgroundTransparency or 1

	local button = Instance.new("ImageButton")

	local buttonSizeReduction = 0.60
	button.Size = UDim2.new(buttonSizeReduction, 0, buttonSizeReduction, 0)
	button.AnchorPoint = Vector2.new(0.5, 0.5)
	button.Position = UDim2.new(0.5, 0, 0.5, 0)

	button.BackgroundColor3 = CONFIG.IconColor
	button.ImageColor3 = config.iconColor or CONFIG.IconTint
	button.Image = config.image

	button.BackgroundTransparency = 1
	button.ImageTransparency = frame.BackgroundTransparency

	frame:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
		button.BackgroundTransparency = 1
		button.ImageTransparency = frame.BackgroundTransparency
	end)

	button.Parent = frame
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, CONFIG.CornerRadius)
	corner.Parent = frame


	local function updateTooltipSize(tooltipText, button)
		local textLength = string.len(tooltipText.Text)
		local newWidth = math.max(100, textLength * 10) 

		tooltipText.Size = UDim2.new(0, newWidth, 0, 30)

		local buttonSize = button.AbsoluteSize
		local tooltipSize = tooltipText.AbsoluteSize

		local xOffset = (buttonSize.X - tooltipSize.X) / 2
		local yOffset = -tooltipSize.Y - 40  

		tooltipText.Position = UDim2.new(
			0, xOffset, 
			1, yOffset
		)
	end

	local function createTooltipAnimation(tooltipText, button)
		updateTooltipSize(tooltipText, button)

		local initialPosition = tooltipText.Position

		local showTween = TS:Create(tooltipText, 
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				Position = initialPosition + UDim2.new(0, 0, 0, -10),
				Transparency = 0
			}
		)

		local hideTween = TS:Create(tooltipText, 
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				Position = initialPosition,
				Transparency = 1
			}
		)

		tooltipText.Position = initialPosition
		tooltipText.Transparency = 1

		button.MouseEnter:Connect(function()
			updateTooltipSize(tooltipText, button)  
			tooltipText.Visible = true
			showTween:Play()
		end)

		button.MouseLeave:Connect(function()
			hideTween:Play()
			hideTween.Completed:Wait()
			tooltipText.Visible = false
		end)
	end

	local tooltipText = Instance.new("TextLabel")
	tooltipText.Name = "TooltipText"
	tooltipText.Visible = false
	tooltipText.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
	tooltipText.BackgroundTransparency = 0.2
	tooltipText.Font = Enum.Font.GothamMedium
	tooltipText.TextSize = CONFIG.TooltipTextSize
	tooltipText.TextColor3 = Color3.fromRGB(255, 255, 255)
	tooltipText.Text = config.name or "Button"
	tooltipText.TextScaled = true

	local textSizeConstraint = Instance.new("UITextSizeConstraint")
	textSizeConstraint.MaxTextSize = CONFIG.TooltipTextSize
	textSizeConstraint.Parent = tooltipText

	local tooltipCorner = Instance.new("UICorner")
	tooltipCorner.CornerRadius = UDim.new(0, 8)
	tooltipCorner.Parent = tooltipText

	createTooltipAnimation(tooltipText, button)

	tooltipText.Parent = button


	local buttonData = {
		button = button,
		frame = frame,
		enabled = config.enabled or false,
		name = config.name or "Button",
		originalColor = button.ImageColor3,

		defaultColor = config.iconColor or CONFIG.IconTint,
		hoverColor = config.hoverColor or CONFIG.ButtonHoverColor,
		pressColor = config.pressColor or CONFIG.ButtonPressColor,
		toggleColor = config.toggleColor or Color3.fromRGB(0, 0, 0),
		disabledColor = config.disabledColor or Color3.fromRGB(0, 0, 0),

		closeOnClick = config.closeOnClick or false,

		toggle = function(self)
			self.enabled = not self.enabled
			self:updateColor()
			return self.enabled
		end,

		updateColor = function(self)
			local targetColor = self.enabled and self.toggleColor or self.disabledColor

			local tween = TS:Create(self.button, 
				TweenInfo.new(CONFIG.ButtonTransitionSpeed), 
				{ImageColor3 = targetColor}
			)
			tween:Play()
		end,


		resetColor = function(self)
			local tween = TS:Create(self.button, 
				TweenInfo.new(CONFIG.ButtonTransitionSpeed), 
				{ImageColor3 = self.defaultColor}
			)
			tween:Play()
		end
	}


	button.MouseButton1Down:Connect(function()
		if buttonData.enabled then
			local tween1 = TS:Create(frame, 
				TweenInfo.new(CONFIG.ButtonTransitionSpeed), 
				{BackgroundColor3 = Color3.fromRGB(255, 255, 255)}
			)
			local tween2 = TS:Create(button, 
				TweenInfo.new(CONFIG.ButtonTransitionSpeed), 
				{ImageColor3 = Color3.fromRGB(0, 0, 0)}
			)
			tween1:Play()
			tween2:Play()
		end
	end)

	button.MouseButton1Up:Connect(function()
		if buttonData.enabled then
			local tween1 = TS:Create(frame, 
				TweenInfo.new(CONFIG.ButtonTransitionSpeed), 
				{BackgroundColor3 = config.backButtonHoverColors or Color3.fromRGB(38, 38, 38)}
			)
			local tween2 = TS:Create(button, 
				TweenInfo.new(CONFIG.ButtonTransitionSpeed), 
				{ImageColor3 = buttonData.defaultColor}
			)
			tween1:Play()
			tween2:Play()
		end
	end)

	button.MouseButton1Click:Connect(function()
		if buttonData.enabled then
			if button.ImageColor3 == Color3.fromRGB(0, 0, 0) then
				local tween1 = TS:Create(frame, 
					TweenInfo.new(CONFIG.ButtonTransitionSpeed), 
					{BackgroundColor3 = config.backButtonHoverColors or Color3.fromRGB(38, 38, 38)}
				)
				local tween2 = TS:Create(button, 
					TweenInfo.new(CONFIG.ButtonTransitionSpeed), 
					{ImageColor3 = buttonData.defaultColor}
				)
				tween1:Play()
				tween2:Play()
			else
				local tween1 = TS:Create(frame, 
					TweenInfo.new(CONFIG.ButtonTransitionSpeed), 
					{BackgroundColor3 = Color3.fromRGB(255, 255, 255)}
				)
				local tween2 = TS:Create(button, 
					TweenInfo.new(CONFIG.ButtonTransitionSpeed), 
					{ImageColor3 = Color3.fromRGB(0, 0, 0)}
				)
				tween1:Play()
				tween2:Play()
			end
		end
	end)

	button.MouseButton1Click:Connect(function()
		if config.action then
			config.action(buttonData)
		end

		buttonData:toggle()

		if buttonData.closeOnClick then
			closeGUI() 
		end
	end)

	frame.Parent = container
	return frame, buttonData
end


local function updateTime(label)
	while true do
		label.Text = os.date("%H:%M")

		local currentTime = os.time()
		local remainingSeconds = 60 - (currentTime % 60)

		wait(remainingSeconds)
	end
end

spawn(function()
	updateTime(timeLabel)
end)

local function animateButtonsAppearance(icons)
	for i, icon in ipairs(icons) do
		local delay = (i - 1) * 0.1

		icon.BackgroundTransparency = 1
		icon.ImageTransparency = 1
		icon.Size = UDim2.new(0, CONFIG.IconSize * 0.5, 0, CONFIG.IconSize * 0.5)

		spawn(function()
			wait(delay)

			local tweenInfo = TweenInfo.new(
				0.3, 
				Enum.EasingStyle.Back, 
				Enum.EasingDirection.Out
			)

			local backgroundTween = TS:Create(icon, tweenInfo, {
				BackgroundTransparency = 0.7,
				ImageTransparency = 0.3
			})

			local sizeTween = TS:Create(icon, tweenInfo, {
				Size = UDim2.new(0, CONFIG.IconSize, 0, CONFIG.IconSize)
			})

			backgroundTween:Play()
			sizeTween:Play()
		end)
	end
end


local isVisible = false
UIS.InputBegan:Connect(function(input, processed)
	if input.KeyCode == CONFIG.OPEN_KEY and not processed then
		isVisible = not isVisible
		toggleTaskbar(taskbar, timeLabel, icons, isVisible)
	end
end)

local ScreenGui = Instance.new("ScreenGui") 
local Frame = Instance.new("Frame") 
local UICorner = Instance.new("UICorner") 
local Menu = Instance.new("ImageButton") 
local Image = Instance.new("ImageLabel") 
local GuiService = game:GetService("GuiService")

if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled then
	
else
Frame.Parent = gui
Frame.Name = "OpenMenu"
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
Frame.BackgroundTransparency = 0.3
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0) 
Frame.BorderSizePixel = 0 
Frame.Position = UDim2.new(0.830, 0, 0, 0) 
Frame.Size = UDim2.new(0, 115, 0, 49) 


UICorner.CornerRadius = UDim.new(1, 0) 
UICorner.Parent = Frame 

Menu.Name = "Menu" 
Menu.Parent = Frame 
Menu.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
Menu.BackgroundTransparency = 1.000 
Menu.BorderColor3 = Color3.fromRGB(0, 0, 0) 
Menu.BorderSizePixel = 0 
Menu.Position = UDim2.new(0.558002651, 0, 0.162123859, 0) 
Menu.Size = UDim2.new(0, 35, 0, 32) 
Menu.Image = "rbxassetid://109900712138994" 

Image.Name = "Image" 
Image.Parent = Frame 
Image.Active = false 
Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
Image.BackgroundTransparency = 1.000 
Image.BorderColor3 = Color3.fromRGB(0, 0, 0) 
Image.BorderSizePixel = 0 
Image.Position = UDim2.new(0.120369896, 0, 0.162123859, 0) 
Image.Selectable = true 
Image.Size = UDim2.new(0, 35, 0, 32) 
Image.Image = "rbxassetid://130498767869873"


Menu.MouseButton1Click:Connect(function()
	isVisible = not isVisible
	toggleTaskbar(taskbar, timeLabel, icons, isVisible)
end)

local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
end

local iconData = {}
local allowedButtonData = {}


for _, data in ipairs(iconData) do
	local icon, buttonData = createButton(
		iconContainer, 
		data
	)
	table.insert(icons, icon)
	table.insert(buttonDataList, buttonData)
end

function createIconButton(params)
	if allowedButtonData ~= nil then
		if allowedButtonData[params.name] == false then
			return nil, nil 
		end
	end



	local newIcon = {
		image = params.image or "rbxassetid://81076981372140",
		name = params.name or "New Button",
		enabled = params.enabled ~= nil and params.enabled or true,
		closeOnClick = params.closeOnClick ~= nil and params.closeOnClick or false,
		action = params.action or function() end
	}

	local icon, buttonData = createButton(iconContainer, newIcon)
	table.insert(icons, icon)
	table.insert(buttonDataList, buttonData)
	table.insert(iconData, newIcon)

	return icon, buttonData
end

local function updateAllowedButtonData(newData)
	for name, value in pairs(newData) do
		allowedButtonData[name] = value
	end
end

getgenv().createButton = createIconButton

for i = 1,2 do
    getgenv().updateAllowedButtonData = updateAllowedButtonData
end
