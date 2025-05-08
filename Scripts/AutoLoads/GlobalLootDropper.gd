extends Node


var loot_scenes : Dictionary[String,PackedScene] = {
	"common_dropper" : preload("res://Scenes/Pickupables/common_item_picker_pickup.tscn"),
	"rare_dropper" : preload("res://Scenes/Pickupables/rare_item_picker_pickup.tscn")
}

static var common_dropper_weight : float = 10
static var rare_dropper_weight : float = 5
static var empty_weight : float = 60

var common_dropper : Dropper = Dropper.new(common_dropper_weight, 10,preload("res://Scenes/Pickupables/common_item_picker_pickup.tscn"))
var rare_dropper : Dropper = Dropper.new(rare_dropper_weight, 10,preload("res://Scenes/Pickupables/rare_item_picker_pickup.tscn"))
var empty_dropper : Dropper = Dropper.new(empty_weight, 10, null)

var droppers : Array[Dropper] = [common_dropper, rare_dropper, empty_dropper]

var weights : Array[float] = [rare_dropper.weight, common_dropper.weight, empty_dropper.weight]
var total_weight : float = 0

func _ready() -> void:
	EnemiesGlobal.enemy_died.connect(on_enemy_died)
	for dropper in droppers:
		total_weight += dropper.weight

func on_enemy_died(enemy : Enemy):
	drop_loot(enemy.global_position)
	pass

func drop_loot(drop_position : Vector2):
	var random : float = randf_range(0, total_weight)
	var cursor : float = 0
	for dropper in droppers:
		cursor += dropper.calculate_scaled_weight()
		if cursor >= random:
			if dropper.loot != null:
				var loot_obj = dropper.loot.instantiate()
				loot_obj.global_position = drop_position
				get_tree().root.add_child(loot_obj)
			return
	pass

class Dropper:
	var weight : float = 0
	var drop_rate_factor : float = 10
	var loot : PackedScene
	
	func calculate_scaled_weight() -> float:
		var scaled_weight = max(0.01, weight / (1 + min(50,EnemiesGlobal.get_enemies().size()) / drop_rate_factor))
		return scaled_weight
	
	func _init(weight : float, drop_rate_factor : float,loot : PackedScene) -> void:
		self.weight = weight
		self.drop_rate_factor = drop_rate_factor
		self.loot = loot
	pass
