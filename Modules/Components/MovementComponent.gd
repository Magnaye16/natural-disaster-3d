class_name MovementComponent
extends Node

var Tile_manager: Tilemap_manager
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
	if move_direction.length() <= 0 and velocity.length() <= 0:return

	if move_direction:
		var product_speed: float = speed
		# Apply status multipliers to speed
		for stat in status_multiplier.status_array:
			product_speed = stat.apply_multiplier(product_speed)

		product_speed = max(0.1, product_speed * get_tile_speed())

		velocity = velocity.lerp(move_direction * product_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, get_tile_friction() * delta)


func get_tile_speed()->float:
	if Tile_manager == null:return 1
	var tile_speed = Tile_manager.get_tile_data(&"Tile_speed")
	#print("Tile friction under player: ", tile_speed)
	if tile_speed == null or tile_speed == 0:
		tile_speed = 1 # fall back to default
	return tile_speed

func get_tile_friction():
	if Tile_manager == null:return friction
	var tile_speed = Tile_manager.get_tile_data(&"Tile_speed")
	#print("Tile friction under player: ", tile_speed)
	if tile_speed == null:
		tile_speed = 0  # fall back to default
	return tile_speed + friction

func set_movement_direction(direction: Vector2) -> void:
	move_direction = direction
	_move(0.01)
	entity.move_and_slide()
