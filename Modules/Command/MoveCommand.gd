
class_name MoveCommand
extends Command


class Params extends CommandParams:
	var direction: Vector2 = Vector2.ZERO

var params:Params = Params.new()

func execute(entity:Node,param:CommandParams = params) -> void:
	var move_comp:MovementComponent = get_component(MovementComponent,entity)
	if move_comp:
		move_comp.set_movement_direction(param.direction)
