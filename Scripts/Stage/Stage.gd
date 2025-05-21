class_name Stage
extends Node2D


@export var player : PlayerCharacter

signal game_over(stage : Stage)

func _ready() -> void:
	player = Globals.player
	player.died.connect(on_player_died)
	pass


func on_player_died():
	#get_tree().change_scene_to_file("res://Scenes/Test/test_scene.tscn")
	#player.queue_free()
	game_over.emit(self)
	PauseManager.pause_scene_tree()
	await get_tree().create_timer(0.5, true, true, false).timeout
	pass


func _on_wave_1_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.
