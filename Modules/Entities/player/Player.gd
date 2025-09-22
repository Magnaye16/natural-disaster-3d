extends Entity
class_name  Player
#variables
var speed = 150

@export var inventory : Inventory
@onready var animated_Sprite = $AnimatedSprite2D
@export var healthComponent:HealthComponent


signal interactable_found
signal interactable_lost

signal inventory_requested


func _physics_process(_delta):
	update_Animation()

func _unhandled_input(event: InputEvent) -> void:


	if Input.is_action_just_pressed("hit_btn"):
		healthComponent.apply_DMG(1)


	if event.is_action_pressed("ui_inventory"):
		inventory_requested.emit()

	if Input.is_key_pressed(KEY_0):
		apply_status(preload("uid://dvrca2v7avjus"))

	if Input.is_key_pressed(KEY_9):
		apply_status(preload("uid://dwnk6l2vu28q7"))


func update_Animation():
	if velocity == Vector2.ZERO:
		animated_Sprite.set_frame_and_progress(5,1)
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


func _on_interactor_component_interactable_contacted() -> void:
	interactable_found.emit()


func _on_interactor_component_interactable_exited() -> void:
	interactable_lost.emit()
