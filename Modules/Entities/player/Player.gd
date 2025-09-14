extends Entity



@onready var _controller_container : Node2D = $ControllerContainer

var _controller : EntityController


func set_controller(controller: EntityController) -> void:
	# free the children from the mines
	for child in _controller_container.get_children():
		child.queue_free()
		
	# A child must be sacrificed to the mines
	_controller = controller
	_controller_container.add_child(controller)



