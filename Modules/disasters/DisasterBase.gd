@abstract
class_name Disaster
extends Resource

@export var disaster_name: String
@export var description: String
@export var chance: float = 0.1
#@export var condition: DisasterCondition
@export var effects: Array[DisasterEffect] = []


func s():
	effects = effects.filter(func (f:DisasterEffect):return not f.is_done())


func can_trigger(game_manager: GameManager) -> bool:
	if randf() > chance:
		return false
	if _condition(game_manager):
		return true
	return false

@abstract
func _condition(game_manager:GameManager)->bool

func trigger(game_manager: GameManager) -> void:
	for effect in effects:
		effect.apply(game_manager)
