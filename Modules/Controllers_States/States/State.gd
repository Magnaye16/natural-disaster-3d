@abstract
class_name State
extends Resource

@warning_ignore("unused_signal")
signal request_change_state(state:State)


@warning_ignore_start("unused_private_class_variable")
var name:StringName:
	get = _get_name

var _active:bool
var active:bool:
	get:return _active
	set(val):_active = val

var manager:BaseController

func _enter(_entity:Entity)->void:pass
func _exit(_entity:Entity)->void:pass
func _input(_entity:Entity)->void:pass
func _process(_entity:Entity)->void:pass


@abstract
func _get_name() -> StringName


func state_connect(_signal:Signal,_cb:Callable):
	_signal.connect(
		func():
			if not active:return
			_cb.call()
	)


func change_state(_state:GDScript)->void:
	request_change_state.emit(_state)
