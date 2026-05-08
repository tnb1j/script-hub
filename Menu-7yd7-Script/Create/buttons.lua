-- Default buttons

getgenv().createButton({
	image = "rbxassetid://88990494766919",
	name = "Home",
	enabled = true,
	closeOnClick = false,
	action = function(buttonData)
		getgenv().toggleGuiHome()
	end
})

getgenv().createButton({
	image = "rbxassetid://116954918143819",
	name = "Chat Logs",
	enabled = true,
	closeOnClick = false,
	action = function(buttonData)
		getgenv().ChatLogs()
	end
})

getgenv().createButton({
	image = "rbxassetid://72528155303943",
	name = "Stat Board",
	enabled = true,
	closeOnClick = false,
	action = function(buttonData)
		getgenv().StatBoard()
	end
})

getgenv().createButton({
	image = "rbxassetid://114208610575552",
	name = "Universal Scripts",
	enabled = true,
	closeOnClick = false,
	action = function(buttonData)
		getgenv().UniversalScripts()
	end
})
