extends Node
class_name DayNightManager


@export_range(1,99999,1,"hide_slider","or_greater") var ticks_per_hour:int = 1
var TICKS_PER_DAY:int:
	get:return 24 * ticks_per_hour

@export var shader_texture:ShaderTexture
@export var curve:Curve

var curr_ticks:float = 1
#
func _ready() -> void:
	@warning_ignore("integer_division")
	curr_ticks = TICKS_PER_DAY / 3

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

	var curve_y:float = curve.sample(curr_ticks/TICKS_PER_DAY)


	shader_texture.set_dim_level(curve_y)
	shader_texture.set_tint_color(curve_y)
