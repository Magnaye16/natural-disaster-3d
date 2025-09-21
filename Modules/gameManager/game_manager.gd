class_name GameManager
extends Node

@export var weather_manager: WeatherManager
@export var season_manager:SeasonManager
@export var disaster_manager:DisasterManager







func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_P):
		preload("uid://c0ftsqgnde17p").new().apply(self)



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


func _on_hot_dry_pressed() -> void:
	set_starting_season("HotDry")

func _on_rainy_pressed() -> void:
	set_starting_season("Rainy")


func _on_typhoon_pressed() -> void:
		set_starting_season("Typhoon")
