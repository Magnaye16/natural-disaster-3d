extends Weather
class_name CloudyWeather


func apply_effect(manager:WeatherManager)->void:
	manager.shader_texture.set_dim_level(0.6)
