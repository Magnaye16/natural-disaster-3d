extends DisasterEffect
class_name ShakeEffect

@export var INTENSITY:int = 1

var intensity:int:
	get:return INTENSITY * 2

@export var duration:float = 5
var frequency:float = 100:
	get:return intensity * 80

func  _enter():
	(game_manager
	.get_tree()\
	.get_first_node_in_group("global_camera") as GlobalCamera)\
	.shake(intensity,duration,frequency)

	var player:Player = Global.get_player()
	player.controller_manager.set_controller_by_class(ShakingPlayerController)
