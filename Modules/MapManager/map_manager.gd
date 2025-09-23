extends SubViewport
class_name MapManager

var current_map: Map = null
var map_cache: Dictionary[String,Map]
var package:PlayerCamPackage


func _ready() -> void:
	set_default_canvas_item_texture_filter(Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST)

	for child in get_children():
		if child  is GlobalCamera:continue
		assert(child is Map,"This child node:%s is not inherent from MAP"%child.name)
		print(child.name)
		map_cache.set(child.name,child)

		if current_map == null:
			current_map = child
			package = current_map.package
			current_map.entry_map()
		else:
			child.clean()  # only keep the first map active

	current_map = get_child(0)

func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_L):
		switch_to_next_map()

func switch_map(map: Map, reload: bool = false) -> void:

	if not reload:
		if current_map == map:return
		#new map
		return switch_to_new_map_no_reload(map)

	#need reload
	var new_map:Map = load(map.scene_path).instantiate()
	var old_map = current_map

	current_map = new_map

	new_map.activate(old_map.player)

	add_child(new_map)
	old_map.queue_free()


func switch_to_new_map_no_reload(map:Map)->void:
	var old_map:Map = current_map
	current_map = map
	old_map.deactivate()
	current_map.activate(package)

func reload_map() -> void:
	if current_map == null:
		push_warning("No map to reload.")
		return
	switch_map(current_map, true)

func switch_to_next_map() -> void:
	if map_cache.is_empty():
		push_warning("No maps available to cycle through.")
		return
	var next_map_idx = (current_map.get_index()+1)% map_cache.size()
	switch_map(get_child(next_map_idx))
