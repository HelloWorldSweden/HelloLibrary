
--[[--
	RÖRELSE MODUL
	=============
	# Kräver:
		-	Modulen "HelloLibrary.Modules.Physics"
		-	Sprite komponent med ID "sprite" [Endast krav om du kommer använda "move_right" eller "move_left" funktionerna]
		-	self.jump_force: (number) hopp kraften. [Endast krav om du kommer använda "jump" funktionen]
		-	self.move_speed: (number) hastigheten karaktären rör sig, i enheter/s. [Endast krav om du kommer använda någon av  "move_*" funktionerna]
	
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
				
		-	move_right(self): # Rör objektet och flippar spriten tillsammans med rörelsen
		-	move_left(self):
			+	self: (userdata) referens till komponenten/scriptet som kallar funktionen.
			=	returnerar: (nil)
			ex:
				function on_input(self, action_id, action)
					if action_id == hash("hero_right") then
						move_right(self)
					end
				end
			
		-	move_north(self): # Rör objektet men flippar inte spriten
		-	move_east(self):
		-	move_south(self):
		-	move_west(self):
			+	self: (userdata) referens till komponenten/scriptet som kallar funktionen.
			=	returnerar: (nil)
			ex:
				function on_input(self, action_id, action)
					if action_id == hash("hero_north") then
						move_north(self)
					end
				end
				
--]]--

require "HelloLibrary.Modules.Math"
require "HelloLibrary.Modules.Health"

--(( Användas för SIDESCROLLER rörelse ))--

function jump(self)
	-- Måste stå på något för att kunna hoppa
	-- Ska inte kunna hoppa i odödlighetsstadiet
	if self.grounded and invis_normalized(self) > .5 then
    	-- Sätt vår momentum till hopp kraften
    	self.momentum.y = self.jump_force
    	self.grounded = false
	end
end

function move_right(self)
	-- Ska inte kunna förflytta i odödlighetsstadiet
	local mult = invis_normalized(self)
	if mult > .4 then
		self.momentum.x = self.move_speed * mult
		self.isMoving = true
		
		-- Få spelaren att vända sig åt höger
		sprite.set_hflip("#sprite", false)
	end
end

function move_left(self)
	-- Ska inte kunna förflytta i odödlighetsstadiet
	local mult = invis_normalized(self)
	if mult > .4 then
		self.momentum.x = -self.move_speed * mult
		self.isMoving = true
		
		-- Få spelaren att vända sig åt vänster
		sprite.set_hflip("#sprite", true)
	end
end

--(( Användas för TOP-DOWN rörelse ))--

function move_north(self)
	-- Ska inte kunna förflytta i odödlighetsstadiet
	local mult = invis_normalized(self)
	if mult > .4 then
		self.momentum.y = self.move_speed * mult
		self.isMoving = true
	end
end
move_up = move_north

function move_east(self)
	-- Ska inte kunna förflytta i odödlighetsstadiet
	local mult = invis_normalized(self)
	if mult > .4 then
		self.momentum.x = self.move_speed * mult
		self.isMoving = true
	end
end

function move_south(self)
	-- Ska inte kunna förflytta i odödlighetsstadiet
	local mult = invis_normalized(self)
	if mult > .4 then
		self.momentum.y = -self.move_speed * mult
		self.isMoving = true
	end
end
move_down = move_south

function move_west(self)
	-- Ska inte kunna förflytta i odödlighetsstadiet
	local mult = invis_normalized(self)
	if mult > .4 then
		self.momentum.x = -self.move_speed * mult
		self.isMoving = true
	end
end
