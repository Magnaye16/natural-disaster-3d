class_name GameManager
extends Node

@export var weather_manager: WeatherManager
@export var season_manager:SeasonManager
@export var disaster_manager:DisasterManager
@export var sound_manager: SoundManager

func _ready() -> void:
	generate_disaster()


func generate_disaster():
	await  get_tree().create_timer(100).timeout
	if disaster_manager.curr_disasters.size() < 2:
		disaster_manager.try_generate_disaster(self)
	generate_disaster()


func _unhandled_key_input(_event: InputEvent) -> void:

	if Input.is_key_pressed(KEY_P):
		disaster_manager.trigger_random_disaster(self)


func get_current_season()->Season:
	return season_manager.get_current_season()

func set_starting_season(season_name:String)->void:
	season_manager.reset()
	season_manager.pick_starting_season(
		season_manager.seasons.find_custom(
			func(season:Season):
				return season_name+"Season" == season.name
				))
	advance_weather()

func advance_day() -> void:
	season_manager.advance_day()
	advance_weather()
	#disaster_manager.try_generate_disaster()

func advance_weather()->void:
	weather_manager.advance_weather(season_manager.get_current_season())


func _on_cool_dry_pressed() -> void:
	set_starting_season("CoolDry")
	sound_manager.switch_music()
	sound_manager.switch_sfx()


func _on_hot_dry_pressed() -> void:
	set_starting_season("HotDry")

func _on_rainy_pressed() -> void:
	set_starting_season("Rainy")
	sound_manager.switch_sfx()
	


func _on_typhoon_pressed() -> void:
	set_starting_season("Typhoon")
