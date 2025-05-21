class_name ChainSpawnable
extends AreaHit


@export var chain_area : Area2D
@export var chain_area_coll_shape : CollisionShape2D
@export var near_entities : Array[Entity]
@export var chain_count : int = 1
var current_host : Entity


func _ready():
	chain_area.body_entered.connect(_on_chain_body_entered)
	chain_area.body_exited.connect(_on_chain_body_exited)
	super()
	pass

func _process(delta: float) -> void:
	if current_host != null:
		global_position = current_host.global_position
	pass

func _on_chain_body_entered(body : Node2D):
	if body != null and body.is_in_group("Hittable") and body != actor:
		if body as Entity != current_host:
			near_entities.append(body)
		pass
	pass

func _on_chain_body_exited(body : Node2D):
	if near_entities.has(body):
		near_entities.erase(body)
	pass

func _on_timer_timeout():
	get_tree().create_timer(0.1, false, false, false).timeout.connect(
	func (): 
		if chain_count > 0:
			if near_entities != null and near_entities.size() > 0:
				var nearest_entity = near_entities[0]
				near_entities.erase(nearest_entity)
				#reparent(nearest_entity, false)
				current_host = nearest_entity
				global_position = current_host.global_position
				chain_count -= 1
				chain_area_coll_shape.disabled = true
				chain_area_coll_shape.disabled = false
				get_tree().create_timer(windup_time, false, false, false).timeout.connect(_on_windup_end)
			else:
				on_destroy.emit()
				queue_free()
				pass
			pass
		else:
			on_destroy.emit()
			queue_free()
		)
	pass
