extends Command
class_name PlayAnimationCommand


class Params extends CommandParams:

	var animationName:StringName

var params:Params = Params.new()

func execute(entity:Node,_params:CommandParams=params)->void:
	var sprite:SpriteComponent = get_component(SpriteComponent,entity)
	if sprite:
		sprite.play(_params.animationName)
