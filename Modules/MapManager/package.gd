extends Node2D
class_name PlayerCamPackage

@onready var global_camera: GlobalCamera = $GlobalCamera
@onready var player: Player = $Player


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func enter_map() -> void:
	await  get_tree().process_frame
	var map:Map = (get_parent() as Map)
	player.global_position = map._last_player_position
	global_camera.global_position = player.global_position
	player.movement_component.Tile_manager = map.Tile_manager
	player.animated_Sprite.Tile_manager = map.Tile_manager
	process_mode = Node.PROCESS_MODE_ALWAYS

	map.Tile_manager.entity = player


func exit_map() -> void:
	var map:Map = (get_parent() as Map)
	map._last_player_position = player.global_position
