extends DisasterEffect


func  _enter():
	game_manager.get_tree().get_first_node_in_group("global_camera").shake()
