
--[[--
	FYSIK MODUL
	===========
	# Kräver:
		-	self.gravity: (number) hastighetsförändring i y-led per sekund. Sätt till 0 för ingen gravitation.
	
	# Funktioner att använda:
		-	init_physics(self):
			+	self: (userdata) referens till komponenten/scriptet som kallar funktionen. 
			=	returnerar: (nil)
			ex:
				function init(self)
					init_physics(self)
				end
			
		-	update_physics(self, dt):
			+	self: (userdata) referens till komponenten/scriptet som kallar funktionen.
			+	dt: (number) "deltatime", tiden mellan uppdateringar.
			=	returnerar: (nil)
			ex:
				function update(self, dt)
					update_physics(self, dt)
				end
	
		-	handle_physics_messages(self, message_id, message, sender):
			+	self: (userdata) referens till komponenten/scriptet som kallar funktionen.
			+	message_id: (hash) identifierings variabel för meddelandet.
			+	message: (table) innehåller information från meddelandet.
			+	sender: (hash) address till sändaren.
			=	returnerar: (nil)
			ex:
				function on_message(self, message_id, message, sender)
					handle_physics_messages(self, message_id, message, sender)
				end
--]]--

require "HelloLibrary.Modules.Math"

function handle_platform_contact(self, message)
	collisionAngle = getCollAngle(message)
	
	-- Kolla om vinkeln är lämplig mark
	if collisionAngle < self.slope_limit then
		self.grounded = true
		-- Återställ Y axeln
		self.momentum.y = 0
	end
	-- Kolla om vinkeln representerar tak
	if collisionAngle > 130 and collisionAngle < 230 then
		-- Nollställ hastigheten, så man slutar åka uppåt
		self.momentum.y = math.min(self.momentum.y, 0)
	end

	-- project the correction vector onto the contact normal
	-- (the correction vector is the 0-vector for the first contact point)
	local proj = vmath.dot(self.correction, message.normal)
	
	-- calculate the compensation we need to make for this contact point
	local comp = ((message.distance) - proj + (message.normal.x)) * message.normal
	
	-- add it to the correction vector
	self.correction = self.correction + comp
	
	-- apply the compensation to the player character
	go.set_position(go.get_position() + comp)
	
	-- project the velocity onto the normal
	proj = vmath.dot(self.step_velocity, message.normal)
	-- if the projection is negative, it means that some of the velocity points towards the contact point
	
	if proj < 0 then
		-- remove that component in that case
		self.step_velocity = self.step_velocity - proj * message.normal
	end

 	-- 	Kollar om collision angle är en slope eller annan problematisk vinkel. OM så sparas den i extraCorrArray
   	if collisionAngle > self.slope_limit or message.normal.y < 0 then
   		self.extraCorrArray[self.amountOfExtraColl] = comp 
   		self.amountOfExtraColl = self.amountOfExtraColl +1
   	end
   	
   	-- Adderar till amountOfColl
   	self.allCorrArray[self.amountOfColl] = comp
   	self.amountOfColl = self.amountOfColl + 1
end

function getCollAngle(message)
	-- math.atan2 gör om vektor till vinkel i radianer
	-- math.deg gör om vinkel i radianer (0-2π) till vinkel i grader (0-360°)
	-- math.abs tar bort minustecken, dvs abs(5)=>5 och abs(-5)=>5
	return math.abs(math.deg (math.atan2(message.normal.y, message.normal.x)) - 90)
end

--Init
function init_physics(self)
	self.amountOfColl = 0
	self.amountOfExtraColl = 0
	self.extraCorrArray = {}
	self.allCorrArray = {}
	self.isMoving = false
	self.step_velocity = vmath.vector3() -- Hastighet per step, ändra inte
	
	self.momentum = vmath.vector3() -- Publik hastighet, ändra på den här när du vill flytta karaktären
	self.terminal_y = -2000 -- Max hastighet på y axeln
	self.slope_limit = 60 -- Maximala vinkeln vi kan gå upp för
	self.horizontal_drag = 7500 -- Horisontella hastigheten sänks med /drag/ enheter/s, mot 0
	
	-- Nuddar spelaren marken just nu?
	-- Användbart att veta när man vill hoppa
	self.grounded = false
end
		
-- Update
function update_physics(self, dt)

	--!! KOLLISION !!--
	
	self.correction = vmath.vector3()
	
	-- Kollar om vi bör utföra någon extra Collision kompensation
	if((self.amountOfExtraColl > 0) and self.amountOfColl > self.amountOfExtraColl) then
		for i = 1, self.amountOfExtraColl do
			go.set_position(go.get_position() + self.extraCorrArray[i-1])
		end
		
		-- OBS!! temp lösning
		if(self.isMoving == true) then
			temp = go.get_position()
			for i = 1, self.amountOfColl do
				temp.y = temp.y + 3*self.allCorrArray[i-1].y
			end
			go.set_position(temp)
		end
	end

	--Återställer Collision räknarna
	self.amountOfColl = 0
	self.amountOfExtraColl = 0
	
	--!! MOMENTUM !!--
	
	-- Lägg på gravitation om vi inte nuddar marken
	if self.grounded == false then
		-- Uppdatera nuvarande hastighet
		self.momentum.y = self.momentum.y - self.gravity * dt
		-- Lås hastigheten till vårt max värde
		self.momentum.y = math.max(self.momentum.y, self.terminal_y)
	end
	
	-- Vi vill inte flytta karaktären på Z axeln
	self.momentum.z = 0
	
	-- Uppdatera positionen från vår momentum
	local pos = go.get_position()
	pos = pos + self.momentum * dt
	go.set_position(pos)
	
	-- Horisontell hastighetsminskning
	-- Gör detta efter positionsändrningen, så det appliseras inför nästa uppdatering
	self.momentum.x = math.moveTowards(self.momentum.x, 0, self.horizontal_drag * dt)
	
	-- Återställ kollision
	self.grounded = false
	self.isMoving = false
end

function handle_physics_messages(self, message_id, message, sender)
	-- Kollisions meddelande
	
	if message_id == hash("contact_point_response") then
        -- Undersök meddelandet
        if message.group == hash("platform") then
            handle_platform_contact(self, message)
        end
    end
	
	-- Sätt vår momentum till ett specifikt värde
	if message_id == hash("set_momentum") then
		-- Skriv över vår momentum med nytt värde
		self.momentum.x = message.force.x
		self.momentum.y = message.force.y
		self.momentum.z = message.force.z
	end
end
