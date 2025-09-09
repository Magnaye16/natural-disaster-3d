extends Entity

@export var speed : float = 400.0
@export var acceleration : float = 7000.0
@export var friction : float = 7000

var move_direction : Vector2 = Vector2.ZERO # Save the move_direction so when we use cmd pattern we just change this

func _physics_process(delta: float) -> void:
	
	move(delta)
	move_and_slide()

func set_movement_direction(direction: Vector2) -> void:
	move_direction = direction
	
func move(delta: float) -> void:
	if move_direction:
		velocity = velocity.lerp(move_direction * speed, 1 - exp(-acceleration * delta))
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		#	print(velocity)
	
