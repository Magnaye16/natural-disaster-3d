extends DisasterEffect
class_name FallingDebress


const DEBREE_SPAWNER = preload("uid://nhl0tvi58djn")

func _enter():
	var player:Player = Global.get_player()
	var debree_spawner:DebreeSpawner = DEBREE_SPAWNER.instantiate()

	player.add_child(debree_spawner)
