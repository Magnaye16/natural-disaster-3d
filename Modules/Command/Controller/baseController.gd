@abstract
class_name BaseController
extends Node


var curr_state:State
var prev_state:State


class State:
	@warning_ignore_start("unused_private_class_variable")
	var _enter:Callable = func():pass
	var _exit:Callable = func():pass
	var _input:Callable = func():pass
	var _process:Callable = func():pass
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


func get_manager()->ControllerManager:

	return get_parent()

func _notification(what: int) -> void:
	if what == NOTIFICATION_READY:
		await  get_tree().process_frame
		_all_ready()
		curr_state = _setup_states()
		if curr_state:curr_state._enter.call()


func _all_ready()->void:
	pass

##The base class calls this and sets the curr_state to the state it returns
func _setup_states()->State:
	return null


func change_state(new_state:State):

	prev_state = curr_state
	curr_state = new_state

	print(prev_state.name," -> ",curr_state.name)

	prev_state._exit.call()
	curr_state._enter.call()

## don't forget to call super.__process() when overriding this[br]
##calls curr_state_process
func __process()->void:
	curr_state._process.call()

## don't forget to call super.__input() when overriding this[br]
##calls curr_state._input
func __input()->void:
	curr_state._input.call()
