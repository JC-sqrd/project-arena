class_name AbilityTree
extends ActiveAbility

@export var ability_branches : Array[AbilityBranch]
@export var head_branch : AbilityBranch
var last_branch : AbilityBranch


var tail_branch : AbilityBranch

func _ready():
	super()
	for child in get_children():
		if child is AbilityBranch:
			ability_branches.append(child)
			child.branch_ability_canceled.connect(_on_branch_ability_canceled)
	ability_branches[ability_branches.size() - 1].branch_end.connect(func(): ability_end.emit())
	pass

func invoke_ability():
	if actor.can_cast:
		head_branch.cast_ability()
		ability_casted.emit()
		ability_start.emit()
	pass

func initialize_ability():

	pass

func _on_branch_ability_canceled():
	ability_canceled.emit()
	pass
