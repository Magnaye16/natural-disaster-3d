extends EntityController




func _physics_process(_delta: float) -> void:
	var input_Direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	#MoveCommand.new(movemen_comp,input_Direction).execute()
