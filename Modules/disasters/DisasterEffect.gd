# disaster_effect.gd
class_name DisasterEffect
extends Resource

var ticks:float = 100
var curr_ticks:float = 0

signal done


func apply(game_manager: GameManager) -> Signal:
	curr_ticks = 0
	return done


func _apply():
	if is_done():return



func _applied(game_manager: GameManager) -> void:
	pass

func _deactivate():
	pass

func is_done()->bool:
	return curr_ticks >= ticks
