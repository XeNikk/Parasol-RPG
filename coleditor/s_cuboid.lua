-- // Funkcje pliku tekstowego z zapisem cuboida \\ --

addEvent('strefa:zapiszPlik', true)
addEventHandler('strefa:zapiszPlik', root,
function(cuboidZapis)
	local file = fileOpen('Cuboid/strefa.txt', false)
	if not file then
		file = fileCreate('Cuboid/strefa.txt')
	end
	fileWrite(file, cuboidZapis)
	fileClose(file)
	outputChatBox('Zapisano plik!', source, 0, 240, 0, false)
end)