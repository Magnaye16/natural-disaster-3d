extends CanvasGroup
class_name InteractableTileManager

@export var interactable_tilelayer:TileMapLayer

var _interactable_tiles:Dictionary[Vector2i, InteractibleTile]

func _cash_tiles()->void:
	for cell:Vector2i in interactable_tilelayer.get_used_cells():
		var tile:InteractableItemTile = InteractableItemTile.new(cell,interactable_tilelayer)
		_interactable_tiles.set(cell,tile)
		tile.init_datas()
	print(_interactable_tiles)


func get_interactable(coords:Vector2i)->InteractibleTile:

	var item:InteractibleTile = _interactable_tiles.get(interactable_tilelayer.local_to_map(interactable_tilelayer.to_local(coords)))

	#print((item as InteractableItemTile).item.item_Name)

	return item
