extends Map
class_name Map2

var sound_manager: SoundManager
@export var theme_music:StringName = &""

func _ready() -> void:
	var gm:GameManager = Global.get_game_manager()
	if gm:sound_manager = gm.sound_manager

@onready var ground: TileMapLayer = $Tilemap_manager/Ground



func _on_enter():
	if not sound_manager:return
	sound_manager.switch_music()
	sound_manager.switch_sfx()
