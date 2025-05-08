extends Node


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


func pause_scene_tree():
	get_tree().paused = true
	pass

func resume_scene_tree():
	get_tree().paused = false
	pass
