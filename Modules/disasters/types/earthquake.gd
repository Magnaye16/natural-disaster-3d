extends Disaster
class_name EarthQuake



@export_group("Aftershock_Res")
@export_range(0.0, 1.0) var aftershock_chance: float = 1.0
@export var aftershock_min_delay_seconds: float = 1.0
@export var aftershock_max_delay_seconds: float = 60.0
@export var aftershock_duration: float = 5.0
@export var aftershock_effects: Array[DisasterEffect]
@export var aftershock_exit_effects: Array[DisasterEffect]

func _condition(_game_manager:GameManager)->bool:
	return true
