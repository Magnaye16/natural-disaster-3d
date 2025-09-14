class_name GameManager
extends Node
extends Node

@export var weather_manager: WeatherManager
@export var season_manager:SeasonManager
@export var disaster_manager:DisasterManager


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
