class_name MovementComponent
extends Node

@export var entity:CharacterBody2D
@export var speed : float = 400.0
@export var acceleration : float = 7000.0
@export var friction : float = 7000
@export var status_multiplier:StatusContainer


var move_direction : Vector2 = Vector2.ZERO # Save the move_direction so when we use cmd pattern we just change this

var velocity:Vector2:
	get():return entity.velocity
	set(val):entity.velocity = val

func _physics_process(delta: float) -> void:
	_move(delta)
	entity.move_and_slide()

func _move(delta: float) -> void:
	if move_direction:
		#var product_speed:float = status_multiplier.status_array.reduce(
			#func (accum,status:Status):return status.apply_multiplier(speed),speed
			#)
		var product_speed:float = speed
		
		for stat in status_multiplier.status_array:
			product_speed = stat.apply_multiplier(product_speed)
		speed = max(0.1, speed)
		velocity = velocity.lerp(move_direction * product_speed, 1 - exp(-acceleration * delta))
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)


func set_movement_direction(direction: Vector2) -> void:
	move_direction = direction
