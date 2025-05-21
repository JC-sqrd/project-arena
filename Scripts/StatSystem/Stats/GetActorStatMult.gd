class_name GetActorStatMult
extends Node

enum MethodName{ACTOR, STACK}

@export var stat : Stat
@export var scale_with_stat_id : String
@export var method_name : MethodName = MethodName.ACTOR
var scale_with_stat : Stat
var stat_manager : StatManager
var actor : Entity
@export var ratio : float = 1
@export var scale_base_value : bool = false

var _old_scaled_value : float = 0
var _original_base_value : float = 0

func _ready():
	owner.ready.connect(on_owner_ready)
	on_ready()
	pass

func on_owner_ready():
	if owner is Entity:
		actor = owner
	elif owner.has_method("get_actor"):
		actor = owner.get_actor()
	if actor != null:
		actor.ready.connect(on_actor_ready)
	pass

func on_actor_ready():
	if method_name == MethodName.ACTOR:
		if owner.has_method("get_actor"):
			stat_manager = owner.get_actor().stat_manager
			scale_with_stat = stat_manager.get_stat(scale_with_stat_id)
			pass
	else:
		if owner.has_method("get_stack"):
			stat_manager = owner.get_actor().stat_manager
			scale_with_stat = stat_manager.get_stat(scale_with_stat_id)
	if scale_with_stat != null:
		scale_with_stat.stat_changed.connect(apply_scaled_value)
		scale_with_stat.stat_updated.connect(apply_scaled_value)
		stat.stat_changed.connect(_update_base_value)
		_original_base_value = stat.stat_value
		apply_scaled_value()
	else:
		printerr("No stat to mult attached to  "  + stat.name)
	pass

#Apply scaling when actor had been ready
func on_ready():
	if method_name == MethodName.ACTOR:
		if owner.has_method("get_actor"):
			if owner.get_actor() != null:
				stat_manager = owner.get_actor().stat_manager
				scale_with_stat = stat_manager.get_stat(scale_with_stat_id)
				if scale_with_stat != null:
					scale_with_stat.stat_changed.connect(apply_scaled_value)
					scale_with_stat.stat_updated.connect(apply_scaled_value)
					stat.stat_changed.connect(_update_base_value)
					_original_base_value = stat.stat_value
					apply_scaled_value()
			pass
	else:
		if owner.has_method("get_stack"):
			if owner.get_actor() != null:
				stat_manager = owner.get_actor().stat_manager
				scale_with_stat = stat_manager.get_stat(scale_with_stat_id)
				if scale_with_stat != null:
					scale_with_stat.stat_changed.connect(apply_scaled_value)
					scale_with_stat.stat_updated.connect(apply_scaled_value)
					stat.stat_changed.connect(_update_base_value)
					_original_base_value = stat.stat_value
					apply_scaled_value()
	pass
	
func apply_scaled_value():
	if scale_with_stat != null:
		if scale_base_value:
			stat.emit_stat_changed_signal = false
			stat.stat_value -= _old_scaled_value
			stat.emit_stat_changed_signal = true
			var new_scaled_value = (scale_with_stat.stat_derived_value * stat.stat_value * ratio) - stat.stat_value
			stat.stat_value += new_scaled_value
			_old_scaled_value = new_scaled_value
			stat.update_stat()
		else:	
			stat.bonus_value -= _old_scaled_value
			var new_scaled_value = (scale_with_stat.stat_derived_value * stat.stat_value * ratio) - stat.stat_value
			stat.bonus_value += new_scaled_value
			_old_scaled_value = new_scaled_value
			stat.update_stat()
	else:
		printerr("No stat to mult attached to " + stat.name)
	pass

func _update_base_value():
	_original_base_value = stat.stat_value
	pass
