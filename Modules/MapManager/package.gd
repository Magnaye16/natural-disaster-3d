extends Node2D
class_name PlayerCamPackage

@onready var global_camera: GlobalCamera = $GlobalCamera
@onready var player: Player = $Player



func enter_map() -> void:
	await  get_tree().process_frame
	var map:Map = (get_parent() as Map)
	player.global_position = map._last_player_position
	global_camera.global_position = player.global_position


func exit_map() -> void:
	var map:Map = (get_parent() as Map)
	map._last_player_position = player.global_position
