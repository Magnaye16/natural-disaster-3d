extends Entity

@export var speed : float = 400.0
@export var acceleration : float = 7000.0
@export var friction : float = 7000

@onready var _controller_container : Node2D = $ControllerContainer

var _controller : EntityController


var move_direction : Vector2 = Vector2.ZERO # Save the move_direction so when we use cmd pattern we just change this

func set_controller(controller: EntityController) -> void:
	# free the children from the mines
	for child in _controller_container.get_children():
		child.queue_free()
		
	# A child must be sacrificed to the mines
	_controller = controller
	_controller_container.add_child(controller)

func set_movement_direction(direction: Vector2) -> void:
	move_direction = direction

func _ready() -> void:
	print("Hello")
	set_controller(PlayerController.new(self))

func _physics_process(delta: float) -> void:
	print("Hello!")
	_move(delta)
	move_and_slide()
	
func _move(delta: float) -> void:
	if move_direction:
		velocity = velocity.lerp(move_direction * speed, 1 - exp(-acceleration * delta))
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		print(velocity)
		
