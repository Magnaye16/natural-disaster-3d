extends DisasterEffect
class_name ShakeEffect

@export var INTENSITY: float = 1

var intensity: float:
	get:return INTENSITY * 2

@export var duration: float = 5


func _enter() -> void:
	var player:Player = Global.get_player()
	player.controller_manager.set_controller_by_class(ShakingPlayerController)
