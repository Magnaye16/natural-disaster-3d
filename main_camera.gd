extends Camera2D
class_name GlobalCamera

@export var follow_speed: float = 5.0

var target: Player


func _ready() -> void:
	await get_tree().process_frame
	target = get_tree().get_first_node_in_group("player")


var _shake_offset: Vector2 = Vector2.ZERO
func _process(delta: float) -> void:
	if not is_instance_valid(Player):return
	var base_pos  = global_position.lerp(target.global_position, follow_speed * delta)
	global_position = base_pos + _shake_offset


var _shake_tween: Tween

func shake(intensity: float = 2.0, duration: float = 1.0, frequency: float = 50.0) -> void:
	if _shake_tween and _shake_tween.is_running():
		_shake_tween.kill()

	_shake_tween = create_tween()
	_shake_tween.set_trans(Tween.TRANS_SINE)
	_shake_tween.set_ease(Tween.EASE_IN_OUT)

	var step = duration / frequency
	for i in range(int(frequency)):
		@warning_ignore("shadowed_variable_base_class")
		var offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
	)
		_shake_tween.tween_property(self, "_shake_offset", offset, step)

	# Reset shake back to zero
	_shake_tween.tween_property(self, "_shake_offset", Vector2.ZERO, step)
