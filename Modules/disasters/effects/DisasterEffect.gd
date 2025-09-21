# disaster_effect.gd
@abstract
class_name DisasterEffect
extends Resource

var ticks:float = 100
var curr_ticks:float = 0


var game_manager:GameManager

func apply(_game_manager: GameManager):
	game_manager = _game_manager
	_enter()


@abstract
func _enter()

func _exit():pass
