
--[[--
	EXTRA ANVÄNDBARA FUNKTIONER
	===========================
	# Funktioner att använda:
		-	restart():
			returnerar: (nil)
--]]--

function restart()
	local arg1 = 'bootstrap.main_collection'
	local arg2 = 'build/default/game.projectc'
	msg.post("@system:", "reboot", {arg1 = arg1, arg2 = arg2})
end