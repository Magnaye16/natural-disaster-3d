extends Disaster
class_name EarthQuake

@export_group("Aftershock_Res")
@export_range(0.0, 1.0) var aftershock_chance: float = 1.0
@export var aftershock_min_delay_seconds: float = 1.0
@export var aftershock_max_delay_seconds: float = 60.0
@export var aftershock_duration: float = 5.0
@export var aftershock_effects: Array[DisasterEffect]
@export var aftershock_exit_effects: Array[DisasterEffect]


func exit_trigger(game_manager: GameManager) -> void:
	super.exit_trigger(game_manager)
	
	# checking if greater to not trigger (less likely if 50% above)
	if randf() > aftershock_chance: return
	
	print("Aftershock incoming!")
	var aftershock_delay_timer: Timer = Timer.new()
	aftershock_delay_timer.wait_time = randf_range(aftershock_max_delay_seconds, aftershock_max_delay_seconds)
	aftershock_delay_timer.one_shot = true
	
	aftershock_delay_timer.timeout.connect(_start_aftershock.bind(game_manager))
	_free_thyself(aftershock_delay_timer)
	
	_add_and_start_timer_to_manager(game_manager, aftershock_delay_timer)
	
	
func _start_aftershock(game_manager: GameManager) -> void:
	for effect in aftershock_effects:
		effect.apply(game_manager)
	
	var aftershock_duration_timer: Timer = Timer.new()
	aftershock_duration_timer.wait_time = aftershock_duration
	aftershock_duration_timer.one_shot = true
	
	aftershock_duration_timer.timeout.connect(_super_exit_trigger_wrapper.bind(game_manager))
	_free_thyself(aftershock_duration_timer)
	
	_add_and_start_timer_to_manager(game_manager, aftershock_duration_timer)
	
	
func _super_exit_trigger_wrapper(game_manager:GameManager):
	super.exit_trigger(game_manager)
	
	
func _free_thyself(timer: Timer) -> void:
	#free the timer to avoid memory leak from stacking too many timers overtime
	timer.timeout.connect(timer.queue_free)	

func _add_and_start_timer_to_manager(game_manager: GameManager, timer: Timer) -> void:
	game_manager.add_child(timer)
	timer.start()

func _condition(_game_manager:GameManager)->bool:
	return true
