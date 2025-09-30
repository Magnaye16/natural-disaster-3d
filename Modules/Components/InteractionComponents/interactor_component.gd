extends Area2D
class_name InteractorComponent


signal interactable_contacted
signal interactable_exited

var interactable:InteractableComponent

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_add"):
		interact()


func interact():
	if interactable == null : return
	interactable.interact(get_parent())

func _on_contact(_interactable:InteractableComponent):
	interactable_contacted.emit()
	interactable = _interactable

func _on_exit(_interactable:InteractableComponent):
	interactable_exited.emit()
	interactable = null
