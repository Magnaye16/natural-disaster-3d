extends Node2D
class_name Map

@export var always_reload: bool = false
@export var package:PlayerCamPackage
@export var Tile_manager:Tilemap_manager

@warning_ignore("unused_private_class_variable")
var _last_player_position:Vector2

func _ready() -> void:
	if get_parent() is not MapManager:
		_entry_map()

func _on_enter()->void:

	pass


func _entry_map()->void:
	_last_player_position = package.player.global_position
	_activate()
	package.enter_map()
	_on_enter()

func activate(new_package:PlayerCamPackage)->void:
	_activate()
	package = new_package
	add_child(package)
	package.enter_map()
	_on_enter()

func _activate()->void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	show()

func deactivate()->void:
	hide()
	package.exit_map()
	remove_child(package)
	process_mode = Node.PROCESS_MODE_DISABLED

func clean():
	package.queue_free()
	deactivate()
