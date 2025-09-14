class_name Disaster
extends Resource

@export var disaster_name: String
@export var description: String
@export var chance: float = 0.1
@export var conditions: Array[DisasterCondition] = []
@export var effects: Array[DisasterEffect] = []


func s():
	effects = effects.filter(func (f:DisasterEffect):return not f.is_done())


func can_trigger(game_manager: GameManager) -> bool:
	if randf() > chance:
		return false

	for condition in conditions:
		if not condition.is_met(game_manager):
			return false

	return true

func trigger(game_manager: GameManager) -> void:
	for effect in effects:
		effect.apply(game_manager)
