class_name ControllerManager
extends Node

var active_controller: BaseController = null
@export var controllers: Dictionary[String,BaseController]
@export var manager_owner:Entity

func _ready() -> void:
	set_process(false)
	_cache_children()
	manager_owner = get_parent()

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
	set_deferred("active_controller",ctrl)


func add_controller(ctrl:BaseController)->void:
	_cache_controller(ctrl)
	add_child(ctrl)


func set_controller(ctrl: BaseController) -> void:
	add_controller(ctrl)
	set_deferred("active_controller",ctrl)


func _cache_controller(cotroller:BaseController)->void:
	controllers.set(cotroller.get_script().get_global_name(),cotroller)

func _process(_delta: float) -> void:
	await get_tree().process_frame
	if active_controller == null:
		set_process(false)
		return
	active_controller.__process()

func _unhandled_key_input(_event: InputEvent) -> void:
	if active_controller == null:return
	active_controller.__input()
