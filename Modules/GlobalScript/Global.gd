extends Node

func get_player()->Player:
	return get_tree().get_first_node_in_group("player")

func get_game_manager()->GameManager:
	var gm_path:String = "../Main_game/GameManager"
	has_node(gm_path)
	return get_node(gm_path)
