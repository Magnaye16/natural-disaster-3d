extends Command
class_name StopRecoveringBalanceCommand

##It has no param to set
class Params extends CommandParams:
	pass

##this params is used as default in execute when there is no param passed[br]
##so you can set this before calling execute
var params:Params = Params.new()

func execute(entity:Node,_param:CommandParams = params) -> void:
	var comp:BalanceComponent = get_component(BalanceComponent,entity)
	if comp:
		comp.cooldown_recovery()
