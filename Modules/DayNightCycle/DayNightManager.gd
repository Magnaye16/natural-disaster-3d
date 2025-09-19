extends Node
class_name DayNightManager


@export var TICKS_PER_DAY:int = 20
@export var shader_texture:ColorRect
@export var curve:Curve

var curr_ticks:float = 1
#
#func _ready() -> void:
	#curve.max_domain = TICKS_PER_day

func _process(delta: float) -> void:
	advance(delta)

var advanced:bool = false

func advance(delta:float)->void:
	curr_ticks += delta

	if int(curr_ticks) % TICKS_PER_DAY == 0 and not advanced:
		(%GameManager as GameManager).advance_day()
		advanced =true
		curr_ticks = 0

	update_light_level()
	if curr_ticks >=1 :advanced = false

func update_light_level():
	shader_texture.get_material().set_shader_parameter("dim_strength",
	curve.sample(curr_ticks/TICKS_PER_DAY))
	#remap(curr_ticks,0,TICKS_PER_day,0,0.8))
