local blackWhiteShader = false 
local blackWhiteScreen = false 

function drawBWRectangle(x, y, w, h, color, postgui)
	if not blackWhiteShader then 
		blackWhiteShader = dxCreateShader("fx/blackwhite.fx", 0, 0, false, "other")
		blackWhiteScreen = dxCreateScreenSource(SW, SH)
	end
	
	dxUpdateScreenSource(blackWhiteScreen, true)
	dxSetShaderValue(blackWhiteShader, "screenSource", blackWhiteScreen)
	
	dxDrawImageSection (x, y, w, h, x, y, w, h, blackWhiteShader, 0, 0, 0, color, type(postgui) == "boolean" and postgui or false)
end 