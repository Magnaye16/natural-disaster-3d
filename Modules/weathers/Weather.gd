extends Resource
class_name Weather

var name: String :
	get:return get_script().get_global_name()
	set(v):return
var description: String = ""
var icon: Texture2D
var ambience:String = ""
@export var probability_modifiers:Array[WeatherProbabiltyModifier]
@export var probability:float = 1 # Default, can be set per season

func init()->void:
	print("==== init %s ===="%name)

	var json_path = "res://Modules/weathers/weather_data.json"
	var file = FileAccess.open(json_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var data = JSON.parse_string(json_text)

		if typeof(data) == TYPE_DICTIONARY and data.has(name):
			var weather_data:Dictionary = data[name]

			description = weather_data.get("description", "")
			var icon_path = weather_data.get("icon_path", "")
			if icon_path != "":
				icon = load(icon_path)

			for prob_modifier in weather_data.get("probability_modifiers",[]) :
				var instance:WeatherProbabiltyModifier = WeatherProbabiltyModifier.new()
				instance.weather = prob_modifier.get("weather")
				instance.amount = prob_modifier.get("amount")
				probability_modifiers.push_back(instance)
			#print("modifiers:",probability_modifiers)
		file.close()
	else:
		push_error("Could not open weather data JSON file.")

func get_computed_probabilty(prev_weather:Weather)->float:

	if prev_weather == null: return probability
	for probability_modifier in probability_modifiers:
		if probability_modifier.weather == prev_weather.name:
			return probability_modifier.apply(probability)
	return  probability

func _to_string() -> String:
	return name
