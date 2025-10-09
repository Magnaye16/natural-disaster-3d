extends Entity
class_name  Player
@export var inventory : Inventory

@onready var animated_Sprite:SpriteComponent = $ComponentManager/SpriteComponent
@export var healthComponent:HealthComponent
@onready var movement_component: MovementComponent = $ComponentManager/MovementComponent
@export var controller_manager: ControllerManager
@onready var click_sfx: AudioStreamPlayer = $ClickSFX
@onready var walking_sfx: AudioStreamPlayer = $WalkingSFX
@onready var interactor_component: InteractorComponent = $ComponentManager/interactor_component


signal interactable_found
signal interactable_lost

signal inventory_requested

func _ready() -> void:
	add_to_group("player")
	movement_component.moved.connect(interactor_component.set_dir)

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

func update_player_audio(audio_name: String):
	if audio_name == "None":
		walking_sfx.stop()
		return

	if audio_name != walking_sfx.stream.resource_name:
		walking_sfx.play()


func _on_interactor_component_interactable_contacted() -> void:
	interactable_found.emit()


func _on_interactor_component_interactable_exited() -> void:
	interactable_lost.emit()
