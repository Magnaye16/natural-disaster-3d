extends Node2D
@export var season_texture: TextureRect
@export var season_label: Label
@export var day_label: Label
@export var year_label: Label
@export var weather_label: Label


var game_manager:GameManager = GameManager.new()


func _ready():
	Season_manager.day_advanced.connect(
		func(day): day_label.text = "%s"%day
)

	Season_manager.season_advanced.connect(
		func(season:Season):
		season_label.text = "%s"%season.name
		season_texture.texture = season.sprite
)

	Season_manager.year_advanced.connect(
		func(year): year_label.text = "%s"%year
)
	game_manager.weather_manager.weather_advanced.connect(
		func(weather):weather_label.text = weather.name
	)

	set_labels()



func advance_day():
	game_manager.advance_day()
	game_manager.advance_weather()

func plus10_day() -> void:
	game_manager.advance_day()
	game_manager.advance_weather()

func set_starting_cool():
	Season_manager.reset()
	Season_manager.pick_starting_season(0)
	game_manager.advance_weather()


func set_starting_hot():
	Season_manager.reset()
	Season_manager.pick_starting_season(1)
	game_manager.advance_weather()


func set_starting_rainy():
	Season_manager.reset()
	Season_manager.pick_starting_season(2)
	game_manager.advance_weather()


func set_starting_typhoon():
	Season_manager.reset()
	Season_manager.pick_starting_season(3)
	game_manager.advance_weather()


func set_labels():
	if Season_manager.get_current_season() == null: return

	season_texture.texture = Season_manager.get_current_season().sprite
	season_label.text = "%s"%Season_manager.get_current_season().name
	day_label.text = "%s"%Season_manager.current_day
	year_label.text = "%s"%Season_manager.current_year


func new_weather() -> void:
	game_manager.advance_weather()
