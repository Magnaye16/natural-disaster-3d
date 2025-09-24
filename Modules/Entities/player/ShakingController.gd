extends PlayerController
class_name ShakingPlayerController

var tick:= 0
var TrippedState = State.new("Tripped").set_manager(self)

##updates the tick value and checks if its timeout [br]
## automatically resets ticks on timeout
func check_and_update_tick(val:int)->bool:
	tick += 1
	var is_timeout :=  tick >= val*10
	if is_timeout:tick = 0
	return is_timeout

var bar:ProgressBar
var balance_comp:BalanceComponent

func _setup_states()->State:
	super._setup_states()
	_setup_tripped()
	return IdleState




var tripped_dmg:int = 1
var recover_bal_cmd:SetBalanceCommand = SetBalanceCommand.new()

func _setup_tripped()->void:
	const MIN_DMG:int = 0
	const MAX_DMG:int = 2
	const  recover_amnt:int = 5
	var player:Player = entity

	TrippedState.state_connect(
		moveCMD.get_component(BalanceComponent,entity).value_filled,
		change_state.bind(IdleState)
	)

	TrippedState._enter = func ():
		tripped_dmg = randi_range(MIN_DMG,
		MAX_DMG + (1 if prev_state == RunningState else 0)
		)
		player.healthComponent.apply_DMG(tripped_dmg)

	TrippedState._input= func ():
		if not Input.is_key_pressed(KEY_SPACE): return
		var recover_ :int = ((MAX_DMG + (1 if prev_state == RunningState else 0) +1)
		- tripped_dmg) * recover_amnt

		recover_bal_cmd.params.add_val = recover_
		recover_bal_cmd.execute(player)

	TrippedState._process=func ():
		moveCMD.params.direction *=0
		moveCMD.execute(player)

func _all_ready() -> void:
	entity = get_manager().manager_owner
	balance_comp = start_rec_bal_cmd.get_component(BalanceComponent,entity)
	bar = (entity as Player).progress_bar

	bar.max_value = balance_comp.value
	bar.value = balance_comp.value
	balance_comp.value_changed.connect(
		func(val):
			bar.value = val
			if bar.value / bar.max_value >= 1:
				bar.hide()
			else:
				bar.show()
	)


const RUNNING_BALANCE_COST:int = 20
const WALKING_BALANCE_COST:int = 10


func setup_walk()->void:
	super.setup_walk()

	WalkingState.state_connect(
		balance_comp.value_depleted,
		change_state.bind(TrippedState)
	)

	var old_proccess = WalkingState._process.bind()

	WalkingState._process =\
	func():
		old_proccess.call()
		if check_and_update_tick(1):
			print(balance_comp.value)
			balance_comp.reduce_balance(WALKING_BALANCE_COST)


func setup_run()->void:
	super.setup_run()
	var old_proccess = RunningState._process.bind()

	RunningState.state_connect(
		balance_comp.value_depleted,
		change_state.bind(TrippedState)
	)

	RunningState._process =\
	func():
		if check_and_update_tick(1):
			print(balance_comp.value)
			balance_comp.reduce_balance(RUNNING_BALANCE_COST)
		old_proccess.call()
