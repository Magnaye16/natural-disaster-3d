extends Node
class_name HealthComponent

var value:int = 1
@export var max_value:int = 10
@export var natural_regen_time:float = 5
var natural_regen:int = 1
var ticks:float = 1
@export var status_multiplier:StatusContainer
const MIN_HEALTH_REGEN:int = 1

signal updated(HP)
signal depleted

func _ready() -> void:
	set_HP(max_value)

func _process(delta: float) -> void:
	if value < max_value:
		ticks += delta

	if ticks > natural_regen_time:
		if status_multiplier:
			natural_regen = status_multiplier.compute_value(natural_regen)
		natural_regen = max(MIN_HEALTH_REGEN, natural_regen)


		set_HP(value + natural_regen)
		ticks = 0



func set_HP(_value:int):
	value = _value
	updated.emit(value)

func apply_DMG(DMG:int):
	value -= DMG
	updated.emit(value)
	if value > 0 :return
	depleted.emit()
