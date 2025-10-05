extends RefCounted
class_name DynamicTile

var coords:Vector2i
var source_id:int
var atlas_coords:Vector2i
var layer:TileMapLayer
var height:int = 1
var depth:int = 1


func set_depth(_depth:int)->DynamicTile:
	depth = _depth
	return self

func set_height(_height:int)->DynamicTile:
	height = _height
	return self

func get_surrounding_cells(_layer:TileMapLayer = layer)->Array[Vector2i]:
	return _layer.get_surrounding_cells(coords)

func queue_free():
	layer.erase_cell(coords)

func _init(_coords:Vector2i,_layer:TileMapLayer) -> void:
	coords = _coords
	layer = _layer

	#add itself to the layer

func spawn_tile():
	layer.set_cell(coords,source_id,atlas_coords)
	layer.update_internals()
