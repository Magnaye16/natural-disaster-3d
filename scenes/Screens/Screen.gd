extends Node2D
@onready var progress_bar: ProgressBar = $"Loading Screen/Panel/ProgressBar"
@onready var loading_screen: Node2D = $"Loading Screen"
@onready var start_screen: Node2D = $"Start Screen"
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var value: float

func  _ready() -> void:
	progress_bar.value = 0

func _process(delta: float) -> void:
	if progress_bar.value < progress_bar.max_value:
		progress_bar.value += 10 * delta
	else:
		#audio_stream_player.play()
		loading_screen.hide()
		start_screen.show()
	


func _on_button_pressed() -> void:
	audio_stream_player.stop()
	get_tree().change_scene_to_file("res://Main_game.tscn")
