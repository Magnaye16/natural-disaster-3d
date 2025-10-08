extends Node2D
class_name Map

@export var always_reload: bool = false
@export var package:PlayerCamPackage
@export var Tile_manager:Tilemap_manager

var sound_manager: SoundManager
@export var theme_music:StringName = &""

@warning_ignore("unused_private_class_variable")
var _last_player_position:Vector2

signal go_to_requested(location:StringName)

func spawn_to_door(door_id:StringName)->void:
	var door:Interactable_door = get_node("DOOR_%s"%door_id)
	_last_player_position = door.spawn_position


func _notification(what: int) -> void:
	if what == NOTIFICATION_READY:
		if get_parent() is not MapManager:
			_entry_map()
			print("?")
		var gm:GameManager = Global.get_game_manager()
		if gm:sound_manager = gm.sound_manager

		return

func go_to(location:StringName)->void:
	go_to_requested.emit(location)

func _on_enter():
	pass

##[color=red]  Do not override this if not neccessary
##activates and setups this map to run [br]
##called by the map manager when this is the default scene
func _entry_map()->void:
	_last_player_position = package.player.global_position
	_activate()
	package.enter_map()
	_on_enter()
	play_music()


func play_music()->void:
	if not sound_manager:return
	sound_manager.switch_music()
	sound_manager.switch_sfx()

func activate(new_package:PlayerCamPackage)->void:
	_activate()
	package = new_package
	add_child(package)
	package.enter_map()
	_on_enter()
	play_music()

func _activate()->void:
	Tile_manager._preload()
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
