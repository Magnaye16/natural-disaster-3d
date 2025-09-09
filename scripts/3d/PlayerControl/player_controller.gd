extends CharacterBody3D

@onready var camera: Camera3D = $"../Camera/WorldCam"

@export var MAX_WALK_SPEED: float = 15
@export var SPRINT_SPEED: float = 25
@export var JUMP_VELOCITY: float = 12
@export var MAX_FALL_SPEED: float = 42
@export var GRAVITY_MULTIPLIER: float = 3.0

@export var ACCELERATION: float = 2
@export var DECELERATION: float = 6




func _physics_process(delta: float) -> void:
	# Add the gravity.
	var gravity: Vector3 = get_gravity()
	gravity.y *= GRAVITY_MULTIPLIER
	if not is_on_floor():
		velocity = drag_player_to_ground(velocity, gravity, delta)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = player_jump(velocity)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# NOTE: Our forward space is -x, and the right is -z.
	var input_dir := Input.get_vector("move_up", "move_down", "move_right", "move_left")
	var is_sprinting := Input.is_action_pressed("ZOOOOOMMMM") # sprint name, just messing around
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and not is_sprinting:
#		velocity.x = direction.x * MAX_WALK_SPEED
#		velocity.z = direction.z * MAX_WALK_SPEED
#		velocity.x = lerp(velocity.x, direction.x * MAX_WALK_SPEED, 1 - exp(-ACCELERATION * delta))
#		velocity.z = lerp(velocity.z, direction.z * MAX_WALK_SPEED, 1 - exp(-ACCELERATION * delta))
		move(direction * MAX_WALK_SPEED, delta)
	elif direction and is_sprinting:
		move(direction * SPRINT_SPEED, delta)
	else:
#		velocity.x = lerp(velocity.x, 0.0, 1 - exp(-DECELERATION * delta))
#		velocity.z = lerp(velocity.z, 0.0, 1 - exp(-DECELERATION * delta))

#		velocity.x = move_toward(velocity.x, 0, MAX_WALK_SPEED / 10)
#		velocity.z = move_toward(velocity.z, 0, MAX_WALK_SPEED / 10)
		move(Vector3.ZERO, delta)



	move_and_slide()

func drag_player_to_ground(_velocity: Vector3, gravity: Vector3, deltaTime: float) -> Vector3:
	_velocity += gravity * deltaTime
	_velocity.y = max(_velocity.y, -MAX_FALL_SPEED)
	return _velocity
	
func player_jump(_velocity: Vector3) -> float:
	_velocity.y = JUMP_VELOCITY
	return _velocity.y
	
func move(_toVelocity: Vector3, deltaTime) -> void:
	velocity = velocity.lerp(_toVelocity, 1 - exp(-ACCELERATION * deltaTime))
	print(velocity)
