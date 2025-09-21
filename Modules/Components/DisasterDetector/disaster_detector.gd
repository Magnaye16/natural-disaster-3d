extends Node
class_name DisasterDetector


signal disaster_detected(disaster:Disaster)

func _ready() -> void:
	add_to_group("disaster_detector")


func _disaster_detected(disater:Disaster):
	disaster_detected.emit(disater)
