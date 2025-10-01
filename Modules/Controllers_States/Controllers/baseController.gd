@abstract
class_name BaseController
extends Node

var states:Dictionary[StringName,State]
var curr_state:State
var prev_state:State
var global_prev_state:State:
	get:return (get_parent() as ControllerManager).global_prev_state

func _activate(player:Player):
	curr_state._enter(player)

func _deactivate(_player:Player):
	pass

func _all_ready()->void:
	pass


##The base class calls this and sets the curr_state to the state it returns
##[br] This function ensures that every [color=green]controller[/color] sets thier curr_state on load
@abstract
func _set_initial_state()->GDScript

func compare_states(state_a:State,state_b:State)->bool:
	return state_a.name == state_b.name

func add_state(_state:GDScript)->void:
	var new_state:State = _state.new()

	new_state.request_change_state.connect(
		func(ns:GDScript):
			if not new_state.active:return
			change_state(ns)
	)
	new_state.manager = self

	states.set(new_state.name,new_state)

func get_state(_state:GDScript)->State:
	@warning_ignore("shadowed_variable")
	var state_name:StringName = self.state_name(_state)
	assert(states.has(state_name),"%s state is not added into this controler"%state_name)
	return states.get(state_name)

##[color=yellow ]!!!!!![/color][color=red] DO NOT OVERRIDE THIS[/color][color=yellow ]!!!!!![/color]
func _get_curr_state()->State:
	var state = get_state(_set_initial_state())
	return state


signal requested_change_state
func change_state(new_state:GDScript):
	if compare_states(curr_state,get_state(new_state)):return
	_change_state(new_state)

func _change_state(new_state:GDScript):
	var state:State = get_state(new_state)
	requested_change_state.emit(state)

func change_state_re_enter(new_state:GDScript):
	_change_state(new_state)

## don't forget to call super.__process() when overriding this[br]
##calls curr_state_process
func __process(manager_owner:Node)->void:
	if not curr_state:return
	curr_state._process(manager_owner)

## don't forget to call super.__input() when overriding this[br]
##calls curr_state._input
func __input(manager_owner:Node)->void:
	if not curr_state:return
	curr_state._input(manager_owner)

static func state_name(state:GDScript)->StringName:
	return state.new().name
