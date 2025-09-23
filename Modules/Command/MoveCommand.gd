
class_name MoveCommand
extends Command


class Params extends CommandParams:
	var direction: Vector2 = Vector2.ZERO

var params:Params = Params.new()

func execute(entity:Node,param:CommandParams = params) -> void:

	var comp_mgr = entity.get_node("ComponentManager") as ComponentManager
	var move_comp:MovementComponent = comp_mgr.get_component(MovementComponent)

	if move_comp:
		move_comp.set_movement_direction(param.direction)
