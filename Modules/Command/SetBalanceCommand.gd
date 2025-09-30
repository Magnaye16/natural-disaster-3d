class_name SetBalanceCommand
extends Command

class Params extends CommandParams:

	##adds val to balance [br]
	## set to negative value to decrease
	var add_val:int = 0
	var balance_comp:BalanceComponent

var params:Params = Params.new()


func execute(entity:Node,param:CommandParams = params) -> void:
	var comp:BalanceComponent = get_component(BalanceComponent,entity)
	if comp:
		comp.recover_balance(param.add_val)
	params.balance_comp = comp
