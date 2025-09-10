extends Resource
class_name Season

@export var name: String:
	get: return get_script().get_global_name()
	set(val):return
@export var total_days: int = 30
@export var sprite: CompressedTexture2D
@export var possible_weathers: Array[Weather] = []

# func _init(_possible_weathers: Array[Weather]) -> void:
#     possible_weathers = _possible_weathers

func _to_string() -> String:
	return name

func rehydrate_posible_weathers():
	print("posible weathers ",possible_weathers)
	for weather in possible_weathers:
		weather._init()

func season_from_string(weather_class_name:String)->Season:
	var path = "res://Modules/weathers/types/%s.gd" % weather_class_name
	var season_script = load(path)
	var season_instance:Season

	if season_script:
		season_instance = season_script.new()
		return season_instance
	else:
		push_error("Season script not found for: %s" % weather_class_name)
		return null
