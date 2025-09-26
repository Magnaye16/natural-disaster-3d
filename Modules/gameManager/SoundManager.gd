extends Node
class_name SoundManager

@export var weather_manager: WeatherManager
@export var season_manager: SeasonManager
@export var sfx_player: AudioStreamPlayer
@export var music_player: AudioStreamPlayer
var current_season: String #for music theme
var current_disaster: String #for sfx
var current_day: String 
var music_volume: int
var sfx_volume: int

func _ready() -> void:
	#switch_music()
	pass
	

func switch_sfx():
	var weather_name =  weather_manager.get_current_name()
	sfx_player.play()
	sfx_player.get_stream_playback().switch_to_clip_by_name(weather_name)
	
	

func switch_music():
	var season_name =  season_manager.get_season_name()
	music_player.play()
	music_player.get_stream_playback().switch_to_clip_by_name(season_name)
	
