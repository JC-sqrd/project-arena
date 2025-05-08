class_name SpawnableTeleportBehavior
extends SpawnableBehavior


@export var teleport_step : int = 1
@export var teleport_delay : float = 1
@export var teleport_distance : float = 100
@export var vector : Vector2
@export var teleport_on_ready : bool = false
var _step_counter : float = 0
func _ready():
	if teleport_on_ready:
		_teleport()
	apply_behavior()
	pass

func apply_behavior():
	if _step_counter < teleport_step:
		get_tree().create_timer(teleport_delay, false, true, false).timeout.connect(
			func():
			_teleport()
			apply_behavior()
		)
	pass

func _teleport():
	spawnable.global_position += spawnable.transform.x * teleport_distance
	_step_counter += 1
	pass

