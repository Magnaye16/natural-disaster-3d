@tool
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

# Variables
var player_in_range = false

func _ready():
	# Set the texture to reflect in the game
	if not Engine.is_editor_hint():
		icon_Sprite.texture = item_Texture
		item_resource = item_resource




func _process(_delta):
	# Set the texture to reflect in the editor
	if Engine.is_editor_hint():
		icon_Sprite.texture = item_Texture
	# Add item to inventory if player presses "E" within range
 #Input.is_action_just_pressed("ui_add"):

# Add item to inventory
func pickup_Item(entity:Entity):

	if entity.inventory == null:
		return
	if entity.inventory.add_Item(item_resource):
		self.queue_free()

# If player is in range, show UI and make item pickable
func _on_area_2d_body_entered(body):
	player_in_range = true
	body.interact_UI.visible = true

# If player is in range, hide UI and don't make item pickable
func _on_area_2d_body_exited(body):
	player_in_range = false
	body.interact_UI.visible = false




func _on_interactable_area_interacted(entity):

	pickup_Item(entity)

func set_item_resource(val:ItemResource):
		if val == null or  Engine.is_editor_hint():return
		item_resource = val
		item_resource.init()
		item_Name = item_resource.item_Name
		item_Texture = item_resource.item_Texture
		item_Effect = item_resource.item_Effect
		item_Type = item_resource.item_Type
		print("set itemresource")
