class_name PlayerController extends EntityController

func _physics_process(_delta: float) -> void:
	var direction : Vector2 = Input.get_vector(
						MoveDirection.MOVE_LEFT, MoveDirection.MOVE_RIGHT,
						MoveDirection.MOVE_UP, MoveDirection.MOVE_DOWN,)
	print(direction)
	# move_command.execute(entity, direction)
