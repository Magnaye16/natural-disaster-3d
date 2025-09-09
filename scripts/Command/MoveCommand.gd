class_name MoveCommand extends Command

var _character : Entity
var _direction : Vector2

func _init(character: CharacterBody2D, direction: Vector2):
	_character = character
	_direction = direction

func execute():
	if _character.has_method("set_movement_direction"):
		_character.set_movement_direction(_direction)
	
