class_name Item

@export var item_resource:ItemResource:
	set = set_item_resource

# Item details for editor window
var item_Type = ""
var item_Name = ""
var item_Texture: Texture
var item_Effect = ""

func set_item_resource(val:ItemResource):
		if val == null or  Engine.is_editor_hint():return
		item_resource = val
		item_Name = item_resource.item_Name
		item_Texture = item_resource.item_Texture
		item_Effect = item_resource.item_Effect
		item_Type = item_resource.item_Type
