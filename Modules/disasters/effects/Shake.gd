extends DisasterEffect
class_name ShakeEffect

@export var INTENSITY:int = 1

var intensity:int:
	get:return INTENSITY * 2

@export var duration:float = 5


func _enter() -> void:
	var player:Player = Global.get_player()
	player.controller_manager.set_controller_by_class(ShakingPlayerController)
