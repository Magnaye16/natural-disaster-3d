extends Control
class_name Inventoryslot


@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_Label = $InnerBorder/ItemQTY
@onready var details_Panel = $DetailsPanel
@onready var item_Name = $DetailsPanel/ItemName
@onready var item_Type = $DetailsPanel/ItemType
@onready var item_Effect = $DetailsPanel/ItemEffect
@onready var usage_Panel = $UsagePanel

var item = null

func _on_item_button_pressed():
	if item != null:
		usage_Panel.visible = !usage_Panel.visible

func _on_item_button_mouse_entered():
	if item != null:
		usage_Panel.visible = false
		details_Panel.visible = true

func _on_item_button_mouse_exited():
	details_Panel.visible = false

func set_empty():
	icon.texture = null
	quantity_Label.text = ""

func set_item(new_Item):
	item = new_Item
	icon.texture = new_Item["texture"]
	quantity_Label.text = str(item["quantity"])
	item_Name.text = str(item["name"])
	item_Type.text = str(item["type"])
	if item["effect"] != "":
		item_Effect.text = str("+ ", item["effect"])
	else:
		item_Effect.text = ""


func _on_drop_button_pressed():
	if item != null:
		var drop_Position = Global.player_Node.global_position
		var drop_Offset = Vector2(0,50)
		
		drop_Offset = drop_Offset.rotated(Global.player_Node.rotation)
		Global.drop_Item(item, drop_Position + drop_Offset)
		Global.remove_Item(item["name"], item["effect"])
		usage_Panel.visible = false


func _on_use_button_pressed():
	usage_Panel.visible = false
	if item != null and item["effect"] != "":
		if Global.player_Node:
			Global.player_Node.apply_Item_effect()
			Global.remove_Item(item["name"], item["effect"])
			
		else:
			print("Player not found")
