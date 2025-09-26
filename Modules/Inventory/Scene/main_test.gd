extends Map
class_name testmap
@export var sound_manager: SoundManager


func _on_enter():
	sound_manager.switch_music()
	sound_manager.switch_sfx()
