extends Node2D
class_name Tilemap_manager

@export var entity:CharacterBody2D
var tilemaps


func _ready() -> void:
	tilemaps = get_children()


func get_tile_data(custom_data_name: StringName ) -> Variant:
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

	var tile_data
	if data.has_custom_data(custom_data_name):
		tile_data = data.get_custom_data(custom_data_name)
	return tile_data
