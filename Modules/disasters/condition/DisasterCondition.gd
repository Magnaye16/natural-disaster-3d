# disaster_condition.gd
class_name DisasterCondition
extends Resource

enum OPERATOR{
    EQUAL,
    NOT_EQUAL,
    GREATER_THAN,
    LESS_THAN,
    GREATER_EQUAL,
    LESS_EQUAL
}

@export var operator:OPERATOR

func is_met(_context: Dictionary) -> bool:
    assert(false,"You need to implement this")
    return true
