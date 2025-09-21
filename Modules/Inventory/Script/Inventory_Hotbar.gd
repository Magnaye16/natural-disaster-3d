extends Control
class_name InventoryHotbar


@onready var grid_Container = $GridContainer
@onready var player_inventory:Inventory

func _ready() -> void:
	await  get_tree().process_frame

	var player = (get_tree().get_first_node_in_group("player") as Player)
	if player and player.inventory:
		player_inventory = player.inventory

		player_inventory.inventory_Updated.connect(_on_inventory_updated)
		_on_inventory_updated()


func _on_inventory_updated():
	clear_Grid_container()
	#add slot for each inventory position
	var i: = 0
	for item in player_inventory.contents:
		if i == 10: return
		i += 1
		var slot = player_inventory.inventory_Slot_scene.instantiate()
		grid_Container.add_child(slot)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()


func clear_Grid_container():
	while grid_Container.get_child_count() > 0:
		var child = grid_Container.get_child(0)
		grid_Container.remove_child(child)
		child.queue_free()
