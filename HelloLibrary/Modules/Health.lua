
--[[--
	HÄLSA/LIV MODUL
	===============
	# Kräver:
		-	self.health: (number) detta objekts liv.
	
	# Variabler att använda:
		-	self.maxHealth: (number, def:/self.health/) kan ändra max liv när som helst om du önskar
		-	self.invis: (number, def:0.5) Hur länge man är odödlig i sekunder 
	
	# Funktioner att använda:
		-	init_health(self):
			+	self: (userdata) referens till komponenten/scriptet som kallar funktionen. 
			=	returnerar: (nil)
			ex:
				function init(self)
					init_health(self)
				end
		
		-	handle_health_messages(self, message_id, message, sender):
			+	self: (userdata) referens till komponenten/scriptet som kallar funktionen.
			+	message_id: (hash) identifierings variabel för meddelandet.
			+	message: (table) innehåller information från meddelandet.
			+	sender: (hash) address till sändaren.
			=	returnerar: (nil)
			ex:
				function on_message(self, message_id, message, sender)
					handle_health_messages(self, message_id, message, sender)
				end
			
	# Meddelanden att använda:
		-	Skada:
			+	message_id == hash("damage")
			+	message:
				-	amount: (number, optional) Hur mycket skada. Om `amount`=2 kommer self.health sjunka med 2
		
		-	Öka liv:
			+	message_id == hash("heal")
			+	message:
				-	amount: (number, optional) Hur mycket livet ska öka med. Om `amount`=2 kommer self.health öka med 2
--]]--

require "HelloLibrary.Modules.Math"

function init_health(self)
	self.max_health = self.max_health or self.health
    self.invis = self.invis or 0.5
    
    -- Odödlighets variabler
    self.invis_since = -math.huge -- = -∞
end

function handle_health_messages(self, message_id, message, sender)
	if message_id == hash("damage") and not is_invis(self) then
		self.health = math.clamp(self.health - (message.amount or 1), 0, self.max_health)
		-- Markera att odödligheten börjar nu
		self.invis_since = os.clock()
	end
	
	if message_id == hash("heal") then
		self.health = math.clamp(self.health + (message.amount or 1), 0, self.max_health)
	end
end

-- =true om tidskillnaden är mindre än /self.invis/ sekunder
function is_invis(self)
	if not self.invis or not self.invis_since or self.invis <= 0 then return false end
	return os.clock() - self.invis_since < self.invis
end

-- =0 om precis odödlig, =1 om dödlig
function invis_normalized(self)
	if not self.invis or not self.invis_since or self.invis <= 0 then return 1 end
	return math.clamp((os.clock() - self.invis_since) / self.invis, 0, 1)
end
