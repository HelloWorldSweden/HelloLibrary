

-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

function handle_platform_contact(self, message)
	collisionAngle =  getCollAngle(message)

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
    proj = vmath.dot(self.velocity, message.normal)
    -- if the projection is negative, it means that some of the velocity points towards the contact point
   
   
    if proj < 0 then
        -- remove that component in that case
        self.velocity = self.velocity - proj * message.normal
    end




 	-- 	Kollar om collision angle är en slope eller annan problematisk vinkel. OM så sparas den i extraCorrArray
   	if (collisionAngle > 0 and collisionAngle < 45) or (message.normal.y < 0) then

   		self.extraCorrArray[self.amountOfExtraColl] = comp 
   		self.amountOfExtraColl = self.amountOfExtraColl +1
   	end
   	
   	-- Adderar till amountOfColl
   	self.allCorrArray[self.amountOfColl] = comp
   	self.amountOfColl = self.amountOfColl + 1
   
end


-- Temp coll angle uträkning
function getCollAngle(message)
	collisionAngle =  math.deg (math.atan(message.normal.y / message.normal.x))
	
	if message.normal.x < 0 then
		collisionAngle = collisionAngle + 90
	else
		collisionAngle = 90 - collisionAngle
	end
	
	if message.normal.x == 0 then
		collisionAngle = 0
	end
	
	if message.normal.y < 0 then
		collisionAngle = 180
	end
	
	return collisionAngle
end


--Init
function init_collision(self)
	self.amountOfColl = 0
	self.amountOfExtraColl = 0
	self.extraCorrArray = {}
	self.allCorrArray = {}
	self.isMoving = false
	self.velocity = vmath.vector3()
end

		
		
-- Update
function update_collision(self)
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
end
