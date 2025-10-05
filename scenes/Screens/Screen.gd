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
	Fade.fade_out(1,Color(),"Diamond")
	await get_tree().create_timer(1.1).timeout
	get_tree().change_scene_to_file("res://Main_game.tscn")
	Fade.fade_in(1,Color(),"Diamond")
