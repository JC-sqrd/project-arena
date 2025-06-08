class_name ChanceDodgeDamage
extends Item

@export var dodge_chance : Stat


func _ready():
	item_equipped.connect(_on_item_equipeed)
	#block_chance.stat_derived_value_changed.connect(on_block_chance_changed)
	pass

func _on_item_equipeed():
	
	pass

func on_block_chance_changed():
	pass
