extends Node

func get_player()->Player:
	return get_tree().get_first_node_in_group("player")

func get_game_manager()->GameManager:
	return _get_node(&"game_manager")

func get_map_manager()->MapManager:
	return _get_node(&"map_manager")

func _get_node(group:StringName)->Variant:
	return get_tree().get_first_node_in_group(group)
