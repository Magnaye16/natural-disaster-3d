class_name PlayerController extends BaseController
var moveCMD:MoveCommand = MoveCommand.new()
@onready var animate_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var IdleState:State = State.new("idle")
var WalkingState:State = State.new("walk")
var RunningState:State = State.new("Running")
@onready var entity:Entity



func _all_ready() -> void:
	entity=get_manager().manager_owner


func _setup_states()->State:
	var move_params:MoveCommand.Params = moveCMD.Params.new()
	moveCMD.params = move_params

	setup_Idle()
	setup_walk()
	setup_run()

	return IdleState

func setup_run()->void:
	var speed_up:Status = Status.new()

	speed_up.setup("run",
	100,0,
	[StatusManagerComponent.STATUS_TYPES.MOVEMENT_SPEED],
	false,
	1
	)

	RunningState._process = func():
		entity.apply_status(speed_up)
		WalkingState._process.call()

	RunningState._exit = func():
		entity.remove_status(speed_up)

	RunningState._input=func():
		if not Input.is_key_pressed(KEY_SHIFT):
			change_state(WalkingState)


func setup_walk()->void:
		var move_params:MoveCommand.Params = moveCMD.params

		WalkingState._input =\
		func():
			if Input.is_key_pressed(KEY_SHIFT):
				return change_state(RunningState)
			move_params.direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
			moveCMD.execute(entity)

		WalkingState._process=\
			func():
				move_params.direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
				moveCMD.execute(entity)

				if move_params.direction == Vector2.ZERO:
					change_state(IdleState)

func setup_Idle()->void:

	IdleState._input=\
	func():
		if Input.get_vector("ui_left","ui_right","ui_up","ui_down").length()>0:
			return change_state(WalkingState)

	IdleState._process=\
	func ():
		moveCMD.execute(entity)
