extends Node
class_name Inventory
const inventorysize = 30
var contents:Array[ItemResource] = []

signal inventory_Updated

@onready var inventory_Slot_scene = preload("res://Modules/Inventory/Scene/Inventory_Slot.tscn")

func _ready():
	#Initialize the contents with 3D slots
	contents.resize(inventorysize)

func add_Item(item:ItemResource)->bool:
	for i in range(contents.size()):
		if contents[i] != null and contents[i].item_Name== item.item_Name and contents[i].item_Effect == item.item_Effect:
			contents[i].item_Qty += item.item_Qty
			inventory_Updated.emit()
			print("item added ", contents)
			return true
		elif contents[i] == null:
			contents[i] = item
			inventory_Updated.emit()
			print("item added ", contents)
			return true
	# If no suitable slot found:
	return false

func remove_Item(item:ItemResource):
	for i in range (contents.size()):
		if contents[i] != null and contents[i].item_Name== item.item_Name and contents[i].item_Effect == item.item_Effect:
			contents[i].item_Qty -= 1
			if contents[i].item_Qty <= 0:
				contents[i] = null
			inventory_Updated.emit()
			return true
	return false

func increased_Inventory_size(extra_Slot):
	contents.resize(contents.size() + extra_Slot)
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

func drop_Item(item_Data:ItemResource, drop_Position):
	Global.get_map_manager()
