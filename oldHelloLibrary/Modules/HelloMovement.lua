require "oldHelloLibrary.Modules.AnimationController"

local deltaTime = 0;

function update(self, dt)
	deltaTime = dt;
	setMoveAnim(self)
	self.isMoving = false
end

function move_left(self, go)
	-- move position
	local pos = go.get_position()
	pos.x = pos.x - self.move_speed * deltaTime
	go.set_position(pos)
	
	-- Få spelaren att vända sig åt vänster
	sprite.set_hflip("#sprite", true)
end

function move_right(self, go)
	-- move position
	local pos = go.get_position()
	pos.x = pos.x + self.move_speed * deltaTime
	go.set_position(pos)
	
	-- Få spelaren att vända sig åt höger
	sprite.set_hflip("#sprite", false)
end

function jump(self)
	msg.post("#script_gravity", "player_says_jump", { jump_force = self.jump_force })
end

function playMoveAnimation(self)
	self.isMoving = true
end