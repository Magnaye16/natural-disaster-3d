extends Resource
class_name Status

@export var Name:String
@export var status_types:Array[StatusManagerComponent.STATUS_TYPES]
@export var flat_addition:int
@export var Multiplier:float
@export var Duration:float
@export var Stackable:bool = true

var Current_duration:float

signal finished(status)
signal updated


func update_duration(delta:float):
	Current_duration += delta
	updated.emit()
	if Current_duration >= Duration:
		finished.emit(self)
		Current_duration = 0


func apply_multiplier(value:float):
	if flat_addition : return value + flat_addition
	return value * Multiplier
