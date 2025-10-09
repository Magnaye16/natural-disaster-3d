@tool
extends InteractableComponent
class_name Interactable_door



var marker:Marker2D:
	set(val):
		marker = val
		update_configuration_warnings()

var spawn_position:Vector2:
	get:return global_position if not marker else marker.global_position


@export var map:Map
@export var need_interaction:bool
@export var location:StringName:
	set(val):
		location = val
		update_configuration_warnings()


func _ready() -> void:
	update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []


	var regex = RegEx.new()

	regex.compile("DOOR_[A-Z]$")

	if not regex.search(name):
		warnings.append("NAME MUST BE IN THIS FORMAT ex:  DOOR_A")

	if not map:
		warnings.append("map is not set")

	if not marker:warnings.append("needs A MARKER 2D child to serve as a spawn location")

	regex.compile("^[A-Z]+:[A-Z]$")  # Only one capital letter after ':'


	if not location:warnings.append("There is no location set")
	elif not regex.search(location):
		warnings.append("not correct format  ===   ex: HOUSE:A")

	return warnings

func _on_child_entered_tree(_node: Node) -> void:
	if _node is Marker2D:marker = _node

func _on_child_exiting_tree(_node: Node) -> void:
	if _node is Marker2D:marker = null


func _on_interacted(_entity: Entity) -> void:
	map.process_mode = Node.PROCESS_MODE_DISABLED
	await Fade.fade_out(.6,Color.BLACK,"DIAMOND").finished
	map.go_to(location)


func _on_contacted(entity:Entity) -> void:
	if not need_interaction:_on_interacted(entity)
