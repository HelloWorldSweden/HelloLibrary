
--[[--
	ANIMATION MODUL
	===============
	# Kräver:
		-	Sprite komponent med ID "sprite"
		-	Animation på spriten med ID "walk"
		-	Animation på spriten med ID "stand"
		-	Modulen "HelloLibrary.Modules.Physics"
		-	Modulen "HelloLibrary.Modules.Movement"
	
	# Variabler att använda:
		-	self.walkAnimActive: (bool, readonly) =true om "walk" animationen spelas upp av
	
	# Funktioner att använda:
		-	update_animations(self):
			+	self: (userdata) referens till komponenten/scriptet som kallar funktionen.
			=	returnerar: (nil)
			ex:
				function update(self, dt)
					update_animations(self) <-- Notera: update_animation bör köras före update_physics!
					update_physics(self, dt)
				end
--]]--

function update_animations(self)
	if self.isMoving and not self.walkAnimActive then
		-- Rör sig men spelar inte gående animationen
		-- Så starta gående animationen
		msg.post("#sprite", "play_animation", {id = hash("walk")})
		self.walkAnimActive = true
	end
	if not self.isMoving and self.walkAnimActive then
		-- Rör sig inte men spelar gående animationen
		-- Så byt till stillastående animationen		
		msg.post("#sprite", "play_animation", {id = hash("stand")})
		self.walkAnimActive = false
	end
end