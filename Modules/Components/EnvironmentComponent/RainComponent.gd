extends Marker2D


@export var camera:GlobalCamera:
	set(val):
		if is_instance_valid(val):
			set_process(true)
		else:
			set_process(false)
		camera = val
@onready var rain: GPUParticles2D = $rain

func _ready() -> void:
	camera=camera

func enable():
	rain.set_emitting(true)


func disable():
	rain.set_emitting(false)

##
#sfa
##
func intensity(val:int):
	rain.amount_ratio = val

func _process(_delta: float) -> void:
	global_position = camera.global_position
