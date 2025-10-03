extends CanvasGroup
class_name Tilemap_manager


class TILE_OBJ :
	var coords:Vector2i
	var source_id:int

class DYNAMIC_TILE_OBJ extends  TILE_OBJ:
	var health:int
	var burnable:bool
	var burning:bool

class FIRE_TILE extends TILE_OBJ:
	var lifespan:int


var _burnable_obj:Array[DYNAMIC_TILE_OBJ]
var _burning_objs:Array[DYNAMIC_TILE_OBJ]


@export var burnable_tile_layers:Array[TileMapLayer] = []
@export var event_layer:TileMapLayer


@export var entity:CharacterBody2D
var tilemaps

@onready var burn_tick: Timer = $"../Timer"


@warning_ignore("unused_parameter")
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var pos:Vector2 = event_layer.to_local(get_global_mouse_position())
		spawn_fire(event_layer.local_to_map(pos))

func _ready() -> void:
	tilemaps = get_children()

const FIRE_SOURCE_ID:int = 14
const FIRE_ATLAS_COORDS:Vector2 = Vector2(1,3)
const BURNABLE:StringName = &"burnable"
const BURNING:StringName = &"burning"
const HEALTH:StringName = &"health"
const FIRE_RESISTANCE:StringName = &"fire_resistance"





func burn_fire():
	add_fire_tile()
	applly_object_tick()
	apply_fire_tick()

func add_fire_tile():
	for  burnable_layer in burnable_tile_layers:
		var used_cells:Array[Vector2i] = burnable_layer.get_used_cells()
		for tile in used_cells:
			var data:TileData  = burnable_layer.get_cell_tile_data(tile)
			if data.has_custom_data(BURNING) and data.get_custom_data(BURNING):
				event_layer.set_cell(tile,FIRE_SOURCE_ID,FIRE_ATLAS_COORDS)

func apply_fire_tick():
	apply_burn_ticks(event_layer)

func applly_object_tick():
	for burnable_layer in burnable_tile_layers:
		apply_burn_ticks(burnable_layer)

func apply_burn_ticks(layer:TileMapLayer):
		if not layer:return
		var used_cell:Array[Vector2i] = layer.get_used_cells()
		for tile in used_cell:
			var data:TileData  = layer.get_cell_tile_data(tile)
			if data.has_custom_data(BURNING) and data.get_custom_data(BURNING):
				var hp:int = data.get_custom_data(HEALTH)
				if hp<=0 : layer.set_cell(tile,-1)
				set_custom_data(layer,tile,HEALTH,hp-1)


func fire_spread():
	return
	#if not event_layer:return
	#var used_cell:Array[Vector2i] = event_layer.get_used_cells()
#
	#var burnable_tile:TileMapLayer=burnable_tile_layers[0]
#
	#for tile in used_cell:
		#var data:TileData  = event_layer.get_cell_tile_data(tile)
		#if not data.has_custom_data(BURNING) or data.get_custom_data(BURNING):continue
#
		#var possible_tiles: = get_surrounding_burnable_tiles(burnable_tile,tile)
#
		#var picked_tile = possible_tiles.pick_random()
		#if not picked_tile:return
		#var fire_resistance:int = get_custom_data(burnable_tile,picked_tile,FIRE_RESISTANCE)
		#set_custom_data(burnable_tile,picked_tile,FIRE_RESISTANCE,fire_resistance-1)
#
		#if fire_resistance -1 > 0:continue
		#spawn_fire(tile)

func get_surrounding_burnable_tiles(layer:TileMapLayer,coords:Vector2i)->Array[Vector2i]:
		return  layer.get_surrounding_cells(coords).filter(
				func(tile):return get_custom_data(layer,tile,BURNABLE)
			)

func get_custom_data(layer:TileMapLayer, tile:Vector2i,custom_data:StringName):
		var data:TileData = layer.get_cell_tile_data(tile)
		if not data:return
		if data.has_custom_data(custom_data):
			return data.get_custom_data(custom_data)

func set_custom_data(layer:TileMapLayer, tile:Vector2i,custom_data:StringName,val)->void:
		var data:TileData = layer.get_cell_tile_data(tile)
		if not data:return

		print("custom data %s = %s "%[custom_data,val])
		if data.has_custom_data(custom_data):
			return data.set_custom_data(custom_data,val)

func spawn_fire(coords:Vector2):
	set_custom_data(burnable_tile_layers[0],coords,BURNING,true)


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
