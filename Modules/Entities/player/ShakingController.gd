extends PlayerController
class_name ShakingPlayerController



func _activate(_player:Player):

	if not global_prev_state:
		change_state(IdleState)
		return

	if compare_states(get_state(TrippedState),global_prev_state):
		change_state(TrippedState)
		return

	change_state(IdleState)

func _set_initial_state()->GDScript:
	add_state(ShakingIdleState)
	add_state(ShakingWakingState)
	add_state(ShakingRunningState)
	add_state(ShakingTrippedState)
	add_state(RecoverState)
	return ShakingIdleState

class ShakingIdleState extends IdleState:
	func _enter(_player:Entity):
		startRecBalCMD.execute(_player
		)
		super._enter(_player)

class ShakingTrippedState extends TrippedState:
	const MIN_DMG:int = 0
	const MAX_DMG:int = 2
	const recover_amnt:int = 5
	var tripped_dmg:int = 1


	func _enter(_player:Entity):
		playAnimationCMD.params.animationName = &"trip"
		playAnimationCMD.execute(_player)
		manager.global_prev_state = self

		tripped_dmg = randi_range(MIN_DMG,
		MAX_DMG + (1 if manager.compare_states(manager.prev_state,manager.get_state(RunningState)) else 0)
		)
		_player.healthComponent.apply_DMG(tripped_dmg)


	func _input(_player:Entity)->void:
		if not Input.is_key_pressed(KEY_SPACE): return
		var recover_ :int = ((MAX_DMG + (1 if manager.compare_states(manager.prev_state,RunningState.new()) else 0) +1)
		- tripped_dmg) * recover_amnt

		setbalCMD.params.add_val = recover_
		setbalCMD.execute(_player)



	func _process(_player:Entity)->void:
		movementCMD.execute(_player)
		if _player.component_manager.get_component(BalanceComponent).is_full:
			return change_state(RecoverState)

class RecoverState extends PlayerState:

	func _get_name() -> StringName:
		return "RECOVER"

	func _enter(_player:Entity)->void:
		playAnimationCMD.params.animationName = &"recover"
		playAnimationCMD.params.on_finished = func():
			change_state(IdleState)

		playAnimationCMD.execute(_player)

class ShakingWakingState extends WalkingState:

	const WALKING_BALANCE_COST:int = 3

	func _enter(_player:Entity):
		setbalCMD.params.add_val = 0
		setbalCMD.execute(_player)
		super._enter(_player)

	func _get_dmg()->int:
		return WALKING_BALANCE_COST

	func _process(_player:Entity):
		if manager.check_and_update_tick(1):
			setbalCMD.params.add_val =- _get_dmg()
			setbalCMD.execute(_player)

		if setbalCMD.params.balance_comp.is_depleted:
			change_state(TrippedState)

		super._process(_player)

class ShakingRunningState extends RunningState:
	const RUNNING_BALANCE_COST:int = 10

	func _init() -> void:
		speed_up.setup("run",
		0,2.2,
		[StatusManagerComponent.STATUS_TYPES.MOVEMENT_SPEED],
		false
	)

	func _get_name() -> StringName:
		return "RUN"

	func _get_dmg()->int:
		return RUNNING_BALANCE_COST

	func _process(_player:Entity)->void:
		_player.apply_status(speed_up)
		super._process(_player)
		if manager.check_and_update_tick(1):
			setbalCMD.params.add_val =- _get_dmg()
			setbalCMD.execute(_player)

		if not _player.component_manager.get_component(BalanceComponent).is_depleted:return
		change_state(TrippedState)

	func _exit(_player:Entity):
		_player.remove_status(speed_up)

	func _input(_player:Entity)->void:
		if not Input.is_key_pressed(KEY_SHIFT):
			change_state(WalkingState)

var tick:= 0
##updates the tick value and checks if its timeout [br]
## automatically resets ticks on timeout
func check_and_update_tick(val:int)->bool:
	tick += 1
	var is_timeout :=  tick >= val*10
	if is_timeout:tick = 0
	return is_timeout
