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
	var initial_state:BaseController.State =controller._setup_states(manager_owner)
	controller.curr_state = initial_state

	assert(controller.curr_state,"_setup_states must return a current state")
	controller.curr_state._enter.call(manager_owner)

func _cache_children():
	for child in get_children():
		if child is BaseController:
			_cache_controller(child)


	if controllers.size() > 0:
		active_controller = get_child(0)

	await  get_tree().process_frame
	set_process(true)


func set_controller_by_class(ctrl_class: GDScript) -> void:
	var ctrl = controllers.get(ctrl_class.get_global_name())

	if not ctrl:
		ctrl = ctrl_class.new()
		add_controller(ctrl)
	active_controller = ctrl
	active_controller._activate(manager_owner)


func add_controller(ctrl:BaseController)->void:
	_cache_controller(ctrl)
	add_child(ctrl)
	ready_controller(active_controller)



func set_controller(ctrl: BaseController) -> void:
	add_controller(ctrl)
	set_deferred("active_controller",ctrl)


func _cache_controller(controller:BaseController)->void:
	controllers.set(controller.get_script().get_global_name(),controller)
	controller.requested_change_state.connect(
		func(new_state):
			if not controller.get_script() == active_controller.get_script():return
			change_state(new_state)
	)
	ready_controller(controller)



func change_state(new_state:BaseController.State):
	print(active_controller.get_script().get_global_name(),"  request----->",new_state.name)
	active_controller.prev_state = active_controller.curr_state
	active_controller.curr_state = new_state
	print(active_controller.prev_state.name," -> ",active_controller.curr_state.name)
	active_controller.prev_state._exit.call(manager_owner)
	active_controller.curr_state._enter.call(manager_owner)

func _process(_delta: float) -> void:
	await get_tree().process_frame
	if active_controller == null:
		set_process(false)
		return

	active_controller.__process(manager_owner)
	$"../Label".text = "%s    %s"%[active_controller.name,active_controller.curr_state.name]


func _unhandled_key_input(_event: InputEvent) -> void:
	if active_controller == null:return
	print(active_controller.curr_state.name)
	active_controller.__input(manager_owner)
