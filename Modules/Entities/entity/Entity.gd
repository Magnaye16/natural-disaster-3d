class_name Entity extends CharacterBody2D



func set_movement_direction(_direction: Vector2) -> void:
	pass


func apply_status(status: Status) -> void:
	(%StatusManager as StatusManager).apply_status(status)
