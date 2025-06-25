class_name StateIndicator
extends Control


@export var icon : Texture
@export var lifetime : float = 1
@export var is_permanent : bool = false
@export_multiline var description : String 

@onready var state_indicator_icon: TextureRect = %StateIndicatorIcon
@onready var icon_texture_progress_bar: TextureProgressBar = %IconTextureProgressBar


func start_indicator_lifetime(lifetime : float, is_permanent : bool = false):
	if !is_permanent:
		var tween : Tween = create_tween()
		tween.finished.connect(_on_tween_finished)
		tween.tween_property(icon_texture_progress_bar, "value", icon_texture_progress_bar.max_value, lifetime)
	pass

func _on_tween_finished():
	queue_free()
	pass
