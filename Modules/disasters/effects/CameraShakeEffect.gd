extends ShakeEffect
class_name CameraShakeEffect

var frequency:float = 100:
	get:return intensity * 80

func _enter() -> void:
	(game_manager
	.get_tree()\
	.get_first_node_in_group("global_camera") as GlobalCamera)\
	.shake(intensity,duration,frequency)