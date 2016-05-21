-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

function setMoveAnim(self)

	if self.isMoving == true and self.walkAnimActive == false then
		msg.post("#sprite", "play_animation", {id = hash("walk")})
		self.walkAnimActive = true
	end
	
	if self.isMoving == false then
	
		if self.walkAnimActive == true then
			msg.post("#sprite", "play_animation", {id = hash("stand")})
		end
		
		self.walkAnimActive = false
	end

	msg.post("#script_collision", "movingUpdate", {moving = self.isMoving})	
end