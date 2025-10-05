extends Sprite2D
class_name SpriteComponent
@onready var animated_sprite: AnimatedSprite2D = $animated_sprite

signal animation_finished
var Tile_manager: Tilemap_manager


var flip:bool:
	set(val):animated_sprite.flip_h = val

func play(_name:StringName):
	animated_sprite.play(_name)


func get_tile_height()->int:
	if Tile_manager == null:return 0
	var tile_height = Tile_manager.get_tile_data(&"height")
	if tile_height == null:
		tile_height = 0# fall back to default
	return tile_height



func update(x_dir:float):
		if x_dir > 0:
			flip = false
		elif x_dir < 0:
			flip = true
		update_height()

func update_height()->void:
	var height=get_tile_height()
	clip(height)
	animated_sprite.offset.y = height*2 +1
	offset.y = -height

func clip(_height:int = 0)->void:
	if _height <=0:
		clip_children = CanvasItem.CLIP_CHILDREN_DISABLED
		self_modulate.a = 0
		return
	clip_children = CanvasItem.CLIP_CHILDREN_ONLY
	self_modulate.a = 1




func _on_animated_sprite_animation_finished() -> void:
	animation_finished.emit()
