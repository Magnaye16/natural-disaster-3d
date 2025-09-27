extends PlayerController
class_name ShakingPlayerController

var tick:= 0

const RUNNING_BALANCE_COST:int = 10
const WALKING_BALANCE_COST:int = 3

##updates the tick value and checks if its timeout [br]
## automatically resets ticks on timeout
func check_and_update_tick(val:int)->bool:
	tick += 1
	var is_timeout :=  tick >= val*10
	if is_timeout:tick = 0
	return is_timeout
var balance_comp:BalanceComponent






func _setup_states(player:Player)->State:
	balance_comp = player.component_manager.get_component(BalanceComponent)
	super._setup_states(player)
	_setup_tripped(player)
	return IdleState


#
#
#func _setup_tripped(player)->void:
	#const MIN_DMG:int = 0
	#const MAX_DMG:int = 2
	#const recover_amnt:int = 5
#
#
	#TrippedState.state_connect(
		#moveCMD.get_component(BalanceComponent,player).value_filled,
		#change_state.bind(IdleState)
	#)
#
	#TrippedState._enter = func (_player:Player):
		#if _player.component_manager.get_component(BalanceComponent).is_full:
			#return change_state(IdleState)
		#playAnimationCMD.params.animationName = &"tripped"
		#playAnimationCMD.execute(_player)
		#tripped_dmg = randi_range(MIN_DMG,
		#MAX_DMG + (1 if prev_state == RunningState else 0)
		#)
		#_player.healthComponent.apply_DMG(tripped_dmg)
#
	#TrippedState._input= func (_player):
		#if not Input.is_key_pressed(KEY_SPACE): return
		#var recover_ :int = ((MAX_DMG + (1 if prev_state == RunningState else 0) +1)
		#- tripped_dmg) * recover_amnt
#
		#set_bal_CMD.params.add_val = recover_
		#set_bal_CMD.execute(_player)
#
	#TrippedState._process=func (_player):
		#moveCMD.params.direction *=0
		#moveCMD.execute(_player)
#


func setup_Idle()->void:
	super.setup_Idle()

	var old_proces =IdleState._enter.bind()

	IdleState._enter=\
	func(player):
		old_proces.call(player)
		start_rec_bal_cmd.execute(player)

func setup_walk()->void:
	super.setup_walk()
	WalkingState.state_connect(
		balance_comp.value_depleted,
		change_state.bind(TrippedState)
	)
	var old_proccess = WalkingState._process.bind()

	WalkingState._process =\
	func(_player):
		old_proccess.call(_player)
		if check_and_update_tick(1):
			balance_comp.reduce_balance(WALKING_BALANCE_COST)

func setup_run()->void:
	super.setup_run()
	var old_proccess = RunningState._process.bind()

	RunningState.state_connect(
		balance_comp.value_depleted,
		change_state.bind(TrippedState)
	)

	RunningState._process =\
	func(_player):
		if check_and_update_tick(1):
			print(balance_comp.value)
			balance_comp.reduce_balance(RUNNING_BALANCE_COST)
		old_proccess.call(_player)
