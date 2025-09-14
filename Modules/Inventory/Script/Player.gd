extends Entity
class_name  Player
#variables
var speed = 150
#@onready var inventory:Inventory = $Inventory
@onready var animated_Sprite = $AnimatedSprite2D
@onready var interact_UI = $InteractUI
@onready var inventoryUI:InventoryUI = $InventoryUI
@onready var invetorygridui:InventoryGridUI = $InventoryUI/ColorRect/Inventory_Grid_UI
@onready var inventory_hotbar: InventoryHotbar = $Hotbar/Inventory_hotbar



func _ready():

	var barui:HealthBar = (get_tree().get_first_node_in_group("healthbar") as HealthBar)

	barui.max_value = ($HealthComponent as HealthComponent ).max_value
	barui.value = ($HealthComponent as HealthComponent ).value


	($HealthComponent as HealthComponent ).updated.connect(
		func(val:int):
			barui.value = val
	)


	inventory = $Inventory
	invetorygridui.init()
	inventory_hotbar.init()

	print("player")

func get_Input():
	var input_Direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = input_Direction * speed

func _physics_process(delta):
	#get_Input()
	#move_and_slide()
	update_Animation()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_add"):
		$"Interactable_area-detector".interact()

	if Input.is_action_just_pressed("hit_btn"):
		($HealthComponent as HealthComponent).apply_DMG(1)

	if event.is_action_pressed("ui_inventory"):
		inventory_hotbar.visible =!inventory_hotbar.visible
		inventoryUI.visible = !inventoryUI.visible
		#get_tree().paused = !get_tree().paused

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


func _on_interactable_areadetector_interactable_contacted() -> void:
	$InteractUI.show()

func _on_interactable_areadetector_interactable_exited() -> void:
	$InteractUI.hide()
