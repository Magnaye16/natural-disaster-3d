class_name  DisasterManager
extends Node

@export var disasters: Array[Disaster] = []



func try_generate_disaster(context: Dictionary) -> void:
	for disaster in disasters:
		if disaster.can_trigger(context):
			disaster.trigger(context)
