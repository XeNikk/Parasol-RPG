--[[
	##########################################################
	# @project: Paradise RPG
	# @author: Brzysiek <brzysiekdev@gmail.com>
	# @filename: utils_s.lua
	# @description: (w oryginale to jest eksport) Skrypt służy do kalkulacji klas / doboru typów silników.
	# All rights reserved.
	##########################################################
--]]

VEHICLES_TYPES = {
	["Bus"] = {431, 437},
	["Truck"] = {403, 406, 407, 408, 413, 414, 427, 432, 433, 443, 444, 455, 456,
				 498, 499, 514, 515, 524, 531, 544, 556, 557, 573, 578, 601, 609},
	["Sport"] = {411, 415, 424, 429, 451, 477, 480, 494, 495, 502, 503, 504, 506, 541, 555, 558, 559, 560,
						 562, 565, 568, 587, 602, 598},
	["Casual"] = {400, 401, 404, 405, 410, 416, 418, 420, 421, 422,
						  426, 436, 438, 440, 445, 458, 459, 470,
						  478, 479, 482, 489, 490, 491, 492, 496, 500, 505, 507, 516, 517, 518,
						  526, 527, 528, 529, 533, 540, 543, 546, 547, 549, 550, 551,
						  554, 561, 566, 579, 580, 585, 589, 597, 596, 599, 600, 604, 605,
						  536, 575, 534, 567, 535, 576, 412},
	["Muscle"] = {474, 545, 466, 467, 439, 542, 603, 475, 419, 402},
	["Plane"] = {592, 577, 511, 548, 512, 593, 425, 520, 417, 487, 553, 488, 497, 563, 476, 447, 519, 460, 469, 513},
	["Boat"] = {472, 473, 493, 595, 484, 430, 453, 452, 446, 454},
	["Motorbike"] = {481, 462, 521, 463, 522, 461, 448, 468, 586, 471, 581}
}

CLASSES = {
	[{0, 200}] = "E",
	[{200, 400}] = "D",
	[{400, 600}] = "C",
	[{600, 800}] = "B",
	[{800, 1000000000}] = "A",
}

MAX_VELOCITY = {
	[400] = 150,
	[401] = 140,
	[402] = 178,
	[404] = 126,
	[405] = 156,
	[409] = 150,
	[410] = 123,
	[411] = 210,
	[412] = 161,
	[415] = 182,
	[418] = 110,
	[419] = 142,
	[421] = 246,
	[422] = 134,
	[424] = 128,
	[426] = 165,
	[429] = 192,
	[434] = 159,
	[436] = 142,
	[439] = 160,
	[445] = 156,
	[451] = 182,
	[458] = 150,
	[461] = 153,
	[463] = 138,
	[466] = 140,
	[467] = 134,
	[468] = 138,
	[471] = 102,
	[474] = 142,
	[475] = 165,
	[477] = 178,
	[478] = 112,
	[479] = 133,
	[480] = 178,
	[482] = 149,
	[483] = 118,
	[489] = 133,
	[491] = 142,
	[492] = 134,
	[495] = 168,
	[496] = 155,
	[500] = 134,
	[506] = 170,
	[507] = 158,
	[508] = 102,
	[516] = 150,
	[517] = 150,
	[518] = 158,
	[521] = 154,
	[526] = 150,
	[527] = 142,
	[529] = 142,
	[533] = 159,
	[534] = 161,
	[535] = 150,
	[536] = 165,
	[540] = 142,
	[541] = 192,
	[542] = 156,
	[543] = 144,
	[545] = 140,
	[546] = 142,
	[547] = 136,
	[549] = 146,
	[550] = 138,
	[551] = 150,
	[554] = 137,
	[555] = 150,
	[558] = 162,
	[559] = 169,
	[560] = 169,
	[561] = 146,
	[562] = 173,
	[565] = 165,
	[566] = 152,
	[567] = 165,
	[575] = 150,
	[576] = 150,
	[579] = 150,
	[580] = 145,
	[581] = 145,
	[585] = 145,
	[586] = 138,
	[587] = 157,
	[589] = 155,
	[600] = 144,
	[602] = 169,
	[603] = 163,
	[522] = 210,
}
function getVehicleMaxVelocity(model)
	return MAX_VELOCITY[model] or 0
