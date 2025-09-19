extends Entity
class_name  Player
#variables
var speed = 150
#@onready var inventory:Inventory = $Inventory


@export var inventory : Inventory
@onready var animated_Sprite = $AnimatedSprite2D
@export var healthComponent:HealthComponent



signal interactable_found
signal interactable_lost


signal inventory_requested


#func get_Input():
	#
	#velocity = input_Direction * speed

func _physics_process(delta):
	#get_Input()
	#move_and_slide()
	update_Animation()

func _unhandled_input(event: InputEvent) -> void:


	if Input.is_action_just_pressed("hit_btn"):
		print("plapalpalpal")
		($HealthComponent as HealthComponent).apply_DMG(1)


	if event.is_action_pressed("ui_inventory"):
		inventory_requested.emit()
	
	if Input.is_key_pressed(KEY_0):
		apply_status(preload("uid://dvrca2v7avjus"))
		
	if Input.is_key_pressed(KEY_9):
		apply_status(preload("uid://dwnk6l2vu28q7"))


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


func apply_Item_effect(item):
	match item["effect"]:
		"Stamina":
			speed += 50
			print("Speed Inceased to ", speed)
		"Slot Boost":
			Global.increased_Inventory_size(5)
			print("Inventory size increase ", Global.inventory.size())


func _on_interactor_component_interactable_contacted() -> void:
	print("ff")
	interactable_found.emit()


func _on_interactor_component_interactable_exited() -> void:
	interactable_lost.emit()
