class_name WeatherManager
extends Node

@export var _prev_weather:Weather
@export var _current_weather: Weather


signal weather_advanced(weather)

func get_current_weather() -> Weather:
	return _current_weather

func advance_weather(season: Season) -> void:
	_prev_weather = _current_weather
	_current_weather = _possible_weather(season)
	weather_advanced.emit(_current_weather)


func _possible_weather(season: Season) -> Weather:
	assert(season and season.possible_weathers.size() > 0,"season and possible_weathers cannot be null")


	var weight:float  = season.possible_weathers.reduce(
		func(total: float, weather: Weather):
			return total + weather.get_computed_probabilty(_current_weather),0
	)


	var rand_num: float = randf() * weight
	var curr_weight: float = 0.0

	for weather in season.possible_weathers:
		var computed_prob:float = weather.get_computed_probabilty(_current_weather)
		print("===============\n%s computed prob:%f"%[weather,computed_prob])

		curr_weight += computed_prob
		if rand_num <= curr_weight:

			print("+++++++++++++++++++ end posible weather +++++++++++++++++++++++++++++")
			return weather

	return null
