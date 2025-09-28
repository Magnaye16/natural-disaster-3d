class_name  DisasterManager
extends Node

@export var disasters: Array[Disaster] = []
@export var curr_disasters:Array[Disaster]
var _disaster_cooldowns: Dictionary[Disaster, Timer] = {}

#func _process(_delta: float) -> void:
#	for current_disasters in curr_disasters:

func _ready() -> void:
	print("Ready DM!")
	for disaster in disasters:
		var timer : Timer = Timer.new()
		timer.one_shot = true
		_disaster_cooldowns[disaster] = timer
		add_child(timer)

func try_generate_disaster(game_manager: GameManager) -> void:
	for disaster in posible_disasters(game_manager):
		var disaster_timer : Timer = _disaster_cooldowns[disaster]
		print(disaster_timer.is_stopped())
		if !disaster_timer.is_stopped(): 
			print("In Cooldown!")
			return
		
		disaster.trigger(game_manager)
		curr_disasters.append(disaster)
		alert_detectors(disaster)
		_create_disaster_timer(disaster, game_manager)
		_start_disaster_timer(disaster)




func curr_disasters_has(disaster_type:GDScript)->bool:
	return curr_disasters.find_custom(
		func(d:Disaster):return d.disaster_name == disaster_type.get_global_name()
	) >= -1


func alert_detectors(disaster:Disaster):
		get_tree().call_group("detector","_disaster_detected",disaster)

func posible_disasters(game_manager)->Array[Disaster]:
	return disasters.filter(func (dis:Disaster):return dis.can_trigger(game_manager))

func exit_disaster(disaster: Disaster, game_manager: GameManager):
	disaster.exit_trigger(game_manager)

func _create_disaster_timer(disaster: Disaster, game_manager: GameManager):
	await get_tree().create_timer(disaster.duration).timeout
	exit_disaster(disaster, game_manager)
	
func _start_disaster_timer(disaster: Disaster) -> void:
	print(disaster.cooldown)
	_disaster_cooldowns[disaster].start(disaster.cooldown)

func trigger_random_disaster(game_manager: GameManager):
	var dis: Disaster = disasters.pick_random()
	if dis:
		try_generate_disaster(game_manager)
		_create_disaster_timer(dis, game_manager)
