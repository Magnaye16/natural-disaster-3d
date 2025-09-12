extends Control
class_name InventoryGridUI


@onready var grid_Container = $GridContainer
@onready var player_inventory:Inventory =$"../../../Inventory"


# Called when the node enters the scene tree for the first time.
func init():
	#await get_parent().ready 
	#print( Global.player_Node)
	Global.player_Node.inventory.inventory_Updated.connect(_on_inventory_updated)
	_on_inventory_updated()

#update the inventory UI
func _on_inventory_updated():
	clear_Grid_container() 
	#add slot for each inventory position
	for item in player_inventory.contents:
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
