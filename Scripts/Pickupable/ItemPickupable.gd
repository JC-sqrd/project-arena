class_name ItemPickupable
extends Pickupable

@export var item : PackedScene

func pickup(player : Entity):
	if player is PlayerCharacter:
		var item_object = item.instantiate()
		if item_object is Item and player.item_iventory != null:
			#player.add_child(item_object)
			#item_object.owner = player
			#item_object.actor = player
			#item_object.item_ready.emit()
			player.item_iventory.add_item(item_object)
			pass
		#var stat_mod : StatMod = StatMod.new()
		#stat_mod.stat_to_modify = "move_speed"
		##stat_mod.mod_value = 900
		#var stat_value : float = player.stat_manager.stats[stat_mod.stat_to_modify].stat_value
		#stat_mod.mod_value = stat_value * 2
		#player.stat_mods.add_child(stat_mod)
		#player.stat_mods.apply_mod_to_stat(player.stat_manager.stats[stat_mod.stat_to_modify], stat_mod)
		#get_tree().create_timer(5, false, true, false).timeout.connect(
			#func():
				#player.stat_mods.remove_mod_from_stat(player.stat_manager.stats[stat_mod.stat_to_modify], stat_mod)
		#)
		pass
	picked_up.emit()
	queue_free()
	pass
