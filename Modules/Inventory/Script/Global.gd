extends Node

var inventory = []

signal inventory_Updated

var player_Node = null
@onready var inventory_Slot_scene = preload("res://Modules/Inventory/Scene/Inventory_Slot.tscn")

func _ready():
	#Initialize the inventory with 3D slots
	inventory.resize(30)

func add_Item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == item["name"] and inventory[i]["effect"] == item["effect"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_Updated.emit()
			print("item added ", inventory)
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_Updated.emit()
			print("item added ", inventory)
			return true
	# If no suitable slot found:
	return false

func remove_Item(item_name, item_effect):
	for i in range (inventory.size()):
		if inventory[i] != null and inventory[i]["name"] ==item_name and inventory[i]["effect"] == item_effect:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_Updated.emit()
			return true
	return false

func increased_Inventory_size(extra_Slot):
	inventory.resize(inventory.size() + extra_Slot)
	inventory_Updated.emit()


func adjust_Drop_position(position):
	var radius = 100
	var nearby_Items = get_tree().get_nodes_in_group("Items")
	for item in nearby_Items:
		if item.global_position.distance_to(position) < radius: 
			var random_offset = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
			position += random_offset
			break 
	return position

func drop_Item(item_Data, drop_Position):
	var item_Scene = load(item_Data["scene_path"])
	var item_Instance = item_Scene.instantiate()
	item_Instance.set_Item_data(item_Data)
	drop_Position = adjust_Drop_position(drop_Position)
	item_Instance.global_position = drop_Position
	get_tree().current_scene.add_child(item_Instance)
