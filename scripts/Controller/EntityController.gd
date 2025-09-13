class_name EntityController extends Node

var entity: Entity

var move_command := MoveCommand.new()

func _init(_entity: Entity) -> void:
	entity = _entity



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
