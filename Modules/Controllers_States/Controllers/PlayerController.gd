class_name PlayerController extends BaseController



func get_balance_comp(_player)->BalanceComponent:
	return (_player.component_manager.get_component(BalanceComponent) as BalanceComponent)

func _set_initial_state()->GDScript:
	add_state(IdleState)
	add_state(RunningState)
	add_state(WalkingState)
	add_state(TrippedState)
	return IdleState


func _activate(player:Player):

	print(global_prev_state.name)

	if not global_prev_state :return
	if compare_states(global_prev_state,get_state(TrippedState)):
		get_balance_comp(player).status_multiplier.add_status(preload("uid://dltu75l766143"))
		print("tripppedddddddddddddd")
		return change_state(TrippedState)



@abstract
class PlayerState  extends State:
	var playAnimationCMD:PlayAnimationCommand = PlayAnimationCommand.new()
	var movementCMD:MoveCommand = MoveCommand.new()
	var setbalCMD:SetBalanceCommand = SetBalanceCommand.new()
	var startRecBalCMD:StartRecoveringBalanceCommand = StartRecoveringBalanceCommand.new()

	func _get_movement_vector() -> Vector2:
		var dir:Vector2 = Input.get_vector(MoveDirection.MOVE_LEFT,MoveDirection.MOVE_RIGHT,MoveDirection.MOVE_UP,MoveDirection.MOVE_DOWN)
		return dir

class RunningState extends WalkingState:

	var speed_up:Status = Status.new()

	func _init() -> void:
		speed_up.setup("run",
		0,2.2,
		[StatusManagerComponent.STATUS_TYPES.MOVEMENT_SPEED],
		false
	)

	func _get_name() -> StringName:
		return "RUN"

	func  _enter(_entity:Entity):
		playAnimationCMD.params.animationName = &"run"
		playAnimationCMD.execute(_entity)

	func _process(_player:Entity):
		_player.apply_status(speed_up)
		super._process(_player)

	func _exit(_player:Entity):
		_player.remove_status(speed_up)

	func _input(_player:Entity)->void:
		if not Input.is_key_pressed(KEY_SHIFT):
			change_state(WalkingState)

class WalkingState extends PlayerState:
	var move_params:MoveCommand.Params = movementCMD.params

	func _get_name() -> StringName:
		return "WALK"

	func  _enter(_entity:Entity):
		playAnimationCMD.params.animationName = &"walk"
		playAnimationCMD.execute(_entity)

	func _input(_player:Entity)->void:
		if Input.is_key_pressed(KEY_SHIFT):
			return change_state(RunningState)
		move_params.direction = _get_movement_vector()
		movementCMD.execute(_player)


	func _process(_player:Entity):
		move_params.direction = _get_movement_vector()
		movementCMD.execute(_player)

		if move_params.direction == Vector2.ZERO:
			change_state(IdleState)

class IdleState extends PlayerState:

	func _get_name() -> StringName:
		return &"IDLE"

	func _enter(_entity:Entity):
		playAnimationCMD.params.animationName = &"Idle"
		playAnimationCMD.execute(_entity)
		startRecBalCMD.execute(_entity)
		movementCMD.params.direction *=0

	func _input(_entity:Entity)-> void:
		if _get_movement_vector().length()>0 :
			return change_state(WalkingState)

	func _process(_player:Entity)->void:
		movementCMD.execute(_player)


class TrippedState extends PlayerState:
	func _get_name() -> StringName:
		return "TRIPPED"

	func _enter(_player:Entity)->void:
		var bal_comp:BalanceComponent = _player.component_manager.get_component(BalanceComponent)
		startRecBalCMD.execute(_player)

		if bal_comp.is_full:
			return change_state(IdleState)

		state_connect(bal_comp.value_filled,
			func():
				playAnimationCMD.params.animationName = &"recover"
				playAnimationCMD.params.on_finished = func():
					if not active:return
					change_state(IdleState)

				playAnimationCMD.execute(_player)

		)
