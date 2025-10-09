class_name InteractableItemTile
extends InteractibleTile

var item:Item = Item.new()

const ITEM_RESOURCE = &"item_resource"

func interact(_entity:Entity):
	var inventory:Inventory =  _entity.component_manager.get_component(Inventory)
	if not inventory:
		OS.alert("No inventiry")
		return
	queue_free()
	inventory.add_Item(item)


func init_datas():
	print("iniiiiit")
	super.init_datas()
	item.set_item_resource(get_custom_data(ITEM_RESOURCE,load("res://Modules/Inventory/Resource/potion.tres")))

func set_item_resource(_item_resource:ItemResource):
	item.set_item_resource(_item_resource)
