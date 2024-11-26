extends ProgressBar


@export var fighter: Fighter

func _process(delta: float) -> void:
	value = fighter.get_health()
