extends Control
@onready var progress_bar: ProgressBar = $loading/ProgressBar
@onready var loading_screen: Panel =$loading
@onready var start_screen: Panel = $start
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var value: float

func  _ready() -> void:
	progress_bar.value = 0


func _process(delta: float) -> void:
	if progress_bar.value < progress_bar.max_value:
		progress_bar.value += 100 * delta
	else:
		#audio_stream_player.play()
		loading_screen.hide()
		start_screen.show()

func _on_button_pressed() -> void:
	$start/Button.hide()
	$AnimationPlayer.play("start")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Main_game.tscn")
