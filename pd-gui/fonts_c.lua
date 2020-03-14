GUI_FONTS = {} 

function loadGUIFonts()
	GUI_FONTS = {
		["normal_small"] = dxCreateFont("fonts/normal.ttf", 15, false, "antialiased"),
		["normal"] = dxCreateFont("fonts/normal.ttf", 20, false, "antialiased"),
		["normal_big"] = dxCreateFont("fonts/normal.ttf", 30, false, "antialiased"),
		["gtav"] = dxCreateFont("fonts/gtav.ttf", 23, false, "antialiased"),
	}
end 

function getGUIFont(font)
	return GUI_FONTS[font] or "default-bold"
end
