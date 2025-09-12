@tool
extends Node2D
class_name InventoryItem

# Item details for editor window
@export var item_Type = ""
@export var item_Name = ""
@export var item_Texture: Texture
@export var item_Effect = ""
var scene_path: String = "res://Scene/Inventory_item.tscn"

# Scene-Tree Node references
@onready var icon_Sprite = $Sprite2D

# Variables
var player_in_range = false

func _ready():
	# Set the texture to reflect in the game
	if not Engine.is_editor_hint():
		icon_Sprite.texture = item_Texture

func _process(_delta):
	# Set the texture to reflect in the editor
	if Engine.is_editor_hint():
		icon_Sprite.texture = item_Texture
	# Add item to inventory if player presses "E" within range
 #Input.is_action_just_pressed("ui_add"):

# Add item to inventory
func pickup_Item(entity):
	var item = {
		"quantity": 1,
		"type": item_Type,
		"name": item_Name,
		"effect": item_Effect,
		"texture": item_Texture,
		"scene_path": scene_path
	}
	entity.add_Item(item)
	self.queue_free()

# If player is in range, show UI and make item pickable
func _on_area_2d_body_entered(body):
	player_in_range = true
	body.interact_UI.visible = true

# If player is in range, hide UI and don't make item pickable
func _on_area_2d_body_exited(body):
	player_in_range = false
	body.interact_UI.visible = false
		

func set_Item_data(data):
	item_Type = data["type"]
	item_Name = data["name"]
	item_Texture = data["texture"]
	item_Effect = data["effect"]
	


func _on_interactable_area_interacted(entity):
	
	pickup_Item(entity)
	
	
	
