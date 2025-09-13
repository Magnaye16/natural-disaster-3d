extends Weather
class_name StormyWeather


static var _instance:Weather

#
#
#func _init():
	#if _instance == null:
		#populate_data()
		#_instance = self
	#
	#description = _instance.description
	#icon = _instance.icon
	#probability_modifiers = _instance.probability_modifiers
