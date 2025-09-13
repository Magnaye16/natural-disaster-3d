extends Area2D
class_name InteractableAreaDetector


signal interactable_contacted
signal interactable_exited

var interacted_area:InteractableArea


func interact():
	if interacted_area == null : return
	interacted_area.interact(get_parent())
	

func _on_contact(area:Area2D):
	interactable_contacted.emit()
	interacted_area = area

func _on_exit(area:Area2D):
	interactable_exited.emit()
	interacted_area = null
