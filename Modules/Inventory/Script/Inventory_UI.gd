extends Control

@onready var grid_Container = $GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.inventory_Updated.connect(_on_inventory_updated)
	_on_inventory_updated()

#update the inventory UI
func _on_inventory_updated():
	clear_Grid_container() 
	#add slot for each inventory position
	for item in Global.inventory:
		var slot = Global.inventory_Slot_scene.instantiate()
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
