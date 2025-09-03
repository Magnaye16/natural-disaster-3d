extends CharacterBody3D

@onready var camera: Camera3D = $"../Camera/WorldCam"

@export var JUMP_VELOCITY: float = 10
@export var MAX_FALL_SPEED: float = 42
@export var GRAVITY_MULTIPLIER: float = 2.0


const SPEED: float = 15.0



func _physics_process(delta: float) -> void:
	# Add the gravity.
	var gravity: Vector3 = get_gravity()
	print(velocity)
	gravity.y *= GRAVITY_MULTIPLIER
	if not is_on_floor():
		velocity += gravity * delta
		velocity.y = max(velocity.y, -MAX_FALL_SPEED)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		print(get_gravity())

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# NOTE: Our forward space is -x, and the right is -z.
	var input_dir := Input.get_vector("move_up", "move_down", "move_right", "move_left")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 8.6)
		velocity.z = move_toward(velocity.z, 0, SPEED / 8.6)

	

	move_and_slide()
