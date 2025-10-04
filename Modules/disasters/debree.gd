extends Sprite2D
class_name Debree

@export var damage:int = 1


var valid_frames:Array[int] = [17,16,41,42]

func _on_hit_component_hit(hurtbox: HurtBoxComponent) -> void:
	hurtbox.damage(damage)
@onready var main_spritr: Sprite2D = $"main spritr"

var DURATION:float = 0.5
var EASE:Tween.EaseType = Tween.EASE_IN
var TRANS:Tween.TransitionType= Tween.TRANS_EXPO


func _ready() -> void:
	frame = valid_frames.pick_random()
	animate_sprite()
	animate_shadow()

func animate_sprite():
	main_spritr.modulate.a = 0
	var tween:=create_tween().set_ease(EASE).set_trans(TRANS)
	tween.set_parallel()
	tween.tween_property(main_spritr,"modulate:a",1,DURATION/3)
	tween.tween_property(main_spritr,"position:y",-6,DURATION)
	tween.set_parallel(false)

	tween.tween_callback(func():$"main spritr/HitComponent".monitoring = true)
	tween.tween_callback(func():$"main spritr/HitComponent".monitoring = false).set_delay(0.2)
	tween.tween_property(main_spritr,"modulate:a",0,1)
	tween.tween_callback(queue_free)

func animate_shadow():
	get_material().set_shader_parameter("alpha",0.2)

	var tween:=create_tween().set_ease(EASE).set_trans(TRANS)
	tween.tween_method(set_shadow_alpha,0.2,0.7,DURATION).set_ease(EASE)
	tween.tween_method(set_shadow_alpha,0.6,0,DURATION).set_ease(EASE).set_delay(0.5)


func set_shadow_alpha(val):
	get_material().set_shader_parameter("alpha",val)
