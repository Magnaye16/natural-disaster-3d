extends ColorRect
class_name  ShaderTexture





func flash()->void:
	get_material().set_shader_parameter("dim_strength",1)

func set_tint_color(value:float)->void:
	get_material().set_shader_parameter("tint_pos",value)

func set_dim_level(value:float)->void:
	get_material().set_shader_parameter("dim_strength",value)
