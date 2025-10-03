extends DynamicTile
class_name FlamableTile

var burning:bool = false
var health:int = 1
var resistance:int = 2

func set_burning(_burning:bool = true)->FlamableTile:
	burning = _burning
	return self

func set_resistance(_resistance:int)->FlamableTile:
	resistance = _resistance
	return self

func set_hp(_health:int)->FlamableTile:
	health = _health
	return self
