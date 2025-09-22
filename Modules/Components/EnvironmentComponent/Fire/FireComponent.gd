extends Node2D
class_name FireComponent

@export var status_multiplier:StatusContainer
@export var Health:HealthComponent
var Damage:int = 1
var ticks:float = 0
var duration: float = 1


func _process(_delta: float) -> void:
	#if Damage < Health.max_value:
	if !Health: return 
	ticks += _delta
	
	if ticks > duration:

		if status_multiplier:
			Damage = status_multiplier.compute_value(Damage)
			print(Damage)
		
		
		Health.apply_DMG(Damage)
		ticks = 0

func apply_damage_fire_status():
	#take burn status then compute the damage value and update the health 
	#re-apply the status when interacted by the player
	pass
	


func _on_interactable_component_interacted(_entity: Entity) -> void:
	pass 


func _on_interactable_component_contacted() -> void:
	#apply_fire_status()
	pass 
