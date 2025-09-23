extends Node
class_name StatusManagerComponent

var status_array :Array[Status]
enum STATUS_TYPES {
	MOVEMENT_SPEED,
	STAMINA,
	HEALTH_REGEN,
	HEALTH_REGEN_SPEED
}

var container:Dictionary
func _ready() -> void:
	container =  {
	STATUS_TYPES.MOVEMENT_SPEED:($MovementSpeedStatusContainer ),
	STATUS_TYPES.HEALTH_REGEN:($HealthRegenStatusContainer ),
	STATUS_TYPES.HEALTH_REGEN_SPEED:($HealthRegenSpeedStatusContainer )
}

func apply_status(status: Status) -> void:
	assert(status.status_types.size() > 0, "status empty")
	for status_type in status.status_types:
		(container.get(status_type) as StatusContainer ).add_status(status)

func remove_status(status: Status) -> void:
	assert(status.status_types.size() > 0, "status empty")
	for status_type in status.status_types:
		(container.get(status_type) as StatusContainer ).remove_status(status)
