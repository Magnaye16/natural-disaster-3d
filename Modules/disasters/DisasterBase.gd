# disaster.gd
class_name Disaster
extends Resource

@export var disaster_name: String
@export var description: String
@export var chance: float = 0.1
@export var conditions: Array[DisasterCondition] = []
@export var effects: Array[DisasterEffect] = []

func can_trigger(context: Dictionary) -> bool:
    if randf() > chance:
        return false
    
    for condition in conditions:
        if not condition.is_met(context):
            return false
    
    return true

func trigger(context: Dictionary) -> void:
    for effect in effects:
        effect.apply(context)


