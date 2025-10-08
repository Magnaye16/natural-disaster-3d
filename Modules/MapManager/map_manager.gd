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
		(child as Map).go_to_requested.connect(switch_map)

		if current_map == null:
			current_map = child
			package = current_map.package
			current_map._entry_map()
		else:
			child.clean()  # only keep the first map active

	current_map = get_child(0)

func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_L):
		switch_to_next_map()



func switch_map(location:StringName, reload: bool = false) -> void:


	var map_door:Array = location.split(":")

	var map_name:StringName = map_door[0]
	var map_id:StringName = map_door[1]

	var map:Map = map_cache.get(map_name)

	if not reload:
		if current_map == map:return
		#new map
		map.spawn_to_door(map_id)

		return switch_to_new_map_no_reload(map)

	#need reload
	var new_map:Map = load(map.scene_path).instantiate()
	var old_map = current_map

	current_map = new_map

	new_map.activate(old_map.player)
	new_map.spawn_to_door(map_id)
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
	switch_map(current_map.name, true)

func switch_to_next_map() -> void:
	if map_cache.is_empty():
		push_warning("No maps available to cycle through.")
		return
	var next_map_idx = (current_map.get_index()+1)% map_cache.size()
	switch_map(get_child(next_map_idx).name)
