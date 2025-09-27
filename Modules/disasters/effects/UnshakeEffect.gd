extends DisasterEffect
class_name UnshakeEffect

func _enter():
	var player : Player = Global.get_player()
	player.controller_manager.set_controller_by_class(PlayerController)
