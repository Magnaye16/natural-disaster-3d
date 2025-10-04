extends CanvasGroup
class_name Tilemap_manager

var _flamable_tiles:Dictionary[Vector2i, DynamicTile]
var _burning_objs:Dictionary[Vector2i, DynamicTile]

@export var objects_layers:Array[TileMapLayer] = []
@export var event_layer:TileMapLayer

@export var entity:CharacterBody2D
var tilemaps


@warning_ignore("unused_parameter")
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var pos:Vector2 = event_layer.to_local(get_global_mouse_position())
		spawn_fire(event_layer.local_to_map(pos))

func _ready() -> void:
	tilemaps = get_children()
	cache_dynamic_tiles()
	print("?")

const FIRE_SOURCE_ID:int = 14
const FIRE_ATLAS_COORDS:Vector2 = Vector2(1,3)
const FLAMABLE:StringName = &"flamable"
const BURNING:StringName = &"burning"
const HEALTH:StringName = &"health"
const FIRE_RESISTANCE:StringName = &"fire_resistance"

func cache_dynamic_tiles()->void:

	for layer in objects_layers:
		for tile in layer.get_used_cells():
			var flamable = get_custom_data(layer,tile,FLAMABLE)
			if not flamable:continue

			var burning:int = get_custom_data(layer,tile,BURNING)
			var resistance:int = get_custom_data(layer,tile,FIRE_RESISTANCE)
			var hp:int = get_custom_data(layer,tile,HEALTH)
			var tile_obj:FlamableTile = FlamableTile.new(tile,layer)
			tile_obj\
			.set_resistance(resistance)\
			.set_hp(hp)\
			.set_burning(burning)
			_flamable_tiles.set(tile,tile_obj)

	for tile in event_layer.get_used_cells():
			var burning:int = get_custom_data(event_layer,tile,BURNING)

			if not burning:continue
			var hp:int = get_custom_data(event_layer,tile,HEALTH)
			var tile_obj:FireTile = FireTile.new(tile,event_layer)
			tile_obj\
			.set_hp(hp)\
			.set_burning()
			_flamable_tiles.set(tile,tile_obj)

func burn_fire():
	add_fire_tile()
	apply_fire_tick()

func add_fire_tile():
		for tile:DynamicTile in _flamable_tiles.values():
			if tile.burning:continue
			event_layer.set_cell(tile.coords,-1)

func apply_fire_tick():
	apply_burn_ticks(event_layer)


func apply_burn_ticks(_layer:TileMapLayer):
		for tile:DynamicTile in _burning_objs.values():
			tile.health -= 1
			print(tile.health)
			if tile.health < 1:
				_burning_objs.erase(tile.coords)
				clear_fire(tile.coords)
				tile.queue_free()


func clear_fire(coords:Vector2i)->void:
	event_layer.set_cell(coords,-1)

func fire_spread():
	for fire:DynamicTile in _burning_objs.values():
		for layer in objects_layers:
			var surrounding_tiles:Array[Vector2i] = fire.get_surrounding_cells(layer)

			surrounding_tiles = surrounding_tiles.filter(
				func(tile:Vector2i):
					return get_custom_data(layer,tile,FLAMABLE)
			)


			if surrounding_tiles.size()<1:continue
			var rand_tile:Vector2i = surrounding_tiles.pick_random()


			if not rand_tile:continue

			var fire_resistance:int = _flamable_tiles.get(rand_tile).resistance
			print("fire resistance of tile %s === %f "%[rand_tile,fire_resistance])

			if (fire_resistance -1) > 0:
				(_flamable_tiles.get(rand_tile) as DynamicTile).resistance -= 1
				continue
			spawn_fire(rand_tile)


func get_surrounding_burnable_tiles(layer:TileMapLayer,coords:Vector2i)->Array[Vector2i]:
		return  layer.get_surrounding_cells(coords).filter(
				func(tile):return get_custom_data(layer,tile,FLAMABLE)
			)

func get_custom_data(layer:TileMapLayer, tile:Vector2i,custom_data:StringName):
		var data:TileData = layer.get_cell_tile_data(tile)
		if not data:return
		if data.has_custom_data(custom_data):
			return data.get_custom_data(custom_data)

func set_custom_data(layer:TileMapLayer, tile:Vector2i,custom_data:StringName,val)->void:
		var data:TileData = layer.get_cell_tile_data(tile)
		if not data:return
		if data.has_custom_data(custom_data):
			return data.set_custom_data(custom_data,val)

func spawn_fire(coords:Vector2i)->void:
	#set_custom_data(objects_layers[0],coords,BURNING,true)
	var flamable_tile:DynamicTile= _flamable_tiles.get(coords)
	if flamable_tile:
		_burning_objs.set(coords,flamable_tile)
		flamable_tile.set_burning(true)
		event_layer.set_cell(coords,FIRE_SOURCE_ID,FIRE_ATLAS_COORDS)
		return
	event_layer.set_cell(coords,FIRE_SOURCE_ID,FIRE_ATLAS_COORDS)
	_burning_objs.set(coords,FireTile.new(coords,event_layer))


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
