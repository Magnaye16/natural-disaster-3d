extends Control
class_name HealthBar

var player:Player
@export var value:int = 7:
	set = set_val
@export var max_value:int = 8
@export var min_value:int = 0
@onready var grid_container: GridContainer = $GridContainer

func _ready() -> void:
	await  get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	if not player:return

	max_value = player.healthComponent.max_value
	set_val(player.healthComponent.value)

	player.healthComponent.updated.connect(set_val)

func set_val(val:int):
	value = val
	update()

func disable_heart(heart:TextureRect,disable:bool=true):
	heart.modulate = Color.BLACK if disable else Color.WHITE

func update():
	clear_hearts()
	display_hearts()

func clear_hearts():
	for i in range(grid_container.get_child_count()):

		var child = grid_container.get_child(i)

		if i < max_value:
			disable_heart(child)
			continue
		child.queue_free()

func display_hearts():
	for i in range(min(value,max_value)):
		var child = grid_container.get_child(i)
		disable_heart(child,false)
