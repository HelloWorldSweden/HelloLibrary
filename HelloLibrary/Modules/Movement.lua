
--[[--
	RÖRELSE MODUL
	=============
	# Kräver:
		-	Modulen "HelloLibrary.Modules.Physics"
		-	Sprite komponent med ID "sprite"
		-	self.jump_force: (number) hopp kraften
		-	self.move_speed: (number) hastigheten karaktären rör sig, i enheter/s
	
	# Funktioner att använda:
		-	jump(self):
			+	self: (userdata) referens till komponenten/scriptet som kallar funktionen.
			=	returnerar: (nil)
			ex:
				function on_input(self, action_id, action)
					if action_id == hash("hero_jump") then
						jump(self)
					end
				end
				
		-	move_right(self):
			+	self: (userdata) referens till komponenten/scriptet som kallar funktionen.
			=	returnerar: (nil)
			ex:
				function on_input(self, action_id, action)
					if action_id == hash("hero_right") then
						move_right(self)
					end
				end
				
		-	move_left(self):
			+	self: (userdata) referens till komponenten/scriptet som kallar funktionen.
			=	returnerar: (nil)
			ex:
				function on_input(self, action_id, action)
					if action_id == hash("hero_left") then
						move_left(self)
					end
				end
--]]--

function jump(self)
	if self.grounded then
    	-- Sätt vår momentum till hopp kraften
    	self.momentum.y = self.jump_force
    	self.grounded = false
	end
end

function move_right(self)
	self.momentum.x = self.move_speed
	self.isMoving = true
	
	-- Få spelaren att vända sig åt höger
	sprite.set_hflip("#sprite", false)
end

function move_left(self)
	self.momentum.x = -self.move_speed
	self.isMoving = true
	
	-- Få spelaren att vända sig åt vänster
	sprite.set_hflip("#sprite", true)
end