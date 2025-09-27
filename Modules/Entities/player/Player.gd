extends Entity
class_name  Player
@export var inventory : Inventory
@onready var animated_Sprite = $ComponentManager/SpriteComponent
@export var healthComponent:HealthComponent
@onready var movement_component: MovementComponent = $ComponentManager/MovementComponent
@export var controller_manager: ControllerManager
@onready var click_sfx: AudioStreamPlayer = $ClickSFX


signal interactable_found
signal interactable_lost

signal inventory_requested

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta):
	update_Animation()

func _unhandled_input(event: InputEvent) -> void:

	if Input.is_action_just_pressed("hit_btn"):
		healthComponent.apply_DMG(1)

	if event.is_action_pressed("ui_inventory"):
		inventory_requested.emit()
		click_sfx.play()

	if Input.is_key_pressed(KEY_0):
		apply_status(preload("uid://dvrca2v7avjus"))

	if Input.is_key_pressed(KEY_9):
		apply_status(preload("uid://dwnk6l2vu28q7"))

	if Input.is_key_pressed(KEY_8):
		apply_status(preload("uid://6xa8o7r5m1mk"))

func update_Animation():
		if velocity.x > 0:
			animated_Sprite.flip_h = false
		elif velocity.x < 0:
			animated_Sprite.flip_h = true



func _on_interactor_component_interactable_contacted() -> void:
	interactable_found.emit()


func _on_interactor_component_interactable_exited() -> void:
	interactable_lost.emit()
