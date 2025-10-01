extends StaticBody2D

var entity:Entity

func _on_interactable_component_interacted(_entity: Entity) -> void:
	entity = _entity
	
	var sprite:SpriteComponent =  entity.component_manager.get_component(SpriteComponent)
	sprite.play(&"cover")

	entity.global_position = global_position
	
