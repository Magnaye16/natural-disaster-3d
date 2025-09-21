extends CanvasLayer
@onready var interactable_tooltip: ColorRect = $interactableTooltip
@onready var inventory_ui: ColorRect = $InventoryUi
@onready var game_manager: GameManager = %GameManager


func _ready() -> void:
	await get_tree().process_frame
	interactable_tooltip.hide()
	var player:Player = get_tree().get_first_node_in_group("player") as Player

	if not player:return

	player.interactable_found.connect(
		interactable_tooltip.show
	)
	player.interactable_lost.connect(
		interactable_tooltip.hide
	)
	player.inventory_requested.connect(
		func():
			@warning_ignore("standalone_ternary")
			inventory_ui.show() if not inventory_ui.visible else inventory_ui.hide()
	)

@onready var day_label: Label = $season_weather_disaster_debug_ui/PanelContainer/HBoxContainer/day
func _on_season_manager_day_advanced(day: int) -> void:
	day_label.set_text(str(day))

@onready var season_label: Label = $season_weather_disaster_debug_ui/PanelContainer/HBoxContainer/SEASON
func _on_season_manager_season_advanced(season: Season) -> void:
	await get_tree().process_frame
	season_label.set_text(season.name)

@onready var year_label: Label = $season_weather_disaster_debug_ui/PanelContainer/HBoxContainer/year
func _on_season_manager_year_advanced(year: int) -> void:
	year_label.set_text(str(year))
