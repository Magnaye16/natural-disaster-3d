extends Node



var player_Node:Player:
	get:return get_tree().get_first_node_in_group("player")
