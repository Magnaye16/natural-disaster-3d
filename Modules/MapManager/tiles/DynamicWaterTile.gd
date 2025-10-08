extends DynamicTile
class_name DynamicWaterTile

var updated:bool = false


func _init(_coords:Vector2i,_layer:TileMapLayer) -> void:
	super._init(_coords,_layer)
