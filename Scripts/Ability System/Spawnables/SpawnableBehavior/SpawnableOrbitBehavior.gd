class_name SpawnableOrbitBehavior
extends SpawnableBehavior


var orbit_distance : float = 0
@export var angular_speed : float = 90
var angle : float = 0
var angular_speed_rad : float = 0
var center : Node2D
var actor : Entity

var _motion : Vector2

func _ready():
	super()
	center = spawnable.actor as Node2D
	#actor = spawnable.actor
	var offset : Vector2 = spawnable.global_position - center.global_position
	orbit_distance = offset.length()
	angle = atan2(offset.y, offset.x)
	angular_speed_rad = deg_to_rad(angular_speed)


func _physics_process(delta: float) -> void:
	angle += angular_speed_rad * delta
	_motion = Vector2(center.global_position.x + orbit_distance * cos(angle), center.global_position.y + orbit_distance * sin(angle))
	#_motion = Vector2((0 - spawnable.position.x) + spawnable.position.x * cos(angle), (0 - spawnable.position.y) + spawnable.position.y * sin(angle))
	spawnable.global_position = _motion #* delta
	pass


func _process(delta: float) -> void:
	
	pass
