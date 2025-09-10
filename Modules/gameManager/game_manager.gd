class_name GameManager
extends Node2D

@export var season_manager: SeasonManager = Season_manager
@export var disaster_manager: DisasterManager = Disaster_manager
@export var weather_manager: WeatherManager = WeatherManager.new()


func advance_day() -> void:
	season_manager.advance_day()

func advance_weather()->void:
	weather_manager.advance_weather(season_manager.get_current_season())
