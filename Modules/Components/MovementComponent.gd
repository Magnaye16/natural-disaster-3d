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



#func _move(delta: float) -> void:
	#if move_direction:
		#var product_speed:float = speed
#
		#for stat in status_multiplier.status_array:
			#product_speed = stat.apply_multiplier(product_speed)
		#speed = max(0.1, speed)
		#velocity = velocity.lerp(move_direction * product_speed, acceleration * delta)
	#var friction  = get_tile_data(&"tile_speed")
	#if friction  == null:
		#friction = self.friction
	#else:
		#
		#velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	#
	#
	
func _move(delta: float) -> void:
	if move_direction:
		var product_speed: float = speed
		# Apply status multipliers to speed
		for stat in status_multiplier.status_array:
			product_speed = stat.apply_multiplier(product_speed)
		# Make sure speed never drops too low
		product_speed = max(0.1, product_speed * get_tile_speed()) 
		# Accelerate towards target velocity
		velocity = velocity.lerp(move_direction * product_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, get_tile_friction() * delta)
	


func get_tile_speed():
	var tile_speed = get_tile_data(&"Tile_speed")
	print("Tile friction under player: ", tile_speed)
	if tile_speed == null:
		tile_speed = 0  # fall back to default
	return tile_speed


func get_tile_friction():
	var tile_speed = get_tile_data(&"Tile_speed")
	print("Tile friction under player: ", tile_speed)
	if tile_speed == null:
		tile_speed = 0  # fall back to default
	return tile_speed + friction

func get_tile_data(custom_data_name: StringName) -> Variant:
	var tilemaps := get_tree().get_nodes_in_group(&"tilemap")
	tilemaps.reverse() # Reverse, so it checks top tilemap layers first
	for tilemap in tilemaps:
		var ret = _get_tile_data_from_tilemap(custom_data_name, tilemap)
		if ret != null:
			return ret
	return null

func _get_tile_data_from_tilemap(custom_data_name: StringName, tile: TileMapLayer) -> Variant:
	var local_pos = tile.to_local(entity.global_position)
	var cell: Vector2i = tile.local_to_map(local_pos)
	#print("Tilemap:", tile.name, " Entity global:", entity.global_position, " Local:", local_pos, " Cell:", cell)
	var data: TileData = tile.get_cell_tile_data(cell)
	if data == null:
		#print("No tile data found at cell in:", tile.name)
		return null
	var tile_data = data.get_custom_data(custom_data_name)
	#print("Custom data [", custom_data_name, "] = ", tile_data)
	return tile_data
	
func set_movement_direction(direction: Vector2) -> void:
	move_direction = direction
	_move(0.01)
	entity.move_and_slide()
