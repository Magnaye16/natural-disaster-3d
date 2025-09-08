extends CharacterBody2D


@export var speed : float = 400.0
@export var acceleration : float = 7000.0
@export var friction : float = 7000

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		print(direction)
		velocity = lerp(velocity, direction * speed, 1 - exp(-acceleration * delta))
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction*delta)

	move_and_slide()