end 

function getVehicleTypeByModel(model)
	for type, models in pairs(VEHICLES_TYPES) do 
		for _, mdl in pairs(models) do 
			if mdl == model then 
				return type
			end
		end
	end 
	
	return "Casual"
end

function calculateVehicleClass(vehicle)
	local handling = nil
	local v_type = nil
	if type(vehicle) == "number" then 
		handling = getOriginalHandling(vehicle)
		v_type = getVehicleTypeByModel(vehicle)
	else 
		handling = getVehicleHandling(vehicle)
		v_type = getElementData(vehicle, "vehicle:type")
	end
	
	-- silnik
	local acc = handling.engineAcceleration 
	local vel = handling.maxVelocity
	local drag = handling.dragCoeff
	local c = (acc / drag / vel)
	if v_type == "Casual" then 
		c = c-0.010
	elseif v_type == "Sport" then 
		c =c-0.005
	elseif v_type == "Muscle" then 
		c = c-0.02
	elseif v_type == "Truck" then 
		c =c+0.01
	end
	
	-- prowadzenie 
	local turnMass = handling.turnMass 
	local mass = handling.mass 
	local traction = handling.tractionLoss
	c = c - (turnMass/mass/traction)*0.001 
	
	return math.ceil(c*(10^4.54))
end

function getVehicleClass(vehicle)
	local class = calculateVehicleClass(vehicle)
	for required, name in pairs (CLASSES) do 
		if class >= required[1] and class <= required[2] then 
			return name
		end
	end
	
	return "E"
end 

-- posortowanie od najlepszego pojazdu z klasy do najgorszego w VEHICLES_TYPES (tylko strona serwera)
if getModelHandling then
	for name, models in pairs(VEHICLES_TYPES) do 
		table.sort(models, function(a, b)
			return calculateVehicleClass(a) > calculateVehicleClass(b)
		end)	
	end

	--[[
	for name, models in pairs(VEHICLES_TYPES) do 
		outputChatBox("Najgorszy z "..name..": "..models[#models])
		outputChatBox("Najlepszy z "..name..": "..models[1])
	end 
	--]]
	
	function getBestVehicleClassByType(type)
		if type then 
			return VEHICLES_TYPES[type][1]
		end
	end 	
end 

--[[
if isAmbientSoundEnabled then return end
vehicleIDS = {
    602, 545, 496, 517, 401, 410, 518, 600, 527, 436, 589, 580, 419, 439, 533, 549, 526, 491, 474, 445, 467, 604, 426, 507, 547, 585, 405, 587,
    409, 466, 550, 492, 566, 546, 540, 551, 421, 516, 529, 592, 553, 577, 488, 511, 497, 548, 563, 512, 476, 593, 447, 425, 519, 520, 460, 417,
    469, 487, 513, 581, 510, 509, 522, 481, 461, 462, 448, 521, 468, 463, 586, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 485, 552, 431,
    438, 437, 574, 420, 525, 408, 416, 596, 433, 597, 427, 599, 490, 432, 528, 601, 407, 428, 544, 523, 470, 598, 499, 588, 609, 403, 498, 514,
    524, 423, 532, 414, 578, 443, 486, 515, 406, 531, 573, 456, 455, 459, 543, 422, 583, 482, 478, 605, 554, 530, 418, 572, 582, 413, 440, 536,
    575, 534, 567, 535, 576, 412, 402, 542, 603, 475, 449, 537, 538, 570, 441, 464, 501, 465, 564, 568, 557, 424, 471, 504, 495, 457, 539, 483,
    508, 571, 500, 444, 556, 429, 411, 541, 559, 415, 561, 480, 560, 562, 506, 565, 451, 434, 558, 494, 555, 502, 477, 503, 579, 400, 404, 489,
    505, 479, 442, 458, 606, 607, 610, 590, 569, 611, 584, 608, 435, 450, 591, 594
}
table.sort(vehicleIDS, function(a, b)
	return getVehicleNameFromModel(a) < getVehicleNameFromModel(b)
end)

for k, v in ipairs(vehicleIDS) do
	outputChatBox(getVehicleNameFromModel(v)..": "..tostring(calculateVehicleClass(v)))
end 
--]]
