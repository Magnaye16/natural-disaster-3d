extends Node2D
class_name FireScene

var fire_damage:int = 1



func _on_area_2d_area_entered(area: Area2D) -> void:
	var fire_component:FireComponent = area.get_parent()
	var BURN = preload("uid://6xa8o7r5m1mk").duplicate()
	BURN.flat_addition = fire_damage

	fire_component.apply_damage_fire_status(BURN)
