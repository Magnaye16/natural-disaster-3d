@abstract
class_name BaseController
extends Node


var curr_state:State
var prev_state:State


class State:
	@warning_ignore_start("unused_private_class_variable")
	var _enter:Callable = func(_entity):pass
	var _exit:Callable = func(_entity):pass
	var _input:Callable = func(_entity):pass
	var _process:Callable = func(_entity):pass
	var name:String
	var active:bool:
		get():return manager.curr_state == self
	var manager:BaseController

	func _init(_name:String="") -> void:
		name = _name

	func set_manager(_manager:BaseController)->State:
		manager = _manager
		return self

	func state_connect(_signal:Signal,_cb:Callable):
		_signal.connect(
			func():
				if not active:return
				_cb.call()
		)

func _activate(player:Player):
	curr_state._enter.call(player)

func _all_ready()->void:
	pass

##The base class calls this and sets the curr_state to the state it returns
func _setup_states(_entity)->State:
	return null


signal requested_change_state
func change_state(new_state:State):
	requested_change_state.emit(new_state)

## don't forget to call super.__process() when overriding this[br]
##calls curr_state_process
func __process(manager_owner:Node)->void:
	if not curr_state:return
	curr_state._process.call(manager_owner)

## don't forget to call super.__input() when overriding this[br]
##calls curr_state._input
func __input(manager_owner:Node)->void:
	if not curr_state:return
	curr_state._input.call(manager_owner)
