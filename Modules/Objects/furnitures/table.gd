extends StaticBody2D

var entity:Entity

func _on_interactable_component_interacted(_entity: Entity) -> void:
	entity = _entity
	
	var sprite:SpriteComponent =  entity.component_manager.get_component(SpriteComponent)
	sprite.play(&"cover")
	
	var dople=sprite.duplicate()
	
	add_child(dople)
	
	var scale_off:Vector2 = Vector2(4	,1)
	#entity.global_position = global_position 

	dople.global_position = global_position + scale_off
	
