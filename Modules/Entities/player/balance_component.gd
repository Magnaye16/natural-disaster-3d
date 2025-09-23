extends Node
class_name BalanceComponent


@warning_ignore_start("unused_signal")
signal value_changed(val:int)
var max_value:int=50
var value:int = max_value:
	set(val):
		value = val
		value_changed.emit(value)
var recovery_amount:int = 1
var recover_timer:Timer = Timer.new()
var recover_cd:Timer = Timer.new()

var RECOVER_CD:int = 2

@export var recovery_curve:Curve = Curve.new()

func _ready() -> void:
	add_child(recover_timer)
	add_child(recover_cd)

	recover_timer.wait_time = 0.1
	recover_cd.one_shot = true
	recover_timer.timeout.connect(recover)
	recover_cd.timeout.connect(func():recover_timer.start())

	recovery_curve.clear_points()
	recovery_curve.max_value = max_value

	recovery_curve.add_point(Vector2(0.0, recovery_amount)) # 2
	@warning_ignore("integer_division")
	recovery_curve.add_point(Vector2(1.0, max_value/10))       # 100


	#recovery_curve.bake_resolution = max_value

func recover():
	var p := float(value) / float(max_value)  # 0.0 -> 1.0
	var recover_amnt = int(ceil(recovery_curve.sample(p)))
	print("recover ", recover_amnt, " at %", p)
	value += recover_amnt
	if value >= max_value:
		value = max_value
		cooldown_recovery()

func cooldown_recovery():
	recover_timer.stop()
	print("stop recovering")
	recover_cd.start(RECOVER_CD)

func reduce_balance(val:int):
	value -= val
	value = max(0,value)
	cooldown_recovery()
