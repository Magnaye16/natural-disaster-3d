class_name Entity extends CharacterBody2D

@onready var component_manager: ComponentManager :
	get:return get_node("ComponentManager")

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func apply_status(status: Status) -> void:
	(component_manager.get_component(StatusManagerComponent)
	as StatusManagerComponent).apply_status(status)


func remove_status(status: Status) -> void:
	(component_manager.get_component(StatusManagerComponent)
	as StatusManagerComponent).remove_status(status)
