extends Area2D
class_name InteractableComponent

@warning_ignore("unused_signal")
signal contacted
@warning_ignore("unused_signal")
signal exit_contacteds
signal interacted(entity:Entity)



func interact(entity:Entity):
	interacted.emit(entity)
