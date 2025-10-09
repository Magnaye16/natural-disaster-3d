extends Node

func get_player()->Player:
	return get_tree().get_first_node_in_group("player")

func get_game_manager()->GameManager:
	return _get_node("%GameManager")

func get_map_manager()->MapManager:
	return _get_node( "%MapManager")


func _get_node(path:NodePath)->Variant:
	if not has_node(path):return null
	return get_node(path)
