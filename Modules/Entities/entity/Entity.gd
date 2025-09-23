class_name Entity extends CharacterBody2D

@onready var component_manager: Node2D = $ComponentManager


func apply_status(status: Status) -> void:
	(component_manager.get_component(StatusManagerComponent)
	as StatusManagerComponent).apply_status(status)


func remove_status(status: Status) -> void:
	(component_manager.get_component(StatusManagerComponent)
	as StatusManagerComponent).remove_status(status)
