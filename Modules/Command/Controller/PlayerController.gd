class_name PlayerController extends BaseController
var moveCMD:MoveCommand = MoveCommand.new()
@export var entity:Player

var states


func _process_commands()->void:
	var param:MoveCommand.Params=moveCMD.Params.new()
	param.direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	moveCMD.execute(entity,param)
