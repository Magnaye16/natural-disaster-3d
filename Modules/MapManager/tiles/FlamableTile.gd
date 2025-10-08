extends DynamicTile
class_name FlamableTile

var burning:bool
var health:int
var max_health:int
var resistance:int

func _init(_coords:Vector2i,_layer:TileMapLayer) -> void:
	super._init(_coords,_layer)



func init_datas():
	super.init_datas()
	set_burning(get_custom_data(BURNING,false))
	set_resistance(get_custom_data(FIRE_RESISTANCE,2))
	set_hp(get_custom_data(HEALTH,1))
	max_health = health

func set_burning(_burning:bool = true)->FlamableTile:
	burning = _burning
	return self

func set_resistance(_resistance:int)->FlamableTile:
	resistance = _resistance
	return self

func set_hp(_health:int)->FlamableTile:
	health = _health
	return self
