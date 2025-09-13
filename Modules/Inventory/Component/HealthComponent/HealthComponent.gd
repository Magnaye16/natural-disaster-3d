extends Node
class_name HealthComponent

var value:int = 5
@export var max_value:int = 10

signal updated(HP)
signal depleted

func _ready() -> void:
	set_HP(max_value)
	
func set_HP(_value:int):
	value = _value 
	updated.emit(value)

func apply_DMG(DMG:int):
	value -= DMG
	updated.emit(value)
	if value > 0 :return
	depleted.emit()
