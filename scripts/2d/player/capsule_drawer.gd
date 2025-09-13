@tool
extends Node2D

@export var radius: float = 20.0
@export var height: float = 50.0
@export var color: Color = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw():
	var rectangle_height = height - (radius * 2)
	if rectangle_height < 0:
		rectangle_height = 0
		
	draw_rect(Rect2(-radius, -rectangle_height / 2, radius * 2, rectangle_height), color)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
