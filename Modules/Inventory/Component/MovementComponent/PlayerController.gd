extends Node
class_name PlayerController

@export var entity :Entity



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_direction = Input.get_vector(
							 MoveDirection.MOVE_LEFT, MoveDirection.MOVE_RIGHT, 
							 MoveDirection.MOVE_UP, MoveDirection.MOVE_DOWN)
	var move_command = MoveCommand.new(entity, move_direction)
	move_command.execute()
	
