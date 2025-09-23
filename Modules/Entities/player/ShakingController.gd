extends PlayerController
class_name ShakingPlayerController

var balance:BalanceComponent = BalanceComponent.new()
var tick:= 0

##updates the tick value and checks if its timeout [br]
## automatically resets ticks on timeout
func check_and_update_tick(val:int)->bool:
	tick += 1
	var is_timeout :=  tick >= val*10
	if is_timeout:tick = 0
	return is_timeout

var bar:ProgressBar

func _all_ready() -> void:
	entity = get_manager().manager_owner
	bar = (entity as Player).progress_bar
	get_manager().add_child(balance)

	bar.max_value = balance.value
	bar.value = balance.value
	balance.value_changed.connect(
		func(val):
			bar.value = val
			if bar.value / bar.max_value >= 1:
				bar.hide()
			else:
				bar.show()
	)


func setup_walk()->void:
	super.setup_walk()
	var old_proccess = WalkingState._process.bind()

	WalkingState._process =\
	func():
		old_proccess.call()
		if check_and_update_tick(1):
			print(balance.value)
			balance.reduce_balance(2)


func setup_run()->void:
	super.setup_run()
	var old_proccess = RunningState._process.bind()

	RunningState._process =\
	func():
		if check_and_update_tick(1):
			print(balance.value)
			balance.reduce_balance(10)
		old_proccess.call()
