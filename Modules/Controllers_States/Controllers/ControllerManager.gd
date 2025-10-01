class_name ControllerManager
extends Node

var active_controller: BaseController = null
@export var controllers: Dictionary[String,BaseController]
var manager_owner:Entity

func _ready() -> void:
	set_process(false)
	manager_owner = get_parent()
	_cache_children()


func ready_controller(controller:BaseController)->void:
	controller._all_ready()
	var initial_state:State =  controller._get_curr_state()
	controller.curr_state = initial_state
	initial_state.active = true
	assert(controller.curr_state,"_setup_states must return a current state")
	controller.curr_state._enter(manager_owner)

func _cache_children():
	for child in get_children():
		if child is BaseController:
			_cache_controller(child)


	if controllers.size() > 0:
		active_controller = get_child(0)
		active_controller._activate(manager_owner)

	await  get_tree().process_frame
	set_process(true)


func set_controller_by_class(ctrl_class: GDScript) -> void:
	var ctrl = controllers.get(ctrl_class.get_global_name())

	if not ctrl:
		ctrl = ctrl_class.new()
		add_controller(ctrl)

	var old_state:State = active_controller.curr_state
	global_prev_state = old_state
	print("set contrler by class  == ",global_prev_state.name)

	#active_controller.curr_state = null
	active_controller._deactivate(manager_owner)
	active_controller = ctrl
	active_controller._activate(manager_owner)


func add_controller(ctrl:BaseController)->void:
	_cache_controller(ctrl)
	add_child(ctrl)
	ready_controller(active_controller)


func _cache_controller(controller:BaseController)->void:
	controllers.set(controller.get_script().get_global_name(),controller)
	controller.requested_change_state.connect(
		func(new_state):
			if not controller.get_script() == active_controller.get_script():return
			change_state(new_state)
	)
	ready_controller(controller)



var global_prev_state:State
func change_state(new_state:State):

	var old_state:State = active_controller.curr_state
	active_controller.prev_state = old_state
	active_controller.curr_state = new_state
	old_state.active = false
	new_state.active = true

	old_state._exit(manager_owner)
	new_state._enter(manager_owner)

func _process(_delta: float) -> void:
	if active_controller == null:
		return
	active_controller.__process(manager_owner)
	$"../Label".text = "%s    %s"%[active_controller.name,active_controller.curr_state.name]


func _unhandled_key_input(_event: InputEvent) -> void:
	if active_controller == null:return
	active_controller.__input(manager_owner)
