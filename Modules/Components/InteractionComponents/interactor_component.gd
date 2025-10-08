extends Area2D
class_name InteractorComponent


signal interactable_contacted
signal interactable_exited

var interactable:InteractableComponent


func interact():
	if interactable == null : return
	interactable.interact(get_parent().get_parent())

func _on_contact(_interactable:InteractableComponent):
	interactable_contacted.emit()
	interactable = _interactable
	interactable.contact(get_parent().get_parent())

func _on_exit(_interactable:InteractableComponent):
	interactable_exited.emit()
	interactable = null
