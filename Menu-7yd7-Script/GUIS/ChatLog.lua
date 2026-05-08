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


local taskbar = Instance.new("Frame")
taskbar.Name = "ChatLogs"
taskbar.AnchorPoint = Vector2.new(0.5, 1)
taskbar.Position = UDim2.new(0.5, 0, 1, -80)
taskbar.Size = UDim2.new(0, 400, 0, 200)
taskbar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
taskbar.BorderSizePixel = 0
taskbar.Visible = false
taskbar.Parent = game.CoreGui["Menu-7yd7"]

local function makeUICorners(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
end
makeUICorners(taskbar, 10)

local title = Instance.new("TextLabel")
title.Parent = taskbar
title.Size = UDim2.new(1, -120, 0, 30)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Chat Logs"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

local searchFrame = Instance.new("Frame")
searchFrame.Parent = taskbar
searchFrame.Size = UDim2.new(0, 120, 0, 24)
searchFrame.Position = UDim2.new(1, -135, 0, 3)
searchFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
makeUICorners(searchFrame, 4)


local searchBox = Instance.new("TextBox")
searchBox.Parent = searchFrame
searchBox.Size = UDim2.new(1, -30, 1, 0)
searchBox.Position = UDim2.new(0, 26, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.Text = ""
searchBox.PlaceholderText = "Search..."
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
searchBox.Font = Enum.Font.Gotham
searchBox.TextWrapped = true
searchBox.TextSize = 12
searchBox.TextXAlignment = Enum.TextXAlignment.Left

local searchIcon = Instance.new("ImageLabel")
searchIcon.Parent = searchFrame
searchIcon.Size = UDim2.new(0, 16, 0, 16)
searchIcon.Position = UDim2.new(0, 6, 0.5, -8)
searchIcon.BackgroundTransparency = 1
searchIcon.Image = "rbxassetid://104986431790017"
searchIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)

local underline = Instance.new("Frame")
underline.Parent = taskbar
underline.Size = UDim2.new(1, -20, 0, 2)
underline.Position = UDim2.new(0, 10, 0, 30)
underline.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Parent = taskbar
scrollFrame.Size = UDim2.new(1, -20, 1, -40)
scrollFrame.Position = UDim2.new(0, 10, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 2
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(75, 75, 75)

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.Padding = UDim.new(0)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local processedMessages = {}
local allMessageLogs = {}
local completeMessageLog = {}  
local MESSAGE_COOLDOWN = .5
local MAX_MESSAGES = 30

local function updateScrollFrame()
	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end

	for i = math.max(1, #allMessageLogs - MAX_MESSAGES + 1), #allMessageLogs do
		local log = allMessageLogs[i]
		local textLabel = Instance.new("TextLabel")
		textLabel.Parent = scrollFrame
		textLabel.Size = UDim2.new(1, 0, 0, 15)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "[" .. log.playerName .. "]: " .. log.message
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.Font = Enum.Font.Gotham
		textLabel.TextSize = 14
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextWrapped = true
		textLabel.AutomaticSize = Enum.AutomaticSize.Y
	end

	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end

local function addMessageToLog(playerName, message)
	local currentTime = tick()
	local messageKey = playerName .. ":" .. message

	if not processedMessages[messageKey] or 
		(processedMessages[messageKey] and 
			currentTime - processedMessages[messageKey] > MESSAGE_COOLDOWN) then

		local messageData = {
			playerName = playerName,
			message = message,
			timestamp = currentTime
		}

		table.insert(completeMessageLog, messageData)

		table.insert(allMessageLogs, messageData)

		if #allMessageLogs > MAX_MESSAGES then
			table.remove(allMessageLogs, 1)
		end

		local searchText = searchBox.Text:lower()

		if searchText == "" then
			updateScrollFrame()
		else
			for _, child in ipairs(scrollFrame:GetChildren()) do
				if child:IsA("TextLabel") then
					local childText = child.Text:lower()
					child.Visible = childText:find(searchText) ~= nil
				end
			end
		end

		processedMessages[messageKey] = currentTime
	end
end


local lastSearchText = ""  

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local searchText = searchBox.Text:lower()

	if searchText == "" then
		updateScrollFrame()
		lastSearchText = ""
		return
	end

	if lastSearchText ~= "" and not searchText:find(lastSearchText) then
		updateScrollFrame()
		lastSearchText = ""
		return
	end

	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end

	local matchedResults = 0
	for i = 1, #completeMessageLog do  
		local log = completeMessageLog[i]

		local playerNameMatch = log.playerName:lower():find(searchText)
		local messageMatch = log.message:lower():find(searchText)

		if playerNameMatch or messageMatch then
			local textLabel = Instance.new("TextLabel")
			textLabel.Parent = scrollFrame
			textLabel.Size = UDim2.new(1, 0, 0, 15)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = "[" .. log.playerName .. "]: " .. log.message
			textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			textLabel.Font = Enum.Font.Gotham
			textLabel.TextSize = 14
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.TextWrapped = true
			textLabel.AutomaticSize = Enum.AutomaticSize.Y

			matchedResults = matchedResults + 1
		end
	end

	if matchedResults == 0 then
		local noResultsLabel = Instance.new("TextLabel")
		noResultsLabel.Parent = scrollFrame
		noResultsLabel.Size = UDim2.new(1, 0, 0, 30)
		noResultsLabel.BackgroundTransparency = 1
		noResultsLabel.Text = "No results found"
		noResultsLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		noResultsLabel.Font = Enum.Font.Gotham
		noResultsLabel.TextSize = 14
	end

	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)

	lastSearchText = searchText
end)


for _, player in pairs(Players:GetPlayers()) do
	player.Chatted:Connect(function(msg)
		addMessageToLog(player.Name, msg)
	end)
end

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		addMessageToLog(player.Name, msg)
	end)
