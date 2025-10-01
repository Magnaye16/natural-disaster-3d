extends Command
class_name PlayAnimationCommand


class Params extends CommandParams:
	var animationName:StringName

	##Set this first before calling execute
	var on_finished:Callable

var params:Params = Params.new()

func execute(entity:Node,_params:CommandParams=params)->void:
	var sprite:SpriteComponent = get_component(SpriteComponent,entity)
	if sprite:
		sprite.play(_params.animationName)
	if not params.on_finished.is_valid():return

	await sprite.animation_finished
	if not params.on_finished.is_valid():return
	params.on_finished.call()
	params.on_finished = Callable()
