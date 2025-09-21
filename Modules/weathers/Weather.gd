@abstract
class_name Weather
extends Resource

var name: String :
	get:return get_script().get_global_name()
	set(v):return
var description: String = ""
var icon: Texture2D
var ambience:String = ""
@export var probability_modifiers:Array[WeatherProbabiltyModifier]
@export var probability:float = 1 # Default, can be set per season

static var _cached_weather_JSON:Dictionary
static var _cached_loaded_weather:Dictionary


func init()->void:
	if _cached_weather_JSON.is_empty():
		var json_path = "res://Modules/weathers/weather_data.json"
		var file = FileAccess.open(json_path, FileAccess.READ)
		var json_text = file.get_as_text()
		_cached_weather_JSON = JSON.parse_string(json_text)
		file.close()

	#"cloudy":{
#		datas
	#}
#}
#	if the loaded data is not _cached
	#var weather_data:Dictionary = get_weather_data_from_cache()

#
	#description = weather_data.get("description", "")
	#var icon_path = weather_data.get("icon_path", "")
	#if icon_path != "":
		#icon = load(icon_path)
#
	probability_modifiers =  get_loaded_cached_data("probability_modifiers")  if    _cached_loaded_weather.has("name")  else load_prob_modifiers()

		#print("modifiers:",probability_modifiers)



func load_prob_modifiers()->Array[WeatherProbabiltyModifier]:

	var weather_data:Dictionary = _cached_weather_JSON.get(name)

	var arr:Array[WeatherProbabiltyModifier]

	for prob_modifier in weather_data.get("probability_modifiers",[]) :
		var instance:WeatherProbabiltyModifier = WeatherProbabiltyModifier.new()
		instance.weather = prob_modifier.get("weather")
		instance.amount = prob_modifier.get("amount")
		arr.push_back(instance)

	return arr



func get_loaded_cached_data(prop:String)->Variant:
	var weather_data:Dictionary = _cached_loaded_weather.get(name,{})
	return weather_data.get(prop)

func get_computed_probabilty(prev_weather:Weather)->float:
	if prev_weather == null: return probability
	for probability_modifier in probability_modifiers:
		if probability_modifier.weather == prev_weather.name:
			return probability_modifier.apply(probability)
	return  probability

func _to_string() -> String:
	return name

@abstract
func apply_effect(manager:WeatherManager)->void
