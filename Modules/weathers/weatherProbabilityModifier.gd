class_name WeatherProbabiltyModifier
extends Resource

@export var weather:String
@export var amount:float = 0

func apply(probability:float)->float:
	return probability * amount

func _to_string() -> String:
	return weather + " modifier"
