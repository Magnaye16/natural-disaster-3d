extends Area2D
class_name  HurtBoxComponent

@export var health_component:HealthComponent

func damage(dmg:int):
	health_component.apply_DMG(dmg)
