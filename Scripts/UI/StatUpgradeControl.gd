class_name StatUpgradeControl
extends Control

@export var stat_to_upgrade : String
@export var add_stat : float = 10
var player_character : PlayerCharacter
var player_stats : StatManager

signal stat_upgraded()
signal stat_upgraded_with_stat()

func _ready():
	owner.ready.connect(_on_owner_ready)
	pass

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			modulate = Color.DIM_GRAY
			var stat : Stat = player_stats.get_stat(stat_to_upgrade)
			if stat != null:
				stat.stat_value += add_stat
				stat.update_stat()
				pass
			var tween : Tween = create_tween()
			tween.tween_property(self, "scale", Vector2.ONE * 1.15, 0.15)
			accept_event()
			pass
		elif !event.pressed:
			stat_upgraded.emit()
			modulate = Color.WHITE
			var tween : Tween = create_tween()
			tween.tween_property(self, "scale", Vector2.ONE, 0.1)
			#accept_event()
			pass
	pass


func _on_owner_ready():
	if owner.has_method("get_player"):
		player_character = owner.get_player() as PlayerCharacter
		player_stats = player_character.stat_manager
		pass
	pass
