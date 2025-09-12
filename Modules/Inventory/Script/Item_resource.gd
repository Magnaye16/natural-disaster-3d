extends Resource
class_name ItemResource 

# Item details for editor window
@export var item_Name = ""

@export_group("auto set")
@export var item_Qty:int = 1
@export var item_Type = ""
@export var item_Texture: Texture
@export var item_Effect = ""

#var scene_path: String = "res://Scene/Inventory_item.tscn"


#
#func init(_item_qty:int, _item_type:String, _item_name:String, _item_texture:Texture, _item_effect:String)->ItemResource:
	#item_Qty = _item_qty
	#item_Type = _item_type
	#item_Name = _item_name
	#item_Texture = _item_texture
	#item_Effect = _item_effect

func init()->ItemResource:
	
	var json_path = "res://Modules/Inventory/Resource/itemsdatas.json"
	var file = FileAccess.open(json_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var data = JSON.parse_string(json_text)[item_Name]
		
		item_Name = data["name"]
		item_Effect = data["effect"]
		item_Texture = load(data["texture"])
		item_Type = data["type"]
	
	file.close()
	return self
	
