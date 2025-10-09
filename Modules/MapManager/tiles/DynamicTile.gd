extends BaseTile
class_name DynamicTile

var source_id:int:
	get:return source_id if not source_id==null else layer.get_cell_source_id(coords)
var atlas_coords:Vector2i:
	get:return atlas_coords if atlas_coords else layer.get_cell_atlas_coords(coords)
var data:TileData:
	get:
		return layer.get_cell_tile_data(coords)

func _init(_coords:Vector2i,_layer:TileMapLayer) -> void:
	super._init(_coords,_layer)

func queue_free():
	layer.set_cell(coords,-1)

func spawn_tile():
	_spawn_tile()
	init_datas()


func _spawn_tile():
	layer.set_cell(coords,source_id,atlas_coords)
