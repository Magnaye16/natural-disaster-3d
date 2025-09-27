extends Map
class_name Map2

var sound_manager: SoundManager
@export var theme_music:StringName = &""

func _ready() -> void:
	sound_manager = Global.get_game_manager().sound_manager

func _on_enter():
	sound_manager.switch_music()
	sound_manager.switch_sfx()
