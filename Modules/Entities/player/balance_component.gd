extends Node
class_name BalanceComponent


@warning_ignore_start("unused_signal")
signal value_changed(val:int)
signal value_depleted
signal value_filled

var max_value:int=50
var value:int = max_value:
	set(val):
		value = val
		value_changed.emit(value)
		if value<=0:
			value_depleted.emit()
			return
		if value>=max_value:value_filled.emit()
var recovery_amount:int = 1
var recover_timer:Timer = Timer.new()


@export var recovery_curve:Curve = Curve.new()




func _ready() -> void:
	add_child(recover_timer)

	recover_timer.wait_time = 0.3
	recover_timer.timeout.connect(recover)

	recovery_curve.clear_points()
	recovery_curve.max_value = max_value

	recovery_curve.add_point(Vector2(0.0, recovery_amount)) # 2
	@warning_ignore("integer_division")
	recovery_curve.add_point(Vector2(1.0,recovery_amount * 20))       # 100

	#recovery_curve.bake_resolution = max_value

func recover():
	var p := float(value) / float(max_value)  # 0.0 -> 1.0
	var recover_amnt = int(ceil(recovery_curve.sample(p)))
	print("recover ", recover_amnt, " at %", p)
	value += recover_amnt
	if value >= max_value:
		value = max_value
		stop_recovery()

func start_recovery()->void:
	recover_timer.start()
	recover()
	print("recovering ")

func stop_recovery():
	recover_timer.stop()
	print("stop recovering")

func reduce_balance(val:int):
	value -= val
	value = max(0,value)
	stop_recovery()

func recover_balance(val:int):
	if val < 0:
		return recover_balance(val)
	value += val
	value = min(max_value,value)
