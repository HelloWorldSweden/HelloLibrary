
--[[--
	UTBYGGD MATEMATIK MODUL
	=======================
	# Funktioner att använda:
		-	math.moveTowards(value, target, maxDelta):
			+	value: (number) start värde
			+	target: (number) mål
			+	maxDelta: (number) maximala deltan den flyttar /value/. Är det negativt flyttar den värdet ifrån /target/.
			=	returnerar: (number) svaret.
			ex:
				math.moveTowards(5, 7, 1) >> 6
				math.moveTowards(5, 7, 3) >> 7
				math.moveTowards(5, 7, -1) >> 4
			
		-	math.clamp(value, min, max):
			+	value: (number) start värde
			+	min: (number) lägre gränsen
			+	max: (number) övre gränsen
			=	returnerar: (number) värdet men begränsat till perioden /min/ till /max/.
			ex:
				math.clamp(2, 1, 3) >> 2
				math.clamp(0, 1, 3) >> 1
				math.clamp(4, 1, 3) >> 3
		
		-	vmath.clampMagnitude(vector, max):
			+	vector: (vector3 | vector4) vector som ska hindras
			+	max: (number) maximala magnitud/längd av vektorn
			=	returnerar:	(vector3 | vector4) vektorn med begränsad magnitud
			ex:
				vmath.clampMagnitude(vmath.vector3(2, 0, 0), 1) >> vmath.vector3(1, 0, 0)
				vmath.clampMagnitude(vmath.vector3(6, 8, 0), 5) >> vmath.vector3(3, 4, 0)
			
		-	math.round(value):
			+	value: (number) värdet som kommer avrundas
			=	returnerar: (number) avrundat värde till närmsta heltal.
			ex:
				math.round(5.25) >> 5
				math.round(5.5) >> 6
				math.round(4.8) >> 5
				
		-	math.round(value, decimal):
			+	value: (number) värdet som kommer avrundas
			+	decimal: (number) antalet decimaler.
			=	returnerar: (number) avrundat värde till närmsta heltal med avseende till antalet önskade decimaler.
			ex:
				math.round(5.25, 0) >> 5
				math.round(5.25, 1) >> 5.3
				math.round(42.8, -1) >> 40
--]]--

function math.moveTowards(value, target, maxDelta)
	if maxDelta == 0 then return value end
	local delta = target - value
	
	if delta < 0 then
		value = value - math.min(math.abs(delta), maxDelta)
	elseif delta > 0 then
		value = value + math.min(delta, maxDelta)
	end
	
	return value
end

function math.clamp(value, min, max)
    if min > max then min, max = max, min end -- byt plats om perioden är inverterad
    return math.max(min, math.min(max, value))
end

function vmath.clampMagnitude(vector, max)
	max = math.abs(max) -- se till så att max värdet är positivt
	if vmath.length(vector) > max then
		vector = vmath.normalize(vector) * max
	end
	return vector
end

function math.round(value, decimals)
  local mult = 10^(decimals or 0)
  return math.floor(value * mult + 0.5) / mult
end
