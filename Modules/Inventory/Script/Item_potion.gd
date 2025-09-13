extends ItemResource
class_name PotionItemResource


func _init() -> void:
	print("intit potion")
	super.init(1,"Consumable","apple",preload("res://src/Item_icon/icon1.png"),"Heal")
