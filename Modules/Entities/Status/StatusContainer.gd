extends Node
class_name StatusContainer

var status_array :Array[Status]





func compute_value(value:float):
	var product_value:float = value

	for stat in status_array:
			product_value = stat.apply_multiplier(product_value)
			#print("Product f", product_value)
	return product_value


func remove_status(status:Status):
	status_array = status_array.filter(
		func(s:Status):
			return s.Name != status.Name
	)


func add_status(status:Status):

	status = status.duplicate()

	if !status.Stackable:
		var index = status_array.find_custom(func(s):
			return s.Name == status.Name)

		if index < 0:
			_add_status(status)
		else:
			status_array.get(index).Duration += status.Duration
		return
	_add_status(status)



func _add_status(status:Status):
	if (status.flat_addition !=0):
		status_array.insert(0,status)
	else:
		status_array.append(status)
	status.finished.connect(remove_status)






func update_statuses_duration(delta:float):
	for status in status_array:
		status.update_duration(delta)
	#print("status",status_array)

func _process(delta: float) -> void:
	update_statuses_duration(delta)
