extends CanvasGroup
class_name Tilemap_manager


var _fire_tiles:Dictionary[Vector2i, FlamableTile]
var _flamable_tiles:Dictionary[Vector2i, FlamableTile]
var _burning_objs:Dictionary[Vector2i, FlamableTile]
var _dynamic_water_tiles:Dictionary[Vector2i, DynamicWaterTile]
var _static_tiles:Dictionary[Vector2i, BaseTile]

var tile_groups:Dictionary[GDScript,Dictionary]={
	BaseTile:_static_tiles,
	DynamicWaterTile:_dynamic_water_tiles,
	FireTile:_fire_tiles,
	FlamableTile:_flamable_tiles,
}



@export var fire_effects_layer:TileMapLayer
@export var water_effects_layer:TileMapLayer


@export var entity:CharacterBody2D
var tile_map_layers


@warning_ignore("unused_parameter")
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_1):
		var pos:Vector2 = fire_effects_layer.to_local(get_global_mouse_position())
		spawn_fire(fire_effects_layer.local_to_map(pos))

	if Input.is_key_pressed(KEY_2):
		var pos:Vector2 = water_effects_layer.to_local(get_global_mouse_position())
		spawn_water(water_effects_layer.local_to_map(pos))

var cached:bool = false
func _preload():
	if cached:return
	cache_dynamic_tiles()
	cached = true

func _ready() -> void:
	tile_map_layers = get_children()

func _cache_tile(tile:BaseTile)->void:
	tile_groups.get(tile.type).set(tile.coords,tile)
	tile.init_datas()


func cache_dynamic_tiles()->void:

	for layer in tile_map_layers:
		for cell in layer.get_used_cells():
			var tile:BaseTile =  BaseTile.create_tile(cell,layer)
			_cache_tile(tile)


func burn_fire():
	apply_fire_tick()





func apply_fire_tick():
	apply_burn_ticks()

##updates lifetime of burning tiles
func apply_burn_ticks():
		for tile:FlamableTile in _burning_objs.values():

			#print( 1/(float(tile.health ) + 5))

			tile.health -= 1

			if tile.health < 1:
				tile.queue_free()
				#remove also the fire sprite
				fire_effects_layer.erase_cell(tile.coords)
				_burning_objs.erase(tile.coords)
				_flamable_tiles.erase(tile.coords)
				continue

#
			if 1/(float(tile.health ) + 5 )> randf():
				tile.set_burning(false)

				fire_effects_layer.erase_cell(tile.coords)
				_burning_objs.erase(tile.coords)
				#_flamable_tiles.set(tile.coords,tile)

		for fire:FireTile in _fire_tiles.values():
			fire.health -= 1

			if fire.health < 1:
				fire.queue_free()
				#remove also the fire sprite
				fire_effects_layer.erase_cell(fire.coords)
				_burning_objs.erase(fire.coords)
				_flamable_tiles.erase(fire.coords)


func fire_spread():
	var surrounding_tiles:Array[FlamableTile]

	for fire:FlamableTile in _burning_objs.values():

		for layer in tile_map_layers:
			surrounding_tiles.append_array( get_surrounding_flamable_tiles(fire) )



		var rand_tile:FlamableTile= surrounding_tiles.pick_random()
		if not rand_tile:continue
		surrounding_tiles.erase(rand_tile)

		if surrounding_tiles.size()>0 and rand_tile.burning and 0.9 > randf() :
			rand_tile= surrounding_tiles.pick_random()


		var fire_resistance:int = rand_tile.resistance
		var coords:Vector2i = rand_tile.coords


		if (fire_resistance -1) > 0:
			rand_tile.resistance -= 1
			continue

		spawn_fire(coords)

func water_spread():

	print(_dynamic_water_tiles.values().map(
		func(w):return w.height
	))

	for water:DynamicWaterTile in _dynamic_water_tiles.values():
		if water.updated or water.height <= 1 : continue

		for layer:TileMapLayer in get_children():
			if layer == water_effects_layer:continue

			var surrounding = water.get_surrounding_cells()

			for tile in surrounding:

				if _dynamic_water_tiles.has(tile):
					var w:DynamicWaterTile = _dynamic_water_tiles.get(tile)
					if water.height <= w.height:continue
					w.height += 1
					w.updated = false
					continue
#
				#var height = get_custom_data(layer,tile,&"height")
				#if not height:height = 0
				#if water.height < height :continue
				#spawn_water(tile,water.height-1)


		water.updated = true
		water.height -= 1



func get_surrounding_flamable_tiles(origin_tile:FlamableTile)->Array[FlamableTile]:
		var tiles:Array[FlamableTile] = []
		for cell in origin_tile.get_surrounding_cells():
			var tile = _flamable_tiles.get(cell)
			if not tile:continue
			tiles.append(tile)
		return tiles



func set_custom_data(layer:TileMapLayer, tile:Vector2i,custom_data:StringName,val)->void:
		var data:TileData = layer.get_cell_tile_data(tile)
		if not data:return
		if data.has_custom_data(custom_data):
			return data.set_custom_data(custom_data,val)

func spawn_fire(coords:Vector2i)->void:
	var flamable_tile:FlamableTile = _flamable_tiles.get(coords)
	var fire:FireTile = FireTile.new(coords,fire_effects_layer)

	fire.spawn_tile()


	##empty space
	if not flamable_tile :
		_fire_tiles.set(coords,fire)

		return


	if flamable_tile.burning:
		print("burninnnngg")
		if randf()<0.99:return
		print("famge")
		flamable_tile.health-=1

	flamable_tile.set_burning(true)
	_burning_objs.set(coords,flamable_tile)





func spawn_water(coords:Vector2i,_height:int = 1)->void:
	#get water tiles that is not yet spread itself
	var existing_water:DynamicWaterTile = _dynamic_water_tiles.get(coords)
	#
	if existing_water:
		existing_water.height +=1
		existing_water.updated = false
		return
	var water:DynamicWaterTile = DynamicWaterTile.new(coords,water_effects_layer)
	water.set_height(_height)

	water.spawn_tile()
	_dynamic_water_tiles.set(coords,water)

func get_tile_data(custom_data_name: StringName ) -> Variant:
	tile_map_layers.reverse() # Reverse, so it checks top tilemap layers first
	for tilemap in tile_map_layers:
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


func _on_housemap_entered() -> void:
	_preload()
