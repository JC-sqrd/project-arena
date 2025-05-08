class_name PlayerLevelBar
extends TextureProgressBar


var actor : Entity
var level_manager : LevelManager
@export var level_label : Label


func _ready() -> void:
	if owner is Entity:
		actor = owner
	elif owner.has_method("get_actor"):
		actor = owner.get_actor()
	actor.ready.connect(_on_actor_ready)
	level_manager = actor.level_manager
	value = 0
	max_value = level_manager.exp_to_level
	
	level_manager.exp_evaluated.connect(_level_bar_exp_gained)
	level_manager.leveled_up.connect(_level_bar_level_up)
	pass

func _on_actor_ready():
	level_label.text = str(level_manager.current_level)
	print("Current level:" + str(level_manager.current_level))
	pass

func _level_bar_exp_gained():
	#level_bar.value = lerp(level_bar.value, level_manager.current_exp, 0.1)
	var tween = create_tween()
	tween.tween_property(self, "value", level_manager.current_exp, 0.25)
	pass

func _level_bar_level_up():
	value = 0
	max_value = level_manager.exp_to_level
	print("Current level:" + str(level_manager.current_level))
	level_label.text = str(actor.stat_manager.stats["level"].stat_derived_value)
	pass
