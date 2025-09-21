class_name Entity extends CharacterBody2D



func apply_status(status: Status) -> void:
	(%StatusManager as StatusManager).apply_status(status)
