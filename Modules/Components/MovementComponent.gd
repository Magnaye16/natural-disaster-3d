class_name MovementComponent
extends Node

@export var entity:CharacterBody2D
@export var speed : float = 400.0
@export var acceleration : float = 7000.0
@export var friction : float = 7000


var move_direction : Vector2 = Vector2.ZERO # Save the move_direction so when we use cmd pattern we just change this

var velocity:Vector2:
	get():return entity.velocity
	set(val):entity.velocity = val

func _physics_process(delta: float) -> void:
	_move(delta)
	entity.move_and_slide()

func _move(delta: float) -> void:
	if move_direction:
		velocity = velocity.lerp(move_direction * speed, 1 - exp(-acceleration * delta))
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)


func set_movement_direction(direction: Vector2) -> void:
	move_direction = direction
