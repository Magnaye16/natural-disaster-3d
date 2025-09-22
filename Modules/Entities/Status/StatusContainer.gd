extends Node
class_name StatusContainer

var status_array :Array[Status] 





func compute_value(value:float):
	var product_value:float = value

	for stat in status_array:
			product_value = stat.apply_multiplier(product_value)
			print("Product f", product_value)
	return product_value


#func compute_val_same_val_stacked(value:float):
	#
	#var product_value:float = value
	#
	#for stat in status_array:
			#product_value = stat.apply_multiplier(product_value)
			#print("Product f", product_value)
	#
	#return product_value


func remove_status(status:Status):
	status_array.remove_at(status_array.find(status))
	pass

func stack_status(status:Status)->void:
	var idx:int = status_array.find(status)

	if idx > -2:
		var existing_stat = status_array.get(idx)
		existing_stat.Duration += status.Duration
		return

	check_stackable_status(status)

func check_stackable_status(status:Status):
	if !status.Stackable:
		var index = status_array.find_custom(func(s):return s.Name == status.Name)
		if index < 0:
			add_status(status)
		else:
			status_array.get(index).Duration += status.Duration
		
	
func add_status(status:Status):
	if (status.flat_addition !=0):
		status_array.insert(0,status)
	else:
		status_array.append(status)
	print("status",status_array)

	status.finished.connect(remove_status)

func update_statuses_duration(delta:float):
	for status in status_array:
		status.update_duration(delta)
	#print("status",status_array)

func _process(delta: float) -> void:
	update_statuses_duration(delta)
