@abstract
class_name Command extends RefCounted




var entity: Node

func _init(e: Node) -> void:
	entity = e

func get_component(type: String) -> Node:
	if entity.has_node(type):
		return entity.get_node(type)
	return null

@abstract
func execute()->void
