class_name ComponentManager
extends Node2D

var components: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		register_component(child)

# Register a component (keyed by class_name for type safety)
func register_component(node: Node) -> void:
	var key :String= node.get_script().get_global_name()
	components[key] = node

# Retrieve a component by class_name
func get_component(type_class: GDScript) -> Node:
	return components.get(type_class.get_global_name())

func add_component(comp:Node)->void:
	register_component(comp)
