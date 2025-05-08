class_name AreaHitOverTime
extends AreaHit

@export var hit_speed : Stat 

@onready var hit_timer : Timer = Timer.new()

var hit_per_second : float

func _ready():
	if actor_stats.stats.has("area_size"):
		area_size_mult = actor_stats.stats["area_size"].stat_derived_value
	self.scale *= area_size_mult
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	hit_per_second = 1 / hit_speed.stat_derived_value
	hit_timer.wait_time = hit_per_second
	windup_start.emit()
	area_hit()
	get_tree().create_timer(windup_time, false, false, false).timeout.connect(
		func():
			windup_end.emit()
			_on_timer_timeout()
			_start_lifetime()
	)
	pass

func area_hit():
	if entities_in_area.size() != 0:
		for entity in entities_in_area:
			if filter.is_valid(self, entity, entities_in_area):
				#on_hit.emit(_create_hit_data(entity))
				var data : Dictionary = _create_hit_data(entity)
				entity.on_hit.emit(data)
				on_hit.emit(data)
				if hit_listener != null:
					hit_listener.on_hit(data)
	pass

func _start_lifetime():
	hit_timer.timeout.connect(area_hit)
	hit_timer.autostart = true
	add_child(hit_timer)
	pass

func _on_body_entered(body : Node2D):
	entities_in_area.append(body)
	hit_body(body)
	#if filter.is_valid(self, body, actor, entities_in_area):
	#	entities_in_area.append(body)
	#	hit_body(body)
	#	pass
	#if body != null and body.is_in_group("Hittable") and body != actor:
		#if !entities_in_area.has(body):
			#entities_in_area.append(body)
			#hit_body(body)
	pass

func hit_body(target : Entity):
	if filter.is_valid(self, target, entities_in_area):
		var data : Dictionary = _create_hit_data(target)
		target.on_hit.emit(data)
		on_hit.emit(data)
		if hit_listener != null:
			hit_listener.on_hit(data)
