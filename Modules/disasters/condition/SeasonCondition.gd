class_name SeasonCondition
extends DisasterCondition


@export var season:Season 



func is_met(_context: Dictionary) -> bool:

	match operator:
		OPERATOR.EQUAL:
			return Season_manager.get_current_season() == season

		OPERATOR.NOT_EQUAL:
			return Season_manager.get_current_season() != season

		_:
			push_error("INVALID OPERATOR %s"%OPERATOR.keys()[operator])
			return false
