return function(isInitialLaunch: boolean)
	local json = [[{
	"Property Color": [205, 214, 244],
	"Luau Keyword Color": [205, 214, 244],

	"Background Color": [30, 30, 46],
	"Selection Color": [205, 214, 244],
	"Selection Background Color": [59, 61, 79],
	"Error Color": [243, 139, 168],
	"Warning Color": [250, 179, 135],
	"Find Selection Background Color": [94, 63, 83],
	"Matching Word Background Color": [59, 61, 79],
	"Whitespace Color": [203, 166, 247],
	"Current Line Highlight Color": [30, 30, 46],
	"Ruler Color": [88, 91, 112],
	"Bracket Color": [243, 139, 168],
	"Text Color": [205, 214, 244],
	"Operator Color": [148, 226, 213],
	"Number Color": [250, 179, 135],
	"String Color": [166, 227, 161],
	"Comment Color": [108, 112, 134],
	"Bool Color": [243, 139, 168],
	"\"nil\" Color": [243, 139, 168],
	"Function Name Color": [137, 180, 250],
	"\"function\" Color": [203, 166, 247],
	"\"local\" Color": [203, 166, 247],
	"\"self\" Color": [203, 166, 247],
	"Keyword Color": [203, 166, 247],
	"Built-in Function Color": [137, 180, 250],
	"\"TODO\" Color": [203, 166, 247],
	"Method Color": [137, 180, 250]
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
		print("Script Editor theme set to Catppuccin Mocha!")
	else
		print("Theme changed; changed script editor theme to Catppuccin Mocha!")
	end
end
