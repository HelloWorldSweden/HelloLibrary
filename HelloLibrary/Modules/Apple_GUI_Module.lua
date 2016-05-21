require "HelloLibrary.Modules.RestartGame"

function on_input(self, action_id, action)
	if action_id == hash("mouse_press") and action.pressed then
    	local x = action.x
        local y = action.y
        local pausenode = gui.get_node("restart")
        if gui.pick_node(pausenode, x, y) then
        	restartGame()
        end
    end
end

function showGameOver()
	msg.post(".", "acquire_input_focus")
		
	local gameOverText = gui.get_node("text")
	local pausenode = gui.get_node("restart")
	local blackNode = gui.get_node("blackScreen")
	gui.set_color(pausenode, vmath.vector4(1, 1, 1, 1))
	gui.set_color(gameOverText, vmath.vector4(1, 1, 1, 1))
	gui.set_color(blackNode, vmath.vector4(1, 1, 1, 1))
end

function hideGameOver()
	msg.post(".", "acquire_input_focus")
		
	local gameOverText = gui.get_node("text")
	local pausenode = gui.get_node("restart")
	local blackNode = gui.get_node("blackScreen")
	gui.set_color(pausenode, vmath.vector4(1, 1, 1, 0))
	gui.set_color(gameOverText, vmath.vector4(1, 1, 1, 0))
	gui.set_color(blackNode, vmath.vector4(1, 1, 1, 0))
end