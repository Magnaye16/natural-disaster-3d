@tool
extends Area2D
class_name InteractorComponent


signal interactable_contacted
signal interactable_exited

@export var length:int  = 10
@export var dir:Vector2=Vector2.RIGHT:
	set=set_dir

var interactable:InteractableComponent
var interactable_tile:InteractibleTile


func set_dir(_dir:Vector2):
	print(_dir)
	if _dir.length()<=0:return
	dir =_dir
	position = dir.normalized() * length


func interact():
	print("interacting   ",interactable," == ",interactable_tile)
	if interactable:
		interactable.interact(get_parent().get_parent())
		return

	if interactable_tile:
		interactable_tile.interact(get_parent().get_parent())

func look_for_tile()->Vector2:
	while not ray_cast_2d.is_colliding():
		ray_cast_2d.rotate(0.1)
	return ray_cast_2d.get_collision_point(0)

func _on_contact(_interactable:InteractableComponent):
	interactable_contacted.emit()
	interactable = _interactable
	interactable.contact(get_parent().get_parent())

func _on_exit(_interactable:InteractableComponent):
	interactable_exited.emit()
	interactable = null
@onready var ray_cast_2d: ShapeCast2D = $ShapeCast2D


func _on_body_entered(_body: Node2D) -> void:
	var map:Map = Global.get_map_manager().current_map
	var interactable_tile_manager:InteractableTileManager = map.interactable_tile_manager
	ray_cast_2d.target_position = dir.normalized() * length
	interactable_tile = interactable_tile_manager.get_interactable(ray_cast_2d.get_collision_point(0))
	interactable_contacted.emit()


func _on_body_exited(_body: Node2D) -> void:

	interactable_exited.emit()
	interactable_tile = null
