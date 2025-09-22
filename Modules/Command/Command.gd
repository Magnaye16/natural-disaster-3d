@abstract
class_name Command extends RefCounted

class CommandParams:
	pass

func get_component(type: String,entity:Node) -> Node:
	if entity.has_node(type):
		return entity.get_node(type)
	return null

@abstract
func execute(entity:Node,params:CommandParams)->void
