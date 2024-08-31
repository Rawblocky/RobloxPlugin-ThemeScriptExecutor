return function(isInitialLaunch: boolean)
	local json = [[{
	"Property Color": [76, 79, 105],
	"Luau Keyword Color": [76, 79, 105],

	"Background Color": [239, 241, 245],
	"Selection Color": [76, 79, 105],
	"Selection Background Color": [204, 207, 215],
	"Error Color": [210, 15, 57],
	"Warning Color": [254, 100, 11],
	"Find Selection Background Color": [230, 173, 189],
	"Matching Word Background Color": [204, 207, 215],
	"Whitespace Color": [136, 57, 239],
	"Current Line Highlight Color": [239, 241, 245],
	"Ruler Color": [172, 176, 190],
	"Bracket Color": [210, 15, 57],
	"Text Color": [76, 79, 105],
	"Operator Color": [23, 146, 153],
	"Number Color": [254, 100, 11],
	"String Color": [64, 160, 43],
	"Comment Color": [156, 160, 176],
	"Bool Color": [254, 100, 11],
	"\"nil\" Color": [210, 15, 57],
	"Function Name Color": [30, 102, 245],
	"\"function\" Color": [136, 57, 239],
	"\"local\" Color": [136, 57, 239],
	"\"self\" Color": [136, 57, 239],
	"Keyword Color": [136, 57, 239],
	"Built-in Function Color": [30, 102, 245],
	"\"TODO\" Color": [136, 57, 239],
	"Method Color": [30, 102, 245]
}]]
	local theme = game.HttpService:JSONDecode(json)
	local studio = settings().Studio
	for name, color in pairs(theme) do
		color = Color3.fromRGB(color[1], color[2], color[3])
		local success = pcall(function()
			studio[name] = color
		end)
		if not success then
			warn(("%s is not a valid theme color"):format(name))
		end
	end
	if isInitialLaunch then
		print("Script Editor theme set to Catppuccin Latte!")
	else
		print("Theme changed; changed script editor theme to Catppuccin Latte!")
	end
end
