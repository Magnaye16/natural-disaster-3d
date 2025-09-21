# disaster_condition.gd
@abstract
class_name DisasterCondition
extends Resource


@abstract
func is_met(game_manager: GameManager) -> bool
