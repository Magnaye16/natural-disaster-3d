extends Area2D
class_name InteractableComponent

@warning_ignore("unused_signal")
signal contacted(entity:Entity)
@warning_ignore("unused_signal")
signal exit_contacteds
signal interacted(entity:Entity)




func contact(entity:Entity):
	contacted.emit(entity)
	print("lmao")

func interact(entity:Entity):
	interacted.emit(entity)
	print("yes")
