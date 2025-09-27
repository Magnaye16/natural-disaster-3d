extends Node2D
class_name BalanceComponent


@warning_ignore_start("unused_signal")
signal value_changed(val:int)
signal value_depleted
signal value_filled

var is_full:bool:
	get:return float(value)/float(max_value) == 1
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


@export var bar: ProgressBar
var recovery_curve:Curve = Curve.new()



func _ready() -> void:
	add_child(recover_timer)

	recover_timer.wait_time = 0.1
	recover_timer.timeout.connect(recover)

	recovery_curve.clear_points()
	recovery_curve.max_value = max_value

	recovery_curve.add_point(Vector2(0.0, recovery_amount)) # 2
	@warning_ignore("integer_division")
	recovery_curve.add_point(Vector2(1.0,recovery_amount * 10))       # 100

	bar.hide()
	bar.max_value = value
	bar.value = value
	value_changed.connect(
		func(val):
			bar.value = val
			if bar.value / bar.max_value >= 1:
				bar.hide()
			else:
				bar.show()
	)

	print(bar)

func recover():
	var p := float(value) / float(max_value)  # 0.0 -> 1.0
	var recover_amnt = int(ceil(recovery_curve.sample(p)))
	value += recover_amnt
	if value >= max_value:
		value = max_value
		stop_recovery()

func start_recovery()->void:
	if not recover_timer.is_stopped() or value>=max_value:
		return
	recover_timer.start()
	recover()

func stop_recovery():
	recover_timer.stop()

func reduce_balance(val:int):
	value -= val
	value = max(0,value)
	stop_recovery()

func recover_balance(val:int):
	if val < 0:
		return recover_balance(val)
	value += val
	value = min(max_value,value)
