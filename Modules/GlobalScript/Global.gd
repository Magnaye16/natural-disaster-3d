extends Node

func get_player()->Player:
	return get_tree().get_first_node_in_group("player")

func get_game_manager()->GameManager:
	return get_node("../Main_game/GameManager")
