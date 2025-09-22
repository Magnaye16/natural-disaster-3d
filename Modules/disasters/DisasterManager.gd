class_name  DisasterManager
extends Node

@export var disasters: Array[Disaster] = []
@export var curr_disaster:Disaster



func try_generate_disaster(game_manager: GameManager) -> void:
	for disaster in posible_disasters(game_manager):
			disaster.trigger(game_manager)
			alert_detectors(disaster)

func alert_detectors(disaster:Disaster):
		get_tree().call_group("detector","_disaster_detected",disaster)

func posible_disasters(game_manager)->Array[Disaster]:
	return disasters.filter(func (dis:Disaster):return dis.can_trigger(game_manager))
