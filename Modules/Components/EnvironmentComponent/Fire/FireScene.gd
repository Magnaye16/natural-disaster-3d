extends Node2D
class_name FireScene

var duration:int = 7
var fire_damage:int = 1
var radius:int  = 100
var amount:int  = 1
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	audio_stream_player_2d.play()
	await get_tree().create_timer(duration).timeout
	despawn_fire()

func start():
	for i in range(amount):
		await  get_tree().create_timer(randf()*0.8).timeout
		var l:=collision_shape_2d.shape.get_rect().size.x/2 * randf_range(-1,1)
		var w:=collision_shape_2d.shape.get_rect().size.y/2 * randf_range(-1,1)
		spawn_fire(Vector2( l,w))


func spawn_fire(pos:Vector2):
	pass
	#var debree:Debree = DEBREE.instantiate()
	#debree.global_position += position + pos
	#get_parent().add_child(debree)

func despawn_fire():
	queue_free()
	pass

func check_burnable():

	pass

func fire_spread():

	pass




func get_tile_data(custom_data_name: StringName) -> Variant:
	var tilemaps := get_tree().get_nodes_in_group(&"Tilemaps")
	tilemaps.reverse() # Reverse, so it checks top tilemap layers first
	for tilemap in tilemaps:
		var ret = _get_tile_data_from_tilemap(custom_data_name, tilemap)
		if ret != null:
			return ret
	return null

func _get_tile_data_from_tilemap(custom_data_name: StringName, tile: TileMapLayer) -> Variant:
	var cell: Vector2i = tile.local_to_map(position)
	var data: TileData = tile.get_cell_tile_data(cell)
	if data:
		var tile_data = data.get_custom_data(custom_data_name)
		return tile_data
	return null


func _on_area_2d_area_entered(area: Area2D) -> void:
	var fire_component:FireComponent = area.get_parent()
	var BURN = preload("uid://6xa8o7r5m1mk").duplicate()
	BURN.flat_addition = fire_damage

	fire_component.apply_damage_fire_status(BURN)
