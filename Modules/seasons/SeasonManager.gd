extends Node
class_name SeasonManager

@export var seasons: Array[Season] = []


signal day_advanced(day: int)
signal season_advanced(season: Season)
signal year_advanced(year: int)

var _current_season: Season:
	get = get_current_season


var starting_season_idx: int
var season_idx: int

var current_day: int = 1
var current_year: int = 1
var total_days: int = 1



func _ready() -> void:
	for season in seasons:
		season.init_posible_weathers()
	pick_starting_season(0)


func reset() -> void:
	_current_season = null
	starting_season_idx = 0

	current_day = 1
	current_year = 1
	total_days = 1

#set it then creates a getter without setter to prevent it from being changed outside
var days_in_year: int = seasons.reduce(
	func(acc, season): return acc + season.total_days
	, 0
):
	get: return days_in_year


func pick_starting_season(idx: int):
	if idx < 0 or idx >= seasons.size():
		push_error("Invalid starting season index.:%s"%[idx])
		return
	starting_season_idx = idx
	season_idx = idx
	season_advanced.emit(get_current_season())
	print("startting season set to:%s"%get_current_season().name)


func advance_day(days: int = 1):
	total_days += days
	current_day += days

	if _current_season == null:
		push_error("curr season is null")

	if current_day > _current_season.total_days:
		current_day -= _current_season.total_days
		advance_season()

	day_advanced.emit(current_day)

func advance_season():
	season_idx += 1
	season_idx = season_idx % (seasons.size())
	season_advanced.emit(get_current_season())
	#checks if this season is same as the starting season
	if season_idx == starting_season_idx and total_days > 1:
		current_year += 1
		year_advanced.emit(current_year)


func get_current_season() -> Season:
	if seasons.size() == 0:
		push_error("No seasons defined in SeasonManager.")
		return null
	return seasons[season_idx]

# Helper function to get current season name
func get_season_name() -> String:
	return _current_season.name if _current_season else "Unknown"


func season_class_from_string(season_class_name:String)->Season:
	var resource_path = "res://Modules/seasons/types/%s.gd" % season_class_name
	var season_script:Season = load(resource_path)
	if season_script:
		return season_script
	else:
		push_error("Season script not found for: %s" % season_class_name)
		return null
