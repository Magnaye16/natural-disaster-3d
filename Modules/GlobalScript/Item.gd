extends Node2D
class_name Item

@export var item_resource:ItemResource:
	set = set_item_resource

# Item details for editor window
var item_Type = ""
var item_Name = ""
var item_Texture: Texture
var item_Effect = ""
static var scene_path: String = "res://Modules/Inventory/Scene/Item.tscn"

# Scene-Tree Node references
@onready var icon_Sprite = $Sprite2D

func _ready():
	# Set the texture to reflect in the game
	if not Engine.is_editor_hint():
		icon_Sprite.texture = item_Texture
		item_resource = item_resource


# Add item to inventory
func pickup_Item(entity:Entity):
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
		print("set itemresource")


func _on_interactable_component_interacted(entity: Entity) -> void:
		pickup_Item(entity)
