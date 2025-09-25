class_name PlayerController extends BaseController



var moveCMD:MoveCommand = MoveCommand.new()
@export var entity:Player

func _process_commands()->void:

	var param:MoveCommand.Params=moveCMD.Params.new()

	param.direction = Input.get_vector(MoveDirection.MOVE_LEFT, MoveDirection.MOVE_RIGHT, 
	MoveDirection.MOVE_UP, MoveDirection.MOVE_DOWN)

	moveCMD.execute(entity,param)
