extends Node2D
@export var season_texture: TextureRect
@export var season_label: Label
@export var day_label: Label
@export var year_label: Label
@export var weather_label: Label


@export var game_manager:GameManager

func _ready():
	game_manager.season_manager.day_advanced.connect(
		func(day): day_label.text = "%s"%day
)

	game_manager.season_manager.season_advanced.connect(
		func(season:Season):
		season_label.text = "%s"%season.name
		season_texture.texture = season.sprite
)

	game_manager.season_manager.year_advanced.connect(
		func(year): year_label.text = "%s"%year
)
	game_manager.weather_manager.weather_advanced.connect(
		func(weather):weather_label.text = weather.name
	)

	set_labels()



func advance_day():
	game_manager.advance_day()


func plus10_day() -> void:
	game_manager.advance_day()
	game_manager.advance_weather()

func set_starting_cool():
	game_manager.set_starting_season("ColdDry")


func set_starting_hot():
	game_manager.set_starting_season("HotDry")



func set_starting_rainy():
	game_manager.set_starting_season("Rainy")



func set_starting_typhoon():
	game_manager.set_starting_season("Typhoon")



func set_labels():
	if game_manager.get_current_season() == null: return

	season_texture.texture = game_manager.get_current_season().sprite
	season_label.text = "%s"%game_manager.get_current_season().name
	day_label.text = "%s"%game_manager.season_manager.current_day
	year_label.text = "%s"%game_manager.season_manager.current_year


func new_weather() -> void:
	game_manager.advance_weather()
