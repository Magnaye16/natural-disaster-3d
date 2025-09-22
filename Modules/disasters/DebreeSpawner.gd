extends Node2D
class_name DebreeSpawner


const DEBREE = preload("uid://b0swruhjk24p0")

@export var amount:int = 50

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	print(collision_shape_2d.shape.get_rect().size)
	start()

func start():
	for i in range(amount):
		await  get_tree().create_timer(randf()*0.8).timeout

		var l:=collision_shape_2d.shape.get_rect().size.x/2 * randf_range(-1,1)
		var w:=collision_shape_2d.shape.get_rect().size.y/2 * randf_range(-1,1)

		spawn(Vector2( l,w))


func spawn(pos:Vector2):
	var debree:Debree = DEBREE.instantiate()
	debree.position += pos
	add_child(debree)
