-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

function restartGame()
	local arg1 = 'bootstrap.main_collection'
	local arg2 = 'build/default/game.projectc'
	msg.post("@system:", "reboot", {arg1 = arg1, arg2 = arg2})
end