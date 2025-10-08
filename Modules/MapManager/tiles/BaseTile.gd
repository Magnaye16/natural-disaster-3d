
class_name BaseTile
extends RefCounted

var coords:Vector2i
var layer:TileMapLayer
var height:int = 1
var depth:int = 1

const HEIGHT:StringName = &"heigth"
const DEPTH:StringName = &"depth"
const FLAMABLE:StringName = &"flamable"
const HEALTH:StringName = &"health"
const FIRE_RESISTANCE:StringName = &"fire_resistance"
const BURNING:StringName = &"burning"

var type:GDScript:
	get:return get_script()

static func create_tile(_coords:Vector2i,_layer:TileMapLayer)->BaseTile:
	var base_tile:BaseTile = BaseTile.new(_coords,_layer)

	if BaseTile._get_custom_data(_layer,_coords,FLAMABLE,false):
		var f =  FlamableTile.new(_coords,_layer)
		return f
	return base_tile


func _init(_coords:Vector2i,_layer:TileMapLayer) -> void:
	coords = _coords
	layer = _layer

func init_datas():
	depth = get_custom_data(DEPTH,0)
	height = get_custom_data(HEIGHT,1)

func set_depth(_depth:int)->BaseTile:
	depth = _depth
	return self

func set_height(_height:int)->BaseTile:
	height = _height
	return self

func has_custom_data(custom_data:StringName)->bool:
		var data:TileData = layer.get_cell_tile_data(coords)
		return data.has_custom_data(custom_data)

func get_surrounding_cells()->Array[Vector2i]:
	return layer.get_surrounding_cells(coords)

static func _get_custom_data(_layer:TileMapLayer,_coords:Vector2i,_custom_data:StringName,default=null)->Variant:
	var data:TileData = _layer.get_cell_tile_data(_coords)
	if  not data.has_custom_data(_custom_data):return default
	var custom_data = data.get_custom_data(_custom_data)
	if not custom_data:return default

	return custom_data

func get_custom_data(_custom_data:StringName,default=null)->Variant:
		return BaseTile._get_custom_data(layer,coords,_custom_data,default)
