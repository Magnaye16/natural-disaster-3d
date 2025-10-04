extends RefCounted
class_name DynamicTile

var coords:Vector2i
var source_id:int
var layer:TileMapLayer



func get_surrounding_cells(_layer:TileMapLayer = layer)->Array[Vector2i]:
	return _layer.get_surrounding_cells(coords)

func queue_free():
	layer.set_cell(coords,-1)

func _init(_coords:Vector2i,_layer:TileMapLayer) -> void:
	coords = _coords
	layer = _layer
