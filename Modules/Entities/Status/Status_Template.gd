extends Resource
class_name Status

@export var Name:String
@export var status_types:Array[StatusManagerComponent.STATUS_TYPES]
@export var flat_addition:int
@export var Multiplier:float
@export var Duration:float

##If true amount is stacked [br]
##if false the duration is extended
@export var Stackable:bool = true

var Current_duration:float

signal finished(status)
signal updated

func _hash():
	return hash("%s%s%f%f%f"%[Name,status_types,flat_addition,Multiplier,Duration])

func setup(_name:String,_flat_Add:int,_multiplier:float
,_stat_types:Array[StatusManagerComponent.STATUS_TYPES],
_stackable:bool=true,
_duration:float=0.3):


	Name = _name
	flat_addition = _flat_Add
	Multiplier = _multiplier
	status_types = _stat_types
	Stackable = _stackable
	Duration = _duration

func update_duration(delta:float):
	Current_duration += delta
	updated.emit()
	if Current_duration >= Duration:
		finished.emit(self)
		Current_duration = 0


func apply_multiplier(value:float):
	if flat_addition : return value + flat_addition
	return value * Multiplier
