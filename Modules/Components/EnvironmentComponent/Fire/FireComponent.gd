extends Node2D
class_name FireComponent

@export var status_container:StatusContainer
@export var Health:HealthComponent
var Damage:int = 0
var ticks:float = 0
var duration: float = 0.5




func _process(_delta: float) -> void:
	#if Damage < Health.max_value:
	if status_container.status_array.is_empty():
		hide()
	else:
		#print(status_container.status_array.get(0).Duration)
		show()
	ticks += _delta
	
	if ticks > duration:
		var Product_Damage
		if status_container:
			Product_Damage = status_container.compute_value(Damage)
			
		
		Health.apply_DMG(Product_Damage)
		ticks = 0
	
	

func apply_damage_fire_status(status:Status):
	status_container.check_stackable_status(status)
	$Area2D.set_deferred("monitoring", false)
	print("invi")
	await get_tree().create_timer(duration).timeout
	$Area2D.set_deferred("monitoring", true)
	print("not invi")
	
