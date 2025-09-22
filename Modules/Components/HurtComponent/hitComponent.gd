extends Area2D
class_name HitComponent

signal hit(hurtbox:HurtBoxComponent)


func _on_area_entered(area: HurtBoxComponent) -> void:
	hit.emit(area)
