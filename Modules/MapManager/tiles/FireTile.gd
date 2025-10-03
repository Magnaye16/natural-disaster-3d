extends FlamableTile
class_name FireTile


func _init(_coords:Vector2i,_layer:TileMapLayer) -> void:
	super._init(_coords,_layer)
	set_burning()
