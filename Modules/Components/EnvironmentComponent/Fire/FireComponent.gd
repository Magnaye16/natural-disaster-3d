extends Area2D
class_name FireComponent

@onready var status_container:StatusContainer = $StatusContainer
@export var Health:HealthComponent
var Damage:int = 0
var ticks:float = 0
var duration: float = 0.5

func _process(_delta: float) -> void:
	#if Damage < Health.max_value:
	if status_container.status_array.is_empty():
		hide()
	else:
		show()
	ticks += _delta

	if ticks > duration:
		var Product_Damage = Damage
		if status_container:
			Product_Damage = status_container.compute_value(Damage)

		Health.apply_DMG(Product_Damage)
		ticks = 0

func apply_damage_fire_status(status:Status):
	status_container.add_status(status)
	set_deferred("monitoring", false)
	await get_tree().create_timer(duration).timeout
	set_deferred("monitoring", true)


func _on_fire_source_entered(_body: Node2D) -> void:
	var BURN = preload("uid://6xa8o7r5m1mk").duplicate()
	BURN.flat_addition = 1
	apply_damage_fire_status(BURN)


func _on_fire_source_exited(_body: Node2D) -> void:
	pass # Replace with function body.
