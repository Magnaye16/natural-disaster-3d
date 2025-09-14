class_name MoveCommand extends Command


var reciever
var dir:Vector2


func _init(reciever_:MovementComponent,dir_:Vector2)->void:
	reciever = reciever_
	dir = dir_

func execute():
	reciever.set_movement_direction(dir)