end)

if TextChatService then
	TextChatService.OnIncomingMessage = function(message)
		local playerName = message.TextSource and message.TextSource.Name or "System"
		addMessageToLog(playerName, message.Text)
	end
end



local function makeDraggable(frame)
	local dragging = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or 
			input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or 
			input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end


local tweenInfo = TweenInfo.new(
	0.3, 
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut
)

local function setupToggleAnimation(frame)
	local isVisible = false
	local originalPosition = UDim2.new(0.5, 0, 1, -80)
	local hiddenPosition = UDim2.new(0.5, 0, 1, 20)

	local function initializeTransparency()
		for _, child in ipairs(frame:GetDescendants()) do
			if child:IsA("Frame") then
				child.BackgroundTransparency = 1
			elseif child:IsA("TextLabel") then
				child.BackgroundTransparency = 1
				child.TextTransparency = 1
			elseif child:IsA("TextBox") then
				child.BackgroundTransparency = 1
				child.TextTransparency = 1
			elseif child:IsA("ImageLabel") then
				child.BackgroundTransparency = 1
				child.ImageTransparency = 1
			end
		end
		frame.BackgroundTransparency = 1
	end

	initializeTransparency()

	local function toggleVisibility()
		isVisible = not isVisible

		local targetTransparency = isVisible and 0 or 1
		local shadowTargetTransparency = isVisible and 0.6 or 1

		local tweens = {
			TweenService:Create(frame, tweenInfo, {
				BackgroundTransparency = targetTransparency,
				Position = isVisible and originalPosition or hiddenPosition
			})
		}

		for _, child in ipairs(frame:GetDescendants()) do
			if child:IsA("Frame") then
				table.insert(tweens, TweenService:Create(child, tweenInfo, {
					BackgroundTransparency = targetTransparency
				}))
			elseif child:IsA("TextLabel") then
				table.insert(tweens, TweenService:Create(child, tweenInfo, {
					TextTransparency = targetTransparency
				}))
			elseif child:IsA("TextBox") then
				table.insert(tweens, TweenService:Create(child, tweenInfo, {
					TextTransparency = targetTransparency
				}))
			elseif child:IsA("ImageLabel") then
				table.insert(tweens, TweenService:Create(child, tweenInfo, {
					ImageTransparency = targetTransparency
				}))
			end
		end

		for _, tween in ipairs(tweens) do
			tween:Play()
		end

		if isVisible then
			frame.Visible = true
		else
			tweens[1].Completed:Connect(function()
				frame.Visible = false
			end)
		end

		task.spawn(function()
			for i, child in ipairs(frame:GetChildren()) do
				if child:IsA("ScrollingFrame") then
					for j, item in ipairs(child:GetChildren()) do
						if item:IsA("Frame") then
							local delay = isVisible and (j * 0.05) or (0.05 * (#child:GetChildren() - j))

							task.wait(delay)

							TweenService:Create(item, tweenInfo, {
								BackgroundTransparency = targetTransparency,
								Position = UDim2.new(
									item.Position.X.Scale, 
									isVisible and item.Position.X.Offset or (item.Position.X.Offset + 50),
									item.Position.Y.Scale,
									item.Position.Y.Offset
								)
							}):Play()

							for _, subChild in ipairs(item:GetChildren()) do
								if subChild:IsA("TextLabel") then
									TweenService:Create(subChild, tweenInfo, {
										TextTransparency = targetTransparency,
										Position = UDim2.new(
											0,
											isVisible and 15 or 30,
											subChild.Position.Y.Scale,
											subChild.Position.Y.Offset
										)
									}):Play()
								end
							end
						end
					end
				end
			end
		end)
	end

	return toggleVisibility
end

makeDraggable(taskbar)
local toggleFrame = setupToggleAnimation(taskbar)

for i = 1,2 do
    getgenv().ChatLogs = toggleFrame
end
