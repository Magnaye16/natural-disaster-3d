extends Sprite2D
class_name SpriteComponent
@onready var animated_sprite: AnimatedSprite2D = $animated_sprite

signal animation_finished
var tilemap_manager: Tilemap_manager

var flip:bool:
	set(val):animated_sprite.flip_h = val

func play(_name:StringName):
	animated_sprite.play(_name)

func get_tile_height()->int:
	var water_tiles:Dictionary = tilemap_manager.tile_groups.get(DynamicWaterTile)
	var tile_layer:TileMapLayer = tilemap_manager.water_effects_layer
	var water_tile:DynamicWaterTile = water_tiles.get(tilemap_manager.local_to_map(tile_layer,global_position))
	var height:int = 0 if not water_tile else water_tile.height
	#print(height)
	return height


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
