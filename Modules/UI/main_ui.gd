extends CanvasLayer

@onready var interactable_tooltip: ColorRect = $interactableTooltip
@onready var inventory_ui: ColorRect = $InventoryUi



func _ready() -> void:
	await get_tree().process_frame
	interactable_tooltip.hide()
	var player:Player = get_tree().get_first_node_in_group("player") as Player
	player.interactable_found.connect(
		interactable_tooltip.show
	)
	player.interactable_lost.connect(
		interactable_tooltip.hide
	)
	player.inventory_requested.connect(
		func():inventory_ui.show() if not inventory_ui.visible else inventory_ui.hide()
	)
	show()
