@abstract
class_name Command extends RefCounted

class CommandParams:
	pass

func get_component(type: GDScript,entity:Node) -> Node:
	var comp_mgr = entity.get_node("ComponentManager") as ComponentManager
	return comp_mgr.get_component(type)

@abstract
func execute(entity:Node,params:CommandParams)->void
