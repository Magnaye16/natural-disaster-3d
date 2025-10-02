extends StaticBody2D



func _on_interactable_component_interacted(entity: Entity) -> void:
	entity.queue_free()
