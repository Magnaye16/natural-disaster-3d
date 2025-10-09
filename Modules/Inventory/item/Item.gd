extends DynamicTile
class_name ItemTile

@export var item_resource:ItemResource:
	set = set_item_resource

# Item details for editor window
var item_Type = ""
var item_Name = ""
var item_Texture: Texture
var item_Effect = ""


var effects:Array = []

# Add item to inventory
func interact(entity:Entity):
	if entity.inventory == null:
		return
	if entity.inventory.add_Item(item_resource):
		self.queue_free()

func set_item_resource(val:ItemResource):
		if val == null or  Engine.is_editor_hint():return
		item_resource = val
		item_resource.init()
		item_Name = item_resource.item_Name
		item_Texture = item_resource.item_Texture
		item_Effect = item_resource.item_Effect
		item_Type = item_resource.item_Type
