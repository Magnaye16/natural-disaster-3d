class_name MovementComponent
extends Node

@export var entity:CharacterBody2D
@export var speed : float = 100.0
@export var acceleration : float = 50.0
@export var friction : float = 100
@export var status_multiplier:StatusContainer = StatusContainer.new()

var move_direction : Vector2 = Vector2.ZERO # Save the move_direction so when we use cmd pattern we just change this

var velocity:Vector2:
	get():return entity.velocity
	set(val):entity.velocity = val



func _move(delta: float) -> void:
	if move_direction:
		var product_speed:float = speed

		for stat in status_multiplier.status_array:
			product_speed = stat.apply_multiplier(product_speed)
		speed = max(0.1, speed)
		velocity = velocity.lerp(move_direction * product_speed, acceleration * delta)

	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func set_movement_direction(direction: Vector2) -> void:
	move_direction = direction
	_move(0.01)
	entity.move_and_slide()
