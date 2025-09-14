extends Area2D
class_name InteractableComponent

signal contacted
signal exit_contacteds
signal interacted(entity)

#func contact(area:Area2D):
	#contacted.emit()
#
#func exit_contact(area:Area2D):
	#exit_contacteds.emit()

func interact(entity:Entity):
	interacted.emit(entity)
