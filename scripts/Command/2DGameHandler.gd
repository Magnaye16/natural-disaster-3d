extends Node2D

@export var entity : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_direction = Input.get_vector(
							 MoveDirection.MOVE_LEFT, MoveDirection.MOVE_RIGHT, 
							 MoveDirection.MOVE_UP, MoveDirection.MOVE_DOWN)
	
	print(move_direction)
	var move_command = MoveCommand.new(entity, move_direction)
	move_command.execute()
	
	
