extends CharacterBody2D

#variables
var speed = 150


@onready var animated_Sprite = $AnimatedSprite2D
@onready var interact_UI = $InteractUI
@onready var inventoryUI = $InventoryUI

func _ready():
	Global.set_Player_reference(self)
	

func get_Input():
	var input_Direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = input_Direction * speed

func _physics_process(delta):
	get_Input()
	move_and_slide()
	update_Animation()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_add"):
		$"Interactable_area-detector".interact()
func update_Animation():
	if velocity == Vector2.ZERO:
		animated_Sprite.play("Idle")
	else:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animated_Sprite.play("walk_right")
			else:
				animated_Sprite.play("walk_left")
		else:
			if velocity.y > 0:
				animated_Sprite.play("walk_down")
			else:
				animated_Sprite.play("walk_up")

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		inventoryUI.visible = !inventoryUI.visible
		#get_tree().paused = !get_tree().paused

func apply_Item_effect(item):
	match item["effect"]:
		"Stamina":
			speed += 50
			print("Speed Inceased to ", speed)
		"Slot Boost":
			Global.increased_Inventory_size(5)
			print("Inventory size increase ", Global.inventory.size())


func _on_interactable_areadetector_interactable_contacted() -> void:
	$InteractUI.show()
	


func _on_interactable_areadetector_interactable_exited() -> void:
	$InteractUI.hide()
	
