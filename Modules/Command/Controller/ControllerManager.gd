class_name ControllerManager
extends Node

var active_controller: BaseController = null
@export var controllers: Dictionary[String,BaseController]

func _ready() -> void:
	set_process(false)
	_cache_children()

func _cache_children():
	for child in get_children():
		if child is BaseController:
			controllers.set(child.get_script().get_global_name(),child)


	if controllers.size() > 0:
		active_controller = get_child(0)

	await  get_tree().process_frame
	set_process(true)


func set_controller_by_class(ctrl_class: GDScript) -> void:
	var ctrl = controllers.get(ctrl_class.get_global_name())
	if ctrl and ctrl is BaseController:
		active_controller = ctrl

func set_controller(ctrl: BaseController) -> void:
	active_controller = ctrl

func _process(_delta: float) -> void:
	if active_controller == null:
		set_process(false)
		return

	active_controller._process_commands()
