class_name PlayerController extends BaseController
var moveCMD:MoveCommand = MoveCommand.new()

var IdleState:State = State.new("idle").set_manager(self)
var WalkingState:State = State.new("walk").set_manager(self)
var RunningState:State = State.new("Running").set_manager(self)
var RecoveringState:State = State.new("Recovering").set_manager(self)



var  playAnimationCMD:PlayAnimationCommand = PlayAnimationCommand.new()

func get_balance_comp(_player)->BalanceComponent:
	return (_player.component_manager.get_component(BalanceComponent) as BalanceComponent)

func _activate(player:Player):
	var bal_comp:BalanceComponent = get_balance_comp(player)
	if bal_comp.is_full:
		return change_state(IdleState)
	change_state(RecoveringState)


func _setup_states(_player)->State:
	setup_Idle()
	setup_walk()
	setup_run()
	set_recovering(_player)
	return IdleState


func set_recovering(_player)->void:
	RecoveringState.state_connect(
		get_balance_comp(_player).value_filled,
		change_state.bind(IdleState)
	)

	RecoveringState._enter=func(player):
		start_rec_bal_cmd.execute(player)
		moveCMD.params.direction *= 0
		moveCMD.execute(player)

func setup_run()->void:
	var speed_up:Status = Status.new()

	speed_up.setup("run",
	100,0,
	[StatusManagerComponent.STATUS_TYPES.MOVEMENT_SPEED],
	false,
	1
	)

	RunningState._process = func(player):
		player.apply_status(speed_up)
		WalkingState._process.call(player)

	RunningState._exit = func(player):
		player.remove_status(speed_up)

	RunningState._input=func(_player):
		if not Input.is_key_pressed(KEY_SHIFT):
			change_state(WalkingState)

func setup_walk()->void:
		var move_params:MoveCommand.Params = moveCMD.params

		WalkingState._input =\
		func(player):

			print("sss")

			if Input.is_key_pressed(KEY_SHIFT):
				return change_state(RunningState)
			move_params.direction = _get_movement_vector()
			moveCMD.execute(player)

		WalkingState._process =\
		func(player):
			move_params.direction = _get_movement_vector()
			moveCMD.execute(player)

			if move_params.direction == Vector2.ZERO:
				change_state(IdleState)

var start_rec_bal_cmd:StartRecoveringBalanceCommand = StartRecoveringBalanceCommand.new()

func setup_Idle()->void:

	IdleState._enter=\
	func(player):
		playAnimationCMD.params.animationName = &"Idle"
		playAnimationCMD.execute(player)

	IdleState._input=\
	func(_player:Player):
		if _get_movement_vector().length()>0 :
			return change_state(WalkingState)

	IdleState._process=\
	func (player):
		moveCMD.execute(player)

func _get_movement_vector() -> Vector2:
	return Input.get_vector(MoveDirection.MOVE_LEFT,MoveDirection.MOVE_RIGHT,MoveDirection.MOVE_UP,MoveDirection.MOVE_DOWN)
