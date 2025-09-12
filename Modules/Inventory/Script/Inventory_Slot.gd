extends Control
class_name Inventoryslot


@onready var icon = $OuterBorder/InnerBorder/ItemIcon
@onready var quantity_Label = $OuterBorder/InnerBorder/ItemQTY
@onready var details_Panel = $OuterBorder/DetailsPanel
@onready var item_Name = $OuterBorder/DetailsPanel/ItemName
@onready var item_Type = $OuterBorder/DetailsPanel/ItemType
@onready var item_Effect  =$OuterBorder/DetailsPanel/ItemEffect
@onready var usage_Panel = $OuterBorder/UsagePanel

var item:ItemResource = null

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

func set_item(new_Item:ItemResource):
	item = new_Item
	icon.texture = new_Item.item_Texture
	quantity_Label.text = str(item.item_Qty)
	item_Name.text = str(item.item_Name)
	item_Type.text = str(item.item_Type)
	if item.item_Effect != "":
		item_Effect.text = str("+ ", item.item_Effect)
	else:
		item_Effect.text = ""


func _on_drop_button_pressed():
	if item != null:
		var drop_Position = Global.player_Node.global_position
		var drop_Offset = Vector2(0,50)
		
		drop_Offset = drop_Offset.rotated(Global.player_Node.rotation)
		Global.player_Node.inventory.remove_Item(item)
		Global.player_Node.inventory.drop_Item(item, drop_Position + drop_Offset)
		usage_Panel.visible = false


func _on_use_button_pressed():
	usage_Panel.visible = false
	if item != null and item.item_Effect != "":
		if Global.player_Node:
			Global.player_Node.apply_Item_effect(item)
			Global.player_Node.inventory.remove_Item(item)
			
		else:
			print("Player not found")
