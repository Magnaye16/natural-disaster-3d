class_name MoveCommand extends Command

func execute(_entity: Entity, data: Variant):
	var direction: Vector2
	if data is Vector2:
		direction = data
	_entity.set_movement_direction(direction)
#	if _entity.has_method("set_movement_direction"):
#		_entity.set_movement_direction(direction)
	
